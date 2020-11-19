# Lab2: Elasticsearch Log analysis using Kibana


- Testing index:
  - Create index mapping </br> 
    `curl -XPUT -H "Content-Type: application/json" localhost:9200/<index_name> -d @<path_to_data_file>.json`
  - delete index </br>
    `curl -X DELETE "localhost:9200/<index_name>?pretty"`
  - display indexes </br>
    `curl -XGET "localhost:9200/_cat/indices"`
  - display mapping </br>
    `curl -XGET "localhost:9200/<name_of_mapping>"`


- Use Kibana console to execute the following and create the log-01 index:
<pre>
    PUT /logs-01
    {
      "aliases": {
      "this_week": {}
    },
    "settings": {
      "number_of_shards": 2,
      "number_of_replicas": 1
    }
    }
</pre>

- Use Kibana console to execute the following and create the log-02 index:

<pre><code>
    PUT /logs-02
    {
    "aliases": {
        "last_week": {}
    },
    "settings": {
        "number_of_shards": 2,
        "number_of_replicas": 1
    }
    }
</pre></code>

- CRUD operations on Elasticsearch

  - Create:
<pre><code>
    PUT bank/_doc/1000
    {
    "account_number": 1000,
    "balance": 65536,
    "firstname": "John",
    "lastname": "Doe",
    "age": 23,
    "gender": "M",
    "address": "45 West 27th Street",
    "employer": "Elastic",
    "email": "john@elastic.com",
    "city": "New York",
    "state": "NY"
    }
</pre></code>

  - Update:
<pre><code>
    POST bank/_update/100/
    {
    "doc": {
        "address": "1600 Pennsylvania Ave NW",
        "city": "Washington",
        "state": "DC"
    }
    }
</pre></code>

  - Delete:
<pre><code>
    DELETE bank/_doc/1
    DELETE bank/_doc/10
</pre></code>

## Querying data in Elasticsearch

- Knowing how to index data in Elasticsearch is important, but knowing how to ask the data precise questions is even more crucial.

<pre><code>
    GET shakespeare/_search
    {
      "query": {
        "term": {
          "speaker.keyword": {
            "value": "ROMEO"
          }
        }
      }
    }
</pre></code>

<pre><code>
    GET shakespeare/_search
    {
      "size": 25, 
      "query": {
        "terms": {
          "play_name.keyword": [
            "Henry VI Part 1",
            "Henry VI Part 2",
            "Henry VI Part 3"
          ]
        }
      }
    }
</pre></code>
<pre><code>
    GET shakespeare/_search
    {
      "size": 5, 
      "query": {
        "match": {
          "text_entry": "London"
        }
      }
    }
  </pre></code>