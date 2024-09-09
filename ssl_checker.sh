#!/bin/bash

# Path to the file containing the list of domains
domain_file="domains.txt"

# Function to check SSL validity period and format output
check_ssl() {
  local domain=$1
  echo "Checking $domain..."

  # Fetch SSL certificate details and extract validity period
  ssl_info=$(echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null | \
  openssl x509 -noout -dates)

  if [[ -z "$ssl_info" ]]; then
    echo "Error: Could not retrieve SSL information for $domain"
    echo "--------------------------------"
    return
  fi

  # Extract and format the "notBefore" and "notAfter" dates, keeping only the date (no time or GMT)
  valid_from=$(echo "$ssl_info" | grep 'notBefore=' | cut -d= -f2 | awk '{print $1, $2, $4}')
  valid_to=$(echo "$ssl_info" | grep 'notAfter=' | cut -d= -f2 | awk '{print $1, $2, $4}')

  # Replace abbreviated months with full names
  valid_from=$(echo "$valid_from" | sed 's/Jan/January/; s/Feb/February/; s/Mar/March/; s/Apr/April/; s/May/May/; s/Jun/June/; s/Jul/July/; s/Aug/August/; s/Sep/September/; s/Oct/October/; s/Nov/November/; s/Dec/December/')
  valid_to=$(echo "$valid_to" | sed 's/Jan/January/; s/Feb/February/; s/Mar/March/; s/Apr/April/; s/May/May/; s/Jun/June/; s/Jul/July/; s/Aug/August/; s/Sep/September/; s/Oct/October/; s/Nov/November/; s/Dec/December/')

  # Convert the dates into a Unix timestamp for comparison
  expiry_date=$(date -d "$valid_to" +%s)
  current_date=$(date +%s)
  
  # Calculate days to expiry or days since expired
  if (( expiry_date > current_date )); then
    days_until_expiry=$(( (expiry_date - current_date) / 86400 ))
    status="Valid"
  else
    days_since_expiry=$(( (current_date - expiry_date) / 86400 ))
    status="Expired"
  fi

  # Output the results
  echo "$domain"
  echo "Valid from $valid_from to $valid_to"
  
  if [[ "$status" == "Valid" ]]; then
    echo "$days_until_expiry days until expiration"
  else
    echo "$days_since_expiry days since expiration"
  fi

  echo "Status: $status"
  echo "--------------------------------"
}

# Check if the domain file exists
if [[ ! -f "$domain_file" ]]; then
  echo "Error: Domain file not found: $domain_file"
  exit 1
fi

# Read the domains from the file and check SSL validity
while IFS= read -r domain; do
  check_ssl "$domain"
done < "$domain_file"
