include "inc/exec/types.inc";

struct Resident is
  rt_MatchWord:uword;
  rt_MatchTag:ulong;
  rt_EndSkip:ulong;
  rt_Flags:ubyte;
  rt_Version:ubyte;
  rt_Type:ubyte;
  rt_Pri:byte;
  rt_Name:ulong;
  rt_IdString:ulong;
  rt_Init:ulong;
;

def RTC_MATCHWORD = $4afc;

def RTF_AUTOINIT = (1<<7);
def RTF_AFTERDOS = (1<<2);
def RTF_SINGLETASK = (1<<1);
def RTF_COLDSTART = (1<<0);

