variable "aws_region" {
    default     = "ap-south-1"
}

variable "private_subnet_cidr" {
  type        = list
  default     = ["10.2.1.0/24" , "10.2.3.0/24"]
}
variable "azs" {
  type        = list
  default     =  ["ap-south-1a","ap-south-1b"]
}
variable "private_subnet_name" {
  type        = list
  default     = ["private1","private2"]
}


output "o1" {
  value       = aws_subnet.public_Subnet.id 
}
