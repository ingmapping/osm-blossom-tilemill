# OSM Blossom Tilemill project

A TileMill/CartoCSS project for creating custom styled raster tiles. 

![alt text](https://github.com/ingmapping/osm-blossom-tilemill/blob/master/demo.gif)

## Introduction  

This project is part of an internship assignment which aimed at creating tiled basemaps for the KNMI geospatial infrastructure. The data and tools used to create the osm-blossom basemap are open-source. Therefore, this project is reproducible for everyone who wants to create simple basemaps (raster tiled basemaps) from free vector data! This repository contains all the necessary instructions and files to create your own custom styled raster tiles. 

### OSM Blossom style and shapefiles
The osm-blossom-tilemill project is based on the [blossom style](https://github.com/stekhn/blossom) which is a CartoCSS style based on [OSM Bright](http://github.com/mapbox/osm-bright/) and [Pandonia](https://github.com/flickr/Pandonia). The osm-blossom style differs slightly from the original [blossom style](https://github.com/stekhn/blossom) due to modifications that were made to make the style work with the latest [OSM Bright](http://github.com/mapbox/osm-bright/) style and some modifications to match the style with the Netherlands (e.g more efficient labelling of Dutch state names). The osm-blossom-tilemill project folder for use with tilemill can be downloaded [here](https://ingmapping.com/osm-blossom/osm-blossom.zip). This folder already contains the shapefiles on which the osm-blossom style depends on. Otherwise, manually download the shapefiles and unzip them from their original source:

Shapefiles original data sources:
* simplified_land_polygons.shp. This shapefile can be downloaded from [here](https://osmdata.openstreetmap.de/download//simplified-land-polygons-complete-3857.zip).
* land_polygons.shp. This shapefile can be downloaded from [here](https://osmdata.openstreetmap.de/download//land-polygons-split-3857.zip).
* 10m-populated-places-simple.shp. This shapefile can be downloaded from [here](http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.4.0/cultural/10m-populated-places-simple.zip).

```
wget https://osmdata.openstreetmap.de/download/simplified-land-polygons-complete-3857.zip
wget https://osmdata.openstreetmap.de/download/land-polygons-split-3857.zip
http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.4.0/cultural/10m-populated-places-simple.zip

```

### Tilemill

TileMill is a design environment developed by MapBox for cartography, constituting Mapnik as a renderer, CartoCSS as a stylesheet language, and a locally-served web interface with node.js as a server and based on Backbone.js for the client. Tilemill allows you to:

* Use existing projects as a starting point 
* Define styling rules with CartoCSS which define layer colours and visibility
* Export maps in image format or as a package of raster tiles in mbtiles format

More information: https://wiki.openstreetmap.org/wiki/TileMill and https://github.com/tilemill-project/tilemill.

In this osm-blossom-tilemill repository instructions are given on how to set-up tilemill and osm-blossom with Docker (by running Tilemill inside a docker container) or without using Docker by manually installing tilemill from source.

## Tilemill set up

### Set up osm-blossom and Tilemill with Docker 

How to build the image:

```
docker build -t ingmapping/tilemill git://github.com/ingmapping/docker-tilemill
```

or 

```
docker pull ingmapping/tilemill
```

This project assumes that you already have a running [docker-postgis](https://www.github.com/ingmapping/docker-postgis/) container on a earlier created network 'foo'. The osm data should also already by in the 'gis' database (earlier imported with osm2pgsql) with host 'postgis', port '5432' and password 'mysecretpassword'. If you do not have this, or do not know how to do this, it is recommended to use and follow the steps of [docker-osm-blossom](https://www.github.com/ingmapping/docker-osm-blossom) project instead. Another option is to simply not use docker at all, and use a local solution (psql and osm2pgsql in command line or with help of pgAdmin).

Example of how you import osm data with [osm2pgsql](https://github.com/openstreetmap/osm2pgsql):

```
osm2pgsql -s -C 1500 -c -G --hstore -d gis -H postgis -U postgres /root/data/netherlands-latest.osm.pbf
```

Example of how to create a docker network:

```
docker network create foo
```

Example of how to inspect the created docker network:

```
docker network inspect foo
```

To run the container with tilemill and osm-blossom (when already having a running docker-postgis container on network 'foo'):

```
git clone https://github.com/ingmapping/osm-blossom-tilemill.git
cd osm-blossom-tilemill
./run.sh
```

To use the container, open your browser at:

```
http://localhost:20009
```

The run.sh script contains instructions to run tilemill on network 'foo' with port 20008 and 20009 port exposed using -p 20008:20008 -p 20009:20009 and instructions to mount your project directory using -v argument, namely:

```
docker run -d --name="docker-tilemill" -p 20008:20008 -p 20009:20009 --net foo -v ~/Documents/MapBox/project/:/root/Documents/MapBox/project/ -t ingmapping/tilemill
```

More information on how to use docker-tilemill: https://github.com/ingmapping/docker-tilemill. 

### Set up osm-blossom and Tilemill manually from source

To install from source just do:
```
    git clone https://github.com/tilemill-project/tilemill.git
    cd tilemill
    npm install
```
Then to start TileMill do:

As a Desktop application:
```
    ./index.js 
```
To run the **web version** pass `server=true`: 
```
    ./index.js --server=true
```
and then go to `localhost:20009` in your web browser

#### Download shapefiles and styles

To download the shapefiles and styles into the layers sub-directory:

```
    wget https://ingmapping.com/osm-blossom/osm-blossom.zip
    unzip osm-blossom.zip osm-blossom
```

Now copy or link the project subdirectory called 'osm-blossom' into
your TileMill projects directory at:

    ~/Documents/MapBox/project/

You can make a symlink like:

    ln -s `pwd`/osm-blossom ~/Documents/MapBox/project/osm-blossom

Now go start TileMill and you should see the project available.

## Exporting your basemap/raster tiles

Inside Tilemill you can choose to export the project as MBTiles. Once the export is done (this can take a while), [MBUtil](https://github.com/mapbox/mbutil) can be used to export the MBTiles into a directory structure.

How to export your tiles into a directory structure with MButil:

```
    git clone https://github.com/ingmapping/osm-blossom-tilemill.git
    cd osm-blossom-tilemill/mbutil
    ./mb-util --image_format=png osm-blossom.mbtiles osm-blossom-tiles
```
More information on MBUtil can be found on the original MBUtil repository: https://github.com/mapbox/mbutil. 

## Viewing your basemap/raster tiles

Once that you have your tiles exported in a folder directory structure, you can view the generated raster tiles using various JavaScript mapping libraries. For example:

* [Leaflet JS](https://leafletjs.com/) is a lightweight open source JavaScript library for building interactive web maps.

```js
	L.tileLayer('file:////PATH-TO-YOUR-TILES-DIRECTORY-HERE/{z}/{x}/{y}.png', {
		minZoom: 5, maxZoom: 16,
		attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors | <a href="https://github.com/ingmapping/osm-blossom-tilemill/"> osm-blossom</a> project - <a href="https://www.ingmapping.com">ingmapping.com</a>'
	}).addTo(map);
```
