include "inc/exec/nodes.inc";

struct MathIEEEResource is
  MathIEEEResource_Node:Node;
  MathIEEEResource_Flags:uword;
  MathIEEEResource_BaseAddr:ulong;
  MathIEEEResource_DblBasInit:ulong;
  MathIEEEResource_DblTransInit:ulong;
  MathIEEEResource_SglBasInit:ulong;
  MathIEEEResource_SglTransInit:ulong;
  MathIEEEResource_ExtBasInit:ulong;
  MathIEEEResource_ExtTransInit:ulong;
;

def MATHIEEERESOURCEF_DBLBAS = (1<<0);
def MATHIEEERESOURCEF_DBLTRANS = (1<<1);
def MATHIEEERESOURCEF_SGLBAS = (1<<2);
def MATHIEEERESOURCEF_SGLTRANS = (1<<3);
def MATHIEEERESOURCEF_EXTBAS = (1<<4);
def MATHIEEERESOURCEF_EXTTRANS = (1<<5);

