# Systemiphus Infra Repo
Infra as code stack for the systemiphus stack.
* Terraform for provisioning
* Ansible AWX for config management
* Jenkins for CI/CD environment
* FUTURE: Graylog(?) for logging and monitoring.

## Mission
Terraform will bring up each individual host as they are defined in the respective terraform files in `./terraform/`.

Terraform provisioners may come into scope in future, but for now the infra and config repos are de coupled.

Ideally, a combination of terraform tags and good ansible inventory writing will mean once the entire picture is understood, diagrammed and documented the following chain of events will kick of:
* Commit infra changes to this repo.
* CI/CD runs the terraform command
* CI/CD commits the updated terraform state to source
* AWX picks up inventory from the dynamic script
* Existing jobs run, new jobs can be set up against the inventory.

Thus config management is managed from a CI/CD perspective.

## Usage

### Terraform
Systemiphus leverages Terraform's excellent infrastructure as code capabilities to manage the setup and changes over time using git and git-crypt for storing secrets.

#### Terraform Notes
 * We can use input variables
 * Output variables
 * provisioners
 * variables are available in list, map and string (not sure how to use lists)

#### Installation of Stack
1) Install Terraform - https://www.terraform.io/
    * Get the binary here: https://www.terraform.io/downloads.html
    * Put the terraform binary on the PATH
        * `$ cp $terraform_binary /usr/local/bin`
    * Verify the install
        * `$ terraform`
2) Run Terraform
    * Initialise terraform if not already initialised
        * `$ terraform init`
        * NOTE: Need to have installed the ansible provider for this to run without errors. See below.
    * Unencrypt the tfstate file with git-crypt
        * `$ git-crypt unlock`
    * Apply the new config
        * `$ terraform apply -var-file="secrets.tfvars"`
    * Check the applied config
        * `$ terraform show -var-file="secrets.tfvars"`
    * TAKE CARE - Remove all infrastructure if required
        * `$ terraform destroy -var-file="secrets.tfvars"

### Managing the gap between Terraform and Ansible
[This article](http://nicholasbering.ca/tools/2018/01/08/introducing-terraform-provider-ansible/) has been a great find on this topic. It outlines the issue with operationally managing the gap between provisioning a guest with terraform, versus managing the config in ansible. Trying to use dynamic inventories by itself means you tie very closely the ansible config with the provider.

From an ansible perspective, I don't care what is hosting the guest, what the private IP is, it should just be pointed at the host I care about. ie - at some point I need an MMPL production webserver. I don't care what is fulfilling that role from day to day.

From a terraform perspective, I don't care what config is on a host, I just care that it's there.

The apporach outlined in this article essentially has you tie the created terraform resource to an ansible resource, and that's that.

#### Installing the packages
We need two packages to complete the integration.
* [The Ansible Provider](https://github.com/nbering/terraform-provider-ansible/)
    * This needs to be installed on the host running the terraform command.
    * Go [here](https://github.com/nbering/terraform-provider-ansible/releases/tag/v0.0.4) for the most recent release. For OSX, get the "darwin" release.
    * Place the binary at `~/.terraform.d/plugins/terraform-provider-ansible_vX.X.X`
    * Run `terraform init` to verify from the base dir of this project to verify the install. This should show that the ansible provider is installed.
* [The Dynamic Imnventory](https://github.com/nbering/terraform-inventory/)
    * This needs to be installed wherever we are running ansible commands. Ultimately this should be on the ansible AWX host.


### Storing Secrets
We will be storing terraform state (very sensitive!) in the git repo, this certain files and directories need to be encrypted.
The git-crypt project seems to have a fairly user friendly approach to encrypting files, and determines which files to encrypt based on the contents of the .gitattributes file. This means that git diffs use the private keys (when unlocked) to compare the contents and diff locally properly.

#### Setup
1) Install GPG - https://gnupg.org/download/
`$ brew install gpg`
2) Create GPG key - https://aplawrence.com/Basics/gpg.html
`$ gpg --full-generate-key`
3) Setup git-crypt - https://www.agwa.name/projects/git-crypt/
    * Install the package with brew
    `$ brew install git-crypt`
    * Init git-crypt
    `$ git-crypt init`
    * Add GPG user
    `$ git-crypt add-gpg-user USER_ID` ( USER_ID provided during key generation )

#### Usage
Define the files to be encrypted using the .gitattributes file. Uses the same format as .gitignore with filter and diff flags
```
# .gitattributes
secretfile filter=git-crypt diff=git-crypt
*.key filter=git-crypt diff=git-crypt
```
    * Unlock the secrets for editing
    `$ git-crypt unlock`
    * Encrypt again when done
    `$ git-crypt lock`
    * Either way data will be encrypted in repo as long as it is identified in .gitattributes

### Structure
We will manage each disticnt element of the stack in it's own file, for separation of concerns.
From my understanding, terraform interpolates all these files and you can reuse variables across all the files that have a .tf extension.

* vpc.tf
    * Manages the VPCs for the solution. This will stay at a single VPC until we have a good reason to split out to more than one.
* subnets.tf
    * This will manage the various subnets within the single VPC. The subnets will have varying levels of access depending on their content.
    * May need to split this out to multiple files based on VPC name. Might make more sense than putting logically separated subnets in one file for the sake of a clean file structure.
* security_groups.tf
    * Will manage the security access of various things based on principle of least access.
    * SHouldn't be a problem keeping these all together, but we will see depending on how reusable security groups are.
* ansible.tf
    * Still tentative, but this file will define the host inventory for ansible managed guests.
    * Likely that this can pass terraform managed secrets like db password up to ansible for management.
    * Until we have more hosts than we can manage, a single file should suffice.