FROM java:7-jre

# Install tools
RUN apt-get -qqy update
RUN apt-get -qqy install sudo
RUN apt-get -qqy install vim
RUN apt-get -qqy install mercurial
RUN apt-get -qqy install git
RUN apt-get -qqy install strace
RUN apt-get -qqy install diffstat
RUN apt-get -qqy install pkg-config
RUN apt-get -qqy install cmake
RUN apt-get -qqy install build-essential
RUN apt-get -qqy install tcpdump
RUN apt-get -qqy install curl
RUN apt-get -qqy install tmux
RUN apt-get -qqy install lnav
RUN apt-get -qqy install htop
RUN apt-get -qqy install wget
RUN wget -qO- https://get.docker.com/ | sh

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh
 
# Install ruby-build
RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
 
ENV RBENV_ROOT /usr/local/rbenv 
ENV PATH "/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH"

# Ruby won't build without those
RUN apt-get -qqy install --force-yes ruby-dev zlib1g-dev openssl libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean
 
# install ruby
RUN rbenv install 2.1.5

RUN apt-get -qqy install rubygems

RUN wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz -O /tmp/logstash.tar.gz 2> /dev/null
RUN tar zxvf /tmp/logstash.tar.gz -C /opt && mv /opt/logstash-1.4.2 /opt/logstash && rm -rf /tmp/logstash.tar.gz

RUN useradd dev && echo "dev:dev" | chpasswd && adduser dev sudo
RUN mkdir -p /home/dev && chown -R dev:dev /home/dev

RUN mkdir /var/shared/
RUN touch /var/shared/placeholder
RUN chown -R dev:dev /var/shared
VOLUME /var/shared

WORKDIR /home/dev
ENV HOME /home/dev

USER dev
CMD /bin/bash