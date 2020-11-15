# Lab4: Mini-project Elastic Stack

You work as a DataOps Engineer in a big company. In order to improve visibility into system issues and performance, you are tasked with deploying a development Elastic Stack that will be used as a proof of concept to collect and visualize system log and telemetry data.

First, you need to deploy and configure three Elasticsearch nodes belonging to the development cluster and listening on local and site-local addresses. The node names and roles are as follows:

|Node Name |Roles          |
|----------|:-------------:|
|master-1  |master, ingest |
|data-1    |data           |
|data-2    |data           |

Second, you need to secure the Elasticsearch cluster by generating a PKCS#12 development certificate that you will use to encrypt the Elasticsearch transport network. Because this is a development environment, we will use the same certificate for each node with certificate-level verification only. By enabling transport network encryption, you will also be enabling user authentication, which means you will need to set the passwords for each of the built-in Elasticsearch users as follows:


| User                   | Password                       |
|------------------------|--------------------------------|
| elastic                | aidodev_elastic                |
| apm_system             | aidodev_apm_system             |
| kibana                 | aidodev_kibana                 |
| logstash_system        | aidodev_logstash_system        |
| beats_system           | aidodev_beats_system           |
| remote_monitoring_user | aidodev_remote_monitoring_user |


Once you have a secured three-node Elasticsearch 7.6 cluster up and running, you will need to deploy a Kibana 7.6 instance on the master-1 node. In order to access Kibana from your local web browser, you will need to configure Kibana to bind to the site-local address of the master-1 node (10.0.1.101) and listen on port 8080.

After you have Kibana up and running, you will need to deploy both Metricbeat 7.6 and Filebeat 7.6 clients to each node. You will need to configure each Beat client to talk to Kibana at 10.0.1.101:8080 and output all collected data to the master-1 Elasticsearch node as the elastic user. Lastly, you will need to enable and set up the system module for each Beat client.

Once you have your Elastic Stack collecting, shipping, parsing, and visualizing the system log and telemetry data, log in to your Kibana instance on your master-1 node as the elastic user and explore your new Kibana dashboards.

1. Install Elasticsearch on Each Node
2. Configure Each Node to make a cluster
3. Generate and deploy the dev certificate to each node 
4. encrypt the elasticsearch Transport Network on each node
5. Use the `elasticsearch-setup-passwords` tool to set the password for each built-in User on the `master-1` node
6. Deploy Kibana on the `master-1` Node
7. Configure Kibana to Bind to the Site-Local Address, Listen on Port 8080, and Connect to Elasticsearch
8. Deploy Metricbeat on each node
9. configure Metricbeat on each node to use the system module to ingest system telemetry to elasticsearch and visualize it in kibana 
10. deploy filebeat on each node
11. configure filebeat on each node to use system Module to ingest system logs to elasticsearch and visualize them in kibana 
12. use kibana to explore your system logs and telemetry data.