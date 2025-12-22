MODULE	'libraries/iffparse'

CONST ID_LCLE=$4C434C45,
  ID_CTRY=$43545259

OBJECT CountryPrefs
	Reserved[4]:ULONG,
	CountryCode:ULONG,
	TelephoneCode:ULONG,
	MeasuringSystem:UBYTE,
	DateTimeFormat[80]:UBYTE,
	DateFormat[40]:UBYTE,
	TimeFormat[40]:UBYTE,
	ShortDateTimeFormat[80]:UBYTE,
	ShortDateFormat[40]:UBYTE,
	ShortTimeFormat[40]:UBYTE,
	DecimalPoint[10]:UBYTE,
	GroupSeparator[10]:UBYTE,
	FracGroupSeparator[10]:UBYTE,
	Grouping[10]:UBYTE,
	FracGrouping[10]:UBYTE,
	MonDecimalPoint[10]:UBYTE,
	MonGroupSeparator[10]:UBYTE,
	MonFracGroupSeparator[10]:UBYTE,
	MonGrouping[10]:UBYTE,
	MonFracGrouping[10]:UBYTE,
	MonFracDigits:UBYTE,
	MonIntFracDigits:UBYTE,
	MonCS[10]:UBYTE,
	MonSmallCS[10]:UBYTE,
	MonIntCS[10]:UBYTE,
	MonPositiveSign[10]:UBYTE,
	MonPositiveSpaceSep:UBYTE,
	MonPositiveSignPos:UBYTE,
	MonPositiveCSPos:UBYTE,
	MonNegativeSign[10]:UBYTE,
	MonNegativeSpaceSep:UBYTE,
	MonNegativeSignPos:UBYTE,
	MonNegativeCSPos:UBYTE,
	CalendarType:UBYTE

OBJECT LocalePrefs
	Reserved[4]:ULONG,
	CountryName[32]:UBYTE,
	PreferredLanguages[10]:UBYTE,
	PreferredLanguages[300]:CHAR, /* Just for now! */
//  PreferredLanguages[10][30]:CHAR,
	GMTOffset:LONG,
	Flags:ULONG,
	CountryData:CountryPrefs
