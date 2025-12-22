GLOBAL {#include "Tree.h"
        typedef struct {tScanAttribute Scan;
                        tTree v;             } tParsAttribute;}


TOKEN

strings          = 1
digis            = 2

"BEGIN"          = 3
"END"            = 4
"CONST"          = 5
"VAR"            = 6
"PROCEDURE"      = 7
"TYPE"           = 8
"ARRAY"          = 9
"OF"             = 10
"IF"             = 11
"THEN"           = 12
"ELSIF"          = 13
"ELSE"           = 14
"WHILE"          = 15
"DO"             = 16
"OR"             = 17
"AND"            = 18
"NOT"            = 19
"ODD"            = 20
"?"              = 21
"!"              = 22

"="              = 23
"#"              = 24
"<"              = 25
">"              = 26
"<="             = 27
">="             = 28
"+"              = 29
"-"              = 30
"*"              = 31
"/"              = 32
":="             = 33

","              = 34
";"              = 35
"."              = 36
"("              = 37
")"              = 38
"["              = 39
"]"              = 40
":"              = 41

identy           = 42


OPER

NONE "=" "<=" ">=" "<" ">" "#"
LEFT "-" "+"
LEFT "*" "/"
LEFT "ODD"


RULE

prog          : block "."
                {tTree t;
                 t = mprogram($1.v); 
                 CheckTree(t); 
                 WriteTree(stdout,t);}.

block         : declaration_s
                "BEGIN"
                   statements
                "END"
                {$$.v = mblock($1.v,$3.v);}.
  
declaration_s : declaration_s declaration
                {$$.v = mdecls1($2.v,$1.v);}.
declaration_s :
                {$$.v = mdecls0();}.

declaration   : "CONST" const_s ";"
                {$$.v = mconstdefs($2.v);}.
declaration   : "VAR" var_s ":" type ";"
                {$$.v = mvardefs($2.v,$4.v);}.
declaration   : "TYPE" ident "=" type ";"
                {$$.v = mtypedefs($2.v,$4.v);}.
declaration   : "PROCEDURE" ident parameter_s ";" block ";"
                {$$.v = mproceduredefs($2.v,$3.v,$5.v);}.

const_s       : const_s "," const
                {$$.v = mconst1($3.v,$1.v);}.
const_s       : const
                {$$.v = mconst1($1.v,mconst0());}.

const         : ident "=" digi
                {$$.v = mConst($1.v,$3.v);}.

var_s         : var_s "," var
                {$$.v = mvar1($3.v,$1.v);}.
var_s         : var
                {$$.v = mvar1($1.v,mvar0());}.

var           : ident
                {$$.v = mvar($1.v);}.

type          : ident
                {$$.v = mtyp1($1.v);}.
type          : "ARRAY" digi "OF" type
                {$$.v = mtyp2($2.v,$4.v);}.

parameter_s   : 
                {$$.v = mpar0();}.
parameter_s   : "(" parameterx ")"
                {$$.v = mpar1($2.v);}.

parameterx    : parameterx ";" parameter
                {$$.v = mparameter1($3.v,$1.v);}.
parameterx    : parameter
                {$$.v = mparameter1($1.v,mparameter0());}.

parameter     : "VAR" para_s ":" type
                {$$.v = mparameter($2.v,$4.v,1);}.
parameter     : para_s ":" type
                {$$.v = mparameter($1.v,$3.v,0);}.

para_s        : ident
                {$$.v = mident1($1.v,mident0());}.
para_s        : para_s "," ident
                {$$.v = mident1($3.v,$1.v);}.

statements    : statement
                {$$.v = mstats0($1.v);}.
statements    : statements ";" statement
                {$$.v = mstats1($3.v,$1.v);}.

statement     : 
                {$$.v = mstat0();}.
statement     : variable ":=" formula
                {$$.v = mstat1($1.v,$3.v);}.
statement     : ident
                {$$.v = mstat2($1.v,mact0());}.
statement     : ident "(" actuals ")"
                {$$.v = mstat2($1.v,$2.v);}.
statement     : "?" variable
                {$$.v = mstat3($2.v);}.
statement     : "!" formula
                {$$.v = mout1($2.v);}.
statement     : "!" string
                {$$.v = mout2($2.v);}.

statement     : "IF" formula "THEN" statements if_s "END" "IF"
                {$$.v = mstat5($2.v,$4.v,$5.v);}.

statement     : "WHILE" formula "DO" statements "END" "WHILE"
                {$$.v = mstat6($2.v,$4.v);}.

if_s          : 
                {$$.v = mels0();}.
if_s          : if_s "ELSE" statements
                {$$.v = mels1($3.v);}.
if_s          : if_s "ELSIF" formula "THEN" statements
                {$$.v = mels1(mstat5($3.v,$5.v,$1.v));}.

formula       : conjunction
                {$$.v = mforms0($1.v);}.
formula       : formula "OR" conjunction
                {$$.v = mforms1($3.v,$1.v);}.

conjunction   : relation
                {$$.v = mconjs0($1.v);}.
conjunction   : conjunction "AND" relation
                {$$.v = mconjs1($3.v,$1.v);}.

relation      : expression
                {$$.v = mrel0($1.v);}.
relation      : expression "=" expression
                {$$.v = mrel1($1.v,0,$3.v);}.
relation      : expression "#" expression
                {$$.v = mrel1($1.v,1,$3.v);}.
relation      : expression "<" expression
                {$$.v = mrel1($1.v,2,$3.v);}.
relation      : expression ">" expression
                {$$.v = mrel1($1.v,3,$3.v);}.
relation      : expression "<=" expression
                {$$.v = mrel1($1.v,4,$3.v);}.
relation      : expression ">=" expression
                {$$.v = mrel1($1.v,5,$3.v);}.

expression    : ["+"] exp_s term
                {$$.v = mexpression(0,$2.v,$3.v);}.
expression    : "-" exp_s term
                {$$.v = mexpression(-1,$2.v,$3.v);}.

exp_s         : 
                {$$.v = mexps0();}.
exp_s         : exp_s term "+"
                {$$.v = mexps1(mexp($2.v,0),$1.v);}.
exp_s         : exp_s term "-"
                {$$.v = mexps1(mexp($2.v,-1),$1.v);}.

term          : term_s factor
                {$$.v = mterm($1.v,$2.v);}.

term_s        : 
                {$$.v = mtes0();}.
term_s        : term_s factor "*"
                {$$.v = mtes1(mte($2.v,1),$1.v);}.
term_s        : term_s factor "/"
                {$$.v = mtes1(mte($2.v,2),$1.v);}.

factor        : variable
                {$$.v = mfact1($1.v);}.
factor        : digi
                {$$.v = mfact2($1.v);}.
factor        : "ODD" factor
                {$$.v = mfact3(1,$2.v);}.
factor        : "NOT" factor
                {$$.v = mfact3(2,$2.v);}.
factor        : "(" formula ")"
                {$$.v = mfact4($2.v);}.

variable      : ident variable_s
                {$$.v = mvariable($1.v,$2.v);}.

variable_s    : 
                {$$.v = marr0();}.
variable_s    : variable_s "[" expression "]"
                {$$.v = marr1($3.v,$1.v);}.

actuals       : formula
                {$$.v = mact1($1.v,mact0());}.
actuals       : actuals "," formula
                {$$.v = mact1($3.v,$1.v);}.

ident         : identy
                {$$.v = mident($1.Scan.lexid);}.

string        : strings
                {$$.v = mstring($1.Scan.lexstring);}.

digi          : digis
                {$$.v = mnumber($1.Scan.lexstring);}.
