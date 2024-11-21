%{
#include "y.tab.h"
#include <stdlib.h>
%}

%%

[ \t\n]         ; /* Skip whitespace */
"VAR"           { return VAR; }
"PRINT"         { return PRINT; }
":="            { return ASSIGN; }
[0-9]+(\.[0-9]+)?  { 
    yylval.number = atof(yytext); 
    return NUMBER; 
}
[a-zA-Z][a-zA-Z0-9]* {
    yylval.id = strdup(yytext);
    return ID;
}
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"("             { return '('; }
")"             { return ')'; }
";"             { return ';'; }
.               { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}