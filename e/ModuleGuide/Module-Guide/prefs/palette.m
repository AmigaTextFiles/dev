@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/palette.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT paletteprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   x4colorpens[32]:ARRAY OF INT
@{fg shine}(  80)@{fg text}   x8colorpens[32]:ARRAY OF INT
@{fg shine}( 144)@{fg text}   colors:colorspec @{fg shine}(or ARRAY OF colorspec)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=400 */

CONST ID_PALT=$50414C54
@endnode
