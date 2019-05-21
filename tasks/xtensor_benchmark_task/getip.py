import json, os

psd = json.load(open("address.json"))

ip = psd['addresses'].split(',')[-1].strip()
with open('getipresult.sh', 'w') as fo:
	fo.write("export SERVER_IPADDR={}\n".format(ip))
