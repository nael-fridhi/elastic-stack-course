# Other Notes:

- To well executre this labs, you need to have a minimum of 8GB of RAM.  

- You may have a problem with the virtual max map count to fix this issue run this command: </br>
  `sudo sysctl -w vm.max_map_count=262144` </br>
  **N.B:** With command the setting will only last for the duration of the session. If you want to set this permanently, you need to edit /etc/sysctl.conf and set vm.max_map_count to 262144. 

- run docker without sudo 
`sudo groupadd docker`
`sudo usermod -aG docker $USER`
`newgrp docker`