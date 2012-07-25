#!/bin/bash

sample_count=0
diff_count=0
for file in $(ls data/training); do
  line_count=$(cat data/training/$file | wc -l)
  sample_count=$((sample_count + line_count))
  diff_count_for_file=$(ruby rate.rb data/training/$file samples/$file 0.1 0.2)
  diff_count=$((diff_count + diff_count_for_file))
done

average_diff=$((diff_count / sample_count))

echo "Total diff: "$diff_count
echo "Average diff for samples: "$average_diff

