/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  imem.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*		imem.c		RD, 05.04.90	*/

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>

#define I_STATISTICS

_VOID_ Iprint_statistics(_VOID_)
{
}

char * Imalloc(i)
	int i;
{	return (char*)MYMALLOC(i);
}

void Ifree(u)
	char * u;
{	MYFREE(u);
}

/*#define MEMLISTMAX 16*/
#define MEMLISTMAX 32
#define MEMLISTMIN 2

typedef union uMemEl {
        union uMemEl *next;
        PLACE mem;
} MemEl, *pMemEl;

typedef struct sMemList {
        pMemEl free;
        int size;
} tMemList;

static tMemList MemList[MEMLISTMAX];
static BOOLEAN MemListInit=FALSE;

#ifdef I_STATISTICS
static long	Ivec_used[MEMLISTMAX];
static long	Ivec_allocated[MEMLISTMAX];
#endif

PLACE * newvec(maxl)
        int *maxl;
{       register int i; 
        register pMemEl u;
        register int a, ml;
        if (!MemListInit) {
                int j=2;
		MemListInit=TRUE;
                for (i=1; i<MEMLISTMAX; i++) {
                        MemList[i].size=j;
			MemList[i].free=NULL;
                        j<<=1;
#ifdef I_STATISTICS
			Ivec_used[i]=0;
			Ivec_allocated[i]=0;
#endif
                }
	}
        a=*maxl;
        i=MEMLISTMIN;
	if (a) {
	    a--;
	    a>>=i;
	    while(a) {
                a>>=1;
                i++;
	    }
	    if (i>=MEMLISTMAX)
		Ierror("newvec: exceeded MEMLISTMAX\n");
	}
        ml=MemList[i].size;
        *maxl=ml;
        u=MemList[i].free;
        if (u) {
                MemList[i].free=u->next;
#ifdef I_STATISTICS
		Ivec_used[i]++;
#endif
                return (pPLACE)u;
        } else {
                u=(pMemEl)MYMALLOC(ml*sizeof(PLACE));
		if (!u) {
		    int j;
		    for (j=1; j<MEMLISTMAX; j++) {
			while (u=MemList[j].free) {
			    MemList[j].free=u->next;
			    MYFREE((char *)u);
			}
		    }
		    u=(pMemEl)MYMALLOC(ml*sizeof(PLACE));
		    if(!u) {
#ifdef I_STATISTICS
			Iprint_statistics();
#endif
			Ierror("newvec: memory full\n");
		    }
		}
#ifdef I_STATISTICS
		Ivec_used[i]++;
		Ivec_allocated[i]++;
#endif
                return (pPLACE)u;
}       }               /* newvec */

void delvec(u, maxl)
        PLACE * u; register int maxl;
{       register int i;
	register pMemEl v;
	v=(pMemEl) u;
        i=MEMLISTMIN;
	maxl--;
	maxl>>=i;
	while(maxl) {
                maxl>>=1;
                i++;
        }
        v->next=MemList[i].free;
        MemList[i].free=v;
#ifdef I_STATISTICS
	Ivec_used[i]--;
#endif
}		/* delvec */

/*************************************/

static Integer * Ifreelist=NULL;

#ifdef I_STATISTICS
static long	Ihead_used=0;
static long	Ihead_allocated=0;
#endif

Integer * newInteger()
{       register Integer * u;
	if (Ifreelist) {
		u=Ifreelist;
		Ifreelist=(Integer *)(u->vec);
#ifdef I_STATISTICS
		Ihead_used++;
#endif
		return u;
	} else {
		u=(Integer *) MYMALLOC(sizeof(Integer));
		if (!u) {
#ifdef I_STATISTICS
			Iprint_statistics();
#endif
			Ierror("newInteger: memory full\n");
		}
#ifdef I_STATISTICS
		Ihead_used++;
		Ihead_allocated++;
#endif
		return u;
	}
}		/* newInteger */

void delInteger(u)
	register Integer *u;
{	u->vec = (PLACE *) Ifreelist;
	Ifreelist=u;
#ifdef I_STATISTICS
		Ihead_used--;
#endif
}		/* delInteger */

/*
#ifdef I_STATISTICS
_VOID_ Iprint_statistics(_VOID_)
{	int i;
	fprintf(stderr,"\nInteger memory management statistics:\n");
	fprintf(stderr,"Integer structs: %ld allocated, %ld used.\n",
		Ihead_used, Ihead_allocated);
	fprintf(stderr,
		"  size(PLACEs)  size(bytes)   allocated     used\n");
	for (i=1; i<MEMLISTMAX; i++) {
		fprintf(stderr, "%10d    %10d    %10ld    %10ld\n",
			MemList[i].size, MemList[i].size*sizeof(PLACE),
			Ivec_allocated[i], Ivec_used[i]);
	}
}
#else
_VOID_ Iprint_statistics(_VOID_)
{
}
#endif
*/
