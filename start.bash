#!/bin/bash

# cat << EOF > .d
# HOMEDIR=${HOME}
# EOF

sudo docker-compose down
sudo docker-compose up -d