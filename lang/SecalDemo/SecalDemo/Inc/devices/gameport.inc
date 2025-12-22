include "inc/exec/types.inc";
include "inc/exec/io.inc";

def GPD_READEVENT = (CMD_NONSTD+0);
def GPD_ASKCTYPE = (CMD_NONSTD+1);
def GPD_SETCTYPE = (CMD_NONSTD+2);
def GPD_ASKTRIGGER = (CMD_NONSTD+3);
def GPD_SETTRIGGER = (CMD_NONSTD+4);

def GPTB_DOWNKEYS = 0;
def GPTF_DOWNKEYS = (1<<0);
def GPTB_UPKEYS = 1;
def GPTF_UPKEYS = (1<<1);

struct GamePortTrigger is
  gpt_Keys:uword;
  gpt_Timeout:uword;
  gpt_XDelta:uword;
  gpt_YDelta:uword;
;

def GPCT_ALLOCATED = -1;
def GPCT_NOCONTROLLER = 0;

def GPCT_MOUSE = 1;
def GPCT_RELJOYSTICK = 2;
def GPCT_ABSJOYSTICK = 3;

def GPDERR_SETCTYPE = 1;

