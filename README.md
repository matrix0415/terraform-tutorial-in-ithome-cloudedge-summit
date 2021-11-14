# terraform-tutorial-in-ithome-cloudedge-summit
Terraform tutorial in ITHome Taiwan Cloud Edge Summit 2021

https://cloudsummit.ithome.com.tw/2021/workshop-page/301



## Requirements

| Name | Version |
|------|---------|
| terraform | \>= 0.13 |
| aws provider | \>= 3.20 |




## Steps
1. Copy sample files to the root folder. 
   * Ex1: cp 1_terraform_introduce/1_start_an_ec2_instance/main.tf ./
   * Ex2: cp 3_environment_consistency/* ./
   * Ex3: cp -r 5_module/1_local/* ./
2. Fill in the required values (with `TODO` comment).
   * Ex: public_key
3. Execute terraform command.
   * terraform plan -out .plan
   * terraform apply .plan
4. Have fun ^^