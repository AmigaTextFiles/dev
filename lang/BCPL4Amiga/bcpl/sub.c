#include	"icint.h"

#ifdef	unix
#define	MAXFILES	20
static	FILE	*filetable[MAXFILES]	= { 0, stdin, stdout, stderr };
/* slot 0 is wasted so we can use 0 as an invalid value */
static	int	curinfile	= S_IN;
static	int	curoutfile	= S_OUT;
#endif

static FP	theinfile;
static FP	theoutfile;
static FP	theerrfile;

initio()
{
#ifdef	unix
	theinfile = stdin;
	theoutfile = stdout;
	theerrfile = stderr;
#endif
#ifdef	cware
	theinfile = stdin;
	theoutfile = stdout;
	theerrfile = stderr;
#endif
#ifdef	c80
	theinfile = S_IN = fopen("con:", "r");
	theoutfile = S_OUT = theerrfile = S_ERR = fopen("con:", "w");
#endif
}

finio()
{
#ifdef	cware
	int	i;

	for (i = 3; i < 20; ++i)
		fclose(i);
#endif
#ifdef	c80
	int	i;

	for (i = 1; i < 7; ++i)
		fclose(i);
#endif
}

#ifdef	unix
int getfileindex(f)
	FILE	*f;
{
	register int	i;

	for (i = 4; i < MAXFILES; ++i)
		if (filetable[i] == NULL)
			break;
	if (i < MAXFILES)
	{
		filetable[i] = f;
		return (i);
	}
	return (0);
}

clearfileindex(i)
	int	i;
{
	if (4 <= i && i < MAXFILES)
		filetable[i] = NULL;
}

int setsysin(name)
	char	*name;
{
	if (freopen(name, "r", stdin) == NULL)
		return (0);
	return (1);
}
#endif

#ifdef	cware
int setsysin(name)
	char	*name;
{
	if ((S_IN = fopen(name, "r")) == NULL)
		return (0);
	return (1);
}
#endif

#ifdef	c80
int fread(buf, sz, n, f)
	char	*buf;
	int	sz, n;
	int	f;
{
	int	nb;

	nb = sz * n;
	while (nb-- > 0)
		*buf++ = getc(f);
	return (n);
}

int fwrite(buf, sz, n, f)
	char	*buf;
	int	sz, n;
	int	f;
{
	int	nb;

	nb = sz * n;
	while (nb-- > 0)
		putc(*buf++, f);	/* putc function, not macro, in c80 */
	return (n);
}

int setsysin(name)
	char	*name;
{
	if ((S_IN = fopen(name, "r")) == NULL)
		return (0);
	return (1);
}
#endif

int findinput(i)
	int	i;
{
	register FP	f;
	char		fn[MAXFN];

	strbc(i, fn);
	if (strcmp(fn, "SYSIN") == 0)
		return (S_IN);
	if ((f = fopen(fn, "r")) == NULL)
		return (0);
#ifdef	unix
	return (getfileindex(f));
#endif
#ifdef	cware
	return (f);
#endif
#ifdef	c80
	return (f);
#endif
}

int findoutput(i)
	int	i;
{
	register FP	f;
	char		fn[MAXFN];

	strbc(i, fn);
	if (strcmp(fn, "SYSPRINT") == 0)
		return (S_OUT);
	if (strcmp(fn, "SYSERROR") == 0)
		return (S_ERR);
	if ((f = fopen(fn, "w")) == NULL)
		return (0);
#ifdef	unix
	return (getfileindex(f));
#endif
#ifdef	cware
	return (f);
#endif
#ifdef	c80
	return (f);
#endif
}

slctinput(f)
	int		f;
{
#ifdef	unix
	if (1 <= f && f < MAXFILES)
	{
		theinfile = filetable[f];
		curinfile = f;
	}
#endif
#ifdef	cware
	theinfile = f;
#endif
#ifdef	c80
	theinfile = f;
#endif
}

slctoutput(f)
	int		f;
{
#ifdef	unix
	if (1 <= f && f < MAXFILES)
	{
		theoutfile = filetable[f];
		curinfile = f;
	}
#endif
#ifdef	cware
	theoutfile = f;
#endif
#ifdef	c80
	theoutfile = f;
#endif
}

int rdch()
{
#ifdef	cware
	int	c;

	do
		c = getc(theinfile);
	while (c == '\r');
	return (c);
#else
	return (getc(theinfile));
#endif
}

wrch(c)
	int		c;
{
#ifdef	cware
	if (c == '\n')
		putc('\r', theoutfile);
#endif
	putc(c, theoutfile);
}

endread()
{
	if (theinfile != NULL)
		fclose(theinfile);
	theinfile = NULL;
#ifdef	unix
	clearfileindex(curinfile);
#endif
}

endwrite()
{
	if (theoutfile != NULL)
		fclose(theoutfile);
	theoutfile = NULL;
#ifdef	unix
	clearfileindex(curoutfile);
#endif
}

mapstore()
{
}
