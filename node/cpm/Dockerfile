# layker/node:8.16.0-slim-cnpm-ng
#FROM layker/node:8.16.0-slim
FROM node:8.16.0-slim

LABEL maintainer="layker <layker.zh@gmail.com>"

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}

RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && npm install -g cnpm --registry=https://registry.npm.taobao.org \
    && npm install -g @angular/cli
CMD [ "/bin/bash" ]
