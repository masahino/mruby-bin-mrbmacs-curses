export MRUBY_CONFIG=`pwd`/.travis_config.rb
if [[ -z "${MRUBY_VERSION}" ]] ; then
  export MRUBY_VERSION="2.1.0"
fi

if [ ! -d "./mruby/src" ]; then
  git clone https://github.com/mruby/mruby.git
  cd mruby
  git fetch --tags
  rev=`git rev-parse $MRUBY_VERSION`
  git checkout $rev
fi
(cd mruby; rake clean)
(cd mruby; rake)
(cd mruby; rake test)
