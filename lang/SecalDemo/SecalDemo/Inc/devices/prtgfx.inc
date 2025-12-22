include "inc/exec/types.inc";

def PCMYELLOW = 0;
def PCMMAGENTA = 1;
def PCMCYAN = 2;
def PCMBLACK = 3;
def PCMBLUE = PCMYELLOW;
def PCMGREEN = PCMMAGENTA;
def PCMRED = PCMCYAN;
def PCMWHITE = PCMBLACK;

union colorEntry is
  colorLong:ulong;
  colorByte[4]:ubyte;
  colorSByte[4]:byte;
;

struct PrtInfo is
  pi_render:ulong;
  pi_rp:ulong;
  pi_temprp:ulong;
  pi_RowBuf:ulong;
  pi_HamBuf:ulong;
  pi_ColorMap:ulong;
  pi_ColorInt:ulong;
  pi_HamInt:ulong;
  pi_Dest1Int:ulong;
  pi_Dest2Int:ulong;
  pi_ScaleX:ulong;
  pi_ScaleXAlt:ulong;
  pi_dmatrix:ulong;
  pi_TopBuf:ulong;
  pi_BotBuf:ulong;
  pi_RowBufSize:uword;
  pi_HamBufSize:uword;
  pi_ColorMapSize:uword;
  pi_ColorIntSize:uword;
  pi_HamIntSize:uword;
  pi_Dest1IntSize:uword;
  pi_Dest2IntSize:uword;
  pi_ScaleXSize:uword;
  pi_ScaleXAltSize:uword;
  pi_PrefsFlags:uword;
  pi_special:ulong;
  pi_xstart:uword;
  pi_ystart:uword;
  pi_width:uword;
  pi_height:uword;
  pi_pc:ulong;
  pi_pr:ulong;
  pi_ymult:uword;
  pi_ymod:uword;
  pi_ety:word;
  pi_xpos:uword;
  pi_threshold:uword;
  pi_tempwidth:uword;
  pi_flags:uword;
;

