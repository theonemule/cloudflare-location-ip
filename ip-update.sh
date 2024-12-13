#!/bin/bash

# Configurations
API_TOKEN="GCLACbcOpaCJagofw8APJ5hvtWL3GiQ1xZsXQKo1"
ACCOUNT_ID="c7065cb68d9917bfb58484d2dadf3b76"
LOCATION_ID="42372b25b2a44f58b7424a717b71df45"
CURRENT_IP_FILE="/ip/current_ip.txt"
API_URL="https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/gateway/locations/$LOCATION_ID"

# Get the current public IP
NEW_IP=$(curl -4 -s https://ifconfig.me)

# Check if the IP file exists
if [ -f "$CURRENT_IP_FILE" ]; then
  STORED_IP=$(cat $CURRENT_IP_FILE)
else
  STORED_IP=""
fi

# Compare IPs and update if necessary
if [ "$NEW_IP" != "$STORED_IP" ]; then
  echo "IP has changed from $STORED_IP to $NEW_IP. Updating Cloudflare..."

  RESPONSE=$(curl -s -X PUT "$API_URL" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{
      \"client_default\": true,
      \"name\": \"Office Location\",
      \"networks\": [
        { \"network\": \"$NEW_IP/32\" }
      ]
    }")

  if echo "$RESPONSE" | grep -q '"success": true'; then
    echo "IP successfully updated to $NEW_IP."
    echo "$NEW_IP" > "$CURRENT_IP_FILE"
  else
    echo "Failed to update IP on Cloudflare. Response: $RESPONSE"
  fi
else
  echo "IP has not changed. Current IP: $STORED_IP"
fi