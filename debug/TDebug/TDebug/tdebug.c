
/*
 *  TDEBUG.C
 *
 *  (C)Copyright 1987 Matthew Dillon, All Rights Reserved
 *  FreeWare.  May be distributed for non-profit only.
 *
 *  Debug any device .. usually trackdisk.device
 *
 *  AZTEC USERS:   MUST COMPILE  +CDL and LINK WITH THE LARGE EVERYTHING
 *  LIBRARY!!!! (cl32.lib).  NOTE: This source expects all the amiga
 *  symbols to be preloaded.  NOTE: There are some function calls in this
 *  source which you don't have... the functions should be obvious and
 *  easy to implement.
 *
 *  Sorry, no support for lattice.  A smart programmable will be able to
 *  split the assembly file and do all the right #includes.
 *
 */

#define FIFO	struct _FIFO

typedef struct ExecBase EB;
typedef struct List	LIST;
typedef struct Node	NODE;
typedef struct IOStdReq STD;
typedef struct Task	TASK;

FIFO {
    FIFO    *next;	    /* next element */
    STD     std;	    /* IO request   */
};

extern EB *SysBase;
extern NODE *findlist();
extern TASK *FindTask();
extern char *AllocMem();

FIFO *Base, **Lnext = &Base;

NODE *Nodearray[64];

NODE *Ntrack;
NODE *Nasdg;

TASK *Mastertask;
long Operations;	    /* # operations monitored	*/
long Mask, Signum;

char *Stdname[] = {
    "INVALID", "RESET", "READ", "WRITE", "UPDATE", "CLEAR", "STOP",
    "START", "FLUSH"
};

main(ac, av)
char *av[];
{
    register FIFO *fifo;
    register long result;

    disablebreak();
    Mastertask = FindTask(0);
    Signum = AllocSignal(-1);
    Mask = 1 << Signum;
    loadnodearray(ac, av);	/* which devices to intercept?	*/

    overidevector(1);
    puts ("Now intercepting all DoIO() and SendIO() operations");
    puts ("");
    puts ("Device__         Cmd_ Len_____");
    SetSignal(0, SIGBREAKF_CTRL_C|SIGBREAKF_CTRL_D);
    for (;;) {
	result = Wait(SIGBREAKF_CTRL_C|SIGBREAKF_CTRL_D|Mask);
	if (result & (SIGBREAKF_CTRL_C|SIGBREAKF_CTRL_D))
	    break;
	while (Base) {
	    long block, cmd;
	    char ext;

	    Forbid();
	    fifo = Base;
	    Base = Base->next;
	    if (Base == NULL)
		Lnext = &Base;
	    Permit();
	    printf ("%16s ", fifo->std.io_Device->dd_Library.lib_Node.ln_Name);
	    cmd = fifo->std.io_Command;
	    ext = ' ';
	    if (cmd & TDF_EXTCOM) {
		cmd &= ~TDF_EXTCOM;
		ext = 'E';
	    }
	    if (fifo->std.io_Command < CMD_NONSTD)
		printf ("%lc%-7s ", ext, Stdname[fifo->std.io_Command]);
	    else
		printf (" NON+%lc%-2ld ", ext, fifo->std.io_Command - CMD_NONSTD);
	    printf ("%-8ld %-8ld ", fifo->std.io_Length, fifo->std.io_Offset);
	    if (fifo->std.io_Device == Ntrack || fifo->std.io_Device == Nasdg) {
		block = fifo->std.io_Offset / 512;
		printf ("Blk#: %-5ld ", block);
		printf ("(Trk %2ld  Cyl %2ld) ", block/22, (block/11)&1);
	    }
	    puts("");
	    FreeMem(fifo, sizeof(*fifo));
	}
    }
    puts ("Restoring intercept vector");
    overidevector(0);
    Delay(50);
    while (Base) {
	fifo = Base->next;
	FreeMem(Base, sizeof(*Base));
	Base = fifo;
    }
    FreeSignal(Signum);
    printf ("%ld operations monitored\n", Operations);
}


loadnodearray(ac, av)
char *av[];
{
    register int i;
    register int j;
    register NODE *node;
    register LIST *list = &SysBase->DeviceList;

    Ntrack = findlist(list, "trackdisk.device");
    Nasdg  = findlist(list, "asdg.vdisk.device");
    if (ac == 1) {
	puts ("TDEBUG V1.00  By Matthew Dillon");
	puts ("(C)Copyright 1987 Mathew Dillon, All Rights Reserved");
	puts ("CTRL-C, CTRL-D, or BREAK to terminate");
	puts ("");
	puts ("tdebug device device...");
	puts ("tdebug trackdisk.device");
	puts ("");
	showlist(list);
	puts ("");
	exit(1);
    }
    for (i = 1, j = 0; av[i]; ++i) {
	node = findlist(list, av[i]);
	if (!node)
	    printf ("Unable to find: %s\n", av[i]);
	else
	    Nodearray[j++] = node;
    }
}


NODE *
findlist(list, name)
LIST *list;
char *name;
{
    register NODE *node;

    for (node = list->lh_Head; node != &list->lh_Tail; node = node->ln_Succ) {
	if (strcmp(name, node->ln_Name) == 0)
	    return(node);
    }
    return(NULL);
}

showlist(list)
LIST *list;
{
    register NODE *node;

    for (node=list->lh_Head; node != &list->lh_Tail; node=node->ln_Succ) {
	puts(node->ln_Name);
    }
}



static long oldsendvec;
static long olddovec;

overidevector(n)
{
    extern char LVODoIO;
    extern char LVOSendIO;
    extern int newsendio(), newdoio();

    Forbid();
    if (n) {
	oldsendvec = SetFunction(SysBase, &LVOSendIO, newsendio);
	olddovec =   SetFunction(SysBase, &LVODoIO,   newdoio);
    } else {
	SetFunction(SysBase, &LVOSendIO, oldsendvec);
	SetFunction(SysBase, &LVODoIO,	 olddovec);
    }
    Permit();
}

/*
 *  NOTE!!! Since BeginIO is the basis for the entire operating system,
 *  we cannot do anything inside this routine that would ever use it.
 */

myio(ioreq)
register STD *ioreq;
{
    register FIFO *fifo;
    register int i;

    Forbid();
    for (i = 0; Nodearray[i]; ++i) {
	if (Nodearray[i] == ioreq->io_Device)
	    break;
    }
    if (Nodearray[i]) {
	if (fifo = (FIFO *)AllocMem(sizeof(*fifo), 0)) {
	    *Lnext = fifo;
	    Lnext = &fifo->next;
	    fifo->next = NULL;
	    fifo->std = *ioreq;
	}
	++Operations;
	Signal(Mastertask, Mask);
    }
    Permit();
}

#asm

_newsendio:
		movem.l D0-D7/A0-A6,-(sp)   ;save regs
		move.l	A1,-(sp)	    ;the io request
		jsr	_myio		    ;call my intercept routine
		addq.l	#4,sp
		movem.l (sp)+,D0-D7/A0-A6   ;restore regs
		move.l	_oldsendvec,A0	    ;A0 not used by SendIO
		jsr (A0)
		rts

_newdoio:
		movem.l D0-D7/A0-A6,-(sp)   ;save regs
		move.l	A1,-(sp)	    ;the io request
		jsr	_myio		    ;call my intercept routine
		addq.l	#4,sp
		movem.l (sp)+,D0-D7/A0-A6   ;restore regs
		move.l	_olddovec,A0	  ;A0 not used by SendIO
		jsr (A0)
		rts

#endasm

