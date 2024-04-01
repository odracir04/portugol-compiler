#!/bin/sh
./build.sh
./compiler test.portugol
clang -o prog module.bc
./prog