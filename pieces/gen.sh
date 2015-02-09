#!/bin/sh

cd "$(dirname "$0")"

pieces="cover_plate hours_disc hours_text minutes_disc minutes_text"

for p in $pieces; do
    echo $p
    > $p.scad
    for p2 in $pieces; do
        disable=true
        [ $p = $p2 ] && disable=false
        echo "disable_$p2 = $disable;" >> $p.scad
    done
    echo >> $p.scad
    echo "include <../clock.scad>" >> $p.scad
done
