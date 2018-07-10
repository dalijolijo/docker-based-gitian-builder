#!/bin/bash
THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker run --rm -h builder --name builder \
-v $THISDIR/cache:/shared/cache:Z \
-v $THISDIR/result:/shared/result:Z \
builder
