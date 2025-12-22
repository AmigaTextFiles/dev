@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/iffparse.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT clipboardhandle
@{fg shine}(   0)@{fg text}   iocr:ioclipreq @{fg shine}(or ARRAY OF ioclipreq)@{fg text}
@{fg shine}(  52)@{fg text}   cbport:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}(  86)@{fg text}   satisfyport:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=120 */

@{fg shine}(----)@{fg text} OBJECT collectionitem
@{fg shine}(   0)@{fg text}   next:PTR TO collectionitem
@{fg shine}(   4)@{fg text}   size:LONG
@{fg shine}(   8)@{fg text}   data:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT storedproperty
@{fg shine}(   0)@{fg text}   size:LONG
@{fg shine}(   4)@{fg text}   data:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT localcontextitem
@{fg shine}(   0)@{fg text}   mln:mln @{fg shine}(or ARRAY OF mln)@{fg text}
@{fg shine}(   8)@{fg text}   id:LONG
@{fg shine}(  12)@{fg text}   type:LONG
@{fg shine}(  16)@{fg text}   ident:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT contextnode
@{fg shine}(   0)@{fg text}   mln:mln @{fg shine}(or ARRAY OF mln)@{fg text}
@{fg shine}(   8)@{fg text}   id:LONG
@{fg shine}(  12)@{fg text}   type:LONG
@{fg shine}(  16)@{fg text}   size:LONG
@{fg shine}(  20)@{fg text}   scan:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT iffstreamcmd
@{fg shine}(   0)@{fg text}   command:LONG
@{fg shine}(   4)@{fg text}   buf:PTR TO CHAR
@{fg shine}(   8)@{fg text}   nbytes:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT iffhandle
@{fg shine}(   0)@{fg text}   stream:LONG
@{fg shine}(   4)@{fg text}   flags:LONG
@{fg shine}(   8)@{fg text}   depth:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST IFFLCI_EXITHANDLER=$65786864,
      IFFLCI_ENTRYHANDLER=$656E6864,
      IFFERR_NOSCOPE=-3,
      IFFSCC_WRITE=3,
      IFFCMD_WRITE=3,
      IFFERR_WRITE=-6,
      IFFF_WRITE=1,
      IFFF_RWBITS=1,
      IFFERR_NOMEM=-4,
      ID_CAT=$43415420,
      ID_NULL=$20202020,
      IFFERR_MANGLED=-8,
      IFFCMD_PURGELCI=7,
      IFFLCI_COLLECTION=$636F6C6C,
      IFFERR_EOC=-2,
      IFFERR_EOF=-1,
      IFFSLI_ROOT=1,
      IFFERR_SYNTAX=-9,
      IFFSCC_CLEANUP=1,
      IFFCMD_CLEANUP=1,
      ID_FORM=$464F524D,
      IFF_RETURN2CLIENT=-12,
      IFFSCC_SEEK=4,
      IFFCMD_SEEK=4,
      IFFERR_SEEK=-7,
      IFFF_RSEEK=4,
      IFFF_FSEEK=2,
      IFFSIZE_UNKNOWN=-1,
      ID_LIST=$4C495354,
      IFFSLI_PROP=3,
      IFFLCI_PROP=$70726F70,
      ID_PROP=$50524F50,
      IFFSLI_TOP=2,
      IFFF_RESERVED=$FFFF0000,
      IFFCMD_ENTRY=5,
      IFFCMD_EXIT=6,
      IFFPARSE_RAWSTEP=2,
      IFFPARSE_STEP=1,
      IFFSCC_READ=2,
      IFFCMD_READ=2,
      IFFERR_READ=-5,
      IFFF_READ=0,
      IFFPARSE_SCAN=0,
      IFFERR_NOTIFF=-10,
      IFFSCC_INIT=0,
      IFFCMD_INIT=0,
      IFFERR_NOHOOK=-11
@endnode
