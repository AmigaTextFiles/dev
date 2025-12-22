#ifndef LIBRARIES_LOCALE_H
#define LIBRARIES_LOCALE_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif


#define DAY_1		1	
#define DAY_2		2	
#define DAY_3		3	
#define DAY_4		4	
#define DAY_5		5	
#define DAY_6		6	
#define DAY_7		7	
#define ABDAY_1	8	
#define ABDAY_2	9	
#define ABDAY_3	10	
#define ABDAY_4	11	
#define ABDAY_5	12	
#define ABDAY_6	13	
#define ABDAY_7	14	
#define MON_1		15	
#define MON_2		16	
#define MON_3		17	
#define MON_4		18	
#define MON_5		19	
#define MON_6		20	
#define MON_7		21	
#define MON_8		22	
#define MON_9		23	
#define MON_10		24	
#define MON_11		25	
#define MON_12		26	
#define ABMON_1	27	
#define ABMON_2	28	
#define ABMON_3	29	
#define ABMON_4	30	
#define ABMON_5	31	
#define ABMON_6	32	
#define ABMON_7	33	
#define ABMON_8	34	
#define ABMON_9	35	
#define ABMON_10	36	
#define ABMON_11	37	
#define ABMON_12	38	
#define YESSTR		39	
#define NOSTR		40	
#define AM_STR		41	
#define PM_STR		42	
#define SOFTHYPHEN	43	
#define HARDHYPHEN	44	
#define OPENQUOTE	45	
#define CLOSEQUOTE	46	
#define YESTERDAYSTR	47	
#define TODAYSTR	48	
#define TOMORROWSTR	49	
#define FUTURESTR	50	
#define MAXSTRMSG	51	


OBJECT LocaleBase

      LibNode:Library
    SysPatches:BOOL   
ENDOBJECT



OBJECT Locale

    LocaleName:PTR TO CHAR	      
    LanguageName:PTR TO CHAR	      
    PrefLanguages[10]:PTR TO CHAR    
    Flags:LONG		      
    CodeSet:LONG	      
    CountryCode:LONG	      
    TelephoneCode:LONG	      
    GMTOffset:LONG	      
    MeasuringSystem:UBYTE      
    CalendarType:UBYTE	      
    Reserved0[2]:UBYTE
    DateTimeFormat:PTR TO CHAR       
    DateFormat:PTR TO CHAR	      
    TimeFormat:PTR TO CHAR	      
    ShortDateTimeFormat:PTR TO CHAR  
    ShortDateFormat:PTR TO CHAR      
    ShortTimeFormat:PTR TO CHAR      
    
    DecimalPoint:PTR TO CHAR	      
    GroupSeparator:PTR TO CHAR       
    FracGroupSeparator:PTR TO CHAR   
    Grouping:PTR TO UBYTE	      
    FracGrouping:PTR TO UBYTE	      
    
    MonDecimalPoint:PTR TO CHAR
    MonGroupSeparator:PTR TO CHAR
    MonFracGroupSeparator:PTR TO CHAR
    MonGrouping:PTR TO UBYTE
    MonFracGrouping:PTR TO UBYTE
    MonFracDigits:UBYTE	      
    MonIntFracDigits:UBYTE     
    Reserved1[2]:UBYTE
    
    MonCS:PTR TO CHAR		      
    MonSmallCS:PTR TO CHAR	      
    MonIntCS:PTR TO CHAR	      
    
    MonPositiveSign:PTR TO CHAR      
    MonPositiveSpaceSep:UBYTE  
    MonPositiveSignPos:UBYTE   
    MonPositiveCSPos:UBYTE     
    Reserved2:UBYTE
    
    MonNegativeSign:PTR TO CHAR      
    MonNegativeSpaceSep:UBYTE  
    MonNegativeSignPos:UBYTE   
    MonNegativeCSPos:UBYTE     
    Reserved3:UBYTE
ENDOBJECT


#define MS_ISO		0	
#define MS_AMERICAN	1	
#define MS_IMPERIAL	2	
#define MS_BRITISH	3	

#define CT_7SUN 0   
#define CT_7MON 1   
#define CT_7TUE 2   
#define CT_7WED 3   
#define CT_7THU 4   
#define CT_7FRI 5   
#define CT_7SAT 6   

#define SS_NOSPACE 0  
#define SS_SPACE   1  

#define SP_PARENS    0	
#define SP_PREC_ALL  1	
#define SP_SUCC_ALL  2	
#define SP_PREC_CURR 3	
#define SP_SUCC_CURR 4	

#define CSP_PRECEDES 0	
#define CSP_SUCCEEDS 1	



#define OC_TagBase	   (TAG_USER + $90000)
#define OC_BuiltInLanguage OC_TagBase+1   
#define OC_BuiltInCodeSet  OC_TagBase+2   
#define OC_Version	   OC_TagBase+3   
#define OC_Language	   OC_TagBase+4   


#define SC_ASCII    0
#define SC_COLLATE1 1
#define SC_COLLATE2 2


OBJECT Catalog

      Link:Node	
    Pad:UWORD	
    Language:PTR TO CHAR	
    CodeSet:LONG	
    Version:UWORD	
    Revision:UWORD	
ENDOBJECT


#endif	
