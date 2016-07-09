FROM hone/mruby-cli
RUN apt-get update && apt-get install -y unzip libncurses5-dev
