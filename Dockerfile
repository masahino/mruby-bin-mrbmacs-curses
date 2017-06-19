FROM hone/mruby-cli
RUN apt-get update && apt-get install -y unzip libncurses5-dev lib32ncurses5-dev wget libpcre3-dev
RUN apt-get install -y g++-arm-linux-gnueabihf
RUN cd /tmp \
  && wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz \
  && wget https://sourceforge.net/projects/pdcurses/files/pdcurses/3.4/PDCurses-3.4.tar.gz \
  && wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz \
  && wget https://sourceforge.net/projects/pcre/files/pcre/8.39/pcre-8.39.tar.bz2
##################
# i686-w64-mingw32
RUN mkdir /tmp/i686 && cd /tmp/i686 \
  && tar zxf ../libiconv-1.14.tar.gz && cd libiconv-1.14 \
  && ./configure --prefix=/usr/i686-w64-mingw32/ --host=i686-w64-mingw32 --enable-static \
  && make install
RUN cd /tmp/i686 \
  && tar zxf ../PDCurses-3.4.tar.gz && cd PDCurses-3.4/win32 \
  && make -f mingwin32.mak CC=i686-w64-mingw32-gcc LINK=i686-w64-mingw32-gcc LIBCURSES=libcurses.a \
  && cp ../curses.h /usr/i686-w64-mingw32/include \
  && cp ../term.h /usr/i686-w64-mingw32/include \
  && cp libcurses.a /usr/i686-w64-mingw32/lib
RUN cd /tmp/i686 \
  && tar jxf ../pcre-8.39.tar.bz2 && cd pcre-8.39 \
  && ./configure --prefix=/usr/i686-w64-mingw32/ --host=i686-w64-mingw32 --enable-static \
  && make install
#RUN cd /tmp/i686 \
#  && tar zxf ../ncurses-5.9.tar.gz && cd ncurses-5.9 \
#  && ./configure --prefix=/usr/i686-w64-mingw32/ --host=i686-w64-mingw32 --enable-database --enable-term-driver --enable-sp-funcs --enable-static \
#  && make install \
#  && cp include/nc_termios.h /usr/i686-w64-mingw32/include/termios.h
####################
# x86_64-w64-mingw32
RUN mkdir /tmp/x86_64 && cd /tmp/x86_64 \
  && tar zxf ../libiconv-1.14.tar.gz && cd libiconv-1.14 \
  && ./configure --prefix=/usr/x86_64-w64-mingw32/ --host=x86_64-w64-mingw32 --enable-static \
  && make install
RUN cd /tmp/x86_64 \
  && tar zxf ../PDCurses-3.4.tar.gz && cd PDCurses-3.4/win32 \
  && make -f mingwin32.mak CC=x86_64-w64-mingw32-gcc LINK=x86_64-w64-mingw32-gcc LIBCURSES=libcurses.a \
  && cp ../curses.h /usr/x86_64-w64-mingw32/include \
  && cp ../term.h /usr/x86_64-w64-mingw32/include \
  && cp libcurses.a /usr/x86_64-w64-mingw32/lib
RUN cd /tmp/x86_64 \
  && tar jxf ../pcre-8.39.tar.bz2 && cd pcre-8.39 \
  && ./configure --prefix=/usr/x86_64-w64-mingw32/ --host=x86_64-w64-mingw32 --enable-static \
  && make install
#RUN cd /tmp/i686 \
#  && tar zxf ../ncurses-5.9.tar.gz && cd ncurses-5.9 \
#  && ./configure --prefix=/usr/x86_64-w64-mingw32/ --host=x86_64-w64-mingw32 --enable-database --enable-term-driver --enable-sp-funcs --enable-static \
#  && make install
#####################
# x86_64-apple-darwin
RUN mkdir /tmp/x86_64-apple && cd /tmp/x86_64-apple \
  && tar jxf ../pcre-8.39.tar.bz2 && cd pcre-8.39 \
  && CC=o64-clang CXX=o64-clang++ ./configure --host=x86_64-apple-darwinXX --prefix=/opt/osxcross/target/SDK/MacOSX10.10.sdk/usr/ --enable-static \
  && make install
##############
# arm-linux-gnueabihf
RUN cd /tmp && wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz
RUN mkdir /tmp/arm-linux-gnueabihf && cd /tmp/arm-linux-gnueabihf \
  && tar zxf ../ncurses-5.9.tar.gz && cd ncurses-5.9 \
  && ./configure --prefix=/usr/arm-linux-gnueabihf/ --host=arm-linux-gnueabihf --without-ada --enable-warnings \
  --without-normal --enable-pc-files --with-shared \
  && make install
RUN cd /tmp/arm-linux-gnueabihf && tar jxf ../pcre-8.39.tar.bz2 && cd pcre-8.39 \
  && ./configure --host=arm-linux-gnueabihf --prefix=/usr/arm-linux-gnueabihf --enable-static --disable-shared \
  && make install
