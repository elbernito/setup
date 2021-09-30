 #sudo docker build . -t elbernito/teamcity-server
 sudo docker rm -f teamcity
 sudo docker run -d --name=teamcity --restart=always --net teamcity --ip 172.18.1.2 -p 8111:8111 -v /workplace/teamcity_home:/data elbernito/teamcity-server
