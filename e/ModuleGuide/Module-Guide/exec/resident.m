@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/resident.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT rt
@{fg shine}(   0)@{fg text}   matchword:INT
@{fg shine}(   2)@{fg text}   matchtag:PTR TO rt
@{fg shine}(   6)@{fg text}   endskip:LONG
@{fg shine}(  10)@{fg text}   flags:CHAR
@{fg shine}(  11)@{fg text}   version:CHAR
@{fg shine}(  12)@{fg text}   type:CHAR
@{fg shine}(  13)@{fg text}   pri:CHAR
@{fg shine}(  14)@{fg text}   name:PTR TO CHAR
@{fg shine}(  18)@{fg text}   idstring:PTR TO CHAR
@{fg shine}(  22)@{fg text}   init:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=26 */

CONST RTW_NEVER=0,
      RTW_COLDSTART=1,
      RTF_COLDSTART=1,
      RTF_SINGLETASK=2,
      RTF_AFTERDOS=4,
      RTC_MATCHWORD=$4AFC,
      RTF_AUTOINIT=$80
@endnode
