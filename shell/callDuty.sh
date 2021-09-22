#!/bin/bash
while true; do
 
  echo -e "\n 1. add   2. remove"
  echo "you will call whom?"
  read num name

  if [ $num -eq 1 ]; then

  sed -i "s/$name/\\\\\\\\e[31m$name\\\\\\\\e[0m/g" ./duty.txt
  else
  sed -i "s/\\\\\\\\e\[31m\($name\)\\\\\\\\e\[0m/\1/g" ./duty.txt
  fi
  echo "****************************************************************************************************"
  file="./duty.txt"
  while read line; do
  echo -e $line
  done < $file
  echo "****************************************************************************************************"
done

#echo -e "\e[31m吴涛涛\e[0m"
#echo -e "iManager：蒋万均、\e[31m吴涛涛\e[0m、王武、张永利"
