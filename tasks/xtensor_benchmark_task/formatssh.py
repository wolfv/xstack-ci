import os

private_key = os.environ['SSH_PRIVATE_KEY']
public_key = os.environ['SSH_PUBLIC_KEY']

private_key.replace(' ', '\n')
print(private_key)

with open('ssh_key', 'w') as fo:
	fo.write(private_key)