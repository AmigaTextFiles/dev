/*
**  $VER: modules.e V1.0
**
**  (C) Copyright 1996-1997 DreamWorld Productions.
**      All Rights Reserved.
**
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'
MODULE 'gms/files/files','gms/files/segments'

/*****************************************************************************
** Module Object.
*/

CONST VER_MODULE  = 1,
      TAGS_MODULE = $FFFB0000 OR ID_MODULE

OBJECT module
  head[1]      :ARRAY OF head    /* [00] Standard header */
  number       :INT              /* [12] Number of the associated module */
  modbase      :LONG             /* [14] Function jump table */
  segment      :PTR TO segment   /* [18] Segment pointer */
  tabletype    :INT              /* [22] */
  empty        :INT              /* [24] */
  functionlist :PTR TO function  /* [26] Size of the function table */
  version      :LONG             /* [30] Version of the module */
  revision     :LONG             /* [34] Revision of the module */
  table        :PTR TO modheader /* [38] Header */
  name         :LONG             /* [42] Name of the module */
ENDOBJECT

OBJECT function
  address :PTR TO LONG
  name    :PTR TO CHAR
ENDOBJECT

CONST MODA_NUMBER    = TWORD OR 12,
      MODA_TABLETYPE = TWORD OR 22,
      MODA_VERSION   = TLONG OR 30,
      MODA_REVISION  = TLONG OR 34,
      MODA_NAME      = TAPTR OR 42

/****************************************************************************/

OBJECT modentry
  next     :PTR TO modentry    /* Next module in list */
  prev     :PTR TO modentry    /* Previous module in list */
  segment  :PTR TO segment     /* Module segment */
  header   :PTR TO modheader   /* Pointer to module header */
  moduleid :INT                /* Module ID */
  empty    :INT                /* Reserved */
  name     :PTR TO CHAR        /* Name of the module */
ENDOBJECT

OBJECT lvofunction
  jump :INT
  code :LONG
ENDOBJECT

CONST JMP_DEFAULT = 1,
      JMP_AMIGAE  = 2

#define JMP_LIBRARY JMP_AMIGAE
#define JMP_LVO     JMP_DEFAULT

/*****************************************************************************
** Module file header.
*/

CONST MODULE_HEADER_V1 = $4D4F4401

OBJECT modheader
  version        :LONG
  init           :LONG
  close          :LONG  
  expunge        :LONG
  tabletype      :INT
  opencount      :INT
  author         :PTR TO CHAR
  funclist       :PTR TO LONG  /* Pointer to function list */
  cpunumber      :LONG         /* CPU that this module is compiled for */
  modversion     :LONG         /* Version of this module */
  modrevision    :LONG         /* Revision of this module */
  mindpkversion  :LONG         /* Minimum DPK version required */
  mindpkrevision :LONG         /* Minimum DPK revision required */
  open           :LONG
  modbase        :LONG         /* Generated function base for given CPU */
  copyright      :PTR TO CHAR
  date           :PTR TO CHAR
  name           :PTR TO CHAR
  dpktable       :INT
ENDOBJECT

CONST CPU_68000 = 1,
      CPU_68010 = 2,
      CPU_68020 = 3,
      CPU_68030 = 4,
      CPU_68040 = 5,
      CPU_68060 = 6

