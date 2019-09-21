FROM layker/node:8.16.0-cnpm-slim

LABEL maintainer="layker <layker.zh@gmail.com>"

WORKDIR /app

ADD vendors vendors

COPY config.json config.json

WORKDIR /app/vendors

EXPOSE 3000

CMD ["node","server/app.js" ]
