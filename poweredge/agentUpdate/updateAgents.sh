#!/bin/bash
echo "Update for teamcity agent containers"

# copy this and settings-agent to conatainer and run in portainer
# sudo docker cp /tmp/updateAgents.sh teamcity-agent:/
# sudo docker exec teamcity-agent rm /opt/maven/conf/settings.xml
# sudo docker cp /tmp/settings-agent.xml teamcity-agent:/opt/maven/conf/settings.xml


echo "--> Stop agent"
/opt/buildagent/bin/agent.sh stop
echo "--> Install corretto 17..."
apt update
apt install wget
echo "--> Install corretto-jdk-17"
wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz
rm -rf /opt/java/corretto-jdk-17
mkdir /corretto-jdk-17
mkdir /opt/java/corretto-jdk-17
tar -xf amazon-corretto-17-x64-linux-jdk.tar.gz -C /corretto-jdk-17
cp -r /corretto-jdk-17/amazon-corretto-17.0.2.8.1-linux-x64/* /opt/java/corretto-jdk-17
rm amazon-corretto-17-x64-linux-jdk.tar.gz*
rm -rf /corretto-jdk-17
echo "--> Install maven..."
rm -rf /maven
rm -rf /opt/maven
mkdir /maven
mkdir /opt/maven
wget https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz
tar -xf apache-maven-3.8.4-bin.tar.gz -C /maven
cp -r /maven/apache-maven-3.8.4/* /opt/maven
rm apache-maven-3.8.4-bin.tar.gz*
rm -rf /maven
rm /opt/maven/conf/settings.xml
cp settings.xml /opt/maven/conf/settings.xml
export PATH=$PATH:/opt/maven/bin
echo "--> Start agent"
/opt/buildagent/bin/agent.sh start
echo "--> All done..."