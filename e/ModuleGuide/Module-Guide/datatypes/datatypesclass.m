@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "datatypes/datatypesclass.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT dtwrite
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   filehandle:LONG
@{fg shine}(  12)@{fg text}   mode:LONG
@{fg shine}(  16)@{fg text}   attrlist:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT dtdraw
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   rport:PTR TO rastport
@{fg shine}(   8)@{fg text}   left:LONG
@{fg shine}(  12)@{fg text}   top:LONG
@{fg shine}(  16)@{fg text}   width:LONG
@{fg shine}(  20)@{fg text}   height:LONG
@{fg shine}(  24)@{fg text}   tophoriz:LONG
@{fg shine}(  28)@{fg text}   topvert:LONG
@{fg shine}(  32)@{fg text}   attrlist:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

@{fg shine}(----)@{fg text} OBJECT dtprint
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   iodrp:PTR TO iodrpreq
@{fg shine}(   8)@{fg text}   iopc:PTR TO ioprtcmdreq
@{fg shine}(   8)@{fg text}   ios:PTR TO iostd
@{fg shine}(  12)@{fg text}   attrlist:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT dttrigger
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   function:LONG
@{fg shine}(  12)@{fg text}   data:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT dtgoto
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   nodename:PTR TO CHAR
@{fg shine}(  12)@{fg text}   attrlist:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT dtframebox
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   contentsinfo:PTR TO frameinfo
@{fg shine}(  12)@{fg text}   frameinfo:PTR TO frameinfo
@{fg shine}(  16)@{fg text}   sizeframeinfo:LONG
@{fg shine}(  20)@{fg text}   frameflags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT dtselect
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(   8)@{fg text}   select:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT dtgeneral
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT frameinfo
@{fg shine}(   0)@{fg text}   propertyflags:LONG
@{fg shine}(   4)@{fg text}   resolution:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(   8)@{fg text}   redbits:CHAR
@{fg shine}(   9)@{fg text}   greenbits:CHAR
@{fg shine}(  10)@{fg text}   bluebits:CHAR
@{fg shine}(  12)@{fg text}   width:LONG
@{fg shine}(  16)@{fg text}   height:LONG
@{fg shine}(  20)@{fg text}   depth:LONG
@{fg shine}(  24)@{fg text}   screen:PTR TO screen
@{fg shine}(  28)@{fg text}   colormap:PTR TO colormap
@{fg shine}(  32)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

@{fg shine}(----)@{fg text} OBJECT dtmethod
@{fg shine}(   0)@{fg text}   label:PTR TO CHAR
@{fg shine}(   4)@{fg text}   command:PTR TO CHAR
@{fg shine}(   8)@{fg text}   method:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT dtspecialinfo
@{fg shine}(   0)@{fg text}   lock:ss @{fg shine}(or ARRAY OF ss)@{fg text}
@{fg shine}(  46)@{fg text}   flags:LONG
@{fg shine}(  50)@{fg text}   topvert:LONG
@{fg shine}(  54)@{fg text}   visvert:LONG
@{fg shine}(  58)@{fg text}   totvert:LONG
@{fg shine}(  62)@{fg text}   otopvert:LONG
@{fg shine}(  66)@{fg text}   vertunit:LONG
@{fg shine}(  70)@{fg text}   tophoriz:LONG
@{fg shine}(  74)@{fg text}   vishoriz:LONG
@{fg shine}(  78)@{fg text}   tothoriz:LONG
@{fg shine}(  82)@{fg text}   otophoriz:LONG
@{fg shine}(  86)@{fg text}   horizunit:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=90 */

CONST DTA_OBJECTID=$80001072,
      DTA_TEXTFONT=$80001017,
      DTA_DATATYPE=$80001067,
      DTA_SOURCETYPE=$80001065,
      DTA_NOMINALHORIZ=$8000107D,
      DTA_TOTALPHORIZ=$8000107B,
      DTA_TOTALHORIZ=$80001011,
      DTA_VISIBLEHORIZ=$80001010,
      DTA_TOPHORIZ=$8000100F,
      DTA_REPEAT=$80001026,
      STM_CONTENTS=3,
      DTA_RASTPORT=$80001193,
      DTM_GOTO=$630,
      DTA_TEXTATTR=$8000100A,
      DTM_WRITE=$650,
      STM_RETRACE=5,
      DTA_SPECIAL=$80001192,
      DTA_DUMMY=$80001000,
      STM_BROWSE_PREV=6,
      STM_PLAY=2,
      STM_PAUSE=1,
      DTM_COPY=$607,
      DTA_PRINTERSTATUS=$80001019,
      DTA_OBJAUTHOR=$8000106E,
      DTA_USERDATA=$80001073,
      DTA_DATA=$80001016,
      DTA_HORIZUNIT=$80001012,
      DTA_VERTUNIT=$8000100E,
      DTA_CONTROLPANEL=$80001024,
      DTA_SYNC=$8000101D,
      DTA_DESTROWS=$80001191,
      DTSIF_PRINTING=$20,
      DTA_IMMEDIATE=$80001025,
      DTA_METHODS=$80001018,
      DTA_TRIGGERMETHODS=$80001015,
      STM_FASTFORWARD=13,
      STM_ACTIVATE_FIELD=10,
      STM_PREV_FIELD=9,
      STM_NEXT_FIELD=8,
      STM_STOP=14,
      STM_RESUME=15,
      DTM_REMOVEDTOBJECT=$604,
      DTA_CONDUCTOR=$80001023,
      STM_INDEX=4,
      DTM_FRAMEBOX=$601,
      FIF_REMAPPABLE=4,
      FIF_SCROLLABLE=2,
      FIF_SCALABLE=1,
      DTA_OBJANNOTATION=$8000106F,
      DTST_RAM=1,
      DTWM_RAW=1,
      DTA_ERRORSTRING=$80001022,
      DTM_DISPOSEMEMBER=$611,
      DTM_NEWMEMBER=$610,
      DTA_ERRORNUMBER=$80001021,
      STM_REWIND=12,
      DTM_DRAW=$641,
      DTM_ABORTPRINT=$609,
      DTM_PRINT=$608,
      DTSIF_DRAGGING=4,
      DTA_TITLE=$80001014,
      DTA_SELECTDOMAIN=$80001079,
      DTA_DOMAIN=$80001068,
      FRAMEF_SPECIFY=1,
      DTM_SELECT=$605,
      DTSIF_DRAGSELECT=8,
      DTA_HANDLE=$80001066,
      DTSIF_LAYOUTPROC=$40,
      DTA_LAYOUTPROC=$8000101B,
      DTA_PRINTERPROC=$8000101A,
      DTM_RELEASEDRAWINFO=$642,
      DTM_OBTAINDRAWINFO=$640,
      DTA_DESTCOLS=$80001190,
      DTA_FRAMEINFO=$80001074,
      STM_COMMAND=11,
      DTM_TRIGGER=$631,
      DTA_TOP=$8000106A,
      DTA_BUSY=$8000101C,
      DTM_CLEARSELECTED=$606,
      DTA_RELBOTTOM=$80001076,
      DTSIF_HIGHLIGHT=16,
      DTA_RELHEIGHT=$80001078,
      DTA_RELRIGHT=$80001075,
      DTA_OBJCOPYRIGHT=$80001070,
      DTA_HEIGHT=$8000106C,
      DTA_LEFT=$80001069,
      DTWM_IFF=0,
      STM_LOCATE=16,
      DTA_NOMINALVERT=$8000107C,
      DTA_TOTALPVERT=$8000107A,
      DTA_TOTALVERT=$8000100D,
      DTA_VISIBLEVERT=$8000100C,
      DTA_TOPVERT=$8000100B,
      DTST_FILE=2,
      DTA_RELWIDTH=$80001077,
      DTA_WIDTH=$8000106B,
      DTA_OBJVERSION=$80001071,
      DTSIF_NEWSIZE=2,
      STM_BROWSE_NEXT=7,
      DTST_HOTLINK=4,
      DTA_GROUPID=$8000101F,
      DTM_ASYNCLAYOUT=$603,
      DTM_PROCLAYOUT=$602,
      DTSIF_LAYOUT=1,
      DTST_CLIPBOARD=3,
      DTA_AREXXPORTNAME=$80001194,
      DTA_OBJNAME=$8000106D,
      DTA_NAME=$80001064,
      DTA_BASENAME=$8000101E,
      DTA_NODENAME=$80001013,
      DTA_ERRORLEVEL=$80001020

#define DATATYPESCLASS/0
@endnode
