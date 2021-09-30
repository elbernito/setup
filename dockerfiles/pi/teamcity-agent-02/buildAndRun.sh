 sudo docker build . -t elbernito/teamcity-agent-2
 sudo docker rm -f teamcity-agent-2
 sudo docker run -d --name=teamcity-agent-2 --restart=always --net teamcity --ip 172.18.1.4 -v /workplace/teamcity_home/agent02:/data elbernito/teamcity-agent-2
