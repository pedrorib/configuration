
echo "São necessárias permissões de root para correr este script"

sudo apt-get update -y
sudo apt-get update -y

sudo apt-get install -y build-essential software-properties-common python-software-properties curl git-core libxml2-dev libxslt1-dev libfreetype6-dev python-pip python-apt python-dev

cd /var/tmp
git clone -b release https://github.com/pedrorib/configuration


cd /var/tmp/configuration
sudo pip install -r requirements.txt

cd /var/tmp/configuration/playbooks && sudo ansible-playbook -c local ./edx_sandbox.yml -i "localhost,"