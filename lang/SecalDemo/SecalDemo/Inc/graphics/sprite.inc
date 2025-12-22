include "inc/exec/types.inc";

def SPRITE_ATTACHED = $80;

struct SimpleSprite is
  posctldata:ulong;
  height:uword;
  x,y:uword;
  num:uword;
;

struct ExtSprite is
  es_SimpleSprite:SimpleSprite;
  es_wordwidth:uword;
  es_flags:uword;
;

def SPRITEA_Width = $81000000;
def SPRITEA_XReplication = $81000002;
def SPRITEA_YReplication = $81000004;
def SPRITEA_OutputHeight = $81000006;
def SPRITEA_Attached = $81000008;
def SPRITEA_OldDataFormat = $8100000a;

def GSTAG_SPRITE_NUM = $82000020;
def GSTAG_ATTACHED = $82000022;
def GSTAG_SOFTSPRITE = $82000024;

def GSTAG_SCANDOUBLED = $83000000;

