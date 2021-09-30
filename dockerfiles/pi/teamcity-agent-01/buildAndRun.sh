 sudo docker build . -t elbernito/teamcity-agent-1
 sudo docker rm -f teamcity-agent-1
 sudo docker run -d --name=teamcity-agent-1 --restart=always --net teamcity --ip 172.18.1.3 -v /workplace/teamcity_home/agent01:/data elbernito/teamcity-agent-1
