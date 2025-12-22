/* hello.c - an example of calling the BCPL library from C
Compile and link with Manx 3.4:
  cc hello
  ln hello.o bcpllib.o -lc
Author: Bill Kinnersley
Date: Mar 12, 1988
Mail:   Physics Dept.
        Montana State University
        Bozeman, MT 59717
        BITNET: iphwk@mtsunix1
        INTERNET: iphwk%mtsunix1.bitnet@cunyvm.cuny.edu
        UUCP: ...psuvax1!mtsunix1.bitnet!iphwk
*/
#include <stdio.h>
#include <exec/memory.h>
#include <libraries/dosextens.h>
#include "bcpl.h"

void *AllocMem();
extern long *a;

main() {
        long proc, root, n, num;
        struct Process *mytask;
        char *s, *t, *buf;
        BPTR bs, bt;

        BCPLInit();

        /*s = "Not is the time"; t = "NoT is the time";
        bs = MakeBSTR(s); bt = MakeBSTR(t); num = BCPL(STRCMP,bs,bt);
        printf("returned %ld\n",num); FreeBSTR(bs); FreeBSTR(bt);*/

        proc = BCPL(FINDTASK); printf("My CLI Process is at %lx\n",proc);
        root = BCPL(FINDROOT); printf("The root is at %lx\n", root);

        s = "Here's a tab:%T5, a signed:%N, and an unsigned:%U8\n";
        bs = MakeBSTR(s);
        BCPL(WRITEF, bs, -1L, -1L); BCPL(NEWLINE);
        FreeBSTR(bs);

        /*num = BCPL(RDCH); num = BCPL(RDCH); BCPL(WRCH,num);BCPL(NEWLINE);*/
        /*buf = (char *)AllocMem(80L,MEMF_PUBLIC);
        num = BCPL(READIN,bptr(buf),80L);
        BCPL(WRITEOUTB,bptr(buf),num); FreeMem(buf,80L);*/
        /*num = BCPL(READN); printf("num=%ld\n",num);*/
        /*n = BCPL(MOD, 23L, 5L); printf("n=%ld\n", n);*/

        BCPLQuit();
}
