# Lab Movies Json 

- Import json file to elasticsearch
`curl -XPUT -H "Content-Type: application/json" localhost:9200/_bulk --data-binary @movies_elastic.json`

- To verify the content we can open a browser and go to this URL
`http://localhost:9200/movies/movie/_search`

- Upload mapping movies version 2
`curl -XPUT -H "Content-Type: application/json" localhost:9200/movies2 -d @mapping_movies/mapping.json`

- Import data movies version 2
`curl -XPUT -H "Content-Type: application/json" localhost:9200/_bulk --data-binary @mapping_movies/movies_elastic2.json`

- Execute the first search query using the browser
`http://localhost:9200/movies2/_search?q=Star+Wars`

- Filter using title field 
`http://localhost:9200/movies2/_search?q=fields.title:Star Wars`

- Query using a list
`http://localhost:9200/movies2/_search?q=fields.actors:Harrison Ford`

- We can have more items using size
`http://localhost:9200/movies2/_search?q=fields.actors:Harrison Ford&size=20`

- Using AND in the query 
`http://localhost:9200/movies2/_search?q=fields.title:Star Wars AND fields.directors:George Lucas`

- Using negation 
`http://localhost:9200/movies2/_search?q=actors=Harrison Ford AND fields.plot:Jones AND -fields.plot:Nazis`

- Elasticsearch Query DSL

  - query1.json

    {
    "query":{
        "match":{
            "fields.title":"Star Wars"
        }
    }
    }

`curl -XGET -H "Content-Type: application/json" 'localhost:9200/movies2/movie/_search?pretty' -d @query1`

- query2.json
    {"query":{
    "bool": {
        "should": [
            { "match": { "fields.title": "Star Wars" }},
            { "match": { "fields.directors": "George Lucas" }}
        ]
    }}}


    {"query":{
    "bool": {
        "should": { "match": { "fields.title": "Star Wars" }},
        "must" :  { "match": { "fields.directors": "George Lucas" }}
    }}}


    {"query":{
    "bool": {
        "should": [
            { "match_phrase": { "fields.title": "Star Wars" }},
            { "match": { "fields.directors": "George Lucas" }}
        ]
    }}}



    {  "query": {
    "match": 
        {"fields.actors":"Harrison Ford"}
    }}


    {"query":{
    "bool": {
        "should": [
            { "match": { "fields.actors": "Harrison Ford" }},
            { "match": { "fields.plot": "Jones" }}
        ]
    }}}


    {"query":{
    "bool": {
        "should": [
            { "match": { "fields.actors": "Harrison Ford" }},
            { "match": { "fields.plot": "Jones" }}
        ],
        "must_not" : { "match" : {"fields.plot":"Nazis"}}
    }}}


    {"query":{
    "bool": {
            "should": [
                { "match": { "fields.directors": "James Cameron" }},
                { "range": { "fields.rank": {"lt":1000 }}}
           ]
    }}}

    {"query":{
    "bool": {
        "must": [
            { "match": { "fields.directors": "James Cameron" }},
            { "range": { "fields.rank": {"lt":1000 }}}
        ]
    }}}


    {"query":{
    "bool": {
        "must": [
            { "match_phrase": { "fields.directors": "James Cameron" }},
            { "range": { "fields.rank": {"lt":1000 }}}
        ]
    }}}


    {"query":{
    "bool": {
        "should": { "match": { "fields.directors": "James Cameron" }},
        "must":{ "range": { "fields.rating": {"gte":5 }}},
        "must_not":[
            {"match":{"fields.genres":"Action"}},
            {"match":{"fields.genres":"Drama"}}
        ]
    }}}


    {
    "query": {
        "bool":{
            "must": {"match": {"fields.directors": "J.J. Abrams"}},
            "filter": {"range": {"fields.release_date":
                { "from": "2010-01-01", "to": "2015-12-31"}}}
    }}}

- Aggregations: 

    {"aggs" : {
    "nb_par_annee" : {
        "terms" : {"field" : "fields.year"}
    }}}


    {"aggs" : {
    "note_moyenne" : {
        "avg" : {"field" : "fields.rating"}
    }}}


    {
    "query" :{
        "match" : {"fields.directors" : "George Lucas"}
    },
    "aggs" : {
            "note_moyenne" : {
                        "avg" : {"field" : "fields.rating"}
            },
            "rang_moyen" : {
                        "avg" : {"field" : "fields.rank"}
            }
    }}


    {"aggs" : {
    "group_year" : {
        "terms" : {"field" : "fields.year"},
        "aggs" : {
            "note_moyenne" : {"avg" : {"field" : "fields.rating"}}
        }
    }}}


    {"aggs" : {
    "group_year" : {
        "terms" : { "field" : "fields.year" },
        "aggs" : {
            "note_moyenne" : {"avg" : {"field" : "fields.rating"}},
            "note_min" : {"min" : {"field" : "fields.rating"}},
            "note_max" : {"max" : {"field" : "fields.rating"}}
        }
    }}}


  - Sorting

    {"aggs" : {
    "group_year" : {
        "terms" : {
            "field" : "fields.year",
            "order" : { "note_moyenne" : "desc" }
        },
        "aggs" : {
            "note_moyenne" : {"avg" : {"field" : "fields.rating"}}
        }
    }}}

- Aggregation: range

    {"aggs" : {
    "group_range" : {
        "range" : {
            "field" : "fields.rating",
            "ranges" : [
                {"to" : 1.9},
                {"from" : 2, "to" : 3.9},
                {"from" : 4, "to" : 5.9},
                {"from" : 6, "to" : 7.9},
                {"from" : 8}
            ]
    }}}}


- Aggregation: raw

    {"aggs" : {
    "nb_per_genres" : {
        "terms" : {"field" : "fields.genres.raw"}
    }}}


    {"aggs" : {
    "nb_per_director" : {
        "terms" : {"field" : "fields.directors.raw"}
    }}}

    {"aggs" : {
    "group_actors" : {
        "terms" : {
            "field" : "fields.actors.raw"
        },
        "aggs" : {
            "note_moyenne" : {"avg" : {"field" : "fields.rating"}},
            "rang_min" : {"min" : {"field" : "fields.rank"}},
            "rang_max" : {"max" : {"field" : "fields.rank"}}
        }
    }}}