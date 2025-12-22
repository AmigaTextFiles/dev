@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/intuition.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT tablethookdata
@{fg shine}(   0)@{fg text}   screen:PTR TO screen
@{fg shine}(   4)@{fg text}   width:LONG
@{fg shine}(   8)@{fg text}   height:LONG
@{fg shine}(  12)@{fg text}   screenchanged:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT tabletdata
@{fg shine}(   0)@{fg text}   xfraction:INT
@{fg shine}(   2)@{fg text}   yfraction:INT
@{fg shine}(   4)@{fg text}   tabletx:LONG
@{fg shine}(   8)@{fg text}   tablety:LONG
@{fg shine}(  12)@{fg text}   rangex:LONG
@{fg shine}(  16)@{fg text}   rangey:LONG
@{fg shine}(  20)@{fg text}   taglist:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT easystruct
@{fg shine}(   0)@{fg text}   structsize:LONG
@{fg shine}(   4)@{fg text}   flags:LONG
@{fg shine}(   8)@{fg text}   title:PTR TO CHAR
@{fg shine}(  12)@{fg text}   textformat:PTR TO CHAR
@{fg shine}(  16)@{fg text}   gadgetformat:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT colorspec
@{fg shine}(   0)@{fg text}   colorindex:INT
@{fg shine}(   2)@{fg text}   red:INT
@{fg shine}(   4)@{fg text}   green:INT
@{fg shine}(   6)@{fg text}   blue:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT remember
@{fg shine}(   0)@{fg text}   nextremember:PTR TO remember
@{fg shine}(   4)@{fg text}   remembersize:LONG
@{fg shine}(   8)@{fg text}   memory:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT extnewwindow
@{fg shine}(   0)@{fg text}   leftedge:INT
@{fg shine}(   2)@{fg text}   topedge:INT
@{fg shine}(   4)@{fg text}   width:INT
@{fg shine}(   6)@{fg text}   height:INT
@{fg shine}(   8)@{fg text}   detailpen:CHAR
@{fg shine}(   9)@{fg text}   blockpen:CHAR
@{fg shine}(  10)@{fg text}   idcmpflags:LONG
@{fg shine}(  14)@{fg text}   flags:LONG
@{fg shine}(  18)@{fg text}   firstgadget:PTR TO gadget
@{fg shine}(  22)@{fg text}   checkmark:PTR TO image
@{fg shine}(  26)@{fg text}   title:PTR TO CHAR
@{fg shine}(  30)@{fg text}   screen:PTR TO screen
@{fg shine}(  34)@{fg text}   bitmap:PTR TO bitmap
@{fg shine}(  38)@{fg text}   minwidth:INT
@{fg shine}(  40)@{fg text}   minheight:INT
@{fg shine}(  42)@{fg text}   maxwidth:INT
@{fg shine}(  44)@{fg text}   maxheight:INT
@{fg shine}(  46)@{fg text}   type:INT
@{fg shine}(  48)@{fg text}   extension:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

@{fg shine}(----)@{fg text} OBJECT nw
@{fg shine}(   0)@{fg text}   leftedge:INT
@{fg shine}(   2)@{fg text}   topedge:INT
@{fg shine}(   4)@{fg text}   width:INT
@{fg shine}(   6)@{fg text}   height:INT
@{fg shine}(   8)@{fg text}   detailpen:CHAR
@{fg shine}(   9)@{fg text}   blockpen:CHAR
@{fg shine}(  10)@{fg text}   idcmpflags:LONG
@{fg shine}(  14)@{fg text}   flags:LONG
@{fg shine}(  18)@{fg text}   firstgadget:PTR TO gadget
@{fg shine}(  22)@{fg text}   checkmark:PTR TO image
@{fg shine}(  26)@{fg text}   title:PTR TO CHAR
@{fg shine}(  30)@{fg text}   screen:PTR TO screen
@{fg shine}(  34)@{fg text}   bitmap:PTR TO bitmap
@{fg shine}(  38)@{fg text}   minwidth:INT
@{fg shine}(  40)@{fg text}   minheight:INT
@{fg shine}(  42)@{fg text}   maxwidth:INT
@{fg shine}(  44)@{fg text}   maxheight:INT
@{fg shine}(  46)@{fg text}   type:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=48 */

@{fg shine}(----)@{fg text} OBJECT window
@{fg shine}(   0)@{fg text}   nextwindow:PTR TO window
@{fg shine}(   4)@{fg text}   leftedge:INT
@{fg shine}(   6)@{fg text}   topedge:INT
@{fg shine}(   8)@{fg text}   width:INT
@{fg shine}(  10)@{fg text}   height:INT
@{fg shine}(  12)@{fg text}   mousey:INT
@{fg shine}(  14)@{fg text}   mousex:INT
@{fg shine}(  16)@{fg text}   minwidth:INT
@{fg shine}(  18)@{fg text}   minheight:INT
@{fg shine}(  20)@{fg text}   maxwidth:INT
@{fg shine}(  22)@{fg text}   maxheight:INT
@{fg shine}(  24)@{fg text}   flags:LONG
@{fg shine}(  28)@{fg text}   menustrip:PTR TO menu
@{fg shine}(  32)@{fg text}   title:PTR TO CHAR
@{fg shine}(  36)@{fg text}   firstrequest:PTR TO requester
@{fg shine}(  40)@{fg text}   dmrequest:PTR TO requester
@{fg shine}(  44)@{fg text}   reqcount:INT
@{fg shine}(  46)@{fg text}   wscreen:PTR TO screen
@{fg shine}(  50)@{fg text}   rport:PTR TO rastport
@{fg shine}(  54)@{fg text}   borderleft:CHAR
@{fg shine}(  55)@{fg text}   bordertop:CHAR
@{fg shine}(  56)@{fg text}   borderright:CHAR
@{fg shine}(  57)@{fg text}   borderbottom:CHAR
@{fg shine}(  58)@{fg text}   borderrport:PTR TO rastport
@{fg shine}(  62)@{fg text}   firstgadget:PTR TO gadget
@{fg shine}(  66)@{fg text}   parent:PTR TO window
@{fg shine}(  70)@{fg text}   descendant:PTR TO window
@{fg shine}(  74)@{fg text}   pointer:PTR TO INT
@{fg shine}(  78)@{fg text}   ptrheight:CHAR
@{fg shine}(  79)@{fg text}   ptrwidth:CHAR
@{fg shine}(  80)@{fg text}   xoffset:CHAR
@{fg shine}(  81)@{fg text}   yoffset:CHAR
@{fg shine}(  82)@{fg text}   idcmpflags:LONG
@{fg shine}(  86)@{fg text}   userport:PTR TO mp
@{fg shine}(  90)@{fg text}   windowport:PTR TO mp
@{fg shine}(  94)@{fg text}   messagekey:PTR TO intuimessage
@{fg shine}(  98)@{fg text}   detailpen:CHAR
@{fg shine}(  99)@{fg text}   blockpen:CHAR
@{fg shine}( 100)@{fg text}   checkmark:PTR TO image
@{fg shine}( 104)@{fg text}   screentitle:PTR TO CHAR
@{fg shine}( 108)@{fg text}   gzzmousex:INT
@{fg shine}( 110)@{fg text}   gzzmousey:INT
@{fg shine}( 112)@{fg text}   gzzwidth:INT
@{fg shine}( 114)@{fg text}   gzzheight:INT
@{fg shine}( 116)@{fg text}   extdata:PTR TO CHAR
@{fg shine}( 120)@{fg text}   userdata:PTR TO CHAR
@{fg shine}( 124)@{fg text}   wlayer:PTR TO layer
@{fg shine}( 128)@{fg text}   ifont:PTR TO textfont
@{fg shine}( 132)@{fg text}   moreflags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=136 */

@{fg shine}(----)@{fg text} OBJECT ibox
@{fg shine}(   0)@{fg text}   left:INT
@{fg shine}(   2)@{fg text}   top:INT
@{fg shine}(   4)@{fg text}   width:INT
@{fg shine}(   6)@{fg text}   height:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT extintuimessage
@{fg shine}(   0)@{fg text}   intuimessage:intuimessage @{fg shine}(or ARRAY OF intuimessage)@{fg text}
@{fg shine}(  52)@{fg text}   tabletdata:PTR TO tabletdata
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

@{fg shine}(----)@{fg text} OBJECT intuimessage
@{fg shine}(   0)@{fg text}   execmessage:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   class:LONG
@{fg shine}(  24)@{fg text}   code:INT
@{fg shine}(  26)@{fg text}   qualifier:INT
@{fg shine}(  28)@{fg text}   iaddress:LONG
@{fg shine}(  32)@{fg text}   mousex:INT
@{fg shine}(  34)@{fg text}   mousey:INT
@{fg shine}(  36)@{fg text}   seconds:LONG
@{fg shine}(  40)@{fg text}   micros:LONG
@{fg shine}(  44)@{fg text}   idcmpwindow:PTR TO window
@{fg shine}(  48)@{fg text}   speciallink:PTR TO intuimessage
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

@{fg shine}(----)@{fg text} OBJECT image
@{fg shine}(   0)@{fg text}   leftedge:INT
@{fg shine}(   2)@{fg text}   topedge:INT
@{fg shine}(   4)@{fg text}   width:INT
@{fg shine}(   6)@{fg text}   height:INT
@{fg shine}(   8)@{fg text}   depth:INT
@{fg shine}(  10)@{fg text}   imagedata:PTR TO INT
@{fg shine}(  14)@{fg text}   planepick:CHAR
@{fg shine}(  15)@{fg text}   planeonoff:CHAR
@{fg shine}(  16)@{fg text}   nextimage:PTR TO image
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT border
@{fg shine}(   0)@{fg text}   leftedge:INT
@{fg shine}(   2)@{fg text}   topedge:INT
@{fg shine}(   4)@{fg text}   frontpen:CHAR
@{fg shine}(   5)@{fg text}   backpen:CHAR
@{fg shine}(   6)@{fg text}   drawmode:CHAR
@{fg shine}(   7)@{fg text}   count:CHAR
@{fg shine}(   8)@{fg text}   xy:PTR TO INT
@{fg shine}(  12)@{fg text}   nextborder:PTR TO border
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT intuitext
@{fg shine}(   0)@{fg text}   frontpen:CHAR
@{fg shine}(   1)@{fg text}   backpen:CHAR
@{fg shine}(   2)@{fg text}   drawmode:CHAR
@{fg shine}(   4)@{fg text}   leftedge:INT
@{fg shine}(   6)@{fg text}   topedge:INT
@{fg shine}(   8)@{fg text}   itextfont:PTR TO textattr
@{fg shine}(  12)@{fg text}   itext:PTR TO CHAR
@{fg shine}(  16)@{fg text}   nexttext:PTR TO intuitext
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT stringinfo
@{fg shine}(   0)@{fg text}   buffer:PTR TO CHAR
@{fg shine}(   4)@{fg text}   undobuffer:PTR TO CHAR
@{fg shine}(   8)@{fg text}   bufferpos:INT
@{fg shine}(  10)@{fg text}   maxchars:INT
@{fg shine}(  12)@{fg text}   disppos:INT
@{fg shine}(  14)@{fg text}   undopos:INT
@{fg shine}(  16)@{fg text}   numchars:INT
@{fg shine}(  18)@{fg text}   dispcount:INT
@{fg shine}(  20)@{fg text}   cleft:INT
@{fg shine}(  22)@{fg text}   ctop:INT
@{fg shine}(  24)@{fg text}   extension:PTR TO stringextend
@{fg shine}(  28)@{fg text}   longint:LONG
@{fg shine}(  32)@{fg text}   altkeymap:PTR TO keymap
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

@{fg shine}(----)@{fg text} OBJECT propinfo
@{fg shine}(   0)@{fg text}   flags:INT
@{fg shine}(   2)@{fg text}   horizpot:INT
@{fg shine}(   4)@{fg text}   vertpot:INT
@{fg shine}(   6)@{fg text}   horizbody:INT
@{fg shine}(   8)@{fg text}   vertbody:INT
@{fg shine}(  10)@{fg text}   cwidth:INT
@{fg shine}(  12)@{fg text}   cheight:INT
@{fg shine}(  14)@{fg text}   hpotres:INT
@{fg shine}(  16)@{fg text}   vpotres:INT
@{fg shine}(  18)@{fg text}   leftborder:INT
@{fg shine}(  20)@{fg text}   topborder:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=22 */

@{fg shine}(----)@{fg text} OBJECT boolinfo
@{fg shine}(   0)@{fg text}   flags:INT
@{fg shine}(   2)@{fg text}   mask:PTR TO INT
@{fg shine}(   6)@{fg text}   reserved:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=10 */

@{fg shine}(----)@{fg text} OBJECT extgadget
@{fg shine}(   0)@{fg text}   nextgadget:PTR TO extgadget
@{fg shine}(   4)@{fg text}   leftedge:INT
@{fg shine}(   6)@{fg text}   topedge:INT
@{fg shine}(   8)@{fg text}   width:INT
@{fg shine}(  10)@{fg text}   height:INT
@{fg shine}(  12)@{fg text}   flags:INT
@{fg shine}(  14)@{fg text}   activation:INT
@{fg shine}(  16)@{fg text}   gadgettype:INT
@{fg shine}(  18)@{fg text}   gadgetrender:LONG
@{fg shine}(  22)@{fg text}   selectrender:LONG
@{fg shine}(  26)@{fg text}   gadgettext:PTR TO intuitext
@{fg shine}(  30)@{fg text}   mutualexclude:LONG
@{fg shine}(  34)@{fg text}   specialinfo:LONG
@{fg shine}(  38)@{fg text}   gadgetid:INT
@{fg shine}(  40)@{fg text}   userdata:LONG
@{fg shine}(  44)@{fg text}   moreflags:LONG
@{fg shine}(  48)@{fg text}   boundsleftedge:INT
@{fg shine}(  50)@{fg text}   boundstopedge:INT
@{fg shine}(  52)@{fg text}   boundswidth:INT
@{fg shine}(  54)@{fg text}   boundsheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

@{fg shine}(----)@{fg text} OBJECT gadget
@{fg shine}(   0)@{fg text}   nextgadget:PTR TO gadget
@{fg shine}(   4)@{fg text}   leftedge:INT
@{fg shine}(   6)@{fg text}   topedge:INT
@{fg shine}(   8)@{fg text}   width:INT
@{fg shine}(  10)@{fg text}   height:INT
@{fg shine}(  12)@{fg text}   flags:INT
@{fg shine}(  14)@{fg text}   activation:INT
@{fg shine}(  16)@{fg text}   gadgettype:INT
@{fg shine}(  18)@{fg text}   gadgetrender:LONG
@{fg shine}(  22)@{fg text}   selectrender:LONG
@{fg shine}(  26)@{fg text}   gadgettext:PTR TO intuitext
@{fg shine}(  30)@{fg text}   mutualexclude:LONG
@{fg shine}(  34)@{fg text}   specialinfo:LONG
@{fg shine}(  38)@{fg text}   gadgetid:INT
@{fg shine}(  40)@{fg text}   userdata:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

@{fg shine}(----)@{fg text} OBJECT requester
@{fg shine}(   0)@{fg text}   olderrequest:PTR TO requester
@{fg shine}(   4)@{fg text}   leftedge:INT
@{fg shine}(   6)@{fg text}   topedge:INT
@{fg shine}(   8)@{fg text}   width:INT
@{fg shine}(  10)@{fg text}   height:INT
@{fg shine}(  12)@{fg text}   relleft:INT
@{fg shine}(  14)@{fg text}   reltop:INT
@{fg shine}(  16)@{fg text}   reqgadget:PTR TO gadget
@{fg shine}(  20)@{fg text}   reqborder:PTR TO border
@{fg shine}(  24)@{fg text}   reqtext:PTR TO intuitext
@{fg shine}(  28)@{fg text}   flags:INT
@{fg shine}(  30)@{fg text}   backfill:CHAR
@{fg shine}(  32)@{fg text}   reqlayer:PTR TO layer
@{fg shine}(  36)@{fg text}   reqpad1[32]:ARRAY OF CHAR
@{fg shine}(  68)@{fg text}   imagebmap:PTR TO bitmap
@{fg shine}(  72)@{fg text}   rwindow:PTR TO window
@{fg shine}(  76)@{fg text}   reqimage:PTR TO image
@{fg shine}(  80)@{fg text}   reqpad2[32]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=112 */

@{fg shine}(----)@{fg text} OBJECT menuitem
@{fg shine}(   0)@{fg text}   nextitem:PTR TO menuitem
@{fg shine}(   4)@{fg text}   leftedge:INT
@{fg shine}(   6)@{fg text}   topedge:INT
@{fg shine}(   8)@{fg text}   width:INT
@{fg shine}(  10)@{fg text}   height:INT
@{fg shine}(  12)@{fg text}   flags:INT
@{fg shine}(  14)@{fg text}   mutualexclude:LONG
@{fg shine}(  18)@{fg text}   itemfill:LONG
@{fg shine}(  22)@{fg text}   selectfill:LONG
@{fg shine}(  26)@{fg text}   command:CHAR
@{fg shine}(  28)@{fg text}   subitem:PTR TO menuitem
@{fg shine}(  32)@{fg text}   nextselect:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

@{fg shine}(----)@{fg text} OBJECT menu
@{fg shine}(   0)@{fg text}   nextmenu:PTR TO menu
@{fg shine}(   4)@{fg text}   leftedge:INT
@{fg shine}(   6)@{fg text}   topedge:INT
@{fg shine}(   8)@{fg text}   width:INT
@{fg shine}(  10)@{fg text}   height:INT
@{fg shine}(  12)@{fg text}   flags:INT
@{fg shine}(  14)@{fg text}   menuname:PTR TO CHAR
@{fg shine}(  18)@{fg text}   firstitem:PTR TO menuitem
@{fg shine}(  22)@{fg text}   jazzx:INT
@{fg shine}(  24)@{fg text}   jazzy:INT
@{fg shine}(  26)@{fg text}   beatx:INT
@{fg shine}(  28)@{fg text}   beaty:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=30 */

CONST IDCMP_MENUPICK=$100,
      AUTOITEXTFONT=0,
      WA_DETAILPEN=$80000068,
      ALERT_TYPE=$80000000,
      GTYP_GADGETTYPE=$FC00,
      GACT_ALTKEYMAP=$1000,
      WA_ACTIVATE=$80000089,
      WFLG_ACTIVATE=$1000,
      FREEHORIZ=2,
      NOSUB=31,
      IDCMP_DELTAMOVE=$100000,
      IDCMP_MOUSEMOVE=16,
      CURSORDOWN=$4D,
      MIDDLEDOWN=$6A,
      MENUDOWN=$69,
      SELECTDOWN=$68,
      IDCMP_GADGETDOWN=$20,
      OKCANCEL=2,
      MENUCANCEL=2,
      WA_AMIGAKEY=$80000094,
      IDCMP_VANILLAKEY=$200000,
      WFLG_WINDOWACTIVE=$2000,
      REQACTIVE=$2000,
      COMMSEQ=4,
      WA_HELPGROUP=$8000009B,
      GFLG_RELSPECIAL=$4000,
      KNOBHIT=$100,
      GTYP_GADGET0002=2,
      TABLETA_DUMMY=$8003A000,
      TABLETA_INPROXIMITY=$8003A008,
      WA_NEWLOOKMENUS=$80000093,
      WA_PUBSCREENFALLBACK=$8000007A,
      WFLG_NEWLOOKMENUS=$200000,
      IDCMP_MENUVERIFY=$2000,
      IDCMP_REQVERIFY=$800,
      IDCMP_SIZEVERIFY=1,
      GTYP_SDOWNBACK=$70,
      GTYP_WDOWNBACK=$60,
      GACT_RELVERIFY=1,
      MENUUP=$E9,
      WA_PUBSCREEN=$80000079,
      WA_CUSTOMSCREEN=$80000070,
      WFLG_ZOOMED=$10000000,
      TABLETA_BUTTONBITS=$8003A007,
      WFLG_REFRESHBITS=$C0,
      GFLG_GADGHIGHBITS=3,
      SIMPLEREQ=16,
      CHECKIT=1,
      WA_SMARTREFRESH=$8000008D,
      WA_SIMPLEREFRESH=$8000008C,
      WA_NOCAREREFRESH=$80000087,
      WFLG_WINDOWREFRESH=$1000000,
      WFLG_NOCAREREFRESH=$20000,
      WFLG_OTHER_REFRESH=$C0,
      WFLG_SIMPLE_REFRESH=$40,
      WFLG_SMART_REFRESH=0,
      GFLG_DISABLED=$100,
      DEFERREFRESH=$8000,
      ITEMENABLED=16,
      MENUENABLED=1,
      WA_TABLETMESSAGES=$8000009A,
      IDCMP_MOUSEBUTTONS=8,
      WA_CHECKMARK=$8000006D,
      WA_POINTERDELAY=$80000099,
      WFLG_MENUSTATE=$8000,
      IDCMP_IDCMPUPDATE=$800000,
      MENUNULL=$FFFF,
      KNOBHMIN=6,
      NOITEM=$3F,
      HIGHITEM=$2000,
      WFLG_NW_EXTENDED=$40000,
      GFLG_EXTENDED=$8000,
      MENUTOGGLED=$4000,
      IDCMP_NEWPREFS=$4000,
      WBENCHOPEN=1,
      MENUWAITING=3,
      TABLETA_RESOLUTIONX=$8003A009,
      TABLETA_RESOLUTIONY=$8003A00A,
      GACT_IMMEDIATE=2,
      AUTOTOPEDGE=3,
      AUTOLEFTEDGE=6,
      IG_LEFTEDGE=0,
      BOOLMASK=1,
      GTYP_SYSTYPEMASK=$F0,
      GTYP_GTYPEMASK=7,
      GFLG_LABELMASK=$3000,
      GD_LEFTEDGE=4,
      WA_DRAGBAR=$80000082,
      WFLG_DRAGBAR=2,
      WA_BACKDROP=$80000085,
      WFLG_BACKDROP=$100,
      IDCMP_DISKINSERTED=$8000,
      AUTOFRONTPEN=0,
      SUPER_UNUSED=$FCFC0000,
      GTYP_SUNUSED=$70,
      TABLETA_ANGLEX=$8003A003,
      TABLETA_ANGLEY=$8003A004,
      WA_REPORTMOUSE=$80000086,
      WFLG_REPORTMOUSE=$200,
      GACT_FOLLOWMOUSE=8,
      GFLG_LABELIMAGE=$2000,
      GFLG_GADGIMAGE=4,
      GFLG_GADGHIMAGE=2,
      USEREQIMAGE=$20,
      HIGHIMAGE=0,
      TABLETA_ANGLEZ=$8003A005,
      GTYP_SUPFRONT=$50,
      GTYP_WUPFRONT=$40,
      WA_GADGETS=$8000006C,
      GFLG_IMAGEDISABLE=$800,
      IDCMP_REQCLEAR=$1000,
      GACT_BORDERSNIFF=$8000,
      KNOBVMIN=4,
      GACT_STRINGEXTEND=$2000,
      GACT_BOOLEXTEND=$2000,
      GFLG_STRINGEXTEND=$400,
      AMIGAKEYS=$C0,
      WA_COLORS=$8000007C,
      WBENCHCLOSE=2,
      GTYP_CLOSE=$80,
      WA_CLOSEGADGET=$80000084,
      WA_DEPTHGADGET=$80000083,
      WA_SIZEGADGET=$80000081,
      WFLG_CLOSEGADGET=8,
      WFLG_DEPTHGADGET=4,
      WFLG_SIZEGADGET=1,
      GTYP_CUSTOMGADGET=5,
      GTYP_STRGADGET=4,
      GTYP_PROPGADGET=3,
      GTYP_BOOLGADGET=1,
      GTYP_REQGADGET=$1000,
      GTYP_GZZGADGET=$2000,
      GTYP_SCRGADGET=$4000,
      GTYP_SYSGADGET=$8000,
      GACT_ACTIVEGADGET=$4000,
      GACT_ENDGADGET=4,
      WA_GIMMEZEROZERO=$80000091,
      WFLG_GIMMEZEROZERO=$400,
      GFLG_LABELSTRING=$1000,
      AUTONEXTTEXT=0,
      GFLG_LABELITEXT=0,
      ITEMTEXT=2,
      WA_RMBTRAP=$8000008A,
      WFLG_RMBTRAP=$10000,
      WFLG_INREQUEST=$4000,
      SYSREQUEST=$4000,
      IDCMP_DISKREMOVED=$10000,
      GTYP_SDRAGGING=$30,
      GTYP_WDRAGGING=$20,
      WA_SCREENTITLE=$8000006F,
      WA_TITLE=$8000006E,
      IDCMP_RAWKEY=$400,
      MAXPOT=$FFFF,
      GACT_TOGGLESELECT=$100,
      WA_RPTQUEUE=$80000080,
      WA_MOUSEQUEUE=$8000007E,
      DEFAULTMOUSEQUEUE=5,
      GACT_LONGINT=$800,
      GFLG_GADGHBOX=1,
      HIGHBOX=$80,
      NOMENU=31,
      MENUHOT=1,
      AUTOBACKPEN=1,
      WA_BLOCKPEN=$80000069,
      GFLG_GADGHNONE=3,
      HIGHNONE=$C0,
      PREDRAWN=2,
      ISDRAWN=$1000,
      MIDRAWN=$100,
      WA_TOP=$80000065,
      KEYCODE_B=$35,
      GFLG_GADGHCOMP=0,
      HIGHCOMP=$40,
      AUTODRAWMODE=1,
      DEADEND_ALERT=$80000000,
      RECOVERY_ALERT=0,
      WA_ZOOM=$8000007D,
      WFLG_HASZOOM=$20000000,
      GTYP_WZOOM=$60,
      WA_SIZEBBOTTOM=$8000008F,
      WFLG_SIZEBBOTTOM=$20,
      GFLG_SELECTED=$80,
      GFLG_RELBOTTOM=8,
      CURSORRIGHT=$4E,
      AMIGARIGHT=$80,
      ALTRIGHT=$20,
      WA_BUSYPOINTER=$80000098,
      WA_POINTER=$80000097,
      WA_SIZEBRIGHT=$8000008E,
      WA_INNERHEIGHT=$80000077,
      WA_MAXHEIGHT=$80000075,
      WA_MINHEIGHT=$80000073,
      WA_HEIGHT=$80000067,
      WFLG_SIZEBRIGHT=16,
      GACT_STRINGRIGHT=$400,
      GACT_STRINGCENTER=$200,
      GFLG_RELHEIGHT=$40,
      GFLG_RELRIGHT=16,
      OKOK=1,
      KEYCODE_M=$37,
      KEYCODE_N=$36,
      GTYP_SIZING=16,
      POINTREL=1,
      KEYCODE_Q=16,
      IDCMP_REQSET=$80,
      KEYCODE_LESS=$38,
      WA_BORDERLESS=$80000088,
      WFLG_BORDERLESS=$800,
      PROPBORDERLESS=8,
      KEYCODE_V=$34,
      WA_OBSOLETE=$80000096,
      KEYCODE_X=$32,
      CURSORLEFT=$4F,
      AMIGALEFT=$40,
      ALTLEFT=16,
      WA_LEFT=$80000064,
      GMORE_SCROLLRASTER=4,
      GACT_STRINGLEFT=0,
      KEYCODE_Z=$31,
      WFLG_WINDOWTICKED=$4000000,
      CHECKED=$100,
      WFLG_VISITOR=$8000000,
      IDCMP_GADGETUP=$40,
      FREEVERT=4,
      IDCMP_LONELYMESSAGE=$80000000,
      IDCMP_WBENCHMESSAGE=$20000,
      NOISYREQ=4,
      WA_NOTIFYDEPTH=$80000095,
      CWCODE_DEPTH=1,
      GMORE_BOUNDS=1,
      GTYP_SDEPTH=$50,
      GTYP_WDEPTH=$40,
      MAXBODY=$FFFF,
      AUTOKNOB=1,
      TABLETA_TABLETZ=$8003A001,
      WA_HELPGROUPWINDOW=$8000009C,
      WA_WBENCHWINDOW=$8000008B,
      WFLG_WBENCHWINDOW=$2000000,
      IDCMP_CHANGEWINDOW=$2000000,
      IDCMP_INTUITICKS=$400000,
      IDCMP_INACTIVEWINDOW=$80000,
      IDCMP_ACTIVEWINDOW=$40000,
      IDCMP_CLOSEWINDOW=$200,
      IDCMP_REFRESHWINDOW=4,
      REQOFFWINDOW=$1000,
      OKABORT=4,
      GFLG_TABCYCLE=$200,
      MIDDLEUP=$EA,
      CURSORUP=$4C,
      MENUTOGGLE=8,
      TABLETA_PRESSURE=$8003A006,
      PROPNEWLOOK=16,
      LOWCOMMWIDTH=16,
      LOWCHECKWIDTH=13,
      COMMWIDTH=27,
      CHECKWIDTH=19,
      WA_INNERWIDTH=$80000076,
      WA_MAXWIDTH=$80000074,
      WA_MINWIDTH=$80000072,
      WA_WIDTH=$80000066,
      GFLG_RELWIDTH=$20,
      HC_GADGETHELP=1,
      WA_MENUHELP=$80000092,
      WA_AUTOADJUST=$80000090,
      WA_IDCMP=$8000006A,
      IDCMP_GADGETHELP=$4000000,
      IDCMP_MENUHELP=$1000000,
      GMORE_GADGETHELP=2,
      KEYCODE_GREATER=$39,
      GACT_BOTTOMBORDER=$80,
      GACT_TOPBORDER=$40,
      GACT_LEFTBORDER=$20,
      GACT_RIGHTBORDER=16,
      WA_BACKFILL=$8000007F,
      NOREQBACKFILL=$40,
      CWCODE_MOVESIZE=0,
      IDCMP_NEWSIZE=2,
      WA_SUPERBITMAP=$80000071,
      WFLG_SUPER_BITMAP=$80,
      TABLETA_RANGEZ=$8003A002,
      SELECTUP=$E8,
      WA_WINDOWNAME=$8000007B,
      WA_PUBSCREENNAME=$80000078,
      WA_FLAGS=$8000006B,
      HIGHFLAGS=$C0

#define FULLMENUNUM/3
#define MENUNUM/1
#define SHIFTSUB/1
#define SHIFTITEM/1
#define SHAKNUM/1
#define SHIFTMENU/1
#define ITEMNUM/1
#define SPARNUM/1
#define SSBNUM/1
#define SWBNUM/1
#define SRBNUM/1
#define SUBNUM/1
@endnode
