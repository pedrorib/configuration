#!/bin/sh
##
## Installs the pre-requisites for running edX on a single Ubuntu 12.04
## instance.  This script is provided as a convenience and any of these
## steps could be executed manually.
##
## Note that this script requires that you have the ability to run
## commands as root via sudo.  Caveat Emptor!
##

echo "Já fez upgrade e update?"
sleep 3
echo "(S para sim, outra tecla para abortar)"
read teste

echo "São necessárias permissões de sudo para prosseguir com a instalação."

##
## Update and Upgrade apt packages
##
sudo apt-get update -y
sudo apt-get upgrade -y

##
## Install system pre-requisites
##
sudo apt-get install -y build-essential software-properties-common python-software-properties curl git-core libxml2-dev libxslt1-dev python-pip python-apt python-dev
sudo pip install --upgrade pip
sudo pip install --upgrade virtualenv

## Did we specify an openedx release?
if [ -n "$OPENEDX_RELEASE" ]; then
  EXTRA_VARS="-e edx_platform_version=$OPENEDX_RELEASE \
    -e certs_version=$OPENEDX_RELEASE \
    -e forum_version=$OPENEDX_RELEASE \
    -e xqueue_version=$OPENEDX_RELEASE \
  "
  CONFIG_VER=$OPENEDX_RELEASE
else
  CONFIG_VER="release"
fi

##
## Clone the configuration repository and run Ansible
##
cd /var/tmp
git clone https://github.com/edx/configuration
cd configuration
git checkout $CONFIG_VER

##
## Install the ansible requirements
##
cd /var/tmp/configuration
sudo pip install -r requirements.txt

sed -i "/libblas/ s/^/#/g" /var/tmp/configuration/playbooks/roles/edxapp/tasks/python_sandbox_env.yml
sed -i "/liblapack/ s/^/#/g" /var/tmp/configuration/playbooks/roles/edxapp/tasks/python_sandbox_env.yml
sed -i "s/https/http/g" /var/tmp/configuration/playbooks/roles/elasticsearch/defaults/main.yml

##
## Run the edx_sandbox.yml playbook in the configuration/playbooks directory
##
cd /var/tmp/configuration/playbooks && sudo ansible-playbook -c local ./edx_sandbox.yml -i "localhost," $EXTRA_VARS
