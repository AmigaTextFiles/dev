@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/icontrol.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT icontrolprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   timeout:INT
@{fg shine}(  18)@{fg text}   metadrag:INT
@{fg shine}(  20)@{fg text}   flags:LONG
@{fg shine}(  24)@{fg text}   wbtofront:CHAR
@{fg shine}(  25)@{fg text}   fronttoback:CHAR
@{fg shine}(  26)@{fg text}   reqtrue:CHAR
@{fg shine}(  27)@{fg text}   reqfalse:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

CONST ICF_COERCE_COLORS=1,
      ICB_COERCE_COLORS=0,
      ICF_COERCE_LACE=2,
      ICB_COERCE_LACE=1,
      ID_ICTL=$4943544C,
      ICF_MENUSNAP=8,
      ICB_MENUSNAP=3,
      ICF_STRGAD_FILTER=4,
      ICB_STRGAD_FILTER=2,
      ICF_MODEPROMOTE=16,
      ICB_MODEPROMOTE=4
@endnode
