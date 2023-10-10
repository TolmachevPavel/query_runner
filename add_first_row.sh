#!/bin/bash

# Добавляю одну строку в начало...
for var in $(ls ~/join-order-benchmark) #...всех файлов в этой директории
  do
      sed -i -e '1 s/^/EXPLAIN ANALYZE\n/;' ~/join-order-benchmark/$var # Строку вот эту EXPLAIN ANALYZE
  done
