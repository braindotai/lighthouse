#!/bin/sh

echo "Backup finished! Sending success ping to Uptime Kuma..."

# Ping Uptime Kuma (The -fsS flags make it fail silently if it can't reach the network, preventing script crashes)
curl -fsS --retry 3 "${UPTIMEKUMA_PUSH_URL}?status=up&msg=OK&ping="
