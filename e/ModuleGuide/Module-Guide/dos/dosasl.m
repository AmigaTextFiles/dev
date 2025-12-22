@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/dosasl.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT achain
@{fg shine}(   0)@{fg text}   child:PTR TO achain
@{fg shine}(   4)@{fg text}   parent:PTR TO achain
@{fg shine}(   8)@{fg text}   lock:LONG
@{fg shine}(  12)@{fg text}   info:fileinfoblock @{fg shine}(or ARRAY OF fileinfoblock)@{fg text}
@{fg shine}( 272)@{fg text}   flags:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=274 */

@{fg shine}(----)@{fg text} OBJECT anchorpath
@{fg shine}(   0)@{fg text}   base:PTR TO achain
@{fg shine}(   4)@{fg text}   last:PTR TO achain
@{fg shine}(   8)@{fg text}   breakbits:LONG
@{fg shine}(  12)@{fg text}   foundbreak:LONG
@{fg shine}(  16)@{fg text}   flags:CHAR
@{fg shine}(  17)@{fg text}   reserved:CHAR
@{fg shine}(  18)@{fg text}   strlen:INT
@{fg shine}(  20)@{fg text}   info:fileinfoblock @{fg shine}(or ARRAY OF fileinfoblock)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=280 */

CONST APF_DODIR=4,
      APB_DODIR=2,
      APF_DIDDIR=8,
      APB_DIDDIR=3,
      APF_NOMEMERR=16,
      APB_NOMEMERR=4,
      P_ORSTART=$82,
      DDF_PATTERNBIT=1,
      DDB_PATTERNBIT=0,
      P_SINGLE=$81,
      DDF_SINGLE=16,
      DDB_SINGLE=4,
      APF_DODOT=$20,
      APB_DODOT=5,
      P_STOP=$8B,
      APF_ITSWILD=2,
      APB_ITSWILD=1,
      APF_DOWILD=1,
      APB_DOWILD=0,
      DDF_ALLBIT=8,
      DDB_ALLBIT=3,
      ERROR_NOT_EXECUTABLE=$131,
      P_NOTEND=$86,
      ERROR_BUFFER_OVERFLOW=$12F,
      DDF_COMPLETED=4,
      DDB_COMPLETED=2,
      P_OREND=$84,
      P_ANY=$80,
      EXAMINE_BIT=2,
      COMPLEX_BIT=1,
      P_REPBEG=$89,
      DDF_EXAMINEDBIT=2,
      DDB_EXAMINEDBIT=1,
      P_REPEND=$8A,
      APF_FOLLOWHLINKS=$80,
      APB_FOLLOWHLINKS=7,
      ERROR_BREAK=$130,
      APF_DIRCHANGED=$40,
      APB_DIRCHANGED=6,
      P_CLASS=$88,
      P_NOTCLASS=$87,
      P_ORNEXT=$83,
      P_NOT=$85
@endnode
