#!/bin/sh
read -p "file name:" file
ncverilog -s +gui +access+r test_$file $file &

ncverilog -s +gui +access+r