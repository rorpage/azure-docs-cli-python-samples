#/bin/bash

# Variables
resourceGroupName="myResourceGroup$RANDOM"
appName="webappwithredis$RANDOM"
storageName="webappredis$RANDOM"
location="westeurope"

# Create a Resource Group 
az group create --name $resourceGroupName --location $location

# Create an App Service Plan
az appservice plan create --name WebAppWithRedisPlan --resource-group $resourceGroupName --location $location

# Create a Web App
az webapp create --name $appName --plan WebAppWithRedisPlan --resource-group $resourceGroupName 

# Create a Redis Cache
redis=($(az redis create --name $appName --resource-group $resourceGroupName --location $location --vm-size C0 --sku Basic --query [hostName,sslPort,accessKeys.primaryKey] --output tsv))

# Assign the connection string to an App Setting in the Web App
az webapp config appsettings set --settings "REDIS_URL=${redis[0]}" "REDIS_PORT=${redis[1]}" "REDIS_KEY=${redis[2]}" --name $appName --resource-group $resourceGroupName