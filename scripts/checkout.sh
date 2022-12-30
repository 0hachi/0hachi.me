#! /usr/bin/env sh

make clean build
git checkout build
git checkout main -- dist

mv -f dist/* .
rm -rf dist

git add .
git commit -m "build: $(date) (automated commit)" -m "$(git log -1 --pretty=%B)"

git push origin build
git checkout main
