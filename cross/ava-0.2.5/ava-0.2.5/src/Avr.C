/*
	Avr.C
	
	AVR Parser and Machine Code Generator
	Uros Platise, (c) Dec 1998
	Last update: 12. March 1999
*/

#include <string.h>
#include "Lexer.h"
#include "Syntax.h"
#include "Symbol.h"
#include "Segment.h"
#include "Object.h"
#include "Reports.h"
#include "Avr.h"

const char rg0 = 0; /* none */
const char rg1 = 1; /* 0:31 (registers only!) */
const char rg2 = 2; /* 0:7 */
const char rg3 = 3; /* 0:63 */
const char rg4 = 4; /* 16:31 (registers only!) */
const char rg5 = 5; /* 0:255 */
const char rg6 = 6; /* -64:63 */
const char rg7 = 7; /* 0:255 -- complement bits! */
const char rg8 = 8; /* -2KB:2KB */
const char rg9 = 12; /* "24,26,28,30" */
//const char rg10 = 9; /* special: 0:4KB (flash) */
//const char rg11 = 10; /* special: 0:64k (sram) */
const char longCall = 11;

const char copyArg = 'C';
const char specialInc = '+';
const char specialDec = '-';

/* special attr: C - copy from the first argument */

TAvr::TInstSet TAvr::instSet [] = { 
  {"---", "--", "----------------", {rg0, rg0}, 0},
  {"adc", "dr", "000111rdddddrrrr", {rg1, rg1}, 1},
  {"add", "dr", "000011rdddddrrrr", {rg1, rg1}, 1},

  {"adiw","dK", "10010110KKddKKKK", {rg9, rg3}, 2},

  {"and", "dr", "001000rdddddrrrr", {rg1, rg1}, 1},
  {"andi","dK", "0111KKKKddddKKKK", {rg4, rg5}, 1},
  {"asr", "d",  "1001010ddddd0101", {rg1, rg0}, 1},
  {"bclr","s",  "100101001sss1000", {rg2, rg0}, 1},
  {"bld", "db", "1111100ddddd0bbb", {rg1, rg2}, 1},
  {"brbc","sk", "111101kkkkkkksss", {rg2, rg6}, 1},
  {"brbs","sk", "111100kkkkkkksss", {rg2, rg6}, 1},
  {"brcc","k",  "111101kkkkkkk000", {rg6, rg0}, 1},
  {"brcs","k",  "111100kkkkkkk000", {rg6, rg0}, 1},
  {"breq","k",  "111100kkkkkkk001", {rg6, rg0}, 1},
  {"brge","k",  "111101kkkkkkk100", {rg6, rg0}, 1},
  {"brhc","k",  "111101kkkkkkk101", {rg6, rg0}, 1},
  {"brhs","k",  "111100kkkkkkk101", {rg6, rg0}, 1},
  {"brid","k",  "111101kkkkkkk111", {rg6, rg0}, 1},
  {"brie","k",  "111100kkkkkkk111", {rg6, rg0}, 1},
  {"brlo","k",  "111100kkkkkkk000", {rg6, rg0}, 1},
  {"brlt","k",  "111100kkkkkkk100", {rg6, rg0}, 1},
  {"brmi","k",  "111100kkkkkkk010", {rg6, rg0}, 1},
  {"brne","k",  "111101kkkkkkk001", {rg6, rg0}, 1},
  {"brpl","k",  "111101kkkkkkk010", {rg6, rg0}, 1},
  {"brsh","k",  "111101kkkkkkk000", {rg6, rg0}, 1},
  {"brtc","k",  "111101kkkkkkk110", {rg6, rg0}, 1},
  {"brts","k",  "111100kkkkkkk110", {rg6, rg0}, 1},
  {"brvc","k",  "111101kkkkkkk011", {rg6, rg0}, 1},
  {"brvs","k",  "111100kkkkkkk011", {rg6, rg0}, 1},
  {"bset","s",  "100101000sss1000", {rg2, rg0}, 1},
  {"bst", "db", "1111101ddddd0bbb", {rg1, rg2}, 1},

  {"call","k",  "1001010kkkkk111k", {longCall, rg0}, 3},

  {"cbi", "Pb", "10011000PPPPPbbb", {rg1, rg2}, 1},
  {"cbr", "dK", "0111KKKKddddKKKK", {rg4, rg7}, 1},
  {"clc", "",   "1001010010001000", {rg0, rg0}, 1},
  {"clh", "",   "1001010011011000", {rg0, rg0}, 1},
  {"cli", "",   "1001010011111000", {rg0, rg0}, 1},
  {"cln", "",   "1001010010101000", {rg0, rg0}, 1},
  {"clr", "d",  "001001CdddddCCCC", {rg1, 'C'}, 1},
  {"cls", "",   "1001010011001000", {rg0, rg0}, 1},
  {"clt", "",   "1001010011101000", {rg0, rg0}, 1},
  {"clv", "",   "1001010010111000", {rg0, rg0}, 1},
  {"clz", "",   "1001010010011000", {rg0, rg0}, 1},
  {"com", "d",  "1001010ddddd0000", {rg1, rg0}, 1},
  {"cp",  "dr", "000101rdddddrrrr", {rg1, rg1}, 1},
  {"cpc", "dr", "000001rdddddrrrr", {rg1, rg1}, 1},
  {"cpi", "dK", "0011KKKKddddKKKK", {rg4, rg5}, 1},
  {"cpse","dr", "000100rdddddrrrr", {rg1, rg1}, 1},

  /* Special non-AVR instrcution .... */
//  {"dba", "k",  "kkkkkkkkkkkkkkkk", {rg11,rg0}, 1},
  
  {"dec", "d",  "1001010ddddd1010", {rg1, rg0}, 1},

  /* Special non-AVR instruction to work-around dc <symbol> */
//  {"dwa", "k",  "0000kkkkkkkkkkkk", {rg10, rg0}, 1}, 

  {"eor", "dr", "001001rdddddrrrr", {rg1, rg1}, 1},

  {"icall", "", "1001010100001001", {rg0, rg0}, 2},
  {"ijmp", "",  "1001010000001001", {rg0, rg0}, 2},

  {"in",  "dP", "10110PPdddddPPPP", {rg1, rg3}, 1},
  {"inc", "d",  "1001010ddddd0011", {rg1, rg0}, 1},

  {"jmp", "k",  "1001010kkkkk110k", {longCall, rg0}, 3},

  {"ld",  "dX", "1001000ddddd1100", {rg1, rg0}, 2},
  {"ld",  "dX", "1001000ddddd1101", {rg1, '+'}, 2},
  {"ld",  "dX", "1001000ddddd1110", {rg1, '-'}, 2},
  
  {"ld",  "dY", "1000000ddddd1000", {rg1, rg0}, 2},
  {"ld",  "dY", "1001000ddddd1001", {rg1, '+'}, 2},
  {"ld",  "dY", "1001000ddddd1010", {rg1, '-'}, 2},

  {"ld",  "dZ", "1000000ddddd0000", {rg1, rg0}, 1}, 
  {"ld",  "dZ", "1001000ddddd0001", {rg1, '+'}, 2},
  {"ld",  "dZ", "1001000ddddd0010", {rg1, '-'}, 2},

  {"ldd", "dY", "10Y0YY0ddddd1YYY", {rg1, rg3}, 2},
  {"ldd", "dZ", "10Z0ZZ0ddddd0ZZZ", {rg1, rg3}, 2},

  {"ldi", "dK", "1110KKKKddddKKKK", {rg4, rg5}, 1},

  {"lds", "dK", "1001000ddddd0000", {rg1, longCall}, 2},
  {"lpm", "",   "1001010111001000", {rg0, rg0}, 2},

  {"lsl", "d",  "000011CdddddCCCC", {rg1, 'C'}, 1},
  {"lsr", "d",  "1001010ddddd0110", {rg1, rg0}, 1},
  {"mov", "dr", "001011rdddddrrrr", {rg1, rg1}, 1},

  {"mul", "dr", "100111rdddddrrrr", {rg1, rg1}, 4},

  {"neg", "d",  "1001010ddddd0001", {rg1, rg0}, 1},
  {"nop", "",   "0000000000000000", {rg0, rg0}, 1},
  {"or",  "dr", "001010rdddddrrrr", {rg1, rg1}, 1},
  {"ori", "dK", "0110KKKKddddKKKK", {rg4, rg5}, 1},
  {"out", "Pr", "10111PPrrrrrPPPP", {rg3, rg1}, 1},

  {"pop", "d",  "1001000ddddd1111", {rg1, rg0}, 2},
  {"push","d",  "1001001ddddd1111", {rg1, rg0}, 2},

  {"rcall","k", "1101kkkkkkkkkkkk", {rg8, rg0}, 1},
  {"ret", "",   "1001010100001000", {rg0, rg0}, 1},
  {"reti", "",  "1001010100011000", {rg0, rg0}, 1},
  {"rjmp", "k", "1100kkkkkkkkkkkk", {rg8, rg0}, 1},
  {"rol", "d",  "000111CdddddCCCC", {rg1, 'C'}, 1},
  {"ror", "d",  "1001010ddddd0111", {rg1, rg0}, 1},
  {"sbc", "dr", "000010rdddddrrrr", {rg1, rg1}, 1},
  {"sbci","dK", "0100KKKKddddKKKK", {rg4, rg5}, 1},
  {"sbi", "pb", "10011010pppppbbb", {rg1, rg2}, 1},
  {"sbic","pb", "10011001pppppbbb", {rg1, rg2}, 1},
  {"sbis","pb", "10011011pppppbbb", {rg1, rg2}, 1},
  
  {"sbiw","dK", "10010111KKddKKKK", {rg9, rg3}, 2},

  {"sbr", "dK", "0110KKKKddddKKKK", {rg4, rg5}, 1},
  {"sbrc","rb", "1111110rrrrr0bbb", {rg1, rg2}, 1},
  {"sbrs","rb", "1111111rrrrr0bbb", {rg1, rg2}, 1},
  {"sec", "",   "1001010000001000", {rg0, rg0}, 1},
  {"seh", "",   "1001010001011000", {rg0, rg0}, 1},
  {"sei", "",   "1001010001111000", {rg0, rg0}, 1},
  {"sen", "",   "1001010000101000", {rg0, rg0}, 1},
  {"ser", "d",  "11101111dddd1111", {rg4, rg0}, 1},
  {"ses", "",   "1001010001001000", {rg0, rg0}, 1},
  {"set", "",   "1001010001101000", {rg0, rg0}, 1},
  {"sev", "",   "1001010000111000", {rg0, rg0}, 1},
  {"sez", "",   "1001010000011000", {rg0, rg0}, 1},
  {"sleep","",  "1001010110001000", {rg0, rg0}, 1},

  {"st", "Xr",  "1001001rrrrr1100", {rg0, rg1}, 2}, /* DO NOT CHANGE ORDER! */
  {"st", "Xr",  "1001001rrrrr1101", {'+', rg1}, 2},
  {"st", "Xr",  "1001001rrrrr1110", {'-', rg1}, 2},
  {"st", "Yr",  "1000001rrrrr1000", {rg0, rg1}, 2},
  {"st", "Yr",  "1001001rrrrr1001", {'+', rg1}, 2},
  {"st", "Yr",  "1001001rrrrr1010", {'-', rg1}, 2},
  {"st", "Zr",  "1000001rrrrr0000", {rg0, rg1}, 1},
  {"st", "Zr",  "1001001rrrrr0001", {'+', rg1}, 2},
  {"st", "Zr",  "1001001rrrrr0010", {'-', rg1}, 2},  

  {"std","Yr",  "10Y0YY1rrrrr1YYY", {rg3, rg1}, 2},
  {"std","Zr",  "10Z0ZZ1rrrrr0ZZZ", {rg3, rg1}, 2}, 
  {"sts","Kd",  "1001001ddddd0000", {longCall, rg1}, 2},

  {"sub", "dr", "000110rdddddrrrr", {rg1, rg1}, 1},
  {"subi","dK", "0101KKKKddddKKKK", {rg4, rg5}, 1},
  {"swap","d",  "1001010ddddd0010", {rg1, rg0}, 1},
  {"tst", "d",  "001000CdddddCCCC", {rg1, 'C'}, 1},
  {"wdr", "",   "1001010110101000", {rg0, rg0}, 1},

  {"","","",{0,0}}
};

TAvr::TConstSet TAvr::regSet [] = {
  { "r0", 0}, { "r1", 1}, {"r10",10}, {"r11",11}, 
  {"r12",12}, {"r13",13}, {"r14",14}, {"r15",15}, 
  {"r16",16}, {"r17",17}, {"r18",18}, {"r19",19}, 
  { "r2", 2}, {"r20",20}, {"r21",21}, {"r22",22},
  {"r23",23}, {"r24",24}, {"r25",25}, {"r26",26},
  {"r27",27}, {"r28",28}, {"r29",29}, { "r3", 3},
  {"r30",30}, {"r31",31}, { "r4", 4}, { "r5", 5}, 
  { "r6", 6}, { "r7", 7}, { "r8", 8}, { "r9", 9},

  {"",0}
};

TAvr::TAvr(){
  for (noInst=0; instSet [noInst].name [0] != 0; noInst++);
  for (noReg=0; regSet [noReg].name [0] != 0; noReg++);
  GET_TOKEN;
  if (lxP->type!=TlxData::LVAL){
    throw syntax_error("Instruction level number is missing (1,2 or 3)");}
  instLevel = lxP->lval;
  bug_skip_instruction = false;
  bug_check_skip_bug = symbol.findMacro("__avr_noskipbug") == NULL;
}

TAvr::~TAvr(){}

char* TAvr::Device(char* buf){
  sprintf(buf, "AVR %d\n", instLevel); return buf;
}

void TAvr::IsSameDevice(){
  if (strcmp(lxP->string, "AVR")!=0){
    throw generic_error("AVR: Previously selected device was not AVR.\n");}
  GET_TOKEN;
  if (lxP->type!=TlxData::LVAL){
    throw syntax_error("AVR: Instruction level number is missing (1,2 or 3)");}
  if (instLevel != lxP->lval){
    throw syntax_error("AVR: Instruction levels don't match:\n"
                       "Mixing different AVR targets.");}  
}

void TAvr::CheckCoreBugs(){
  if (bug_check_skip_bug){
    /* bug hunting */
    if (strcasecmp(lxP->string, "sbrs")==0 ||
	strcasecmp(lxP->string, "sbrc")==0 ||
	strcasecmp(lxP->string, "sbis")==0 ||
	strcasecmp(lxP->string, "sbic")==0 ||      
	strcasecmp(lxP->string, "cpse")==0){
      bug_skip_instruction = true;
    } else
    if ((strcasecmp(lxP->string, "lds")==0 ||
	strcasecmp(lxP->string, "sts")==0 ||
	strcasecmp(lxP->string, "jmp")==0 ||  
	strcasecmp(lxP->string, "call")==0) && bug_skip_instruction == true){
      reports.FileStatus(TReports::VL_ALL);
      reports.Warnning(
	"AVR-CORE BUG: Skip and Two-Word instructions:\n"
	"  If interrupt occurs during execution of the skip instruction\n"
	"  (sbrs,sbrc,sbis,sbic,cpse) followed by the two-word instruction\n"
	"  (lds,sts,jmp,call) AVR stores invalid return address to the stack.\n"
	"  This bug is fixed in later AVR revisions. Append the -favr_noskipbug\n"
	"  to the assembler command line in order to disable this checking.");
    } else bug_skip_instruction = false;
  }
}

int TAvr::is_Arch(){
  int top=0, bottom=noInst;
  int r, curInst, oldTop, oldBottom;    
  do{
    oldTop = top; oldBottom = bottom;
    curInst = (bottom + top) >> 1;
    if ((r=strcasecmp(lxP->string,(ip=&instSet[curInst])->name))==0){
      /*roll up to first instruction - like st, which has 3 derivates */
      while(strcasecmp(lxP->string,(ip-1)->name)==0){ip--;}
      if (ip->model > instLevel){
        throw syntax_error("Instruction not supported by selected model: ",
	                   ip->name);}
      CheckCoreBugs();
      return 1;
    }
    if (r<0){bottom = curInst;} else {top = curInst;}
  } while (oldTop!=top || oldBottom!=bottom);
  ip=NULL; 
  if ((rp=is_Register(lxP->string))!=NULL){return 1;}
  return 0;
}

TAvr::TConstSet* TAvr::is_Register(const char* str){
  int top=0, bottom=noReg;
  int r, curReg, oldTop, oldBottom;
  TConstSet* r_rp=NULL;
  do{  
    oldTop = top; oldBottom = bottom;
    curReg = (bottom + top) >> 1;
    if ((r=strcasecmp(str,(r_rp=&regSet[curReg])->name))==0){return r_rp;}
    if (r<0) {bottom = curReg;} else {top = curReg;}
  } while (oldTop!=top || oldBottom!=bottom);
  return NULL;
}

void TAvr::Parse(){
  if (ip!=NULL){
    /* tell segments to increase program counter */
    if (ip->chk[0]==longCall||ip->chk[1]==longCall){segment.incPC(4);}
    else{segment.incPC(2);}  
  
    int noArg=strlen(ip->arg);	/* number of arguments per instruction */
    int cArg;			/* instructions's current argument */  
    for (cArg=0; cArg<noArg; cArg++) {
      /* Get Next Token */
      GET_TOKEN;   
      //printf("(%ld,%d,%s)\n",preproc.line(),lxP->type,lxP->string);

      if (lxP->type!=TlxData::STRING && lxP->type!=TlxData::LVAL &&
          lxP->type!=TlxData::MATH && lxP->type!=TlxData::CONTROL) {
        throw syntax_error(cArg, "Invalid argument at ",ip->name);
      }            
      /* Parse Registers */
      if (ip->arg [cArg]=='d' || ip->arg [cArg]=='r') {
        if (lxP->type != TlxData::STRING) {
	  throw syntax_error(cArg, "Register is required at ", ip->name); 
	}
        TConstSet* ap = is_Register (lxP->string);
	if (ap==NULL){throw syntax_error(cArg,"Invalid register at ",ip->name);}
	
	/* Register Range Check */
	int regVal=ap->val;
	switch(ip->chk [cArg]){
	  case rg4: 
	    regVal-=16; 
	    if (regVal<0){throw syntax_error(cArg,
	      "Only registers r16-r31 are valid at ",ip->name);}
	    break;
	  case rg9: 
	    regVal-=24; /* registers 24,26,28,30 */
	    if (regVal<0||regVal>6||regVal&1==1){
	      throw syntax_error(cArg,"Only registers r24,r26,r28"
	        " and r30 are valid at ",ip->name);}
	    regVal>>=1; /* div by 2, now've got range from 0-3 */
	    break;
	}	
	object.outOperand(regVal);
        /* get delimiter - (expressions already return delimiter) */
        GET_TOKEN;      	  
      }
      /* 
        PARSE X,Y,Z SPECIAL REGISTERS
	They exist in the followings forms:
	  Z,Z+,-Z,Z+q
	  Y,Y+,-Y,Y+q
	  X,X+,-X
      */
      else if (ip->arg [cArg]=='X' || ip->arg [cArg]=='Y' ||
               ip->arg [cArg]=='Z') {
        parseIndexRegs(cArg);
      }
      /* PARSE CONSTANTS - Expressions */
      else {
        if (is_Register (lxP->string)){
	  throw syntax_error(cArg,"Invalid use of register at ",ip->name);}
        syntax.Parse_GAS (cArg);
	out_GAS(cArg);	
      }
      /* Check for delimiter (coma) after non-last argument! */
      if (cArg==noArg-1){continue;}
      if (lxP->type != TlxData::CONTROL) {
	if (lxP->string [0] != ','){
	  throw syntax_error(cArg, "Missing delimiter , at ", ip->name);}
      }
    }
    /* If instruction has arguments, we did read one token more for sure!
       We have to put it back, so Syntax.Run func. can correctly determine
       next operation. */    
    if (noArg>0){PUT_TOKENBACK;}
    object.outInstruction(ip-instSet);
  } else if (rp!=NULL) {
    throw syntax_error("Algebraical Assembler is not"
                       " supported in this version.");
    //printf ("Parsing algebraical form of '%s':\n", rp->name);
  }
}

void TAvr::parseIndexRegs(int cArg){
  TInstSet* org_ip=ip;
  int old_cursor_position;
  if (lxP->type==TlxData::STRING){
    if (lxP->string[1]!=0 || (lxP->string[0]!='X' &&
        lxP->string[0]!='Y' && lxP->string[0]!='Z')){
      throw syntax_error(cArg,"Invalid index register at ",ip->name);}
    /* Get close to REAL instruction. */
    /* Roll down in array... */    
    while (ip->arg [cArg]!=lxP->string[0]){      
      if((++ip)->name[0]==0){
        throw syntax_error(cArg,"Unsupported index register ",org_ip->name);}
    };    
    GET_TOKEN;
    if (lxP->type!=TlxData::MATH&&
        strcmp(ip->name,"std")!=0&&strcmp(ip->name,"ldd")!=0){
      return;}
    if (lxP->type!=TlxData::MATH || lxP->string[0]!='+' || lxP->string[1]!=0){
      throw syntax_error("Invalid use of index register at ", ip->name);}
    /* now we know, we have the following possibilities: Z+, Z+p */
    old_cursor_position=preproc.curpos();
    GET_TOKEN;
    if (strcmp(ip->name,"std")!=0&&strcmp(ip->name,"ldd")!=0){
      if ((old_cursor_position==(preproc.curpos()))&&
          (lxP->type==TlxData::STRING||lxP->type==TlxData::LVAL)){
        throw syntax_error(cArg,"Offset is not supported for instruction ",
	                   ip->name);}
      ip++; return;      
    }
    /* handle Z+p form */
    syntax.Parse_GAS (cArg);
    if (strlen(gas.eqstr)==0){
      throw syntax_error(cArg,"Offset is required at ",ip->name);}
    out_GAS(cArg);
  }else if (lxP->type==TlxData::MATH){
    if (lxP->string[0]!='-' || lxP->string[1]!=0){
      throw syntax_error(cArg,"Invalid use of index register at ", ip->name);}
    GET_TOKEN;
    if (lxP->type!=TlxData::STRING){
      throw syntax_error(cArg,"Index is missing at ",ip->name);}
    if (lxP->string[1]!=0 || (lxP->string[0]!='X' &&
        lxP->string[0]!='Y' && lxP->string[0]!='Z')){
      throw syntax_error(cArg,"Invalid index register at ",ip->name);}
    /* Get close to REAL instruction. */
    /* Roll down in array... */    
    while (ip->arg [cArg]!=lxP->string[0]){      
      if((++ip)->name[0]==0){
        throw syntax_error(cArg,"Unsupported index register ",org_ip->name);}
    };
    ip+=2; /* set to - register */
    GET_TOKEN;
  }
}

TAvr::TToDo TAvr::checK(int cArg, long res){
  if (ip->arg[cArg]=='k'){res>>=1;} 	/* FLASH ADDRESS SPACE!!! */
  switch(ip->chk[cArg]){
    case rg2:
      if (res<0||res>7){
        throw syntax_error(cArg,"Out of range [0:7] at ",ip->name);}
      break;
    case rg3:
      if (res<0||res>63){
        throw syntax_error(cArg,"Out of range [0:63] at ",ip->name);}
      break;
    case rg5:
      if (res<0||res>255){
        throw syntax_error(cArg,"Out of range [0:255] at ",ip->name);}
      break;
    case rg6:
      if (res<-64||res>63){
        throw syntax_error(cArg,"Out of range [-64:63] at ",ip->name);}
      break;
    case rg7: /* Note: complement bits */
      if (res<0||res>255){
        throw syntax_error(cArg,"Out of range [0:255] at ",ip->name);}
      return NegateBits;
      break;
    case rg8:
      if (res<-2048||res>2047){
        if (symbol.findMacro("__AVR_WRAP_AROUND")==NULL){
          throw syntax_error(cArg,"Out of range [-2048:2047] at ",ip->name);}
	else{return WrapAround;}
      }
      break;
    case longCall:
      if (ip->arg[cArg]=='K'){ /* sts/lds only */
        if (res<0||res>=65536){throw syntax_error(cArg,
	"Out of range [0:65535] at ",ip->name);}
      }else{ /* jmp/call only */
        if (res<0||res>=(4*1024*1024)){throw syntax_error(cArg,
	"Out of range [0:4M] at ",ip->name);}      
      }
      break;
  }
  return Nothing;
}

void TAvr::out_GAS(int cArg){
  char pc_offset [SEG_LABELLEN+LX_STRLEN];
  if (gas.status==TGAS::Solved){
    long res=gas.result();
    checK(cArg,res);
    /* Output Result */
    object.outOperand(res);
  }else{
    /* Look for relative Branch instructions. If their args
     are not fixed values but they are labels, relative address
     has to be calculated by substracting the value of current
     segment. */
    if (ip->chk[cArg]==rg6||ip->chk[cArg]==rg8){
      pc_offset [0]='(';
      strcpy(&pc_offset[1], gas.eqstr);
      strcat(pc_offset,")-");      
      segment.getPC(&pc_offset[strlen(pc_offset)]);
      object.outOperand(pc_offset);
    }else{    
      object.outOperand(gas.eqstr); 
    }
  }
}
 
void TAvr::Translate(int instruction){  
  ip = &instSet [instruction];
  long arg=0;
  unsigned int longCallBuffer=0;
  bool longCallFlag=false;

  /* create translation table */
  unsigned long int tranArray [256];
  tranArray ['0'] = 0;
  tranArray ['1'] = 0xffff;

  for (int i=strlen(ip->arg)-1;i>=0;i--){
    if (ip->chk[i]==rg0 || ip->chk[i]=='-' || ip->chk[i]=='+'){continue;}
    arg = object.popOperand();
    TToDo todo = checK(i,arg);
    
    if (todo==NegateBits){arg^=0xffffffff;}
    if (ip->arg[i]=='k'){arg>>=1;} 	/* FLASH ADDRESS SPACE!!! */
    if (todo==WrapAround){
//      long t=arg;     
      if (arg>2047){arg-=4096;}else{arg+=4096;}
//      reports.Warnning("wraping around: $%lx -> $%lx", t, arg);
    }
    if (ip->chk[i]==longCall){
      longCallFlag=true; longCallBuffer=(unsigned int)(arg&0xffff); arg>>=16;
    }
    tranArray [ip->arg[i]] = (unsigned int)arg;
  } 
  if (ip->chk[1]=='C'){tranArray['C']=(unsigned int)arg;} 
  /* translate now */
  char bn, *p = &ip->opcode [15];
  unsigned int outCode=0;
  for (bn=0; bn<16; bn++, p--) {
    outCode |= (tranArray [*p] & 1) << bn;
    tranArray[*p] >>= 1;
  }
  object.outCode(outCode);
  if (longCallFlag==true){object.outCode(longCallBuffer);}
}

