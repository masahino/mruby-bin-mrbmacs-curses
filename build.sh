export MRUBY_CONFIG=`pwd`/misc/build_config.rb
SCINTILLA_FILE='scintilla372.tgz'
SCINTERM_VER='scinterm_1.8'

if [ ! -f "./scintilla/bin/scintilla.a" ]; then
  if [ ! -d "./scintilla/$SCINTERM_VER" ]; then
    wget http://www.scintilla.org/$SCINTILLA_FILE
    tar zxf $SCINTILLA_FILE
    wget http://foicica.com/scinterm/download/${SCINTERM_VER}.zip
    (cd scintilla; unzip ../${SCINTERM_VER}.zip)
  fi
  (cd scintilla/${SCINTERM_VER} ; make)
fi
if [ ! -d "./mruby/src" ]; then
  git clone https://github.com/mruby/mruby.git
fi
(cd mruby; ./minirake)
(cd mruby; ./minirake test)
