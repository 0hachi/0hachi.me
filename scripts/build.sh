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

posts=""
mkdir -p $2/$1

cp index.html $2


if [ "$3" = 1 ]; then
  for file in $1/*.md; do
    to=$(echo $file | sed -e "s/$1/$2\/$1/g" -e "s/.md/.html/g")

    post_link=${to#"$2"}
    date=$(grep -oP '(?<=date: ).*' $file)

    posts+="<li><a href=\"$post_link\">$post_link</a></li>"

    pandoc -s -f markdown -t html5+smart --highlight=zenburn --css /styles/theme.css -o $to $file

    echo $to
  done

  posts=$(echo $posts | sed -e "s/\//\\\\\//g")
  sed -i -e "s/<!-- POSTS -->/<ul>$posts<\/ul>/g" $2/index.html
fi

cp -r assets $2
cp -r styles $2/styles

