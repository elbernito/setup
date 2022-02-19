echo " =============================================="
echo "  docker script for TheCollector"
echo " =============================================="

echo "install as root"
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
sudo ulimit -n 131072
sudo ulimit -u 8192

echo "--> Install Postgre DB"
docker run -d \
	--name postgreDB \
	--restart=always \
	-p 5432:5432 \
	-e POSTGRES_PASSWORD=admin123 \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
    -v /workplace/postgreDB:/var/lib/postgresql/data \
	postgres

echo "--> Install pgAdmin"
chown -R 5050:5050 /workplace/pgAdmin
docker run -d \
	--name pgAdmin \
	--restart=always \
	-p 5434:80 \
    -v /workplace/pgAdmin:/var/lib/pgadmin \
    -e 'PGADMIN_DEFAULT_EMAIL=bernie@bru2ner.ch' \
    -e 'PGADMIN_DEFAULT_PASSWORD=admin123' \
    -d dpage/pgadmin4
	
echo "--> Install Nexus 3"
sudo chown -R 200:200 /workplace/nexus3
sudo docker run -d \
	--name nexus3 \
	--restart=always \
	-v /workplace/nexus3:/nexus-data \
	-p 8082:8081 \
	sonatype/nexus3
	
echo "--> Install Sonarqube"
docker run -d \
	--name sonarqube \
	--restart=always \
	-v /workplace/sonarqube/data:/opt/sonarqube/data \
	-v /workplace/sonarqube/logs:/opt/sonarqube/logs \
	-v /workplace/sonarqube/extensions:/opt/sonarqube/extensions \
	-p 9020:9000 \
	--stop-timeout 3600 \
	sonarqube

echo "--> Install ELK"
sudo docker run -d --name elk --restart=always -e ES_HEAP_SIZE="512m" -e LS_HEAP_SIZE="512m" -v /workplace/elk/kibana:/opt/kibana -v /workplace/elk/logstash:/opt/logstash -v /workplace/elk/elasticsearch/data:/var/lib/elasticsearch -v /workplace/elk/elasticsearch/plugins:/opt/elasticsearch -p 5601:5601 -p 9200:9200 -p 5044:5044 sebp/elk


firewall-cmd --zone=public --add-port=5044/tcp --permanent
firewall-cmd --reload