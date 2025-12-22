 {      File format for locale preferences }


{$I "Include:Libraries/IffParse.i"}

const
 ID_LCLE = 1279478853;
 ID_CTRY = 1129599577;


Type
 CountryPrefs = Record
    cp_Reserved     : Array[0..3] of Integer;
    cp_CountryCode  : Integer;
    cp_TelephoneCode: Integer;
    cp_MeasuringSystem : Byte;

    cp_DateTimeFormat  : Array[0..79] of Char;
    cp_DateFormat      : Array[0..39] of Char;
    cp_TimeFormat      : Array[0..39] of Char;

    cp_ShortDateTimeFormat  : Array[0..79] of Char;
    cp_ShortDateFormat      : Array[0..39] of Char;
    cp_ShortTimeFormat      : Array[0..39] of Char;

    { for numeric values }
    cp_DecimalPoint,
    cp_GroupSeparator,
    cp_FracGroupSeparator   : Array[0..9] of Char;
    cp_Grouping,
    cp_FracGrouping         : Array[0..9] of Byte;

    { for monetary values }
    cp_MonDecimalPoint,
    cp_MonGroupSeparator,
    cp_MonFracGroupSeparator   : Array[0..9] of Char;
    cp_MonGrouping,
    cp_MonFracGrouping         : Array[0..9] of Byte;
    cp_MonFracDigits,
    cp_MonIntFracDigits        : Byte;

    { for currency symbols }
    cp_MonCS,
    cp_MonSmallCS,
    cp_MonIntCS                : Array[0..9] of Char;

    { for positive monetary values }
    cp_MonPositiveSign         : Array[0..9] of Char;
    cp_MonPositiveSpaceSep,
    cp_MonPositiveSignPos,
    cp_MonPositiveCSPos        : Byte;

    { for negative monetary values }
    cp_MonNegativeSign         : Array[0..9] of Char;
    cp_MonNegativeSpaceSep,
    cp_MonNegativeSignPos,
    cp_MonNegativeCSPos        : Byte;

    cp_CalendarType            : Byte;
 end;
 CountryPrefsPtr = ^CountyPrefs;

 LocalePrefs = Record
    lp_Reserved         : Array[0..3] of Integer;
    lp_CountryName      : Array[0..31] of Char;
    lp_PreferredLanguages : Array[0..9] of Array[0..29] of Char;
    lp_GMTOffset        : Integer;
    lp_Flags            : Integer;
    lp_CountryData      : CountryPrefs;
 end;
 LocalePrefsPtr = ^LocalePrefs;


