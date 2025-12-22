/* Lexer.h */

#ifndef __Lexer
#define __Lexer

#include <assert.h>

#define LX_STRLEN	128
#define LX_LINEBUF	512

#define GET_TOKEN	lexer.gettoken()
#define PUT_TOKENBACK	lexer.getback();
#define WHILE_TOKEN	while(lexer.gettoken())

struct TlxData{
  enum TlxType{THEEND=0,STRING=1,QSTRING=2,LVAL=3,PREPROC=4, 
               CONTROL=5,MATH=6,NEWLINE=7,LABEL=8};
  char string[LX_STRLEN];
  long lval;
  TlxType type;
  char buf;		/* character buffer */
  int back_count;	/* If token is returned back, increment this counter,
                           that next time gettoken function is invoked, the
			   same string will be returned. */
  bool stick;		/* if current token is placed just by the last one,
                           this variable become true */
  bool macro;		/*if string was replaced by macro, set this flag high*/
  long lastCurPos;      /* last cursor position */
};

/* global structure */
extern TlxData lxdata;
extern TlxData *lxP;

class TLexer{
private:
  void getnext();
public:  
  TLexer();
  ~TLexer(){}
  int __gettoken();	/* pure tokens */  
  int _gettoken();	/* without remarks */
  /* gettoken cooperates with symbols, macros and remarks
     returns TlxData::THEEND if eof is reached otherwise lxdata is updated. */
  int gettoken();  
  void getback(){assert(lxdata.back_count<1);lxdata.back_count++;}  
  
  /* flush current buffer: current character in buffer is pushed back 
     to owner and afterthat, it is cleared - prepeared for new stream. */
  void flush();
  void Unroll();
};

extern TLexer lexer;

#endif

