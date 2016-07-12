FROM hone/mruby-cli
RUN apt-get update && apt-get install -y unzip libncurses5-dev wget
RUN cd /tmp && wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.0.tar.gz \
  && tar zxf ncurses-6.0.tar.gz && cd ncurses-6.0 \
  && ./configure --prefix=/usr/i686-w64-mingw32/ --host=i686-w64-mingw32 --with-shared --enable-term-driver \
  && make install
RUN cd /tmp && wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz \
  && tar zxf libiconv-1.14.tar.gz && cd libiconv-1.14 \
  && ./configure --prefix=/usr/i686-w64-mingw32/ --host=i686-w64-mingw32 \
  && make install
