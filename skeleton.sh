#!/bin/bash

echo "Creating Terraform + App skeleton at repository root..."

# App layer
mkdir -p app/lambda/{order_creation,payment_validation,fulfillment_processing}

touch app/lambda/order_creation/{handler.py,requirements.txt}
touch app/lambda/payment_validation/{handler.py,requirements.txt}
touch app/lambda/fulfillment_processing/{handler.py,requirements.txt}

# Infra modules
mkdir -p infra/modules/{api_gateway,lambda,dynamodb,sqs,sns,step_functions,iam,cloudwatch}

for module in api_gateway lambda dynamodb sqs sns step_functions iam cloudwatch
do
  touch infra/modules/$module/{main.tf,variables.tf,outputs.tf}
done

# Infra environments
mkdir -p infra/env/{dev,prod}

for env in dev prod
do
  touch infra/env/$env/{main.tf,variables.tf,terraform.tfvars,backend.tf,providers.tf}
done

# Root files
touch README.md
touch .gitignore

echo "✅ Skeleton created successfully."
