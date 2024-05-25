As Terraform projects start to grow, it's important to organize infrastructure components into separate Terraform state files. This greatly reduces the blast radius for changes made to the infrastructure. This strategy is a popular concept within the Terraform community and is also referred to as "Terraservices." The infrastructure that frequently changes like EC2, ECS, or EKS services should stay separate from infrastructure that rarely changes, like VPC configurations. Also, sensitive services like RDS should have their state file. You don't want to be resizing an EC2 instance in the same Terraform configuration that contains code for the MYSQL database. Splitting up components can become very hard to manage with Terraform alone, which is why Terragrunt becomes an important tool when managing infrastructure that has been split up into Terraservices.


# deploy everything. Run just at the first time
terragrunt run-all apply

# deploy after made some adjust
terragrunt apply