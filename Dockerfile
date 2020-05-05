FROM hone/mruby-cli
RUN apt-get update && apt-get install -y unzip libncurses5-dev lib32ncurses5-dev wget
RUN apt-get install -y g++-arm-linux-gnueabihf
RUN cd /tmp \
  && wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz \
  && wget https://github.com/Bill-Gray/PDCurses/archive/v4.1.0.tar.gz \
  && wget https://github.com/neovim/unibilium/archive/v2.1.0.tar.gz \
  && wget https://github.com/k-takata/Onigmo/releases/download/Onigmo-6.2.0/onigmo-6.2.0.tar.gz \
  && wget http://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-unibilium-2.1.0-1-any.pkg.tar.xz \
  && wget http://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-onigmo-6.2.0-1-any.pkg.tar.xz \
  && wget http://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-pdcurses-4.1.0-3-any.pkg.tar.xz \
  && wget http://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-libiconv-1.16-1-any.pkg.tar.xz
##################
# x86_64-w64-mingw32
RUN mkdir /tmp/x86_64
#RUN mkdir /tmp/x86_64 && cd /tmp/x86_64 \
#  && tar zxf ../libiconv-1.16.tar.gz && cd libiconv-1.16 \
#  && ./configure --prefix=/usr/x86_64-w64-mingw32/ --host=x86_64-w64-mingw32 --enable-static \
#  && make install
#RUN cd /tmp/x86_64 \
#  && tar zxf ../v4.1.0.tar.gz && cd PDCurses-4.1.0/wingui \
#  && make -f Makefile.mng pdcurses.a CC=x86_64-w64-mingw32-gcc LINK=x86_64-w64-mingw32-gcc WIDE=Y UTF8=Y \
#  && cp ../curses.h /usr/x86_64-w64-mingw32/include \
#  && cp ../term.h /usr/x86_64-w64-mingw32/include \
#  && cp ../panel.h /usr/x86_64-w64-mingw32/include \
#  && x86_64-w64-mingw32-ranlib pdcurses.a \
#  && cp pdcurses.a /usr/x86_64-w64-mingw32/lib/libpdcurses.a
#RUN cd /tmp/x86_64 \
#  && tar zxf ../onigmo-6.2.0.tar.gz && cd onigmo-6.2.0 \
#  && ./configure --prefix=/usr/x86_64-w64-mingw32/ --host=x86_64-w64-mingw32 --enable-static \
#  && make install
#RUN cd /tmp/x86_64 \
#  && tar zxf ../v2.1.0.tar.gz && cd unibilium-2.1.0 \
#  && make PREFIX=/usr/x86_64-w64-mingw32 CC=x86_64-w64-mingw32-gcc LINK=x86_64-w64-mingw32-gcc LDFLAGS="-L/usr/x86_64-w64-mingw32/lib -lmsvcrt"
RUN cd /tmp/x86_64 \
  && tar Jxf ../mingw-w64-x86_64-unibilium-2.1.0-1-any.pkg.tar.xz \
  && tar Jxf ../mingw-w64-x86_64-onigmo-6.2.0-1-any.pkg.tar.xz \
  && tar Jxf ../mingw-w64-x86_64-pdcurses-4.1.0-3-any.pkg.tar.xz \
  && tar Jxf ../mingw-w64-x86_64-libiconv-1.16-1-any.pkg.tar.xz \
  && cp -rp mingw64/* /usr/x86_64-w64-mingw32/
#####################
# x86_64-apple-darwin
#RUN mkdir /tmp/x86_64-apple && cd /tmp/x86_64-apple \
#  && tar jxf ../pcre-8.39.tar.bz2 && cd pcre-8.39 \
#  && CC=o64-clang CXX=o64-clang++ ./configure --host=x86_64-apple-darwinXX --prefix=/opt/osxcross/target/SDK/MacOSX10.10.sdk/usr/ --enable-static \
#  && make install
##############
# arm-linux-gnueabihf
RUN cd /tmp && wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz
RUN mkdir /tmp/arm-linux-gnueabihf && cd /tmp/arm-linux-gnueabihf \
  && tar zxf ../ncurses-5.9.tar.gz && cd ncurses-5.9 \
  && ./configure --prefix=/usr/arm-linux-gnueabihf/ --host=arm-linux-gnueabihf --without-ada --enable-warnings \
  --without-normal --enable-pc-files --with-shared \
  && make install
#RUN cd /tmp/arm-linux-gnueabihf && tar jxf ../pcre-8.39.tar.bz2 && cd pcre-8.39 \
#  && ./configure --host=arm-linux-gnueabihf --prefix=/usr/arm-linux-gnueabihf --enable-static --disable-shared \
#  && make install
