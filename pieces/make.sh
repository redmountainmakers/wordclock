#!/bin/bash

cd "$(dirname "$0")"

# Generate the .stl files for the individual pieces

openscad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

#pieces="cover_plate hours_disc hours_text minutes_disc minutes_text base"
pieces="cover_plate hours_disc minutes_disc base"

for p in $pieces; do
    stl="$p.stl"
    echo "Generating $stl"
    "$openscad" "$p.scad" -o "$stl"
done
