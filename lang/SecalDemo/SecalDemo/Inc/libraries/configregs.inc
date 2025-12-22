include "inc/exec/types.inc";

struct ExpansionRom is
  er_Type:ubyte;
  er_Product:ubyte;
  er_Flags:ubyte;
  er_Reserved03:ubyte;
  er_Manufacturer:uword;
  er_SerialNumber:ulong;
  er_InitDiagVec:uword;
  er_Reserved0c:ubyte;
  er_Reserved0d:ubyte;
  er_Reserved0e:ubyte;
  er_Reserved0f:ubyte;
;

struct ExpansionControl is
  ec_Interrupt:ubyte;
  ec_Z3_HighBase:ubyte;
  ec_BaseAddress:ubyte;
  ec_Shutup:ubyte;
  ec_Reserved14:ubyte;
  ec_Reserved15:ubyte;
  ec_Reserved16:ubyte;
  ec_Reserved17:ubyte;
  ec_Reserved18:ubyte;
  ec_Reserved19:ubyte;
  ec_Reserved1a:ubyte;
  ec_Reserved1b:ubyte;
  ec_Reserved1c:ubyte;
  ec_Reserved1d:ubyte;
  ec_Reserved1e:ubyte;
  ec_Reserved1f:ubyte;
;

def E_SLOTSIZE = $10000;
def E_SLOTMASK = $ffff;
def E_SLOTSHIFT = 16;

def E_EXPANSIONBASE = $00e80000;
def EZ3_EXPANSIONBASE = $ff000000;

def E_EXPANSIONSIZE = $00080000;
def E_EXPANSIONSLOTS = 8;

def E_MEMORYBASE = $00200000;
def E_MEMORYSIZE = $00800000;
def E_MEMORYSLOTS = 128;

def EZ3_CONFIGAREA = $40000000;
def EZ3_CONFIGAREAEND = $7fffffff;
def EZ3_SIZEGRANULARITY = $00080000;

def ERT_TYPEMASK = $c0;
def ERT_TYPEBIT = 6;
def ERT_TYPESIZE = 2;
def ERT_NEWBOARD = $c0;
def ERT_ZORROII = ERT_NEWBOARD;
def ERT_ZORROIII = $80;

def ERTB_MEMLIST = 5;
def ERTB_DIAGVALID = 4;
def ERTB_CHAINEDCONFIG = 3;

def ERTF_MEMLIST = (1<<5);
def ERTF_DIAGVALID = (1<<4);
def ERTF_CHAINEDCONFIG = (1<<3);

def ERT_MEMMASK = $07;
def ERT_MEMBIT = 0;
def ERT_MEMSIZE = 3;

def ERFF_MEMSPACE = (1<<7);
def ERFB_MEMSPACE = 7;

def ERFF_NOSHUTUP = (1<<6);
def ERFB_NOSHUTUP = 6;

def ERFF_EXTENDED = (1<<5);
def ERFB_EXTENDED = 5;

def ERFF_ZORRO_III = (1<<4);
def ERFB_ZORRO_III = 4;

def ERT_Z3_SSMASK = $0f;
def ERT_Z3_SSBIT = 0;
def ERT_Z3_SSSIZE = 4;

def ECIB_INTENA = 1;
def ECIB_RESET = 3;
def ECIB_INT2PEND = 4;
def ECIB_INT6PEND = 5;
def ECIB_INT7PEND = 6;
def ECIB_INTERRUPTING = 7;

def ECIF_INTENA = (1<<1);
def ECIF_RESET = (1<<3);
def ECIF_INT2PEND = (1<<4);
def ECIF_INT6PEND = (1<<5);
def ECIF_INT7PEND = (1<<6);
def ECIF_INTERRUPTING = (1<<7);

def EC_MEMADDR(slot) = ((slot)<<(E_SLOTSHIFT));

struct DiagArea is
  da_Config:ubyte;
  da_Flags:ubyte;
  da_Size:uword;
  da_DiagPoint:uword;
  da_BootPoint:uword;
  da_Name:uword;
  da_Reserved01:uword;
  da_Reserved02:uword;
;

def DAC_BUSWIDTH = $c0;
def DAC_NIBBLEWIDE = $00;
def DAC_BYTEWIDE = $40;
def DAC_WORDWIDE = $80;

def DAC_BOOTTIME = $30;
def DAC_NEVER = $00;
def DAC_CONFIGTIME = $10;

def DAC_BINDTIME = $20;

