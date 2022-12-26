# V Rising on Hetzner VM 

Requirements (run on ubuntu or WSL2):
* hcloud cli is installed and configured (HETZNER_API_TOKEN is set)
* make
* scp

```
# This will take a while until ready, cloud_data.sh will install docker on the VM
make h-create-server

# Copy local repo to remote
make h-copy-files

# ssh to the remote host (from here manual installation)
make h-ssh

# On the VM
cd v-rising-server-dedicated
make image-run
```
