%{
   #include <stdio.h>
   %}

   %%
   [0-9]+      { printf("NUMBER: %s\n", yytext); }
   [a-zA-Z]+   { printf("WORD: %s\n", yytext); }
   [ \t\n]     { /* Ignore whitespace */ }
   .           { printf("UNKNOWN: %s\n", yytext); }
   %%

   int main() {
       printf("Lexer started. Please enter some text (Ctrl+D to end):\n");
       yylex();
       printf("Lexer finished.\n");
       return 0;
   }
   %%
