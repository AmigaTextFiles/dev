/*
	Syntax.h
	Uros Platise, Dec. 1998
*/

#ifndef __Syntax
#define __Syntax

#include <stack>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "Global.h"
#include "Lexer.h"

/* Operator Magic Number	Mnemonic */
#define OP_NOP		0	/*    */
#define OP_PLUS		1	/* +  */
#define OP_MINUS	2	/* -  */
#define OP_ASL		3	/* <  */
#define OP_ASR		4	/* >  */
#define OP_LAND		5	/* &  */
#define OP_LOR		6	/* |  */
#define OP_LXOR		7	/* ^  */
#define OP_MUL		8	/* *  */
#define OP_DIV		9	/* /  */
#define OP_LE		10	/* <  */
#define OP_GR		11	/* >  */
#define OP_EQ		12	/* == */
#define OP_LEQ		13	/* <= */
#define OP_GEQ		14	/* >= */

#define OP_PERIOD	15

#define MAX_ARG		128
#define MAX_EQLEN	8000	/* max length in its original form
				   without spaces ... */
				  
/* Type: General Argument Structure */
class TGAS{
private:
  struct TGAE {			/* Type: General Argument Entry */
    char symbol [LX_STRLEN];
    long lval;
  }; 
  enum TOAM{NotDefined, Operator, Argument};
  
  static int OP_LEVEL[OP_PERIOD];
  
  TGAE GAS[MAX_ARG];		/* General Argument Stack */
  unsigned int GOS[MAX_ARG];	/* General Operand Stack */
  unsigned int ai, oi;		/* Argument and Operand Indexes */
  unsigned int aip, oip;  
  TOAM oam;	/* Operator/Argument Mode (which was last pushed?) */
  
public:
  enum TStatus{Parsing,CannotSolve,Solved};
  TStatus status;
  char eqstr [MAX_EQLEN];
  int eqlen;
  TGAS(): ai(0), oi(0), aip(0), oip(0), oam(NotDefined), status(Parsing){
    eqstr[0]=eqlen=0;}    
  void clear (){ai=oi=aip=oip=eqlen=eqstr[0]=0;oam=NotDefined;status=Parsing;}
  
  void push_arg (const char* symbol){ 
    assert(ai<MAX_ARG); 
    GAS[ai].lval=0; strcpy(GAS[ai++].symbol, symbol); oam=Argument;
    eqlen+=strlen(symbol); assert(eqlen<MAX_EQLEN); strcat(eqstr, symbol); 
    status=CannotSolve;/*Whenever symbol is pushed, expr. cannot be solved!*/
  }
  void push_arg (const char* symbol,long lval){
    assert(ai<MAX_ARG); 
    GAS[ai].lval=lval; GAS[ai++].symbol[0]=0; oam=Argument;
    eqlen+=strlen(symbol); assert(eqlen<MAX_EQLEN); strcat(eqstr, symbol);
  }
  void push_op (int op, const char* symbol){ 
    evaluate(op);	/* Evaluate as much as possible */
    assert(oi<MAX_ARG); GOS[oi++]=op; strcat(eqstr,symbol); oam=Operator;    
  }
  void push_eqstr(const char* symbol){
    strcat(eqstr,symbol);
    if (symbol[0]=='('){oam=NotDefined;}
  }
  
  long pop_arg (){assert(ai>0); return GAS[--ai].lval;}    
  int pop_op (){assert(oi>0); return GOS[--oi];}
  
  int wasArgument(){return oam==Argument;}
  int wasOperator(){return oam==Operator;}
  int wasNotDefined(){return oam==NotDefined;}
  
  void evaluate(int new_op);
  void update_argstack(long lval){
    assert(ai<MAX_ARG); GAS[ai].lval=lval; GAS[ai++].symbol[0]=0;}
    
  long result(){return GAS[0].lval;}
};

extern TGAS gas;

class TSyntax{
public:
  TMicroStack<bool> ifdef_stack;
  bool ifdef_status;	/*parse all code (true) or just wait for #endif*/
  bool HaltOnInvalid;	/*halt on invalid/unknown macros */
  bool firstDefine;
public:
  TSyntax():ifdef_status(true),HaltOnInvalid(false),firstDefine(true){}
  ~TSyntax(){}

  void haltOnInvalidMacros(bool confirm=true){HaltOnInvalid=confirm;}
  
  void Run();  
  void Preprocessor();
  char* Parse_FileName(char* buf);
  void Parse_GAS(int argNo=1);  
};

extern TSyntax syntax;

#endif
