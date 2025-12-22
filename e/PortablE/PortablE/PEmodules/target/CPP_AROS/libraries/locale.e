OPT NATIVE
MODULE 'target/exec/libraries', 'target/exec/lists', 'target/exec/nodes', 'target/exec/types', 'target/utility/tagitem'
{#include <libraries/locale.h>}
NATIVE {LIBRARIES_LOCALE_H} CONST

NATIVE {LocaleBase} OBJECT localebase
    {lb_LibNode}	lib	:lib
    {lb_SysPatches}	syspatches	:INT
ENDOBJECT

NATIVE {Locale} OBJECT locale
    {loc_LocaleName}	localename	:/*STRPTR*/ ARRAY OF CHAR
    {loc_LanguageName}	languagename	:/*STRPTR*/ ARRAY OF CHAR
    {loc_PrefLanguages}	preflanguages[10]	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR
    {loc_Flags}	flags	:ULONG
    {loc_CodeSet}	codeset	:ULONG

    {loc_CountryCode}	countrycode	:ULONG
    {loc_TelephoneCode}	telephonecode	:ULONG
    {loc_GMTOffset}	gmtoffset	:VALUE
    {loc_MeasuringSystem}	measuringsystem	:UBYTE /* see below */
    {loc_CalendarType}	calendartype	:UBYTE    /* see below */
    {loc_Reserved0}	reserved0[2]	:ARRAY OF UBYTE

    {loc_DateTimeFormat}	datetimeformat	:/*STRPTR*/ ARRAY OF CHAR
    {loc_DateFormat}	dateformat	:/*STRPTR*/ ARRAY OF CHAR
    {loc_TimeFormat}	timeformat	:/*STRPTR*/ ARRAY OF CHAR
    {loc_ShortDateTimeFormat}	shortdatetimeformat	:/*STRPTR*/ ARRAY OF CHAR
    {loc_ShortDateFormat}	shortdateformat	:/*STRPTR*/ ARRAY OF CHAR
    {loc_ShortTimeFormat}	shorttimeformat	:/*STRPTR*/ ARRAY OF CHAR

    {loc_DecimalPoint}	decimalpoint	:/*STRPTR*/ ARRAY OF CHAR
    {loc_GroupSeparator}	groupseparator	:/*STRPTR*/ ARRAY OF CHAR
    {loc_FracGroupSeparator}	fracgroupseparator	:/*STRPTR*/ ARRAY OF CHAR
    {loc_Grouping}	grouping	:PTR TO UBYTE
    {loc_FracGrouping}	fracgrouping	:PTR TO UBYTE
    {loc_MonDecimalPoint}	mondecimalpoint	:/*STRPTR*/ ARRAY OF CHAR
    {loc_MonGroupSeparator}	mongroupseparator	:/*STRPTR*/ ARRAY OF CHAR
    {loc_MonFracGroupSeparator}	monfracgroupseparator	:/*STRPTR*/ ARRAY OF CHAR
    {loc_MonGrouping}	mongrouping	:PTR TO UBYTE
    {loc_MonFracGrouping}	monfracgrouping	:PTR TO UBYTE

    {loc_MonFracDigits}	monfracdigits	:UBYTE
    {loc_MonIntFracDigits}	monintfracdigits	:UBYTE
    {loc_Reserved1}	reserved1[2]	:ARRAY OF UBYTE

    {loc_MonCS}	moncs	:/*STRPTR*/ ARRAY OF CHAR
    {loc_MonSmallCS}	monsmallcs	:/*STRPTR*/ ARRAY OF CHAR
    {loc_MonIntCS}	monintcs	:/*STRPTR*/ ARRAY OF CHAR

    {loc_MonPositiveSign}	monpositivesign	:/*STRPTR*/ ARRAY OF CHAR
    {loc_MonPositiveSpaceSep}	monpositivespacesep	:UBYTE /* see below */
    {loc_MonPositiveSignPos}	monpositivesignpos	:UBYTE  /* see below */
    {loc_MonPositiveCSPos}	monpositivecspos	:UBYTE    /* see below */
    {loc_Reserved2}	reserved2	:UBYTE
    {loc_MonNegativeSign}	monnegativesign	:/*STRPTR*/ ARRAY OF CHAR
    {loc_MonNegativeSpaceSep}	monnegativespacesep	:UBYTE /* see below */
    {loc_MonNegativeSignPos}	monnegativesignpos	:UBYTE  /* see below */
    {loc_MonNegativeCSPos}	monnegativecspos	:UBYTE    /* see below */
    {loc_Reserved3}	reserved3	:UBYTE
ENDOBJECT

/* loc_MeasuringSystem */
NATIVE {MS_ISO}      CONST MS_ISO      = 0
NATIVE {MS_AMERICAN} CONST MS_AMERICAN = 1
NATIVE {MS_IMPERIAL} CONST MS_IMPERIAL = 2
NATIVE {MS_BRITISH}  CONST MS_BRITISH  = 3

/* loc_CalendarType */
NATIVE {CT_7SUN} CONST CT_7SUN = 0
NATIVE {CT_7MON} CONST CT_7MON = 1
NATIVE {CT_7TUE} CONST CT_7TUE = 2
NATIVE {CT_7WED} CONST CT_7WED = 3
NATIVE {CT_7THU} CONST CT_7THU = 4
NATIVE {CT_7FRI} CONST CT_7FRI = 5
NATIVE {CT_7SAT} CONST CT_7SAT = 6

/* loc_MonPositiveSpaceSep and loc_MonNegativeSpaceSep */
NATIVE {SS_NOSPACE} CONST SS_NOSPACE = 0
NATIVE {SS_SPACE}   CONST SS_SPACE   = 1

/* loc_MonPositiveSignPos and loc_MonNegativeSignPos */
NATIVE {SP_PARENS}    CONST SP_PARENS    = 0
NATIVE {SP_PREC_ALL}  CONST SP_PREC_ALL  = 1
NATIVE {SP_SUCC_ALL}  CONST SP_SUCC_ALL  = 2
NATIVE {SP_PREC_CURR} CONST SP_PREC_CURR = 3
NATIVE {SP_SUCC_CURR} CONST SP_SUCC_CURR = 4

/* loc_MonPositiveCSPos and loc_MonNegativeCSPos */
NATIVE {CSP_PRECEDES} CONST CSP_PRECEDES = 0
NATIVE {CSP_SUCCEEDS} CONST CSP_SUCCEEDS = 1

                       /* OpenCatalog() */

NATIVE {OC_TagBase}         CONST OC_TAGBASE         = (TAG_USER + $90000)
NATIVE {OC_BuiltInLanguage} CONST OC_BUILTINLANGUAGE = (OC_TAGBASE + 1)
NATIVE {OC_BuiltInCodeSet}  CONST OC_BUILTINCODESET  = (OC_TAGBASE + 2)
NATIVE {OC_Version}         CONST OC_VERSION         = (OC_TAGBASE + 3)
NATIVE {OC_Language}        CONST OC_LANGUAGE        = (OC_TAGBASE + 4)

                        /* StrnCmp() */

NATIVE {SC_ASCII}    CONST SC_ASCII    = 0
NATIVE {SC_COLLATE1} CONST SC_COLLATE1 = 1
NATIVE {SC_COLLATE2} CONST SC_COLLATE2 = 2

                 /* Internal String-Numbers */

/* Days of Week */
NATIVE {DAY_1} CONST DAY_1 = 1 /* Sunday */
NATIVE {DAY_2} CONST DAY_2 = 2 /* Monday */
NATIVE {DAY_3} CONST DAY_3 = 3 /* Tuesday */
NATIVE {DAY_4} CONST DAY_4 = 4 /* Wednesday */
NATIVE {DAY_5} CONST DAY_5 = 5 /* Thursday */
NATIVE {DAY_6} CONST DAY_6 = 6 /* Friday */
NATIVE {DAY_7} CONST DAY_7 = 7 /* Saturday */

/* Abbreviated Days of Week */
NATIVE {ABDAY_1} CONST ABDAY_1 = 8
NATIVE {ABDAY_2} CONST ABDAY_2 = 9
NATIVE {ABDAY_3} CONST ABDAY_3 = 10
NATIVE {ABDAY_4} CONST ABDAY_4 = 11
NATIVE {ABDAY_5} CONST ABDAY_5 = 12
NATIVE {ABDAY_6} CONST ABDAY_6 = 13
NATIVE {ABDAY_7} CONST ABDAY_7 = 14

/* Months */
NATIVE {MON_1}  CONST MON_1  = 15 /* January */
NATIVE {MON_2}  CONST MON_2  = 16
NATIVE {MON_3}  CONST MON_3  = 17
NATIVE {MON_4}  CONST MON_4  = 18
NATIVE {MON_5}  CONST MON_5  = 19
NATIVE {MON_6}  CONST MON_6  = 20
NATIVE {MON_7}  CONST MON_7  = 21
NATIVE {MON_8}  CONST MON_8  = 22
NATIVE {MON_9}  CONST MON_9  = 23
NATIVE {MON_10} CONST MON_10 = 24
NATIVE {MON_11} CONST MON_11 = 25
NATIVE {MON_12} CONST MON_12 = 26

/* Abbreviated Months */
NATIVE {ABMON_1}  CONST ABMON_1  = 27
NATIVE {ABMON_2}  CONST ABMON_2  = 28
NATIVE {ABMON_3}  CONST ABMON_3  = 29
NATIVE {ABMON_4}  CONST ABMON_4  = 30
NATIVE {ABMON_5}  CONST ABMON_5  = 31
NATIVE {ABMON_6}  CONST ABMON_6  = 32
NATIVE {ABMON_7}  CONST ABMON_7  = 33
NATIVE {ABMON_8}  CONST ABMON_8  = 34
NATIVE {ABMON_9}  CONST ABMON_9  = 35
NATIVE {ABMON_10} CONST ABMON_10 = 36
NATIVE {ABMON_11} CONST ABMON_11 = 37
NATIVE {ABMON_12} CONST ABMON_12 = 38

NATIVE {YESSTR} CONST YESSTR = 39
NATIVE {NOSTR}  CONST NOSTR  = 40

NATIVE {AM_STR} CONST AM_STR = 41
NATIVE {PM_STR} CONST PM_STR = 42

NATIVE {SOFTHYPHEN} CONST SOFTHYPHEN = 43
NATIVE {HARDHYPHEN} CONST HARDHYPHEN = 44

NATIVE {OPENQUOTE}  CONST OPENQUOTE  = 45
NATIVE {CLOSEQUOTE} CONST CLOSEQUOTE = 46

NATIVE {YESTERDAYSTR} CONST YESTERDAYSTR = 47
NATIVE {TODAYSTR}     CONST TODAYSTR     = 48
NATIVE {TOMORROWSTR}  CONST TOMORROWSTR  = 49
NATIVE {FUTURESTR}    CONST FUTURESTR    = 50

NATIVE {MAXSTRMSG} CONST MAXSTRMSG = 51

NATIVE {Catalog} OBJECT catalog
    {cat_Link}	ln	:ln

    {cat_Pad}	pad	:UINT
    {cat_Language}	language	:/*STRPTR*/ ARRAY OF CHAR
    {cat_CodeSet}	codeset	:ULONG
    {cat_Version}	version	:UINT
    {cat_Revision}	revision	:UINT
ENDOBJECT
