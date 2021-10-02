 #sudo docker build . -t elbernito/teamcity-server
 sudo docker rm -f teamcity-server
 sudo docker run -d \
    --name=teamcity-server \
	-m 1560m \
	--memory-reservation=512m \
	--cpus=3 \
	--restart=always \
	--net teamcity \
	--ip 172.18.1.2 \
	-p 8111:8111 \
	-v /workplace/teamcity_home/server:/data \
	elbernito/teamcity-server
