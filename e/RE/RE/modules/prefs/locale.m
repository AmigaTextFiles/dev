#ifndef PREFS_LOCALE_H
#define PREFS_LOCALE_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_LCLE MAKE_ID("L","C","L","E")
#define ID_CTRY MAKE_ID("C","T","R","Y")
OBJECT CountryPrefs

    Reserved[4]:LONG
    CountryCode:LONG
    TelephoneCode:LONG
    MeasuringSystem:UBYTE
    DateTimeFormat[80]:LONG
    DateFormat[40]:LONG
    TimeFormat[40]:LONG
    ShortDateTimeFormat[80]:LONG
    ShortDateFormat[40]:LONG
    ShortTimeFormat[40]:LONG
    
    DecimalPoint[10]:LONG
    GroupSeparator[10]:LONG
    FracGroupSeparator[10]:LONG
    Grouping[10]:UBYTE
    FracGrouping[10]:UBYTE
    
    MonDecimalPoint[10]:LONG
    MonGroupSeparator[10]:LONG
    MonFracGroupSeparator[10]:LONG
    MonGrouping[10]:UBYTE
    MonFracGrouping[10]:UBYTE
    MonFracDigits:UBYTE
    MonIntFracDigits:UBYTE
    
    MonCS[10]:LONG
    MonSmallCS[10]:LONG
    MonIntCS[10]:LONG
    
    MonPositiveSign[10]:LONG
    MonPositiveSpaceSep:UBYTE
    MonPositiveSignPos:UBYTE
    MonPositiveCSPos:UBYTE
    
    MonNegativeSign[10]:LONG
    MonNegativeSpaceSep:UBYTE
    MonNegativeSignPos:UBYTE
    MonNegativeCSPos:UBYTE
    CalendarType:UBYTE
ENDOBJECT

OBJECT LocalePrefs

    Reserved[4]:LONG
    CountryName[32]:LONG
    PreferredLanguages[10]:LONG0:LONG0:LONG    LONG:LONG		p_GMTOffset:LONG    LONG:LONG		p_Flags:LONG    truct:LONG  CountryData:LONG
ENDOBJECT


#endif 
