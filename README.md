# smartconsole-ext
Framework for hosting Smart Console Extensions

This playbook will install Nginx aand configure basic SSL. This downloads a repository from Github and hosts the Smart Console Extensions.

This example was tested using  the example [Smart Console Extensions](https://github.com/CheckPointSW/smart-console-extensions) 

NSGs are created that only allow access to the host on port 443 and port 22. Also, it is defined to allow only one IP address to connect.

## Prerequisites

Terraform

Azure CLI (If running Terraform on premise)

## Usage:

Clone the repository

```hcl
git clone https://github.com/metalstormbass/smartconsole-ext.git
```

Ensure that you have Azure CLI installed. Once installed run the following command in Powershell.

```hcl
az login
```

Configure the variables. The majority of the variables are for Azure settings (VNETs, subnets, names, etc). Two important variables to consider are:

```hcl
#This variable is the repository that will be cloned and hosted on the webserver. Tested using the Check Point provided examples.
github-address = https://github.com/CheckPointSW/smart-console-extensions.git

#This IP is the only IP address that you will be able to access the new VM from. This would typically be a WAN IP Address
allowed-IP
```

Run the following commands in Terraform:

```hcl
terraform init
```

then:

```hcl
terraform apply
```

Finally, wait until Terraform has completed. Then wait an addtional 5-10 mins for the VM to complete bootstrapping.

Finally, in order to connect the Smart Console extention: 
    1. Go to Manage & Settings within Smart Console
    2. Select Preferences and scroll down to Smart Console Extensions
    3. Add the extension URL. By default, it will be something like:

```hcl
https://x.x.x.x/smart-console-extensions/yourextension.json
```

For the example extension use the following path:

```hcl
https://x.x.x.x/smart-console-extensions/examples/hello-world/extension.json
```

or

```hcl
https://x.x.x.x/smart-console-extensions/examples/show-gateways-interfaces/extension.json
```

To destroy, you need to run:

```hcl
terraform destroy
```

## Issues:

At this point, sometimes you need to run the destroy  command several (~3) times for the environment to be completely removed. This appears to be a bug in the dependency handling within Terraform.