#!/bin/bash
clear
echo " ========================================================"
echo " Base installations for TheOrigin Server"
echo " ========================================================"

echo " Run as root!"

javaPath="/usr/lib/jvm/java-17-amazon-corretto"

echo "--> update centos"
yum -y update

echo "--> Install setup script"
if service --status-all | grep -Fq 'startup'
then 
	echo "Startup script is already installed"
else
	cp startup.sh /root
	cp startup.service /etc/systemd/system
	chmod +x /root/startup.sh
	systemctl daemon-reload
	systemctl enable startup.service
	
fi

echo "--> Create workplace"
if ls / | grep -Fq 'workplace'; then    
	echo "workplace folder already created"
else
	mkdir /workplace
fi

chown -R admin:admin /workplace

echo "--> Mount workplace"
mount /dev/sdb /workplace

echo "--> Install corretto 17"
if service --status-all | grep -Fq 'corretto'; then    
	echo "corretto already installed"
else
	rpm --import https://yum.corretto.aws/corretto.key 
	curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
	yum install -y java-17-amazon-corretto-devel
	rm -rf /etc/profile.d/jdk_home.sh
	touch /etc/profile.d/jdk_home.sh
	echo "export JAVA_HOME=$javaPath/" >> /etc/profile.d/jdk_home.sh
	sudo chmod +x /etc/profile.d/jdk_home.sh
	source /etc/profile.d/jdk_home.sh
fi

echo $JAVA_HOME


echo "--> Install docker"
if service --status-all | grep -Fq 'docker'; then    
	echo "docker already installed"
else
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
	yum install -y docker-ce docker-ce-cli containerd.io
	systemctl stop docker 
	cp docker.service /lib/systemd/system
	mkdir /etc/docker
	cp daemon.json /etc/docker
	systemctl daemon-reload
	systemctl enable docker
	systemctl start docker
fi


echo "--> Install latest GIT"
yum -y remove git
yum -y remove git-*
yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo-1.10-1.x86_64.rpm
yum -y install git
git config --global user.name "elbernito"
git config --global user.email "bernie@bru2ner.ch"
git --version

echo "--> Install maven 3.8.4"
if mvn -version | grep -Fq 'maven'; then    
	echo "Maven already installed"
else
	wget https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz -P /tmp
	tar xf /tmp/apache-maven-3.8.4-bin.tar.gz -C /opt
	rm -f /opt/maven
	ln -s /opt/apache-maven-3.8.4 /opt/maven
	rm -rf /etc/profile.d/maven.sh
	touch /etc/profile.d/maven.sh
	echo "export M2_HOME=/opt/maven" >> /etc/profile.d/maven.sh
	echo "export MAVEN_HOME=/opt/maven" >> /etc/profile.d/maven.sh
	echo "export PATH=/opt/maven/bin:${PATH}" >> /etc/profile.d/maven.sh
	sudo chmod +x /etc/profile.d/maven.sh
	source /etc/profile.d/maven.sh
fi

echo "--> Remove smb bus error"
echo "blacklist i2c-piix4" > /etc/modprobe.d/blacklist.conf

echo "--> Open ports"
firewall-cmd --zone=public --add-port=2375/tcp --permanent
firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --reload

echo "--> Own workplace to admin"
chown -R admin:admin /workplace

echo "--> remove lost+found"
rm -rf /workplace/lost+found

echo "= CHECKS ================================"
docker --version
echo " - - - - - - - - - - - - - - - - - - -"
java --version
echo $JAVA_HOME
echo " - - - - - - - - - - - - - - - - - - -"
git --version
echo " - - - - - - - - - - - - - - - - - - -"
mvn -version
echo $M2_HOME
echo $MAVEN_HOME
echo $PATH
echo "--> All done"