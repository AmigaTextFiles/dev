%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <ctype.h>
#include "tree.h"
#include "types.h"
#include "codegen.h"

extern int onefile;
extern int lineno;
extern FILE *yyin;
extern FILE *yyout;
extern char *filename;
extern char *outname;
char *srcname = NULL;
FILE *yyasm = NULL;
FILE *yyextern = NULL;
treenode *tree = NULL;

extern int vars, varsize, pagesize, noconstants, debug, header;

int errors = 0;

void yyerror(char *str)
{
  fprintf(stdout,"error in %s, line %d: %s.\n", filename, lineno, str);
  errors++;
}

int yywrap()
{
	return 1;
}

int main(int argc, char *argv[])
{
  int c;
  for (c = 1; c < argc; c++)
  {
    if ((argv[c][0] == '-') || ((argv[c][0] == '/') && (strlen(argv[c]) > 1)))
    {
      int ch = tolower(argv[c][1]);
      switch(ch)
      {
        case 'c':
        noconstants = 1;
        break;

        case 'd':
        debug = 1;
        break;

        case 'h':
        header = 1;
        break;

        case 'l':
        yyasm = fopen(&argv[c][2], "wt");
        break;

        case 'o':
        onefile = 1;
        yyout = fopen(&argv[c][2], "wb");
        break;

        case 'p':
        sscanf(&argv[c][2], "%x", &pagesize);
        break;

        case 'v':
        sscanf(&argv[c][2], "%x,%x", &vars, &varsize);
        break;

        case 'e':
        yyextern = fopen(&argv[c][2], "rt");
        break;
      }
    }
    else
    {
      if (!srcname) srcname = argv[c];
    }
  }

  if (!srcname)
  {
    printf("CovertScript compiler V1.0\n"
           "usage: cs <infile> [options]\n\n"
           "-c            Do not automatically import constants from extern file\n"
           "-d            Enable compiler debugging output\n"
           "-e<name>      Extern definition file name\n"
           "-h            Add chunk-header (for datafiles)\n"
           "-l<name>      Listing file name\n"
           "-o<name>      Output to one file, instead of multiple pages\n"
           "-p<val>       Bytecode page size in hex                  (default: 0400)\n"
           "-v<val>,<val> Startaddress & length for variables in hex (default: 0334,100)\n");
    return 1;
  }
  yyin = fopen(srcname, "rt");
  if (!yyin)
  {
    fprintf(stderr, "error: couldn't open input file %s\n", srcname);
    return 1;
  }
  filename = srcname;
  yyparse();
  if (errors) return 1;
  compile(tree);
  if (errors) return 1;
  else return 0;
}

%}

%union
{
  int number;
  char *string;
  treenode *node;
}

%start program

%token FLUSH
%token INCLUDE
%token LOADPTR
%token CHUNK
%token SWITCH
%token CASE
%token DEFAULT
%token ALIAS
%token ASSIGN
%token ADDASSIGN
%token SUBASSIGN
%token MULASSIGN
%token DIVASSIGN
%token MODASSIGN
%token ANDASSIGN
%token ORASSIGN
%token EORASSIGN
%token SHIFTLASSIGN
%token SHIFTRASSIGN
%token EQ
%token NE
%token GTE
%token LTE
%token GT
%token LT
%token INC
%token DEC
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token AND
%token OR
%token BOOLAND
%token BOOLOR
%token BOOLNOT
%token EOR
%token LEFT
%token RIGHT
%token LEFTBR
%token RIGHTBR
%token LEFTCOMP
%token RIGHTCOMP
%token SHIFTL
%token SHIFTR
%token COMMA
%token DBLCOLON
%token CONSTANT
%token VAR
%token EXTERN
%token ENDSTAT
%token IF
%token ELSE
%token WHILE
%token DO
%token FOR
%token GOTO
%token DATA
%token STOP
%token BREAK
%token RETURN

%token <number> NUMBER
%token <string> NAME
%token <string> STRING

%type <string> label
%type <node> expression
%type <node> expr
%type <node> expr2
%type <node> expr3
%type <node> expr4
%type <node> expressions
%type <node> program
%type <node> declaration
%type <node> statement
%type <node> compstatement
%type <node> statements
%type <node> assignment
%type <node> identifier
%type <node> identifiers
%type <node> string
%type <node> strings
%type <node> unit
%type <node> units

%expect 1

%%

program:
  units
  {
    tree = $1;
  }
;

units:
  units unit
  {
    $$ = node2(UNIT_SEQ, $1, $2);
  }
| unit
  {
    $$ = $1;
  }
;

unit:
  declaration
  {
    $$ = $1;
  }
| NAME LEFT identifiers RIGHT compstatement
  {
    $$ = node2(FUNCT_BODY, $3, $5);
    $$->label = $1;
    $$->index = NULL;
  }
| NAME NAME LEFT identifiers RIGHT compstatement
  {
    $$ = node2(FUNCT_BODY, $4, $6);
    $$->label = $1;
    $$->index = $2;
  }
;

statements:
  statements statement
  {
    $$ = node2(STMT_SEQ, $1, $2);
  }
| statement
  {
    $$ = $1;
  }
;

identifiers:

  {
    $$ = node(EMPTY_STMT);
  }
| identifiers COMMA identifier
  {
    $$ = node2(IDENT_SEQ, $1, $3);
  }
| identifier
  {
    $$ = $1;
  }
;

assignment:
  identifier ASSIGN expression
  {
    $$ = node2(ASSIGN_STMT, $1, $3);
  }
| identifier INC
  {
    $$ = node1(INCASSIGN_STMT, $1);
  }
| identifier DEC
  {
    $$ = node1(DECASSIGN_STMT, $1);
  }
| identifier ADDASSIGN expression
  {
    treenode *temp = node2(ADD_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
| identifier SUBASSIGN expression
  {
    treenode *temp = node2(SUB_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
| identifier MULASSIGN expression
  {
    treenode *temp = node2(MUL_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
| identifier DIVASSIGN expression
  {
    treenode *temp = node2(DIV_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
| identifier MODASSIGN expression
  {
    treenode *temp = node2(MOD_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
| identifier ANDASSIGN expression
  {
    treenode *temp = node2(AND_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
| identifier ORASSIGN expression
  {
    treenode *temp = node2(OR_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
| identifier EORASSIGN expression
  {
    treenode *temp = node2(EOR_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
| identifier SHIFTLASSIGN expression
  {
    treenode *temp = node2(SHIFTL_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
| identifier SHIFTRASSIGN expression
  {
    treenode *temp = node2(SHIFTR_EXPR, $1, $3);
    $$ = node2(ASSIGN_STMT, $1, temp);
  }
;

declaration:
  CHUNK LEFT expression RIGHT LEFTCOMP expressions RIGHTCOMP
  {
    $$ = node2(CHUNK_STMT, $3, $6);
  }
| FLUSH
  {
    $$ = node(FLUSH_STMT);
  }
| DATA LEFT expressions RIGHT ENDSTAT
  {
    $$ = node1(DATA_STMT, $3);
  }
| LEFTCOMP expressions RIGHTCOMP
  {
    $$ = node1(DATA_STMT, $2);
  }
| NAME ALIAS NAME ENDSTAT
  {
    $$ = node(ALIAS_STMT);
    $$->name = $1;
    $$->index = $3;
   }
| label DATA LEFT expressions RIGHT ENDSTAT
  {
    $$ = node1(DATA_STMT, $4);
    $$->label = $1;
  }
| label LEFTCOMP expressions RIGHTCOMP
  {
    $$ = node1(DATA_STMT, $3);
    $$->label = $1;
  }
| CONSTANT NAME ASSIGN expression
  {
    $$ = node1(CONSTANT_DEF, $4);
    $$->name = $2;
  }
| CONSTANT NAME expression
  {
    $$ = node1(CONSTANT_DEF, $3);
    $$->name = $2;
  }
| NAME LEFT identifiers RIGHT ENDSTAT
  {
    $$ = node1(FUNCT_DEF, $3);
    $$->name = $1;
    $$->index = NULL;
  }
| NAME NAME LEFT identifiers RIGHT ENDSTAT
  {
    $$ = node1(FUNCT_DEF, $4);
    $$->name = $1;
    $$->index = $2;
  }
| EXTERN NAME LEFT identifiers RIGHT ENDSTAT
  {
    $$ = node1(EXTFUNCT_DEF, $4);
    $$->name = $2;
    $$->index = NULL;
  }
| EXTERN NAME NAME LEFT identifiers RIGHT ENDSTAT
  {
    $$ = node1(EXTFUNCT_DEF, $5);
    $$->name = $2;
    $$->index = $3;
  }
| EXTERN NAME ENDSTAT
  {
    $$ = node(EXTERN_DEF);
    $$->name = $2;
  }
| EXTERN VAR NAME ENDSTAT
  {
    $$ = node(EXTERN_DEF);
    $$->name = $3;
  }
| EXTERN VAR NAME LEFTBR RIGHTBR ENDSTAT
  {
    $$ = node(EXTERN_DEF);
    $$->name = $3;
  }
| VAR NAME ENDSTAT
  {
    $$ = node(GLOBAL_DEF);
    $$->name = $2;
  }
| VAR NAME LEFTBR expression RIGHTBR ENDSTAT
  {
    $$ = node1(GLOBALARRAY_DEF, $4);
    $$->name = $2;
  }
;

compstatement:
  LEFTCOMP RIGHTCOMP
  {
    $$ = node(EMPTY_STMT);
  }
| LEFTCOMP statements RIGHTCOMP
  {
    $$ = $2;
  }
;

statement:
  ENDSTAT
  {
    $$ = node(EMPTY_STMT);
  }
| label statement
  {
    $$ = $2;
    $$->label = $1;
  }
| compstatement
  {
    $$ = $1;
  }
| assignment ENDSTAT
  {
    $$ = $1;
  }
| LOADPTR LEFT identifier RIGHT ENDSTAT
  {
    $$ = node1(LOADPTR_STMT, $3);
  }
| IF LEFT expression RIGHT statement
  {
    $$ = node2(IF_STMT, $3, $5);
  }
| IF LEFT expression RIGHT statement ELSE statement
  {
    $$ = node3(IFELSE_STMT, $3, $5, $7);
  }
| DO statement WHILE LEFT expression RIGHT ENDSTAT
  {
    $$ = node2(REPWHILE_STMT, $2, $5);
  }
| WHILE LEFT expression RIGHT statement
  {
    $$ = node2(WHILE_STMT, $3, $5);
  }
| FOR LEFT assignment ENDSTAT expression ENDSTAT assignment RIGHT statement
  {
    $$ = node4(FORNEXT_STMT, $3, $5, $7, $9);
  }
| FOR LEFT ENDSTAT expression ENDSTAT RIGHT statement
  {
    treenode *temp = node(EMPTY_STMT);
    $$ = node4(FORNEXT_STMT, temp, $4, temp, $7);
  }
| FOR LEFT ENDSTAT expression ENDSTAT assignment RIGHT statement
  {
    treenode *temp = node(EMPTY_STMT);
    $$ = node4(FORNEXT_STMT, temp, $4, $6, $8);
  }
| FOR LEFT assignment ENDSTAT expression ENDSTAT RIGHT statement
  {
    treenode *temp = node(EMPTY_STMT);
    $$ = node4(FORNEXT_STMT, $3, $5, temp, $8);
  }
| FOR LEFT ENDSTAT ENDSTAT RIGHT statement
  {
    treenode *temp = node(EMPTY_STMT);
    $$ = node4(FORNEXT_STMT, temp, temp, temp, $6);
  }
| FOR LEFT ENDSTAT ENDSTAT assignment RIGHT statement
  {
    treenode *temp = node(EMPTY_STMT);
    $$ = node4(FORNEXT_STMT, temp, temp, $5, $7);
  }
| FOR LEFT assignment ENDSTAT ENDSTAT RIGHT statement
  {
    treenode *temp = node(EMPTY_STMT);
    $$ = node4(FORNEXT_STMT, $3, temp, temp, $7);
  }
| SWITCH LEFT expression RIGHT statement
  {
    $$ = node2(SWITCH_STMT, $3, $5);
  }
| CASE expression DBLCOLON
  {
    $$ = node1(CASE_STMT, $2);
  }
| DEFAULT DBLCOLON
  {
    $$ = node(DEFAULTCASE_STMT);
  }
| NAME LEFT expressions RIGHT ENDSTAT
  {
    $$ = node1(FUNCT_STMT, $3);
    $$->name = $1;
  }
| GOTO NAME ENDSTAT
  {
    $$ = node(GOTO_STMT);
    $$->name = $2;
  }
| RETURN ENDSTAT
  {
    $$ = node(RETURN_STMT);
  }
| RETURN LEFT RIGHT ENDSTAT
  {
    $$ = node(RETURN_STMT);
  }
| RETURN expression ENDSTAT
  {
    $$ = node1(RETURNEXPR_STMT, $2);
  }
| STOP ENDSTAT
  {
    $$ = node(STOP_STMT);
  }
| STOP LEFT RIGHT ENDSTAT
  {
    $$ = node(STOP_STMT);
  }
| BREAK ENDSTAT
  {
    $$ = node(BREAK_STMT);
  }
;

expressions:

  {
    $$ = node(EMPTY_STMT);
  }
| expression
  {
    $$ = $1;
  }
| expressions COMMA expression
  {
    $$ = node2(EXPR_SEQ, $1, $3);
  }
;

string:
  STRING
  {
    $$ = node(STRINGDEF);
    $$->name = $1;
  }
;

strings:
  string
  {
    $$ = $1;
  }
| strings string
  {
    $$ = node2(STRINGDEF_SEQ, $1, $2);
  }
;

label:
  NAME DBLCOLON
  {
    $$ = $1;
  }
;

identifier:
  NAME
  {
    $$ = node(ABS_IDENT);
    $$->name = $1;
  }
| NAME LEFTBR expression RIGHTBR
  {
    $$ = node1(SUB_IDENT, $3);
    $$->name = $1;
  }
;

expression:
  expr
  {
    $$ = $1;
  }
| strings
  {
    $$ = $1;
  }
| expr EQ expr
  {
    $$ = node2(EQ_EXPR, $1, $3);
  }
| expr NE expr
  {
    $$ = node2(NE_EXPR, $1, $3);
  }
| expr GT expr
  {
    $$ = node2(GT_EXPR, $1, $3);
  }
| expr LT expr
  {
    $$ = node2(LT_EXPR, $1, $3);
  }
| expr GTE expr
  {
    $$ = node2(GTE_EXPR, $1, $3);
  }
| expr LTE expr
  {
    $$ = node2(LTE_EXPR, $1, $3);
  }
| expr BOOLOR expr
  {
    $$ = node2(OR_EXPR, $1, $3);
  }
| expr BOOLAND expr
  {
    $$ = node2(AND_EXPR, $1, $3);
  }
| BOOLNOT expr
  {
    $$ = node1(NOT_EXPR, $2);
  }
;

expr:
  expr2
  {
    $$ = $1;
  }
| DATA LEFT expressions RIGHT
  {
    $$ = node1(DATA_STMT, $3);
  }
| LEFTCOMP expressions RIGHTCOMP
  {
    $$ = node1(DATA_STMT, $2);
  }
| NAME LEFT expressions RIGHT
  {
    $$ = node1(FUNCT_EXPR, $3);
    $$->name = $1;
  }
| expr SHIFTL expr2
  {
    $$ = node2(SHIFTL_EXPR, $1, $3);
  }
| expr SHIFTR expr2
  {
    $$ = node2(SHIFTR_EXPR, $1, $3);
  }
| expr EOR expr2
  {
    $$ = node2(EOR_EXPR, $1, $3);
  }
| expr OR expr2
  {
    $$ = node2(OR_EXPR, $1, $3);
  }
| expr AND expr2
  {
    $$ = node2(AND_EXPR, $1, $3);
  }
;

expr2:
  expr3
  {
    $$ = $1;
  }
| expr2 ADD expr3
  {
    $$ = node2(ADD_EXPR, $1, $3);
  }
| expr2 SUB expr3
  {
    $$ = node2(SUB_EXPR, $1, $3);
  }
;

expr3:
  expr4
  {
    $$ = $1;
  }
| expr3 MOD expr4
  {
    $$ = node2(MOD_EXPR, $1, $3);
  }
| expr3 DIV expr4
  {
    $$ = node2(DIV_EXPR, $1, $3);
  }
| expr3 MUL expr4
  {
    $$ = node2(MUL_EXPR, $1, $3);
  }
;

expr4:
  ADD expr4
  {
    $$ = $2;
  }
| SUB expr4
  {
    $$ = node1(NEG_EXPR, $2);
  }
| LEFT expression RIGHT
  {
    $$ = $2;
  }
| NUMBER
  {
    $$ = node(IMM_EXPR);
    $$->number = $1;
  }
| identifier
  {
    $$ = $1;
  }
;

%%
