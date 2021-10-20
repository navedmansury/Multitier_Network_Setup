# Anonymous Voting App

This is a React-native and NodeJs App for carrying out elections in the college.
<p align="center">
<img src="https://github.com/himanshu1510/Multitier_Network_Setup/blob/main/Images/1_9lEP5_-xZ-PqXglMIxNGeA.png" alt="alt text">
</p>

#### So here are the steps for proper understanding
- In that VPC we have to create 2 subnets:
   - public  subnet [ Accessible for Public World! ] 
   - private subnet [ Restricted for Public World! ]
- Create a public facing internet gateway for connect our VPC/Network to the internet world and attach this gateway to our VPC.

- Create  a routing table for Internet gateway so that instance can connect to outside world, update and associate it with public subnet.

- Create a NAT gateway for connect our VPC/Network to the internet world  and attach this gateway to our VPC in the public network

- Update the routing table of the private subnet, so that to access the internet it uses the nat gateway created in the public subnet

- Launch an ec2 instance which has Wordpress setup already having the security group allowing  port 80 sothat our client can connect to our wordpress site. Also attach the key to instance for further login into it.

- Launch an ec2 instance which has MYSQL setup already with security group allowing  port 3306 in private subnet so that our wordpress vm can connect with the same. Also attach the key with the same.

<p align="center">
  <img src="https://github.com/himanshu1510/Multitier_Network_Setup/blob/main/Images/vpc.png">
 </p>
___

## Below are the steps how you can successfully execute my code:

Step 1: Configure your aws profile with below cmd

  `aws configure --profile user1` 


Step 2. Create variable.tf file that includes all the variables using in entire setup

Step 3: Now below will be steps for code completion. If you are not interested then you may skip to Step 4.

For providing provider info

```
provider "aws"{

  profile = "user1"

  region = var.aws_region
}
```

<img src="https://github.com/himanshu1510/Multitier_Network_Setup/blob/main/Images/aws_conf.PNG">

Step 4. For creating new key and key pair for ssh login

```
provider "tls" {}
resource "tls_private_key" "t" {
    algorithm = "RSA"
}
resource "aws_key_pair" "test" {
    key_name   = "task1-key"
    public_key = "${tls_private_key.t.public_key_openssh}"
}
provider "local" {}

resource "local_file" "key" {
    content  = "${tls_private_key.t.private_key_pem}"
    filename = "task1-key.pem"
       
}
```
Step 5.  vpc.tf file include setup of public and private subnet in a vpc. Public facing internet gateway for connect our VPC/Network to the internet world and attach this gateway to our VPC. Routing table for Internet gateway so that instance can connect to outside world, update and associate it with public subnet

Step 6. natgateway.tf includes NAT gateway for connect our VPC/Network to the internet world  and attach this gateway to our VPC in the public network and update the routing table of the private subnet, so that to access the internet it uses the nat gateway created in the public subnet

Step 7. Now we can launch our webserver in the public subnet and the database server in the private subnet. main.tf launch public instance with webserver configured and private key attested.

The remote-exec provisioner invokes a script on a remote resource after it is created. It setup the webserver on the public instance

```

provisioner "remote-exec" {

    inline = [
    
      "sudo yum install httpd php git -y",
      
      "sudo systemctl start httpd",
      
      "sudo amazon-linux-extras install php7.3 -y",
      
      "sudo wget https://wordpress.org/latest.tar.gz",
      
      "sudo tar -zxf latest.tar.gz",
      
      "sudo cp -r wordpress/* /var/www/html/",
      
      "sudo chmod -R 755 wp-content",
      
      "sudo wget https://s3.amazonaws.com/bucketforwordpresslab-donotdelete/htaccess.txt",
      
      " sudo mv htaccess.txt /var/www/html/.htaccess",
      
      "sudo systemctl restart httpd",
      
      "sudo systemctl enable httpd",
      
    ]
    
  }
  
  ```
  
Step 8. database.tf configured firewall for database sderver and setup the database server in the private subnet 


#### That’s it for coding part. Now execution part resumes

Go inside directory where your terraform files are present and run

#### Initialize a working directory containing Terraform configuration files

`terraform init`

<img src="https://github.com/himanshu1510/Multitier_Network_Setup/blob/main/Images/terraform_initialise.PNG">

> It will install all the necessary plugins for your code.

#### terraform plan command creates an execution plan

`terraform plan`

#### The terraform apply command executes the actions proposed in a Terraform plan.

`terraform apply  --auto-approve`

> It will take some time to complete and then after it will do all the thing for you. You can verify from your AWS console also .


#### The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.

`terraform destroy --auto-approve`



