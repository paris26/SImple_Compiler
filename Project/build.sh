#!/bin/zsh

# Stop on any error
set -e

echo "Cleaning old files..."
rm -f calc lex.yy.c lex.yy.o y.tab.c y.tab.h y.tab.o

echo "Generating parser with bison..."
bison --defines=y.tab.h --output=y.tab.c calc.y

echo "Checking if parser files were generated..."
if [[ ! -f y.tab.c ]] || [[ ! -f y.tab.h ]]; then
    echo "Error: Bison failed to generate parser files"
    ls -la
    exit 1
fi

echo "Generating lexer with flex..."
flex --outfile=lex.yy.c calc.l

echo "Checking if lexer file was generated..."
if [[ ! -f lex.yy.c ]]; then
    echo "Error: Flex failed to generate lexer file"
    ls -la
    exit 1
fi

echo "Compiling parser..."
gcc -Wall -c y.tab.c

echo "Compiling lexer..."
gcc -Wall -c lex.yy.c

echo "Linking everything..."
gcc -o calc y.tab.o lex.yy.o -lfl

echo "Build complete! You can run the calculator with ./calc"

# Show the files that were created
echo "\nGenerated files:"
ls -la