# Simple curl to check if a http response is correct

line="=================================================================================================="

address=$1
port=$2
code=$3
echo $line
echo "Check health for address $address on port $port, if code is $code"

response=$(curl -o /dev/null -s -w "%{http_code}\n" http://$address:$port)

if [ "$code" = "$response" ]
then 
	echo "-> Check is ok..."
	echo $line
else
	echo "-> Check is not ok..."
	echo $line
fi

