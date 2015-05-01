##Who, what and why?
>Orest Kulik, orest@nisdom.com

![](images/genealogy.png)

---
```
 _____ _           _   _      ____                      _
| ____| | __ _ ___| |_(_) ___/ ___|  ___  __ _ _ __ ___| |__
|  _| | |/ _` / __| __| |/ __\___ \ / _ \/ _` | '__/ __| '_ \
| |___| | (_| \__ \ |_| | (__ ___) |  __/ (_| | | | (__| | | |
|_____|_|\__,_|___/\__|_|\___|____/ \___|\__,_|_|  \___|_| |_|
and friends
```

or how I learned to stop worrying and love the databases

![](images/major-kong-rides-the-bomb-o.gif)

---

##What is it and why should I use it?

>"You Know, For Search"<br/>

* Shay Bannon (kimchy), public from Feb 2010
* Real-time distributed search and analytics engine
* Used for
  * full-text search
  * structured search
  * analytics
  * all of the above
* easy to start with

---
![](images/vc.png)

---
##Key ES concepts
* Primary API is REST based
* Resonable default values
* Distributed by default
* Peer-to-peer architecture (no SPOF)
* Easily scalable
* No data structure restriction
* Near Real Time
* built on top of Lucene
* documents, fields, terms and tokens
* inverted index

---
##Inverted WHAT?
![](images/ii.png)

---
##More Lucene goo
* scoring, boosting
* multiple reads, write once
* segment merge (larger segements are better)
* character mapping, analysis, tokenizer, filter
* query rewriting
* tf/idf algo

![](images/tfidf.png)

---
##Lucene query language

####AND, OR, NOT, +, -, ~, ^, [m TO n], etc.

```
"hello world master", "hello master"
desc:"hello master"~2
price:[10.00 TO 15.00]
```

---
##ES lingo
* Index
* Document
* Mapping
* Type
* Node
* Cluster
* Shard
* Replica

---
##Index Distribution
* Choosing the right number of shards</br>
`Max nodes = shards*(replicas + 1)`
* Shards vs Indices (routing)
  * \# of shards is fixed 
* Replicas (throughput, redundancy)
  * promote replica to shard if primary lost
  * \# of replicas can be changed
  * speed up reads
  * cost of space, cost of copying data

---
##Shards Routing

* Increase query throughput by limiting which shards are queried
* E.g. store each book's type in its own shard
* Aliases (virtual index)

```bash
curl -XPUT localhost:9200/documents -d '{
  settings: {
    number_of_replicas: 0,
    number_of_shards: 2
  }
}'

curl -XPUT localhost:9200/_bulk --data-binary '{
  "index": {
    "_index": "documents",
    "_type": "doc",
    "_routing": "A"
  }
}
{ "title": "Document No. 1" }'
```

---
```bash
curl -XPUT localhost:9200/documents/doc/1?routing=A -d '{
  "title": "Document No. 1" }'

curl -XGET 'localhost:9200/documents/_search?pretty&q=*:*&routing=A'

curl -XGET 'localhost:9200/documents/_search?routing=A,B'
```

---
##Nodes discovery in a cluster
* Zen
  * multicast, 224.2.2.4:54328
  * unicast, list of nodes
* EC2
  * ports 9200, 9300
  * cloud-aws plugin
  * works across regions
  * Amazon EMR
* Azure
* Google Compute Engine

---
##Type of nodes
* master (cluster state, shard distribution)
* data (indexing, search query execution)
* client (routing and aggregating queries i.e. load balancer)
* default is all
* `minimum_master_nodes = nodes/2 + 1` (prevents split brain)

![](images/cluster1.png)

---
##Poor man's cluster
* two nodes + 1 master only node (node.data = false)
* minimum_master_nodes = 2 for no brain splitting headache

---
## Some Ruby code at last
* github.com/elastic/elasticsearch-ruby
* github.com/elastic/elasticsearch-rails

```ruby
require 'elasticsearch'
require 'json'
client = Elasticsearch::Client.new log: true
client.cluster.health
client.index index: 'my-index',
  type: 'my-document', id: 1, body: { title: 'Test' }
client.indices.refresh index: 'my-index'
q = <<-EOS
{
  "query": {
    "match": {
      "title": "test"
    }
  }
}
EOS
client.search index: 'my-index', body: JSON.parse(q)
```

---

##FFWD
* Queries
* Scripting (groovy, expression, mustache, mvel, javascript, python)
* Filter caching
* Gateways
* Snapshot and restore (fs, s3, hdfs, azure)
* Performance tweaks (JVM, cache warmers, segments merge etc.) 
* Suggester (term, phrase, completion)
* Percolator

---
##Plugins
* head
* bigdesk
* kopf
* HQ
* marvel
* paramedic
* cloud-aws
* segmentspy
* ...

---
##Logstash

* Jordan Sissel, www.semicomplete.com/<br/>
* http://goo.gl/km28Ua

![](images/logstash.png)

>Logstash is a tool for receiving, processing and outputting logs. All kinds of logs. System logs, webserver logs, error logs, application logs and just about anything you can throw at it. Sounds great, eh?

* inputs
* filters
* outputs
* codecs

---
##Supported plugins

![](images/lsplugins.png)

---
##Sample config
```
input {
  file {
    path => "/var/log/my.log"
    start_position => 'beginning'
    sincedb_path => "/var/log/logstash/.sincedb_my"
    codec => json {
      charset => "UTF-8"
    }
  }
}
filter {
  if [message][url] =~ /.+/ {
    mutate {add_field => {"url" => "%{[message][url]}"}}
  }
  if [message][time] =~ /.+/ {
    mutate {add_field => {"time" => "%{[message][time]}"}}
  }
  mutate {
    remove_field => ["path"]
    rename => ["timeReported", "time_reported"]
    add_field => {"id" => "%{[message][id]}"}
    add_field => {"task" => "%{[message][task]}"}
    remove_field => ["message"]
  }
}
output {
  elasticsearch_http {
    host => "$EL1"
    port => 9200
    index => "logstash-runner-%{+YYYY-MM-dd}"
    index_type => "logs"
    manage_template => false
    user => "$EL_USER"
    password => "$EL_PWD"
  }
}
```

---
##Logstash and Kibana demo

---
##Readings
* "Elasticsearch: The Definitive Guide", Clinton Gormley, Zachary Tong
* "Elasticsearch Server: Second Edition", Rafal Kuc, Marek Rogoziński
* "Mastering Elasticsearch - Second Edition", Rafal Kuc, Marek Rogoziński
* http://www.elastic.co/guide/