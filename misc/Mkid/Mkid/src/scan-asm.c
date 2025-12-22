/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)scan-asm.c	1.2 86/11/06";

#include	"bool.h"
#include	<stdio.h>
#include	"string.h"
#include	<ctype.h>
#include	"id.h"

char *getAsmId();
void setAsmArgs();

static void clrCtype();
static void setCtype();

#define	I1	0x01	/* 1st char of an identifier [a-zA-Z_] */
#define	NM	0x02	/* digit [0-9a-fA-FxX] */
#define	NL	0x04	/* newline: \n */
#define	CM	0x08	/* assembler comment char: usually # or | */
#define	IG	0x10	/* ignore `identifiers' with these chars in them */
#define	C1	0x20	/* C comment introduction char: / */
#define	C2	0x40	/* C comment termination  char: * */
#define	EF	0x80	/* EOF */

/* Assembly Language character classes */
#define	ISID1ST(c)	((rct)[c]&(I1))
#define	ISIDREST(c)	((rct)[c]&(I1|NM))
#define	ISNUMBER(c)	((rct)[c]&(NM))
#define	ISEOF(c)	((rct)[c]&(EF))
#define	ISCOMMENT(c)	((rct)[c]&(CM))
#define	ISBORING(c)	(!((rct)[c]&(EF|NL|I1|NM|CM|C1)))
#define	ISCBORING(c)	(!((rct)[c]&(EF|NL)))
#define	ISCCBORING(c)	(!((rct)[c]&(EF|C2)))
#define	ISIGNORE(c)	((rct)[c]&(IG))

static char idctype[] = {

	EF,

	/*      0       1       2       3       4       5       6       7   */
	/*    -----   -----   -----   -----   -----   -----   -----   ----- */

	/*000*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*010*/	0,	0,	NL,	0,	0,	0,	0,	0,
	/*020*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*030*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*040*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*050*/	0,	0,	C2,	0,	0,	0,	0,	C1,
	/*060*/	NM,	NM,	NM,	NM,	NM,	NM,	NM,	NM,	
	/*070*/	NM,	NM,	0,	0,	0,	0,	0,	0,
	/*100*/	0,	I1|NM,	I1|NM,	I1|NM,	I1|NM,	I1|NM,	I1|NM,	I1,
	/*110*/	I1,	I1,	I1,	I1,	I1|NM,	I1,	I1,	I1,
	/*120*/	I1,	I1,	I1,	I1,	I1,	I1,	I1,	I1,
	/*130*/	I1|NM,	I1,	I1,	0,	0,	0,	0,	I1,
	/*140*/	0,	I1|NM,	I1|NM,	I1|NM,	I1|NM,	I1|NM,	I1|NM,	I1,
	/*150*/	I1,	I1,	I1,	I1,	I1|NM,	I1,	I1,	I1,
	/*160*/	I1,	I1,	I1,	I1,	I1,	I1,	I1,	I1,
	/*170*/	I1|NM,	I1,	I1,	0,	0,	0,	0,	0,

	/*200*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*210*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*220*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*230*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*240*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*250*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*260*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*270*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*300*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*310*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*320*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*330*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*340*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*350*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*360*/	0,	0,	0,	0,	0,	0,	0,	0,
	/*370*/	0,	0,	0,	0,	0,	0,	0,	0,

};

static bool eatUnder = TRUE;
static bool preProcess = TRUE;

/*
	Grab the next identifier the assembly language
	source file opened with the handle `inFILE'.
	This state machine is built for speed, not elegance.
*/
char *
getAsmId(inFILE, flagP)
	FILE		*inFILE;
	int		*flagP;
{
	static char	idBuf[BUFSIZ];
	register char	*rct = &idctype[1];
	register int	c;
	register char	*id = idBuf;
	static bool	newLine = TRUE;

top:
	c = getc(inFILE);
	if (preProcess > 0 && newLine) {
		newLine = FALSE;
		if (c != '#')
			goto next;
		while (ISBORING(c))
			c = getc(inFILE);
		if (!ISID1ST(c))
			goto next;
		id = idBuf;
		*id++ = c;
		while (ISIDREST(c = getc(inFILE)))
			*id++ = c;
		*id = '\0';
		if (strcmp(idBuf, "include") == 0) {
			while (c != '"' && c != '<')
				c = getc(inFILE);
			id = idBuf;
			*id++ = c = getc(inFILE);
			while ((c = getc(inFILE)) != '"' && c != '>')
				*id++ = c;
			*id = '\0';
			*flagP = IDN_STRING;
			return idBuf;
		}
		if (strncmp(idBuf, "if", 2) == 0
		|| strcmp(idBuf, "define")  == 0
		|| strcmp(idBuf, "undef")   == 0)
			goto next;
		while (c != '\n')
			c = getc(inFILE);
		newLine = TRUE;
		goto top;
	}

next:
	while (ISBORING(c))
		c = getc(inFILE);

	if (ISCOMMENT(c)) {
		while (ISCBORING(c))
			c = getc(inFILE);
		newLine = TRUE;
	}

	if (ISEOF(c)) {
		newLine = TRUE;
		return NULL;
	}

	if (c == '\n') {
		newLine = TRUE;
		goto top;
	}

	if (c == '/') {
		if ((c = getc(inFILE)) != '*')
			goto next;
		c = getc(inFILE);
		for (;;) {
			while (ISCCBORING(c))
				c = getc(inFILE);
			if ((c = getc(inFILE)) == '/') {
				c = getc(inFILE);
				break;
			} else if (ISEOF(c)) {
				newLine = TRUE;
				return NULL;
			}
		}
		goto next;
	}

	id = idBuf;
	if (eatUnder && c == '_' && !ISID1ST(c = getc(inFILE))) {
		ungetc(c, inFILE);
		return "_";
	}
	*id++ = c;
	if (ISID1ST(c)) {
		*flagP = IDN_NAME;
		while (ISIDREST(c = getc(inFILE)))
			*id++ = c;
	} else if (ISNUMBER(c)) {
		*flagP = IDN_NUMBER;
		while (ISNUMBER(c = getc(inFILE)))
			*id++ = c;
	} else {
		if (isprint(c))
			fprintf(stderr, "junk: `%c'", c);
		else
			fprintf(stderr, "junk: `\\%03o'", c);
		goto next;
	}

	*id = '\0';
	for (id = idBuf; *id; id++)
		if (ISIGNORE(*id))
			goto next;
	ungetc(c, inFILE);
	*flagP |= IDN_LITERAL;
	return idBuf;
}

static void
setCtype(chars, type)
	char		*chars;
	int		type;
{
	char		*rct = &idctype[1];

	while (*chars)
		rct[*chars++] |= type;
}
static void
clrCtype(chars, type)
	char		*chars;
	int		type;
{
	char		*rct = &idctype[1];

	while (*chars)
		rct[*chars++] &= ~type;
}

extern char	*MyName;
static void
usage(lang)
	char		*lang;
{
	fprintf(stderr, "Usage: %s -S%s([-c<cc>] [-u] [(+|-)a<cc>] [(+|-)p] [(+|-)C])\n", MyName, lang);
	exit(1);
}
static char *asmDocument[] =
{
"The Assembler scanner arguments take the form -Sasm<arg>, where",
"<arg> is one of the following: (<cc> denotes one or more characters)",
"  -c<cc> . . . . <cc> introduce(s) a comment until end-of-line.",
"  (+|-)u . . . . (Do|Don't) strip a leading `_' from ids.",
"  (+|-)a<cc> . . Allow <cc> in ids, and (keep|ignore) those ids.",
"  (+|-)p . . . . (Do|Don't) handle C-preprocessor directives.",
"  (+|-)C . . . . (Do|Don't) handle C-style comments. (/* */)",
NULL
};
void
setAsmArgs(lang, op, arg)
	char		*lang;
	int		op;
	char		*arg;
{
	if (op == '?') {
		document(asmDocument);
		return;
	}
	switch (*arg++)
	{
	case 'a':
		setCtype(arg, I1|((op == '-') ? IG : 0));
		break;
	case 'c':
		setCtype(arg, CM);
		break;
	case 'u':
		eatUnder = (op == '+');
		break;
	case 'p':
		preProcess = (op == '+');
		break;
	case 'C':
		if (op == '+') {
			setCtype("/", C1);
			setCtype("*", C2);
		} else {
			clrCtype("/", C1);
			clrCtype("*", C2);
		}
		break;
	default:
		if (lang)
			usage(lang);
		break;
	}
}
