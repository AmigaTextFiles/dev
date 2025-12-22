%x incl

%{
#include <string.h>
#include <stdio.h>
#include "tree.h"
#include "cs_tab.h"

#define MAX_INCLUDE_DEPTH 10

void yyerror(char *str);

YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
char *filename_stack[MAX_INCLUDE_DEPTH];
int lineno_stack[MAX_INCLUDE_DEPTH];
char *filename;

int include_stack_ptr = 0;
int lineno = 1;
%}

%%
"#include" BEGIN(incl);
"include" BEGIN(incl);
<incl>[ \t]+ { }
<incl>[^ \t\n]+\n {
  unsigned c;
  lineno++;
  if ((yytext[0] == '<') || (yytext[0] == '\"'))
  {
    strcpy(&yytext[0], &yytext[1]);
  }
  for (c = 0; c < strlen(yytext); c++)
  {
    if ((yytext[c] == '\n') || (yytext[c] == '>') || (yytext[c] == '\"'))
    {
      yytext[c] = 0;
      break;
    }
  }
  if ( include_stack_ptr >= MAX_INCLUDE_DEPTH )
  {
    yyerror("too much nested includes");
    exit(1);
  }
  include_stack[include_stack_ptr] = YY_CURRENT_BUFFER;
  lineno_stack[include_stack_ptr] = lineno;
  filename_stack[include_stack_ptr] = filename;
  include_stack_ptr++;
  yyin = fopen(yytext, "rt");
  filename = strdup(yytext);
  if (!yyin)
  {
    yyerror("couldn't open include file");
    exit(1);
  }
  lineno = 1;
  yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
  BEGIN(INITIAL);
}
<<EOF>> {
  if ( --include_stack_ptr < 0 )
  {
    yyterminate();
  }
  else
  {
    yy_delete_buffer(YY_CURRENT_BUFFER);
    yy_switch_to_buffer(include_stack[include_stack_ptr]);
    lineno = lineno_stack[include_stack_ptr];
    filename = filename_stack[include_stack_ptr];
  }
}

"=" { return ASSIGN; }
">" { return GT; }
"<" { return LT; }
"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"%" { return MOD; }
"^" { return EOR; }
"&" { return AND; }
"|" { return OR; }
"(" { return LEFT; }
")" { return RIGHT; }
"[" { return LEFTBR; }
"]" { return RIGHTBR; }
"{" { return LEFTCOMP; }
"}" { return RIGHTCOMP; }
":" { return DBLCOLON; }
";" { return ENDSTAT; }
"," { return COMMA; }
"!" { return BOOLNOT; }
"==" { return EQ; }
"!=" { return NE; }
">=" { return GTE; }
"<=" { return LTE; }
"+=" { return ADDASSIGN; }
"-=" { return SUBASSIGN; }
"*=" { return MULASSIGN; }
"/=" { return DIVASSIGN; }
"%=" { return MODASSIGN; }
"^=" { return EORASSIGN; }
"&=" { return ANDASSIGN; }
"|=" { return ORASSIGN; }
"++" { return INC; }
"--" { return DEC; }
"&&" { return BOOLAND; }
"||" { return BOOLOR; }
"<<" { return SHIFTL; }
">>" { return SHIFTR; }
"switch" { return SWITCH; }
"case" { return CASE; }
"default" { return DEFAULT; }
"alias" { return ALIAS; }
"extern" { return EXTERN; }
"constant" { return CONSTANT; }
"#define" { return CONSTANT; }
"#flush" { return FLUSH; }
"#flushdata" { return FLUSH; }
"var" { return VAR; }
"variable" { return VAR; }
"char" { return VAR; }
"loadptr" { return LOADPTR; }
"chunk" { return CHUNK; }
"if" { return IF; }
"else" { return ELSE; }
"while" { return WHILE; }
"do" { return DO; }
"for" { return FOR; }
"goto" { return GOTO; }
"return" { return RETURN; }
"stop" { return STOP; }
"data" { return DATA; }
"break" { return BREAK; }
'[a-zA-Z0-9]' { yylval.number = yytext[1]; return NUMBER; }
[0-9]+ { yylval.number = atoi(yytext); return NUMBER; }
0x[a-f0-9]+ { sscanf(yytext, "0x%x", &yylval.number); return NUMBER; }
$[a-f0-9]+ { sscanf(yytext, "$%x", &yylval.number); return NUMBER; }
0x[A-F0-9]+ { sscanf(yytext, "0x%X", &yylval.number); return NUMBER; }
$[A-F0-9]+ { sscanf(yytext, "$%X", &yylval.number); return NUMBER; }
[a-z_A-Z][a-z_A-Z0-9]* { yylval.string = strdup(yytext); return NAME; }
\"(\\.|[^\\"])*\" { yylval.string = strdup(yytext); return STRING; }
"//" {
  char c;

  for (;;)
  {
    c = input();
    if ((c == '\n') || (c == 0)) break;
  }
  lineno++;
}
\r { }
\n { lineno++; }
[ \t]+ { }
. {
  char textbuf[80];
  sprintf(textbuf, "unrecognized token %s", yytext);
  yyerror(textbuf);
}

%%
