/*
**  $VER: amigae.e V1.0
**
**  Some extra AmigaE-fuctions.
**
**  Written by Gøran W. Thomassen
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register',
       'gms/dpkernel','gms/system/modules'

MODULE 'gms/system/debug'

PROC init_eModule(modname,basestore)
  DEF mod:PTR TO module

  DprintF('Init() (AmigaE.m)',['%s','Setting AmigaE-tabletype.'])

  IF (mod:=Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    modname,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN RETURN NIL
  ^basestore:=mod.modbase
ENDPROC mod
