export MRUBY_CONFIG=`pwd`/misc/build_config.rb

if [ ! -d "./mruby/src" ]; then
  git clone https://github.com/mruby/mruby.git
fi
(cd mruby; ./minirake)
(cd mruby; ./minirake test)
