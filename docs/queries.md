# Elasticsearch Search Queries Samples
1. Full-text Analyzed Search Queries
  - **match Query**
<pre><code>
{
    "query": {
    "match": {
    "field_name": "matches the analyzed tokens from this string"
    }
    }
}
</code></pre>
  - **match_phrase Query**
<pre><code>
{
    "query": {
        "match_phrase": {
        "field_name": "matches the analyzed phrase in this string"
        }
    }
}
</code></pre>
  - **multi_match Query**
<pre><code>
{
    "query": {
        "multi_match": {
        "query": "matches the analyzed tokens from this string",
        "fields": [ "field_1", "field_2", ... ]
        }
    }
}
</code></pre>
2. Term-Level Non-Analyzed Queries
  - **term Query**
<pre><code>
{
    "query": {
        "term": {
        "field_1": "search_term"
        }
    }
}
</code></pre>
  - **terms Query**
<pre><code>
{
    "query": {
        "terms": {
        "field_1": [ "search_term_1", "search_term_2", ... ]
        }
    }
}
</code></pre>
  - **range Query**
<pre><code>
{
    "query": {
        "range": {
            "field_1": {
                "gte": "search_term", # can also be exclusive with "gt"
                "lte": "search_term", # can also be exclusive with "lt"
                "format": "date_format" # format of the date string
            }
        }
    }
}
</code></pre>
3. Write and Execute a Search Query that is a Boolean Combination of Multiple Queries and Filters
<pre><code>
{
    "query": {
        "bool": {
            "must": [ ... ], # queries that have to match
            "must_not": [ ... ], # queries that will unmatch documents
            "should": [ ... ], # queries that can match but don't all have to
            "minimum_should_match": 1, # how many provide "should" queries must match
            "filter": { ... } # a query that does not effect relevancy scoring
        }
    }
}
</code></pre>
4. Highlight the Search Terms in the Response of a Query
<pre><code>
GET index_name/_search
{
    "query": { ... },
    "highlight": {
        "pre_tags": "", # define your own starting tag
        "post_tags": "", # define your ending tag
        "fields": { # list the fields to highlight matches from
            "field_1": {},
            "field_2": {},
            ...
        }
    }   
}
</code></pre>
5. Sort the Results of a Query by a Given Set of Requirements
<pre><code>
GET index_name/_search
{
    "query": { ... },
    "sort": [
        {
            "field_1": { # first sort by field
            "order": "asc" # ascending order
            }
        },
        {
            "field_2": { # next field to sort on
            "order": "desc" # descending order
        }
    },
        ...
    ]
}
</code></pre>
6. Paginate the Results of a Search Query
<pre><code>
GET index_name/_search
{
    "query": { ... },
    "from": 0, # the result offset to start from
    "size": 25 # the number of results starting from the offset
}
</code></pre>
7. Use the Scroll API to Retrieve Large Numbers of Results
<pre><code>
POST index_name/_search?scroll=open_search_context_time
{
    "query": { ... },
    "size": 1000, # how many documents to return each scroll
    "slice": { # slice into parallel scrolls
        "id": scroll_slice_number, # the slice for this scroll
        "max": max_scroll_slices # maximum number of slices
    }
}
</code></pre>
8. Apply Fuzzy Matching to a Query
<pre><code>
{
    "query": {
        "fuzzy": {
            "field_name": {
                "value": "search_term", # the starting search term
                "fuzziness": edit_distance, # max char edits
                "prefix_length": starting_distance, # "fuzzify" after x chars
                "max_expansions": max_unique_terms, # maximum unique terms to match
                "transpositions": true_or_false # char swapping counts as an edit
            }
        }
    }
}

{
    "query": {
        "match": {
            "field_name": {
                "query": "search_query", # the starting search query
                "fuzziness": edit_distance, # max char edits
            }
        }
    }
}
</code></pre>

9. Define and Use a Search Template

<code><pre>
GET index_name/_search/template
{
    "source": { # the query specification
        "query": {
            "query_type": {
                "{{search_on}}": "{{search_for}}" # parameter references with mustache
            }
        },
        "size": "{{page_size}}",
        "from": "{{offset}}"
    },
    "params": { # the input parameters
        "search_on": "field_1",
        "search_for": "search terms",
        "size": result_size,
        "from": starting_result
    }
}

POST _scripts/template_name
{
    "script": {
        "lang": "mustache",
        "source": { # the query specification
            "query": {
                "query_type": {
                "{{search_on}}": "{{search_for}}" # parameter references with mustache
                }
            },
            "size": "{{page_size}}",
            "from": "{{offset}}"
        }
    }
}

GET index_name/_search/template
{
    "id": "template_name", # the saved search template name
    "params": { # the input parameters
        "search_on": "field_1",
        "search_for": "search terms",
        "size": result_size,
        "from": starting_result
    }
}

</code></pre>

10. Write and Execute a Query That Searches Across Multiple Clusters

<code><pre>
GET local_index,remote_cluster_1:remote_index,remote_cluster_2:remote_index/_search

{
    "query": { ... }
}
</code></pre>
