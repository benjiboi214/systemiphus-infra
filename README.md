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
    `$ terraform init`
    * Unencrypt the tfstate file with git-crypt
    `$ git-crypt unlock`
    * Apply the new config
    `$ terraform apply -var-file="secrets.tfvars"`
    * Check the applied config
    `$ terraform show -var-file="secrets.tfvars"`
    * TAKE CARE - Remove all infrastructure if required
    `$ terraform destroy -var-file="secrets.tfvars"`

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
