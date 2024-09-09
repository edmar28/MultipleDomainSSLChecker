
# SSL Certificate Expiry Checker Script

This bash script is designed to check the SSL certificate expiration status for a list of domains. It outputs the validity period of the SSL certificate, the number of days left until expiration (or how many days since the certificate expired), and the current status (Valid or Expired).




## Features

- Valid From: Displays the date when the SSL certificate becomes valid.
- Valid To: Displays the date when the SSL certificate expires.
- Days Until Expiration: Shows how many days are left until the certificate expires.
- Days Since Expiration: If the certificate has expired, it shows how many days have passed since it expired.
- Status: Indicates whether the SSL certificate is currently valid or has expired.


## Prerequisites
- Bash Shell: This script runs on Unix-based systems such as Linux or macOS.
- OpenSSL: The script uses the openssl command-line tool to query the SSL certificate information. Ensure it's installed on your system.


## Installation

You can install OpenSSL on Ubuntu or other Debian-based distributions using the following command:

```bash
  sudo apt install openssl
```

For Red Hat/CentOS systems:
```bash
  sudo yum install openssl
```
    
## Setting Up

1. Save domains in a text file: Create a file named domains.txt and list the domains (one per line) that you want to check.

Example domains.txt:
```bash
example.com
subdomain.example.com
anotherdomain.com
```

2. Download the Script: Save the following bash script as ssl_checker.sh:

3. Make the Script Executable: Run the following command to make the script executable:
```bash
chmod +x ssl_checker.sh
```

4. Run the Script: Execute the script using the following command:
```bash
./ssl_checker.sh
```

