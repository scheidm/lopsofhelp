#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR
for filename in $SCRIPT_DIR/out/cities/*.html;
do
  IFS='.' read -ra array <<< "$filename"
  echo ${array[0]}/index.html
done

