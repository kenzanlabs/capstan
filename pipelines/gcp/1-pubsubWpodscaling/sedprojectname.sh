#!/usr/bin/env bash

###################
# Sed insert the Google Project Name
###################

PROJECT_NAME=$(gcloud info --format='value(config.project)')
cp dev-pipeline.sed.json dev-pipeline.json

echo "Adding $PROJECT_NAME to pipeline"

sed -i "s/XXXXXXXXXXXX/$PROJECT_NAME/g" dev-pipeline.json

echo "Hopefully complete"