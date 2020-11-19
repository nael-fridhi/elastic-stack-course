# Lab1 : Installation & Configuration Elastic Stack


In this labs you are going to install and configure elastic stack using two methods:

1. Docker
2. Using binaries


## Docker

First of all you have to verify if you have docker and docker-compose installed or not. In case you don't have docker installed : you could use the script `install-docker.sh` in the config folder in case you are using ubuntu as operating system if it's not the case please follow the installation guide in the docker documentation: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

- Once docker and docker-compose installed:
  1. Take a look at the docker-compose.yml which contains the containers we will run
  2. run this command </br>
  `docker-compose -f docker-compose.yml up -d`
  3. After waiting some minutes we can verify that our cluster is working well by accessing this url:
    - `localhost:9200` : elasticsearch endpoint
    - `localhost:5601` : kibana UI


## Using binaries 

- Elasticsearch using JVM under the hood to work so be sure that you have JAVA installed.

- **Java installation**: 
Please refer to this link to install Java : [https://www.java.com/en/download/help/index_installing.html](https://www.java.com/en/download/help/index_installing.html)

- **Elasticsearch installtion**:
[https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html)

1. Import the Elastic GPG key </br>
`sudo su -` </br>
`rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch`
2. Download and install Elasticsearch from an RPM </br>
`curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.0-x86_64.rpm` </br>
`rpm --install elasticsearch-7.6.0-x86_64.rpm` </br>
`systemctl enable elasticsearch` : configure elastisearch to start on system boot 

3. Configure Elasticsearch to form a cluster
Log in to each node: </br>
`sudo su -` </br>
`vim /etc/elasticsearch/elasticsearch.yml` </br>
change the line `#cluster.name: my-application` to  `cluster.name: cluster-lab` </br>
change the line `#node.name: node-1` to `node.name: node-1` </br>

4. Configure Elasticsearch to listen on multiple addresses

5. Start and test an Elasticsearch 
`systemctl start elasticsearch` </br>
`less /var/log/elasticsearch/cluster-1.log` </br>
`curl localhost:9200/_cat/nodes?v` </br>


### Install Kibana:

We will follow the same approach to install kibana :

`sudo su -` </br>
`curl -O https://artifacts.elastic.co/downloads/kibana/kibana-7.6.0-x86_64.rpm` </br>
`rpm --install kibana-7.6.0-x86_64.rpm` </br>
`systemctl enable kibana` </br>

- We change the configuration of kibana like the port number by editing `kibana.yml` file:
    vim /etc/kibana/kibana.yml
    server.port: 8080
    server.host: "127.0.0.1"

- Once done you can execute the start command and watch the log to make sure all things went well and kibana has running status:
`systemctl start kibana` </br>
`less /var/log/message`

- Check Elasticsearch node status using the console: 
  - Go to Dev Tools > Console : `GET _cat/nodes?v`
  - Or using Command line: `curl localhost:9200/_cat/nodes?v`


- Cluster Administration

`curl localhost:9200/_cluster/health?pretty` </br>
`curl localhost:9200/_cat/shards` </br>
`curl localhost:9201/_nodes/process?pretty` </br>

