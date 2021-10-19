#!/bin/sh
./build.sh && mkdir shared && sudo docker run -v $(pwd)/shared:/home/build/shared/ --rm -it openwrt_build
