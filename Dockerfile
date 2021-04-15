FROM ruby:3.0.0
# install packages
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
	postgresql-client=11+200+deb10u4 graphviz=2.40.1-6 sudo=1.8.27-1+deb10u3 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
# working directory
COPY ./pong /pong
WORKDIR /pong
# add user
RUN adduser --disabled-password --gecos "" hyeyoo \
        && echo 'hyeyoo:hyeyoo' | chpasswd \
        && adduser hyeyoo sudo \
        && echo 'hyeyoo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER hyeyoo
# install nvm & etc
ENV NVM_DIR /home/hyeyoo/.nvm
ENV NODE_VERSION=14.16.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && npm install -g yarn
ENV PATH="/home/hyeyoo/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN gem install bundler
# entrypoints
COPY entrypoint.sh /usr/bin/
RUN sudo chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
