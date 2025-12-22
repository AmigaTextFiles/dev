MODULE 'exec/nodes'
/*
* The 'Init' entries are only used if the corresponding
* bit is set in the Flags field.
*
* So if you are just a 68881, you do not need the Init stuff
* just make sure you have cleared the Flags field.
*
* This should allow us to add Extended Precision later.
*
* For Init users, if you need to be called whenever a task
* opens this library for use, you need to change the appropriate
* entries in MathIEEELibrary.
*/
OBJECT MathIEEEResource
  MathIEEEResource_Node:Node,
  MathIEEEResource_Flags:UWORD,
  MathIEEEResource_BaseAddr:PTR TO UWORD,
  MathIEEEResource_DblBasInit(),
  MathIEEEResource_DblTransInit(),
  MathIEEEResource_SglBasInit(),
  MathIEEEResource_SglTransInit(),
  MathIEEEResource_ExtBasInit(),
  MathIEEEResource_ExtTransInit()

/* definations for MathIEEEResource_FLAGS */
CONST MATHIEEERESOURCEF_DBLBAS=(1<<0),
 MATHIEEERESOURCEF_DBLTRANS=(1<<1),
 MATHIEEERESOURCEF_SGLBAS=(1<<2),
 MATHIEEERESOURCEF_SGLTRANS=(1<<3),
 MATHIEEERESOURCEF_EXTBAS=(1<<4),
 MATHIEEERESOURCEF_EXTTRANS=(1<<5)
