/* bcpllib.c - An Interface Permitting Calls To The BCPL Library From C
/*
/* Compile using Manx 3.4a
/*	cc bcpllib.c
/*
/* Author: Bill Kinnersley
/* Date: Mar 12, 1988
/* Mail: Physics Dept.
/*	Montana State University
/*	Bozeman, MT 59717
/* BITNET: iphwk@mtsunix1
/* INTERNET: iphwk%mtsunix1.bitnet@cunyvm.cuny.edu
/* USENET: lll-crg!umt!mts-cs!uphwk
*/

#include <libraries/dosextens.h>
#include <functions.h>
#include <exec/memory.h>

long a0[3], /* for a copy of the BCPL registers */
	*a1,
	*a;

BCPLInit() {
	struct DosLibrary *doslib;
	struct Task *mytask;
	long *splower;

	doslib = (struct DosLibrary *)OpenLibrary("dos.library",0L);
	a0[0] = doslib->dl_A2;
	a0[1] = doslib->dl_A5;
	a0[2] = doslib->dl_A6;
	a1 = (long *)AllocMem(2000L, MEMF_CLEAR);
	a = &a1[3];
/* a points to memory allocated for my BCPL stack.
(Yes, I know, I could have put this on the process stack) */
}

BCPLQuit() {
	FreeMem(a1, 2000L);
}

long BCPL(n) long n; {
#asm
	movem.l	d4-d7/a2-a5,-(a7)
	movea.l	a7,a0
	adda.l	#40,a0
	movem.l (a0),d0-d4
	adda.l	#4,a0
	movea.l	_a,a1
	moveq	#9,d5
l1:	move.l	(a0)+,(a1)+
	dbf	d5,l1
	movea.l	_a1,a1
	lea	_a0,a0
	movem.l	(a0)+,a2/a5-a6
	suba.l	a0,a0
	move.l	0(a2,d0.l),a4
	moveq	#$c,d0
	jsr	(a5)
	move.l	d1,d0
	movem.l (a7)+,d4-d7/a2-a5
#endasm
}

BPTR MakeBSTR(s) char *s; {
	long len;
	char *bs;

	len = (long)strlen(s);
	bs = (char *)AllocMem(len+2L,MEMF_CLEAR);
	if (!bs) {printf("Can't allocate\n"); exit(0);}
	bs[0] = len;
	strcpy(&bs[1], s);
	return ((long)bs)>>2;
}

FreeBSTR(bs) long bs; {
	char *s;

	s = (char *)BADDR(bs);
	FreeMem(s,(long)(*s)+2L);
}
