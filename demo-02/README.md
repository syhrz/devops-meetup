# demo-02

This demo is intended to get more practices in Terraform code style.
```
.
|-ansible -- Store ansible playbooks and roles.
|-modules -- Store main modules.
|-myapp   -- An example stack.
|-scripts -- Store additional scripts that needed.
```

Before you create the stack You will need to bake the AMI.
```
cd myapp
packer build -var service_version=<service_version> main.json
```

Then use the ami output to provision.
```
cd myapp/stg
terraform init
terraform apply -var ami_id=ami-abcxyz
``
