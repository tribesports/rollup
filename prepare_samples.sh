#!/bin/bash

for file in $(ls data); do
  if [ -f data/$file ]; then
    ./go.rb data/$file > samples/$file
  fi
done
