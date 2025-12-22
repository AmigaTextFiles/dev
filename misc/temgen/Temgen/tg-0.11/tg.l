%{
#include "y.tab.h"
#include "alloc.h"
#include "sysdefs.h"
#include "txttab.h"
    
YYSTYPE  yylval;

void no_operation() {};
#define  dprintf  no_operation

int lineno = 1;
int charno = 0;

extern struct txttab *text_table;

#define    SETYYLVAL(v)  { v.line=lineno; v.start=charno; \
                           charno+=strlen(yytext); v.end=charno; \
                           tt_token( text_table, yytext ); }

#define    STORETEXT()   { tt_token( text_table, yytext ); }                           

                                               
                           
%}

%%


\\.            {  dprintf( "ESC(%c)\n", yytext[1]); 
                  SETYYLVAL( yylval.i );
                  yylval.i.val=yytext[1]; 
                  return TOK_CHAR; }
[0-9]+         {  yylval.i.val = atoi( yytext ); 
                  SETYYLVAL( yylval.i );
                  dprintf("int(%d)\n", yylval.i.val);  
                  return TOK_NUM; }
[0-9]+\.[0-9]+ {  yylval.f.val = atof( yytext ); 
                  SETYYLVAL( yylval.f );
                  dprintf("num(%f)\n", yylval.f.val);  
                  return TOK_FLOAT; }
\in            {  
                  SETYYLVAL( yylval.i );
                  return TOK_IN; }
[a-zA-Z_][a-zA-Z_0-9]*      { yylval.s.val = STRDUP( yytext ); 
                              SETYYLVAL( yylval.s );
                              dprintf("name '%s'\n",yytext);  
                              return TOK_NAME; }
[ \t]*         {  SETYYLVAL( yylval.s ); }
\\[ \t]*\n@    {  SETYYLVAL( yylval.s );  /* line continuation */
                  lineno++; charno=0;  }
\#.*\n         {  SETYYLVAL( yylval.s );  /* #-comment */
                  tt_store( text_table, lineno );
                  lineno++; charno=0; 
                  return TOK_NL; }
'[^'\n]*'      {  yylval.s.val = STRDUP( yytext );
                  SETYYLVAL( yylval.s );
                  dprintf( "%s", yytext ); return TOK_STRING; }
\"[^\"\n]*\"   {  yylval.s.val = STRDUP( yytext );
                  SETYYLVAL( yylval.s );
                  dprintf( "%s", yytext ); return TOK_STRING; }

^@             {  STORETEXT();
                  yylval.i.line=lineno; return TOK_AT; } 
\$             {  
                  SETYYLVAL( yylval.s );
                  return TOK_DOL;  }                 
\.             {  
                  SETYYLVAL( yylval.s );
                  return TOK_DOT;  }
\,             {  
                  SETYYLVAL( yylval.s );
                  return TOK_COM;  }
\==            {  
                  SETYYLVAL( yylval.i );
                  return TOK_EQEQ;  }
\!=            {  
                  SETYYLVAL( yylval.i );
                  return TOK_NE;  }
\=             {  
                  SETYYLVAL( yylval.i );
                  return TOK_EQ;  }
\<             {  
                  SETYYLVAL( yylval.i );
                  return TOK_LT;  }
\>             {  
                  SETYYLVAL( yylval.i );
                  return TOK_GT;  }
\<=            {  
                  SETYYLVAL( yylval.i );
                  return TOK_LTEQ;  }
\>=            {  
                  SETYYLVAL( yylval.i );
                  return TOK_GTEQ;  }
\!             {  
                  SETYYLVAL( yylval.i );
                  return TOK_NOT;   }
\*             {  
                  SETYYLVAL( yylval.s );
                  return TOK_STAR;  }
\+             {  
                  SETYYLVAL( yylval.s );
                  return TOK_PLUS;  }
\-             {  
                  SETYYLVAL( yylval.s );
                  return TOK_MINUS;  }
\/             {  
                  SETYYLVAL( yylval.s );
                  return TOK_DIV;  }
\*=            {  
                  SETYYLVAL( yylval.s );
                  return TOK_MUL_S; }
\+=            {  
                  SETYYLVAL( yylval.s );
                  return TOK_PLUS_S; }
\-=            {  
                  SETYYLVAL( yylval.s );
                  return TOK_MINUS_S;  }
\/=            {  
                  SETYYLVAL( yylval.s );
                  return TOK_DIV_S;  }
\++            {  
                  SETYYLVAL( yylval.s );
                  return TOK_PLUSPLUS;  }
\--            {  
                  SETYYLVAL( yylval.s );
                  return TOK_MINUSMINUS;  }
\|\|           {  
                  SETYYLVAL( yylval.s );
                  return TOK_OR; }
\&\&           {  
                  SETYYLVAL( yylval.s );
                  return TOK_AND; }
\(             {  
                  SETYYLVAL( yylval.s );
                  return TOK_OPEN;  }
\)             {  
                  SETYYLVAL( yylval.s );
                  return TOK_CLOSE;  }
\[             {  
                  SETYYLVAL( yylval.s );
                  return TOK_OPENB;  }
\]             {  
                  SETYYLVAL( yylval.s );
                  return TOK_CLOSEB;  }
\:             {  
                  SETYYLVAL( yylval.i );
                  return TOK_COLON;  }
\;             {  
                  SETYYLVAL( yylval.i );
                  return TOK_SCOL;   }
\n             {  
                  SETYYLVAL( yylval.s );
                  tt_store( text_table, lineno );
                  lineno++; charno=0; 
                  return TOK_NL; }
.              { 
                  SETYYLVAL( yylval.i );
                  yylval.i.val=yytext[0]; 
               /* printf( "CHAR: %d\n", yytext[0] ); */
                  return TOK_CHAR; }
^@[ \t]*if           { STORETEXT(); yylval.i.line=lineno; return TOK_IF; }    
^@[ \t]*else         { STORETEXT(); yylval.i.line=lineno; return TOK_ELSE; }    
^@[ \t]*endif        { STORETEXT(); yylval.i.line=lineno; return TOK_ENDIF; }   
^@[ \t]*embed        { STORETEXT(); yylval.i.line=lineno; return TOK_EMBED; }   
^@[ \t]*emit         { STORETEXT(); yylval.i.line=lineno; return TOK_EMIT; }  
^@[ \t]*function     { STORETEXT(); yylval.i.line=lineno; return TOK_FUNCTION; }
^@[ \t]*endfunction  { STORETEXT(); yylval.i.line=lineno; return TOK_ENDFUNCTION; }
^@[ \t]*switch       { STORETEXT(); yylval.i.line=lineno; return TOK_SWITCH; }
^@[ \t]*case         { STORETEXT(); yylval.i.line=lineno; return TOK_CASE; }
^@[ \t]*for          { STORETEXT(); yylval.i.line=lineno; return TOK_FOR; }
^@[ \t]*endswitch    { STORETEXT(); yylval.i.line=lineno; return TOK_ENDSWITCH;}
^@[ \t]*endfor       { STORETEXT(); yylval.i.line=lineno; return TOK_ENDFOR; }
^@[ \t]*return       { STORETEXT(); yylval.i.line=lineno; return TOK_RETURN; }
^@[ \t]*break        { STORETEXT(); yylval.i.line=lineno; return TOK_BREAK; }
^@[ \t]*push         { STORETEXT(); yylval.i.line=lineno; return TOK_PUSH; }
^@[ \t]*pop          { STORETEXT(); yylval.i.line=lineno; return TOK_POP; }
^@[ \t]*output       { STORETEXT(); yylval.i.line=lineno; return TOK_OUTPUT; }
^@[ \t]*local        { STORETEXT(); yylval.i.line=lineno; return TOK_LOCAL; }
^@[ \t]*use          { STORETEXT(); yylval.i.line=lineno; return TOK_USE; }
^@[ \t]*exit         { STORETEXT(); yylval.i.line=lineno; return TOK_EXIT; }

%%


