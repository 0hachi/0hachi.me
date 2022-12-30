#! /usr/bin/env sh

usage() {
    echo "usage: $0 <posts_dir> <dist_dir> [0|1]"
    exit 1
}

if [ -z $1 ]; then
    usage
fi

if [ -z $2 ]; then
  usage
fi

POSTS_DIR=$1
DIST_DIR=$2
BUILD_POSTS=$3

posts=""
mkdir -p $DIST_DIR/$POSTS_DIR

cp -r public/* $DIST_DIR

if [ "$BUILD_POSTS" = 1 ]; then
  for file in $POSTS_DIR/*.md; do
    to=$(echo $file | sed -e "s/$POSTS_DIR/$DIST_DIR\/$POSTS_DIR/g" -e "s/.md/.html/g")

    post_link=${to#"$DIST_DIR"}
    date=$(grep -oP '(?<=date: ).*' $file)

    posts+="<li><a href=\"$post_link\">$post_link</a></li>"

    pandoc -s -f markdown -t html5+smart --highlight=zenburn --css /styles/theme.css -o $to $file

    echo $to
  done

  posts=$(echo $posts | sed -e "s/\//\\\\\//g")
  sed -i -e "s/<!-- POSTS -->/<ul>$posts<\/ul>/g" $DIST_DIR/index.html
fi

