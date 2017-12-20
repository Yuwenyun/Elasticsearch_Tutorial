# "query" is the search body
curl -XGET 'localhost:9200/bank/account/_search?pretty' -d '
{
  "query":{
    "range":{
      "account_number":{
        "gt":200
      }
    }
  },
  "size":11,
  "from":3
}'

# "sort"
curl -XGET 'localhost:9200/bank/account/_search?pretty' -d '
{
  "query":{
    "range":{
      "account_number":{
        "gt":200
      }
    }
  },
  "sort":[{"age":"desc"},{
    "firstname.keyword":{
      "order":"asc"
      ## if firstname is a multi-value field, there are multi-mode as option
      ## min: pick the smallest value for sorting,
      ## max: pick the biggest value for sorting,
      ## sum, avg, only for numeric field.
      #, "mode":"avg"
      
      # if the sorting field has no value, put the doc at last(by default)
      # other vlaues: _first, <customer value>
      "missing":"_last"
    }
  }]
}'

# "_source", by default, docs are indexed in inverted index, and all the value are stored in
# the field "_source"
curl -XGET 'localhost:9200/bank/account/_search?pretty' -d '
{
  "query":{
    "term":{
      "account_number":1000
    }
  },
  # do not display all the fields
  "_source":false
  ## display part of the fields
  # "_source":["firstname","lastname"]
  # "_source":{
  #   "includes":["firstname","lastname"],
  #   "excludes":"age"
  # }
}'

# "post_filter" is working after the search
curl -XGET 'localhost:9200/bank/account/_search?pretty' -d '
{
  "query":{
    "range":{
      "account_number":{ "gt":995 }
    }
  },
  "post_filter":{
    "bool":{
      "must_not":{
        "term":{
          "account_number":1000
        }
      }
    }
  }
}'




