include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct CountryPrefs is
  cp_Reserved[4]:ulong;
  cp_CountryCode:ulong;
  cp_TelephoneCode:ulong;
  cp_MeasuringSystem:ubyte;
  cp_DateTimeFormat[80]:byte;
  cp_DateFormat[40]:byte;
  cp_TimeFormat[40]:byte;
  cp_ShortDateTimeFormat[80]:byte;
  cp_ShortDateFormat[40]:byte;
  cp_ShortTimeFormat[40]:byte;
  cp_DecimalPoint[10]:byte;
  cp_GroupSeparator[10]:byte;
  cp_FracGroupSeparator[10]:byte;
  cp_Grouping[10]:ubyte;
  cp_FracGrouping[10]:ubyte;
  cp_MonDecimalPoint[10]:byte;
  cp_MonGroupSeparator[10]:byte;
  cp_MonFracGroupSeparator[10]:byte;
  cp_MonGrouping[10]:ubyte;
  cp_MonFracGrouping[10]:ubyte;
  cp_MonFracDigits:ubyte;
  cp_MonIntFracDigits:ubyte;
  cp_MonCS[10]:byte;
  cp_MonSmallCS[10]:byte;
  cp_MonIntCS[10]:byte;
  cp_MonPositiveSign[10]:byte;
  cp_MonPositiveSpaceSep:ubyte;
  cp_MonPositiveSignPos:ubyte;
  cp_MonPositiveCSPos:ubyte;
  cp_MonNegativeSign[10]:byte;
  cp_MonNegativeSpaceSep:ubyte;
  cp_MonNegativeSignPos:ubyte;
  cp_MonNegativeCSPos:ubyte;
  cp_CalendarType:ubyte;
;

struct LocalePrefs is
  lp_Reserved[4]:ulong;
  lp_CountryName[32]:byte;
  lp_PreferredLanguages[10,30]:byte;
  lp_GMTOffset:long;
  lp_Flags:ulong;
  lp_CountryData:CountryPrefs;
;

