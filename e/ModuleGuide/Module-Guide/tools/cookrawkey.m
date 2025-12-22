@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "tools/cookrawkey.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

/* this module contains 592 bytes of code! */

/* ... and 3 reloc entries */

PROC shutdownRawkeyCooker@{fg shine}()@{fg text}
PROC warmupRawkeyCooker@{fg shine}()@{fg text}
PROC cookRawkey@{fg shine}(idcmpCode,idcmpQualifier,iAddress)@{fg text}

DEF consoledevice
/* 2 private global variable@{fg shine}(s)@{fg text} in this module */

CONST ER_ASKKEYMAP=$4B4D4150,
      ER_CREATEPORT=$504F5254,
      ER_CREATEIO=$494F,
      ER_OPENDEVICE=$444556,
      ER_NONE=0
@endnode
