 #sudo docker build . -t elbernito/teamcity-agent
 sudo docker rm -f teamcity-agent
 sudo docker run -d --name=teamcity-agent --restart=always --net teamcity --ip 172.18.1.3 -v /workplace/teamcity_home/agent01:/data elbernito/teamcity-agent
