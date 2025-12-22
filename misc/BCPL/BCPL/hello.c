/* hello.c - An Example Of Calling The BCPL Library From C
/*
/* Compile and link with Manx 3.4:
/*  cc hello
/*  ln hello.o bcpllib.o -lc
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

#include <stdio.h>
#include <exec/memory.h>
#include <libraries/dosextens.h>
#include "BCPL.h"

void *AllocMem();
extern long *a;

main() {
	long proc, root, n, num;
	struct Process *mytask;
	char *s, *t, *buf;
	BPTR bs, bt;

	BCPLInit();

	proc = BCPL(FINDTASK); printf("My CLI Process is at %lx\n",proc);
	root = BCPL(FINDROOT); printf("The root is at %lx\n", root);

	s = "Here's a tab:%T5, a signed:%N, and an unsigned:%U8\n";
	bs = MakeBSTR(s);
	BCPL(WRITEF, bs, -1L, -1L); BCPL(NEWLINE);
	FreeBSTR(bs);

	BCPLQuit();
}
