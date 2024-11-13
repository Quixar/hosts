#!/bin/bash

validate_ip() {
    local hostname=$1
    local ip_address=$2
    local dns_server=$3

    nslookup_ip=$(nslookup "$hostname" "$dns_server" 2>/dev/null | grep -A1 "Name:" | grep "Address:" | awk '{print $2}')

    if [[ "$nslookup_ip" && "$nslookup_ip" != "$ip_address" ]]; then
        echo "Bogus IP for $hostname in /etc/hosts!"
    fi
}

cat /etc/hosts | while read -r line; do

    if [[ $line =~ ^# ]] || [[ -z $line ]]; then
        continue
    fi

    ip_address=$(echo $line | awk '{print $1}')
    hostname=$(echo $line | awk '{print $2}')

    validate_ip "$hostname" "$ip_address" "8.8.8.8"
done

