#!/bin/bash
cat /etc/hosts | while read -r line; do

    if [[ $line =~ ^# ]] || [[ -z $line ]]; then
        continue
    fi

    ip_address=$(echo $line | awk '{print $1}')
    hostname=$(echo $line | awk '{print $2}')

    nslookup_ip=$(nslookup $hostname 2>/dev/null | grep -A1 "Name:" | grep "Address:" | awk '{print $2}')

    if [[ "$nslookup_ip" && "$nslookup_ip" != "$ip_address" ]]; then
        echo "Bogus IP for $hostname in /etc/hosts!"
    fi
done
