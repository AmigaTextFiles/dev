include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

def DRIVERNAMESIZE = 30;
def DEVICENAMESIZE = 32;

struct PrinterTxtPrefs is
  pt_Reserved[4]:long;
  pt_Driver[30]:ubyte;
  pt_Port:ubyte;
  pt_PaperType:uword;
  pt_PaperSize:uword;
  pt_PaperLength:uword;
  pt_Pitch:uword;
  pt_Spacing:uword;
  pt_LeftMargin:uword;
  pt_RightMargin:uword;
  pt_Quality:uword;
;

def PP_PARALLEL = 0;
def PP_SERIAL = 1;

def PT_FANFOLD = 0;
def PT_SINGLE = 1;

def PS_US_LETTER = 0;
def PS_US_LEGAL = 1;
def PS_N_TRACTOR = 2;
def PS_W_TRACTOR = 3;
def PS_CUSTOM = 4;
def PS_EURO_A0 = 5;
def PS_EURO_A1 = 6;
def PS_EURO_A2 = 7;
def PS_EURO_A3 = 8;
def PS_EURO_A4 = 9;
def PS_EURO_A5 = 10;
def PS_EURO_A6 = 11;
def PS_EURO_A7 = 12;
def PS_EURO_A8 = 13;

def PP_PICA = 0;
def PP_ELITE = 1;
def PP_FINE = 2;

def PS_SIX_LPI = 0;
def PS_EIGHT_LPI = 1;

def PQ_DRAFT = 0;
def PQ_LETTER = 1;

struct PrinterUnitPrefs is
  pu_Reserved[4]:long;
  pu_UnitNum:long;
  pu_OpenDeviceFlags:ulong;
  pu_DeviceName[32]:ubyte;
;

