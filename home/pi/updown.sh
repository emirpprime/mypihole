#!/bin/bash

# Define log files.
log_domain='/var/log/updown_dommain.log';
log_dns='/var/log/updown_dns.log';

# Create log files as needed.
test -f $log_domain || echo $'\n' > $log_domain;
test -f $log_dns || echo $'\n' > $log_dns;

# Define targets;
domain_target='google.co.uk';
dns_target='1.1.1.1';

# Run the tests.
domain_test=$( ping -f -c 10 $domain_target | awk -F '/' 'END {print strftime("%s,"), $5}' );
dns_test=$( ping -f -c 10 $dns_target | awk -F '/' 'END {print strftime("%s,"), $5}' );

# Write the results. Currently cron is every 5 mins. 288 = 24 hours worth.
sed -ni "1s/^/$domain_test\n/;288q;p" $log_domain;
sed -ni "1s/^/$dns_test\n/;288q;p" $log_dns;
