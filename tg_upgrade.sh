#!/bin/bash
#
# Download Terragrunt binary file and replace/create symbolic links to the binary.
#
# Requisites:
# - WGET command installed
#
# Arguments are only required if an specific Terragrunt version is required, otherwhise none are
# required to deploy latest version available.
#
# $1 = Version
# $2 = Release
#
# i.e. Pass specific Version and Release to deploy:
# $ tg_upgrade.sh 42 5
#
# i.e. If no version and release are passed as arguments the script will download the latest
# available version:
#
# $ tg_upgrade.sh
#

# Terragrunt URL's:
TG_RELEASES_URL="https://github.com/gruntwork-io/terragrunt/releases"
TG_DOWNLOAD_URL="${TG_RELEASES_URL}/download"

# Evaluate arguments:
if [ $# -eq 0 ]
then
	# Look for the latest Terragrunt version_release available online:
	TG_LATEST=$(wget ${TG_RELEASES_URL} -q -O - | grep " v0." | head -1 | awk '{print $1}')
else
	if [ $# -eq 2 ]
	then
		TG_LATEST="v0.${1}.${2}"   # i.e. v0.42.5
	else
		echo "This script works with none or exactly 2 arguments in the following order:"
		echo -e "${0} [ Version ] [ Release ]\n"
		echo -e "i.e. ${0} 42 5\n"
		exit
	fi
fi

# Set variables with the files and directories names:
BASE_DIR="${HOME}/bin/terragrunt"
NEW_DIR="${BASE_DIR}/${TG_LATEST}"
SYM_LINK="${BASE_DIR}/latest"
BIN_LINK="/usr/local/bin/terragrunt"
TG_BINARY="terragrunt_darwin_amd64"  # MAC
# TG_BINARY="terragrunt_linux_amd64" # Linux

# Create Base directory if it doesn't exist:
if [ ! -d "${BASE_DIR}" ]
then
	echo "Creating base directory to hold Terragrunt binary."
	mkdir -p "${BASE_DIR}"
fi

# Check if the requested version exist and create the new directory if it doesn't:
if [ -d "${NEW_DIR}" ]
then
	echo -e "Terragrunt ${TG_LATEST} is already installed, No action taken.\n"
	exit
else
	mkdir "${NEW_DIR}"
	cd "${NEW_DIR}" || exit
fi
#
# Install the new Terragrunt version:
#
echo "Downloading Terragrunt ${TG_LATEST} binary."
if ! wget "${TG_DOWNLOAD_URL}"/"${TG_LATEST}"/"${TG_BINARY}" -q
then
	echo "Terragrunt binary file download FAILED."
	cd - || exit
	rm -rf "${NEW_DIR}"
	exit
fi

chmod +x "${TG_BINARY}"

if [ -L "${SYM_LINK}" ]
then
	echo "Deleting old symbolic link."
	rm "${SYM_LINK}"
fi

# Create the new symbolic link to the latest terragrunt binary:
ln -s "${NEW_DIR}"/"${TG_BINARY}" "${SYM_LINK}"

if [ -f "${BIN_LINK}" ] && [ ! -L "${BIN_LINK}" ]
then
	sudo rm "${BIN_LINK}"
fi

if [ ! -L "${BIN_LINK}" ]
then
	echo "Creating terragrunt symbolic link at /usr/local/bin directory if it doesn't exist yet."
	sudo ln -s "${SYM_LINK}" "${BIN_LINK}"
fi

cd - || exit
echo -e "\nNew version has been deployed.\n"
