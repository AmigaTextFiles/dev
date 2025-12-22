include "inc/exec/types.inc";
include "inc/exec/lists.inc";
include "inc/exec/ports.inc";
include "inc/exec/interrupts.inc";
include "inc/exec/libraries.inc";

struct DiscResourceUnit is
  dru_Message:Message;
  dru_DiscBlock:Interrupt;
  dru_DiscSync:Interrupt;
  dru_Index:Interrupt;
;

struct DiscResource is
  dr_Library:Library;
  dr_Current:ulong;
  dr_Flags:ubyte;
  dr_pad:ubyte;
  dr_SysLib:ulong;
  dr_CiaResource:ulong;
  dr_UnitID[4]:ulong;
  dr_Waiting:List;
  dr_DiscBlock:Interrupt;
  dr_DiscSync:Interrupt;
  dr_Index:Interrupt;
  dr_CurrTask:ulong;
;

def DRB_ALLOC0 = 0;
def DRB_ALLOC1 = 1;
def DRB_ALLOC2 = 2;
def DRB_ALLOC3 = 3;
def DRB_ACTIVE = 7;

def DRF_ALLOC0 = (1<<0);
def DRF_ALLOC1 = (1<<1);
def DRF_ALLOC2 = (1<<2);
def DRF_ALLOC3 = (1<<3);
def DRF_ACTIVE = (1<<7);

def DSKDMAOFF = $4000;

def DISKNAME = "disk.resource";

def DR_ALLOCUNIT = (LIB_BASE-0*LIB_VECTSIZE);
def DR_FREEUNIT = (LIB_BASE-1*LIB_VECTSIZE);
def DR_GETUNIT = (LIB_BASE-2*LIB_VECTSIZE);
def DR_GIVEUNIT = (LIB_BASE-3*LIB_VECTSIZE);
def DR_GETUNITID = (LIB_BASE-4*LIB_VECTSIZE);
def DR_READUNITID = (LIB_BASE-5*LIB_VECTSIZE);

def DR_LASTCOMM = (DR_READUNITID);

def DRT_AMIGA = ($00000000);
def DRT_37422D2S = ($55555555);
def DRT_EMPTY = ($ffffffff);
def DRT_150RPM = ($aaaaaaaa);

