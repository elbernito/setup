docker run -d
	--name teamcity-server  \
	--restart=always \
    -v /workplace/teamcity-server/data:/data/teamcity_server/datadir \
    -v /workplace/teamcity-server/logs:/opt/teamcity/logs  \
    -p 8111:8111 \
    jetbrains/teamcity-server