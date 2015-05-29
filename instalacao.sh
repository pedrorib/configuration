
echo "São necessárias permissões de root para correr este script"

if [[ ! "$(lsb_release -d | cut -f2)" =~ $'Ubuntu 14.04.4 LTS' ]]; then
   echo "Este script funciona apenas em UBUNTU 14.04.4 LTS."
   echo "Quer prosseguir mesmo assim? (S=SIM / Outra tecla para sair)"
   read conf;
   if ["$conf"="S"]; then;
    else
    echo "ABORTADO"
    exit;
   fi
fi
sudo apt-get update -y
sudo apt-get update -y

sudo apt-get install -y build-essential software-properties-common python-software-properties curl git-core libxml2-dev libxslt1-dev libfreetype6-dev python-pip python-apt python-dev
sudo pip install --upgrade pip
sudo pip install --upgrade virtualenv

cd /var/tmp
git clone -b release https://github.com/pedrorib/configuration


cd /var/tmp/configuration
sudo pip install -r requirements.txt

cd /var/tmp/configuration/playbooks && sudo ansible-playbook -c local ./edx_sandbox.yml -i "localhost,"
