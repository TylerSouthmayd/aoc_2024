#!/bin/bash

DAY=$1
SESSION_COOKIE=$2

cp template/day_x.ex lib/day/day_${DAY}.ex
sed -i "" "s/_DAY_/${DAY}/g" lib/day/day_${DAY}.ex

cp template/day_x_test.exs test/day/day_${DAY}_test.exs
sed -i "" "s/_DAY_/${DAY}/g" test/day/day_${DAY}_test.exs

curl -o "input/day${DAY}.txt" "https://adventofcode.com/2024/day/${DAY}/input" --cookie "session=${SESSION_COOKIE}"
