#!/bin/sh

url="https://update.faraday.dev/download/windows"
file=`curl -s -D- "$url" | grep -i "location:" | sed -e 's;^.*\(faraday-Setup-.*\.exe\).*$;\1;'`
echo "url:  $url"
echo "file: $file"
curl "-#" -L -o "$file" "$url"

