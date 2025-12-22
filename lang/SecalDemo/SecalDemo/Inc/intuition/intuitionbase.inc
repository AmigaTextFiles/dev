include "inc/exec/types.inc";
include "inc/exec/libraries.inc";
include "inc/intuition/intuition.inc";
include "inc/exec/interrupts.inc";

def DMODECOUNT = $0002;
def HIRESPICK = $0000;
def LOWRESPICK = $0001;

def EVENTMAX = 10;

def RESCOUNT = 2;
def HIRESGADGET = 0;
def LOWRESGADGET = 1;

def GADGETCOUNT = 8;
def UPFRONTGADGET = 0;
def DOWNBACKGADGET = 1;
def SIZEGADGET = 2;
def CLOSEGADGET = 3;
def DRAGGADGET = 4;
def SUPFRONTGADGET = 5;
def SDOWNBACKGADGET = 6;
def SDRAGGADGET = 7;

struct IntuitionLibBase is
  LibNode:Library;
  ViewLord:View;
  ActiveWindow:ulong;
  ActiveScreen:ulong;
  FirstScreen:ulong;
  Flags:ulong;
  MouseY,MouseX:word;
  Seconds:ulong;
  Micros:ulong;
;

