
/*
**  $VER: objects.e
**
**  Object definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register','gms/files/segments'

/****************************************************************************
** Object entries.
*/

OBJECT objectentry      /* Entry stucture for GetObjectList() */
  name   :PTR TO CHAR   /* Pointer to the name, may be NULL */
  object :LONG          /* Object is returned here */
ENDOBJECT

/*****************************************************************************
** Object-File.
*/

CONST VER_OBJECTFILE  = 2,
      TAGS_OBJECTFILE = $FFFB0000 OR ID_OBJECTFILE

OBJECT objectfile
  head[1]  :ARRAY OF head
  source   :LONG
  config   :LONG
ENDOBJECT

CONST OBJA_Source = 12 OR TAPTR,
      OBJA_Config = 16 OR TAPTR

