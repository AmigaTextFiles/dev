/* bcpllib.c - An interface between C programs and BCPL
Compile with Manx 3.4:
cc bcpllib
By Bill Kinnersley - Dec 18, 1987
Mail:   Physics Dept.
        Montana State University
        Bozeman, MT 59717
BITNET: iphwk@mtsunix1
INTERNET: iphwk%mtsunix1.bitnet@cunyvm.cuny.edu
UUCP: ...psuvax1!mtsunix1.bitnet!iphwk
*/
#include <libraries/dosextens.h>
#include <functions.h>
#include <exec/memory.h>

long a0[3], *a1, *a, b[500];

BCPLInit() {
        struct DosLibrary *doslib;
        struct Task *mytask;
        long *splower;

        doslib = (struct DosLibrary *)OpenLibrary("dos.library",0L);
/*      mytask = FindTask(0L);
        splower = (long *)mytask->tc_SPLower;
        printf("splower = %lx\n",splower);*/
        a0[0] = doslib->dl_A2;
        a0[1] = doslib->dl_A5;
        a0[2] = doslib->dl_A6;
        a1 = (long *)AllocMem(2000L,MEMF_CLEAR);
        /*splower; a1+=200;*/
        a = &a1[3];
}

BCPLQuit() {
        FreeMem(a1,2000L);
}

long BCPL(n) long n; {
#asm
;       move.l  8(a7),d0
        movem.l d4-d7/a2-a5,-(a7)
        movea.l a7,a0
        adda.l  #40,a0
        movem.l (a0),d0-d4
        adda.l  #4,a0
        movea.l _a,a1
        moveq   #9,d5
l1:     move.l  (a0)+,(a1)+
        dbf     d5,l1
;       movea.l _a,a1
;       movem.l (a1),d1-d4
        movea.l _a1,a1
        lea     _a0,a0
        movem.l (a0)+,a2/a5-a6
        suba.l  a0,a0
        move.l  0(a2,d0.l),a4
        moveq   #$c,d0
        jsr     (a5)
        move.l  d1,d0
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
