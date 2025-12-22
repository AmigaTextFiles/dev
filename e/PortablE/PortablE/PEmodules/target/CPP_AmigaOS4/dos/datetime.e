/* $Id: datetime.h,v 1.13 2005/11/10 15:32:20 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/dos/dos'
MODULE 'target/dos/dos_shared', 'target/exec/types'
{#include <dos/datetime.h>}
NATIVE {DOS_DATETIME_H} CONST

/*
 * Data structures and equates used by the V1.4 DOS functions
 * StrtoDate() and DatetoStr()
 */

/*--------- String/Date structures etc */
NATIVE {DateTime} OBJECT datetime
    {dat_Stamp}	stamp	:datestamp     /* DOS DateStamp */
    {dat_Format}	format	:UBYTE    /* controls appearance of dat_StrDate */
    {dat_Flags}	flags	:UBYTE     /* see BITDEF's below */
    {dat_StrDay}	strday	:ARRAY OF CHAR /*STRPTR*/    /* day of the week string */
    {dat_StrDate}	strdate	:ARRAY OF CHAR /*STRPTR*/   /* date string */
    {dat_StrTime}	strtime	:ARRAY OF CHAR /*STRPTR*/   /* time string */
ENDOBJECT

/* You need this much room for each of the DateTime strings: */
NATIVE {LEN_DATSTRING}    CONST LEN_DATSTRING    = 16

/*    flags for dat_Flags */
NATIVE {DTB_SUBST}         CONST DTB_SUBST         = 0    /* substitute Today, Tomorrow, etc. */
NATIVE {DTB_FUTURE}        CONST DTB_FUTURE        = 1    /* day of the week is in future */

NATIVE {DTF_SUBST}        CONST DTF_SUBST        = $1
NATIVE {DTF_FUTURE}       CONST DTF_FUTURE       = $2

/*
 * date format values
 */

NATIVE {FORMAT_DOS}    CONST FORMAT_DOS    = 0        /* dd-mmm-yy */
NATIVE {FORMAT_INT}    CONST FORMAT_INT    = 1        /* yy-mmm-dd */
NATIVE {FORMAT_USA}    CONST FORMAT_USA    = 2        /* mm-dd-yy  */
NATIVE {FORMAT_CDN}    CONST FORMAT_CDN    = 3        /* dd-mm-yy  */
NATIVE {FORMAT_DEF}    CONST FORMAT_DEF    = 4        /* use default format, as defined
                                  by locale; if locale not available, 
                                  use FORMAT_DOS instead */
NATIVE {FORMAT_ISO}    CONST FORMAT_ISO    = 5        /* yyyy-mm-dd (ISO 8601)
                                  Requires locale V48 or dos V50.36 
                                  if locale not available */
NATIVE {FORMAT_MAX}    CONST FORMAT_MAX    = FORMAT_ISO
