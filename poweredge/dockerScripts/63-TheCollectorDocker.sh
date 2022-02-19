echo " =============================================="
echo "  docker script for TheCollector"
echo " =============================================="

echo "install as root"
echo "in /etc/sysctl.conf"
vm.max_map_count=524288
fs.file-max=131072
echo "in /etc/security/limits.conf"
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
sudo rm -rf /workplace/elk/*
sudo mkdir /workplace/elk/logs
sudo mkdir /workplace/elk/logs/kibana
sudo mkdir /workplace/elk/logs/logstash
sudo mkdir /workplace/elk/logs/elasticsearch

sudo chmod -R 777 /workplace/elk/logs/kibana
sudo chmod -R 777 /workplace/elk/logs/logstash
sudo chmod -R 777 /workplace/elk/logs/elasticsearch


sudo docker run -d --name elk --restart=always -e ES_HEAP_SIZE="512m" -e LS_HEAP_SIZE="512m" -v /workplace/elk/logs/elasticsearch:/var/log/elasticsearch -v /workplace/elk/logs/kibana:/var/log/kibana -v /workplace/elk/logs/logstash:/var/log/logstash -v /workplace/elk/logstash/config:/opt/logstash/config -v /workplace/elk/elasticsearch/data:/var/lib/elasticsearch -p 5601:5601 -p 9200:9200 -p 5044:5044 sebp/elk:7.16.3



firewall-cmd --zone=public --add-port=5044/tcp --permanent
firewall-cmd --reload