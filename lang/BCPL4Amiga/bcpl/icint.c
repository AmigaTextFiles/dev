/*
//     This program is an ASCII INTCODE assembler and interpreter
// for a 16 bit machine.
*/

#define	EXT
#include	"icint.h"

static int	uglob = 0;
static int	verbose = 0;
static struct hdr
{
	unsigned short	psize, gsize, plen, glen;
} proghdr =
{
	0, 0, 0, 0
};
static FP	symin;
static int	hiwater = 0;

int vec(n)
	int	n;
{
	register int	t;

	if (hiwater + n + 1 > MAXMEM)
	{
		fprintf(stderr, "Cannot allocate %d words\n", n);
		exit(2);
	}
	t = hiwater;
	hiwater += n + 1;
	return (t);
}

unvec(n)
	int		n;
{
	hiwater = n;
}

rch()
{
	for (;;)
	{
		ch = getc(symin);
		if (ch != '/')
			return;
		while (ch != '\n')
			ch = getc(symin);
		linecount++;
	}
}

assemble()
{
	register int	v, f;
	register int	a, w, i, aa;

	linecount = 0;
	/* put startup code in first three words */
	mem[pp++] =  LIG1;
	mem[pp++] = K2;
	/* make all globals initially point to exit instruction */
	for (i = 0; i <= GLOBMAX; ++i)
		mem[gp++] = pp;
	gp = globvec;
	mem[pp++] = X22;
	v = labvec = vec(LABMAX);
	f = 0;
clear:
	for (i = 0; i <= LABMAX; ++i)
		mem[v++] = 0;
	v = labvec;
	cp = 0;

next:
	rch();
sw:
	switch (ch)
	{
	default:
		fprintf(stderr, "Bad char '%c' (%02x) at p = %d (line %d)\n",
			ch, ch, pp - progvec, linecount);
		goto next;

	case EOF:
		if (!uglob)
		{
			unvec(labvec);	/* return storage */
			return;
		}
		fprintf(stderr, "Possibly uninitialized globals: ");
		for (i = 0; i <= GLOBMAX; ++i)
			if (mem[globvec+i] == 0)
			{
				mem[globvec+i] = progvec + 2;
				fprintf(stderr, "%d ", i);
			}
		fprintf(stderr, "\n");
		unvec(labvec);		/* return storage */
		return;

	case '0':case '1':case '2':case '3':case '4':
	case '5':case '6':case '7':case '8':case '9':
		setlab(rdn());
		cp = 0;
		goto sw;

	case '\n':
		linecount++;
	case '$':
	case ' ':
	case '\r':
		goto next;

	case 'L': f = OP_L; break;
	case 'S': f = OP_S; break;
	case 'A': f = OP_A; break;
	case 'J': f = OP_J; break;
	case 'T': f = OP_T; break;
	case 'F': f = OP_F; break;
	case 'K': f = OP_K; break;
	case 'X': f = OP_X; break;

	case 'C':
		rch(); stc(rdn()); goto sw;

	case 'D':
		rch();
		if (ch == 'L')
		{
			rch();
			stw(0);
			labref(rdn(), pp - 1);
		}
		else
			stw(rdn());
		goto sw;

	case 'G':
		rch();
		aa = rdn();
		if (aa > proghdr.glen)
			proghdr.glen = aa;
		a = aa + gp;
		if (ch == 'L')
			rch();
		else
			fprintf(stderr, "Bad code at p = %d (line %d)\n",
				pp - progvec, linecount);
		mem[a] = 0;
                labref(rdn(), a);
                goto sw;

	case 'Z':
		for (i = 0; i <= LABMAX; ++i)
			if (mem[labvec+i] > 0)
				fprintf(stderr, "L%d unset\n", i);
                goto clear;
	}

	w = f << FSHIFT;
	rch();
	if (ch == 'I')
	{
		w |= IBIT;
		rch();
	}
	if (ch == 'P')
	{
		w |= PBIT;
		rch();
	}
	if (ch == 'G')
	{
		w |= GBIT;
		rch();
	}

	if (ch == 'L')
	{
		rch();
		stw(w | DBIT);		/* two words so we can backpatch */
		stw(0);
		labref(rdn(), pp - 1);
	}
        else
	{
		aa = rdn();
                if ((aa & ABITS) == aa)
			stw(w | aa);
		else
		{
			stw(w | DBIT);
			stw(aa);
		}
		if (w & GBIT && mem[globvec+aa] == progvec + 2)
			mem[globvec+aa] = 0;
	}

	goto sw;
}

stw(w)
	int		w;
{
	mem[pp] = w;
	++pp;
	cp = 0;
}

stc(c)
	int		c;
{
	if (cp == 0)
	{
		stw(0);
		cp = CHARWORDBITS;
	}
	cp -= BYTESIZE;
	mem[pp - 1] |= (c << cp);
}

int rdn()
{
	register int	a, b;

	a = b = 0;
	if (ch == '-')
	{
		b = 1;
		rch();
	}
	while ('0' <= ch && ch <= '9')
	{
		a = 10 * a + ch - '0';
		rch();
	}
	if (b)
		a = -a;
	return (a);
}

setlab(n)
	int		n;
{
	register int	k, nn;

	k = mem[labvec+n];
        if (k < 0)
		fprintf(stderr, "L%d already set to %d at p = %d (line %d)\n",
			n, -k - progvec, pp - progvec, linecount);
        while (k > 0)
	{
		nn = mem[k];
		mem[k] = pp;
		k = nn;
	}
        mem[labvec+n] = -pp;
}

labref(n, a)
	int		n, a;
{
	register int	k;

	k = mem[labvec+n];
	if (k < 0)
		k = -k;
	else
		mem[labvec+n] = a;
	mem[a] += k;
}

/*
**	The intcode has the assumption that 2 characters fit in a word
**	hardwired in because of packstring and unpackstring.
**	Hence the next three routines.
*/

int icgetbyte(s, i)
	int		s, i;
{
	register word	*w;

	w = &mem[s] + i / 2;
        return (i & 1 ?  *w & 0xff : (*w >> 8) & 0xff);
}

icputbyte(s, i, ch)
	int		s, i, ch;
{
	register word	*w;

	w = &mem[s] + i / 2;
	if (i & 1)
		*w = (*w & ~0xff) | (ch & 0xff);
	else
		*w = (*w & ~0xff00) | ((ch & 0xff) << 8);
}

/* convert a C string to a BCPL string; storage comes from BCPL memory */
int bcstr(s)
	char		*s;
{
	register int	i, len, t;

	len = strlen(s);
	t = vec((len + 2) / 2);
	icputbyte(t, 0, len);
	for (i = 1; i <= len; ++i)
		icputbyte(t, i, *s++);
	return (t);
}

/* convert a BCPL string to a C string; caller supplies array */
strbc(i, s)
	int		i;
	char		s[];
{
	register int	n, len;
	register char	*p;

	len = icgetbyte(i, 0);
	if (len > MAXFN - 1)
		len = MAXFN - 1;
	p = s;
	for (n = 1; n <= len; ++n)
		*p++ = icgetbyte(i, n);
	*p = '\0';
}

makemem()
{
	char		*malloc();

	MAXMEM = proghdr.psize + proghdr.gsize + LABMAX + 100;
	if ((mem = (word *)malloc(MAXMEM * sizeof(word))) == NULL)
	{
		fprintf(stderr, "Cannot allocate %d words of memory for interpreter\n", MAXMEM);
		exit(1);
	}
}

rchk(a, b, s)
	int		a, b;
	char		*s;
{
	if (a != b)
		fprintf(stderr, "Read error on %s\n", s);
}

loadbin(name)
	char		*name;
{
	register FP	f;

#ifdef	c80
	if ((f = fopen(name, "rb")) == NULL)
#else
	if ((f = fopen(name, "r")) == NULL)
#endif
	{
		fprintf(stderr, "Cannot open %s for reading\n", name);
		exit(1);
	}
	rchk(fread((char *)&proghdr, sizeof(struct hdr), 1, f), 1, "proghdr");
	makemem();
	progvec = vec((int)proghdr.psize);
	pp = progvec + proghdr.plen;
	gp = globvec = vec((int)proghdr.gsize);
	rchk(fread((char *)&mem[progvec], sizeof(word), (int)proghdr.plen, f),
		(int)proghdr.plen, "prog");
	rchk(fread((char *)&mem[globvec], sizeof(word), (int)proghdr.glen, f),
		(int)proghdr.glen, "glob");
	fclose(f);
}

loadsym(name)
	char		*name;
{
	makemem();
	pp = progvec = vec((int)proghdr.psize);
	gp = globvec = vec((int)proghdr.gsize);
	if ((symin = fopen(name, "r")) == NULL)
	{
		fprintf(stderr, "Cannot open %s for reading\n", name);
		exit(1);
	}
	assemble();
	proghdr.plen = pp - progvec;
	fclose(symin);
}

wchk(a, b, s)
	int		a, b;
	char		*s;
{
	if (a != b)
		fprintf(stderr, "Write error on %s\n", s);
}

storebin(name)
	char		*name;
{
	register FP	f;

#ifdef	c80
	if ((f = fopen(name, "wb")) == NULL)
#else
	if ((f = fopen(name, "w")) == NULL)
#endif
	{
		fprintf(stderr, "Cannot open %s for writing\n", name);
		exit(1);
	}
	++proghdr.glen;
	wchk(fwrite((char *)&proghdr, sizeof(struct hdr), 1, f), 1, "proghdr");
	wchk(fwrite((char *)&mem[progvec], sizeof(word), (int)proghdr.plen, f),
		(int)proghdr.plen, "prog");
	wchk(fwrite((char *)&mem[globvec], sizeof(word), (int)proghdr.glen, f),
		(int)proghdr.glen, "glob");
	fclose(f);
}

main(argc, argv)
	int		argc;
	char		*argv[];
{
	register int	i;
	register char	*opstring;
	int		loadflag, storeflag;
	int		atoi();

	initio();
	proghdr.psize = PROGMAX;
	proghdr.gsize = GLOBMAX;
	storeflag = loadflag = 0;
	for (--argc, ++argv; argc > 0 && *argv[0] == '-'; --argc, ++argv)
	{
		opstring = *argv;
		switch (opstring[1])
		{
		case 'g':
		case 'G':
			proghdr.gsize = atoi(&opstring[2]);
			break;
		case 'p':
		case 'P':
			proghdr.psize = atoi(&opstring[2]);
			break;
		case 'l':
		case 'L':
			loadflag = 1;
			break;
		case 's':
		case 'S':
			storeflag = 1;
			break;
		case 'u':
		case 'U':
			uglob = 1;
			break;
		case 'v':
		case 'V':
			verbose = 1;
			break;
		}
	}

	if (storeflag)
	{
		if (argc <= 1)
		{
			fprintf(stderr, "Usage: icint -s source binary\n");
			exit(1);
		}
	}
	else
	{
		if (argc <= 0)
		{
			fprintf(stderr, "Usage: icint [options] source [input]\n");
			exit(1);
		}
		if (argc > 1 && !setsysin(argv[1]))
		{
			fprintf(stderr, "Cannot open %s for reading\n", argv[1]);
			exit(1);
		}
	}

	if (loadflag)
		loadbin(argv[0]);
	else
		loadsym(argv[0]);

	if (verbose)
		fprintf(stderr, "Program size = %d\n", proghdr.plen);

	if (storeflag)
	{
		storebin(argv[1]);
		exit(0);
	}

	slctinput(S_IN);
	slctoutput(S_OUT);

	if (verbose)
		fprintf(stderr, "Intcode system entered\n");

#ifdef	profiling
	for (i = 0; i < 8; ++i)
		majinstr[i] = 0;
	for (i = 0; i < 38; ++i)
		mininstr[i] = 0;
#endif

	i = interpret();

#ifdef	profiling
	for (i = 0; i < 8; ++i)
		fprintf(stderr, "Major %d: %d\n", i, majinstr[i]);
	for (i = 0; i < 38; ++i)
		fprintf(stderr, "Minor %d: %d\n", i, mininstr[i]);
#endif	profiling

	if (verbose)
		fprintf(stderr, "Execution cycles = %d, code = %d\n", cyclecount, i);

	if (i < 0)
		mapstore();
	finio();
	exit(i);
	return (0);
}
