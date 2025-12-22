@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/conunit.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT conunit
@{fg shine}(   0)@{fg text}   mp:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}(  34)@{fg text}   window:PTR TO window
@{fg shine}(  38)@{fg text}   xcp:INT
@{fg shine}(  40)@{fg text}   ycp:INT
@{fg shine}(  42)@{fg text}   xmax:INT
@{fg shine}(  44)@{fg text}   ymax:INT
@{fg shine}(  46)@{fg text}   xrsize:INT
@{fg shine}(  48)@{fg text}   yrsize:INT
@{fg shine}(  50)@{fg text}   xrorigin:INT
@{fg shine}(  52)@{fg text}   yrorigin:INT
@{fg shine}(  54)@{fg text}   xrextant:INT
@{fg shine}(  56)@{fg text}   yrextant:INT
@{fg shine}(  58)@{fg text}   xminshrink:INT
@{fg shine}(  60)@{fg text}   yminshrink:INT
@{fg shine}(  62)@{fg text}   xccp:INT
@{fg shine}(  64)@{fg text}   yccp:INT
@{fg shine}(  66)@{fg text}   keymapstruct:keymap @{fg shine}(or ARRAY OF keymap)@{fg text}
@{fg shine}(  98)@{fg text}   tabstops[80]:ARRAY OF INT
@{fg shine}( 258)@{fg text}   mask:CHAR
@{fg shine}( 259)@{fg text}   fgpen:CHAR
@{fg shine}( 260)@{fg text}   bgpen:CHAR
@{fg shine}( 261)@{fg text}   aolpen:CHAR
@{fg shine}( 262)@{fg text}   drawmode:CHAR
@{fg shine}( 263)@{fg text}   obsolete1:CHAR
@{fg shine}( 264)@{fg text}   obsolete2:LONG
@{fg shine}( 268)@{fg text}   minterms[8]:ARRAY OF CHAR
@{fg shine}( 276)@{fg text}   font:PTR TO textfont
@{fg shine}( 280)@{fg text}   algostyle:CHAR
@{fg shine}( 281)@{fg text}   txflags:CHAR
@{fg shine}( 282)@{fg text}   txheight:INT
@{fg shine}( 284)@{fg text}   txwidth:INT
@{fg shine}( 286)@{fg text}   txbaseline:INT
@{fg shine}( 288)@{fg text}   txspacing:INT
@{fg shine}( 290)@{fg text}   modes[3]:ARRAY OF CHAR
@{fg shine}( 293)@{fg text}   rawevents[4]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=297 */

CONST CONU_STANDARD=0,
      PMB_ASM=21,
      CONU_CHARMAP=1,
      CONU_SNIPMAP=3,
      CONU_LIBRARY=-1,
      PMB_AWM=22,
      CONFLAG_DEFAULT=0,
      MAXTABS=$50,
      CONFLAG_NODRAW_ON_NEWSIZE=1
@endnode
