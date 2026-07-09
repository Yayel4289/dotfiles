# !/bin/bash

mkdir -p out/
output=$(echo $1 | cut -d '.' -f 1)
g++ -o out/${output}.out $1 && ./out/${output}.out
