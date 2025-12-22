/* ------------------------------------------------------------------
    PSPOP.C -- parse directives
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "asmfile.h"
#include "conf.h"
#include "error.h"
#include "global.h"
#include "label.h"
#include "outf.h"
#include "psexpr.h"
#include "pstext.h"
#include "treefind.h"
#include "ustring.h"

#ifndef EXIT_FAILURE
#define EXIT_SUCCESS (0)
#define EXIT_FAILURE g_errorcount
#endif

/*-----------------------------------------------------------------*/
/* Handle binary includes */
int incbinhandler(char *name,int fileformat)
{
	char *s=stripquote(trim(name));
	FILE *infile;
	unsigned char c;

	infile=fopen(s,"rb");

	if(!infile) {
		errors("file `%s' not found",s,ERR_PASS2);
		return(-1);
	}

	switch(fileformat) {
		case OUTF_PRG:
			getc(infile);
			getc(infile);
			/* DROPTHROUGH!!! */
		case OUTF_BIN:
			c=getc(infile);
			while(!feof(infile)) {
				outf_wbyte(c);
				c=getc(infile);
			}
		case OUTF_P00:
			for(c=0;c<0x1a;c++)
				getc(infile);
			while(!feof(infile)) {
				outf_wbyte(c);
				c=getc(infile);
			}
	}

	fclose(infile);

	return(0);
}

void dotincbin(char *e)
{
	incbinhandler(e,OUTF_BIN);
}

void dotincprg(char *e)
{
	incbinhandler(e,OUTF_PRG);
}

void dotincpzz(char *e)
{
	incbinhandler(e,OUTF_P00);
}


/*-----------------------------------------------------------------*/
/* .BYTE, .WORD and etc */
void dotbytehandler(char *e,long mask)
{
	char *z=0; long q; char quote;
	static char textbuf[1024]; int pos=0;

	while(*e) {
		while(isspace(*e)) e++;

		/* Parse text arguments */
		if (*e=='\"' || *e=='\'') {
			quote=*e;

			e++;

			while(*e) {
				if(*e==quote) {
					switch(e[1]) {
						case ',':
							z=e+2;
							*e=0;
							break;
						case 0:
							*e=0;
							break;
						default:
							if(e[1]==quote) {
								textbuf[pos++]=pstext_convchar(*e);
								e+=2;
							} else {
								z=strchr(e,',');
								if(z) *z++=0;
								error("junk (possibly whitespace) after end of string",ERR_PASS2);
							}
							break;
					}
				} else
					if(pos<1024)
						textbuf[pos++]=pstext_convchar(*e++);
					else
						e++;
			}

			if(mask==2 && pos)
				textbuf[pos-1]|=0x80;

			for(q=0;q<pos;q++)
				outf_wbyte(textbuf[q]);

			if(mask==1) outf_wbyte(0);
		} else

		if(mask) {
			/* Parse non-text arguments if mask */
			if((z=strchr(e,',')))
				*z++=0;

			q=parseexpr(e);

			/* Remember, exceeding amounts may be forward references! */
			if(g_pass && q!=-1 && q>mask) {
				if(mask==0xff)
					error("amount exceeds byte",ERR_WARNING);
				else
					error("amount exceeds word",ERR_WARNING);
			} else {
				outf_wbyte(q & 0xff);
				if(mask==0xffff)
					outf_wbyte((q >> 8) & 0xff);
			}
		} else {
			/* Otherwise text-only.  Therefore, error */
			if(*e)
				error("invalid text argument",ERR_PASS2);
		}

		if(z) {
			e=z;
			z=0;
		} else
			*e=0;
	}
}

void dotbyte(char *e)
{
	dotbytehandler(e,0xff);
}

void dottasc(char *e)
{
	int i=pstext_getcset();
	pstext_setcset(CSET_ASCII);
	dotbytehandler(e,0);
	pstext_setcset(i);
}

void dottext(char *e)
{
	dotbytehandler(e,0);
}

void dotnull(char *e)
{
	dotbytehandler(e,1);
}

void dotshift(char *e)
{
	dotbytehandler(e,2);
}

void dottpet(char *e)
{
	int i=pstext_getcset();
	pstext_setcset(CSET_PETSCII);
	dotbytehandler(e,0);
	pstext_setcset(i);
}

void dottscrl(char *e)
{
	int i=pstext_getcset();
	pstext_setcset(CSET_SCRL);
	dotbytehandler(e,0);
	pstext_setcset(i);
}

void dottscru(char *e)
{
	int i=pstext_getcset();
	pstext_setcset(CSET_SCRU);
	dotbytehandler(e,0);
	pstext_setcset(i);
}

void dotword(char *e)
{
	dotbytehandler(e,0xffff);
}

/*-----------------------------------------------------------------*/
/* Charset */
void dotcset(char *e)
{
	if(!strcmp(e,"scru")) pstext_setcset(CSET_SCRU);
	else if(!strcmp(e,"scrl")) pstext_setcset(CSET_SCRL);
	else if(!strcmp(e,"ascii")) pstext_setcset(CSET_ASCII);
	else if(!strcmp(e,"pet")) pstext_setcset(CSET_PETSCII);
	else error("unknown character set",ERR_PASS2);
}

/*-----------------------------------------------------------------*/
/* .BLOCK, .PAD */
void dotblock(char *expr)
{
	unsigned int q=parseexpr(expr);

	if(q>0 && q!=0xffff) {
		while(q--) {
			outf_wbyte(0xea);
		}
	}
}

/*-----------------------------------------------------------------*/
/* Local scopes */
void dotendloc(char *expr)
{
	lbl_exitlocal();
}

void dotlocal(char *expr)
{
	lbl_enterlocal();
}

/*-----------------------------------------------------------------*/
/* Include a file */
void dotinclude(char *expr)
{
	FILE *f;
	char *s=trim(expr);
	char *t=0; char *u; char *p;
	int scancurrent=1;

	/* strip single quote */
	if(*s=='\'') {
		t=strchr(s+1,'\'');
		if(!t) {
			error("no end quote on filename",ERR_PASS1);
			return;
		}
	} else
	if(*s=='\"') {
		t=strchr(s+1,'\"');
		if(!t)
			error("no end quote on filename",ERR_PASS1);
	} else
	if(*s=='<') {
		t=strchr(s+1,'>');
		if(!t)
			error("no end chevron on filename",ERR_PASS1);
		scancurrent=0;
	}

	if(t) {
		*t=0;
		s++;
	}

	if(scancurrent) {
		f=fopen(s,"r");
	}

	if(f) {
		af_open(s,f);
		return;
	}

	t=getenv("A6_INCPATH");

	p=malloc(256 * sizeof(char));

	while(t) {
		/* Find where current section of path ends */
		u=strchr(t,PATH_SEPARATOR);

		/* Delete separator */
		if(u)
			*u++=0;

		/* Build new filename */
		scancurrent=strlen(t);

		if(t[scancurrent-1]==PATH_SLASH)
			sprintf(p,"%s%s",t,s);
		else
			sprintf(p,"%s%c%s",t,PATH_SLASH,s);

		/* Find it */
		if((f=fopen(p,"r"))) {
			af_open(p,f);
			free(p);
			return;
		}

		/* Next path */
/*		if(u)*/
			t=u;
	}

	free(p);

	errors("cannot find include file `%s'\n",s,ERR_FATAL);
}

/*-----------------------------------------------------------------*/
/* Org */
void dotorg(char *e)
{
	if(outf_getpc()!=0)
		error("second .org encountered",ERR_WARNING);
	else {
		outf_setpc(parseexpr(e));
	}
}

/*-----------------------------------------------------------------*/
/* Echo */
void dotecho(char *e)
{
	printf("%s\n",e);
}

/*-----------------------------------------------------------------*/
/* Align */
void dotalign(char *e)
{
	unsigned int alignto=parseexpr(e) & 0xff;

	if(alignto==0) alignto=256;

	while(outf_getpc() & alignto)
		outf_wbyte(0xea);
}

/*-----------------------------------------------------------------*/
/* Ver */
void dotver(char *e)
{
	unsigned int ver=parseexpr(e);

	if(ver > G_VER) {
		printf("A6 version %u.%u.%u is recommended to assemble this source!\n",ver/100,(ver/10)%10,ver%10);

		if(ver>G_FAILVER) {
			printf("Fatal error:  Later version of A6 requested.\n\n" \
				"Go to http://www.powerfield.demon.co.uk/a6/ to download a new version.\n");

			exit (EXIT_FAILURE);
		}
	}
}

/*-----------------------------------------------------------------*/
/* .ADD, .EOR */
void dotadd(char *e)
{
	if(!g_pass)
		g_outf_add=parseexpr(e);
}

void doteor(char *e)
{
	if(!g_pass)
		g_outf_eor=parseexpr(e);
}

/*-----------------------------------------------------------------*/
/* Undocumented opcodes on and off */
void dotundoc(char *e)
{
	g_undocopsflag=1;
}

void dotnoundoc(char *e)
{
	g_undocopsflag=0;
}

/* --------------------------------------------------------------- */
#define POPADD (4)
#define POPCOUNT (30)

char *popnames[POPCOUNT] = {
	"add", "align",
	"block", "byt", "byte",
	"cset",
	"echo", "endloc", "eor",
	"inc", "incbin", "include", "incp00", "incprg",
	"local",
	"noundoc", "null",
	"org",
	"pad",
	"shift",
	"tasc", "text", "tpet", "tscrl", "tscru", "txt",
	"undoc",
	"ver",
	"wor", "word"
};

typedef void (*PFC)(char *);

PFC popfuncs[POPCOUNT] = {
	dotadd, dotalign,
	dotblock, dotbyte, dotbyte,
	dotcset,
	dotecho, dotendloc, doteor,
	dotinclude, dotincbin, dotinclude, dotincpzz, dotincprg,
	dotlocal,
	dotnoundoc, dotnull,
	dotorg,
	dotblock,
	dotshift,
	dottasc, dottext, dottpet, dottscrl, dottscru, dottext,
	dotundoc,
	dotver,
	dotword, dotword
};

int popsyntax[POPCOUNT] = {
	2,2,		/* add */
	0,2,2,		/* byte */
	2,		/* cset */
	2,2,1,		/* echo,endloc,eor */
	2,2,2,2,2,	/* include */
	2,		/* local */
	2,		/* noundoc */
	1,		/* null */
	0,		/* org */
	0,		/* pad */
	1,		/* shift */
	2,1,2,2,2,1,	/* text stuff */
	2,		/* undoc */
	2,		/* ver */
	0,0		/* word */
};

/* --------------------------------------------------------------- */
/* `Parse' directive */
void parsepop(char *popn,char *expr)
{
	int pop=-1;
	PFC z;

	pop=treefind(popnames,popn,POPCOUNT);

	if(pop==-1) {
		errors("unknown directive `%s'",popn,ERR_PASS1);
	} else {
		if(popsyntax[pop]>g_syntax)
			error("directive not available at this syntax level",0);
		else {
			z=popfuncs[pop];
			z(expr);
		}
	}
}
