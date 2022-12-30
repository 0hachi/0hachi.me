---
title: how this website was built
date: 30.12.2022
---

## styling a simple blog

i used to be hesitant about making websites because i found the tools & technologies frustrating to work with, & i'm not a designer. that changed when i came across [webb's website](https://webb.spiderden.org/). although i was familiar with minimalism & simplicity, i had never seen a website that exploited it in such a beautiful way.

inspired by webb's design, i created my own website & made a few changes to it. however, the most challenging part was the blog. i wanted to create a blog that was as simple as possible & easy to update with new posts.

## static generation of blog posts

my first idea was to use a static site generator, but i found the configuration overwhelming & disliked the added complexity & design. instead, i turned to a tool i used to use a lot when taking latex notes: [pandoc](https://pandoc.org/).

to generate my blog posts, i simply fed p&oc `.md` files & it converted them to `.html` files.

```sh
for file in posts/*.md; do
    pandoc -s -o "${file%.md}.html" "$file"
done
```

i then adapted the styling to match my website by adding a --css flag that pointed to my stylesheet. pandoc already handled syntax highlighting & basic styling for various blog elements, which made the process easier.

incorporating the index into the page was similarly straightforward. i added dummy comments around the files i wanted to include, & then used sed to replace them with the actual content.

```html
<section class="index">
  <h1>blog</h1>
  <!-- posts -->
</section>
```

```sh
sed -i -e "s/<!-- posts -->/$posts/g" dist/index.html
```

now, all we're left with is a bunch of `.html` files in the `dist` folder. as i use github pages to host my website, i decided to create a script to compile & push the output to the `build` branch.

```sh
#! /usr/bin/env sh

# or whatever you use
make clean build posts=1
git checkout build
git checkout main -- dist

# avoids conflicts with non-empty directories
rsync -a dist/ . --exclude=.gitkeep
rm -rf dist

git add .
git commit -m "build: $(date) (automated commit)" \
           -m "$(git log -1 --pretty=%B)"

git push origin build
git checkout main
```

## final thoughts

i can say, with confidence, that this was the most fun i've had making a website. i'm not sure if i'll continue to make posts on this blog, but i'm glad i made it.

if you're interested in the full source code, you can find it [here](https://gitlab.com/0hachi/0hachi.me) on gitlab.
