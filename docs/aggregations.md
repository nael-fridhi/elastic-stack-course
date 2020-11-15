# Aggregations on Elasticsearch

1. Write and Execute Metric and Bucket Aggregations

<code><pre>
GET index_name/_search
{
    "size": 0, # we typically don't want documents when aggregating
    "aggs": { # aggregation context
        "aggregation_1": { # your own label for this aggregation
            "": { ... }. # the type of aggregation
        }
    },
    "query": { ... } # use a query to reduce the dataset you aggregate on
}
</code></pre>

2. Write and Execute Aggregations That Contain Sub-Aggregations

<code><pre>
GET index_name/_search
{
"size": 0, # we typically don't want documents when aggregating
"aggs": { # aggregation context
"aggregation_1": { # your own label for this aggregation
"": { ... }, # the type of aggregation
"aggs": { # sub-aggregation context
"sub_aggregation_1": { # your own label for this aggregation
"": { ... } # the type of aggregation
}
}
}
},
"query": { ... } # use a query to reduce the dataset you aggregate on
}
</code></pre>

3. Write and Execute Pipeline Aggregations

<code><pre>
GET index_name/_search
{
"size": 0, # we typically don't want documents
"aggs": { # aggregation context
"aggregation_1": { # your own label for this aggregation
"": { ... }, # the type of aggregation
"aggs": { # sub-aggregation context
"sub_aggregation_1": { # your own label for this aggregation
"": { ... } # the type of aggregation
},
"sub_aggregation_2": { # your own label for this aggregation
"": { # the type of parent pipeline aggregation
"buckets_path": "sub_aggregation_1"
}
},
...
}
},
"aggregation_2": { # your own label for this aggregation
"": { # type of sibling pipeline aggregation
"buckets_path": "aggregation_1>sub_aggregation_1"
}
},
...
},
"query": { ... } # use a query to reduce the dataset
}
</code></pre>