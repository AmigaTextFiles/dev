#ifndef _MATCHPATTERN_H_
#define _MATCHPATTERN_H_ 1
/* MatchPattern.h Version 2.0
 * Copyright (c) 04.2001, Peter Riede
 *
 * Changes to version 1.x:
 * Completely redesigned pattern-matching functions, now able to match all
 * patterns defined for AmigaOS.
 * System independent code, working on AmigaOS 1.2 - 3.9 and Windoof 9x.
 *
 * These are the functions needed for pattern matching.
 *
 *	The pattern matching functions are able to parse any string, so they could
 * be used for pattern matching to find filenames that correspond to a given
 * pattern - like used in the FirstMatch(), NextMatch(), EndMatch() functions -
 * or even for something like full-text-search in documents.
 *
 * This is system independent code, working on AmigaOS 1.2 - 3.9 and Windoof 9x.
 *
 * The pattern-template must be created using the following semantic:
 *
 * expr - any character (except the non-printable characters in the range of
 *			 0x80 up to 0x8B) or any of the following patterns
 *
 * (expr) - parentheses to group patterns
 *
 * expr1expr2 - matches expr1 followed by expr2
 *
 * expr1|expr2 - matches if either expr1 or expr2 matches, choises must always
 *			be parenthesized
 *
 * % - matches the empty string in choises, e.g. "foo(%|bar)" matches "foo" and
 *			"foobar".
 *
 * ~expr - matches any expression that does not match expr, e.g. "~(foo|bar)"
 *			matches anything EXCEPT "foo" or "bar".
 *
 * ? - matches any single character
 *
 * #expr - matches zero or more occurances of expr.
 *
 * 'char - the single quotation mark serves as an escape character. The character
 *			following it, is taken literally, i.e. without its special pattern-
 *			matching properties. It's possible to "escape" all characters.
 *
 * [class] - square brackets are used around character classes. A character class
 *			matches any single character that has been specified within the pair of
 *			square brackets. Characters may be listed explicity, as ranges, or as
 *			any combination thereof, e.g.:
 *
 *			[abc] - matches either "a","b", or "c"
 *			[a-z] - matches all lower case letters
 *			[0-9a-fA-F] matches all sedecimal digits
 *
 *			if the first character after the opening bracket is a "~", then the
 *			entire class is negated, i.e. it will match all characters NOT included
 *			in the class. Both the "~" and the "-" can be escaped by preceding them
 *			with a single quotation mark ('), just like any other special character
 *
 * The second set of functions found in this module are especialy for
 * file-pattern-matching. Using this functions you are able to match all
 * filesystem-objects that match the specified pattern.
 */

/* --- includes ------------------------------------------------------------- */

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifdef _AMIGA

#ifndef DOS_DOSASL_H
#include <dos/dosasl.h>
#endif

#else			/* _AMIGA */

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDOS.h>
#endif

/* --- defines -------------------------------------------------------------- */

/*
 * Constants used by wildcard routines, these are the pre-parsed tokens
 * referred to by pattern match.  It is not necessary for you to do
 * anything about these, FirstMatch() NextMatch() respectively PatternMatch()
 * PatternMatchNoCase() handle all these for you.
 */

#define P_ANY		0x80	/* Token for '*' or '#?  */
#define P_SINGLE	0x81	/* Token for '?' */
#define P_ORSTART	0x82	/* Token for '(' */
#define P_ORNEXT	0x83	/* Token for '|' */
#define P_OREND	0x84	/* Token for ')' */
#define P_NOT		0x85	/* Token for '~' */
#define P_NOTEND	0x86	/* Token for */
#define P_NOTCLASS	0x87	/* Token for '^' */
#define P_CLASS	0x88	/* Token for '[]' */
#define P_REPBEG	0x89	/* Token for '[' */
#define P_REPEND	0x8A	/* Token for ']' */
#define P_STOP		0x8B	/* token to force end of evaluation */

/* --- structures for pattern matching -------------------------------------- */

/* This structure is expected by MatchFirst, MatchNext.
 * Allocate this structure and initialize it as follows:
 *
 * Set ap_BreakBits to the signal bits (CDEF) that you want to take a
 * break on, or NULL, if you don't want to convenience the user.
 *
 * If you want to have the FULL PATH NAME of the files you found,
 * allocate a buffer at the END of this structure, and put the size of
 * it into ap_Strlen.  If you don't want the full path name, make sure
 * you set ap_Strlen to zero.  In this case, the name of the file, and stats
 * are available in the ap_Info, as per usual.
 *
 * Then call MatchFirst() and then afterwards, MatchNext() with this structure.
 * You should check the return value each time (see below) and take the
 * appropriate action, ultimately calling MatchEnd() when there are
 * no more files and you are done.  You can tell when you are done by
 * checking for the normal AmigaDOS return code ERROR_NO_MORE_ENTRIES.
 *
 */

struct AnchorPath {
	struct AChain	*ap_Base;	/* pointer to first anchor */
#define	ap_First ap_Base
	struct AChain	*ap_Last;	/* pointer to last anchor */
#define ap_Current ap_Last
	LONG	ap_BreakBits;	/* Bits we want to break on */
	LONG	ap_FoundBreak;	/* Bits we broke on. Also returns ERROR_BREAK */
	BYTE	ap_Flags;	/* New use for extra word. */
	BYTE	ap_Reserved;
	WORD	ap_Strlen;	/* This is what ap_Length used to be */
#define	ap_Length ap_Flags	/* Old compatability for LONGWORD ap_Length */
	struct	FileInfoBlock ap_Info;
	UBYTE	ap_Buf[1];	/* Buffer for path name, allocated by user */
	/* FIX! */
};


#define	APB_DOWILD	0	/* User option ALL */
#define APF_DOWILD	1

#define	APB_ITSWILD	1	/* Set by MatchFirst, used by MatchNext	 */
#define APF_ITSWILD	2	/* Application can test APB_ITSWILD, too */
				/* (means that there's a wildcard	 */
				/* in the pattern after calling		 */
				/* MatchFirst).				 */

#define	APB_DODIR	2	/* Bit is SET if a DIR node should be */
#define APF_DODIR	4	/* entered. Application can RESET this */
				/* bit after MatchFirst/MatchNext to AVOID */
				/* entering a dir. */

#define	APB_DIDDIR	3	/* Bit is SET for an "expired" dir node. */
#define APF_DIDDIR	8

#define	APB_NOMEMERR	4	/* Set on memory error */
#define APF_NOMEMERR	16

#define	APB_DODOT	5	/* If set, allow conversion of '.' to */
#define APF_DODOT	32	/* CurrentDir */

#define APB_DirChanged	6	/* ap_Current->an_Lock changed */
#define APF_DirChanged	64	/* since last MatchNext call */

#define APB_FollowHLinks 7	/* follow hardlinks on DODIR - defaults   */
#define APF_FollowHLinks 128	/* to not following hardlinks on a DODIR. */


struct AChain {
	struct AChain *an_Child;
	struct AChain *an_Parent;
	BPTR	an_Lock;
	struct FileInfoBlock an_Info;
	BYTE	an_Flags;
	UBYTE	an_String[1];
};

#define	DDB_PatternBit	0
#define	DDF_PatternBit	1
#define	DDB_ExaminedBit	1
#define	DDF_ExaminedBit	2
#define	DDB_Completed	2
#define	DDF_Completed	4
#define	DDB_AllBit	3
#define	DDF_AllBit	8
#define	DDB_Single	4
#define	DDF_Single	16

#endif		/* _AMIGA */

#endif		/* _MATCHPATTERN_H_ */
