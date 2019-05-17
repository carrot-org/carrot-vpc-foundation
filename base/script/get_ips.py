#!/usr/bin/env python
import requests
import json

ip_ranges = requests.get('https://ip-ranges.amazonaws.com/ip-ranges.json').json()['prefixes']
amazon_ips = [item for item in ip_ranges if item["service"] != "AMAZON"]
ec2_ips = [item for item in ip_ranges if item["service"] == "EC2"]
region_ips = [item for item in ip_ranges if item["region"] == "us-west-1" or item["region"] == "GLOBAL"]

amazon_ips_less_ec2=[]
amazon_ip_list=[]

for ip in amazon_ips:
    if ip not in ec2_ips and ip in region_ips:
        amazon_ips_less_ec2.append(ip)

# for ip in amazon_ips_less_ec2: print(str(ip))

for ip in amazon_ips_less_ec2:
    amazon_ip_list.append(ip["ip_prefix"])

print(json.dumps({"list": ",".join(amazon_ip_list)}))