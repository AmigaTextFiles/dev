#ifndef	unix
#define	cware
/* or c80 */
#endif

#ifndef	EXT
#define	EXT	extern
#endif

#ifdef	unix
#include	<stdio.h>
typedef	FILE	*FP;
/* standard stream numbers */
#define	S_IN		1
#define	S_OUT		2
#define	S_ERR		3
#endif

#ifdef	cware
#include	<stdio.h>
typedef	int	FP;
EXT int	S_IN, S_OUT, S_ERR;
#endif

#ifdef	c80
#define	EOF	-1
#define	NULL	0
#define	FP	int
EXT int	S_IN, S_OUT, S_ERR;
EXT int	stdin, stdout, stderr;
#include	"printf.h"
#endif

/* fundamental constants */
#define	CHARWORDBITS	16
#define	BYTESIZE	8
#define	MAXFN		16		/* max length of filenames */

/* default memory allocation */
#define	PROGMAX		21000
#define	GLOBMAX		400
#define	LABMAX		500

/* Intcode instructions */
#define	OP_L		0
#define	OP_S		1
#define	OP_A		2
#define	OP_J		3
#define	OP_T		4
#define	OP_F		5
#define	OP_K		6
#define	OP_X		7

/* codeword layout */
#define	FSHIFT		12
#define	DBIT		(1<<15)
#define	IBIT		(1<<10)
#define	GBIT		(1<<9)
#define	PBIT		(1<<8)
#define	ABITS		((1<<8)-1)

/* some initial instructions */
#ifdef	unix
#define	op(x)		(x<<FSHIFT)
#define	LIG1		(op(OP_L)|IBIT|GBIT|1)
#define	K2		(op(OP_K)|2)
#define	X22		(op(OP_X)|22)
#define	X100		(op(OP_X)|100)
#endif

#ifdef	cware
#define	op(x)		(x<<FSHIFT)
#define	LIG1		(op(OP_L)|IBIT|GBIT|1)
#define	K2		(op(OP_K)|2)
#define	X22		(op(OP_X)|22)
#define	X100		(op(OP_X)|100)
#endif

#ifdef	c80
/* gee what a stupid macro processor */
#define	LIG1		((OP_L<<FSHIFT)|IBIT|GBIT|1)
#define	K2		((OP_K<<FSHIFT)|2)
#define	X22		((OP_X<<FSHIFT)|22)
#define	X100		((OP_X<<FSHIFT)|100)
#endif

#ifdef	unix
typedef	short	word;
#endif

#ifdef	cware
typedef	short	word;
#endif

#ifdef	c80
#define	word	short
#define	unsigned
/* apparently asm mnemonics cannot be used as vars, how silly */
#define	cp	ccp
#define	stc	storec
/* why they want to be non-standard I don't know */
#define	malloc	alloc
#endif

EXT int	ch, cp;
EXT int	MAXMEM;
EXT word	*mem;
EXT int	progvec, globvec, labvec;
EXT int	pp, gp;
EXT int	cyclecount, linecount;

#ifdef	profiling
EXT int	majinstr[8];
EXT int	mininstr[38];
#endif
