#!/bin/bash
cd "$(dirname "${BASH_SOURCE}")"
DIR=`pwd`
git pull
function doIt() {
  for FILE in `find . -maxdepth 1 -type f -iname ".*"`
  do
    if [ -f ~/$FILE ]; then
      rm -f ~/$FILE
    fi
    ln -s "$DIR/$FILE" ~/
  done
}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt
  fi
fi
unset doIt
source ~/.bash_profile
