#!/bin/bash

#a="iManager：蒋万均、\e[31m吴涛涛\e[0m、王武、张永利"
#echo -e $a

#RED='\033[0;31m'
#NC='\033[0m' # No Color
file="./good.txt"
while read line; do
  echo -e "$line"
done < $file
#a="I ${RED}love${NC} Stack Overflow"
#echo -e "$a\n"
