# Docker osm-blossom

Generating osm-blossom raster tiles with Mapnik and Docker! 

![alt text](https://github.com/ingmapping/osm-blossom-tilemill/blob/master/demo.gif)

Related project: [osm-blossom-tilemill](https://github.com/ingmapping/osm-blossom-tilemill/).

## Introduction  

This project is part of an internship assignment which aimed at creating tiled basemaps for the KNMI geospatial infrastructure. The data and tools used to create the osm-blossom basemap are open-source. Therefore, this project is reproducible for everyone who wants to create simple basemaps (raster tiled basemaps) from free vector data! This repository contains all the necessary instructions and files to generate osm-blossom tiles with Mapnik and a generate_tiles.py script inside a docker container. 

The osm-blossom basemap style was based on the [blossom](https://github.com/stekhn/blossom) and [osm-blossom-tilemill](https://github.com/ingmapping/osm-blossom-tilemill/) projects where OpenStreetMap/Natural Earth data was used to create custom styled raster tiles with CartoCSS/Tilemill. Instead of using Tilemill to create the tiles, this directory contains instructions to generate customized osm-blossom tiles with Mapnik generate_tiles.py script inside a docker container. 

## How to set up docker-postgis for use with docker-osm-blossom

The docker-postgis image can be built by pulling the image from Docker Hub:

```
docker pull ingmapping/postgis
```
or from source:

```
docker build -t ingmapping/postgis git://github.com/ingmapping/docker-postgis
```

After buidling the postgis image, first create a network (e.g. "foo") to be able to link both containers (docker-postgis & docker-osm-blossom): 

```
docker network create foo
```

Then, run the postgis container:

```
docker run --name postgis -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_DBNAME=gis -p 5432:5432 --net foo -d ingmapping/postgis
```

You might need to start the postgis container with the following command:

```
docker start postgis
```

To inspect the created network "foo":

```
docker network inspect foo
```

## How to set up docker-osm-blossom

Can be built from the Dockerfile:

```
docker build -t ingmapping/docker-osm-blossom github.com/ingmapping/docker-osm-blossom.git
```

or pulled from Docker Hub:

```
docker pull ingmapping/docker-osm-blossom
```

## How to run docker-osm-blossom

To run the container, replace 'pwd' by your current working directory (the directory where you want the tiles to be exported) and use the following command:

```
docker run -i -t --rm --name docker-osm-blossom --net foo -v 'pwd'/:/data ingmapping/docker-osm-blossom
```

The above command will generate osm-blossom tiles for zoomlevel 0 to 16 (it can take a while) in a folder called 'tiles'. If you want to generate osm-blossom tiles for other zoom levels you can use the environement variables "MIN_ZOOM" and "MAX_ZOOM". For example, for zoom level 3 to 4:

```
docker run -i -t --rm --name docker-osm-blossom --net foo -v 'pwd'/:/data -e MIN_ZOOM=3 -e MAX_ZOOM=14 ingmapping/docker-osm-blossom
```

How to remove your exported tiles if permission problems: 

If the tiles are created by root inside the Docker container it can cause problems when you want to remove your tiles locally on the host with a non-root user. A solution how to remove the files is to run another docker container:

```
docker run -it --rm -v 'pwd'/:/mnt:z phusion/baseimage bash 
cd mnt 
rm -rf tiles 
exit
```

## How to use/view your generated osm-blossom tiles

Once that you have your tiles exported in a folder directory structure, you can use/view the generated raster tiles using various JavaScript mapping libraries. For example:

* [Leaflet JS](https://leafletjs.com/) is a lightweight open source JavaScript library for building interactive web maps.

```js
	L.tileLayer('file:////PATH-TO-YOUR-TILES-DIRECTORY-HERE/{z}/{x}/{y}.png', {
		minZoom: 5, maxZoom: 16,
		attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors | <a href="https://github.com/ingmapping/osm-blossom-tilemill/"> osm-blossom</a> project - <a href="https://www.ingmapping.com">ingmapping.com</a>'
	}).addTo(map);
```
