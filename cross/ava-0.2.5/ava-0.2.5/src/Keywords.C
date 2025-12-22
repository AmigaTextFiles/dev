/*
  Keywords.C
  Uros Platise, dec. 1998
  
  Last update: 21. Januar 1999 (Little endians added)
  
  Supported keywords:
    * define storage ds.(b/w/l/W/L)
    * defind constant dc.(b/w/l/W/L)
    
  where b=byte, w=word, l=long (32 bit), 
                W=word (big endian format),
                L=long (big endian format)
*/

#include <stdio.h>
#include <string.h>
#include "Lexer.h"
#include "Syntax.h"
#include "Segment.h"
#include "Error.h"
#include "Keywords.h"
#include "Object.h"
#include "Avr.h"
#include "Global.h"

#define KEY_NONE	0
#define KEY_DS		1
#define KEY_DC		2

const char* TKeywords::help_keyformat =
"Byte (b), little/Big endian word (w/W) or\n"
"            little/Big endian long (l/L) is not defined.";


bool TKeywords::parse(){
  assert(lxP->type==TlxData::STRING);
  if (strcmp(lxP->string,"ds")==0){ds();}
  else if (strcmp(lxP->string,"dc")==0){dc();}
  else if (strcmp(lxP->string,"cref")==0){cref();}
  else if (strcmp(lxP->string,"device")==0){Device();}
  else {return false;}
  return true;
}

void TKeywords::Translate(int keyNo){
  TSize sizeType=(TSize)object.popOperand();
  long size = GetSize(sizeType);
  long aux=object.popOperand();
  switch(keyNo){  
  case KEY_DS:
    size *= aux;
    for(long i=0; i<size; i++){object.outCode((unsigned char)0x00);}
    break;    
  case KEY_DC:
    outArg(sizeType,aux);
    break;
  default:
    throw syntax_error("Invalid keyword number.");
  }
}

TKeywords::TSize TKeywords::getType(){
  GET_TOKEN; 
  if (lxP->type!=TlxData::CONTROL||lxP->string[0]!='.'){
    throw syntax_error(help_keyformat);
  }
  GET_TOKEN; 
  if (lxP->type!=TlxData::STRING){
    throw syntax_error(help_keyformat);
  }
  switch (lxP->string[0]){
  case 'b': return S_Byte;
  case 'w': return S_Word;
  case 'l': return S_Long;
  case 'W': return S_Word | A_BigEndian;
  case 'L': return S_Long | A_BigEndian;
  default: throw syntax_error("Invalid format.");
  }
}

void TKeywords::outArg(TSize sizeType, long val){
  unsigned int lendi;
  unsigned long lendl;
  
  switch(sizeType){
  case S_Byte: object.outCode((unsigned char)val); break;
  case S_Word: 
    lendi = ((val>>8) & 0xff) + ((val & 0xff)<<8);
    object.outCode(lendi); 
    break;               
  case S_Long: 
    lendl = ((val>>24) & 0xff) + ((val>>8) & 0xff00) +
            ((val & 0xff00)<<8) + ((val & 0xff)<<24);
    object.outCode(lendl); 
    break;
  
  case S_Word|A_BigEndian: object.outCode((unsigned  int)val); break;
  case S_Long|A_BigEndian: object.outCode((unsigned long)val); break;
  
  default: assert(0);
  }
}

void TKeywords::ds(){
  TSize sizeType=getType();
  long res;
  GET_TOKEN; 
  syntax.Parse_GAS (1);
  if (gas.status!=TGAS::Solved){
    throw syntax_error("Storage size must be known.");
  }    
  object.outOperand(res=gas.result());
  object.outOperand((long)sizeType);
  object.outKeyword(KEY_DS);
  segment.incPC(GetSize(sizeType) * res);
}

void TKeywords::dc(){
  TSize sizeType=getType();
  int argCount=0;
  do{
    argCount++;  
get_again:
    GET_TOKEN;
    /* expecting value or quoted string */
    switch(lxP->type){
    case TlxData::NEWLINE: goto get_again;
    case TlxData::MATH:
    case TlxData::LVAL:
    case TlxData::STRING:
    case TlxData::CONTROL:
      syntax.Parse_GAS(argCount);
      object.outOperand(gas.eqstr);
      object.outOperand(sizeType);
      object.outKeyword(KEY_DC);
      segment.incPC(GetSize(sizeType));
      break;
      
    case TlxData::QSTRING:
      object.outSrcLine();
      for (unsigned int i=0;i<strlen(lxP->string);i++){
        outArg(sizeType,lxP->string[i]); 
        segment.incPC(GetSize(sizeType));
      }
      GET_TOKEN;
      break;
      
    default:
      throw syntax_error("Syntax error.");
    }    
  }while(lxP->type==TlxData::CONTROL && lxP->string[0]==',');
  PUT_TOKENBACK;
}

void TKeywords::cref(){
  GET_TOKEN;
  syntax.Parse_GAS(1);
  if (gas.status==TGAS::Solved){object.outCRef(gas.result());}
  else{throw syntax_error("C Reference must not contain unknown symbols.");}
}

void TKeywords::Device(){  
  GET_TOKEN;
  if (lxP->type!=TlxData::STRING){
    throw syntax_error("Invalid device declaration.");}
    
  if (archp()){archp->IsSameDevice();} 
  else if (strcmp(lxP->string,"AVR")==0){archp = new TAvr();}
  else{throw syntax_error("Not supported device: ", lxP->string);}
}

