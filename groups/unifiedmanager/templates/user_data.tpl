#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#Generate new cloudwatch conf file with updated log group and load into cw agent service
python /root/cw_log_conf.py \
 -o "amazon-cloudwatch-agent.log" \
. /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:amazon-cloudwatch-agent.log 

