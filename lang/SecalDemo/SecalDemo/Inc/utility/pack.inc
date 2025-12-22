include "inc/exec/types.inc";
include "inc/utility/tagitem.inc";

def PSTB_SIGNED = 31;
def PSTB_UNPACK = 30;
def PSTB_PACK = 29;
def PSTB_EXISTS = 26;

def PSTF_SIGNED = (1<<PSTB_SIGNED);
def PSTF_UNPACK = (1<<PSTB_UNPACK);
def PSTF_PACK = (1<<PSTB_PACK);

def PSTF_EXISTS = (1<<PSTB_EXISTS);

def PKCTRL_PACKUNPACK = $00000000;
def PKCTRL_PACKONLY = $40000000;
def PKCTRL_UNPACKONLY = $20000000;

def PKCTRL_BYTE = $80000000;
def PKCTRL_WORD = $88000000;
def PKCTRL_LONG = $90000000;

def PKCTRL_UBYTE = $00000000;
def PKCTRL_UWORD = $08000000;
def PKCTRL_ULONG = $10000000;

def PKCTRL_BIT = $18000000;
def PKCTRL_FLIPBIT = $98000000;

def PACK_STARTTABLE(tagbase) = (tagbase);
def PACK_NEWOFFSET(tagbase) = (-1),(tagbase);
def PACK_ENDTABLE = 0;
def PACK_ENTRY(tagbase,tag,type,field,control) = (control|((tag-tagbase)<<16)|PK_CALCOFFSET(type,field));
def PACK_BYTEBIT(tagbase,tag,type,field,control,flags) = (control|((tag-tagbase)<<16)|PK_CALCOFFSET(type,field)|(PK_BITNUM(flags)<<13));
def PACK_WORDBIT(tagbase,tag,type,field,control,flags) = (control|((tag-tagbase)<<16)|(PK_CALCOFFSET(type,field)+PK_WORDOFFSET(flags))|((PK_BITNUM(flags)&7)<<13));
def PACK_LONGBIT(tagbase,tag,type,field,control,flags) = (control|((tag-tagbase)<<16)|(PK_CALCOFFSET(type,field)+PK_LONGOFFSET(flags))|((PK_BITNUM(flags)&7)<<13));

