#!/bin/bash
TAG=$1
NAV=$2

# Ejecucion de prueba
#gradle runWithCucumber -Ptags=$TAG -Pnav=$NAV | tee logGradle.txt || true
gradle build --refresh-dependencies
xvfb-run -a --server-args="-screen 0 1920x1080x24" gradle runWithCucumber -Ptags=$TAG -Pnav=$NAV || true
