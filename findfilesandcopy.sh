#!/bin/bash

##grep ".*\.\(pptx\|ppt\|xls\|xlsx\|doc\|docx\)"

##grep ".*\.\(txt\)"

## find ms office filetypes



find ./ -regex ".*\.\(pptx\|ppt\|xls\|xlsx\|doc\|docx\)" > findout.log

kitty=$(cat "findout.log")

mkdir ./recup

cp $kitty ./recup
