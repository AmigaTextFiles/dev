@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/prtbase.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT printersegment
@{fg shine}(   0)@{fg text}   nextsegment:LONG
@{fg shine}(   4)@{fg text}   runalert:LONG
@{fg shine}(   8)@{fg text}   version:INT
@{fg shine}(  10)@{fg text}   revision:INT
@{fg shine}(  12)@{fg text}   ped:printerextendeddata @{fg shine}(or ARRAY OF printerextendeddata)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=78 */

@{fg shine}(----)@{fg text} OBJECT printerextendeddata
@{fg shine}(   0)@{fg text}   printername:PTR TO CHAR
@{fg shine}(   4)@{fg text}   init:LONG
@{fg shine}(   8)@{fg text}   expunge:LONG
@{fg shine}(  12)@{fg text}   open:LONG
@{fg shine}(  16)@{fg text}   close:LONG
@{fg shine}(  20)@{fg text}   printerclass:CHAR
@{fg shine}(  21)@{fg text}   colorclass:CHAR
@{fg shine}(  22)@{fg text}   maxcolumns:CHAR
@{fg shine}(  23)@{fg text}   numcharsets:CHAR
@{fg shine}(  24)@{fg text}   numrows:INT
@{fg shine}(  26)@{fg text}   maxxdots:LONG
@{fg shine}(  30)@{fg text}   maxydots:LONG
@{fg shine}(  34)@{fg text}   xdotsinch:INT
@{fg shine}(  36)@{fg text}   ydotsinch:INT
@{fg shine}(  38)@{fg text}   commands:PTR TO LONG
@{fg shine}(  42)@{fg text}   dospecial:LONG
@{fg shine}(  46)@{fg text}   render:LONG
@{fg shine}(  50)@{fg text}   timeoutsecs:LONG
@{fg shine}(  54)@{fg text}   x8bitchars:PTR TO LONG
@{fg shine}(  58)@{fg text}   printmode:LONG
@{fg shine}(  62)@{fg text}   convfunv:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=66 */

@{fg shine}(----)@{fg text} OBJECT printerdata
@{fg shine}(   0)@{fg text}   dd:devicedata @{fg shine}(or ARRAY OF devicedata)@{fg text}
@{fg shine}(  52)@{fg text}   unit:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}(  86)@{fg text}   printersegment:LONG
@{fg shine}(  90)@{fg text}   printertype:INT
@{fg shine}(  92)@{fg text}   segmentdata:PTR TO printersegment
@{fg shine}(  96)@{fg text}   printbuf:PTR TO CHAR
@{fg shine}( 100)@{fg text}   pwrite:LONG
@{fg shine}( 104)@{fg text}   pbothready:LONG
@{fg shine}( 108)@{fg text}   p0:ioextpar @{fg shine}(or ARRAY OF ioextpar)@{fg text}
@{fg shine}( 108)@{fg text}   s0:ioextser @{fg shine}(or ARRAY OF ioextser)@{fg text}
@{fg shine}( 190)@{fg text}   p1:ioextpar @{fg shine}(or ARRAY OF ioextpar)@{fg text}
@{fg shine}( 190)@{fg text}   s1:ioextser @{fg shine}(or ARRAY OF ioextser)@{fg text}
@{fg shine}( 272)@{fg text}   tior:timerequest @{fg shine}(or ARRAY OF timerequest)@{fg text}
@{fg shine}( 312)@{fg text}   iorport:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}( 346)@{fg text}   tc:tc @{fg shine}(or ARRAY OF tc)@{fg text}
@{fg shine}( 438)@{fg text}   oldstk[2048]:ARRAY OF CHAR
@{fg shine}(2486)@{fg text}   flags:CHAR
@{fg shine}(2487)@{fg text}   pad:CHAR
@{fg shine}(2488)@{fg text}   preferences:preferences @{fg shine}(or ARRAY OF preferences)@{fg text}
@{fg shine}(2720)@{fg text}   pwaitenabled:CHAR
@{fg shine}(2721)@{fg text}   pad1:CHAR
@{fg shine}(2722)@{fg text}   stk[4096]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=6818 */

@{fg shine}(----)@{fg text} OBJECT devicedata
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   segment:LONG
@{fg shine}(  38)@{fg text}   execbase:LONG
@{fg shine}(  42)@{fg text}   cmdvectors:LONG
@{fg shine}(  46)@{fg text}   cmdbytes:PTR TO CHAR
@{fg shine}(  50)@{fg text}   numcommands:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

CONST PCC_ADDITIVE=8,
      PCC_YMCB=4,
      IOF_DONE=$80,
      PPC_COLORALPHA=2,
      PPC_BWALPHA=0,
      P_PRIORITY=0,
      DEVICES_PRTBASE_I=1,
      PCC_BGR=10,
      PPCF_GFX=1,
      PPCB_GFX=0,
      PCC_YMC_BW=3,
      PCC_BW=1,
      PCC_YMC=2,
      PCC_MULTI_PASS=16,
      PCC_4COLOR=4,
      PPCF_COLOR=2,
      PPCB_COLOR=1,
      PCC_BGR_WB=11,
      PF_IOR0=1,
      PCC_BGRW=12,
      PF_IOR1=2,
      DUF_STOPPED=1,
      IOF_CURRENT=$20,
      PPC_COLORGFX=3,
      IOF_QUEUED=16,
      PPC_BWGFX=1,
      IOF_SERVICING=$40,
      PF_EXPUNGED=$80,
      P_SAFESIZE=$80,
      P_BUFSIZE=$100,
      P_STKSIZE=$1000,
      P_OLDSTKSIZE=$800,
      DU_FLAGS=9,
      PCC_WB=9
@endnode
