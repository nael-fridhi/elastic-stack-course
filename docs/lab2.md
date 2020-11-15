# Lab2: Elasticsearch Log analysis using Kibana



- Testing index:
  - Create index mapping 
    `curl -XPUT -H "Content-Type: application/json" localhost:8000/currency -d @coin_mapping.json`
  - delete index 
    `curl -X DELETE "localhost:8000/currency?pretty"`
  - display indexes 
    `curl -XGET "localhost:8000/_cat/indices"`
  - display mapping 
    `curl -XGET "localhost:8000/currency"`


- Use Kibana console to execute the following and create the log-01 index:

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


- Use Kibana console to execute the following and create the log-02 index:

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


- CRUD operations on Elasticsearch

  - Create:

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

  - Update:

    POST bank/_update/100/
    {
    "doc": {
        "address": "1600 Pennsylvania Ave NW",
        "city": "Washington",
        "state": "DC"
    }
    }

  - Delete:

    DELETE bank/_doc/1
    DELETE bank/_doc/10


## Querying data in Elasticsearch

- Knowing how to index data in Elasticsearch is important, but knowing how to ask the data precise questions is even more crucial.


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


    GET shakespeare/_search
    {
      "size": 5, 
      "query": {
        "match": {
          "text_entry": "London"
        }
      }
    }