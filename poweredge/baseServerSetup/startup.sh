echo "Startup script for centos server"
log=startup.log

echo "execution started"

echo "shutdown docker"
systemctl stop docker

echo "mount workplace"
mount /dev/sdb /workplace

echo "start docker"
systemctl start docker

echo "start portainer"
docker volume create portainer_data

docker rm portainer

docker run -d -p 8000:8000 -p 9000:9443 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest


echo "all done"

exit 0


