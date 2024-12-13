# Cloudflare Zero Trust IP Updater Script

## Overview
This script automates updating the external IP address of a Zero Trust location in Cloudflare. It checks the current public IPv4 address, compares it to a previously stored IP address, and updates Cloudflare only if the IP has changed. This is useful for maintaining up-to-date IP addresses in Cloudflare when using a dynamic IP.

## How It Works
1. The script fetches the current public IPv4 address using `curl -4 https://ifconfig.me`.
2. It checks if the IP address stored in `/tmp/current_ip.txt` exists.
3. If the current IP differs from the stored IP, the script makes a `PUT` request to the Cloudflare API with the new IP address.
4. The new IP is stored in the file for future comparison.
5. If the API request succeeds, a success message is printed. Otherwise, an error message is displayed.

## Requirements
- **Bash Shell:** Ensure the system supports bash scripting.
- **Curl:** The `curl` command must be installed.
- **Cloudflare API Token:** A Cloudflare API token with permissions to manage Gateway locations.

## Setup Instructions
1. **Clone the Script:** Download or copy the script to a local file, e.g., `ip_update.sh`.
2. **Make Executable:**
   ```bash
   chmod +x ip_update.sh
   ```
3. **Edit Configurations:** Open the script in a text editor and update the following placeholders:
   - `API_TOKEN="your_cloudflare_api_token"`
   - `ACCOUNT_ID="your_account_id"`
   - `LOCATION_ID="your_location_id"`
   
  **Get Your Cloudflare API Token:**
   - Log in to the Cloudflare Dashboard.
   - Go to **Manage Account** > **Account API Tokens**.
   - Click **Create Token**.
   - Click **Get Started** under Create Custom Token.'
   
	 - Give it a meaningful name: "Location Update"
	 - For **Permissions**, select Account, Zero Trust, Edit
	 - Click **Continue to summary**
	 - Click **Create Token**
	 - Click **Copy** next to the created token.
	 
   
   - Copy the generated token.

 **Find Your Cloudflare Account ID:**
   - Log in to the Cloudflare Dashboard.
   - Go to **Overview**.
   - Your **Account ID** is part of the URL: https://dash.cloudflare.com/{ACCOUNT_ID}

 **Retrieve Your Location ID:**
   - Use the following API call to list all Gateway locations:
     ```bash
     curl -X GET "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/gateway/locations" \
       -H "Authorization: Bearer {API_TOKEN}" \
       -H "Content-Type: application/json"
     ```
   - Look for the "id" field in the response. This is your **Location ID**.   
   

4. **Run the Script Manually:**
   ```bash
   ./ip_update.sh
   ```

5. **Automate with Cron (Optional):**
   Add a cron job to run the script periodically:
   ```bash
   crontab -e
   ```
   Add the following line to run the script every hour:
   ```bash
   0 * * * * /path/to/ip_update.sh
   ```

## Security Considerations
- Store API tokens securely and limit their permissions.
- Ensure file permissions on the script are restrictive to prevent unauthorized modifications.

## Disclaimer
Use this script at your own risk. The author assumes no responsibility for misconfigurations or issues arising from its use.

