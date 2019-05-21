import json, os

psd = json.load(open("address.json"))
ip = psd['addresses'].split(',')[-1].strip()
print(ip)
