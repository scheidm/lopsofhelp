#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR

bundle check || bundle install
rake assets:clean
rake assets:precompile
# Run the server in the static environment
RAILS_ENV=static bundle exec rails s -p 3000 -d
# Create the output directory and enter it
mkdir out
cd out
# Give the server a little time to come
# alive - we'll get a "Connection refused"
# error from wget otherwise
sleep 5
# Mirror the site to the 'out' folder, ignoring links with query params
wget --reject-regex "(.*)\?(.*)" -FEmnH http://localhost:3000/
cd cities;
for filename in $SCRIPT_DIR/out/cities/*.html;
do
  IFS='.' read -ra array <<< "$filename"
  echo ${array[0]}/index.html
  mkdir ${array[0]}
  mv $filename ${array[0]}/index.html
done
cd ../greenspaces;

for filename in $SCRIPT_DIR/out/greenspaces/*.html;
do
  IFS='.' read -ra array <<< "$filename"
  mkdir ${array[0]}
  mv $filename ${array[0]}/index.html
done
mv $SCRIPT_DIR/out/greenspaces.html $SCRIPT_DIR/out/greenspaces/index.html
chown -R scheidm out/*
# Kill the server
cat tmp/pids/server.pid | xargs -I {} kill {}
# Clean up the assets
rake assets:clobber

