@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/input.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT inputprefs
@{fg shine}(   0)@{fg text}   keymap[16]:ARRAY OF CHAR
@{fg shine}(  16)@{fg text}   pointerticks:INT
@{fg shine}(  18)@{fg text}   doubleclick:timeval @{fg shine}(or ARRAY OF timeval)@{fg text}
@{fg shine}(  26)@{fg text}   keyrptdelay:timeval @{fg shine}(or ARRAY OF timeval)@{fg text}
@{fg shine}(  34)@{fg text}   keyrptspeed:timeval @{fg shine}(or ARRAY OF timeval)@{fg text}
@{fg shine}(  42)@{fg text}   mouseaccel:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

CONST ID_INPT=$494E5054
@endnode
