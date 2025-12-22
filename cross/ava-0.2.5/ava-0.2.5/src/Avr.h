/*
	Avr.h
	
	AVR Family Machine Code Generator
	Uros Platise, (c) 1998
*/

#ifndef __AVR
#define __AVR

#include "Global.h"

class TAvr: public TArch {
private:
  enum TToDo {Nothing=0, NegateBits=1, WrapAround=2};
  
  struct TInstSet {		/* instruction entry */
    char name [6];
    char arg [4];
    char opcode [17];
    char chk [2];
    char model;
  };  
  struct TConstSet {
    char name [4];
    int  val;
  };      
  static TInstSet instSet [];
  static TConstSet regSet [];  
  int noInst;			/* number of instruction in database */
  int noReg;
  int instLevel;		/* instruction level support */
  TInstSet* ip;			/* current instruction */
  TConstSet* rp;		/* current register */
  
  /* BUG hunters */
  bool bug_skip_instruction;
  bool bug_check_skip_bug;

private:
  void CheckCoreBugs();
  TConstSet* is_Register (const char* str);  
  				/* Check and Modify Range of
				   Constants and Address Space */
  TToDo checK(int cArg, long res); 
  void parseIndexRegs(int cArg);/* Aux. parsing functions ... */  				
  void out_GAS(int cArg);	/* Aux. output functions ... */ 
  
public:
  TAvr ();
  ~TAvr ();

  char* Device(char* buf);
  void IsSameDevice();
  int is_Arch ();
  void Parse ();
  void Translate(int instruction);
};

#endif

