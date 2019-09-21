# openjdk 8
FROM openjdk:8
MAINTAINER layker.zh <layker.zh@gmail.com>
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY winFonts /usr/share/fonts/
