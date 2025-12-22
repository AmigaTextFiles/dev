include "inc/exec/types.inc";
include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/exec/libraries.inc";
include "inc/utility/tagitem.inc";

def DAY_1 = 1;
def DAY_2 = 2;
def DAY_3 = 3;
def DAY_4 = 4;
def DAY_5 = 5;
def DAY_6 = 6;
def DAY_7 = 7;

def ABDAY_1 = 8;
def ABDAY_2 = 9;
def ABDAY_3 = 10;
def ABDAY_4 = 11;
def ABDAY_5 = 12;
def ABDAY_6 = 13;
def ABDAY_7 = 14;

def MON_1 = 15;
def MON_2 = 16;
def MON_3 = 17;
def MON_4 = 18;
def MON_5 = 19;
def MON_6 = 20;
def MON_7 = 21;
def MON_8 = 22;
def MON_9 = 23;
def MON_10 = 24;
def MON_11 = 25;
def MON_12 = 26;

def ABMON_1 = 27;
def ABMON_2 = 28;
def ABMON_3 = 29;
def ABMON_4 = 30;
def ABMON_5 = 31;
def ABMON_6 = 32;
def ABMON_7 = 33;
def ABMON_8 = 34;
def ABMON_9 = 35;
def ABMON_10 = 36;
def ABMON_11 = 37;
def ABMON_12 = 38;

def YESSTR = 39;
def NOSTR = 40;

def AM_STR = 41;
def PM_STR = 42;

def SOFTHYPHEN = 43;
def HARDHYPHEN = 44;

def OPENQUOTE = 45;
def CLOSEQUOTE = 46;

def YESTERDAYSTR = 47;
def TODAYSTR = 48;
def TOMORROWSTR = 49;
def FUTURESTR = 50;

def MAXSTRMSG = 51;

struct LocaleLibBase is
  lb_LibNode:Library;
  lb_SysPatches:word;
;

struct Locale is
  loc_LocaleName:ulong;
  loc_LanguageName:ulong;
  loc_PrefLanguages[10]:ulong;
  loc_Flags:ulong;
  loc_CodeSet:ulong;
  loc_CountryCode:ulong;
  loc_TelephoneCode:ulong;
  loc_GMTOffset:long;
  loc_MeasuringSystem:ubyte;
  loc_CalendarType:ubyte;
  loc_Reserved0[2]:ubyte;
  loc_DateTimeFormat:ulong;
  loc_DateFormat:ulong;
  loc_TimeFormat:ulong;
  loc_ShortDateTimeFormat:ulong;
  loc_ShortDateFormat:ulong;
  loc_ShortTimeFormat:ulong;
  loc_DecimalPoint:ulong;
  loc_GroupSeparator:ulong;
  loc_FracGroupSeparator:ulong;
  loc_Grouping:ulong;
  loc_FracGrouping:ulong;
  loc_MonDecimalPoint:ulong;
  loc_MonGroupSeparator:ulong;
  loc_MonFracGroupSeparator:ulong;
  loc_MonGrouping:ulong;
  loc_MonFracGrouping:ulong;
  loc_MonFracDigits:ubyte;
  loc_MonIntFracDigits:ubyte;
  loc_Reserved1[2]:ubyte;
  loc_MonCS:ulong;
  loc_MonSmallCS:ulong;
  loc_MonIntCS:ulong;
  loc_MonPositiveSign:ulong;
  loc_MonPositiveSpaceSep:ubyte;
  loc_MonPositiveSignPos:ubyte;
  loc_MonPositiveCSPos:ubyte;
  loc_Reserved2:ubyte;
  loc_MonNegativeSign:ulong;
  loc_MonNegativeSpaceSep:ubyte;
  loc_MonNegativeSignPos:ubyte;
  loc_MonNegativeCSPos:ubyte;
  loc_Reserved3:ubyte;
;

def MS_ISO = 0;
def MS_AMERICAN = 1;
def MS_IMPERIAL = 2;
def MS_BRITISH = 3;

def CT_7SUN = 0;
def CT_7MON = 1;
def CT_7TUE = 2;
def CT_7WED = 3;
def CT_7THU = 4;
def CT_7FRI = 5;
def CT_7SAT = 6;

def SS_NOSPACE = 0;
def SS_SPACE = 1;

def SP_PARENS = 0;
def SP_PREC_ALL = 1;
def SP_SUCC_ALL = 2;
def SP_PREC_CURR = 3;
def SP_SUCC_CURR = 4;

def CSP_PRECEDES = 0;
def CSP_SUCCEEDS = 1;

def OC_TagBase = (TAG_USER+$90000);

def OC_BuiltInLanguage = (OC_TagBase+1);
def OC_BuiltInCodeSet = (OC_TagBase+2);
def OC_Version = (OC_TagBase+3);
def OC_Language = (OC_TagBase+4);

def SC_ASCII = 0;
def SC_COLLATE1 = 1;
def SC_COLLATE2 = 2;

struct Catalog is
  cat_Link:Node;
  cat_Pad:uword;
  cat_Language:ulong;
  cat_CodeSet:ulong;
  cat_Version:uword;
  cat_Revision:uword;
;

