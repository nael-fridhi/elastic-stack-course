# Lab1 : Installation & Configuration Elastic Stack


In this we are going to install and configure elastic stack using two methods:

1. Docker
2. Using binaries


## Docker

First of all you have to verify if you have docker installed or not. In case you don't have docker installed please follow the installation guide in the docker documentation: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)



## Using binaries 

Elasticsearch using JVM under the hood to work so be sure that you have JAVA installed.

**JAVA INSTALLATION**
[https://www.java.com/en/download/help/index_installing.html](https://www.java.com/en/download/help/index_installing.html)

**ELASTICSEARCH INSTALLATION**
[https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html)

1. Import the Elastic GPG key
`sudo su -`
`rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch`
2. Download and install Elasticsearch from an RPM
`curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.0-x86_64.rpm`
`rpm --install elasticsearch-7.6.0-x86_64.rpm` 
`systemctl enable elasticsearch` : configure elastisearch to start on system boot

3. Configure Elasticsearch to form a cluster
Log in to each node:
`sudo su -`
`vim /etc/elasticsearch/elasticsearch.yml`
change the line `#cluster.name: my-application` to  `cluster.name: cluster-lab`
change the line `#node.name: node-1` to `node.name: node-1`

4. Configure Elasticsearch to listen on multiple addresses

5. Start and test an Elasticsearch 
`systemctl start elasticsearch`
`less /var/log/elasticsearch/cluster-1.log`
`curl localhost:9200/_cat/nodes?v`


### Install Kibana:

`sudo su -`
`curl -O https://artifacts.elastic.co/downloads/kibana/kibana-7.6.0-x86_64.rpm`
`rpm --install kibana-7.6.0-x86_64.rpm`
`systemctl enable kibana`


`vim /etc/kibana/kibana.yml`
`server.port: 8080`
`server.host: "127.0.0.1"`


`systemctl start kibana`
`less /var/log/message`

check Elasticsearch node status using the console: 
Go to Dev Tools > Console : `GET _cat/nodes?v`
Or using Command line: `curl localhost:9200/_cat/nodes?v`