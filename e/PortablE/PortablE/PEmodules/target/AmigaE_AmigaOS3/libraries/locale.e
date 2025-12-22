/* $VER: locale.h 38.12 (24.2.1993) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes', 'target/exec/lists', 'target/exec/libraries', 'target/utility/tagitem'
{MODULE 'libraries/locale'}

/* constants for GetLocaleStr() */
NATIVE {DAY_1}		CONST DAY_1		= 1	/* Sunday    */
NATIVE {DAY_2}		CONST DAY_2		= 2	/* Monday    */
NATIVE {DAY_3}		CONST DAY_3		= 3	/* Tuesday   */
NATIVE {DAY_4}		CONST DAY_4		= 4	/* Wednesday */
NATIVE {DAY_5}		CONST DAY_5		= 5	/* Thursday  */
NATIVE {DAY_6}		CONST DAY_6		= 6	/* Friday    */
NATIVE {DAY_7}		CONST DAY_7		= 7	/* Saturday  */

NATIVE {ABDAY_1}	CONST ABDAY_1	= 8	/* Sun */
NATIVE {ABDAY_2}	CONST ABDAY_2	= 9	/* Mon */
NATIVE {ABDAY_3}	CONST ABDAY_3	= 10	/* Tue */
NATIVE {ABDAY_4}	CONST ABDAY_4	= 11	/* Wed */
NATIVE {ABDAY_5}	CONST ABDAY_5	= 12	/* Thu */
NATIVE {ABDAY_6}	CONST ABDAY_6	= 13	/* Fri */
NATIVE {ABDAY_7}	CONST ABDAY_7	= 14	/* Sat */

NATIVE {MON_1}		CONST MON_1		= 15	/* January   */
NATIVE {MON_2}		CONST MON_2		= 16	/* February  */
NATIVE {MON_3}		CONST MON_3		= 17	/* March     */
NATIVE {MON_4}		CONST MON_4		= 18	/* April     */
NATIVE {MON_5}		CONST MON_5		= 19	/* May	     */
NATIVE {MON_6}		CONST MON_6		= 20	/* June      */
NATIVE {MON_7}		CONST MON_7		= 21	/* July      */
NATIVE {MON_8}		CONST MON_8		= 22	/* August    */
NATIVE {MON_9}		CONST MON_9		= 23	/* September */
NATIVE {MON_10}		CONST MON_10		= 24	/* October   */
NATIVE {MON_11}		CONST MON_11		= 25	/* November  */
NATIVE {MON_12}		CONST MON_12		= 26	/* December  */

NATIVE {ABMON_1}	CONST ABMON_1	= 27	/* Jan */
NATIVE {ABMON_2}	CONST ABMON_2	= 28	/* Feb */
NATIVE {ABMON_3}	CONST ABMON_3	= 29	/* Mar */
NATIVE {ABMON_4}	CONST ABMON_4	= 30	/* Apr */
NATIVE {ABMON_5}	CONST ABMON_5	= 31	/* May */
NATIVE {ABMON_6}	CONST ABMON_6	= 32	/* Jun */
NATIVE {ABMON_7}	CONST ABMON_7	= 33	/* Jul */
NATIVE {ABMON_8}	CONST ABMON_8	= 34	/* Aug */
NATIVE {ABMON_9}	CONST ABMON_9	= 35	/* Sep */
NATIVE {ABMON_10}	CONST ABMON_10	= 36	/* Oct */
NATIVE {ABMON_11}	CONST ABMON_11	= 37	/* Nov */
NATIVE {ABMON_12}	CONST ABMON_12	= 38	/* Dec */

NATIVE {YESSTR}		CONST YESSTR		= 39	/* affirmative response for yes/no queries */
NATIVE {NOSTR}		CONST NOSTR		= 40	/* negative response for yes/no queries    */

NATIVE {AM_STR}		CONST AM_STR		= 41	/* AM */
NATIVE {PM_STR}		CONST PM_STR		= 42	/* PM */

NATIVE {SOFTHYPHEN}	CONST SOFTHYPHEN	= 43	/* soft hyphenation */
NATIVE {HARDHYPHEN}	CONST HARDHYPHEN	= 44	/* hard hyphenation */

NATIVE {OPENQUOTE}	CONST OPENQUOTE	= 45	/* start of quoted block */
NATIVE {CLOSEQUOTE}	CONST CLOSEQUOTE	= 46	/* end of quoted block	 */

NATIVE {YESTERDAYSTR}	CONST YESTERDAYSTR	= 47	/* Yesterday */
NATIVE {TODAYSTR}	CONST TODAYSTR	= 48	/* Today     */
NATIVE {TOMORROWSTR}	CONST TOMORROWSTR	= 49	/* Tomorrow  */
NATIVE {FUTURESTR}	CONST FUTURESTR	= 50	/* Future    */

NATIVE {MAXSTRMSG}	CONST MAXSTRMSG	= 51	/* current number of defined strings */


/*****************************************************************************/


/* OpenLibrary("locale.library",0) returns a pointer to this structure */
NATIVE {localebase} OBJECT localebase
    {lib}	lib	:lib
    {syspatches}	syspatches	:INT   /* TRUE if locale installed its patches */
ENDOBJECT


/*****************************************************************************/


/* This structure must only be allocated by locale.library and is READ-ONLY! */
NATIVE {locale} OBJECT locale
    {localename}	localename	:/*STRPTR*/ ARRAY OF CHAR	      /* locale's name		     */
    {languagename}	languagename	:/*STRPTR*/ ARRAY OF CHAR	      /* language of this locale     */
    {preflanguages}	preflanguages[10]	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR    /* preferred languages	     */
    {flags}	flags	:ULONG		      /* always 0 for now	     */

    {codeset}	codeset	:ULONG	      /* always 0 for now	     */
    {countrycode}	countrycode	:ULONG	      /* user's country code	     */
    {telephonecode}	telephonecode	:ULONG	      /* country's telephone code    */
    {gmtoffset}	gmtoffset	:VALUE	      /* minutes from GMT	     */
    {measuringsystem}	measuringsystem	:UBYTE      /* what measuring system?      */
    {calendartype}	calendartype	:UBYTE	      /* what calendar type?	     */
    {reserved0}	reserved0[2]	:ARRAY OF UBYTE

    {datetimeformat}	datetimeformat	:/*STRPTR*/ ARRAY OF CHAR       /* regular date & time format  */
    {dateformat}	dateformat	:/*STRPTR*/ ARRAY OF CHAR	      /* date format by itself	     */
    {timeformat}	timeformat	:/*STRPTR*/ ARRAY OF CHAR	      /* time format by itself	     */

    {shortdatetimeformat}	shortdatetimeformat	:/*STRPTR*/ ARRAY OF CHAR  /* short date & time format    */
    {shortdateformat}	shortdateformat	:/*STRPTR*/ ARRAY OF CHAR      /* short date format by itself */
    {shorttimeformat}	shorttimeformat	:/*STRPTR*/ ARRAY OF CHAR      /* short time format by itself */

    /* for numeric values */
    {decimalpoint}	decimalpoint	:/*STRPTR*/ ARRAY OF CHAR	      /* character before the decimals */
    {groupseparator}	groupseparator	:/*STRPTR*/ ARRAY OF CHAR       /* separates groups of digits    */
    {fracgroupseparator}	fracgroupseparator	:/*STRPTR*/ ARRAY OF CHAR   /* separates groups of digits    */
    {grouping}	grouping	:PTR TO UBYTE	      /* size of each group	       */
    {fracgrouping}	fracgrouping	:PTR TO UBYTE	      /* size of each group	       */

    /* for monetary values */
    {mondecimalpoint}	mondecimalpoint	:/*STRPTR*/ ARRAY OF CHAR
    {mongroupseparator}	mongroupseparator	:/*STRPTR*/ ARRAY OF CHAR
    {monfracgroupseparator}	monfracgroupseparator	:/*STRPTR*/ ARRAY OF CHAR
    {mongrouping}	mongrouping	:PTR TO UBYTE
    {monfracgrouping}	monfracgrouping	:PTR TO UBYTE
    {monfracdigits}	monfracdigits	:UBYTE	      /* digits after the decimal point   */
    {monintfracdigits}	monintfracdigits	:UBYTE     /* for international representation */
    {reserved1}	reserved1[2]	:ARRAY OF UBYTE

    /* for currency symbols */
    {moncs}	moncs	:/*STRPTR*/ ARRAY OF CHAR		      /* currency symbol	      */
    {monsmallcs}	monsmallcs	:/*STRPTR*/ ARRAY OF CHAR	      /* symbol for small amounts     */
    {monintcs}	monintcs	:/*STRPTR*/ ARRAY OF CHAR	      /* internationl (ISO 4217) code */

    /* for positive monetary values */
    {monpositivesign}	monpositivesign	:/*STRPTR*/ ARRAY OF CHAR      /* indicate positive money value	 */
    {monpositivespacesep}	monpositivespacesep	:UBYTE  /* determine if separated by space */
    {monpositivesignpos}	monpositivesignpos	:UBYTE   /* position of positive sign	 */
    {monpositivecspos}	monpositivecspos	:UBYTE     /* position of currency symbol	 */
    {reserved2}	reserved2	:UBYTE

    /* for negative monetary values */
    {monnegativesign}	monnegativesign	:/*STRPTR*/ ARRAY OF CHAR      /* indicate negative money value	 */
    {monnegativespacesep}	monnegativespacesep	:UBYTE  /* determine if separated by space */
    {monnegativesignpos}	monnegativesignpos	:UBYTE   /* position of negative sign	 */
    {monnegativecspos}	monnegativecspos	:UBYTE     /* position of currency symbol	 */
    {reserved3}	reserved3	:UBYTE
ENDOBJECT

/* constants for Locale.loc_MeasuringSystem */
NATIVE {MS_ISO}		CONST MS_ISO		= 0	/* international metric system */
NATIVE {MS_AMERICAN}	CONST MS_AMERICAN	= 1	/* american system	       */
NATIVE {MS_IMPERIAL}	CONST MS_IMPERIAL	= 2	/* imperial system	       */
NATIVE {MS_BRITISH}	CONST MS_BRITISH	= 3	/* british system	       */

/* constants for Locale.loc_CalendarType */
NATIVE {CT_7SUN} CONST CT_7SUN = 0   /* 7 days a week, Sunday is the first day	 */
NATIVE {CT_7MON} CONST CT_7MON = 1   /* 7 days a week, Monday is the first day	 */
NATIVE {CT_7TUE} CONST CT_7TUE = 2   /* 7 days a week, Tuesday is the first day	 */
NATIVE {CT_7WED} CONST CT_7WED = 3   /* 7 days a week, Wednesday is the first day */
NATIVE {CT_7THU} CONST CT_7THU = 4   /* 7 days a week, Thursday is the first day  */
NATIVE {CT_7FRI} CONST CT_7FRI = 5   /* 7 days a week, Friday is the first day	 */
NATIVE {CT_7SAT} CONST CT_7SAT = 6   /* 7 days a week, Saturday is the first day  */

/* constants for Locale.loc_MonPositiveSpaceSep and Locale.loc_MonNegativeSpaceSep */
NATIVE {SS_NOSPACE} CONST SS_NOSPACE = 0  /* cur. symbol is NOT separated from value with a space */
NATIVE {SS_SPACE}   CONST SS_SPACE   = 1  /* cur. symbol IS separated from value with a space     */

/* constants for Locale.loc_MonPositiveSignPos and Locale.loc_MonNegativeSignPos */
NATIVE {SP_PARENS}    CONST SP_PARENS    = 0	/* () surround the quantity and currency_symbol   */
NATIVE {SP_PREC_ALL}  CONST SP_PREC_ALL  = 1	/* sign string comes before amount and symbol	  */
NATIVE {SP_SUCC_ALL}  CONST SP_SUCC_ALL  = 2	/* sign string comes after amount and symbol	  */
NATIVE {SP_PREC_CURR} CONST SP_PREC_CURR = 3	/* sign string comes right before currency symbol */
NATIVE {SP_SUCC_CURR} CONST SP_SUCC_CURR = 4	/* sign string comes right after currency symbol  */

/* constants for Locale.loc_MonPositiveCSPos and Locale.loc_MonNegativeCSPos */
NATIVE {CSP_PRECEDES} CONST CSP_PRECEDES = 0	/* currency symbol comes before value */
NATIVE {CSP_SUCCEEDS} CONST CSP_SUCCEEDS = 1	/* currency symbol comes after value  */

/* elements of the byte arrays pointed to by:
 *   Locale.loc_Grouping
 *   Locale.loc_FracGrouping
 *   Locale.loc_MonGrouping
 *   Locale.loc_MonFracGrouping
 * are interpreted as follows:
 *
 *    255     indicates that no further grouping is to be performed
 *    0       indicates that the previous element is to be repeatedly used
 *	      for the remainder of the digits
 *    <other> the number of digits that comprises the current group
 */


/*****************************************************************************/


/* Tags for OpenCatalog() */
NATIVE {OC_TagBase}	   CONST OC_TAGBASE	   = (TAG_USER + $90000)
NATIVE {OC_BuiltInLanguage} CONST OC_BUILTINLANGUAGE = OC_TAGBASE+1   /* language of built-in strings    */
NATIVE {OC_BuiltInCodeSet}  CONST OC_BUILTINCODESET  = OC_TAGBASE+2   /* code set of built-in strings    */
NATIVE {OC_Version}	   CONST OC_VERSION	   = OC_TAGBASE+3   /* catalog version number required */
NATIVE {OC_Language}	   CONST OC_LANGUAGE	   = OC_TAGBASE+4   /* preferred language of catalog   */


/*****************************************************************************/


/* Comparison types for StrnCmp() */
NATIVE {SC_ASCII}    CONST SC_ASCII    = 0
NATIVE {SC_COLLATE1} CONST SC_COLLATE1 = 1
NATIVE {SC_COLLATE2} CONST SC_COLLATE2 = 2


/*****************************************************************************/


/* This structure must only be allocated by locale.library and is READ-ONLY! */
NATIVE {catalog} OBJECT catalog
    {ln}	ln	:ln	/* for internal linkage    */
    {pad}	pad	:UINT	/* to longword align	   */
    {language}	language	:/*STRPTR*/ ARRAY OF CHAR	/* language of the catalog */
    {codeset}	codeset	:ULONG	/* currently always 0	   */
    {version}	version	:UINT	/* version of the catalog  */
    {revision}	revision	:UINT	/* revision of the catalog */
ENDOBJECT
