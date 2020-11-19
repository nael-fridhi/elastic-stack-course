# Other Notes:

- To well executre this labs, you need to have a minimum of 8GB of RAM.  

- You may have a problem with the virtual max map count to fix this issue run this command: </br>
  `sudo sysctl -w vm.max_map_count=262144` </br>
  **N.B:** With command the setting will only last for the duration of the session. If you want to set this permanently, you need to edit /etc/sysctl.conf and set vm.max_map_count to 262144. 

- run docker without sudo </br>
`sudo groupadd docker`
`sudo usermod -aG docker $USER`
`newgrp docker`


- In the lab 4 you may not have your data from ingested into elasticsearch from filebeat. In this case to fix the problem try to delete the pipeline using this command </br> `curl -XDELETE -u elastic:password 'http://elasticsearch:9200/_ingest/pipeline/filebeat-*'` </br> and restart filebeat and it should work.

- We can run multiple node of elasticsearch in the same machine. We have only to change this properties in the elasticsearch yml file to the number of node: </br>
`node.max_local_storage_nodes: 2`

- Elasticsearch is a memory-based engine so it will consume too much memory if you run more than one node in the same your machine. You can adjust the maximum memory by changing the file </br> `config/jvm.options` `-Xms1g -Xmx1g`