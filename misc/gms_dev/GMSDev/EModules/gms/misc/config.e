
/*
**  $VER: config.e
**
**  Config Object.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'

/****************************************************************************
** config Object.
*/

CONST VER_CONFIG  = 1,
      TAGS_CONFIG = $FFFB0000 OR ID_CONFIG

OBJECT conentry
  section :PTR TO CHAR
  item    :PTR TO CHAR
  data    :PTR TO CHAR
ENDOBJECT

OBJECT config
  head[1]    :ARRAY OF head  /* Standard header */
  source     :LONG
  entries    :PTR TO conentry
  amtentries :LONG
ENDOBJECT

CONST CFA_Source     = TAPTR OR 12,
      CFA_Entries    = TAPTR OR 16,
      CFA_AmtEntries = TAPTR OR 20

