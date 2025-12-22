/* $VER: datetime.h 45.1 (17.12.2001) */
OPT NATIVE
MODULE 'target/dos/dos_shared'
MODULE 'target/exec/types'
{MODULE 'dos/datetime'}

/*--------- String/Date structures etc */
NATIVE {datetime} OBJECT datetime
	{stamp}		stamp	:datestamp	/* DOS DateStamp */
	{format}	format	:UBYTE		/* controls appearance of StrDate */
	{flags}		flags	:UBYTE		/* see BITDEF's below */
	{strday}	strday	:ARRAY OF UBYTE		/* day of the week string */
	{strdate}	strdate	:ARRAY OF UBYTE		/* date string */
	{strtime}	strtime	:ARRAY OF UBYTE		/* time string */
ENDOBJECT

/* You need this much room for each of the DateTime strings: */
NATIVE {LEN_DATSTRING}	CONST LEN_DATSTRING	= 16

/*	flags for dat_Flags */

NATIVE {DTB_SUBST}	CONST DTB_SUBST	= 0		/* substitute Today, Tomorrow, etc. */
NATIVE {DTF_SUBST}	CONST DTF_SUBST	= 1
NATIVE {DTB_FUTURE}	CONST DTB_FUTURE	= 1		/* day of the week is in future */
NATIVE {DTF_FUTURE}	CONST DTF_FUTURE	= 2

/*
 *	date format values
 */

NATIVE {FORMAT_DOS}	CONST FORMAT_DOS	= 0		/* dd-mmm-yy */
NATIVE {FORMAT_INT}	CONST FORMAT_INT	= 1		/* yy-mm-dd  */
NATIVE {FORMAT_USA}	CONST FORMAT_USA	= 2		/* mm-dd-yy  */
NATIVE {FORMAT_CDN}	CONST FORMAT_CDN	= 3		/* dd-mm-yy  */
NATIVE {FORMAT_MAX}	CONST FORMAT_MAX	= FORMAT_CDN
CONST FORMAT_DEF	= 4		/* use default format, as defined
					   by locale; if locale not
					   available, use FORMAT_DOS
					   instead */
