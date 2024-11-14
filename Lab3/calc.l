%{
#define YYSTYPE double
#include "y.tab.h"
extern YYSTYPE yylval;
#include <stdlib.h>
%}

%option noyywrap

white   [ \t]+
nzdigit [1-9]
digit (0|{nzdigit})
digits {digit}+
optFr (\.{digits})?
real ({nzdigit}{digits}*|0){optFr}

%%

{white}  { }
{real}   {
            yylval=atof(yytext); 
            return REAL;
        }

"+"     return PLUS;
"-"     return MINUS;
"*"     return TIMES;
"/"     return DIVIDE;
"^"     return POWER;
"("     return LEFT;
")"     return RIGHT;
"\n"    return END;

%%