echo "--> Install Teamcity Server"
sudo rm -rf /workplace/teamcity-server/*

sudo docker run -d \
	--name teamcity-server  \
	--restart=always \
	--net=host \
	-e TEAMCITY_SERVER_MEM_OPTS="-Xmx2g -XX:MaxPermSize=512m -XX:ReservedCodeCacheSize=350m" \
    -v /workplace/teamcity-server/data:/data/teamcity_server/datadir \
    -v /workplace/teamcity-server/logs:/opt/teamcity/logs  \
    jetbrains/teamcity-server:2021.2.3
	
sudo firewall-cmd --zone=public --add-port=9090/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8111/tcp --permanent
sudo firewall-cmd --reload