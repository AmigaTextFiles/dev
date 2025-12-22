;/*
;**  $VER: mathresource.h 1.2 (13.7.90)
;**  Includes Release 40.15
;**
;**  Data structure returned by OpenResource of:
;**  "MathIEEE.resource"
;**
;**
;**  (C) Copyright 1987-1993 Commodore-AMIGA, Inc.
;**      All Rights Reserved
;*/

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"

;* The 'Init' entries are only Used If the corresponding
;* bit is set in the Flags field.
;*
;* So If you are just a 68881, you do NOT need the Init stuff
;* just make sure you have cleared the Flags field.
;*
;* This should allow us To ADD Extended Precision later.
;*
;* For Init users, If you need To be called whenever a task
;* opens this library For Use, you need To change the appropriate
;* entries in MathIEEELibrary.

Structure MathIEEEResource
  MathIEEEResource_Node.Node;
  MathIEEEResource_Flags.w;
  *MathIEEEResource_BaseAddr.w; /* ptr to 881 if exists */
  *MathIEEEResource_DblBasInit.l
  *MathIEEEResource_DblTransInit.l
  *MathIEEEResource_SglBasInit.l
  *MathIEEEResource_SglTransInit.l
  *MathIEEEResource_ExtBasInit.l
  *MathIEEEResource_ExtTransInit.l
EndStructure

; definations For MathIEEEResource_FLAGS

#MATHIEEERESOURCEF_DBLBAS  = (1 << 0)
#MATHIEEERESOURCEF_DBLTRANS =  (1 << 1)
#MATHIEEERESOURCEF_SGLBAS =  (1 << 2)
#MATHIEEERESOURCEF_SGLTRANS = (1 << 3)
#MATHIEEERESOURCEF_EXTBAS = (1 << 4)
#MATHIEEERESOURCEF_EXTTRANS = (1 << 5)
