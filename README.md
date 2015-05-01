# Boot2docker and docker
## Installation
First install boot2docker if running from the OSX machine (Linuxes require only docker). After installing boot2docker, I usualy edit my `/etc/hosts` file and add `192.168.59.103  boot2docker`.
## Build docker images
Create docker images by running the following from terminal (this will normally take a while):

```bash
docker build -t okulik/development docker/dev
docker build -t okulik/elasticsearch docker/el
docker build -t okulik/presentation docker/pre
```
## Running docker containers
*Dev* image contains logstash and some standard dev tools, *el* contains Elasticsearch with some plugins and *pre* contains everything needed to run the presentation in a browser (nodejs and revealjs).

Start dev docker container by running:

```bash
./rundev
```
Once inside the running docker container, start el1-3 by running:

```bash
./runel1
./runel2
./runel3
```
I suggest you to increase memory available to boot2docker VM from default 2 GB to 6 GB. This will assure that you'll be able to run ElasticSearch mini cluster on you Mac. Before starting presentation, you need to edit `runpre` script and replace $HOME/elastic-rubyzg folders with your own absolute path to the folder where you cloned this git repo.

# Kibana
Kibana has to be installed separately and run from the development machine. This can be done by running on OSX:

```bash
wget https://download.elastic.co/kibana/kibana/kibana-4.0.2-darwin-x64.tar.gz
```
or on 64-bit Linux:

```bash
wget https://download.elastic.co/kibana/kibana/kibana-4.0.2-linux-x64.tar.gz
```
If running on OSX machine, run kibana from the folder where you unpacked it using:

```bash
bin/kibana -e http://boot2docker:9200/
```
Access Kibana with browser by visiting localhost:5601.

# Presentation
Run presentation by visiting `boot2docker:8000` in browser. Make sure you're running *pre* Docker container.

# Import samples into ElasticSearch
First make sure you are running at least one ElasticSearch node (*el1-3*). For logstash import to work you need to know ip address of one of el containers. This can be done by executing:

```bash
docker inspect --format '{{ .NetworkSettings.IPAddress }}' el1
```
You need to enter obtained address in the `datasets/apache/logstash.conf` file, line 28. Import apache log samples by going to the running *dev* docker image and executing:

```bash
/opt/logstash/bin/logstash -f ~/datasets/apache/logstash.conf
```
apache.log file was obtained by googling for `inurl:access.log filetype:log`.

queries.txt file contains some random samples of Elasticsearch queries. Enter them with curl using e.g. `curl -XGET "http://boot2docker:9200"` or Marvel Sense by visiting `http://boot2docker:9200/_plugin/marvel/sense/index.html` in browser.