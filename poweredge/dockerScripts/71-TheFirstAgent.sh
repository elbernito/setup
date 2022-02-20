echo "--> Install Consul Agent Node"
sudo docker run -d --name=consul-agent --restart=always --net=host -e CONSUL_LOCAL_CONFIG='{"datacenter":"poweredge", "server":false, "enable_debug":true}' consul:1.11.3 agent -node=TheFirstAgent -join 192.168.1.64 --retry-join=192.168.1.64 -bind=192.168.1.71

echo "--> Install Teamcity Agent"

sudo rm -rf /workplace/teamcity-agent/*
sudo mkdir /workplace/teamcity-agent/conf
sudo cp ./teamcity-agent/buildAgent1.properties /workplace/teamcity-agent/conf/buildAgent.properties

sudo docker rm -f teamcity-agent
sudo docker run -d --name="teamcity-agent" --restart=always --net=host -e SERVER_URL="192.168.1.70:8111" -e AGENT_NAME="TheFirstAgent" -e OWN_ADDRESS="192.168.1.71" -u 0 -v /workplace/teamcity-agent/config:/data/teamcity_agent/conf -v /var/run/docker.sock:/var/run/docker.sock -v /workplace/teamcity-agent/work:/opt/buildagent/work -v /workplace/teamcity-agent/temp:/opt/buildagent/temp -v /workplace/teamcity-agent/tools:/opt/buildagent/tools -v /workplace/teamcity-agent/plugins:/opt/buildagent/plugins -v /workplace/teamcity-agent/system:/opt/buildagent/system jetbrains/teamcity-agent:2021.2.3

