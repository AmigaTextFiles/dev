@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/sghooks.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT sgwork
@{fg shine}(   0)@{fg text}   gadget:PTR TO gadget
@{fg shine}(   4)@{fg text}   stringinfo:PTR TO stringinfo
@{fg shine}(   8)@{fg text}   workbuffer:PTR TO CHAR
@{fg shine}(  12)@{fg text}   prevbuffer:PTR TO CHAR
@{fg shine}(  16)@{fg text}   modes:LONG
@{fg shine}(  20)@{fg text}   ievent:PTR TO inputevent
@{fg shine}(  24)@{fg text}   code:INT
@{fg shine}(  26)@{fg text}   bufferpos:INT
@{fg shine}(  28)@{fg text}   numchars:INT
@{fg shine}(  30)@{fg text}   actions:LONG
@{fg shine}(  34)@{fg text}   longint:LONG
@{fg shine}(  38)@{fg text}   gadgetinfo:PTR TO gadgetinfo
@{fg shine}(  42)@{fg text}   editop:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

@{fg shine}(----)@{fg text} OBJECT stringextend
@{fg shine}(   0)@{fg text}   font:PTR TO textfont
@{fg shine}(   4)@{fg text}   pens[2]:ARRAY OF CHAR
@{fg shine}(   6)@{fg text}   activepens[2]:ARRAY OF CHAR
@{fg shine}(   8)@{fg text}   initialmodes:LONG
@{fg shine}(  12)@{fg text}   edithook:PTR TO hook
@{fg shine}(  16)@{fg text}   workbuffer:PTR TO CHAR
@{fg shine}(  20)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

CONST SGAF_PREVACTIVE=$40,
      SGAB_PREVACTIVE=6,
      SGA_PREVACTIVE=$40,
      SGAF_NEXTACTIVE=$20,
      SGAB_NEXTACTIVE=5,
      SGA_NEXTACTIVE=$20,
      EO_SPECIAL=13,
      SGAF_REDISPLAY=16,
      SGAB_REDISPLAY=4,
      SGA_REDISPLAY=16,
      SGAF_BEEP=4,
      SGAB_BEEP=2,
      SGA_BEEP=4,
      EO_BADFORMAT=9,
      SGH_KEY=1,
      EO_DELFORWARD=3,
      EO_DELBACKWARD=2,
      SGMF_FIXEDFIELD=2,
      SGMB_FIXEDFIELD=1,
      SGM_FIXEDFIELD=2,
      SGAF_END=2,
      SGAB_END=1,
      SGA_END=2,
      SGAF_USE=1,
      SGAB_USE=0,
      SGA_USE=1,
      EO_BIGCHANGE=10,
      SGH_CLICK=2,
      EO_CLEAR=12,
      EO_RESET=6,
      SGMF_REPLACE=1,
      SGMB_REPLACE=0,
      SGM_REPLACE=1,
      EO_MOVECURSOR=4,
      EO_ENTER=5,
      EO_NOOP=1,
      SGAF_REUSE=8,
      SGAB_REUSE=3,
      SGA_REUSE=8,
      EO_UNDO=11,
      SGMF_NOFILTER=4,
      SGMB_NOFILTER=2,
      SGM_NOFILTER=4,
      EO_INSERTCHAR=8,
      EO_REPLACECHAR=7,
      SGMF_EXITHELP=$80,
      SGMB_EXITHELP=7,
      SGM_EXITHELP=$80
@endnode
