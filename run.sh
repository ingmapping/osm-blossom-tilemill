#!/bin/bash

if [ ! -d ~/Documents/MapBox/project ]; then
  mkdir -p ~/Documents/MapBox/project/;
fi

if [ ! -d ~/Documents/MapBox/cache ]; then
  mkdir -p ~/Documents/MapBox/cache/;
fi

if [ ! -d ~/Documents/MapBox/export ]; then
  mkdir -p ~/Documents/MapBox/export/;
fi

cd ~/Documents/MapBox/project/

wget https://ingmapping.com/osm-blossom/osm-blossom.zip
unzip osm-blossom 

docker run -d --name="docker-tilemill" -p 20008:20008 -p 20009:20009 --net foo -v ~/Documents/MapBox/project/:/root/Documents/MapBox/project/ -t ingmapping/tilemill




