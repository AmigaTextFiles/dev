@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/locale.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT catalog
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   pad:INT
@{fg shine}(  16)@{fg text}   language:PTR TO CHAR
@{fg shine}(  20)@{fg text}   codeset:LONG
@{fg shine}(  24)@{fg text}   version:INT
@{fg shine}(  26)@{fg text}   revision:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

@{fg shine}(----)@{fg text} OBJECT locale
@{fg shine}(   0)@{fg text}   localename:PTR TO CHAR
@{fg shine}(   4)@{fg text}   languagename:PTR TO CHAR
@{fg shine}(   8)@{fg text}   preflanguages[10]:ARRAY OF LONG
@{fg shine}(  48)@{fg text}   flags:LONG
@{fg shine}(  52)@{fg text}   codeset:LONG
@{fg shine}(  56)@{fg text}   countrycode:LONG
@{fg shine}(  60)@{fg text}   telephonecode:LONG
@{fg shine}(  64)@{fg text}   gmtoffset:LONG
@{fg shine}(  68)@{fg text}   measuringsystem:CHAR
@{fg shine}(  69)@{fg text}   calendartype:CHAR
@{fg shine}(  70)@{fg text}   reserved0[2]:ARRAY OF CHAR
@{fg shine}(  72)@{fg text}   datetimeformat:PTR TO CHAR
@{fg shine}(  76)@{fg text}   dateformat:PTR TO CHAR
@{fg shine}(  80)@{fg text}   timeformat:PTR TO CHAR
@{fg shine}(  84)@{fg text}   shortdatetimeformat:PTR TO CHAR
@{fg shine}(  88)@{fg text}   shortdateformat:PTR TO CHAR
@{fg shine}(  92)@{fg text}   shorttimeformat:PTR TO CHAR
@{fg shine}(  96)@{fg text}   decimalpoint:PTR TO CHAR
@{fg shine}( 100)@{fg text}   groupseparator:PTR TO CHAR
@{fg shine}( 104)@{fg text}   fracgroupseparator:PTR TO CHAR
@{fg shine}( 108)@{fg text}   grouping:PTR TO CHAR
@{fg shine}( 112)@{fg text}   fracgrouping:PTR TO CHAR
@{fg shine}( 116)@{fg text}   mondecimalpoint:PTR TO CHAR
@{fg shine}( 120)@{fg text}   mongroupseparator:PTR TO CHAR
@{fg shine}( 124)@{fg text}   monfracgroupseparator:PTR TO CHAR
@{fg shine}( 128)@{fg text}   mongrouping:PTR TO CHAR
@{fg shine}( 132)@{fg text}   monfracgrouping:PTR TO CHAR
@{fg shine}( 136)@{fg text}   monfracdigits:CHAR
@{fg shine}( 137)@{fg text}   monintfracdigits:CHAR
@{fg shine}( 138)@{fg text}   reserved1[2]:ARRAY OF CHAR
@{fg shine}( 140)@{fg text}   moncs:PTR TO CHAR
@{fg shine}( 144)@{fg text}   monsmallcs:PTR TO CHAR
@{fg shine}( 148)@{fg text}   monintcs:PTR TO CHAR
@{fg shine}( 152)@{fg text}   monpositivesign:PTR TO CHAR
@{fg shine}( 156)@{fg text}   monpositivespacesep:CHAR
@{fg shine}( 157)@{fg text}   monpositivesignpos:CHAR
@{fg shine}( 158)@{fg text}   monpositivecspos:CHAR
@{fg shine}( 159)@{fg text}   reserved2:CHAR
@{fg shine}( 160)@{fg text}   monnegativesign:PTR TO CHAR
@{fg shine}( 164)@{fg text}   monnegativespacesep:CHAR
@{fg shine}( 165)@{fg text}   monnegativesignpos:CHAR
@{fg shine}( 166)@{fg text}   monnegativecspos:CHAR
@{fg shine}( 167)@{fg text}   reserved3:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=168 */

@{fg shine}(----)@{fg text} OBJECT localebase
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   syspatches:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

CONST ABMON_1=27,
      MON_1=15,
      ABMON_2=28,
      MON_2=16,
      CT_7MON=1,
      ABMON_3=29,
      MON_3=17,
      PM_STR=$2A,
      AM_STR=$29,
      NOSTR=$28,
      ABMON_4=30,
      MON_4=18,
      ABMON_5=31,
      MON_5=19,
      ABMON_6=$20,
      MON_6=20,
      ABMON_7=$21,
      MON_7=21,
      ABMON_8=$22,
      MON_8=22,
      ABMON_9=$23,
      MON_9=23,
      TODAYSTR=$30,
      YESTERDAYSTR=$2F,
      CSP_PRECEDES=0,
      CLOSEQUOTE=$2E,
      OPENQUOTE=$2D,
      SS_SPACE=1,
      SS_NOSPACE=0,
      MS_AMERICAN=1,
      OC_TAGBASE=$80090000,
      CSP_SUCCEEDS=1,
      TOMORROWSTR=$31,
      SP_SUCC_ALL=2,
      SP_PREC_ALL=1,
      CT_7FRI=5,
      OC_BUILTINCODESET=$80090002,
      CT_7SUN=0,
      SC_ASCII=0,
      MAXSTRMSG=$33,
      FUTURESTR=$32,
      CT_7TUE=2,
      ABDAY_1=8,
      DAY_1=1,
      ABDAY_2=9,
      DAY_2=2,
      ABDAY_3=10,
      DAY_3=3,
      ABDAY_4=11,
      DAY_4=4,
      OC_LANGUAGE=$80090004,
      OC_BUILTINLANGUAGE=$80090001,
      SP_PARENS=0,
      ABDAY_5=12,
      DAY_5=5,
      ABDAY_6=13,
      DAY_6=6,
      ABDAY_7=14,
      DAY_7=7,
      CT_7THU=4,
      MS_IMPERIAL=2,
      YESSTR=$27,
      SC_COLLATE1=1,
      SC_COLLATE2=2,
      MS_ISO=0,
      MS_BRITISH=3,
      CT_7SAT=6,
      OC_VERSION=$80090003,
      HARDHYPHEN=$2C,
      SOFTHYPHEN=$2B,
      ABMON_10=$24,
      MON_10=24,
      SP_SUCC_CURR=4,
      SP_PREC_CURR=3,
      ABMON_11=$25,
      MON_11=25,
      ABMON_12=$26,
      MON_12=26,
      CT_7WED=3
@endnode
