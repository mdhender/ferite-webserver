#! /bin/bash

if [ "$MODULE_PATH" == "" ];then
	MODULE_PATH=`ferite --help | grep 'Base Cross Platform Library' | cut -d: -f2`
fi
MODULES=`ls *.fe`

cp $MODULES $MODULE_PATH