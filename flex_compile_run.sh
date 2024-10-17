#!/bin/bash

# Check if a filename was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <flex_file.l>"
    exit 1
fi

# Get the filename without extension
filename=$(basename -- "$1")
filename="${filename%.*}"

# Run flex
echo "Running Flex..."
flex "$1"

if [ $? -ne 0 ]; then
    echo "Flex failed. Exiting."
    exit 1
fi

# Compile the C code
echo "Compiling..."
gcc lex.yy.c -lfl -o "$filename"

if [ $? -ne 0 ]; then
    echo "Compilation failed. Exiting."
    exit 1
fi

# Run the executable
echo "Running the program..."
./"$filename"

# Clean up
echo "Cleaning up..."
rm lex.yy.c "$filename"

echo "Done."
