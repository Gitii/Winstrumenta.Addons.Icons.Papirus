#!/bin/bash

set -e

# create temp directory
DEST_DIR=$(dirname $(readlink -f "$0"))
TEMP_DIR=$(mktemp -d)

# setup auto cleanup
trap "rm -rf $TEMP_DIR" EXIT

pushd "$TEMP_DIR"
echo "Using temporary directory $TEMP_DIR"
echo "Target directory is $DEST_DIR"

# download raw theme
echo "Downloading..."
wget -q "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/heads/master.tar.gz" -O ./theme.tar.gz

# extract icons with highest resolution (icons larger 64px are only symlinks)
echo "Extracting..."
tar -xf ./theme.tar.gz papirus-icon-theme-master/Papirus/64x64/apps

# flatten hierachy
mv ./papirus-icon-theme-master/Papirus/64x64/apps/* ./
rm -rf ./papirus-icon-theme-master/Papirus/64x64/apps

# first cleanup: remove theme.tar.gz
rm ./theme.tar.gz

echo "Creating mapping file..."
# for each real file: Write mapping from name to file
for iconFile in *.svg
do
 if [[ -f "$iconFile" ]]; then
   # not a symlink

   baseName=$(basename "$iconFile" ".svg")
   fileName=$(basename "$iconFile")

   echo "$baseName;$fileName" >> ./mapping.csv
 fi
done

# for each symlink: Check if target is valid and write mapping to real file
for iconFile in *.svg
do
 if [[ -L "$iconFile" && -e "$iconFile" ]]; then
   # IS a symlink

   baseName=$(basename "$iconFile" ".svg")
   targetLink=$(basename $(readlink -f "$iconFile")) # is in same directory because target is valid (all other files haven't been extracted)

   echo "$baseName;$targetLink" >> ./mapping.csv

   # remove symlink (we will rely on the mapping)
   rm "$iconFile"
 fi
done

# mapping file is ready, move out of temp
mv ./mapping.csv "$DEST_DIR/mapping.csv"

# zip all svgs
zip -q -9 icons.zip *.svg

# move zip out of temp
mv ./icons.zip "$DEST_DIR/icons.zip"

popd # exit temp directory

echo "Done!"
