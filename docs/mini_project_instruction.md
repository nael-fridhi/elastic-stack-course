# Lab 4 : Intructions

1. Install Elasticsearch on Each Node
<pre><code>
    sudo su -

    rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

    curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.0-x86_64.rpm

    rpm --install elasticsearch-7.6.0-x86_64.rpm

    systemctl enable elasticsearch
    
</pre></code>

2. Configure Each Node to make a cluster
<pre><code>
    vim /etc/elasticsearch/elasticsearch.yml

    #cluster.name: my-application --> cluster.name: development
    
    #node.name: node-1 --> node.name: master-1
    
    #node.name: node-1 --> node.name: data-1
    
    #node.name: node-1 --> node.name: data-2
    
    node.master: true
    node.data: false
    node.ingest: true
    node.ml: false

    node.master: false
    node.data: true
    node.ingest: false
    node.ml: false

#network.host: 192.168.0.1 --> network.host: [_local_, _site_]

#discovery.seed_hosts: ["host1", "host2"] --> discovery.seed_hosts: ["10.0.1.101"]

#cluster.initial_master_nodes: ["node-1", "node-2"] --> cluster.initial_master_nodes: ["master-1"]

systemctl start elasticsearch

curl localhost:9200/_cat/nodes?v
</pre></code>


3. Generate and deploy the dev certificate to each node 

<pre><code>
mkdir /etc/elasticsearch/certs
/usr/share/elasticsearch/bin/elasticsearch-certutil cert --name development --out /etc/elasticsearch/certs/development

chmod 640 /etc/elasticsearch/certs/development

scp /etc/elasticsearch/certs/development 10.0.1.102:/etc/elasticsearch/certs/

scp /etc/elasticsearch/certs/development 10.0.1.103:/etc/elasticsearch/certs/

</pre></code>



4. encrypt the elasticsearch Transport Network on each node

<pre><code>
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.keystore.path: certs/development
xpack.security.transport.ssl.truststore.path: certs/development
systemctl restart elasticsearch
</pre></code>


5. Use the `elasticsearch-setup-passwords` tool to set the password for each built-in User on the `master-1` node
<pre><code>
User: elastic
Password: aidodev

User: apm_system
Password: aidodev

User: kibana
Password: aidodev

User: logstash_system
Password: aidodev

User: beats_system
Password: aidodev

User: remote_monitoring_user
Password: aidodev
</pre></code>

6. Deploy Kibana on the `master-1` Node
<pre><code>
curl -O https://artifacts.elastic.co/downloads/kibana/kibana-7.6.0-x86_64.rpm
rpm --install kibana-7.6.0-x86_64.rpm
systemctl enable kibana
</pre></code>

7. Configure Kibana to Bind to the Site-Local Address, Listen on Port 8080, and Connect to Elasticsearch
<pre><code>
vim /etc/kibana/kibana.yml
#server.port: 5601 --> server.port: 8080
#server.host: "localhost" --> server.host: "10.0.1.101"
#elasticsearch.username: "kibana" --> elasticsearch.username: "kibana"
#elasticsearch.password: "pass" --> elasticsearch.password: "aidodev"
systemctl start kibana
</pre></code>

8. Deploy Metricbeat on each node
<pre><code>
curl -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.0-x86_64.rpm
rpm --install metricbeat-7.6.0-x86_64.rpm
systemctl enable metricbeat
</pre></code>

9. configure Metricbeat on each node to use the system module to ingest system telemetry to elasticsearch and visualize it in kibana 
<pre><code>
vim /etc/metricbeat/metricbeat.yml
    #host: "localhost:5601" --> host: "10.0.1.101:8080"

    hosts: ["localhost:9200"] --> hosts: ["10.0.1.101:9200"]
    #api_key: "id:api_key"
    #username: "elastic" --> username: "elastic"
    #password: "changeme" --> password: "aidodev"

`metricbeat setup`
`systemctl start metricbeat`
</pre></code>

10. deploy filebeat on each node
<pre><code>
curl -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.0-x86_64.rpm
rpm --install filebeat-7.6.0-x86_64.rpm
systemctl enable filebeat
</pre></code>

11. configure filebeat on each node to use system Module to ingest system logs to elasticsearch and visualize them in kibana
<pre><code>
vim /etc/filebeat/filebeat.yml
#host: "localhost:5601" --> host: "10.0.1.101:8080"
hosts: ["localhost:9200"] --> hosts: ["10.0.1.101:9200"]
#username: "elastic" --> username: "elastic"
#password: "changeme" --> password: "aidodev"

filebeat modules enable system
filebeat setup
systemctl start filebeat
</pre></code>

12. use kibana to explore your system logs and telemetry data.

  - Navigate to http://<PUBLIC_IP_ADDRESS_OF_MASTER-1>:8080 in your web browser and log in as:
    - Username: elastic
    - Password: aidodev
    - On the side navigation bar, click on Dashboard.
    - In the search bar, type "Filebeat System" or "Metricbeat System" to find your sample dashboards.