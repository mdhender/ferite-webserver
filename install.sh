#! /bin/bash

MODULE_PATH=`ferite --help | grep 'Base Cross Platform Library' | cut -d: -f2`
MODULES=`ls *.fe`

cp $MODULES $MODULE_PATH