#!/bin/bash

url=$1
bn=$(basename $url)

wget $url -P modules/bin-releases/

echo modules/bin-releases/$bn

