# Useful Bash shell scripts

## tg_upgrade.sh

Download Terragrunt binary file and replace/create symbolic links to the binary.

This script will create a directory tree in your home directory to hold [Terragrunt](https://terragrunt.gruntwork.io/)
binary file and also a symbolic link in `/usr/local/bin` to the latest version installed using this script.

Running this script periodically will help to keep your Terragrunt binary file up to date.

**Note:** keep in mind the script requires you to install WGET command before run it.

## Author and Lincense

This script has been written by [Ariel Jall](https://github.com/ArielJalil) and it is released under
 [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
