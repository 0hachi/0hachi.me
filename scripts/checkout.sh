#! /usr/bin/env sh

make clean build posts=1
git checkout build
git checkout main -- dist

rsync -a dist/ . --exclude=.gitkeep
rm -rf dist

git add .
git commit -m "build: $(date) (automated commit)" -m "$(git log -1 --pretty=%B)"

git push origin build
git checkout main
