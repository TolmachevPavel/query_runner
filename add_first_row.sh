#!/bin/bash

for var in $(ls ~/join-order-benchmark)
  do
      sed -i -e '1 s/^/EXPLAIN ANALYZE\n/;' ~/join-order-benchmark/$var
  done