docker_image := public.ecr.aws/ponjimon/vrising:latest
server_data_local := ${PWD}/server-data
server_data := /vrising/server-data

image-run:
	docker run -d -e LOCAL_USER_ID=$(shell id -u ${USER}) -e LOCAL_GROUP_ID=$(shell id -g ${USER}) -p 27015:27015/udp -p 27016:27016/udp -v ${server_data_local}:${server_data} public.ecr.aws/ponjimon/vrising:latest

# Hetzner Specific Commands - requires hcloud
ssh_key_name := main
h-add-ssh-key:
	hcloud ssh-key create --name ${ssh_key_name} --public-key-from-file ${HOME}/.ssh/id_rsa.pub

server_name := vrising
server_image := ubuntu-22.04
server_type := cx31 # 2 vCPU/8 GiB - 11~ Euros per month
location := fsn1 # Falkenstein Germany
user_data := cloud_data.sh
h-create-server:
	hcloud server create --type ${server_type} --ssh-key ${ssh_key_name} --location ${location} --name ${server_name} --image ${server_image} --user-data-from-file ${user_data}

h-delete-server:
	hcloud server delete ${server_name}

username := user
h-ssh:
	hcloud server ssh -u ${username} ${server_name}

h-copy-files:
	scp -r ${PWD} user@$(shell hcloud server describe ${server_name} -o json | jq .public_net.ipv4.ip -r):/home/user
