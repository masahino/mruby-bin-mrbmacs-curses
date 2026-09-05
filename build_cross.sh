#!/bin/sh
# Cross-compile mrbmacs-curses for the targets defined in
# misc/build_config_cross.rb.
#
# Normal local builds use `rake` (which uses build_config.rb). This script is
# only for producing multi-platform release binaries and needs the relevant
# cross toolchains installed. The cross config is kept for reference and may
# need updating before it works again.
set -e

here=$(cd "$(dirname "$0")" && pwd)
export MRUBY_CONFIG="$here/misc/build_config_cross.rb"
export MRUBY_VERSION="${MRUBY_VERSION:-4.0.0}"

if [ ! -d "$here/mruby/src" ]; then
  git clone https://github.com/mruby/mruby.git "$here/mruby"
  (cd "$here/mruby" && git fetch --tags && git checkout "$(git rev-parse "$MRUBY_VERSION")")
fi

(cd "$here/mruby" && rake all "$@")
