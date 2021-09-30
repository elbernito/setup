#!/bin/sh
echo "===================================================="
echo "      Starting Teamcity script"
echo "===================================================="

serverBasePath="/TeamCity/bin/"
serverStartScript="$serverBasePath/teamcity-server.sh"
teamcityPort=8111

echo "Parameters"
echo "ServerBasePath:         $serverBasePath"
echo "ServerStartScript:      $serverStartScript"
echo "Teamcity port           $teamcityPort"


echo "============ START TEAMCITY ============="
chmod +x $serverStartScript
$serverStartScript run



