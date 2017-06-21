#!/bin/bash

rm -f obj/*

for i in src/*.adb; do
    gprbuild $i
done
