%{
/*------------------------------------------------------------------------*/
/* Lexical input for LEX for LALR(1) Grammar for ANSI Ada                 */
/*                                                                        */
/*              Herman Fischer                                            */
/*            Litton Data Systems                                         */
/*              March 26, 1984                                            */
/*                                                                        */
/* Accompanies Public Domain YACC format Ada grammar                      */
/*                                                                        */
/*                                                                        */
/*                                                                        */
/*                                                                        */
/*                                                                        */
/*                                                                        */
/*                                                                        */
/*------------------------------------------------------------------------*/
/* #include        "y.tab.h"*/
int             lines = 1;      /* line number being processed */

char id_string[256];            /* identifier being processed  */
char char_lit[256];             /* character or string literal */
char num_lit[80];               /* numeric literal             */
int num_errors = 0;             /* number of errors encountered*/

#define linenum printf("\n[%d]\t",++lines)
%}

%START IDENT Z

%%
ABORT|abort     {ECHO; BEGIN Z; return(ABORT_);}
ABS|abs         {ECHO; BEGIN Z; return(ABS_);}
ACCEPT|accept   {ECHO; BEGIN Z; return(ACCEPT_);}
ACCESS|access   {ECHO; BEGIN Z; return(ACCESS_);}
ALL|all         {ECHO; BEGIN Z; return(ALL_);}
AND|and         {ECHO; BEGIN Z; return(AND_);}
ARRAY|array     {ECHO; BEGIN Z; return(ARRAY_);}
AT|at           {ECHO; BEGIN Z; return(AT_);}
BEGIN|begin     {ECHO; BEGIN Z; return(BEGIN_);}
BODY|body       {ECHO; BEGIN Z; return(BODY_);}
CASE|case       {ECHO; BEGIN Z; return(CASE_);}
CONSTANT|constant {ECHO; BEGIN Z; return(CONSTANT_);}
DECLARE|declare {ECHO; BEGIN Z; return(DECLARE_);}
DELAY|delay     {ECHO; BEGIN Z; return(DELAY_);}
DELTA|delta     {ECHO; BEGIN Z; return(DELTA_);}
DIGITS|digits   {ECHO; BEGIN Z; return(DIGITS_);}
DO|do           {ECHO; BEGIN Z; return(DO_);}
ELSE|else       {ECHO; BEGIN Z; return(ELSE_);}
ELSIF|elsif     {ECHO; BEGIN Z; return(ELSIF_);}
END|end         {ECHO; BEGIN Z; return(END_);}
ENTRY|entry     {ECHO; BEGIN Z; return(ENTRY_);}
EXCEPTION|exception {ECHO; BEGIN Z; return(EXCEPTION_);}
EXIT|exit       {ECHO; BEGIN Z; return(EXIT_);}
FOR|for         {ECHO; BEGIN Z; return(FOR_);}
FUNCTION|function {ECHO; BEGIN Z; return(FUNCTION_);}
GENERIC|generic {ECHO; BEGIN Z; return(GENERIC_);}
GOTO|goto       {ECHO; BEGIN Z; return(GOTO_);}
IF|if           {ECHO; BEGIN Z; return(IF_);}
IN|in           {ECHO; BEGIN Z; return(IN_);}
IS|is           {ECHO; BEGIN Z; return(IS_);}
LIMITED|limited {ECHO; BEGIN Z; return(LIMITED_);}
LOOP|loop       {ECHO; BEGIN Z; return(LOOP_);}
MOD|mod         {ECHO; BEGIN Z; return(MOD_);}
NEW|new         {ECHO; BEGIN Z; return(NEW_);}
NOT|not         {ECHO; BEGIN Z; return(NOT_);}
NULL|null       {ECHO; BEGIN Z; return(NULL_);}
OF|of           {ECHO; BEGIN Z; return(OF_);}
OR|or           {ECHO; BEGIN Z; return(OR_);}
OTHERS|others   {ECHO; BEGIN Z; return(OTHERS_);}
OUT|out         {ECHO; BEGIN Z; return(OUT_);}
PACKAGE|package {ECHO; BEGIN Z; return(PACKAGE_);}
PRAGMA|pragma   {ECHO; BEGIN Z; return(PRAGMA_);}
PRIVATE|private {ECHO; BEGIN Z; return(PRIVATE_);}
PROCEDURE|procedure {ECHO; BEGIN Z; return(PROCEDURE_);}
RAISE|raise     {ECHO; BEGIN Z; return(RAISE_);}
RANGE|range     {ECHO; BEGIN Z; return(RANGE_);}
RECORD|record   {ECHO; BEGIN Z; return(RECORD_);}
REM|rem         {ECHO; BEGIN Z; return(REM_);}
RENAMES|renames {ECHO; BEGIN Z; return(RENAMES_);}
RETURN|return   {ECHO; BEGIN Z; return(RETURN_);}
REVERSE|reverse {ECHO; BEGIN Z; return(REVERSE_);}
SELECT|select   {ECHO; BEGIN Z; return(SELECT_);}
SEPARATE|separate {ECHO; BEGIN Z; return(SEPARATE_);}
SUBTYPE|subtype {ECHO; BEGIN Z; return(SUBTYPE_);}
TASK|task       {ECHO; BEGIN Z; return(TASK_);}
TERMINATE|terminate {ECHO; BEGIN Z; return(TERMINATE_);}
THEN|then       {ECHO; BEGIN Z; return(THEN_);}
TYPE|type       {ECHO; BEGIN Z; return(TYPE_);}
USE|use         {ECHO; BEGIN Z; return(USE_);}
WHEN|when       {ECHO; BEGIN Z; return(WHEN_);}
WHILE|while     {ECHO; BEGIN Z; return(WHILE_);}
WITH|with       {ECHO; BEGIN Z; return(WITH_);}
XOR|xor         {ECHO; BEGIN Z; return(XOR_);}
"=>"    {ECHO; BEGIN Z; return(ARROW_);}
".."    {ECHO; BEGIN Z; return(DBLDOT_);}
"**"    {ECHO; BEGIN Z; return(EXP_);}
":="    {ECHO; BEGIN Z; return(ASSIGN_);}
"/="    {ECHO; BEGIN Z; return(NOTEQL_);}
">="    {ECHO; BEGIN Z; return(GTEQL_);}
"<="    {ECHO; BEGIN Z; return(LTEQ_);}
"<<"    {ECHO; BEGIN Z; return(L_LBL_);}
">>"    {ECHO; BEGIN Z; return(R_LBL_);}
"<>"    {ECHO; BEGIN Z; return(BOX_);}
"&"     {ECHO; BEGIN Z; return('&'); }
"("     {ECHO; BEGIN Z; return('('); }
")"     {ECHO; BEGIN IDENT; return(')'); }
"*"     {ECHO; BEGIN Z; return('*'); }
"+"     {ECHO; BEGIN Z; return('+'); }
","     {ECHO; BEGIN Z; return(','); }
"-"     {ECHO; BEGIN Z; return('-'); }
"."     {ECHO; BEGIN Z; return('.'); }
"/"     {ECHO; BEGIN Z; return('/'); }
":"     {ECHO; BEGIN Z; return(':'); }
";"     {ECHO; BEGIN Z; return(';'); }
"<"     {ECHO; BEGIN Z; return('<'); }
"="     {ECHO; BEGIN Z; return('='); }
">"     {ECHO; BEGIN Z; return('>'); }
"|"     {ECHO; BEGIN Z; return('|'); }
<IDENT>\'  {ECHO; BEGIN Z; return('\'');}   /* type mark only */


[a-zA-Z]([_]?[a-zA-Z0-9])*   {ECHO; BEGIN IDENT; strcpy(id_string,yytext);
                              return(identifier);}
[0-9][0-9_]*([.][0-9_]+)?([Ee][-+]?[0-9_]+)?  {
                              ECHO; BEGIN Z; strcpy(num_lit,yytext);
                              return(numeric_literal);}

[0-9][0-9_]*#[0-9a-fA-F_]+([.][0-9a-fA-F_]+)?#([Ee][-+]?[0-9_]+)? {
                              ECHO; BEGIN Z; strcpy(num_lit,yytext);
                              return(numeric_literal);}


\"([^"]*(\"\")*)*\" {ECHO; BEGIN Z; strcpy(char_lit,yytext);
                          return(string_literal);}
<Z>\'.\'    {ECHO; BEGIN Z; strcpy(char_lit,yytext);
                          return(character_literal);}


[ \t]   ECHO;          /* ignore spaces and tabs */
"--".*  ECHO;          /* ignore comments to end-of-line */

.       {ECHO; printf("?? lexical error [%s] ??\n\t", yytext);
                                           /* unlexable chars */
        ++num_errors;}
[\n]    linenum;
%%
