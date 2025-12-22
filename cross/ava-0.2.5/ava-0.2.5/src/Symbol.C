/*
  Symbol.C
  
  Symbols, Macros and that's all.
  Uros Platise, dec. 1998
*/

#include "Preproc.h"
#include "Lexer.h"
#include "Syntax.h"
#include "Segment.h"
#include "Symbol.h"
#include "Reports.h"
#include "Object.h"

bool TSymbol::addMacro(){
  TSymbolRec tmpRec;
  string macroName;
  parseFlags(&tmpRec,TlxData::STRING);
  macroName=lxP->string; parseMacro(&tmpRec);
  if (test(&tmpRec,macroName)==Define){storeSym(&tmpRec, macroName);}
  if (macroName[0]=='_' && macroName[1]=='_'){return true;}
  return false;
}

void TSymbol::addMacro(const char* macroName, const char* label=NULL,
                       TSymbolRec::TAttr macro_attr=TSymbolRec::Internal){
  if (label==NULL){label=macroName;}
  TSymbolRec tmpRec;
//  tmpRec.attr=TSymbolRec::Internal;
  tmpRec.attr=macro_attr;
  tmpRec.label=false; 
  tmpRec.internal=false;
  tmpRec.macro=label;
  if (test(&tmpRec,macroName)==Define){storeSym(&tmpRec, macroName);}
}

int TSymbol::addLabel(){
  TSymbolRec tmpRec;
  string labelName;
  char buf[128]; 	/* buf is used below by the getPC() */
  PUT_TOKENBACK;	/* parseFlags routine immediately calls GET_TOKEN */
  
  parseFlags(&tmpRec,TlxData::LABEL);    
  labelName=lxP->string; tmpRec.label=true;
  
  if (tmpRec.attr!=TSymbolRec::Extern){
    tmpRec.macro=segment.getPC(buf);
    tmpRec.segNo=segment.getSegNo();
  }else{tmpRec.macro=labelName;}
  
  if (test(&tmpRec,labelName)==Define){storeSym(&tmpRec, labelName);}
  return 1;
}

/*
  Internal Labels are intented for segment purposes.
  These labels are always marked external, since linker defines
  them later and are never put into object file.
  
  Special flag protected disallaws modifying the value from
  the assembler source.
*/
void TSymbol::addInternalLabel(const char* macroName, const char* label=NULL){
  if (label==NULL){label=macroName;}
  TSymbolRec tmpRec;
  tmpRec.attr=TSymbolRec::Extern;
  tmpRec.label=true; 
  tmpRec.internal=true;
  tmpRec.macro=label;
  test(&tmpRec,macroName);
  sym[label]=tmpRec;
}

/* if sym is already present, updates refs and then stores */
void TSymbol::storeSym(TSymbolRec* tmpRec, const string& macroName){
  TsymI symI;
  if ((symI=sym.find(macroName))!=sym.end()){
    /* remove old references to old segment */
    segment.incRef((*symI).second.segNo, (*symI).second.refCnt);
    tmpRec->refCnt += (*symI).second.refCnt; (*symI).second = *tmpRec;
  }else{sym[macroName]=*tmpRec;}
  /* add new refs to new segment (if it is the same, so what) */
  segment.incRef(tmpRec->segNo, tmpRec->refCnt);
}

void TSymbol::modifyValue(const char* macroName, const char* macroString){
  TsymI symI;
  if ((symI=sym.find(macroName))==sym.end()){
    throw syntax_error("Label is not defined: ", macroName);}
  (*symI).second.macro = macroString; 
}

bool TSymbol::ifexpr(){
  GiveUndefinedSymVal(true);
  lexer.gettoken();
  syntax.Parse_GAS();
  GiveUndefinedSymVal(false);
  if (gas.status!=TGAS::Solved){
    throw syntax_error("Bad format: ", gas.eqstr);}
  return gas.result()>0;
}

bool TSymbol::ifdef(){
  lexer._gettoken();
  if (lxP->type!=TlxData::STRING){
    throw syntax_error("Bad format: ", lxP->string);}
  return findMacro(lxP->string)!=NULL;
}

string* TSymbol::findMacro(const string& macroName){
  TsymI symI;
  if ((symI=sym.find(macroName))==sym.end()){return NULL;}
  return &(*symI).second.macro;
}

void TSymbol::undefine(){
  lexer._gettoken();
  if (lxP->type!=TlxData::STRING){
    throw syntax_error("Invalid macro declaration.");}
  undefine(lxP->string);
}

void TSymbol::undefine(const string& macroName){
  TsymI symI;
  if ((symI=sym.find(macroName))==sym.end()){
    throw syntax_error("Cannot erase macro that is not defined: ", 
                       macroName.c_str());}
  sym.erase(symI);
}

/*
long TSymbol::noRefs(int segNo){
  long refCnt=0;
  TsymI symI;
  for(symI=sym.begin(); symI != sym.end(); symI++){
    refCnt += ((*symI).second.segNo==segNo)?(*symI).second.refCnt:0;}  
  return refCnt;
}
*/

int TSymbol::Replace2Zero(){
  if (undefEqZero==false){return 0;}
  TMemBlock* macroSource = new TMemBlock;
  macroSource->append("0");
  preproc.insert(macroSource);
  return 1;
}

int TSymbol::replaceWithMacro(){
  TsymI symI;
  char macroName [LX_STRLEN], macro [LX_LINEBUF];
  char buf [LX_LINEBUF];
  int psi_chk=0;
  int parethLevel;		/* i.e.: ((( ... ))) */
  
  /* SPECIAL CASE: for #ifdef parser, all undefined macros should return
     zero; this is handled by the second if clause! 
     
     Exceptions to which zero is assigned too:
       * labels
  */ 
  if (lxP->type!=TlxData::STRING){return 0;}
  if ((symI=sym.find(lxP->string))==sym.end()){return Replace2Zero();}
  if ((*symI).second.label==true && undefEqZero==true){return Replace2Zero();}
    
  strcpy(macroName, lxP->string);
  strcpy(macro,     (*symI).second.macro.c_str());
  psi_chk     =     (*symI).second.noArgs;

  /* -----------------------------------------------------------------------
     (Macros are used only durring PASS1, otherwise produce ERROR!)
     Further test showed up that macros can be used in both passes, 1 and 2!
     -----------------------------------------------------------------------          
TODO:  
     Add error report on every unknown symbol to replace seeking for 
     undefined symbol in Object.C::obj2exe()
 
  if (HaltOnMacro==true && (*symI).second.label==false){
    if ((*symI).second.attr&TSymbolRec::Extern){
      throw syntax_error("Undefined symbol: ", macroName);}
    else{
      throw syntax_error("Macro should be declared before it is used: ",
        macroName);
    }   
  }
  */
  
  /* Segment Reference Count */
  segment.incRef((*symI).second.segNo);
  
  /* Symbol Count - used when reporting file references and symbols */
  (*symI).second.refCnt++;
  
  /* Non-internal Extern macros should tell the system that macro 
     is present - but string is not replaced */
  if (((*symI).second.attr & TSymbolRec::Extern) && 
      !((*symI).second.internal) && psi_chk==0){
    lxP->macro=true;
    return 0;
  }    

  /* SPECIAL CASE: if macroname equals macro, skip it */
  if (strcmp(macro,macroName)==0 && psi_chk==0){lxP->macro=true;return 0;}

  /* check for parameters in form (A0+B0+C0+...+n0,A1+B1+C1+...+n1,...) 
     where A,B and C may MATH, STRING and LVAL */
  clearps(); 
  if (psi_chk>0){
    lexer._gettoken();
    if (lxP->type==TlxData::CONTROL && lxP->string[0]=='('){
      while(lexer._gettoken()){
        /* load parameter string terminated by a >new line<, #, THEEND
	   NEWLINE or CONTROL ... except ( and ) */
        buf[0]=parethLevel=0;
	do{
          if (lxP->type==TlxData::PREPROC || lxP->type==TlxData::THEEND){break;}
          if (lxP->type==TlxData::NEWLINE){continue;}
	  if (lxP->type==TlxData::CONTROL){	    
	    if (lxP->string[0]=='('){parethLevel++;}
	    else if (lxP->string[0]==')'){
	      if (parethLevel==0){break;}	/* end of parameters */
	      parethLevel--;
	    }else{break;}	/* if none of above CONTROL ch is found */
	  }
          strcat(buf,lxP->string);
        }while(lexer._gettoken());

        if (buf[0]==0){throw syntax_error("Parameter is expected.");}      
        addps(buf);
        if (lxP->type==TlxData::CONTROL && lxP->string[0]==')'){break;}
        if (lxP->type!=TlxData::CONTROL || lxP->string[0]!=','){
         throw syntax_error("Invalid delimiter after parameter: ",lxP->string);}
      } 
    }
    if (psi_chk!=psi){throw syntax_error("Invalid parameter count.");}
    replaceParameters(macro);
  }
 
  TMemBlock* macroSource = new TMemBlock;
  macroSource->append(macro);
  preproc.insert(macroSource);
  return 1;
}

/*
  Error Table tests attributes of stored and new (template) symbol.
  Template symbol is represented in rows and stored symbol in columns.
*/
TSymbol::TOperation TSymbol::ErrorTable[16] = {
	OK,	Define,	Define,	Error1,
	OK,	Common,	Error2,	Error2,
	OK,	Define,	Define,	Error1,
	Error1,	Define,	Error1,	Define
};

#define stRec (*symI).second

TSymbol::TOperation TSymbol::test(TSymbolRec* pRec, const string& macroName){
  TsymI symI;
  /* Calculate offset for error check table */
  pRec->tbl_offset = pRec->attr;
  if (pRec->attr & TSymbolRec::Extern && pRec->attr & TSymbolRec::Virtual){
    pRec->tbl_offset-=2;}
  pRec->tbl_offset--;
  
  if ((symI=sym.find(macroName))==sym.end()){return Define;}

  if ((stRec.internal==true)^(pRec->internal==true)){
    throw syntax_error("Source contains symbols that are used by segments: ",
      macroName.c_str());
  }
  int opRes;
  if (stRec.attr&TSymbolRec::Virtual){
    reports.Warnning(TReports::Symbols,
      "Virtual symbol `%s' is assigned new value.",macroName.c_str());
  }    
  if (stRec.attr==TSymbolRec::Internal){
    throw syntax_error("Symbol already defined: ",macroName.c_str());}    
  if (pRec->attr==TSymbolRec::Internal){
    if (stRec.attr==TSymbolRec::Virtual ||
        stRec.attr==TSymbolRec::Extern){return Define;}
    else{opRes=Error1;}
  }else{opRes = ErrorTable[pRec->tbl_offset+(stRec.tbl_offset<<2)];}
  
  /* Test func() already handles the following cases */
  switch(opRes){
  case Common:
    if (stRec.macro != pRec->macro){
      reports.Warnning(TReports::Symbols,
        "Previously decalred symbol `%s' as `%s'\n"
        "          is now redefined to `%s'", 
	macroName.c_str(), stRec.macro.c_str(), pRec->macro.c_str());
      throw syntax_error("Symbol already defined: ", macroName.c_str());
    }
    break;      
  case Error1:
    throw syntax_error("Attributes missmatch with"
                       " previously declared symbol: ",macroName.c_str());
  case Error2:
    throw syntax_error("Symbol already defined: ",macroName.c_str());
  }
  /* UPDATE REFERENCES */
  if (opRes==OK){
    int savedRef = pRec->refCnt; *pRec = stRec; pRec->refCnt = savedRef;
    storeSym(pRec, macroName);
  }
  return opRes;
}

/* returns macro name in lxP->string */ 
void TSymbol::parseFlags(TSymbolRec* pRec, int terminator_type){
  while(lexer._gettoken()){    
    if (lxP->type!=TlxData::STRING && lxP->type!=terminator_type){
      throw syntax_error("Invalid macro declaration.");}
      
    if (strcmp(lxP->string,"extern")==0){pRec->attr|=TSymbolRec::Extern;}
    else if (strcmp(lxP->string,"public")==0){pRec->attr|=TSymbolRec::Public;}
    else if (strcmp(lxP->string,"virtual")==0){pRec->attr|=TSymbolRec::Virtual;}
    else if (strcmp(lxP->string,"ref")==0){parseReference(pRec);}
    else if (lxP->type==terminator_type){break;}
    else{
      /* if label own attributes, listed just before, : is not
         need - otherwise : is required! */
      if (terminator_type==TlxData::LABEL){
        if (pRec->attr==0){
          throw syntax_error("Semicolon : is missing after label: ",
	                      lxP->string);}
        break; 
      }else{throw syntax_error("Invalid macro attribute.");}
    }
  }
  /* check relations between flags */
  if (pRec->attr==0||
      pRec->attr==TSymbolRec::Extern||
      pRec->attr==TSymbolRec::Public||
      pRec->attr==TSymbolRec::Virtual||
      (pRec->attr & TSymbolRec::Extern && pRec->attr & TSymbolRec::Virtual)){
    return;}    
  throw syntax_error("Symbol attributes are excluding each other.");
}

void TSymbol::parseMacro(TSymbolRec* pRec){
  bool newLineExpected=false;		/* if macro is extended with \ */
  
  /* check for parameters in form (a0,a1,...,an) */
  clearps(); lexer._gettoken();
  if (lxP->type==TlxData::CONTROL && lxP->string[0]=='(' && lxdata.stick){
    while(lexer._gettoken()){
      while (lxP->type==TlxData::NEWLINE){lexer._gettoken();}
      if (lxP->type!=TlxData::STRING){
        throw syntax_error("Parameter is expected.");}
      addps(lxP->string);
      lexer._gettoken();
      while (lxP->type==TlxData::NEWLINE){lexer._gettoken();}      
      if (lxP->type==TlxData::CONTROL && lxP->string[0]==')'){break;}
      if (lxP->type!=TlxData::CONTROL || lxP->string[0]!=','){
        throw syntax_error("Invalid delimiter after macro parameter: ",
                           lxP->string);
      }
    } 
  }else{PUT_TOKENBACK;}
  pRec->noArgs = psi;

  /* load macro string terminated by a new line, # or THEEND */
  while(lexer._gettoken()){
    if (lxP->type==TlxData::PREPROC || lxP->type==TlxData::THEEND){break;}
    if (lxP->type==TlxData::NEWLINE){
      if (newLineExpected==true){newLineExpected=false;}else{break;}}
    if (lxP->type==TlxData::CONTROL && lxP->string[0]=='\\'){
      newLineExpected=true;continue;}
    replace(lxP->string);      
    if (lxP->type==TlxData::QSTRING){
      pRec->macro = pRec->macro + '"' + lxP->string + '"';
    } else {
      if (lxP->stick==false && pRec->macro.size()>0){pRec->macro += " ";}
      pRec->macro = pRec->macro + lxP->string;      
    }
  }
  /* add default value 1 */
  if (pRec->macro.length()==0){pRec->macro="1";}
}

void TSymbol::reparseMacro(TSymbolRec* pRec){
  /* load macro string terminated by a new line, # or THEEND */
  while(lexer.gettoken()){
    if (lxP->type==TlxData::PREPROC || lxP->type==TlxData::THEEND){break;}
    if (lxP->type==TlxData::QSTRING){
      pRec->macro = pRec->macro + '"' + lxP->string + '"';
    }else{pRec->macro = pRec->macro + lxP->string + " ";}
  }
}

void TSymbol::parseReference(TSymbolRec* pRec){
  /* expecting = */
  GET_TOKEN;
  if (lxP->type!=TlxData::CONTROL || strcmp(lxP->string,"=")){
    throw syntax_error("Bad format at ",lxP->string);}
    
  char fn_buf [LX_STRLEN];
  syntax.Parse_FileName(fn_buf);
  pRec->ref = fn_buf;
}

void TSymbol::addps(char *s){
  if (psi==SYM_MAX_PARAM){
    throw generic_error("Parameter stack too small."
      " Increase SYM_MAX_PARAM in Symbol.h.");}
  /* SPECIAL CASE: NEGATIVE VALUES MUST BE IN BRACKETS! */
  if (s[0]=='-'){
    param_stack[psi][0]='(';
    strcpy(&param_stack[psi][1],s); strcat(param_stack[psi++],")");
  }else{strcpy(param_stack[psi++], s);}
}
 
/* 
  Replace parameter with sequent number - before storing it to the
  database.
*/
void TSymbol::replace(char *s){
  int i; for (i=0;i<psi;i++){
    if (strcmp(s,param_stack[i])==0){sprintf(s,"g%.2x",i);}}
}

void TSymbol::replaceParameters(char* s){
  char *needle,*src,buf [LX_LINEBUF],pnum [5];
  int pi;
  for (pi=0;pi<psi;pi++){
    buf[0]=0;src=s; sprintf(pnum,"g%.2x",pi);  
    while ((needle=strstr(src,pnum))!=NULL){
      strncat(buf,src,needle-src); strcat(buf,param_stack[pi]);
      src+=needle-src+3;
    }
    /* copy rest of it and update s */
    strcat(buf,src); strcpy(s,buf);
  }
}

/* Export all symbols, except extern with refCnt=0 */
void TSymbol::saveSymbols(){
  TsymCI symI;
  /* export public, extern and extern virtual */
  for (symI=sym.begin(); symI != sym.end(); symI++){  
  
    if ((stRec.attr==TSymbolRec::Extern && stRec.refCnt==0) || 
        stRec.attr==TSymbolRec::Internal ||
	stRec.attr==TSymbolRec::Virtual ||
      /*  stRec.label==false || */ stRec.internal==true){continue;}
      
    object.outOperand(stRec.refCnt);
    object.outOperand(stRec.segNo);
    object.outOperand(stRec.attr);    
    object.outStringOperand((*symI).first.c_str());
    object.outStringOperand(stRec.macro.c_str());
    object.outSymbolData();
  }  
  object.outTerminator();
  /* export internal and virtual */
  for(symI=sym.begin(); symI != sym.end(); symI++){
    if (!(stRec.attr==TSymbolRec::Internal ||
        stRec.attr==TSymbolRec::Virtual) ||
	stRec.label==false || stRec.internal==true){continue;}
    object.outOperand(stRec.refCnt);
    object.outOperand(stRec.segNo);
    object.outOperand(stRec.attr);
    object.outStringOperand((*symI).first.c_str());
    object.outOperand(stRec.macro.c_str());    
    object.outSymbolData();
  }  
}

/* Load public and extern virtual. */
void TSymbol::loadSymbols(){
  TSymbolRec tmpRec;
  tmpRec.label = true;
  tmpRec.segP = preproc.csrc->segP;
  tmpRec.attr = object.popOperand();
  tmpRec.segNo = preproc.csrc->segP->seg[object.popOperand()].newNo;
  tmpRec.refCnt = object.popOperand();
  tmpRec.macro = object.popStringOperand();  
  string macroName = object.popStringOperand();
/*
  printf("adding `%s' = `%s' (segNo=%d, refCnt=%d, attr=%d)\n",
    macroName.c_str(), 
    tmpRec.macro.c_str(),
    tmpRec.segNo, tmpRec.refCnt, tmpRec.attr); 
*/
  if (test(&tmpRec,macroName)==Define){storeSym(&tmpRec,macroName);}
}

/* Load non-public symbols and save them back immediatelly - debug support */
void TSymbol::loadNonPublicSymbols(){
  TSymbolRec tmpRec;
  long lval;
  string macroName = object.popStringOperand();
  lval = object.popOperand();
  tmpRec.attr = object.popOperand();
  tmpRec.segNo = preproc.csrc->segP->seg[object.popOperand()].newNo;
  tmpRec.refCnt = object.popOperand();
  if (segment.isEnabled(tmpRec.segNo)==false){return;}
  object.outOperand(tmpRec.refCnt);
  object.outOperand(tmpRec.segNo);
  object.outOperand(tmpRec.attr);
  object.outStringOperand(macroName.c_str());
  object.outOperand(lval);    
  object.outSymbolData();
}

/* After segments are fitted, public symbols need to be updated.
   A pass is required for each file seperately, because segment labels
   need to be adjusted every turn. 
   
   Extern virtual syms are changed to internal ones.
   
   Every memory block ends with # character! 
   While updatePublic() is called continously, this character is
   removed by first get_token in the reparseMacro() func. 
   
   For the last time, Object.C must take care, that this
   character does not confuse it. */
void TSymbol::updatePublic(){
  TsymI symI;
  /* compare segP to find current file */
  for(symI=sym.begin(); symI != sym.end(); symI++){
    if (stRec.segP != preproc.csrc->segP){continue;}
    /* copy macroString and reparse it */ 
    TMemBlock* macroSource = new TMemBlock;
    macroSource->append(stRec.macro.c_str());
    macroSource->append(" #");	/* add delimiter so we know where to stop */
    preproc.insert(macroSource);
    TSymbolRec tmp; reparseMacro(&tmp); stRec.macro=tmp.macro;
    if (stRec.attr==(TSymbolRec::Extern+TSymbolRec::Virtual)){
      stRec.attr=TSymbolRec::Internal;}
  }
}

