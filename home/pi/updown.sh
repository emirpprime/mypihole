#!/bin/bash

# Define log files.
log_domain='/var/log/updown_domain.log';
log_dns='/var/log/updown_dns.log';
log_wifi='/var/log/updown_wifi.log'

# Create log files as needed.
test -f $log_domain || echo $'\n' > $log_domain;
test -f $log_dns || echo $'\n' > $log_dns;
test -f $log_wifi || echo $'\n' > $log_wifi;

# Define targets;
domain_target='google.co.uk';
dns_target='1.1.1.1';
wifi_target='192.168.1.1';

# Run the tests.
domain_test=$( sudo ping -f -c 10 $domain_target | awk -F '/' 'END {print $5}' );
  [[ -z "$domain_test" ]] && domain_test=0;
  domain_test=$(date +%s)","$domain_test;
dns_test=$( sudo ping -f -c 10 $dns_target | awk -F '/' 'END {print $5}' );
  [[ -z "$dns_test" ]] && dns_test=0;
  dns_test=$(date +%s)","$dns_test;
wifi_test=$( sudo ping -f -c 10 $wifi_target | awk -F '/' 'END {print $5}' );
  [[ -z "$wifi_test" ]] && wifi_test=0;
  wifi_test=$(date +%s)","$wifi_test;

# Write the results. Currently cron is every 5 mins. 288 = 24 hours worth.
sed -ni "1s/^/$domain_test\n/;288q;p" $log_domain;
sed -ni "1s/^/$dns_test\n/;288q;p" $log_dns;
sed -ni "1s/^/$wifi_test\n/;288q;p" $log_wifi;
