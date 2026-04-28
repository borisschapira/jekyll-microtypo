#!/bin/sh
# https://github.com/svenfuchs/gem-release

if ! command -v bump > /dev/null 2>&1; then
  echo "Error: 'bump' is not installed."
  echo "Please install it by running: gem install gem-release"
  exit 1
fi

if [ -z "$1" ]; then
  echo "Usage: provide the release type (patch, minor, major)."
  exit 1
else
  release_type="$@"
fi

# gem build jekyll-microtypo.gemspec

bump "$release_type" --tag