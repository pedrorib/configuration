
if [[ ! "$(lsb_release -d | cut -f2)" =~ $'Ubuntu 14.04.2 LTS' ]]; then
   echo "Este script funciona apenas em UBUNTU 14.04.2 LTS."
   echo "Quer prosseguir mesmo assim? (S=SIM / Outra tecla para sair)"
   read conf;
   if [[ "$conf" != "S" ]]; then
    echo "ABORTADO"
    exit;
   fi
fi

echo "Já fez upgrade e update?"
sleep 3
echo "(S para sim, outra tecla para abortar)"
read teste

if [[ "$teste" != "S" ]]; then
echo "ABORTADO";
fi

echo "São necessárias permissões de root para correr este script"

sudo apt-get install -y build-essential software-properties-common python-software-properties curl git-core libxml2-dev libxslt1-dev libfreetype6-dev python-pip python-apt python-dev
sudo pip install --upgrade pip
sudo pip install --upgrade virtualenv

cd /var/tmp
git clone -b named-release/birch https://github.com/edx/configuration

sleep 10

sudo sed -i "/libblas/ s/^/#/g" /var/tmp/configuration/playbooks/roles/edxapp/tasks/python_sandbox_env.yml
sudo sed -i "/liblapack/ s/^/#/g" /var/tmp/configuration/playbooks/roles/edxapp/tasks/python_sandbox_env.yml

sudo sed -i "s/https/http/g" /var/tmp/configuration/playbooks/roles/elasticsearch/defaults/main.yml

cd /var/tmp/configuration
sudo pip install -r requirements.txt
sudo apt-get install -y ansible

cd /var/tmp/configuration/playbooks && sudo ansible-playbook -c local ./edx_sandbox.yml -i "localhost,"
