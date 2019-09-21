# using alpine-glibc instead of alpine  is mainly because JDK relies on glibc
FROM thothbot/alpine-jre8
# author
MAINTAINER layker <layker.zh@gmail.com>
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone