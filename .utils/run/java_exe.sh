# !/bin/bash 

package=$(echo $1 | tr '/' '.')
echo $package
javac $1/*.java && java ${package}Main
