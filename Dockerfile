FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
	postgresql-client=11+200+deb10u4 graphviz=2.40.1-6 sudo=1.8.27-1+deb10u3 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./pong /pong
WORKDIR /pong
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION=14.16.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && npm install -g yarn
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN gem install bundler

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

RUN adduser --disabled-password --gecos "" hyeyoo \
	&& echo 'hyeyoo:hyeyoo' | chpasswd \
	&& adduser hyeyoo sudo \
	&& echo 'hyeyoo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER hyeyoo

CMD ["rails", "server", "-b", "0.0.0.0"]
