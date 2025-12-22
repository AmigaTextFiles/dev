/*tabsize=2
**
** AsmBeautyfier
**
** Written by Frank Wille using VBCC
** 
** Compile:
** vc vlib:minstart.o asmbf.c -sc -sd -lamigas -lvcs -nostdlib -o asmbf
**
** V1.0  13-May-96
** V1.1  29-Jun-96 GLOBAL/S was preset by -1, which is nonsense, of course
** V1.2  09-Jul-96 fixed problems with toupper-macro in SAS/C and GCC
**
*/


#include <ctype.h>

#include <exec/libraries.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>


#define BUFSIZE 1024 	/* maximum line length for conversion */
#define DEF_TABSIZE 8	/* default tabulator size */

struct bfdata {
	char *srcbuf;
	long srclen;
	long len;
	int dpos,opos,cpos;
	int tabsize;
	int globlf,loclf;
};

struct { 	/* directives which must not be separated from their labels */
	int nchars;
	char directive[4];
} equdirs[] = {
	1,"=",
	3,"EQU",
	4,"FREG",
	4,"IDNT",
	4,"MACR",
	2,"RS",
	3,"REG",
	3,"SET",
	0	/* Ende */
};


struct Library *DOSBase=NULL;

static LONG argv[5] = {
	0,(LONG)"8,16,40",DEF_TABSIZE,0,0
};


static const char *readval(const char *,int *);
static void beautify(struct bfdata *,const char *);
static void bconv(struct bfdata *,char *);
static int cmp_equdirs(char *);
static char *fillgap(char *,int *,int *,int,int);
static void printErr(const char *);




main()
{
 	const char *poserr = "Illegal position string";
	struct RDArgs *rda;
	const char *ps;
	struct bfdata bfd;

	if (!(DOSBase = OpenLibrary("dos.library",37)))
		exit(20);
	if (rda = ReadArgs("FILE/A,P=POS/K,T=TAB/K/N,G=GLOBAL/S,L=LOCAL/S",
	 argv,NULL)) {
		ps = (const char *)argv[1];
		ps = readval(ps,&bfd.dpos);
		if (*ps == ',') {
			ps = readval(++ps,&bfd.opos);
			if (*ps == ',') {
				readval(++ps,&bfd.cpos);
				bfd.tabsize = (int)argv[2];
				bfd.globlf = (int)argv[3];
				bfd.loclf = (int)argv[4];
				beautify(&bfd,(const char *)argv[0]);
			}
			else
				printErr(poserr);
		}
		else
			printErr(poserr);
		FreeArgs(rda);
	}
	else
		PrintFault(IoErr(),NULL);
	CloseLibrary(DOSBase);
}


static const char *readval(s,n)
const char *s;
int *n;
{
	LONG cr = StrToLong((STRPTR)s,(LONG *)n);
	return (s + cr);
}


static void beautify(bfd,fname)
struct bfdata *bfd;
const char *fname;
{
	char *source;
	BPTR fh;
	long flen;
	char buffer[BUFSIZE];

	if (fh = Open((STRPTR)fname,MODE_OLDFILE)) {
		Seek(fh,0,OFFSET_END);
		if ((flen = (long)Seek(fh,0,OFFSET_BEGINNING)) <= 0) {
			printErr("Seek error");
			return;
		}
		if (source = (char *)AllocMem((unsigned long)flen,MEMF_ANY)) {
			if (Read(fh,(APTR)source,flen) >= 0) {
				Close(fh);
				if (fh = Open((STRPTR)fname,MODE_NEWFILE)) {
					bfd->srcbuf = source;
					bfd->srclen = flen;
					while (bfd->srclen > 0) {
						bconv(bfd,buffer);
						if (Write(fh,(APTR)buffer,bfd->len) < 0) {
							printErr("Write error");
							break;
						}
						if (bfd->len >= BUFSIZE)
							Printf("Warning: Line buffer overflow!\n");
					}
				}
				else
					printErr("Unable to create output file");
			}
			else
				printErr("Read error");
			FreeMem((APTR)source,(unsigned long)flen);
		}
		else
			printErr("Out of memory");
		Close(fh);
	}
	else
		printErr("Unable to open source file");
}


static void bconv(bfd,buf)
struct bfdata *bfd;
char *buf;
{
	char *src = bfd->srcbuf;
	long slen = bfd->srclen;
	int spos = 0;
	int len = 0;
	int pos = 0;
	int locflag,d;
	char c,sc;

	if (*src=='*' || *src==';')
		goto bc_comment;
	locflag = *src=='.';	/* local .label ? */
	while (!isspace(*src)) {	/* copy label */
		if (len >= BUFSIZE-1)
			goto bc_exit;
		*buf++ = *src++;
		++pos;
		++len;
		++spos;
		if (--slen <= 0)
			goto bc_exit;
	}
	if (pos >= 2)			/* Local label$ ? */
		if (*(buf-1)=='$' || *(buf-2)=='$')
			locflag = 1;

	while (isspace(*src)) {				/* advance to opcode field */
		if (*src++ == '\n') {
			if (pos && pos < bfd->dpos && isspace(*src)) {
				if ((locflag && !bfd->loclf) || (!locflag && !bfd->globlf)) {
					spos = 0;
					if (--slen <= 0)
						goto bc_exit;
					continue;
				}
			}
			goto bc_exit;
		}
		++spos;
		if (--slen <= 0)
			goto bc_exit;
	}
	if (pos) {
		if ( pos >= bfd->dpos || (!locflag && bfd->globlf) || 
		 (locflag && bfd->loclf) ) {
			if (!cmp_equdirs(src)) {
				if (len >= BUFSIZE-1)
					goto bc_exit;
				/* line feed after label, if desired/necessary */
				++len;
				*buf++ = '\n';
				pos = 0;
			}
		}
	}
	buf = fillgap(buf,&len,&pos,bfd->dpos,bfd->tabsize);

	if (*src=='*' || *src==';')
		goto bc_comment;
	while (!isspace(*src)) {			/* copy opcode */
		if (len >= BUFSIZE-1)
			goto bc_exit;
		*buf++ = *src++;
		++pos;
		++len;
		++spos;
		if (--slen <= 0)
			goto bc_exit;
	}

	while (isspace(*src)) {				/* advance to opcode field */
		if (*src++ == '\n')
			goto bc_exit;
		++spos;
		if (--slen <= 0)
			goto bc_exit;
	}
	buf = fillgap(buf,&len,&pos,bfd->opos,bfd->tabsize);

	while(*src != ';' && *src != '\n') { /* copy opcode */
		c = *src;
		if (c == 0x22 || c == 0x27) {	/* string */
			sc = c;
			do {
				if (len >= BUFSIZE-1)
					goto bc_exit;
				if (c == '\t') {
					d = DEF_TABSIZE-(spos%DEF_TABSIZE);
					spos += d;
					buf = fillgap(buf,&len,&pos,pos+d,bfd->tabsize);
				}
				else {
					*buf++ = c;
					++pos;
					++len;
					++spos;
				}
				if (--slen <= 0)
					goto bc_exit;
				d = 1;
				if ((c = *(++src)) == sc)
					if (*(src-1) != 0x5c && *(src+1) != sc)
						d = 0;
			}
			while (d && c != '\n');
		}
		if (!isspace(c)) {
			if (len >= BUFSIZE-1)
				goto bc_exit;
			*buf++ = c;
			++pos;
			++len;
		}
		++spos;
		++src;
		if (--slen <= 0)
			goto bc_exit;
	}
	if (*src == ';')					/* advance to comment-position */
		buf = fillgap(buf,&len,&pos,bfd->cpos,bfd->tabsize);

bc_comment:
	while ((c = *src) != '\n') {
		if (len >= BUFSIZE-1)
			goto bc_exit;
		if (c == '\t') {
			d = DEF_TABSIZE-(spos%DEF_TABSIZE);
			spos += d;
			buf = fillgap(buf,&len,&pos,pos+d,bfd->tabsize);
		}
		else {
			*buf++ = c;
			++pos;
			++len;
			++spos;
		}
		++src;
		if (--slen <= 0)
			goto bc_exit;
	}
	++src;

bc_exit:
	*buf = '\n';
	bfd->srcbuf = src;
	bfd->srclen = slen-1;
	bfd->len = (long)len+1;
}


static int cmp_equdirs(src)
char *src;
{
	char *s;
	int i = -1;
	int n,j;

	while (n = equdirs[++i].nchars) {
		for (j=0,s=src; j<n; j++,s++)
			if ((char)toupper((int)*s) != equdirs[i].directive[j])
				break;
		if (j == n)
			return 1;
	}
	return 0;
}


static char *fillgap(buf,len,curr_pos,jump_pos,tab)
char *buf;
int *len,*curr_pos,jump_pos,tab;
{
	int ns,nt = 0;

	if (*curr_pos >= jump_pos)
		jump_pos = *curr_pos+1;
	ns = jump_pos - *curr_pos;
	if (tab)
		if (nt = ((jump_pos-(jump_pos%tab))-(*curr_pos-(*curr_pos%tab))) / tab)
			ns = jump_pos % tab;
	if (*len+nt >= BUFSIZE-1) {
		nt = BUFSIZE - *len-1;
		ns = 0;
	}
	*len += nt;
	while (nt--)
		*buf++ = '\t';
	if (*len+ns >= BUFSIZE-1)
		ns = BUFSIZE-*len-1;
	*len += ns;
	while (ns--)
		*buf++ = ' ';
	*curr_pos = jump_pos;
	return buf;
}


static void printErr(errmsg)
const char *errmsg;
{
	Printf("*** ERROR: %s!\n",errmsg);
}
