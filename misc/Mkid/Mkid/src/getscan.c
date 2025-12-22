/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)getscan.c	1.1 86/10/09";

#include	<stdio.h>
#include	"string.h"
#include	"id.h"
#include	<ctype.h>
#include	"extern.h"

char *getLanguage();
char *(*getScanner())();
void setScanArgs();

static struct sufftab *suffSlot();
static struct langtab *langSlot();
static void sorryNoScan();

void setAdaArgs(lang) { sorryNoScan(lang); }
char *getAdaId() { setAdaArgs("ada"); return NULL; }

void setPascalArgs(lang) { sorryNoScan(lang); }
char *getPascalId() { setPascalArgs("pascal"); return NULL; }

void setTextArgs(lang) { sorryNoScan(lang); }
char *getTextId() { setTextArgs("plain text"); return NULL; }

void setRoffArgs(lang) { sorryNoScan(lang); }
char *getRoffId() { setRoffArgs("[nt]roff"); return NULL; }

void setTeXArgs(lang) { sorryNoScan(lang); }
char *getTeXId() { setTeXArgs("TeX"); return NULL; }

void setLispArgs(lang) { sorryNoScan(lang); }
char *getLispId() { setLispArgs("lisp"); return NULL; }

struct langtab {
	struct langtab	*lt_next;
	char	*lt_name;
	char	*(*lt_getid)();
	void	(*lt_setargs)();
};

struct sufftab {
	struct sufftab	*st_next;
	char	*st_suffix;
	struct langtab *st_lang;
};


struct langtab langtab[] = {
#define	SCAN_C		(&langtab[0])
{	&langtab[1],	"c",		getCId,		setCArgs	},
#define	SCAN_ASM	(&langtab[1])
{	&langtab[2],	"asm",		getAsmId,	setAsmArgs	},
#define	SCAN_ADA	(&langtab[2])
{	&langtab[3],	"ada",		getAdaId,	setAdaArgs	},
#define	SCAN_PASCAL	(&langtab[3])
{	&langtab[4],	"pascal",	getPascalId,	setPascalArgs	},
#define	SCAN_LISP	(&langtab[4])
{	&langtab[5],	"lisp",		getLispId,	setLispArgs	},
#define	SCAN_TEXT	(&langtab[5])
{	&langtab[6],	"text",		getTextId,	setTextArgs	},
#define	SCAN_ROFF	(&langtab[6])
{	&langtab[7],	"roff",		getRoffId,	setRoffArgs	},
#define	SCAN_TEX	(&langtab[7])
{	&langtab[8],	"tex",		getTeXId,	setTeXArgs	},
{ NULL, NULL, NULL, NULL }
};

/*
	This is a rather incomplete list of default associations
	between suffixes and languages.  You may add more to the
	default list, or you may define them dynamically with the
	`-S<suff>=<lang>' argument to mkid(1) and idx(1).  e.g. to
	associate a `.ada' suffix with the Ada language, use
	`-S.ada=ada'
*/
struct sufftab sufftab[] = {
{	&sufftab[1],	".c",	SCAN_C		},
{	&sufftab[2],	".h",	SCAN_C		},
{	&sufftab[3],	".y",	SCAN_C		},
{	&sufftab[4],	".s",	SCAN_ASM	},
{	&sufftab[5],	".p",	SCAN_PASCAL	},
{	&sufftab[6],	".pas",	SCAN_PASCAL	},
{ NULL, NULL, NULL },
};

/*
	Return an index into the langtab array for the given suffix.
*/
static struct sufftab *
suffSlot(suffix)
	register char	*suffix;
{
	register struct sufftab	*stp;

	if (suffix == NULL)
		suffix = "";

	for (stp = sufftab; stp->st_next; stp = stp->st_next)
		if (strequ(stp->st_suffix, suffix))
			return stp;
	return stp;
}

static struct langtab *
langSlot(lang)
	char		*lang;
{
	register struct langtab	*ltp;

	if (lang == NULL)
		lang = "";

	for (ltp = langtab; ltp->lt_next; ltp = ltp->lt_next)
		if (strequ(ltp->lt_name, lang))
			return ltp;
	return ltp;
}

char *
getLanguage(suffix)
	char		*suffix;
{
	struct sufftab	*stp;

	if ((stp = suffSlot(suffix))->st_next == NULL)
		return NULL;
	return (stp->st_lang->lt_name);
}

char *(*
getScanner(lang))()
	char		*lang;
{
	struct langtab	*ltp;

	if ((ltp = langSlot(lang))->lt_next == NULL)
		return NULL;
	return (ltp->lt_getid);
}

static void
usage()
{
	fprintf(stderr, "Usage: %s [-S<suffix>=<lang>] [+S(+|-)<arg>] [-S<lang>(+|-)<arg>]\n", MyName);
	exit(1);
}
void
setScanArgs(op, arg)
	int		op;
	char		*arg;
{
	struct langtab	*ltp;
	struct sufftab	*stp;
	char		*lhs;
	int		count = 0;

	lhs = arg;
	while (isalnum(*arg) || *arg == '.')
		arg++;

	if (strequ(lhs, "?=?")) {
		for (stp = sufftab; stp->st_next; stp = stp->st_next)
			printf("%s%s=%s", (count++>0)?", ":"", stp->st_suffix, stp->st_lang->lt_name);
		if (count)
			putchar('\n');
		return;
	}

	if (strnequ(lhs, "?=", 2)) {
		lhs += 2;
		if ((ltp = langSlot(lhs))->lt_next == NULL) {
			printf("No scanner for language `%s'\n", lhs);
			return;
		}
		for (stp = sufftab; stp->st_next; stp = stp->st_next)
			if (stp->st_lang == ltp)
				printf("%s%s=%s", (count++>0)?", ":"", stp->st_suffix, ltp->lt_name);
		if (count)
			putchar('\n');
		return;
	}

	if (strequ(arg, "=?")) {
		lhs[strlen(lhs)-2] = '\0';
		if ((stp = suffSlot(lhs))->st_next == NULL) {
			printf("No scanner assigned to suffix `%s'\n", lhs);
			return;
		}
		printf("%s=%s\n", stp->st_suffix, stp->st_lang->lt_name);
		return;
	}

	if (*arg == '=') {
		*arg++ = '\0';
		
		if ((ltp = langSlot(arg))->lt_next == NULL) {
			fprintf(stderr, "%s: Language undefined: %s\n", MyName, arg);
			return;
		}
		if ((stp = suffSlot(lhs))->st_next == NULL) {
			stp->st_suffix = lhs;
			stp->st_lang = ltp;
			stp->st_next = NEW(struct sufftab);
		} else if (!strequ(arg, stp->st_lang->lt_name)) {
			fprintf(stderr, "%s: Note: `%s=%s' overrides `%s=%s'\n", MyName, lhs, arg, lhs, stp->st_lang->lt_name);
			stp->st_lang = ltp;
		}
		return;
	}
	
	if (op == '+') {
		switch (op = *arg++)
		{
		case '+':
		case '-':
		case '?':
			break;
		default:
			usage();
		}
		for (ltp = langtab; ltp->lt_next; ltp = ltp->lt_next)
			(*ltp->lt_setargs)(NULL, op, arg);
		return;
	}

	if (*arg == '-' || *arg == '+' || *arg == '?') {
		op = *arg;
		*arg++ = '\0';
		
		if ((ltp = langSlot(lhs))->lt_next == NULL) {
			fprintf(stderr, "%s: Language undefined: %s\n", MyName, lhs);
			return;
		}
		(*ltp->lt_setargs)(lhs, op, arg);
		return;
	}

	usage();
}

/*
	Notify user of unimplemented scanners.
*/
static void
sorryNoScan(lang)
	char		*lang;
{
	if (lang == NULL)
		return;
	fprintf(stderr, "Sorry, no scanner is implemented for %s...\n", lang);
}
