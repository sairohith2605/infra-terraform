## Infrastructure Automation with Terraform

Terraform helps manage infrastructure on cloud providers like AWS, Azure via code. It helps meet the paradigm of Infrastructure as Code (IaC). 

### Installation

This section guides you on installing various prerequisites and Terraform itself.

It is suggested to enable WSL (v2) with Ubuntu distribution if you're working on a Windows machine to efficiently run the Terraform commands without any hassle.

#### Installing WSL2

- The official reference to install WSL2 from Microsoft can be found here - https://learn.microsoft.com/en-us/windows/wsl/install. 
- For a manual installation this reference should help - https://learn.microsoft.com/en-us/windows/wsl/install-manual

#### Installing AWS CLI

It is mandatory that we install AWS CLI before running any automation with Terraform, since Terraform uses the CLI under the hood to deloy any infrastructure. 

Installation source for AWS CLI V2 - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

#### Terraform CLI Via Tfenv

An optimal way of installing Terraform is via tfenv. It helps maintain and switch versions of Terraform CLI on our local machine. 
Installation instructions of `tfenv` can be found at their home repository - https://github.com/tfutils/tfenv.

#### Terraform CLI Via Official Documentation

If you would not like to you `tfenv`, you may follow the official documentation of Terraform to install - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli. 

### Setting Up the Codebase

Before you get started running infrastructure provisioning via the codebase in this repository, there are a few things to run as a preliminary setup. 

#### Create a Configuration File

The configuration file provides inputs to the Terraform variables defined within the codebase.
Add a new directory called config and add a file `demo.tfvars` inside it.

#### Defining the Terraform Backend

##### Configuring Amazon S3 for Backend

The `terraform.tf` contains the backend configuration configuration for an S3 bucket to persist the state. Follow the below instructions to setup the backend

- Run init with the backend flag for S3:

  ```shell
  terraform init backend-config="bucket=<name_of_bucket>"
  ```

##### Local State Persistence

If you do not want to use an S3 backend, and instead use the local directory for state, then comment out the contents in `terraform.tf` file. You can run the `terraform init` command without include `backend-config`.
