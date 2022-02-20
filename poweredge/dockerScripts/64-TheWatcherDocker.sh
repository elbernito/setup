echo "--> Install Consul Master Node"
sudo docker run -d --name=consul-master --restart=always --net=host -e CONSUL_BIND_INTERFACE='ens192' -e CONSUL_LOCAL_CONFIG='{"datacenter":"poweredge", "server":true, "enable_debug":true}' consul:1.11.3 agent -server -ui -node=TheWatcher -bootstrap-expect=1 -client=0.0.0.0

sudo firewall-cmd --zone=public --add-port=8500/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8600/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8301/tcp --permanent
sudo firewall-cmd --reload

echo "--> Install Traefik"
sudo rm -rf /workplace/traefik/*
cp traefik.yml /workplace/traefik
sudo docker run -d --name=traefik --restart=always -p 8080:8080 -p 80:80 -v /workplace/traefik/traefik.yml:/etc/traefik/traefik.yml -v /var/run/docker.sock:/var/run/docker.sock traefik:v2.6.1

sudo firewall-cmd --zone=public --add-port=2375/tcp --permanent
sudo firewall-cmd --reload