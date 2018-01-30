# demo-01

There are some ways to provision infrastructure. This demo is intended to get
the tastes of each tools.

# How to Use
## Ansible
```
ansible-playbook start-ec2.yml

```

## Cloudformation
```
aws cloudformation create-stack --stack-name myteststack --template-body main.cf
```

## Terraform

```
terraform init
terraform apply
```
