import json, os

psd = json.load(open("address.json"))

ip = psd.split(',')[1].strip()

with open('getipresult.sh') as fo:
	fo.write("export SERVER_IPADDR={}".format(ip))
