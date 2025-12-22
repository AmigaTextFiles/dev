/*
**  $VER: files.e V1.0
**
**  File definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register','gms/misc/time'

/****************************************************************************
** Module information.
*/

CONST FILE_MODVERSION  = 1,
      FILE_MODREVISION = 0

/****************************************************************************
** Mini structures for source and destination operations.
*/

OBJECT filename
  id   :INT       /* ID_FILENAME */
  name :LONG      /* Pointer to filename */
ENDOBJECT

/* Memory pointer structure */

OBJECT memptr
  id      :INT      /* ID_MEMPTR */
  address :LONG     /* Pointer to memory area */
  size    :LONG     /* Must supply a size unless you are a MemBlock */
ENDOBJECT

/****************************************************************************
** Seek positions.
*/

CONST POS_BEGINNING = 0,
      POS_CURRENT   = 1,
      POS_END       = 2

CONST POS_START = POS_BEGINNING

/****************************************************************************
** File Object.
*/

CONST VER_FILE  = 1,
      TAGS_FILE = $FFFB0000 OR ID_FILE

OBJECT file
  head[1]       :ARRAY OF head /* (-R) Standard header */
  bytepos       :LONG          /* (-R) Current position in file */
  flags         :LONG          /* (IR) File flags */
  source        :PTR TO head   /* (IR) Direct pointer to the original Source structure */
  prev          :PTR TO file   /* (-R) Previous file in chain */
  next          :PTR TO file   /* (-R) Next file in chain */
  dataprocessor :LONG          /* (--) Not available for program use */
ENDOBJECT

CONST FLA_FLAGS  = TLONG OR 16,
      FLA_SOURCE = TAPTR OR 20

/****************************************************************************
** Opening flags for Files and Directories.
*/

CONST FL_OLDFILE     = $00000000,
      FL_WRITE       = $00000001,
      FL_EXCLUSIVE   = $00000002,
      FL_DATAPROCESS = $00000004,
      FL_FIND        = $00000008,
      FL_NOUNPACK    = $00000010,
      FL_NOBUFFER    = $00000020,
      FL_NEWFILE     = $00000040,
      FL_ALPHASORT   = $00000080,
      FL_READ        = $00000100,
      FL_AUTOCREATE  = $00000200

CONST FL_NOPACK = FL_NOUNPACK

/****************************************************************************
** Permission flags for Files and Directories.
*/

CONST FPT_READ     = $00000001,
      FPT_WRITE    = $00000002,
      FPT_EXECUTE  = $00000004,
      FPT_DELETE   = $00000008,
      FPT_SCRIPT   = $00000010,
      FPT_HIDDEN   = $00000020,
      FPT_ARCHIVE  = $00000040,
      FPT_PASSWORD = $00000080

/****************************************************************************
** Directory Object.
*/

CONST VER_DIRECTORY  = 1,
      TAGS_DIRECTORY = $FFFB0000 OR ID_DIRECTORY

OBJECT directory
  head[1]   :ARRAY OF head     /* [00] Standard header */
  childdir  :PTR TO directory  /* [12] First directory in list (master only) */
  childfile :PTR TO file       /* [16] First file in list (master only) */
  source    :PTR TO filename   /* [20] Location and Name of this directory */
  flags     :LONG              /* [24] Opening Flags (see file flags) */
  next      :PTR TO directory  /* [28] Next directory in this list */
  prev      :PTR TO directory  /* [32] Previous directory in this list */
ENDOBJECT

CONST DIRA_Source = TAPTR OR 20,
      DIRA_Flags  = TLONG OR 24

