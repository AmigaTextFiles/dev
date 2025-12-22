include "inc/exec/types.inc";
include "inc/exec/libraries.inc";

def MR_SERIALPORT = 0;
def MR_SERIALBITS = 1;
def MR_PARALLELPORT = 2;
def MR_PARALLELBITS = 3;

def MR_ALLOCMISCRESOURCE = (LIB_BASE);
def MR_FREEMISCRESOURCE = (LIB_BASE-LIB_VECTSIZE);

def MISCNAME = "misc.resource";

