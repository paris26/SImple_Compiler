%{
#define YYSTYPE double
#include <stdio.h>
#include <math.h>
void yyerror(const char *s);
int yylex();
%}

%token REAL
%token PLUS MINUS TIMES DIVIDE POWER LEFT RIGHT END

%left PLUS MINUS
%left TIMES DIVIDE
%right POWER

%%

program:
    | program expression END  { printf("Result: %g\n", $2); }
    ;

expression: 
    REAL                    { $$ = $1; }
    | expression PLUS expression   { $$ = $1 + $3; }
    | expression MINUS expression  { $$ = $1 - $3; }
    | expression TIMES expression  { $$ = $1 * $3; }
    | expression DIVIDE expression { $$ = $1 / $3; }
    | expression POWER expression  { $$ = pow($1, $3); }
    | LEFT expression RIGHT       { $$ = $2; }
    | MINUS expression           { $$ = -$2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter arithmetic expressions (e.g., 2.5 + 3.7):\n");
    yyparse();
    return 0;
}