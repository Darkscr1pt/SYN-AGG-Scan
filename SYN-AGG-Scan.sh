#!/bin/bash

# Check if an IP address argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <IP address>"
  exit 1
fi

# Store the provided IP address in a variable
ip_address=$1

# Stealth SYN scan (change or remove --max-rate as needed)
sudo nmap -p- -sS -oG ports.txt $ip_address

# Store the port numbers (comma separated) in the $ports variable
ports=$(grep Ports ports.txt | sed 's/, /\n/g' | grep -oP '^\d+' | paste -sd ',' -)

# Perform an aggressive Nmap scan with service version and OS detection and script scan
sudo nmap -sV -sC -A -T4 -O -p $ports $ip_address -oN nmap_results.txt

# Remove the ports.txt file after the scan is completed
rm ports.txt

# Notify the user that the scan is complete and the file has been deleted
echo "Scan complete. ports.txt has been deleted."
