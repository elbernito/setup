#!/bin/sh
echo "===================================================="
echo "      Starting Teamcity and an Agent script"
echo "===================================================="

agentBasePath="/buildAgent/bin"
agentStartScript="$agentBasePath/agent.sh"

echo "Parameters"
echo "AgentBasePath:          $agentBasePath"
echo "AgentStartScript:       $agentStartScript"

echo "============ START AGENT ============="
chmod +x $agentStartScript 
$agentStartScript run




