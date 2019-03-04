# Amazon Web Services Featuring Spinnaker on EKS

This Guide Deploy Spinnaker on EKS with some AWS specific IaaS integrations for other AWS services

## Limitations

The following are known limitations

- Testing occured in the first few regions that recieved EKS initially
- Solution assumes 3 AZ(s)

## Let's Get Started

These steps already assume that you can use the AWS CLI from your workstation and can run commands aginst your AWS account with the AWS CLI.

### Additional Installation

Normally, the only tools you will need on your computer will be terraform, git, and IaaS tools (here the AWS CLI). However, for authentication with EKS from your workstation you will also need the `aws-iam-authenticator`. You can read about the installation process [here]().

If you are on a mac you can download it here
`curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/darwin/amd64/aws-iam-authenticator`

make sure you make it executable
`chmod +x aws-iam-authenticator`

`sudo mv aws-iam-authenticator /somewhere/in/your/path.`




### Advanced Set-up
TBD,  uses DNS/TLS/Oauth2

### Set-up Terraform

To configure terraform, we will:
- Use AWS Native IaaS mark-up terraform to configure and AWS Account for terraform
- Validate that terraform can modify said AWS account

#### Deploy Cloudformation

While logged in as a user that can manipulate AWS IAM with CloudFormation, you will apply the cloudformation template located [here](./cloudformation/iam.yml). 

The cloudformation template will create an IAM user for Terraform and an IAM role for terraform. 

On the output tab you should see and entry for
- AccessKey
- SecretAccessKey
- TerraformRole

Terraform will use these values to manipulate your aws account


#### Validate you setup




## Finally You are ready to begin





## Accessing the Environment
Assuming that you have 

### Kubectl

This solution did download a version of kubectl to your machine. It is located in the terraform folder. In your shell in the terraform folder

`./kubectl --kubeconfig=generated-kube.conf get pods --namespace spinnaker`

This command will list all the pods that spinnaker deployed. The ready colum in the output should have 1/N for all services. 

This 

### Observability


### Access Spinnaker


### Adding Jenkins


### Advanced Access



## Destroy everything

If you run `terraform destory` after use of this environment you may find that some items can't be destroyed. These will ussually be
- S3 buckets created
- Network

The leading cause for S3 buckets is that terraform does not delete buckets with contents. The Bucket for Spinnaker will have connect

Regarding network, this most often occurs after deploying apps to K8 that will create addition network resources in the VPC. 

Regardless, you have to manuallly remove items using the AWS Console/CLI and then run `terraform destory`