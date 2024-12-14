for DAY in {1..10}
do
    cp template/day_x_test.tpl.exs test/day/day_${DAY}_test.exs
    sed -i "" "s/_DAY_/${DAY}/g" test/day/day_${DAY}_test.exs
done
