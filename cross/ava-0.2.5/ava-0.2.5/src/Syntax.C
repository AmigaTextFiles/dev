/*
  Syntax.C      
  Assembler Syntax Analyzer
  Uros Platise, July 1998
*/

#include <string.h>
#include <stdio.h>
#include "Keywords.h"
#include "Segment.h"
#include "Symbol.h"
#include "Syntax.h"
#include "Reports.h"

void TSyntax::Preprocessor(){
  char buf [LX_STRLEN];
  GET_TOKEN;
  /* The first structure does not depend on ifdef_status */
  if (lxP->type==TlxData::STRING){
    if (strcmp(lxP->string,"endif")==0){
      if (ifdef_stack.empty()){
        throw syntax_error("There is no corresponding "
	                   "#ifdef/#ifndef for #endif.");}
      ifdef_status=ifdef_stack.pop();return;
    }    
    else if (strcmp(lxP->string,"if")==0){
      ifdef_stack.push(ifdef_status); ifdef_status &= symbol.ifexpr();return;}
    else if (strcmp(lxP->string,"ifdef")==0){
      ifdef_stack.push(ifdef_status); ifdef_status &= symbol.ifdef();return;}
    else if (strcmp(lxP->string, "ifndef")==0){
      ifdef_stack.push(ifdef_status); ifdef_status &= !symbol.ifdef();return;}
    else if (strcmp(lxP->string, "else")==0){
      if (ifdef_stack.empty()){
        throw syntax_error("#else not within #ifdef statement.");}
      ifdef_status = (ifdef_status^1) & ifdef_stack.top(); return;
    }
    /* if none is found, go to the 'second' switch */
  }
  if (ifdef_status==false){return;}  
  switch(lxP->type){
    case TlxData::THEEND:
    case TlxData::NEWLINE: return;
    case TlxData::STRING:
      /* INCLUDE FILES ... */      
      if (strcmp(lxP->string, "include")==0){
        preproc.insert (preproc.FindFullPathName(Parse_FileName(buf)));}
      else if (strcmp(lxP->string, "define")==0){symbol.addMacro();}
      else if (strcmp(lxP->string, "arch")==0){
        symbol.addMacro();          	
        if (firstDefine==true){
	  firstDefine=false;
	  strcpy(buf, AVA_LIB); strcat(buf, "/"); strcat(buf, AVA_ARCH);
	  preproc.insert(buf);
	} else {
	  throw syntax_error("Target device was already defined.");
	}
      }
      else if (strcmp(lxP->string, "undefine")==0){symbol.undefine();}
      else if (strcmp(lxP->string, "adddir")==0){preproc.AddDir();}
      else if (strcmp(lxP->string, "error")==0){
        reports.FileStatus(TReports::VL_ALL);
        WHILE_TOKEN{
          if (lxP->type==TlxData::NEWLINE){break;}
          reports.Info(TReports::VL_ALL, "%s ",lxP->string);
        }
        throw generic_error ("");
      }
      else if (strcmp(lxP->string, "print")==0){
        reports.FileStatus(TReports::VL_ALL);
        WHILE_TOKEN{
          if (lxP->type==TlxData::NEWLINE){break;}
          reports.Info(TReports::VL_ALL, "%s ",lxP->string);
        }
        reports.Info(TReports::VL_ALL, "\n");
      }
      else{ /* If none of above matched lxP->string */      
        throw syntax_error ("Invalid preprocessor directive: #", lxP->string);}
      break;

    default:
      throw syntax_error ("Syntax error after '#' character.");
  }
}

char* TSyntax::Parse_FileName(char* buf){
  GET_TOKEN; 
  if (lxP->type!=TlxData::QSTRING /* && lxP->type!=TlxData::STRING */) {
    throw syntax_error ("File name is missing after #include ...");}
  strcpy(buf,lxP->string);
  return buf;
}

/*
  Parse_GAS
  General Parser for non-RPM expressions.
  It uses General Argument Structure to store expression structure
  and only if all arguments are known, expression is evaluated.
  Otherwise, it is kept in its original parsed form.
*/

void TSyntax::Parse_GAS(int argNo=1){
  int op,op_level=0;			/* (((... level */
  gas.clear ();
  do {
    switch (lxP->type) {    
      case TlxData::STRING:
        if (gas.wasArgument()){
  /* If expression is closed ( ... ) then string is not for us anymore */
	  if (op_level==0){goto check_expression;}
	  throw syntax_error(argNo,"Operator is required before ",lxP->string);
	}
	gas.push_arg(lxP->string);
	if (HaltOnInvalid==true && lxP->macro==false){
	  throw syntax_error(argNo, "Not defined symbol: ", lxP->string);}
        break;
	
      case TlxData::LVAL:        
        if (gas.wasArgument()){
	  throw syntax_error(argNo,"Operator is required before ",lxP->string);}
	gas.push_arg(lxP->string,lxP->lval);
	break;
	
      case TlxData::CONTROL:
        if (gas.wasArgument() && lxP->string[0]=='('){
	  throw syntax_error(argNo,"Undefined macro (or syntax "
            "error) before: ",lxP->string);}
	if (!gas.wasArgument() && lxP->string[0]==')'){
	  throw syntax_error(argNo,
            "Argument is required before: ",lxP->string);
        }
	switch(lxP->string[0]){
	  case '(': op_level+=OP_PERIOD; gas.push_eqstr(lxP->string); break;
	  case ')': op_level-=OP_PERIOD; gas.push_eqstr(lxP->string); break;
	  default: goto check_expression;
	}
	break;
	
      case TlxData::MATH:
        /* MAP one character operators */
        if (lxP->string[1]==0){
	  switch(lxP->string[0]){
	    case '+': op=OP_PLUS; break;
	    case '-': op=OP_MINUS; break;
	    case '&': op=OP_LAND; break;
	    case '|': op=OP_LOR; break;
	    case '^': op=OP_LXOR; break;
	    case '*': op=OP_MUL; break;
	    case '/': op=OP_DIV; break;
	    case '<': op=OP_LE; break;
	    case '>': op=OP_GR; break;
	    default:  throw lexer_error(lxP->string[0]); break;
	  }
	/* MAP two same character operators */
	} else if (lxP->string[0]==lxP->string[1] && lxP->string[2]==0){
	  switch(lxP->string[0]){
	    case '<': op=OP_ASL; break;
	    case '>': op=OP_ASR; break;
	    case '=': op=OP_EQ; break;
	    default:  throw lexer_error(lxP->string[0]); break;
	  }
	/* MAP >= and <= */
	} else if (lxP->string[1]=='=' && lxP->string[2]==0){
	  switch(lxP->string[0]){
	    case '<': op=OP_LEQ; break;
	    case '>': op=OP_GEQ; break;
	    default:  throw lexer_error(lxP->string[0]); break;
	  }
	/* if non of above ... error! */
	}else{throw lexer_error(lxP->string[0]);}
	
        if (gas.wasOperator() || gas.wasNotDefined() && op!=OP_MINUS){
	  throw syntax_error(argNo,"Argument is required before ",lxP->string);}
	
	/* add zero to satisfy -x form */  
	if (gas.wasNotDefined() && op==OP_MINUS){gas.update_argstack(0);}
	
	gas.push_op(op+op_level,lxP->string);
        break;
	
      case TlxData::PREPROC:
        throw lexer_error('#');
        break;
	
      default:
        goto check_expression;
    }
  } WHILE_TOKEN;
check_expression:
  if (op_level!=0||gas.wasOperator()){
    throw syntax_error(argNo,"Malformed expression:", gas.eqstr);}
  gas.evaluate(0);
}

/*
  Every sub-function within the following procedure must put back
  last not used token. TSyntax::Run reads next token on
  every pass. If sub-function does not leave last token,
  one token is therefore skipped - and - not parsed!
*/
void TSyntax::Run (){
  WHILE_TOKEN{
    try{
      if (lxP->type==TlxData::PREPROC){Preprocessor();continue;}
      if (ifdef_status==false){continue;}    
      switch(lxP->type){
        case TlxData::STRING: 
          if (archp()){if (archp->is_Arch()){archp->Parse();break;}}
  	  if (segment.parse()){break;}
  	  if (keywords.parse()){break;}
	  if (archp()==NULL){
	    throw generic_error("Target device is not defined.");}
	    
        case TlxData::LABEL:
	  if (symbol.addLabel()){break;}
	    throw syntax_error("Syntax error at: ",lxP->string);
	    
        case TlxData::CONTROL: 
	  throw lexer_error(lxP->string[0]);
	  
        case TlxData::NEWLINE: break;
	
        default: throw lexer_error(lxP->string[0]);
      }
    }
    catch (lexer_error &x){reports.Error(x); lexer.Unroll();}
    catch (syntax_error &x){reports.Error(x); lexer.Unroll();}
  }
  if (ifdef_stack.empty()==false){
    throw generic_error("Program is not correctly terminated:"
                        " #if(n)def/#endif count missmatch.");}

  if (archp()==NULL){throw generic_error("Device was not specified.");}
}


/*
  Some Implementation of the GAS Class is found below ...
*/

int TGAS::OP_LEVEL [OP_PERIOD] = {0, 2,2, 3,3,3,3,3, 4,4, 1,1,1,1,1};

#define OP_CMP(a)	(OP_LEVEL[a%OP_PERIOD] + OP_PERIOD*(a/OP_PERIOD))

void TGAS::evaluate(int new_op){
  unsigned int op_cmp = OP_CMP(new_op);
  int op;
  long tmp;
  if (status==CannotSolve){return;}		/* symbols are present */
  while(op_cmp <= OP_CMP(GOS[oi-1]) && oi>0){
    op=pop_op()%OP_PERIOD;    
    switch(op){
      case OP_PLUS: update_argstack(pop_arg()+pop_arg()); break;
      case OP_MINUS: update_argstack(-pop_arg()+pop_arg()); break;
      case OP_LAND: update_argstack(pop_arg()&pop_arg()); break;
      case OP_LOR: update_argstack(pop_arg()|pop_arg()); break;
      case OP_LXOR: update_argstack(pop_arg()^pop_arg()); break;      
      case OP_MUL: update_argstack(pop_arg()*pop_arg()); break;
      case OP_DIV: tmp=pop_arg(); update_argstack(pop_arg()/tmp); break;
      case OP_ASL: tmp=pop_arg(); update_argstack(pop_arg()<<tmp); break;
      case OP_ASR: tmp=pop_arg(); update_argstack(pop_arg()>>tmp); break;
      case OP_LE: update_argstack((-pop_arg()+pop_arg()) < 0); break;
      case OP_GR: update_argstack((-pop_arg()+pop_arg()) > 0); break;
      case OP_EQ: update_argstack((-pop_arg()+pop_arg()) == 0); break;
      case OP_LEQ: update_argstack((-pop_arg()+pop_arg()) <= 0); break;
      case OP_GEQ: update_argstack((-pop_arg()+pop_arg()) >= 0); break;
      default: 
        throw generic_error("GAS: Not yet supported operation."); break;
    }
  }
  if(oi==0){status=Solved;}
}

