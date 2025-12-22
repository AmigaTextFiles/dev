%{

/* calculatrice en E utilisant E-Yacc:

   opérateurs binaires: + - * / % & |     (précédence dans cet ordre)
   opérateurs unaires : - ~
   groupe             : ( )
   assignation        : var = exp         (variables 'a' .. 'f')
   valeurs            : intnum var
   quitter            : Q <eof>

*/

DEF vars:PTR TO LONG

%}

%start stmt

%token DIGIT LETTER QUIT

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS '~'

%%

stmt    : expr                  { PrintF('résultat: \d\n> ',$1); Flush(stdout) }
        | LETTER '=' expr       { IF vars=NIL THEN NEW vars[26]; vars[$1]:=$3; PrintF('> '); Flush(stdout) }
        | QUIT                  { CleanUp(0) }
        ;

expr    : '(' expr ')'          { $$:=$2 }
        | expr '+' expr         { $$:=$1+$3 }
        | expr '-' expr         { $$:=$1-$3 }
        | expr '*' expr         { $$:=$1*$3 }
        | expr '/' expr         { $$:=$1/$3 }
        | expr '%' expr         { $$:=Mod($1,$3) }
        | expr '|' expr         { $$:=$1 OR $3 }
        | expr '&' expr         { $$:=$1 AND $3 }
        | '~' expr              { $$:=Not($2) }
        | '-' expr %prec UMINUS { $$:=-$2 }
        | LETTER                { $$:=vars[$1] }
        | number
        ;

number  : DIGIT                 { $$:=$1 }
        | number DIGIT          { $$:=10*$1+$2 }
        ;

%%

PROC yylex()
  DEF c
  WHILE (c:=FgetC(stdin))=" " DO NOP
  IF c="\n" THEN RETURN 0
  IF (c="Q") OR (c=-1) THEN RETURN QUIT
  IF (c>="a") AND (c<="z") THEN RETURN LETTER,c-"a"
  IF (c>="0") AND (c<="9") THEN RETURN DIGIT,c-"0"
ENDPROC c

PROC yyerror(n)
  IF n=YYERRSTACK
    PrintF('Pile de parse pleine!\n> ')
  ELSEIF n=YYERRPARSE
    PrintF('errur de parse!\n> ')
  ENDIF
ENDPROC
