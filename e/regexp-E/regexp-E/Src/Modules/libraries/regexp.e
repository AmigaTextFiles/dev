OPT MODULE
OPT EXPORT

OPT PREPROCESS

/*
**	$VER: regexp.e 37.1 (1.3.98)
**
**	(L) Copyleft 1998 Matthias Bethke
**	Converted from C to E by Per Olofsson (MagerValp@Goth.Org)
*/

MODULE 'dos/dos'

CONST	REXPERR_NULLARG=-1,			/* "NULL argument" */
	REXPERR_REXPTOOBIG=-2,			/* "regexp too big */
	REXPERR_TOOMANYPARENS=-3,		/* "too many parentheses" */
	REXPERR_UNMATCHEDPARENS=-4,		/* "unmatched parentheses */
	REXPERR_JUNKONEND=-5,			/* "junk on end" (should never happen) */
	REXPERR_ARSKPLUSCBE=-6,			/* "*+ operand could be empty" */
	REXPERR_NESTEDARSKQMPLUS=-7,		/* "nested *?+" */
	REXPERR_INVALIDABRKTRANGE=-8,		/* "invalid [] range" */
	REXPERR_UNMATCHEDABRKT=-9,		/* "unmatched []" */
	REXPERR_INTERNALURP=-10,		/* "internal urp" */
	REXPERR_QMPLUSARSKFN=-11,		/* "?+* follows nothing" */
	REXPERR_TRAILINGDSLASH=-12,		/* "trailing \\" */
	/* returned by RegMatch() only */
	REXPERR_CORRUPTEDPROG=-13,		/* "corrupted program" */
	REXPERR_CORRUPTEDMEM=-14,		/* "corrupted memory" */
	REXPERR_CORRUPTEDPTRS=-15,		/* "corrupted pointers" */
	REXPERR_INTERNALFOULUP=-16		/* "internal foulup" */

/*
** better don't mess with struct regexp, use it as an abstract
** handle for expressions only!
*/

#define NSUBEXP 10
OBJECT regexp
	startp[NSUBEXP]:ARRAY OF LONG
	endp[NSUBEXP]:ARRAY OF LONG
	regstart:CHAR			/* Internal use only. */
	reganch:CHAR			/* Internal use only. */
	regmust:PTR TO CHAR		/* Internal use only. */
	regmlen:INT			/* Internal use only. */
	program[1]:ARRAY OF CHAR	/* Unwarranted chumminess with compiler. */
ENDOBJECT
