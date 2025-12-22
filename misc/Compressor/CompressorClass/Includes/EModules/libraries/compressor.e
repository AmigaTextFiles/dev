/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: com_Defs.e                                          -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Definitions for the compressor.class                -- *
 * -- ----------------------------------------------------------------- -- *
 * -- History                                                           -- *
 * --                                                                   -- *
 * --   0.1 (13. August 1998) - Started with writing.                   -- *
 * --                                                                   -- *
 * -- ----------------------------------------------------------------- -- */

/* -- ----------------------------------------------------------------- -- *
 * --                              Options                              -- *
 * -- ----------------------------------------------------------------- -- */

OPT PREPROCESS       -> enable preprocessor
OPT MODULE           -> generate module
OPT EXPORT           -> export all


/* -- ----------------------------------------------------------------- -- *
 * --                              Modules                              -- *
 * -- ----------------------------------------------------------------- -- */

MODULE 'intuition/classusr'


/* -- ----------------------------------------------------------------- -- *
 * --                              Macros                               -- *
 * -- ----------------------------------------------------------------- -- */

#define PACKSIZE( origin ) origin + Shr( origin, 5 ) + Shl( XPK_MARGIN, 1 )
#define UNPACKSIZE( origin ) origin + XPK_MARGIN
#define MEMSIZE( mem ) Long( mem - 4 )


/* -- ----------------------------------------------------------------- -- *
 * --                             Constants                             -- *
 * -- ----------------------------------------------------------------- -- */

CONST METHODLENGTH   = 6,    -> length for the name of a compressor
      PASSWORDLENGTH = 80    -> length of the password

-> alle verfügbaren Attribute
CONST CCA_METHODINDEX      = $FFFF0000 + $0000,    -> ISG-U
      CCA_MODE             = $FFFF0000 + $0001,    -> ISG-U
      CCA_PASSWORD         = $FFFF0000 + $0002,    -> ISG-U
      CCA_PROGRESSHOOK     = $FFFF0000 + $0003,    -> ISG-U
      CCA_XPKPACKERINFO    = $FFFF0000 + $0004,    -> --G--
      CCA_XPKMODE          = $FFFF0000 + $0005,    -> --G--
      CCA_METHODLIST       = $FFFF0000 + $0006,    -> --G--
      CCA_PREFSCHUNK       = $FFFF0000 + $0007,    -> ISG-U
      CCA_METHOD           = $FFFF0000 + $0008,    -> ISG-U
      CCA_NUMPACKERS       = $FFFF0000 + $0009,    -> --G--
      CCA_HIDEPASSWORD     = $FFFF0000 + $000A,    -> ISG-U
      CCA_FLAGS            = $FFFF0000 + $000B,    -> ISG-U
      CCA_SCREEN           = $FFFF0000 + $000C,    -> I-G--
      CCA_SCREENLOCKED     = $FFFF0000 + $000D,    -> --G--
      CCA_TEXTATTR         = $FFFF0000 + $000E,    -> I-G--
      CCA_PUBSCREENNAME    = $FFFF0000 + $000F,    -> I----
      CCA_MEMPOOL          = $FFFF0000 + $0010,    -> ISG-U
      CCA_INTERNALPROGRESS = $FFFF0000 + $0011     -> ISG-U

-> alle verfügbaren Flags
SET CCF_HIDEPASSWORD,     -> Passwort im Interface nicht zeigen
    CCF_SCREENLOCKED,     -> Bildschirm ist gelockt
    CCF_INTERNALPROGRESS  -> internes Routine als Progress-Funktion wird genutzt

-> alle verfügbaren Methoden
CONST CCM_FILE2FILE     = $FFAA0000 + $0000,
      CCM_FILE2MEM      = $FFAA0000 + $0001,
      CCM_FILES2FILES   = $FFAA0000 + $0002,
      CCM_MEM2MEM       = $FFAA0000 + $0003,
      CCM_PREFSGUI      = $FFAA0000 + $0004,
      CCM_EXAMINE       = $FFAA0000 + $0005


CONST ID_CCCP = "CCCP"


/* -- ----------------------------------------------------------------- -- *
 * --                            Structures                             -- *
 * -- ----------------------------------------------------------------- -- */

OBJECT ccmFile2File OF msg             -> CCM_FILE2FILE
  com_Source      : PTR TO CHAR        -> path of the source-file
  com_Destination : PTR TO CHAR        -> path of the destination-file
  com_Compressing : LONG               -> 0 = decompressing else compressing
ENDOBJECT


OBJECT ccmFiles2Files OF msg        -> CCM_FILES2FILES
  com_Compressing  : LONG           -> 0 = decompressing else compressing
  com_Sources      : PTR TO LONG    -> a NIL-terminated list where each element contains a file-path
  com_Destinations : PTR TO LONG    -> NIL or a NIL-terminated list with the same length as the sourcelist
  com_Results      : PTR TO LONG    -> must exist and habe the same length like the sourcelist
  com_Suffix       : PTR TO CHAR    -> if the destination-list doesn't exist you can use your own suffix (default = ".xpk")
ENDOBJECT


OBJECT ccmFile2Mem OF msg           -> CCM_FILE2MEM
  com_Compressing : LONG            -> 0 = decompressing else compressing
  com_Source      : PTR TO CHAR     -> NIL or path of the sourcefile
  com_Memory      : LONG            -> memory area as destination
  com_Length      : LONG            -> length of the memory-area
  com_OutLen      : PTR TO LONG     -> the length of the compressed data will be stored here
ENDOBJECT


OBJECT ccmMem2Mem OF msg            -> CCM_MEM2MEM
  com_Compressing    : LONG         -> 0 = decompressing else compressing
  com_Source         : PTR TO CHAR  -> source memory
  com_Destination    : PTR TO CHAR  -> destination memory
  com_SourceLen      : LONG         -> length of source memory
  com_DestinationLen : LONG         -> length of destination memory
  com_OutLen         : LONG         -> length of the (de)compressed area
ENDOBJECT


OBJECT ccmExamine OF msg            -> CCM_EXAMINE
  com_Source         : PTR TO CHAR  -> sourcefile
  com_Memory         : LONG         -> sourcememory
  com_MemoryLen      : LONG         -> length of the sourcememory
  com_SizeAddr       : LONG         -> address to write the size to
ENDOBJECT

