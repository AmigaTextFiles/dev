@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/serial.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT serialprefs
@{fg shine}(   0)@{fg text}   reserved[3]:ARRAY OF LONG
@{fg shine}(  12)@{fg text}   unit0map:LONG
@{fg shine}(  16)@{fg text}   baudrate:LONG
@{fg shine}(  20)@{fg text}   inputbuffer:LONG
@{fg shine}(  24)@{fg text}   outputbuffer:LONG
@{fg shine}(  28)@{fg text}   inputhandshake:CHAR
@{fg shine}(  29)@{fg text}   outputhandshake:CHAR
@{fg shine}(  30)@{fg text}   parity:CHAR
@{fg shine}(  31)@{fg text}   bitsperchar:CHAR
@{fg shine}(  32)@{fg text}   stopbits:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

CONST PARITY_EVEN=1,
      PARITY_MARK=3,
      PARITY_SPACE=4,
      HSHAKE_XON=0,
      PARITY_ODD=2,
      ID_SERL=$5345524C,
      HSHAKE_NONE=2,
      PARITY_NONE=0,
      HSHAKE_RTS=1
@endnode
