/*   Program bref2.c -- makes the cross reference table. */
/* Set TAB value to 3 for this listing. */
/*		Invoked from bref.c which is main() */ 

extern char   Version[];

/*		Following are the original usage instructions for the CLI-only
	version of BREF.  These instructions are still valid with the
	present version.

**	This program reads standard input OR one or more files
**	and prints the file(s) with line numbers added plus an
**      alphabetic list of word references by line number.
**
**	To run:
**  bref [-Q] [-Lnnn] [-Wnnn] [-Hccc] [-Tn] [-?] [-S] [-K] [-E] [file...]
**
**	Where 'file' must be ASCII, not binary -- AmigaBasic default.
**	To save a Basic program in ASCII, enter in Basic output window:
**		LIST ,"prog.name"
**
**	Options--first letter can be upper or lower case:

**	-Q    - don't print normal input file listing (Quiet).
**	-Lnnn - set page Length to n instead of the default 66.
**	-Wnnn - set page Width to n instead of the default 80.
** 		Maximum permitted page width is 132.
**	-Hccc - set page Heading to 'ccc' rather than file names.
**	-Tn   - set tab spaces to n instead of default 3
**	-S    - Suppress form feeds; use for screen output
**	-K    - show BASIC Keywords in crossref table
**	-E    - print the input file 12 chars/in (Elite).  Default 10 cpi.
**      -?    - display this list.
*/

#include <stdio.h>
#include <ctype.h>
#include <signal.h>
#include <exec/types.h>
#include <stat.h>
#include <intuition/intuition.h>

#define MAXWORD		15	/* maximum chars in word */
#define MAXPAGLINES	999	/* maximum posible lines in page */
#define MINPAGLINES	4	/* minimum posible lines in page */
#define MAXLINWIDTH	132	/* maximum posible chars in line */
#define MINLINWIDTH	MAXWORD+12  /* minimum posible chars in line */
#define MAXTABSIZE	132	/* maximum posible chars in tab */
#define MINTABSIZE	1	/* minimum posible chars in tab */

#define igncase(c)	(isupper(c)? tolower(c) : (c))

#undef FALSE
#undef TRUE
#define FALSE	0
#define TRUE	1

#ifdef	DEBUG
#define debug(a,b)	fprintf(stderr,(a),(b))
#else
#define debug(a,b)
#endif


/*  global structures*/

#define LINLIST	struct	_linlist
#define WRDLIST	struct	_wrdlist

struct	_linlist {		/* line number list node */
	long	 ln_no ;	  /* line number */
	LINLIST	*ln_next ;	  /* next element pointer (or NULL) */
} ;

struct	_wrdlist {		/* word list node */
	char	*wd_wd ;	  /* pointer to word */
	char	*wd_lwd ;	  /* pointer to word (lower case) */
	LINLIST	 wd_ln ;	  /* first element of line list */
	WRDLIST	*wd_low ;	  /* lower child */
	WRDLIST	*wd_hi ;	  /* higher child */
} ;


/*  options*/

char	*Progname ;
int 	 Tabsize     = 3 ;	/* default length of tab (-T) */

/*  extern variables -- values defined in main() */

extern int icon;				/* T = icon invoke, F = CLI invoke */ 
extern char	*Filename ;		/* name of current input file */
extern UBYTE out_name[];	/* Output -- CLI- to stdout */
									/*				Icon- default to printer */
extern char	Brefhdr[MAXLINWIDTH+1] ;/* report header */
extern int	Quiet;			/* Print input file listing? (-q) */
extern int	Maxlinwidth;	/* Chars in print line (-w) */
extern int	Maxpaglines;	/* maximum lines in page (-L) */
extern int	FormFeed;		/* Form feeds control (-S) */
extern int	Elite;			/* Print source code in elite? (-E) */
extern int	ShowKeyWords;	/* Show BASIC keywords in table? (-K)*/
extern struct Window *w;	/* Pointer to Window */
extern struct IntuitionBase *IntuitionBase;

/*  global variables*/

char	Date[30] ;		/* current or last file modify date */
long	Hiline = 1L ;	/* current (and max.) input file line number */
int	files=0 ;		/* count of source files */
WRDLIST	*Wdtree = NULL ;	/* ptr to root node of binary word list */
int	SkipREM  = FALSE;	/* Skip to EOL for REM */
int	SkipDATA = FALSE;	/* For DATA, skip to EOL or colon */
int	SaveMLW;		/* Save Max line width */
FILE *output;		/* Output file pointer */
FILE	*filep ;		/* Input file pointer */

/*  AmigaBASIC language reserved keywords */
/*  Entered in binary search order.  This minimizes recursion */
/*  during store of the keywords in the tree, thereby conserving on */
/*  Stack usage. If the keywords are entered in alphabetic order, it */
/*  causes a system crash (exceed Stack) during keyword store in the*/
/*  tree.  There are 202 keywords in this list. */
 
char	*Bkeywords[] = {

/* Level 1 -- #101 */  "MOUSE",
/* Level 2 -- #50 & #151 */  "EOF", "RESUME",
/* Level 3 -- #25 75 126 177 */ "COLOR", "INT", "OPTION", "SUB",
/* Level 4 */ 
"BREAK", "DECLARE", "FRE","LOF","OBJECT.PLANES","POKEW","SIN","UCASE$",
/* Level 5 */
"AREAFILL", "CINT", "CVD",  "DEFSTR", "EXIT", "IF", "LIBRARY", "MERGE",
"OBJECT.AY","OBJECT.VY", "PEEK", "PTAB","SADD","STATIC","TIME$","WEND",
/* Level 6 */
"AND",  "ATN",  "CHAIN", "CLNG", "COS",  "CVS", "DEFINT",  "EDIT",
"ERL",  "FILES", "GOSUB", "INPUT", "LEFT$", "LLIST", "LPRINT", "MKI$", 
"NEXT", "OBJECT.HIT", "OBJECT.START", "OCT$", "PAINT", "POINT","PRINT",
"READ", "RND", "SCREEN", "SPACE$", "STOP", "TAB", "TRANSLATE$",
"VARPTR", "WINDOW",
/* Level 7 */
"ABS", "APPEND", "AS", "BASE", "CALL", "CHDIR","CIRCLE","CLS","COMMON",
"CSNG", "CVI", "DATA", "DEF", "DEFLNG", "DELETE", "ELSEIF", "EQV",
"ERR", "EXP", "FIX", "FUNCTION", "GOTO", "IMP", "INPUT$",
"KILL", "LEN", "LINE", "LOC", "LOG", "LSET", "MID$", "MKS$", "NAME",
"NOT", "OBJECT.CLIP", "OBJECT.OFF", "OBJECT.PRIORITY", "OBJECT.STOP",
"OBJECT.X", "ON", "OR", "PALETTE", "PEEKL", "POKE", "POS", "PRINT#",
"PUT", "RESET", "RETURN", "RSET", "SAVE", "SGN", "SLEEP", "SPC",
"STEP", "STRIG", "SWAP", "TAN", "TIMER", "TRON", "USING",
"WAIT", "WHILE", "WRITE#",
/* Level 8 -- everything else */
"ALL", "AREA", "ASC", "BEEP", "CDBL", "CHR$", "CLEAR", "CLOSE",
"COLLISION", "CONT", "CSRLIN", "CVL", "DATE$",  "DEFDBL", "DEFSNG",
"DIM","ELSE", "END", "ERASE", "ERROR", "FIELD", "FOR", "GET", "HEX$",
"INKEY$", "INPUT$", "INSTR", "LBOUND", "LET", "LIST", "LOAD",
"LOCATE", "LPOS", "MENU", "MKD$", "MKL$", "MOD", "NEW","OBJECT.AX",
"OBJECT.CLOSE", "OBJECT.ON", "OBJECT.SHAPE",  "OBJECT.VX",
"OBJECT.Y", "OFF", "OPEN", "OUTPUT", "PATTERN", "PEEKW", "POKEL",
"PRESET", "PSET", "RANDOMIZE", "REM", "RESTORE", "RIGHT$", "RUN","SAY",
"SCROLL", "SHARED", "SOUND", "SQR", "STICK", "STR$", "STRING$",
"SYSTEM", "THEN","TO", "TROFF", "UBOUND", "VAL", "WAVE", "WIDTH",
"WRITE", "XOR",
	0
} ;


/*  main2 - Store Basic keywords in tree.
 *	   Get program options and format heading lines.
 *	   Get words/line numbers from input file(s), store in tree.
 *	   Retrieve and print words in alphabetic order.  For each
 *		word, print line numbers where word appears. */

main2(argc, argv)
int	 argc ;
char	*argv[] ;
{
	char	wordfilebuf[BUFSIZ] ;
	char	*getword(), *word ;
	struct	 stat	stbuf ;
	long	 time() ;
	register cnt ;

	Progname = *argv ;		/* get invoked program name */
	if (!icon)
	{	output = stdout;
		getcmd(argc, argv) ;	/* get CLI command line items */
	}

		/* If the BASIC keywords are bypassed for the output */
		/*   table, then store keywords in the tree with */
		/*   line count = 0. */
	if (!ShowKeyWords)
	   for (cnt=0 ; Bkeywords[cnt] ; cnt++)
			storword(Bkeywords[cnt], 0L) ;

	listchr(-2);	/* clear output line */
					/* read and store files */
	if (icon)
	{
		if (out_name[0] != '*')
			output = fopen(out_name,"w");
		else
			output = stdout;
		if (output == NULL)
			fatal("Can't open output = %s",out_name);
		if ((filep = fopen(Filename, "r")) == NULL)
			fatal("Can't open input = %s", Filename) ;
		if (! *Brefhdr)
			strcpy(Brefhdr, Filename);
		if (Elite == TRUE)
		{	fprintf (output,"%s", "[2w");  /* Send elite code to printer*/
			SaveMLW = Maxlinwidth;		/* Save Max Line Width */
			Maxlinwidth = (Maxlinwidth * 6) / 5; /* New Max Line Width*/
		}
		stat(Filename, &stbuf) ;
		mkdate((long)stbuf.st_mtime + 252460800) ;	/* This constant, */
			/* (8 yrs in secs) changes the base year from 1978 to 1970. */
		while (word = getword(filep))
	   {	storword(word, Hiline);
	     	if (strcmp(word,"REM") == 0)
				SkipREM = TRUE;
	   	if (strcmp(word,"DATA") == 0)
				SkipDATA = TRUE;
	   }
		fclose(filep) ;
	}
	else
	{
		for (cnt=1 ; cnt < argc ; cnt++)
			if (*argv[cnt] != '-')
			{	files++ ;
				Filename = argv[cnt] ;
				if ((filep = fopen(Filename, "r")) == NULL)
					fatal("can't open %s", Filename) ;
				stat(Filename, &stbuf) ;
				mkdate((long)stbuf.st_mtime + 252460800);	/* This constant, */
			/* (8 yrs in secs) changes the base year from 1978 to 1970. */

				while (word = getword(filep))
			   {	storword(word, Hiline);
			     	if (strcmp(word,"REM") == 0)
						SkipREM = TRUE;
			   	if (strcmp(word,"DATA") == 0)
						SkipDATA = TRUE;
			   }
				fclose(filep) ;
			}

		if (!files)			/* no files - read stdin */
		{	if (*Brefhdr)
				Filename = Brefhdr ;
			else
				Filename = "stdin" ;
			mkdate(time( (long *)0)) ;
			while (word = getword(stdin))
				storword(word, Hiline) ;
		}
	}
	/*  print cross reference report */
	bref(Wdtree) ;
	fclose(output);
}


/*  getcmd - get arguments from command line & build page headings*/

getcmd(argc, argv)
register argc ;
register char	*argv[] ;
{
   register cnt ;

   debug("GETCMD(%d", argc) ;
   debug(", %s)\n", argv[0]) ;

   *Brefhdr = '\0' ;
					/* get command options */
   for (cnt=1; cnt < argc; cnt++)
   {   if (*argv[cnt] == '-')
       {   switch(igncase(argv[cnt][1]))
	   {  case 'q':
		Quiet = TRUE ;
		break ;

	      case 'l':
		Maxpaglines = atoi(&argv[cnt][2]) ;
		if (Maxpaglines < MINPAGLINES
		    || Maxpaglines > MAXPAGLINES)
			fatal("Bad -l value: %s", argv[cnt]) ;
		break ;

	      case 'w':
		Maxlinwidth = atoi(&argv[cnt][2]) ;
		if (Maxlinwidth < MINLINWIDTH
		    || Maxlinwidth > MAXLINWIDTH)
			fatal("Bad -w value: %s", argv[cnt]) ;
		break ;

	      case 't':
		Tabsize = atoi(&argv[cnt][2]);
		if (Tabsize < MINTABSIZE
		    || Tabsize > MAXTABSIZE)
			fatal ("Bad -T value: %s", argv[cnt]);
		break;

	      case 's':
		FormFeed = FALSE;	/* Suppress form feeds */
		break;

	      case 'k':
		ShowKeyWords = TRUE;   /* Show BASIC keywords */
		break;

	      case 'e':
		Elite = TRUE;
		fprintf (output,"%s", "[2w");  /* Send elite code to printer*/
		break;

	      case 'h':
		strncpy(Brefhdr, &argv[cnt][2], MAXLINWIDTH) ;
		Brefhdr[MAXLINWIDTH] = '\0' ;
		break ;

	      case '?':				/* help option */
		usage();
	fprintf (output," Options--1st letter either upper or lower case:\n\n");
	fprintf (output," -Q    - don't print input file listing (Quiet)\n");
	fprintf (output," -Lnnn - set page Length to n, not default 66.\n");
	fprintf (output," -Wnnn - set page Width to n, not default 80.\n");
	fprintf (output," -Hccc - set page Heading 'ccc', not file names\n");
	fprintf (output," -Tn   - set tab spacing to n, not default 3\n");
	fprintf (output," -S    - Suppress form feeds; use--screen output\n");
	fprintf (output," -K    - show BASIC Keywords in CrossRef table\n");
	fprintf (output," -E    - print input file 12 chars/inch (Elite)\n");
	fprintf (output," -?    - display this list.\n");
		exit(0);

	      default:
		usage();
		exit(0);
	   }
       }
   }

    if (Elite)
       { SaveMLW = Maxlinwidth;		/* Save Max Line Width */
	 Maxlinwidth = (Maxlinwidth * 6) / 5; /* New Max Line Width*/
	}
				/* insert file names in hdr */
   if (!*Brefhdr)
       for (cnt=1; cnt < argc; cnt++)
	    if (*argv[cnt] != '-')
	       strjoin(Brefhdr, ' ', argv[cnt], MAXLINWIDTH) ;
}

usage()
{
fprintf (output,"usage:\n\n");
fprintf (output,"bref [-Q] [-Lnnn] [-Wnnn] [-Hccc] [-Tn] [-S] [-K] [-E] \
[-?] [file ...]\n\n");
}

#define	_listchr(chr)	if (!Quiet) listchr(chr)

/*  bypass - skip over constant:  hex, octal, decimal exponential */

bypass(filep,chr)
  FILE  *filep;
  register chr;
{
	_listchr(chr);
	while (chr != EOF)
	{
		chr = getc(filep);
		if ((chr >= '0' && chr <= '9') ||
		    (chr >= 'a' && chr <= 'f') ||
		    (chr >= 'A' && chr <= 'F'))
		{  _listchr(chr);}	/* <--BRACKETS CRITICAL*/
		else break;
	}
	return(chr);
}

/*  getword - read, print and return next word from file*/
 
char *
getword(filep)
FILE	*filep ;
{	static   int    first_read = TRUE;
	static	 char	wordbuf[MAXWORD+1] ;
	static	 int	savchr;
	register char	*wp = wordbuf ;
	register maxw = sizeof(wordbuf) ;
	register chr ;
	int	 inword=0, lastchr=0, inquote = FALSE;
	long	 slineno ;

#define	_rtrnwrd(wp) 		\
   {   ungetc(chr, filep) ;	\
	*(wp) = '\0' ;		\
	savchr = chr;		\
	return wordbuf ;	\
   }

			/* Check for Intuition message CLOSEWINDOW to abort run */
	if (icon) CheckAbort();

   while ((chr = getc(filep)) != EOF)
   {
	if (first_read)
	{ first_read = FALSE;
	  if (chr == 0xf5)
	  fatal ("File %s is binary, can't process--ASCII req.",Filename);
	}

	if (SkipREM || SkipDATA)
	{
		if (savchr == '\n')
		{	SkipREM = FALSE;/* This covers pathological case */
			SkipDATA = FALSE;/* where nothing follows REM,DATA*/
		}
		else goto REM_DATA;	/* REM--skip to end of line*/
				/* DATA--skip to end of line or colon */
	}

				/* Test for hex constant (&Hnnn) */
	if (igncase(chr) == 'h' && lastchr == '&' && inword == 0)
		chr = bypass(filep,chr);

				/* Test for octal constant (&Onnn) */ 
	if (igncase(chr) == 'o' && lastchr == '&' && inword == 0)
		chr = bypass(filep,chr);

	/* Test for decimal exponential constant (nnEnn or nn.Enn) */
	if (igncase(chr) == 'e' && inword == 0 && 
	     (lastchr >= '0' && lastchr <= '9' || lastchr == '.'))
		chr = bypass(filep,chr);

       if ((chr <= 'z' && chr >= 'a') || 
	   (chr <= 'Z' && chr >= 'A') )
	   {
	   if (maxw-- <= 1)
		_rtrnwrd(wp) ;
	   *wp++ = chr ;		/* Add char to current word */
	   inword++ ;
	   _listchr(chr) ;
	   }

       else switch (chr)
       {
			/* These can't be 1st char in word -- */
		      /*   digit, period, suffixes for variable type */
	  case '0': case '1': case '2': case '3': case '4':
	  case '5': case '6': case '7': case '8': case '9':
	  case '.': case '%': case '&': case '!': case '#': case '$':
	      if (inword)
		{   if (maxw-- <= 1)
			_rtrnwrd(wp) ;
		   *wp++ = chr ;
	        }
	      _listchr(chr) ;
	      break ;
				/* newline - end current word */
	  case '\n':
	      if (inword)
		  _rtrnwrd(wp) ;
	      _listchr(chr) ;
	      Hiline++ ;
	      break ;
			/* Apostrophe (') comment - print & bypass */
                        /*     to end of the line. */
	  case '\'':
	      if (inword)
		  _rtrnwrd(wp) ;
REM_DATA:	/* For REM, skip to end of line */
		/* For DATA, skip to end of line or colon not in string */
	      _listchr(chr) ;
	      while ((chr = getc(filep)) != EOF)
	      {_listchr(chr);
		if (chr == '\n')
		  {	Hiline++;
			SkipREM = FALSE;
			SkipDATA = FALSE;
			break;
		  }
		if (SkipDATA)
		{		/* Check DATA for ':' not in string */
			if (inquote)
				{ if (chr == '"') inquote = FALSE; }
			else if (chr == '"') inquote = TRUE;
		     	     else if (chr == ':')
			    	{	SkipDATA = FALSE;
					break;
			        }
		}
	      }
	      if (chr == EOF)  ungetc(chr, filep);
	      break ;
				/* words in quotes - print & bypass */
	  case '"':
	      if (inword)
		  _rtrnwrd(wp) ;
	      _listchr(chr) ;
	      while ((chr = getc(filep)) != EOF)
	      {   _listchr(chr);
	          if (chr == '"')
		      break;
		  if (chr == '\n')   /* Making assumption here that */
		  {   Hiline++;      /* end of line is implied end of*/
		      break;         /* quote string. Apparently this*/
		  }		     /* is what AmigaBasic does. */
	      }
	      if (chr == EOF) ungetc(chr,filep);
	      break ;

	  default:
	      if (inword)
		  _rtrnwrd(wp) ;
	      _listchr(chr) ;
	      break ;
       }		/* End of switch -- process char's */
       lastchr = chr ;
   }			/* End of while -- read char's */

   if (inword)
       _rtrnwrd(wp) ;
   _listchr(EOF) ;
   return NULL ;
}


/*  listchr - list the input files one character at a time*/

static	Listpage = 0 ;
static	Listpline = MAXPAGLINES ;

listchr(chr)
register chr ;
{
	static	char	 linebuf[MAXLINWIDTH*2], *lineptr=linebuf ;
	static	lastchr=0, linecnt=0 ;
	static  int	remain;
	static  int	LNWid = 4;   /* Line number width on listing */
			/* Changed from 6 in CREF to 4 in BREF */

	if (chr == -2)			/* clear line buffer */
	{	setmem(linebuf,Maxlinwidth,' ');
		return;
	}

	if (chr == EOF)			/* EOF - print final line */
	{	*lineptr = '\0' ;
		listline(linebuf) ;
		Listpage = 0 ;
		Listpline = MAXPAGLINES ;
		lineptr = linebuf ;
		linecnt = 0 ;
		return ;
	}

	if (lineptr == linebuf)	    /* new line - format line number */
	{	ltoc(linebuf, Hiline, LNWid) ;
		lineptr = linebuf + LNWid ;
		*lineptr++ = ' ' ;
		*lineptr++ = ' ' ;
		linecnt = LNWid + 2;
	}

#define	_lineoflo(ctr, newctr)		\
	if ((ctr) >= Maxlinwidth)	\
	{	*lineptr = '\0' ;	\
		listline(linebuf) ;	\
		lineptr = &linebuf[LNWid + 2] ;	\
		linecnt = (newctr) ;	\
	}

	switch (chr)
	{				/* newline - print last line */
	   case '\n':
		if (lastchr != '\f')
		{	*lineptr = '\0' ;
			listline(linebuf) ;
		}
		lineptr = linebuf ;
		linecnt = 0 ;
		break ;
	 			/* formfeed - print line and end page*/
	   case '\f':
		if (linecnt != LNWid + 2)
		{	*lineptr = '\0' ;
			listline(linebuf) ;
		}
		Listpline = MAXPAGLINES ;  /* This triggers form feed*/
					   /* on next entry--listline*/
		lineptr = linebuf ;
		linecnt = 0 ;
		break ;
				/* tab - skip to next tab stop */
	   case '\t':
		linecnt += Tabsize ;
		remain =  linecnt % Tabsize ;
		linecnt -= remain;
		_lineoflo(linecnt, LNWid + 2) ;
		lineptr += Tabsize ;
		lineptr -= remain;
		break ;
				/* backspace - print, but don't count*/
	   case '\b':
		*lineptr++ = chr ;
		break ;
					/* ctl-char - print as "^x" */
		     case 001: case 002: case 003:
	   case 004: case 005: case 006: case 007:
					 case 013:
	             case 015: case 016: case 017:
	   case 020: case 021: case 022: case 023:
	   case 024: case 025: case 026: case 027:
	   case 030: case 031: case 032: case 033:
	   case 034: case 035: case 036: case 037:
		_lineoflo(linecnt+=2, LNWid + 4) ;
		*lineptr++ = '^' ;
		*lineptr++ = ('A'-1) + chr ;
		break ;

	   default:
		if (isprint(chr))
		{	_lineoflo(++linecnt, LNWid + 3) ;
			*lineptr++ = chr ;
		}
		else		/* non-ascii chars - print as "\nnn" */
		{	_lineoflo(linecnt+=4, LNWid + 6) ;
			*lineptr++ = '\\' ;
			*lineptr++ = '0' + ((chr & 0300) >> 6) ;
			*lineptr++ = '0' + ((chr & 070) >> 3) ;
			*lineptr++ = '0' + (chr & 07) ;
		}
		break ;
	}
	lastchr = chr ;
}


		/* print a completed line from the input file */
listline(line)
register char	*line ;
{
	if (*line)
	{	if (++Listpline >= (Maxpaglines-8))
		{	if (FormFeed)
			    if (files >1 || Listpage) putc('\f',output) ;
			fprintf (output,"\nBREF %s %s %s  Page %d\n\n",
			   Version, Date, Filename, ++Listpage) ;
			Listpline = 0 ;
		}
		strcat(line,"\n");	/* Append newline char */
		fputs(line,output) ;
		listchr(-2);	/* clear line buffer */
	}
}


/*  storword - store word and line # in binary word tree or word file*/

storword(word, lineno)
register char	*word ;
long	 lineno ;
{
	char	 lword[MAXWORD+1] ;
	register char	*cp1, *cp2 ;
	WRDLIST	*addword() ;

				/* convert word to lower case */
	for (cp1=word, cp2=lword ; *cp2++ = igncase(*cp1) ; cp1++)
		;

					/* store words and lineno */
	Wdtree = addword(Wdtree, word, lword, lineno) ;
}


/*  addword - add word and line# to in-core word list*/
 
WRDLIST *
addword(wdp, word, lword, lineno)
register WRDLIST *wdp ;
char	*word, *lword ;
long	 lineno ;
{
	char	*malloc() ;
	int	 comp ;
					/* insert new word into list */
	if (wdp == NULL)
	{	register wordlen = strlen(word) + 1 ;

		wdp = (WRDLIST *)malloc((wordlen * 2)+sizeof(WRDLIST));
		if (wdp == NULL)
			goto nomemory ;

		wdp->wd_wd  = (char *)wdp + sizeof(WRDLIST) ;
		wdp->wd_lwd = wdp->wd_wd + wordlen ;
		strcpy(wdp->wd_wd,  word) ;
		strcpy(wdp->wd_lwd, lword) ;

		wdp->wd_hi = wdp->wd_low = NULL ;
		wdp->wd_ln.ln_no = lineno ;
		wdp->wd_ln.ln_next = NULL ;
	}

					/* word matched in list? */
	else if (((comp = strcmp(lword, wdp->wd_lwd)) == 0)
	      && ((comp = strcmp(word,  wdp->wd_wd))  == 0))
	{	register LINLIST *lnp, **lnpp ;

		if (wdp->wd_ln.ln_no)
		{			  /* add line# to linked list*/
			lnp = &wdp->wd_ln ;
			do
			{	if (lineno == lnp->ln_no)
					return wdp ;
				lnpp = &lnp->ln_next ;
			} while ((lnp = *lnpp) != NULL) ;

			*lnpp = (LINLIST *)malloc(sizeof(LINLIST)) ;
			if ((lnp = *lnpp) == NULL)
				goto nomemory ;
			lnp->ln_no = lineno ;
			lnp->ln_next = NULL ;
		}
	}

	else if (comp < 0)	/* search for word in children */
		wdp->wd_low = addword(wdp->wd_low, word, lword,lineno);
	else
		wdp->wd_hi = addword(wdp->wd_hi, word, lword, lineno) ;

	return wdp ;
				/* not enough memory - convert to -b */
nomemory:
	fatal("not enough memory for in-core word list") ;
}


/*  bref - print cross reference report from internal word list*/

#define MAXLNOS 2000		/* maximum line nos. for a word */
long	Linenos[MAXLNOS] ;	/* list of line numbers for a word */

bref(wdtree)
register WRDLIST *wdtree ;
{
	if (Elite)
	{fprintf (output,"%s","[1w");   /* Turn off elite for printer */
	 Maxlinwidth = SaveMLW;  /* Restore original Max line width*/
	}

	breftree(wdtree) ;
	if (FormFeed)
	    putc ('\f',output); /*Final form feed after print x-ref table*/
}


breftree(wdp)			/* recursively print word tree nodes */
register WRDLIST *wdp ;
{
	register LINLIST *lnp ;
	register nos ;

	if (wdp != NULL)
	{	breftree(wdp->wd_low) ;	/* print lower children */

		nos = 0 ;
		if (Linenos[0] = wdp->wd_ln.ln_no)
		{	lnp = &wdp->wd_ln ;
			while ((lnp = lnp->ln_next) != NULL)
				if (nos < (MAXLNOS-2))
					Linenos[++nos] = lnp->ln_no ;
			printword(wdp->wd_wd, nos) ;
		}

		breftree(wdp->wd_hi) ;	/* print higher children */
	}
}

static int SkipFF = FALSE;

/*  printword - print a word and all its line number references*/

printword(word, nos)
char	*word ;
register nos ;
{
	static	firstime=TRUE, linecnt, maxlnos, lnosize ;
	register cnt ;

	if (icon) CheckAbort();		/* Check for CLOSEWINDOW to abort run */
	if (firstime)
	{	firstime = FALSE ;
		if (Quiet) SkipFF = TRUE;/* If didn't print input, skip 1st FormFeed*/
		linecnt = Maxpaglines ;
		for (lnosize=1 ; Hiline ; lnosize++)
			Hiline /= 10L ;
		maxlnos = (Maxlinwidth - (MAXWORD+7)) / lnosize ;
	}

	if (linecnt >= (Maxpaglines - 5))
	{	printheads() ;
		linecnt = 5 ;
	}

	fprintf (output,"%-15s%5d  ", word, ++nos) ;
	Linenos[nos] = 0 ;

	for (nos=0, cnt=0 ; Linenos[nos] ; nos++)
	{	if (++cnt > maxlnos)
		{	cnt = 1 ;
			if (linecnt++ >= (Maxpaglines - 4))
			{	printheads() ;
				linecnt = 5 ;
				fprintf (output,"%-15s(cont) ", word);
			}
			else
				fprintf (output,"\n%22s", " ") ;
		}
		fprintf (output,"%*ld", lnosize, Linenos[nos]) ;
	}
	putc('\n',output) ;

	linecnt++ ;
}


/*  printheads - print page headings*/

printheads()
{
	static	page=0 ;
	long	time() ;

	if (!page)
		mkdate(time( (long *)0)) ;

	if (SkipFF) SkipFF = FALSE;		/* if Quiet, skip 1st FormFeed */
	else if (FormFeed) putc('\f',output) ;		/* Form feed */
	fprintf (output,"\nBREF %s %s %.*s  Page %d\n\n",
	   Version, Date, (Maxlinwidth-36), Brefhdr, ++page) ;
	fprintf (output,"word             refs    line numbers\n\n") ;
}


/*  ltoc - store ASCII equivalent of long value in given field*/

ltoc(fld, lval, len)
register char	*fld ;
register long	lval ;
register len ;
{
	fld += len ;
	while (len-->0)
		if (lval)
		{	*--fld = '0' + (lval%10L) ;
			lval /= 10L ;
		}
		else
			*--fld = ' ' ;
}


/*  mkdate - build time/date for use in heading lines*/
 
mkdate(atime)
long	atime ;
{
	long	mtime ;
	char	*cp, *ctime() ;

	debug("MKDATE(%ld)\n", atime) ;

	mtime = atime ;
	cp = ctime(&mtime) ;
	*(cp+24) = ' ' ;		/* clear newline */
	strcpy(cp+16, cp+19) ;		/* shift over seconds */
	strcpy(Date, cp+4) ;
}


/*  strjoin - join "str1" to "str2" (separated by "sep")
 *	Truncate if necessary to "max" chars.*/

strjoin(str1, sep, str2, max)
register char	*str1, *str2;
char	sep ;
register max ;
{
	if (*str2)
	{	if (*str1)
		{	while (*str1++)
				if (--max <= 0)
					goto oflo ;
			max--, str1-- ;
			*str1++ = sep ;
		}
		while (*str1++ = *str2++)
			if (--max <= 0)
				goto oflo ;
	}
	return ;

oflo:
	*--str1 = '\0' ;
	return ;
}

CheckAbort()	/* Check for CLOSEWINDOW message to abort run */
{
 static struct IntuiMessage *msg;	/* Intuition message pointer */
 static ULONG class;
 static BOOL fin = FALSE;

	while (msg = (struct IntuiMessage *) GetMsg(w->UserPort))
	{
		class = msg->Class;
		ReplyMsg(msg);

		switch(class)
		{
			case CLOSEWINDOW:
				fin = TRUE;
				break;
			default:
				break;
		}
	}
	if (fin)
	{											/* Abort run -- clean up & quit */
		fclose(filep);
		fclose(output);
		CloseWindow(w);
		CloseLibrary(IntuitionBase);
		exit(0);
	}
}

/*  fatal - print standard error msg and halt process*/

fatal(ptrn, data1)
register char	*ptrn, *data1;
{
	if (icon)
	{
		fclose(output);
		ErrMsg(0,ptrn,data1);	/* In main() mod, use requester */
									/* to display the error message */
			/* 1st arg (= 0) signals close of Window, Intuition */
	}
	else
	{
		fprintf(stderr, "%s: ", Progname) ;
		fprintf(stderr, ptrn, data1) ;
		putc('\n', stderr) ;
		fclose(output);
		exit(1);
	}
}
