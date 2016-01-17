export MRUBY_CONFIG=`pwd`/misc/build_config.rb
SCINTILLA_FILE='scintilla362.tgz'
SCINTERM_VER='scinterm_1.6'

if [ ! -f "./scintilla/bin/scintilla.a" ]; then
  if [ ! -d "./scintilla/$SCINTERM_VER" ]; then
    wget http://www.scintilla.org/$SCINTILLA_FILE
    tar zxf $SCINTILLA_FILE
    wget http://foicica.com/scinterm/download/${SCINTERM_VER}.zip
    (cd scintilla; unzip ../${SCINTERM_VER}.zip; patch -p0 < ../misc/${SCINTERM_VER}.patch)
  fi
  (cd scintilla/${SCINTERM_VER} ; make)
fi
if [ ! -d "./mruby/src" ]; then
  git clone https://github.com/mruby/mruby.git
fi
(cd mruby; rake)
