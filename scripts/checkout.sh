#! /usr/bin/env sh

make clean build
git checkout build

git checkout main -- dist
git add dist/**/*
git commit -m "build: $(date) (automated commit)" -m "$(git log -1 --pretty=%B)"

git push origin build
git checkout main
