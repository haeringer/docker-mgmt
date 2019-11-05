# Docker management scripts

- Place the scripts in ```/usr/local/bin/``` and make them executable.


### check-container-status.sh

Script returns 0 if provided container is running, 2 if container is dead and 3 if there is no such container.


### restart-container-if-dead.sh

Script uses ```check-container-status.sh```. If the container is present but not running, it tries to re-run the container with docker-compose.

Example cronjob for 'self-healing' a container that regularly fails to come up after system reboots:

    * * * * * /bin/bash /usr/local/bin/restart-container-if-dead.sh <container_name> <url_to_repo_master.tar.gz> docker-compose.yml >/dev/null 2>&1
