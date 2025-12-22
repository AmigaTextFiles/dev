include "inc/exec/io.inc";

def NDB_NEWIORB = 0;
def NDB_WORDSYNC = 1;
def NDB_SYLSYNC = 2;

def NDF_NEWIORB = (1<<NDB_NEWIORB);
def NDF_WORDSYNC = (1<<NDB_WORDSYNC);
def NDF_SYLSYNC = (1<<NDB_SYLSYNC);

def ND_NoMem = -2;
def ND_NoAudLib = -3;
def ND_MakeBad = -4;
def ND_UnitErr = -5;
def ND_CantAlloc = -6;
def ND_Unimpl = -7;
def ND_NoWrite = -8;
def ND_Expunged = -9;
def ND_PhonErr = -20;
def ND_RateErr = -21;
def ND_PitchErr = -22;
def ND_SexErr = -23;
def ND_ModeErr = -24;
def ND_FreqErr = -25;
def ND_VolErr = -26;
def ND_DCentErr = -27;
def ND_CentPhonErr = -28;

def DEFPITCH = 110;
def DEFRATE = 150;
def DEFVOL = 64;
def DEFFREQ = 22200;
def MALE = 0;
def FEMALE = 1;
def NATURALF0 = 0;
def ROBOTICF0 = 1;
def MANUALF0 = 2;
def DEFSEX = MALE;
def DEFMODE = NATURALF0;
def DEFARTIC = 100;
def DEFCENTRAL = 0;
def DEFF0PERT = 0;
def DEFF0ENTHUS = 32;
def DEFPRIORITY = 100;

def MINRATE = 40;
def MAXRATE = 400;
def MINPITCH = 65;
def MAXPITCH = 320;
def MINFREQ = 5000;
def MAXFREQ = 28000;
def MINVOL = 0;
def MAXVOL = 64;
def MINCENT = 0;
def MAXCENT = 100;

struct narrator_rb is
  message:IOStdReq;
  rate:uword;
  pitch:uword;
  mode:uword;
  sex:uword;
  ch_masks:ulong;
  nm_masks:uword;
  volume:uword;
  sampfreq:uword;
  mouths:ubyte;
  chanmask:ubyte;
  numchan:ubyte;
  flags:ubyte;
  F0enthusiasm:ubyte;
  F0perturb:ubyte;
  F1adj:byte;
  F2adj:byte;
  F3adj:byte;
  A1adj:byte;
  A2adj:byte;
  A3adj:byte;
  articulate:ubyte;
  centralize:ubyte;
  centphon:ulong;
  AVbias:byte;
  AFbias:byte;
  priority:byte;
  pad1:byte;
;

struct mouth_rb is
  voice:narrator_rb;
  width:ubyte;
  height:ubyte;
  shape:ubyte;
  sync:ubyte;
;

