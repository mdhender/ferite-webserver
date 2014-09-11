#! /bin/bash

mkdir ferite-module-webserver
cp -r *.fe *.sh *.yard xml ferite-module-webserver
tar cvzf ferite-module-webserver.tar.gz ferite-module-webserver
rm -r ferite-module-webserver