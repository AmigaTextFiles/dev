@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/mathresource.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT mathieeeresource
@{fg shine}(   0)@{fg text}   node:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   flags:INT
@{fg shine}(  16)@{fg text}   baseaddr:PTR TO INT
@{fg shine}(  20)@{fg text}   dblbasinit:LONG
@{fg shine}(  24)@{fg text}   dbltransinit:LONG
@{fg shine}(  28)@{fg text}   sglbasinit:LONG
@{fg shine}(  32)@{fg text}   sgltransinit:LONG
@{fg shine}(  36)@{fg text}   extbasinit:LONG
@{fg shine}(  40)@{fg text}   exttransinit:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

CONST MATHIEEERESOURCEF_EXTBAS=16,
      MATHIEEERESOURCEF_SGLBAS=4,
      MATHIEEERESOURCEF_DBLBAS=1,
      MATHIEEERESOURCEF_EXTTRANS=$20,
      MATHIEEERESOURCEF_SGLTRANS=8,
      MATHIEEERESOURCEF_DBLTRANS=2
@endnode
