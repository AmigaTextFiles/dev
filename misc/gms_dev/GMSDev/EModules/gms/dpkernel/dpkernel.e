/*
**  $VER: dpkernel.e V2.1
**
**  General include file for programs using the DPKernel.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/system/register'

CONST DPKVersion  = 2,
      DPKRevision = 1

CONST SKIPENTRY  = 0,
      ENDLIST    = -1,
      LISTEND    = -1,
      TAGEND     = 0

CONST TBYTE    = $00000000,
      TLONG    = $80000000,
      TWORD    = $40000000,
      TAPTR    = $C0000000,
      TSTEPIN  = $10000000,
      TSTEPOUT = $08000000,
      TTRIGGER = $04000000

CONST TAG_IGNORE = 1,
      TAG_MORE   = 2,
      TAG_SKIP   = 3

CONST GET_NOTRACK = $00010000,
      GET_PUBLIC  = $00020000,
      GET_SHARE   = $00060000

/***************************************************************************
** Header used for all objects.
*/

OBJECT head
  id      :INT
  version :INT
  class   :LONG ->PTR TO sysobject
  stats   :LONG ->PTR TO stats
ENDOBJECT

/****************************************************************************
** The Stats structure is private to the system, and is handled by Get()
*/

OBJECT stats
  empty       :LONG    /* */
  private     :LONG    /* Reserved pointer for use by child objects */
  flags       :LONG    /* General flags */
  exclusive   :LONG    /* Who owns the exclusive */
  lockcount   :INT     /* A running count of active locks */
  emp         :INT     /* */
  memflags    :LONG    /* Recommended memory allocation flags */
  container   :LONG
  resourcelist:LONG
  totaldata   :LONG
  totalvideo  :LONG
  totalsound  :LONG
  totalblit   :LONG
ENDOBJECT

CONST ST_SHARED      = $00000001,  /* The object is being openly shared */
      ST_EXCLUSIVE   = $00000002,  /* If the object is exclusive to a task */
      ST_PUBLIC      = $00000004,  /* If the object can be passed around */
      ST_NOTRACKING  = $00000008,  /* Do not track resources on this object */
      ST_INITIALISED = $00000010   /* This is set by Init() */

/****************************************************************************
** Raw Data object.
*/

CONST VER_RAWDATA  = 1,
      TAGS_RAWDATA = $FFFB0000 OR ID_RAWDATA

OBJECT rawdata
  head[1] :ARRAY OF head   /* Standard structure header */
  size    :LONG            /* Size of the data in bytes */
  data    :PTR TO CHAR     /* Pointer to the data */
ENDOBJECT

/****************************************************************************
** ItemList object.
*/

CONST VER_ITEMLIST  = 1,
      TAGS_ITEMLIST = $FFFB0000 OR ID_ITEMLIST

OBJECT itemlist
  head[1] :ARRAY OF head /* Standard header */
  array   :LONG          /* Pointer to the list's array, terminated with -1 */
  maxsize :LONG          /* Maximum amount of objects that this list can hold */
ENDOBJECT

/***************************************************************************
** Universal errorcodes returned by certain functions.
*/

ENUM  ERR_OK,          /* Function went OK */
      ERR_NOMEM,       /* Not enough memory available */
      ERR_NOPTR,       /* Required pointer not present */
      ERR_INUSE,       /* Previous allocations have not been freed */
      ERR_STRUCT,      /* Structure version not supported or not found */
      ERR_FAILED,      /* General failure */
      ERR_FILE,        /* File error, eg file not found */
      ERR_DATA,        /* There is an error in the given data */
      ERR_SEARCH,      /* A search routine failed to make a match */
      ERR_SCRTYPE,     /* Screen Type not recognised */
      ERR_MODULE,      /* Trouble with initialising/using a module */
      ERR_RASTCOMMAND, /* Invalid raster command detected */
      ERR_RASTERLIST,  /* Complete rasterlist failure */
      ERR_NORASTER,    /* Rasterlist missing from Screen->RasterList */
      ERR_DISKFULL,    /* Disk full error */
      ERR_FILEMISSING, /* File not found */
      ERR_WRONGVER,    /* Wrong version or version not supported */
      ERR_MONITOR,     /* Monitor driver not found or cannot be used */
      ERR_UNPACK,      /* Problem with unpacking of data */
      ERR_ARGS,        /* Invalid arguments passed to function */
      ERR_NODATA,      /* No data is available for use */
      ERR_READ,        /* Error reading data from file */
      ERR_WRITE,       /* Error writing data to file */
      ERR_LOCK,        /* Could not obtain lock on object */
      ERR_EXAMINE,     /* Could not examine directory or file */
      ERR_LOSTCLASS,   /* This object has lost its class reference */
      ERR_NOACTION,    /* This object does not support the required action */
      ERR_NOSUPPORT,   /* Object does not support the given data */
      ERR_MEMORY,      /* General memory error */
      ERR_TIMEOUT,     /* Function timed-out before successful completion */
      ERR_NOSTATS,     /* This object has lost its stats structure */
      ERR_GET,
      ERR_INIT,
      ERR_NOPERMISSION

CONST ERR_SUCCESS = 0  /* Synonym for ERR_OK */

/***************************************************************************
** Memory types used by AllocMemBlock().  This is generally identical to the
** exec definitions but CHIP is renamed to VIDEO (displayable memory) and
** there is an addition of BLIT and SOUND specific memory.
*/

CONST MEM_DATA      = $00000000,
      MEM_PUBLIC    = $00000001,
      MEM_VIDEO     = $00000002,
      MEM_BLIT      = $00000004,
      MEM_SOUND     = $00000008,
      MEM_AUDIO     = $00000008,
      MEM_CODE      = $00000010,
      MEM_PRIVATE   = $00000020,
      MEM_NOCLEAR   = $00000040,
      MEM_RESOURCED = $00000080,
      MEM_UNTRACKED = $80000000

