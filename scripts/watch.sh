#! /usr/bin/env sh

if [ -z $1 ]; then
    echo "usage: $0 <...files>"
    exit 1
fi

if ! which inotifywait > /dev/null; then
    echo "inotifywait not found. please install it."
    exit 1
fi

while inotifywait -e modify -q -r $1; do
    make build
done