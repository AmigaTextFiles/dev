%token   <i>   TOK_NUM         
%token   <f>   TOK_FLOAT             
%token   <s>   TOK_NAME                  
%token   <s>   TOK_STRING              
%token   <i>   TOK_CHAR                       
%token   <s>   TOK_DOL
%token   <s>   TOK_DIV
%token   <s>   TOK_DOT
%token   <s>   TOK_COM
%token   <s>   TOK_STAR
%token   <s>   TOK_PLUS
%token   <s>   TOK_MINUS
%token   <i>   TOK_PLUSPLUS
%token   <i>   TOK_MINUSMINUS
%token   <i>   TOK_PLUS_S
%token   <i>   TOK_MINUS_S
%token   <i>   TOK_DIV_S
%token   <i>   TOK_MUL_S 
%token   <s>   TOK_CLOSE
%token   <s>   TOK_CLOSEB
%token   <s>   TOK_NL
%token   <s>   TOK_OPEN
%token   <s>   TOK_OPENB
%token   <i>   TOK_COLON
%token   <i>   TOK_SCOL 
%token   <i>   TOK_AT   
%token   <i>   TOK_EQ   
%token   <i>   TOK_IN   
%token   <i>   TOK_EQEQ   
%token   <i>   TOK_LT     
%token   <i>   TOK_NE     
%token   <i>   TOK_GT     
%token   <i>   TOK_NOT    
%token   <i>   TOK_AND    
%token   <i>   TOK_OR     
%token   <i>   TOK_LTEQ   
%token   <i>   TOK_GTEQ   

%token   <i>   TOK_IF
%token   <i>   TOK_ELSE
%token   <i>   TOK_ENDIF
%token   <i>   TOK_EMBED
%token   <i>   TOK_EMIT 
%token   <i>   TOK_OUTPUT
%token   <i>   TOK_LOCAL 
%token   <i>   TOK_PUSH 
%token   <i>   TOK_POP  
%token   <i>   TOK_FUNCTION
%token   <i>   TOK_ENDFUNCTION
%token   <i>   TOK_SWITCH
%token   <i>   TOK_CASE
%token   <i>   TOK_FOR
%token   <i>   TOK_ENDSWITCH
%token   <i>   TOK_ENDFOR
%token   <i>   TOK_RETURN
%token   <i>   TOK_BREAK 
%token   <i>   TOK_USE   
%token   <i>   TOK_EXIT  

%type    <p>   obj
%type    <p>   ear
%type    <p>   exp
%type    <p>   array
%type    <p>   record
%type    <p>   constructor
%type    <p>   emul
%type    <l>   data_line
%type    <l>   ctl_cmd  
%type    <l>   cmd_if   
%type    <l>   cmd_function
%type    <l>   cmd_switch
%type    <l>   cmd_for
%type    <l>   cmd_exp
%type    <l>   cmd_embed
%type    <l>   cmd_emit
%type    <l>   cmd_output
%type    <l>   cmd_local 
%type    <l>   cmd_return
%type    <l>   cmd_break 
%type    <l>   cmd_push  
%type    <l>   cmd_pop   
%type    <l>   cmd_use   
%type    <l>   cmd_exit   
%type    <p>   fun_body  
%type    <p>   objpart
%type    <p>   forctl 
%type    <p>   optexp 
%type    <p>   case_list
%type    <p>   case_item
%type    <p>   param_list
%type    <p>   param_list1
%type    <s>   other_token
%type    <p>   dol_exp     
%type    <p>   smp_exp     
%type    <p>   arglist     
%type    <p>   arglist1 
%type    <i>   relop

%union  {
    struct int_rec {
            int            val;
            int            line;
            int            start, end;
    } i;

    struct float_rec {
            float          val;
            int            line;
            int            start, end;
    } f;
    
    struct char_rec {
            char          *val;
            int            line;
            int            start, end;
    } s;
    
    struct ptr_rec {
            void          *val;
            int            line;
            int            start, end;
    } p;
    
    struct line_rec {
        int    line;
        struct command *cmd;
    } l;
}

%{
#include "alloc.h"
#include "generator.h"    
#include "util.h"    
    
#include <stdio.h>
#define FL     fflush(stdout);    
#define dpr    printf 
#define P(s)   {dpr(s);}

#undef  YYDEBUG        
#define YYDEBUG 1

#undef  YYERROR_VERBOSE        
#define YYERROR_VERBOSE   1
    
int   yydebug = 0;        
char *errmsg = "syntax error";

extern struct txttab *text_table;
extern struct lintab *line_table;
extern int curfilen;
extern int lineno;

#define  ERR(msg) save_error(atom_name(curfilen), lineno, msg)
%}

%%
lines: 
  |    cmd                        
  |    lines eol                  
  |    lines eol cmd          
  ;
  
eol:   TOK_NL                     { close_line( $1.line, $1.end ); }
  ;
  
cmd:   data_line                  {          
                                    lt_set( line_table, $1.line, $1.cmd );
                                  }
  |    ctl_cmd                    { 
                                    add_cmd( line_table, $1.line, $1.cmd );
                                  }
  ;
                                  

data_line:  other_token           { 
                                    $$.line = $1.line; 
                                    $$.cmd = build_lcmd_c(0, $1.start, $1.end);
                                  } 
  |    dol_exp                    { 
                                    /* dump_expression( $1.val ); */
                                    $$.line = $1.line; 
                                    $$.cmd = build_lcmd_e(0, $1.val, $1.start, 
                                            $1.end);
                                  }
  |    data_line other_token      { 
                                    $$.line = $1.line;
                                    $$.cmd = build_lcmd_c($1.cmd, 
                                            $2.start, $2.end);
                                  }     
  |    data_line dol_exp          { 
                                    /* dump_expression( $2.val ); */
                                    $$.line = $1.line; 
                                    $$.cmd = build_lcmd_e($1.cmd, $2.val, $2.start, $2.end);
                                  }
  ;
  
other_token:    TOK_NUM     { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_FLOAT   { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_NAME    { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_STRING  { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_CHAR    { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_DOT     { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_COLON   { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_SCOL    { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_COM     { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_EQ      { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_LT      { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_IN      { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_NE      { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_GT      { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_NOT     { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_AND     { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_OR      { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_EQEQ    { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_LTEQ    { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_GTEQ    { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_STAR    { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_PLUS    { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_MINUS_S { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_PLUS_S  { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_MUL_S   { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_DIV_S   { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_MINUS   { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_PLUSPLUS   {
                            $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_MINUSMINUS { 
                            $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_DIV     { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_OPEN    { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_CLOSE   { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_OPENB   { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }
  |             TOK_CLOSEB  { $$.line=$1.line;$$.start=$1.start;$$.end=$1.end; }    
  ;
  
dol_exp:        TOK_DOL obj            { 
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $2.end;
                                          $$.val = new_objexp( $2.val );
                                       }
  |             TOK_DOL TOK_OPEN exp TOK_CLOSE  {
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $4.end;
                                          $$.val = $3.val;
                                       }
  |             TOK_DOL error          { ERR(        
                                       "'(', '$' or object expected after '$'");
                                          $$.val = 0; 
                                       }                                       
  ;
  
obj:            objpart                {
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $1.end;
                                          $$.val = new_object( 0, $1.val );
                                       }
  |             obj TOK_DOT objpart    { 
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $3.end; 
                                          $$.val = new_object($1.val, $3.val);
                                       }
  |             obj TOK_DOT error      { 
                                         ERR("object expected after '.'"); 
                                         $$.val = 0;
                                       }                                     
  ;
  
relop:          TOK_EQEQ               {  $$.val = 'e'; }
  |             TOK_EQ                 {  $$.val = '='; }
  |             TOK_LT                 {  $$.val = '<'; }
  |             TOK_GT                 {  $$.val = '>'; }
  |             TOK_NE                 {  $$.val = '!'; }
  |             TOK_LTEQ               {  $$.val = 'l'; }
  |             TOK_GTEQ               {  $$.val = 'g'; }
  |             TOK_MUL_S              {  $$.val = '1'; }
  |             TOK_DIV_S              {  $$.val = '2'; }
  |             TOK_PLUS_S             {  $$.val = '3'; }
  |             TOK_MINUS_S            {  $$.val = '4'; }
  |             TOK_OR                 {  $$.val = '|'; }
  |             TOK_AND                {  $$.val = '&'; }
  ;

exp:            ear
  |             exp relop ear          {
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $3.end;
                                          $$.val = new_exp($1.val, $2.val, $3.val);
                                       }  
  ;
                                       
ear:            emul                   
  |             ear TOK_PLUS   emul    {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $3.end; 
                                          $$.val = new_exp($1.val, '+', $3.val);
                                       }
  |             ear TOK_MINUS  emul    {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $3.end; 
                                          $$.val = new_exp($1.val, '-', $3.val);
                                       }
  |             ear TOK_PLUS error     {  
                                          ERR("expression expected after '+'"); 
                                          $$.val = 0;
                                       }                                      
  |             ear TOK_MINUS error    {  
                                          ERR("expression expected after '-'"); 
                                          $$.val = 0;
                                       }                                      
  ;
  
emul:           smp_exp                
  |             emul TOK_STAR  smp_exp {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $3.end; 
                                          $$.val = new_exp($1.val, '*', $3.val);
                                       }
  |             emul TOK_DIV   smp_exp {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $3.end; 
                                          $$.val = new_exp($1.val, '/', $3.val);
                                       }
  |             emul TOK_STAR error    {  ERR("expression expected after '*'");
                                          $$.val = 0;
                                       }                                      
  |             emul TOK_DIV error     {  ERR("expression expected after '/'");
                                          $$.val = 0;
                                       }                                      
  ;
  
array:          exp                    {  $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $1.end;
                                          $$.val = new_explist( 0, $1.val );
                                       }   
  |             array TOK_COM exp      {  $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $1.end;
                                          $$.val = new_explist($1.val, $3.val);
                                       }   
  ;
  
record:         TOK_NAME TOK_COLON exp {  $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $3.end;
                                          $$.val = new_fldlist( 0, $1.val,
                                                  $3.val );
                                       }
  |             record TOK_COM TOK_NAME TOK_COLON exp {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $5.end;
                                          $$.val = new_fldlist( $1.val, $3.val,
                                                      $5.val );
                                       }
  ;
  
constructor:    TOK_OPENB array TOK_CLOSEB {
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $3.end;
                                          $$.val = new_array( $2.val );
                                       }
  |             TOK_OPENB record TOK_CLOSEB {
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $3.end;
                                          $$.val = new_record( $2.val );
                                       }
  |             TOK_OPENB error        {  ERR("error in array definition");
                                          $$.val = 0;
                                          $$.line = $1.line;
                                       }      
  ;
  
smp_exp:        dol_exp
  |             constructor                                     
  |             smp_exp TOK_PLUSPLUS   { 
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $2.end;
                                          $$.val = new_inc( $1.val, +1, 1 );
                                       }
  |             TOK_PLUSPLUS smp_exp   {
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $2.end;
                                          $$.val = new_inc( $2.val, +1, 0 );
                                       }
  |             TOK_NOT smp_exp        {
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $2.end;
                                          $$.val = new_exp( 0, 'n', $2.val);
                                       }  
  |             TOK_MINUS smp_exp      {
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $2.end;
                                          $$.val = new_exp( 0, '-', $2.val);
                                       }  
  |             smp_exp TOK_MINUSMINUS { 
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $2.end;
                                          $$.val = new_inc( $1.val, -1, 1 );
                                       }
  |             TOK_MINUSMINUS smp_exp {
                                          $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $2.end;
                                          $$.val = new_inc( $2.val, -1, 0 );
                                       }
  |             TOK_NUM                {   
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $1.end; 
                                          $$.val = new_num($1.val);
                                       }
  |             TOK_FLOAT              {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $1.end; 
                                          $$.val = new_float($1.val);
                                       }
  |             TOK_STRING             {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $1.end; 
                                          $$.val = new_string($1.val);
                                          if ( $1.val ) {
                                              FREE( $1.val );
                                              $1.val = 0;
                                          }
                                       }
  |             TOK_OPEN exp TOK_CLOSE {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $3.end; 
                                          $$.val = $2.val;
                                       }
  |             TOK_OPEN error         {  ERR("expression expected after '('");
                                          $$.val = 0;
                                       }                                     
  ;
  
objpart:        TOK_NAME               {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $1.end; 
                                          $$.val = new_part($1.val);
                                          if ( $1.val ) {
                                              FREE( $1.val );
                                              $1.val = 0;
                                          }
                                       }    
  |             dol_exp                {  $$.line = $1.line;
                                          $$.start = $1.start;
                                          $$.end = $1.end; 
                                          $$.val = new_exppart( $1.val );
                                       }   
  |             objpart TOK_OPEN arglist TOK_CLOSE {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $4.end; 
                                          $$.val = new_fun( $1.val, $3.val );
                                       } 
  |             objpart TOK_OPENB exp TOK_CLOSEB {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $4.end; 
                                          $$.val = new_tab( $1.val, $3.val );
                                       } 
  |             objpart TOK_OPEN error {  ERR("bad function call argument");
                                          $$.val = 0;
                                       }                                     
  |             objpart TOK_OPENB error { ERR("expression expected after '['");
                                          $$.val = 0;
                                       }      
  ;


arglist:        /* nil */              {  $$.val = 0; }
  |             arglist1               
  ;

arglist1:       exp                    {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $1.end; 
                                          $$.val = new_explist( 0, $1.val );
                                       } 
  |             arglist1 TOK_COM exp   {
                                          $$.line = $1.line; 
                                          $$.start = $1.start;
                                          $$.end = $3.end; 
                                          $$.val = new_explist($1.val, $3.val);
                                       } 
  ;
  
ctl_cmd:        cmd_if
  |             cmd_function
  |             cmd_switch
  |             cmd_for
  |             cmd_exp
  |             cmd_embed
  |             cmd_emit 
  |             cmd_output
  |             cmd_local 
  |             cmd_return
  |             cmd_break 
  |             cmd_push  
  |             cmd_pop   
  |             cmd_use
  |             cmd_exit
  |             TOK_AT                 {  $$.line = $1.line;
                                          $$.cmd = 0; }
  |             TOK_AT error           {  $$.line = $1.line;
                                          ERR( "bad '@' command" );
                                          $$.cmd = 0;
                                       } 
  ;
  
cmd_if:         TOK_IF exp TOK_NL lines TOK_ENDIF  {
                                         $$.line = $1.line;
                                         $$.cmd=new_if($2.val,$5.line,$5.line); 
                                       }
  |             TOK_IF exp TOK_NL lines TOK_ELSE TOK_NL lines TOK_ENDIF {
                                         $$.line = $1.line;
                                         $$.cmd=new_if($2.val,$5.line,$8.line); 
                                       }
  |             TOK_IF error           { ERR( "@if command malformed" );
                                         $$.cmd = 0;
                                       }
  ;
                                       
fun_body:       lines TOK_ENDFUNCTION  { $$.end = $2.line; } 
  |             error                  { ERR("@function not closed");
                                         $$.val = 0; } 
  ;
  
cmd_function:   TOK_FUNCTION TOK_NAME TOK_OPEN param_list TOK_CLOSE 
                TOK_NL fun_body     {
                                      int _regres;
                                      $$.line = $1.line;
                                      $$.cmd = new_function( $2.val, $4.val,
                                              $7.end ); 
                                      if ( regfun( $2.val, curfilen, 
                                                  $1.line ) == 2 ) 
                                          warning( "warning: function duplicated" );
                                      if ( $2.val ) FREE( $2.val );
                                    }  
  |             TOK_FUNCTION  error  {
                                      ERR("bad @function header");
                                      $$.cmd = 0;
                                    }
  ;
  
param_list:     /* empty */         { $$.val = 0; }
  |             param_list1          
  ;
  
param_list1:    TOK_NAME            { $$.line = $1.line;
                                      $$.val = new_parlist( 0, $1.val ); 
                                      if ( $1.val ) FREE( $1.val );
                                    }
  |             param_list1 TOK_COM TOK_NAME {
                                      $$.line = $1.line;
                                      $$.val = new_parlist( $1.val, $3.val ); 
                                      if ( $3.val ) FREE( $3.val );
                                    } 
  ;
  
cmd_switch:     TOK_SWITCH exp TOK_NL case_list TOK_ENDSWITCH {
                                      $$.line = $1.line;
                                      $$.cmd = new_switch($2.val,$4.val,
                                              $1.line,$5.line);
                                    }  
  |             TOK_SWITCH exp TOK_NL error  { ERR( "@case expected" );
                                      $$.cmd = 0;
                                    }
  ;
  
case_list:      case_item          {  $$.line = $1.line;
                                      $$.val = new_caselist(0,$1.val,$1.line);
                                   }   
  |             case_list case_item { $$.line = $1.line;
                                      $$.val = new_caselist($1.val, 
                                              $2.val, $2.line );
                                   }
  ;
  
case_item:      TOK_CASE exp TOK_COLON TOK_NL lines {
                                      $$.line = $2.line;
                                      $$.val = $2.val;
                                   }   
  |             TOK_CASE error     {  ERR("after @case expected expression and ':'");
                                      $$.val = 0;
                                   }
  ;
  
cmd_for:        TOK_FOR forctl TOK_NL lines TOK_ENDFOR {
                                      $$.line = $1.line;
                                      $$.cmd = new_for($2.val, $1.line, $5.line);
                                   }   
  |             TOK_FOR error      {  ERR( "bad @for command syntax" );
                                      $$.cmd = 0; $$.line = $1.line;
                                   }
  ;
  
forctl:         TOK_OPEN optexp TOK_SCOL optexp TOK_SCOL optexp TOK_CLOSE {
                                      $$.line = $1.line;
                                      $$.val = new_forctl($2.val,$4.val,$6.val);
                                   }     
  |             TOK_OPEN dol_exp TOK_IN exp TOK_CLOSE {
                                      $$.line = $1.line;
                                      $$.start = $1.start;
                                      $$.end = $5.end;
                                      $$.val = new_lforctl($2.val,$4.val);  
                                   }      
  |             TOK_OPEN error     {  ERR( "bad @for command syntax" );
                                      $$.val = 0;
                                   }
  ;
  
cmd_return:     TOK_RETURN exp     {  $$.line = $1.line;
                                      $$.cmd = new_return( $2.val );
                                   }   
  |             TOK_RETURN error   {  ERR( "@return without argument" );
                                      $$.cmd = 0;
                                   }
  ;
  
cmd_break:      TOK_BREAK          {  $$.line = $1.line;
                                      $$.cmd = new_break( $1.line );
                                   }   
  ;
  
cmd_push:       TOK_PUSH           {  $$.line = $1.line;
                                      $$.cmd = new_push();
                                   }   
  ;
  
cmd_pop:        TOK_POP            {  $$.line = $1.line;
                                      $$.cmd = new_pop();
                                   }   
  ;
  
optexp:         /* empty */        {  $$.val = 0;  }
  |             exp              
  |             error              {  ERR( "expression expected" );
                                      $$.val = 0; 
                                   }
  ;
  
cmd_exp:        TOK_AT exp         {  $$.line = $1.line;
                                      $$.cmd = new_cmdexp( $2.val ); }
  ;
  
cmd_embed:      TOK_EMBED exp      {  $$.line = $1.line;
                                      $$.cmd = new_embed( $2.val ); }
  ;
  
cmd_emit:       TOK_EMIT exp       {  $$.line = $1.line;
                                      $$.cmd = new_emit( $2.val ); }
  ;
  
cmd_output:     TOK_OUTPUT exp     {  $$.line = $1.line;
                                      $$.cmd = new_output( $2.val ); }
  ;
  
cmd_local:      TOK_LOCAL TOK_NAME {  $$.line = $1.line;
                                      $$.cmd = new_local( $2.val ); }
  ;
  
cmd_use:        TOK_USE TOK_NAME   {  $$.line = $1.line;
                                      $$.cmd = new_use( $2.val ); }
  |             TOK_USE TOK_STRING {  $$.line = $1.line;
                                      $$.cmd = new_use( unquote($2.val) );
                                      if ($2.val) FREE($2.val);
                                   }
  ;

cmd_exit:       TOK_EXIT           {  $$.line = $1.line;
                                      $$.cmd = new_exit( 0 );
                                   }              
  |             TOK_EXIT exp       {  $$.line = $1.line;
                                      $$.cmd = new_exit( $2.val );
                                   }
  ;

