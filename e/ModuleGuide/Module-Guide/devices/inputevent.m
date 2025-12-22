@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/inputevent.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT inputevent
@{fg shine}(   0)@{fg text}   nextevent:PTR TO inputevent
@{fg shine}(   4)@{fg text}   class:CHAR
@{fg shine}(   5)@{fg text}   subclass:CHAR
@{fg shine}(   6)@{fg text}   code:INT
@{fg shine}(   8)@{fg text}   qualifier:INT
@{fg shine}(  10)@{fg text}   eventaddress:LONG
@{fg shine}(  10)@{fg text}   x:INT
@{fg shine}(  10)@{fg text}   prev1downcode:CHAR
@{fg shine}(  11)@{fg text}   prev1downqual:CHAR
@{fg shine}(  12)@{fg text}   y:INT
@{fg shine}(  12)@{fg text}   prev2downcode:CHAR
@{fg shine}(  13)@{fg text}   prev2downqual:CHAR
@{fg shine}(  14)@{fg text}   timestamp:timeval @{fg shine}(or ARRAY OF timeval)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=22 */

@{fg shine}(----)@{fg text} OBJECT ienewtablet
@{fg shine}(   0)@{fg text}   callback:PTR TO hook
@{fg shine}(   4)@{fg text}   scaledx:INT
@{fg shine}(   6)@{fg text}   scaledy:INT
@{fg shine}(   8)@{fg text}   scaledxfraction:INT
@{fg shine}(  10)@{fg text}   scaledyfraction:INT
@{fg shine}(  12)@{fg text}   tabletx:LONG
@{fg shine}(  16)@{fg text}   tablety:LONG
@{fg shine}(  20)@{fg text}   rangex:LONG
@{fg shine}(  24)@{fg text}   rangey:LONG
@{fg shine}(  28)@{fg text}   taglist:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

@{fg shine}(----)@{fg text} OBJECT iepointertablet
@{fg shine}(   0)@{fg text}   rangex:INT
@{fg shine}(   2)@{fg text}   rangey:INT
@{fg shine}(   4)@{fg text}   valuex:INT
@{fg shine}(   6)@{fg text}   valuey:INT
@{fg shine}(   8)@{fg text}   pressure:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=10 */

@{fg shine}(----)@{fg text} OBJECT iepointerpixel
@{fg shine}(   0)@{fg text}   screen:PTR TO screen
@{fg shine}(   4)@{fg text}   positionx:INT
@{fg shine}(   6)@{fg text}   positiony:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST IEQUALIFIERB_REPEAT=9,
      IEQUALIFIER_REPEAT=$200,
      IECLASS_GADGETDOWN=7,
      IECLASS_NEWPOINTERPOS=19,
      IECLASS_POINTERPOS=4,
      IECODE_NEWACTIVE=1,
      IESUBCLASS_PIXEL=1,
      IEQUALIFIERB_LALT=4,
      IEQUALIFIER_LALT=16,
      IECODE_REFRESH=3,
      IECLASS_NULL=0,
      IEQUALIFIERB_CAPSLOCK=2,
      IEQUALIFIER_CAPSLOCK=4,
      IECLASS_NEWPREFS=14,
      IESUBCLASS_NEWTABLET=3,
      IESUBCLASS_TABLET=2,
      IEQUALIFIERB_CONTROL=3,
      IEQUALIFIER_CONTROL=8,
      IECLASS_EVENT=3,
      IECLASS_DISKINSERTED=16,
      IEQUALIFIERB_RELATIVEMOUSE=15,
      IEQUALIFIER_RELATIVEMOUSE=$8000,
      IECLASS_RAWMOUSE=2,
      IECLASS_TIMER=6,
      IECODE_REQCLEAR=0,
      IEQUALIFIERB_INTERRUPT=10,
      IEQUALIFIER_INTERRUPT=$400,
      IECLASS_DISKREMOVED=15,
      IECLASS_RAWKEY=1,
      IEQUALIFIERB_NUMERICPAD=8,
      IEQUALIFIER_NUMERICPAD=$100,
      IEQUALIFIERB_RSHIFT=1,
      IEQUALIFIERB_LSHIFT=0,
      IEQUALIFIER_RSHIFT=2,
      IEQUALIFIER_LSHIFT=1,
      IECLASS_MENULIST=10,
      IEQUALIFIERB_RALT=5,
      IEQUALIFIER_RALT=$20,
      IEQUALIFIERB_RCOMMAND=7,
      IEQUALIFIERB_LCOMMAND=6,
      IEQUALIFIER_RCOMMAND=$80,
      IEQUALIFIER_LCOMMAND=$40,
      IESUBCLASS_COMPATIBLE=0,
      IECODE_ASCII_DEL=$7F,
      IEQUALIFIERB_LEFTBUTTON=14,
      IEQUALIFIERB_RBUTTON=13,
      IEQUALIFIERB_MIDBUTTON=12,
      IEQUALIFIER_LEFTBUTTON=$4000,
      IEQUALIFIER_RBUTTON=$2000,
      IEQUALIFIER_MIDBUTTON=$1000,
      IECODE_NOBUTTON=$FF,
      IECODE_MBUTTON=$6A,
      IECODE_RBUTTON=$69,
      IECODE_LBUTTON=$68,
      IECODE_REQSET=1,
      IECLASS_REQUESTER=9,
      IEQUALIFIERB_MULTIBROADCAST=11,
      IEQUALIFIER_MULTIBROADCAST=$800,
      IECLASS_GADGETUP=8,
      IECLASS_CHANGEWINDOW=21,
      IECLASS_INACTIVEWINDOW=18,
      IECLASS_ACTIVEWINDOW=17,
      IECLASS_REFRESHWINDOW=13,
      IECLASS_SIZEWINDOW=12,
      IECLASS_CLOSEWINDOW=11,
      IECODE_LATIN1_FIRST=$A0,
      IECODE_C1_FIRST=$80,
      IECODE_ASCII_FIRST=$20,
      IECODE_C0_FIRST=0,
      IECODE_COMM_CODE_FIRST=$78,
      IECODE_KEY_CODE_FIRST=0,
      IECODE_LATIN1_LAST=$FF,
      IECODE_C1_LAST=$9F,
      IECODE_ASCII_LAST=$7E,
      IECODE_C0_LAST=31,
      IECODE_COMM_CODE_LAST=$7F,
      IECODE_KEY_CODE_LAST=$77,
      IECODEB_UP_PREFIX=7,
      IECODE_UP_PREFIX=$80,
      IECLASS_MAX=21,
      IECLASS_MENUHELP=20,
      IECODE_NEWSIZE=2
@endnode
