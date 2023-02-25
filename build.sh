#!/bin/sh
export MRUBY_CONFIG=`pwd`/.travis_config.rb
if [ -z "${MRUBY_VERSION}" ] ; then
  export MRUBY_VERSION="3.2.0"
fi

if [ ! -d "./mruby/src" ]; then
  git clone https://github.com/mruby/mruby.git
  cd mruby
  git fetch --tags
  rev=`git rev-parse $MRUBY_VERSION`
  git checkout $rev
  cd ..
fi
(cd mruby; rake $1)
