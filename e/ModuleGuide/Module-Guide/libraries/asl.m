@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/asl.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT displaymode
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   dimensioninfo:dimensioninfo @{fg shine}(or ARRAY OF dimensioninfo)@{fg text}
@{fg shine}( 102)@{fg text}   propertyflags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=106 */

@{fg shine}(----)@{fg text} OBJECT screenmoderequester
@{fg shine}(   0)@{fg text}   displayid:LONG
@{fg shine}(   4)@{fg text}   displaywidth:LONG
@{fg shine}(   8)@{fg text}   displayheight:LONG
@{fg shine}(  12)@{fg text}   displaydepth:INT
@{fg shine}(  14)@{fg text}   overscantype:INT
@{fg shine}(  16)@{fg text}   autoscroll:INT
@{fg shine}(  18)@{fg text}   bitmapwidth:LONG
@{fg shine}(  22)@{fg text}   bitmapheight:LONG
@{fg shine}(  26)@{fg text}   leftedge:INT
@{fg shine}(  28)@{fg text}   topedge:INT
@{fg shine}(  30)@{fg text}   width:INT
@{fg shine}(  32)@{fg text}   height:INT
@{fg shine}(  34)@{fg text}   infoopened:INT
@{fg shine}(  36)@{fg text}   infoleftedge:INT
@{fg shine}(  38)@{fg text}   infotopedge:INT
@{fg shine}(  40)@{fg text}   infowidth:INT
@{fg shine}(  42)@{fg text}   infoheight:INT
@{fg shine}(  44)@{fg text}   userdata:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=48 */

@{fg shine}(----)@{fg text} OBJECT fontrequester
@{fg shine}(   0)@{fg text}   reserved0[8]:ARRAY OF CHAR
@{fg shine}(   8)@{fg text}   attr:textattr @{fg shine}(or ARRAY OF textattr)@{fg text}
@{fg shine}(  16)@{fg text}   frontpen:CHAR
@{fg shine}(  17)@{fg text}   backpen:CHAR
@{fg shine}(  18)@{fg text}   drawmode:CHAR
@{fg shine}(  19)@{fg text}   reserved1:CHAR
@{fg shine}(  20)@{fg text}   userdata:LONG
@{fg shine}(  24)@{fg text}   leftedge:INT
@{fg shine}(  26)@{fg text}   topedge:INT
@{fg shine}(  28)@{fg text}   width:INT
@{fg shine}(  30)@{fg text}   height:INT
@{fg shine}(  32)@{fg text}   tattr:ttextattr @{fg shine}(or ARRAY OF ttextattr)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

@{fg shine}(----)@{fg text} OBJECT filerequester
@{fg shine}(   0)@{fg text}   reserved0[4]:ARRAY OF CHAR
@{fg shine}(   4)@{fg text}   file:LONG
@{fg shine}(   8)@{fg text}   drawer:LONG
@{fg shine}(  12)@{fg text}   reserved1[10]:ARRAY OF CHAR
@{fg shine}(  22)@{fg text}   leftedge:INT
@{fg shine}(  24)@{fg text}   topedge:INT
@{fg shine}(  26)@{fg text}   width:INT
@{fg shine}(  28)@{fg text}   height:INT
@{fg shine}(  30)@{fg text}   reserved2[2]:ARRAY OF CHAR
@{fg shine}(  32)@{fg text}   numargs:LONG
@{fg shine}(  36)@{fg text}   arglist:PTR TO wbarg
@{fg shine}(  40)@{fg text}   userdata:LONG
@{fg shine}(  44)@{fg text}   reserved3[8]:ARRAY OF CHAR
@{fg shine}(  52)@{fg text}   pattern:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

CONST ASL_DIR=$80080009,
      RF_DIR=8,
      ASLSM_DOOVERSCANTYPE=$80080070,
      ASLSM_INITIALOVERSCANTYPE=$80080068,
      FOF_PRIVATE=$20,
      RFF_PATGAD=1,
      FILF_PATGAD=1,
      FILB_PATGAD=0,
      ASL_HAIL=$80080001,
      ASL_EXTFLAGS1=$80080016,
      ASLFR_FLAGS1=$80080014,
      ASLSM_TEXTATTR=$80080033,
      ASLFO_TEXTATTR=$80080033,
      ASLFR_FLAGS2=$80080016,
      ASLFR_TEXTATTR=$80080033,
      ASL_DUMMY=$80080000,
      FONF_STYLES=4,
      FONB_STYLES=2,
      FIL1F_NOFILES=1,
      FIL1B_NOFILES=0,
      ASL_FONTSTYLES=$8008000C,
      ASLSM_SCREEN=$80080028,
      ASLFO_SCREEN=$80080028,
      ASLFR_SCREEN=$80080028,
      ASLSM_DOAUTOSCROLL=$80080071,
      ASLSM_INITIALAUTOSCROLL=$80080069,
      RF_USERDATA=$28,
      ASLSM_USERDATA=$80080034,
      ASLFO_USERDATA=$80080034,
      ASLFR_USERDATA=$80080034,
      FRF_FILTERDRAWERS=2,
      FRB_FILTERDRAWERS=1,
      ASLFR_FILTERDRAWERS=$8008003F,
      ASLSM_INITIALDISPLAYID=$80080064,
      ASL_TOPEDGE=$80080004,
      ASL_LEFTEDGE=$80080003,
      RF_TOPEDGE=24,
      RF_LEFTEDGE=22,
      ASLSM_PROPERTYMASK=$80080073,
      ASLSM_INITIALINFOTOPEDGE=$8008006C,
      ASLSM_INITIALINFOLEFTEDGE=$8008006B,
      ASLSM_INITIALTOPEDGE=$80080004,
      ASLSM_INITIALLEFTEDGE=$80080003,
      ASLFO_INITIALTOPEDGE=$80080004,
      ASLFO_INITIALLEFTEDGE=$80080003,
      ASLFR_INITIALTOPEDGE=$80080004,
      ASLFR_INITIALLEFTEDGE=$80080003,
      ASL_FRONTPEN=$8008000E,
      FOF_DOFRONTPEN=1,
      FOB_DOFRONTPEN=0,
      ASLFO_MAXFRONTPEN=$80080042,
      ASLFO_DOFRONTPEN=$8008002C,
      ASLFO_INITIALFRONTPEN=$8008000E,
      ASL_CANCELTEXT=$80080013,
      ASL_OKTEXT=$80080012,
      ASLSM_NEGATIVETEXT=$80080013,
      ASLSM_POSITIVETEXT=$80080012,
      ASLSM_TITLETEXT=$80080001,
      ASLFO_NEGATIVETEXT=$80080013,
      ASLFO_POSITIVETEXT=$80080012,
      ASLFO_TITLETEXT=$80080001,
      ASLFR_NEGATIVETEXT=$80080013,
      ASLFR_POSITIVETEXT=$80080012,
      ASLFR_TITLETEXT=$80080001,
      ASL_SCREENMODEREQUEST=2,
      ASL_FONTREQUEST=1,
      ASL_FILEREQUEST=0,
      FOF_DOFONTSTYLE=4,
      FOB_DOFONTSTYLE=2,
      ASLFO_DOSTYLE=$8008002E,
      ASLFO_INITIALSTYLE=$8008000C,
      RFF_MULTISELECT=8,
      FILF_MULTISELECT=8,
      FILB_MULTISELECT=3,
      FRF_DOMULTISELECT=8,
      FRB_DOMULTISELECT=3,
      ASLFR_DOMULTISELECT=$8008002D,
      FONF_BACKCOLOR=2,
      FONF_FRONTCOLOR=1,
      FONB_BACKCOLOR=1,
      FONB_FRONTCOLOR=0,
      RFF_DOCOLOR=$20,
      ASLFR_INITIALDRAWER=$80080009,
      ASL_BACKPEN=$8008000F,
      FOF_DOBACKPEN=2,
      FOB_DOBACKPEN=1,
      ASLFO_MAXBACKPEN=$80080043,
      ASLFO_DOBACKPEN=$8008002D,
      ASLFO_INITIALBACKPEN=$8008000F,
      ASL_MODELIST=$80080015,
      RF_ARGLIST=$24,
      ASLSM_CUSTOMSMLIST=$8008007B,
      ASLFO_MODELIST=$80080015,
      FONF_DOWILDFUNC=$80,
      FONF_DOMSGFUNC=$40,
      FONB_DOWILDFUNC=7,
      FONB_DOMSGFUNC=6,
      RFF_DOMSGFUNC=$40,
      RFF_DOWILDFUNC=$80,
      FILF_DOWILDFUNC=$80,
      FILF_DOMSGFUNC=$40,
      FILB_DOWILDFUNC=7,
      FILB_DOMSGFUNC=6,
      ASL_HOOKFUNC=$80080007,
      ASLSM_FILTERFUNC=$8008007A,
      ASLSM_INTUIMSGFUNC=$80080046,
      FOF_FILTERFUNC=$80,
      FOF_DOWILDFUNC=$80,
      FOF_INTUIFUNC=$40,
      FOF_DOMSGFUNC=$40,
      FOB_FILTERFUNC=7,
      FOB_INTUIFUNC=6,
      ASLFO_HOOKFUNC=$80080007,
      ASLFO_FILTERFUNC=$80080031,
      ASLFO_INTUIMSGFUNC=$80080046,
      FRF_INTUIFUNC=$40,
      FRB_INTUIFUNC=6,
      FRF_DOMSGFUNC=$40,
      FRF_FILTERFUNC=$80,
      FRB_FILTERFUNC=7,
      FRF_DOWILDFUNC=$80,
      ASLFR_HOOKFUNC=$80080007,
      ASLFR_FILTERFUNC=$80080031,
      ASLFR_INTUIMSGFUNC=$80080046,
      FRF_DOPATTERNS=1,
      FRB_DOPATTERNS=0,
      ASLFR_DOPATTERNS=$8008002E,
      RF_NUMARGS=$20,
      FONF_DRAWMODE=8,
      FONB_DRAWMODE=3,
      FOF_DODRAWMODE=8,
      FOB_DODRAWMODE=3,
      ASLFO_DODRAWMODE=$8008002F,
      ASLFO_INITIALDRAWMODE=$8008003B,
      FRF_DOSAVEMODE=$20,
      FRB_DOSAVEMODE=5,
      ASLFR_DOSAVEMODE=$8008002C,
      ASL_MAXHEIGHT=$80080011,
      ASL_MINHEIGHT=$80080010,
      ASL_FONTHEIGHT=$8008000B,
      ASL_HEIGHT=$80080006,
      RF_HEIGHT=28,
      ASLSM_MAXHEIGHT=$80080077,
      ASLSM_MINHEIGHT=$80080076,
      ASLSM_DOHEIGHT=$8008006E,
      ASLSM_INITIALDISPLAYHEIGHT=$80080066,
      ASLSM_INITIALHEIGHT=$80080006,
      ASLFO_MAXHEIGHT=$80080011,
      ASLFO_MINHEIGHT=$80080010,
      ASLFO_INITIALHEIGHT=$80080006,
      ASLFR_INITIALHEIGHT=$80080006,
      FRF_REJECTICONS=4,
      FRB_REJECTICONS=2,
      ASLFR_REJECTICONS=$8008003C,
      FOF_FIXEDWIDTHONLY=16,
      FOB_FIXEDWIDTHONLY=4,
      ASLFO_FIXEDWIDTHONLY=$80080030,
      FRF_DRAWERSONLY=1,
      FRB_DRAWERSONLY=0,
      ASLFR_DRAWERSONLY=$8008002F,
      ASLFO_BACKPENS=$80080041,
      ASLFO_FRONTPENS=$80080040,
      FIL1F_MATCHDIRS=2,
      FIL1B_MATCHDIRS=1,
      ASLSM_MAXDEPTH=$80080079,
      ASLSM_MINDEPTH=$80080078,
      ASLSM_DODEPTH=$8008006F,
      ASLSM_INITIALDISPLAYDEPTH=$80080067,
      ASLSM_INITIALINFOOPENED=$8008006A,
      ASL_WINDOW=$80080002,
      ASLSM_SLEEPWINDOW=$8008002B,
      ASLSM_WINDOW=$80080002,
      ASLFO_SLEEPWINDOW=$8008002B,
      ASLFO_WINDOW=$80080002,
      ASLFR_SLEEPWINDOW=$8008002B,
      ASLFR_WINDOW=$80080002,
      ASL_TB=$80080000,
      ASL_FILE=$80080008,
      RF_FILE=4,
      ASLFR_INITIALFILE=$80080008,
      FONF_FIXEDWIDTH=16,
      FONB_FIXEDWIDTH=4,
      ASL_WIDTH=$80080005,
      RF_WIDTH=26,
      ASLSM_MAXWIDTH=$80080075,
      ASLSM_MINWIDTH=$80080074,
      ASLSM_DOWIDTH=$8008006D,
      ASLSM_INITIALDISPLAYWIDTH=$80080065,
      ASLSM_INITIALWIDTH=$80080005,
      ASLFO_INITIALWIDTH=$80080005,
      ASLFR_INITIALWIDTH=$80080005,
      FONF_NEWIDCMP=$20,
      FONB_NEWIDCMP=5,
      RFF_NEWIDCMP=16,
      FILF_NEWIDCMP=16,
      FILB_NEWIDCMP=4,
      ASLSM_PRIVATEIDCMP=$8008002A,
      FOF_PRIVATEIDCMP=$20,
      FOB_PRIVATEIDCMP=5,
      ASLFO_PRIVATEIDCMP=$8008002A,
      FRF_PRIVATEIDCMP=16,
      FRB_PRIVATEIDCMP=4,
      ASLFR_PRIVATEIDCMP=$8008002A,
      FILF_SAVE=$20,
      FILB_SAVE=5,
      ASL_PATTERN=$8008000A,
      ASLFR_ACCEPTPATTERN=$8008003E,
      ASLFR_REJECTPATTERN=$8008003D,
      ASLFR_INITIALPATTERN=$8008000A,
      ASLFO_INITIALSIZE=$8008000B,
      RF_PAT=$34,
      ASLSM_LOCALE=$80080032,
      ASLFO_LOCALE=$80080032,
      ASLFR_LOCALE=$80080032,
      ASL_FUNCFLAGS=$80080014,
      ASL_FONTFLAGS=$8008000D,
      ASL_FONTNAME=$8008000A,
      ASLSM_PROPERTYFLAGS=$80080072,
      ASLSM_PUBSCREENNAME=$80080029,
      ASLFO_FLAGS=$80080014,
      ASLFO_INITIALFLAGS=$8008000D,
      ASLFO_INITIALNAME=$8008000A,
      ASLFO_PUBSCREENNAME=$80080029,
      ASLFR_PUBSCREENNAME=$80080029

#define ASLNAME/0
@endnode
