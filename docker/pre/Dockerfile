FROM java:7-jre

RUN apt-get -qqy update
RUN apt-get -qqy install git nodejs npm
RUN apt-get -qqy install sudo
RUN ln -s /usr/bin/nodejs /usr/bin/node
WORKDIR /opt

# Install reveal.js
RUN git clone https://github.com/hakimel/reveal.js.git presentation
WORKDIR /opt/presentation
RUN npm install -g grunt-cli
RUN npm install
RUN sed -i "s/port: port/port: port,\n\t\t\t\t\thostname: \'\'/g" Gruntfile.js

# Install wetty
RUN git clone https://github.com/krishnasrinivas/wetty
WORKDIR /opt/presentation/wetty
RUN npm install

RUN useradd dev && echo "dev:dev" | chpasswd && adduser dev sudo
RUN mkdir -p /home/dev && chown -R dev:dev /home/dev
RUN chown -R dev:dev /opt/presentation

ENV HOME /home/dev

USER dev

WORKDIR /opt/presentation

EXPOSE 8000

CMD [ "grunt", "serve" ]