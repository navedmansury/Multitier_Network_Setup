# VPC with public and private subnets (NAT)

<img src="https://user-images.githubusercontent.com/64575592/119870204-b6c25a00-bf3e-11eb-895e-adf00ba27928.png">

## Statement: We have to create a web portal for our company with all the security as much as possible.
So, we use Wordpress software with dedicated database server.
Database should not be accessible from the outside world for security purposes.
We only need to public the WordPress to clients.
So here are the steps for proper understanding

- In that VPC we have to create 2 subnets:
   - public  subnet [ Accessible for Public World! ] 
   -  private subnet [ Restricted for Public World! ]

- Create a public facing internet gateway for connect our VPC/Network to the internet world and attach this gateway to our VPC.
- Create  a routing table for Internet gateway so that instance can connect to outside world, update and associate it with public subnet.
- Create a NAT gateway for connect our VPC/Network to the internet world  and attach this gateway to our VPC in the public network
- Update the routing table of the private subnet, so that to access the internet it uses the nat gateway created in the public subnet
- Launch an ec2 instance which has Wordpress setup already having the security group allowing  port 80 sothat our client can connect to our wordpress site. Also attach the key to instance for further login into it.
- Launch an ec2 instance which has MYSQL setup already with security group allowing  port 3306 in private subnet so that our wordpress vm can connect with the same. Also attach the key with the same.
<img src="https://user-images.githubusercontent.com/64575592/120079152-40556180-c0d0-11eb-944e-57167a6d5bad.png">

#### _Wordpress instance has to be part of public subnet so that our client can connect our site.mysql instance has to be part of private  subnet so that outside world can't connect to it._

#### Initialize a working directory containing Terraform configuration files
`terraform init`

#### terraform plan command creates an execution plan
`terraform plan`

#### The terraform apply command executes the actions proposed in a Terraform plan.
`terraform apply  --auto-approve`

#### The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.
`terraform destroy --auto-approve`



