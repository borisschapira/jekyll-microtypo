#!/bin/sh
# https://github.com/svenfuchs/gem-release

if [ -z "$1" ]; then
  echo "Usage: provide the release type (patch, minor, major)."
  exit -1
else
  release_type="$@"
fi

# gem build jekyll-microtypo.gemspec

bump "$release_type" --tag
