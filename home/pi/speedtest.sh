#!/bin/bash

# Define log files.
log_down='/var/log/speedtest_down.log';
log_up='/var/log/speedtest_up.log';
log_ping='/var/log/speedtest_ping.log';

# Create log files as needed.
test -f $log_down || echo $'\n' > $log_down;
test -f $log_up || echo $'\n' > $log_up;
test -f $log_ping || echo $'\n' > $log_ping;

# Run the test.
speed=( $( /usr/local/bin/speedtest-cli --secure --csv | awk -F ',' '{print $6 " " $7/1000000 " " $8/1000000}' ) );
date=( $( date +"%s" ) );

# Write the results. Cron currently hourly. 168 = hours in a week.
sed -ni "1s/^/${date},${speed[1]}\n/;168q;p" $log_down;
sed -ni "1s/^/${date},${speed[2]}\n/;168q;p" $log_up;
sed -ni "1s/^/${date},${speed[0]}\n/;168q;p" $log_ping;
