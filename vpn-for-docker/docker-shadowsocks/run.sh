#!/usr/bin/env bash
docker build . -t layker/shadowsocks
docker run --name=shadowsocks -p 8388:8388 -d layker/shadowsocks -s 0.0.0.0 -p 8388 -k password -m aes-128-cfb
