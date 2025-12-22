@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/iff.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

CONST IFFVERSION=22,
      IFFL_ERROR_BADTASK=-1,
      IFFL_ERROR_OPEN=16,
      IFFL_ERROR_READ=17,
      IFFL_ERROR_NOMEM=18,
      IFFL_ERROR_NOTIFF=19,
      IFFL_ERROR_WRITE=20,
      IFFL_ERROR_NOILBM=24,
      IFFL_ERROR_NOBMHD=25,
      IFFL_ERROR_NOBODY=26,
      IFFL_ERROR_BADCOMPRESSION=28,
      IFFL_ERROR_NOANHD=29,
      IFFL_ERROR_NODLTA=30,
      ID_FORM=$464F524D,
      ID_CAT=$43415420,
      ID_LIST=$4C495354,
      ID_PROP=$50524F50,
      ID_ANIM=$414E494D,
      ID_ANHD=$414E4844,
      ID_ANNO=$414E4E4F,
      ID_BMHD=$424D4844,
      ID_BODY=$424F4459,
      ID_CAMG=$43414D47,
      ID_CLUT=$434C5554,
      ID_CMAP=$434D4150,
      ID_CRNG=$43524E47,
      ID_CTBL=$4354424C,
      ID_DLTA=$444C5441,
      ID_ILBM=$494C424D,
      ID_SHAM=$5348414D,
      ID_8SVX=$38535658,
      ID_ATAK=$4154414B,
      ID_NAME=$4E414D45,
      ID_RLSE=$524C5345,
      ID_VHDR=$56484452,
      IFFL_MODE_READ=0,
      IFFL_MODE_WRITE=1,
      IFFL_COMPR_NONE=0,
      IFFL_COMPR_BYTERUN1=1,
      IFFL_COMPR_FIBDELTA=$101

@{fg shine}(----)@{fg text} OBJECT bmh
@{fg shine}(   0)@{fg text}   width:INT
@{fg shine}(   2)@{fg text}   height:INT
@{fg shine}(   4)@{fg text}   xpos:INT
@{fg shine}(   6)@{fg text}   ypos:INT
@{fg shine}(   8)@{fg text}   nplanes:CHAR
@{fg shine}(   9)@{fg text}   masking:CHAR
@{fg shine}(  10)@{fg text}   compression:CHAR
@{fg shine}(  11)@{fg text}   pad1:CHAR
@{fg shine}(  12)@{fg text}   transpcol:INT
@{fg shine}(  14)@{fg text}   xaspect:CHAR
@{fg shine}(  15)@{fg text}   yaspect:CHAR
@{fg shine}(  16)@{fg text}   pagewidth:INT
@{fg shine}(  18)@{fg text}   pageheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT anh
@{fg shine}(   0)@{fg text}   operation:CHAR
@{fg shine}(   1)@{fg text}   mask:CHAR
@{fg shine}(   2)@{fg text}   w:INT
@{fg shine}(   4)@{fg text}   h:INT
@{fg shine}(   6)@{fg text}   x:INT
@{fg shine}(   8)@{fg text}   y:INT
@{fg shine}(  10)@{fg text}   abstime:LONG
@{fg shine}(  14)@{fg text}   reltime:LONG
@{fg shine}(  18)@{fg text}   interleave:CHAR
@{fg shine}(  19)@{fg text}   pad0:CHAR
@{fg shine}(  20)@{fg text}   bits:LONG
@{fg shine}(  24)@{fg text}   pad:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=25 */
@endnode
