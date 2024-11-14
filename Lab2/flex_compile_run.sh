#!/bin/bash

# Check if both flex file and input file were provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <flex_file.l> <input_file.txt>"
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

# Compile the C code with a simple main function
echo "Compiling..."
cat > temp_main.c << EOL
#include <stdio.h>
extern FILE* yyin;
extern int yylex(void);

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    yylex();
    return 0;
}
EOL

gcc lex.yy.c temp_main.c -lfl -o "$filename"

if [ $? -ne 0 ]; then
    echo "Compilation failed. Exiting."
    exit 1
fi

# Run the executable with input file
echo "Running the program with input file..."
./"$filename" "$2"

# Clean up
echo "Cleaning up..."
rm lex.yy.c "$filename" temp_main.c

echo "Done."
