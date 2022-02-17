echo " ========================================================"
echo " Base installations for TheOrigin Server"
echo " ========================================================"

echo " Run as root!"
echo " Usage: baseInstallations.sh password"

if [ -z "$1" ]
then
      echo "Password as a parameter not given"
	  exit 1
fi

echo "--> update centos"
yum -y update

echo "--> create admin user"
adduser admin
echo $1 | passwd admin --stdin
usermod -aG wheel admin


echo "--> Install setup script"
if service --status-all | grep -Fq ''; then 
	echo "Startup script is already installed"
elif
	cp startup.sh /root
	cp startup.service /etc/systemd/system
	chmod x+ /etc/systemd/system/startup.service
	systemctl daemon-reload
	systemctl enable startup.service
fi

echo "--> Create workplace"
mkdir workplace
chown -R admin:admin /workplace

echo "--> Install corretto 17"
if service --status-all | grep -Fq 'corretto'; then    
	echo "corretto already installed"
elif
	rpm --import https://yum.corretto.aws/corretto.key 
	curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
	yum install -y java-17-amazon-corretto-devel
fi

echo "--> Install docker"
if service --status-all | grep -Fq 'docker'; then    
	echo "docker already installed"
elif
	yum remove docker \
		docker-client \
		docker-client-latest \
		docker-common \
		docker-latest \
		docker-latest-logrotate \
		docker-logrotate \
		docker-engine

	yum install -y yum-utils

	yum-config-manager --add-repo  https://download.docker.com/linux/centos/docker-ce.repo

	yum install docker-ce docker-ce-cli containerd.io

	systemctl stop docker 

	cp docker.service /lib/systemd/system

	mkdir /etc/docker
	cp daemon.json /etc/docker

	systemctl daemon-reload
	systemctl enable docker
fi


echo "--> Install latest GIT"
yum -y remove git
yum -y remove git-*
yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo-1.10-1.x86_64.rpm
yum -y install git
git --version

echo "--> Remove smb bus error"
/etc/modprobe.d/blacklist.conf > blacklist i2c-piix4

echo "--> All done"