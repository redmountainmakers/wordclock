#!/bin/bash

cd "$(dirname "$0")"

# Generate the .stl files for the individual pieces

openscad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

for i in *.scad; do
    stl="${i%.scad}.stl"
    echo "Generating $stl"
    "$openscad" "$i" -o "$stl"
done
