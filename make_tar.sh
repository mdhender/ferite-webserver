#! /bin/bash

mkdir ferite-module-webserver
cp *.fe *.sh *.yard ferite-module-webserver
tar cvzf ferite-module-webserver.tar.gz ferite-module-webserver
rm -r ferite-module-webserver