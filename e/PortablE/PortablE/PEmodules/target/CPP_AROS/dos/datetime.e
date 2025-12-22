/* $Id: datetime.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/dos/dos'
MODULE 'target/exec/types'
{#include <dos/datetime.h>}
NATIVE {DOS_DATETIME_H} CONST

NATIVE {DateTime} OBJECT datetime
    {dat_Stamp}	stamp	:datestamp   /* see above */
    {dat_Format}	format	:UBYTE  /* Describes, which format the strings
                                     should have (see below) */
    {dat_Flags}	flags	:UBYTE   /* see below */
    /* The following pointers may be NULL under certain circumstances. */
    {dat_StrDay}	strday	:ARRAY OF UBYTE  /* Day of the week string */
    {dat_StrDate}	strdate	:ARRAY OF UBYTE /* Date string */
    {dat_StrTime}	strtime	:ARRAY OF UBYTE /* Time string */
ENDOBJECT

/* You need this much room for each of the DateTime strings. */
NATIVE {LEN_DATSTRING} CONST LEN_DATSTRING = 16

/* dat_Format */
NATIVE {FORMAT_DOS} CONST FORMAT_DOS = 0          /* DOS internal format, e.g. 21-Jan-78 */
NATIVE {FORMAT_INT} CONST FORMAT_INT = 1          /* International format, e.g. 78-01-21 */
NATIVE {FORMAT_USA} CONST FORMAT_USA = 2          /* US-American format, e.g. 01-21-78 */
NATIVE {FORMAT_CDN} CONST FORMAT_CDN = 3          /* Canadian format, e.g. 21-01-78 */
NATIVE {FORMAT_DEF} CONST FORMAT_DEF = 4          /* Format of current locale */
NATIVE {FORMAT_MAX} CONST FORMAT_MAX = FORMAT_CDN

/* dat_Flags */
NATIVE {DTB_SUBST}  CONST DTB_SUBST  = 0 /* Substitute Today, Tomorrow, etc. if possible. */
NATIVE {DTB_FUTURE} CONST DTB_FUTURE = 1 /* Day of the week is in future. */
NATIVE {DTF_SUBST}  CONST DTF_SUBST  = $1
NATIVE {DTF_FUTURE} CONST DTF_FUTURE = $2
