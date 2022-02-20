echo "Update for teamcity agent containers"

apt install wget
wget -O- https://apt.corretto.aws/corretto.key | apt-key add - 
add-apt-repository 'deb https://apt.corretto.aws stable main'
apt-get update; apt-get install -y java-17-amazon-corretto-jdk


apt-get update 
apt-get install java-common
wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.deb
dpkg --install amazon-corretto-17-x64-linux-jdk.deb
java -version

/opt/buildagent/bin/agent.sh stop
wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz
rm -rf /opt/java/openjdk/*
mkdir /corretto-jdk-17
tar -xf amazon-corretto-17-x64-linux-jdk.tar.gz -C /corretto-jdk-17
cp /corretto-jdk-17/* /opt/java/openjdk/
rm amazon-corretto-17-x64-linux-jdk.tar.gz
java -version
/opt/buildagent/bin/agent.sh start