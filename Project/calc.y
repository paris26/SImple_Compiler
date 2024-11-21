%{ 
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    void yyerror(const char *s);
    int yylex(void);

    /* Define symbol structure */
    struct symbol {
        char *name;
        double value;
    };

    /* Add function prototypes */
    struct symbol *sym_lookup(char *name);
    struct symbol *sym_add(char *name);

    /* Symbol table */
    #define NSYMS 100
    struct symbol symtab[NSYMS];
    int sym_count = 0;
%}

%union {
    double number;
    char* id;
    struct symbol* sym;
}

%token VAR 
%token PRINT
%token ASSIGN
%token <number> NUMBER
%token <id> ID

%type <number> expr
%type <number> term
%type <number> factor
%type <sym> var

%left '+' '-'
%left '*' '/'
%right UMINUS 

%%    

/* Rest of your grammar rules remain the same */

prog: dlist slist 
    ; 

dlist: decl ';'
    | dlist decl ';'
    |    /* empty */
    ;

decl: VAR var
    ;

var: ID {
        struct symbol *s = sym_lookup($1);
        if(s == NULL)
            s = sym_add($1);
        $$ = s;
    }
    ;

slist: stmt
    | slist ';' stmt
    ;

stmt: var ASSIGN expr {
        $1->value = $3;
    }
    | PRINT expr {
        printf("%g\n", $2);
    }
    ;

expr: expr '+' term { $$ = $1 + $3; }
    | expr '-' term { $$ = $1 - $3; }
    | term { $$ = $1; }
    ;

term: term '*' factor { $$ = $1 * $3; }
    | term '/' factor {
        if($3 == 0){
            yyerror("division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | factor { $$ = $1; }
    ;

factor: '(' expr ')'  { $$ = $2; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | var {
        if($1 == NULL)
            yyerror("undefined variable");
        else
            $$ = $1->value;
    }
    | NUMBER { $$ = $1; }
    ;

%%

/* Function implementations */
struct symbol *sym_lookup(char *name) {
    int i;
    for(i = 0; i < sym_count; i++) {
        if(strcmp(name, symtab[i].name) == 0)
            return &symtab[i];
    }
    return NULL;
}

struct symbol *sym_add(char *name) {
    struct symbol *sp = &symtab[sym_count++];
    sp->name = strdup(name);
    sp->value = 0;
    return sp;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}