%{
#include <stdio.h>
#include <string.h>
#define N 9
char *sa[N]={"and","else","if","int","not","or","print","read","while"};
int id_or_keyword(char *s);
%}

%option noyywrap

numbers     [0-9]+
variables   [a-zA-Z]([a-zA-Z]|[0-9])*
signs       [*+-=%;\(\)>]
format      [ \n\t\f]

%%

{numbers}   { printf("Number: %s\n", yytext); }
{variables} { 
    int i = id_or_keyword(yytext);
    if (i == 0) 
        printf("ID: %s\n", yytext);
    else 
        printf("RESERVED: %s\n", yytext); 
}
{signs}     { printf("Sign: %s\n", yytext); }
{format}    { /* Ignore whitespace */ }
.           { printf("Unknown character %s!\n", yytext); }

%%

int id_or_keyword(char *s)
{
    int i = 0, found = 0;
    while (found == 0 && i < N)
        if (strcmp(sa[i], s) == 0)
            found = 1;
        else 
            i++;
    return found; 
}
