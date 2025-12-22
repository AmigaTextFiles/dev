/*
  Lexer.C

  Lexical Analyzer
  Uros Platise, Feb 1998
*/

#include <stdio.h>
#include <string.h>
#include "Symbol.h"
#include "Global.h"
#include "Error.h"
#include "Reports.h"

/* The only Lexer Global Data Structure */
TlxData lxdata;
TlxData *lxP = &lxdata;

/* set source and open a file */
TLexer::TLexer (){
  lxdata.buf=lxdata.back_count=lxdata.lastCurPos=0;
  lxdata.stick=lxdata.macro=false;
  lxdata.type=TlxData::NEWLINE; /* first pass is new line pass - increments */
}                               /* lineNumber counter */


/* Macro Definitions */
#define LX_C          lxdata.buf
#define LX_NEXT       lexer.getnext()

#define LX_IS_SPECIAL (LX_C=='_')
#define LX_IS_ALPHA   ((LX_C>='A' && LX_C<='Z')||(LX_C>='a' && LX_C<='z')||LX_IS_SPECIAL)
#define LX_IS_BIN     (LX_C>='0' && LX_C<='1')
#define LX_IS_DEC     (LX_C>='0' && LX_C<='9')
#define LX_IS_HEX     (LX_IS_DEC||(LX_C>='A' &&LX_C<='F')||(LX_C>='a' &&LX_C<='f'))
#define LX_IS_x       (LX_C=='x')
#define LX_IS_b       (LX_C=='b')
#define LX_IS_DOLLAR  (LX_C=='$')
#define LX_IS_0       (LX_C=='0')
#define LX_IS_QS      (LX_C=='"')
#define LX_IS_PREPROC (LX_C=='#')
#define LX_IS_SPACE   (LX_C==' ' || LX_C=='\t') /* or TAB */
#define LX_IS_CONTROL (LX_C=='.' || LX_C==',' || LX_C=='{' || LX_C=='}' || LX_C=='(' || LX_C==')' || LX_C=='\\')
#define LX_IS_MATH    (LX_C=='+' || LX_C=='-' || LX_C=='*' || LX_C=='/' || LX_C=='<' || LX_C=='>' || LX_C=='&' || LX_C=='|' || LX_C=='^' || LX_C=='=') /* LX_C=='!' is removed */
#define LX_IS_NL      (LX_C=='\n')
#define LX_IS_TRASH   (LX_C=='\r' /* || LX_C=='.' */ )
#define LX_IS_EOL     (LX_C==0)
#define LX_IS_TERM    (LX_IS_REM1||LX_IS_MATH||LX_IS_CONTROL||LX_IS_SPACE||LX_IS_TRASH||LX_IS_NL||LX_IS_EOL)
#define LX_IS_LABEL   (LX_C==':')
#define LX_IS_REM1    (LX_C==';')

#define LX_TOSTR      lxdata.string [strpos++]

/* Be sure what you are doing with the following lines.
   There is no range cheking on these two operations */
#define LX_STRBACK    strpos--;
#define LX_C_BEFORE   lxdata.string [strpos-1]

inline void TLexer::getnext(){
  lxdata.buf=preproc.getch();
//  printf("got: %d (%c)\n", lxdata.buf, lxdata.buf);
  if (strlen(lxdata.string)==(LX_STRLEN-1)){
    throw generic_error("Lexer buffer is too small."
                        " Increase LX_STRLEN in Lexer.h");}
}

/* push back old character and clear current buffer */
void TLexer::flush(){
  lxdata.buf=0; 	/* clear buffer so it will be reread next time */
  preproc.putbackch();	/* give current ch back to the owner ... */
}

/* returns TlxData::EOF if eof is reached otherwise lxdata is updated. */
int TLexer::__gettoken(){
  if (lxdata.back_count>0){lxdata.back_count--;return lxdata.type;}  
  if (LX_IS_EOL){
    getnext();if (LX_IS_EOL){return (lxdata.type=TlxData::THEEND);}}
  
  int strpos; long aux;
  
  lxdata.stick = true;
  /* go state machine */
  while (lxdata.buf != 0){
    strpos=aux=0;
    lxdata.string [0] = 0;
    lxdata.lval = 0;
    lxdata.macro = false;
  
    if (LX_IS_SPACE){lxdata.stick=false; LX_NEXT; continue;}
    if (LX_IS_TRASH){lxdata.stick=false; LX_NEXT; continue;}
    if (LX_IS_ALPHA){
      preproc.mark();
      while (LX_IS_ALPHA || LX_IS_DEC){LX_TOSTR = LX_C; LX_NEXT;}
      LX_TOSTR = 0;
      if (LX_IS_LABEL){LX_NEXT; return lxdata.type=TlxData::LABEL;}
      if (!LX_IS_TERM){throw lexer_error (LX_C);}
      return lxdata.type=TlxData::STRING;
    }
    if (LX_IS_QS){
      LX_NEXT; /* skip " character */
      while (!(LX_IS_QS || LX_IS_EOL)){LX_TOSTR = LX_C; LX_NEXT;}
      if (LX_IS_EOL){throw lexer_error("Incorrectly terminated string");}
      preproc.mark();      
      LX_TOSTR = 0; LX_NEXT; /* skip " character */
      return (lxdata.type = TlxData::QSTRING);
    }
    if (LX_IS_PREPROC){
      preproc.mark();    
      LX_NEXT; return (lxdata.type = TlxData::PREPROC);
    }
    if (LX_IS_CONTROL){ 
      preproc.mark();
      LX_TOSTR = LX_C; LX_TOSTR = 0; LX_NEXT;
      return (lxdata.type = TlxData::CONTROL);
    }
    if (LX_IS_REM1){	/* standard assembler remarks starting with ; */
      while (!(LX_IS_NL || LX_IS_EOL)){LX_NEXT;}
      lxdata.stick=false;
      continue; /* start at the beginning */
    }
    if (LX_IS_MATH){
      preproc.mark();
      while (LX_IS_MATH){
        LX_TOSTR = LX_C; LX_NEXT;
	/* standard C remarks starting with / and * and closing reversibly */
	if (LX_C_BEFORE=='/' && LX_C=='*'){
	  if (strpos==0){lxdata.stick=false;}
	  LX_STRBACK;	/* remove last character: / */
	  char ch;	/* buffer for last character */
	  do{ch=LX_C; LX_NEXT;
	  }while(!LX_IS_EOL&& !(ch=='*'&&LX_C=='/'));
	  /* continue with parsing the equation */
	  LX_NEXT; /* remove / ch */
	}
      }
      /* if there was not just C comment, go out with MATH */
      if (strpos>0){LX_TOSTR = 0;return (lxdata.type = TlxData::MATH);}
      continue; /* start at the beginning */
    }
    if (LX_IS_DEC || LX_IS_DOLLAR){
      preproc.mark();
      lxdata.lval = 0;
      if (LX_IS_0){
        LX_NEXT;
	if (LX_IS_x){goto hex;}
	else if (LX_IS_b){
	  LX_NEXT;
          while (LX_IS_BIN){ 
	    lxdata.lval <<= 1; lxdata.lval |= LX_C - '0'; LX_NEXT;}
	}else{goto dec;}
      } 
      else if (LX_IS_DOLLAR){ /* hex */
hex:    LX_NEXT;
	while (LX_IS_HEX){
	  if (LX_IS_DEC){aux = LX_C - '0';}
	  else if (LX_C > 'F'){aux = LX_C - 'a' + 10;}
	  else {aux = LX_C - 'A' + 10;}
	  lxdata.lval <<= 4; lxdata.lval |= aux; LX_NEXT;
	}	
      }else{ /* decimal */
dec:	while (LX_IS_DEC){
	  lxdata.lval *= 10; lxdata.lval += LX_C - '0'; LX_NEXT;
	}
      }
      if (!LX_IS_TERM){throw lexer_error (LX_C);}
      sprintf(lxP->string, "$%lx", lxP->lval); /* convert to hex... */
      return (lxdata.type = TlxData::LVAL);
    }
    if (LX_IS_NL){LX_NEXT; return lxdata.type=TlxData::NEWLINE;}

    /* if none of above options are incorrect, then it must be an error */
    throw lexer_error (LX_C);
  }
  return (lxdata.type=TlxData::THEEND); /* eof */
}

int TLexer::_gettoken(){
  __gettoken();
//  printf("%ld:(%d,%s)\n",preproc.line(),lxP->type,lxP->string);  
  return lxP->type;
}
int TLexer::gettoken(){
  int maxCount = 128;
  _gettoken();  
  while (symbol.replaceWithMacro()==1){
    _gettoken();	/* if string is replaced, flush old one */
    lxP->macro=true;	/* set flag, that original source is macro */    
    if (maxCount--==0){throw syntax_error("Recursive symbols ... ");}
  }
  return lxP->type;
}

void TLexer::Unroll(){
  while(lxP->type!=TlxData::NEWLINE && lxP->type!=TlxData::THEEND){
    gettoken();
  }
}

