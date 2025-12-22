@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/sound.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT soundprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   displayqueue:INT
@{fg shine}(  18)@{fg text}   audioqueue:INT
@{fg shine}(  20)@{fg text}   audiotype:INT
@{fg shine}(  22)@{fg text}   audiovolume:INT
@{fg shine}(  24)@{fg text}   audioperiod:INT
@{fg shine}(  26)@{fg text}   audioduration:INT
@{fg shine}(  28)@{fg text}   audiofilename[256]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=284 */

CONST SPTYPE_BEEP=0,
      ID_SOND=$534F4E44,
      SPTYPE_SAMPLE=1
@endnode
