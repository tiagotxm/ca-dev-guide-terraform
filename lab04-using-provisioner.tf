/**
  Provisioners can help on additional steps when creating or deleting terraform resources.
  However it's comes a cost to use it when thinking about project complexity e.g network or software dependencies
  The examples below as just for ilustration. The best practice should be using CI/CD tools for deploy the image
*/ 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7"
    }
  }
}
provider "aws" {
  region = "us-west-2"
}

/* empty resource that will run a series of command on the local endpoint runnint terraform
    Its a good practice to isolate them in a specific block instead, like

    resource "null_resource" "image" {
    provisioner "local-exec" {
        command = <<EOF
        $(aws ecr get-login --region us-west-2 --no-include-email)
        docker pull hello-world:latest
        docker tag hello-world:latest ${aws_ecr_repository.ecr.repository_url}
        docker push ${aws_ecr_repository.ecr.repository_url}:latest
    EOF
  }
}
*/
resource "aws_ecr_repository" "ecr" {
  name = "catest"
  provisioner "local-exec" {
    when = destroy # will be called on terraform destroy command
    command = <<EOF
    $(aws ecr get-login --region us-west-2 --no-include-email)
    docker pull ${self.repository_url}:latest
    docker save --output catest.tar ${self.repository_url}:latest 
    EOF
  }
}

#Import Container Image to Elastic Container Registry
resource "null_resource" "image" {
  provisioner "local-exec" {
    command = <<EOF
       $(aws ecr get-login --region us-west-2 --no-include-email)
       docker pull hello-world:latest
       docker tag hello-world:latest ${aws_ecr_repository.ecr.repository_url}
       docker push ${aws_ecr_repository.ecr.repository_url}:latest
   EOF
  }
}