%{
    void yyerror(char *s);
    int yylex();
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    struct VarTable {
        int num;
        char id[10];
        struct VarTable *next;
    };

    typedef struct VarTable Var;
    Var *head = NULL;

    void updateTable(int n, char a[]);
    int getValue(char a[]);
%}

%union {
    int num;
    char id[10];
}

%start line
%token print
%token exit_cmd
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%

line : assignment '~' {;}
     | exit_cmd '~' {exit(0);} /* Corrected the exit function call */
     | print exp '~' { printf("%d\n", $2); }
     | line assignment '~' {;}
     | line print exp '~' { printf("%d\n", $3); }
     | line exit_cmd '~' { exit(0); } /* Corrected the exit function call */
     ;

assignment : identifier '=' exp { updateTable($3, $1); };

exp : term { $$ = $1; }
    | exp '+' term { $$ = $1 + $3; }
    | exp '-' term { $$ = $1 - $3; }
    | exp '/' term { $$ = $1 / $3; }
    | exp '*' term { $$ = $1 * $3; }
    
    ;

term : number { $$ = $1; }
     | identifier { $$ = getValue($1); }
     ;

%%

Var* create(int n, char a[], Var *h) {
    Var *t = (Var *)malloc(sizeof(Var));
    t->num = n;
    strcpy(t->id, a);
    t->next = NULL;

    if (h == NULL) {
        return t;
    }

    Var *p = h;
    while (p->next != NULL) {
        p = p->next;
    }
    p->next = t;
    return h;
}

Var* find(char a[], Var *h) {
    Var *p = h;
    while (p != NULL) {
        if (strcmp(a, p->id) == 0)
            return p;
        p = p->next;
    }
    return NULL;
}

void updateTable(int n, char a[]) {
    Var *h = find(a, head);
    if (h == NULL) {
        head = create(n, a, head);
    } else {
        h->num = n;
    }
}

int getValue(char a[]) {
    Var *h = find(a, head);
    if (h == NULL) {
        fprintf(stderr, "Undefined variable: %s\n", a);
        exit(1);
    }
    return h->num;
}

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    return yyparse();
}
