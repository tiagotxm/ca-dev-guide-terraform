
variable "instance_size" {
  description = "Size of the EC2 instance"
  type        = string
  default     = "t2.micro"
}
variable "servername" {
  description = "Name of the EC2 Instance tag"
  type        = string
  default     = "cloudacademylabs"
}
