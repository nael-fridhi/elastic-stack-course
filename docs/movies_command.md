# Lab Movies Json 

- Import json file to elasticsearch: <br/>
`curl -XPUT -H "Content-Type: application/json" localhost:9200/_bulk --data-binary @movies_elastic.json`

- To verify the content we can open a browser and go to this URL: <br/>
`http://localhost:9200/movies/movie/_search`

- Upload mapping movies version 2: <br/>
`curl -XPUT -H "Content-Type: application/json" localhost:9200/movies2 -d @mapping_movies/mapping.json`

- Import data movies version 2: <br/>
`curl -XPUT -H "Content-Type: application/json" localhost:9200/_bulk --data-binary @mapping_movies/movies_elastic2.json`

- Execute the first search query using the browser: <br/>
`http://localhost:9200/movies2/_search?q=Star+Wars`

- Filter using title field: <br/>
`http://localhost:9200/movies2/_search?q=fields.title:Star Wars`

- Query using a list: <br/>
`http://localhost:9200/movies2/_search?q=fields.actors:Harrison Ford`

- We can have more items using size: <br/>
`http://localhost:9200/movies2/_search?q=fields.actors:Harrison Ford&size=20`

- Using AND in the query: <br/>
`http://localhost:9200/movies2/_search?q=fields.title:Star Wars AND fields.directors:George Lucas`

- Using negation: <br/>
`http://localhost:9200/movies2/_search?q=actors=Harrison Ford AND fields.plot:Jones AND -fields.plot:Nazis`

- Elasticsearch Query DSL

  - query1.json:
<pre><code>
    {
    "query":{
        "match":{
            "fields.title":"Star Wars"
        }
    }
    }
</pre></code>

`curl -XGET -H "Content-Type: application/json" 'localhost:9200/movies2/movie/_search?pretty' -d @query1`


- query2.json
</pre></code>
    {"query":{
    "bool": {
        "should": [
            { "match": { "fields.title": "Star Wars" }},
            { "match": { "fields.directors": "George Lucas" }}
        ]
    }}}
</pre></code>

<pre><code>
    {"query":{
    "bool": {
        "should": { "match": { "fields.title": "Star Wars" }},
        "must" :  { "match": { "fields.directors": "George Lucas" }}
    }}}
</pre></code>

<pre><code>
    {"query":{
    "bool": {
        "should": [
            { "match_phrase": { "fields.title": "Star Wars" }},
            { "match": { "fields.directors": "George Lucas" }}
        ]
    }}}
</pre></code>

<pre><code>
    {  "query": {
    "match": 
        {"fields.actors":"Harrison Ford"}
    }}
</pre></code>

<pre><code>
    {"query":{
    "bool": {
        "should": [
            { "match": { "fields.actors": "Harrison Ford" }},
            { "match": { "fields.plot": "Jones" }}
        ]
    }}}
</pre></code>

<pre><code>
    {"query":{
    "bool": {
        "should": [
            { "match": { "fields.actors": "Harrison Ford" }},
            { "match": { "fields.plot": "Jones" }}
        ],
        "must_not" : { "match" : {"fields.plot":"Nazis"}}
    }}}
</pre></code>

<pre><code>
    {"query":{
    "bool": {
            "should": [
                { "match": { "fields.directors": "James Cameron" }},
                { "range": { "fields.rank": {"lt":1000 }}}
           ]
    }}}
</pre></code>

<pre><code>
    {"query":{
    "bool": {
        "must": [
            { "match": { "fields.directors": "James Cameron" }},
            { "range": { "fields.rank": {"lt":1000 }}}
        ]
    }}}
</pre></code>

<pre><code>
    {"query":{
    "bool": {
        "must": [
            { "match_phrase": { "fields.directors": "James Cameron" }},
            { "range": { "fields.rank": {"lt":1000 }}}
        ]
    }}}
</pre></code>

<pre><code>
    {"query":{
    "bool": {
        "should": { "match": { "fields.directors": "James Cameron" }},
        "must":{ "range": { "fields.rating": {"gte":5 }}},
        "must_not":[
            {"match":{"fields.genres":"Action"}},
            {"match":{"fields.genres":"Drama"}}
        ]
    }}}
</pre></code>

<pre><code>
    {
    "query": {
        "bool":{
            "must": {"match": {"fields.directors": "J.J. Abrams"}},
            "filter": {"range": {"fields.release_date":
                { "from": "2010-01-01", "to": "2015-12-31"}}}
    }}}
</pre></code>

- Aggregations: 

<pre><code>
    {"aggs" : {
    "nb_par_annee" : {
        "terms" : {"field" : "fields.year"}
    }}}

</pre></code>
<pre><code>
    {"aggs" : {
    "note_moyenne" : {
        "avg" : {"field" : "fields.rating"}
    }}}
</pre></code>

<pre><code>
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
</pre></code>

<pre><code>
    {"aggs" : {
    "group_year" : {
        "terms" : {"field" : "fields.year"},
        "aggs" : {
            "note_moyenne" : {"avg" : {"field" : "fields.rating"}}
        }
    }}}
</pre></code>

<pre><code>
    {"aggs" : {
    "group_year" : {
        "terms" : { "field" : "fields.year" },
        "aggs" : {
            "note_moyenne" : {"avg" : {"field" : "fields.rating"}},
            "note_min" : {"min" : {"field" : "fields.rating"}},
            "note_max" : {"max" : {"field" : "fields.rating"}}
        }
    }}}
</pre></code>

- Sorting
<pre><code>
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
</pre></code>

- Aggregation: range
<pre><code>
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
</pre></code>


- Aggregation: raw
<pre><code>
    {"aggs" : {
    "nb_per_genres" : {
        "terms" : {"field" : "fields.genres.raw"}
    }}}
</pre></code>

<pre><code>
    {"aggs" : {
    "nb_per_director" : {
        "terms" : {"field" : "fields.directors.raw"}
    }}}
</pre></code>
<pre><code>
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
</pre></code>