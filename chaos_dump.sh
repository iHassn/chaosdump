#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
  printf "Please provide the domain name (without the .zip extension or .com) as an argument.\nUsage: %s <domain>\n" "$0"
  exit 1
fi

# Set the URL and file name
URL="https://chaos-data.projectdiscovery.io/$1.zip"
ZIP_FILE="$1.zip"
UNZIPPED_DIR="$1"

# Check if the file exists on the site
if ! curl --output /dev/null --silent --head --fail "$URL"; then
  printf "Your target %s.com does not exist on the chaos-data.projectdiscovery.io\n" "$1"
  exit 1
fi

# Download the file
curl -L -sS -o "$ZIP_FILE" "$URL"

# Unzip the file
unzip -q "$ZIP_FILE" -d "$UNZIPPED_DIR" > /dev/null 2>&1

# Remove the zip file
rm "$ZIP_FILE"

CATSUBS=$(cat "$1"/*.txt)

SUBDOMAIN_COUNT=$(cat "$1"/*.txt | wc -l)

printf "\n%s\n\n" "$CATSUBS"
printf "  Total subdomains of %s is %d\n" "$1" "$SUBDOMAIN_COUNT"

rm -rf "$1"
