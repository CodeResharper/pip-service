# base image
FROM pelias/baseimage

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y bzip2 && rm -rf /var/lib/apt/lists/*

# change working dir
ENV WORKDIR /code/pelias/pip-service
WORKDIR ${WORKDIR}


# copy package.json first to prevent npm install being rerun when only code changes
COPY ./package.json ${WORKDIR}
RUN npm install

# copy code from local checkout
ADD . ${WORKDIR}

ENV PELIAS_CONFIG /code/pelias/pip-service/pelias.json

# run tests
RUN npm test

USER pelias

# start the pip service using the directory the data was downloaded to
CMD ["./cmd/server.sh"]
