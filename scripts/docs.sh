#!/bin/bash

# Bash script to generate the documentation of smart contracts
# stored at ../contracts/ directory 
# All docs will be stored at ../docs directory

echo Start to generate the documentation
echo

# Go to contracts directory
cd ..
cd contracts

# Iterates through ../contracts directory
for d in *.sol; do
    echo Generate docs \for: $d
    eval $"solidity-doc generate $d ../docs/$d.md" > ../docs/$d.md
done

echo
echo Done
