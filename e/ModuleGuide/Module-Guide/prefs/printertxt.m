@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/printertxt.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT printerunitprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   unitnum:LONG
@{fg shine}(  20)@{fg text}   opendeviceflags:LONG
@{fg shine}(  24)@{fg text}   devicename[32]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

@{fg shine}(----)@{fg text} OBJECT printertxtprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   driver[30]:ARRAY OF CHAR
@{fg shine}(  46)@{fg text}   port:CHAR
@{fg shine}(  48)@{fg text}   papertype:INT
@{fg shine}(  50)@{fg text}   papersize:INT
@{fg shine}(  52)@{fg text}   paperlength:INT
@{fg shine}(  54)@{fg text}   pitch:INT
@{fg shine}(  56)@{fg text}   spacing:INT
@{fg shine}(  58)@{fg text}   leftmargin:INT
@{fg shine}(  60)@{fg text}   rightmargin:INT
@{fg shine}(  62)@{fg text}   quality:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=64 */

CONST PP_FINE=2,
      PQ_LETTER=1,
      PS_US_LETTER=0,
      PT_SINGLE=1,
      ID_PUNT=$50554E54,
      PS_CUSTOM=4,
      PS_W_TRACTOR=3,
      PS_N_TRACTOR=2,
      PQ_DRAFT=0,
      PS_US_LEGAL=1,
      PS_EURO_A0=5,
      PS_EURO_A1=6,
      PS_EURO_A2=7,
      PS_EURO_A3=8,
      PS_EURO_A4=9,
      PP_ELITE=1,
      PS_EURO_A5=10,
      PS_EURO_A6=11,
      PS_EURO_A7=12,
      PS_EURO_A8=13,
      PP_SERIAL=1,
      PP_PARALLEL=0,
      PT_FANFOLD=0,
      PS_EIGHT_LPI=1,
      PS_SIX_LPI=0,
      PP_PICA=0,
      DEVICENAMESIZE=$20,
      DRIVERNAMESIZE=30,
      ID_PTXT=$50545854
@endnode
