#! /usr/bin/env python

from datetime import datetime
from os import path, mkdir, listdir
from sys import exit, argv
from typing import TypedDict
from subprocess import run
from shutil import copytree

class Args(TypedDict):
  posts_dir: str
  dist_dir: str
  build_posts: str

class PostItem(TypedDict):
  link: str
  date: str

def usage(error: str):
  if error:
    print('error: %s' % error)
  
  print('usage: %s <posts_dir> <dist_dir> [0|1]' % argv[0])
  exit(1)

def log(msg: str):
  print('log: %s' % msg)

def parse_args() -> Args:
  if len(argv) < 3:
    usage('not enough arguments')

  posts_dir = argv[1]
  dist_dir = argv[2]
  build_posts = argv[3] if len(argv) > 3 else '0'

  if not path.isdir(posts_dir):
    usage('posts_dir must be a directory')

  if not path.isdir(dist_dir):
    usage('dist_dir must be a directory')

  # lazy flag
  if build_posts not in ['0', '1']:
    usage('build_posts must be 0 or 1')
    
  return Args(posts_dir=posts_dir, dist_dir=dist_dir, build_posts=build_posts)

def parse_date(date: str) -> datetime:
  return datetime.strptime(date, '%d.%m.%Y')

def replace_in_file(path: str, old: str, new: str):
  with open(path, 'r') as file:
    content = file.read()

  with open(path, 'w') as file:
    file.write(content.replace(old, new))

def main():
  args = parse_args()

  dist_dir = args['dist_dir']
  posts_dir = args['posts_dir']
  build_posts = args['build_posts']

  posts_dist_dir = path.join(dist_dir, posts_dir)
  if not path.isdir(posts_dist_dir):
    mkdir(posts_dist_dir)

  copytree('public', dist_dir, dirs_exist_ok=True)
  log('copied public to %s' % dist_dir)
  
  if build_posts == '1':
    index_posts_list_items: list[PostItem] = []

    for post in listdir(posts_dir):
      to = path.join(posts_dist_dir, post).replace('.md', '.html')

      run([
        'pandoc',
        '-s',
        '-f',
        'markdown',
        '-t',
        'html5+smart',
        '--highlight=zenburn',
        '-H',
        'METADATA',
        '--css',
        '/styles/theme.css',
        '-o',
        to,
        path.join(posts_dir, post)
      ])
      log('built %s' % to)

      clean_link = to.replace(dist_dir, '')
      date = run([
        'grep',
        '-oP',
        '(?<=date: ).*',
        path.join(posts_dir, post)
      ], capture_output=True).stdout.decode('utf-8').strip()

      index_posts_list_items.append(
        PostItem(link=clean_link, date=date)
      )

    index_posts_list_items.sort(key=lambda item: parse_date(item['date']), reverse=True)
    replace_in_file(
      path.join(dist_dir, 'index.html'),
      '<!-- POSTS -->',
      '<ul>%s</ul>' % ''.join(
        ['<li><a href="%s">%s</a></li>' % (item['link'], item['link']) for item in index_posts_list_items]
      )
    )

  with open('METADATA', 'r') as file:
    metadata = file.read()

    replace_in_file(
      path.join(dist_dir, 'index.html'),
      '<!-- METADATA -->',
      metadata
    )

if __name__ == '__main__':
  main()