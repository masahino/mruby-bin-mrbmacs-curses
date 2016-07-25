FROM hone/mruby-cli
RUN apt-get update && apt-get install -y unzip libncurses5-dev wget
#RUN cd /tmp && wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.0.tar.gz \
#  && tar zxf ncurses-6.0.tar.gz && cd ncurses-6.0 \
#  && ./configure --prefix=/usr/i686-w64-mingw32/ --host=i686-w64-mingw32 --without-ada --enable-warnings \
#  --enable-asertions --disable-home-terminfo --enable-database --enable-term-driver --enable-sp-funcs \
#  --enable-interop --disable-termcap --with-progs --enable-pc-files --enable-widec \
#  && make install
#RUN cd /usr/i686-w64-mingw32 && wget http://invisible-island.net/datafiles/release/mingw32.zip \
#  && unzip mingw32.zip
RUN cd /tmp && wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz \
  && tar zxf libiconv-1.14.tar.gz && cd libiconv-1.14 \
  && ./configure --prefix=/usr/i686-w64-mingw32/ --host=i686-w64-mingw32 --enable-static \
  && make install
RUN cd /tmp && wget https://sourceforge.net/projects/pdcurses/files/pdcurses/3.4/PDCurses-3.4.tar.gz \
  && tar zxf PDCurses-3.4.tar.gz && cd PDCurses-3.4/win32 \
  && make -f mingwin32.mak CC=i686-w64-mingw32-gcc LINK=i686-w64-mingw32-gcc LIBCURSES=libcurses.a \
  && cp ../curses.h /usr/i686-w64-mingw32/include \
  && cp ../term.h /usr/i686-w64-mingw32/include \
  && cp libcurses.a /usr/i686-w64-mingw32/lib
#RUN cd /tmp && wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.0.tar.gz \
#  && tar zxf ncurses-6.0.tar.gz && cd ncurses-6.0 \
#  && ./configure --prefix=/usr/x86_64-w64-mingw32/ --host=x86_64-w64-mingw32 --enable-term-driver --enable-sp-funcs \
#  && make install
#RUN cd /tmp && wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz \
#  && tar zxf libiconv-1.14.tar.gz && cd libiconv-1.14 \
#  && make clean \
#  && ./configure --prefix=/usr/x86_64-w64-mingw32/ --host=x86_64-w64-mingw32 --enable-static \
# && make install
