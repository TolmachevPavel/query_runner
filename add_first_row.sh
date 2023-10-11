#!/bin/bash

location=~/join-order-benchmark # Директория, файлы в которой буду обрабатывать
str='EXPLAIN (ANALYZE, BUFFERS)' # Строка, которую буду записывать

# Добавляю одну строку в начало...
for var in $(ls $location) #...всех файлов в этой директории
  do
      sed -i -e "1 s/^/$str\n/;" $location/$var
  done
