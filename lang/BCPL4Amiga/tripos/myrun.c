/* Myrun.c - a C language replacement for RUN
Compile and link with Manx 3.4:
  cc myrun
  ln myrun.o bcpllib.o -lc
By Bill Kinnersley - Dec 18, 1987
Mail:   Physics Dept.
        Montana State University
        Bozeman, MT 59717
BITNET: iphwk@mtsunix1
INTERNET: iphwk%mtsunix1.bitnet@cunyvm.cuny.edu
UUCP: ...psuvax1!mtsunix1.bitnet!iphwk
*/
#include <stdio.h>
#include <libraries/dosextens.h>
#include <functions.h>
#include <exec/memory.h>
#include "BCPL.h"
#define DOSTRUE -1L

struct pathlist {
        BPTR next;
        BPTR lock;
};

long cli_init();
struct pathlist *copypath();
long *gv;

main() {
        struct RootNode *root;
        struct DosLibrary *doslib;
        struct Task *mytask;
        struct Process *myproc, *newproc;
        struct CommandLineInterface *cli;
        struct DosPacket *pkt;
        struct FileLock *lock;
        struct FileHandle *cis, *cos, *myfh;
        char *oldbuf, *mybuf;
        long clitask, *tskarr, taskno, end, size, *buf, i,
                stsz, sz, *mysegarray, *newsegarray, res, res2, pri;
        BPTR cd=0, procname=0;

        BCPLInit();
        myproc = (struct Process *)FindTask(0L);
        res2 = myproc->pr_Result2;
/* Here's where RUN finds the command line when called by EXECUTE
   Unfortunately, the Manx startup code overwrites Result2 */
        res2 = 0;
        cis = (struct FileHandle *)BADDR(myproc->pr_CIS);
        cos = (struct FileHandle *)BADDR(myproc->pr_COS);
        newproc = 0;
        newsegarray = (long *)AllocMem(20L, MEMF_PUBLIC);*newsegarray++ = 20;
        doslib = (struct DosLibrary *)OpenLibrary("dos.library", 0L);
        root = (struct RootNode *)doslib->dl_Root;
        tskarr = (long *)BADDR(root->rn_TaskArray);
        taskno = 0;
        mytask = &myproc->pr_Task;
        pri = mytask->tc_Node.ln_Pri;
        mysegarray = (long *)BADDR(myproc->pr_SegList);
        gv = (long *)myproc->pr_GlobVec;
        cli = (struct CommandLineInterface *)BADDR(myproc->pr_CLI);
        if (res2) {     /* called by EXECUTE */
                oldbuf = (char *)BADDR(res2);
                end = *oldbuf++;
        }
        else {
                end = cis->fh_End;
                oldbuf = (char *)BADDR(cis->fh_Buf);
        }
        size = 4L*(end/4L + 13L);
printf("end=%ld oldbuf=%lx bufsize=%ld\n", end, oldbuf, size);
        buf = (long *)AllocMem(size, MEMF_CLEAR); *buf++ = size;
        myfh = (struct FileHandle *)buf;
        mybuf = (char *)((long)myfh + 44L);
        for (i=0; i<end; i++) mybuf[i] = oldbuf[i];
        mybuf[end] = '\n';
for (i=0; i<=end; i++) printf("%c",mybuf[i]);
        newsegarray[0] = 4;
        newsegarray[1] = mysegarray[1];
        newsegarray[2] = mysegarray[2];
        newsegarray[3] = 0;
        newsegarray[4] = (long)root->rn_ConsoleSegment;
printf("copied segarray %ld %lx %lx %lx %lx\n",newsegarray[0],newsegarray[1],
newsegarray[2],newsegarray[3],newsegarray[4]);
        procname = MakeBSTR("Background CLI");
        stsz = 3200;
        Forbid();
        sz = tskarr[0];
        for (taskno=1; taskno<=sz; taskno++) if (!tskarr[taskno]) break;
        if (!(clitask = BCPL(CREATEPROCB, bptr(newsegarray), stsz>>2, pri,
                procname, bptr(gv)))) {
                if (taskno) tskarr[taskno] = 0;
                Permit();
                if (!res2) printf("RUN failed\n");
                FreeMem(newsegarray, 20L);
                FreeMem(myfh, size);
                FreeBSTR(procname);
                BCPLQuit();
                exit(20);
        }
printf("clitask=%lx\n",clitask);
        tskarr[taskno] = (long)clitask;
        newproc =(struct Process *)((long)clitask-(long)sizeof(struct Task));
        newproc->pr_TaskNum = taskno;
        Permit();
        myfh->fh_Buf = (long)bptr(mybuf);
        myfh->fh_End = end + 1L;
        cd = cli ? DupLock(myproc->pr_CurrentDir) : 0;
printf("ready to dospacket\n");
        if (!BCPL(SENDPKT, DOSTRUE, clitask, cli_init, 0L, 0L, bptr(cli),
                bptr(cis), bptr(cos), bptr(myfh), cd, res2))
                printf("[CLI %ld]\n", taskno);
printf("dospacketed\n");
        FreeBSTR(procname);
        BCPLQuit();
        exit(0);
}

struct clistartup {
        long unused[5];
        BPTR cli, cis, cos, fh, cd;
        long res2;
};

long retval;
long cli_init(arg) BPTR arg; {
        struct clistartup *pkt; /* this MUST be the FIRST local */
        struct Process *mytask;
        struct CommandLineInterface *oldcli, *mycli;
        struct FileHandle *fh, *input;
        BPTR output;
        long max, i, putpkt, flag, flagset, *mysegarr, inisint, outisint;
        char *prompt, *newprompt, *curdir, *newcurdir;

#asm
        movem.l a1/a3,-(a7)
        asl.l   #2,d1
        move.l  d1,-4(a5)       ;this initializes pkt */
#endasm
        geta4();
        oldcli = (struct CommandLineInterface *)BADDR(pkt->cli);
        fh = (struct FileHandle *)BADDR(pkt->fh);
        mytask = (struct Process *)FindTask(0L);
        mycli = (struct CommandLineInterface *)BADDR(mytask->pr_CLI);
        flag = !(pkt->res2);
        output = 0;
        inisint = FALSE;
        flagset = -4;
        mycli->cli_CurrentInput = mycli->cli_StandardInput = pkt->fh;
        if (!flag) {
                input = (struct FileHandle *)BADDR(pkt->cis);
                if (input) {
                        mycli->cli_StandardInput = pkt->cis;
                        mytask->pr_ConsoleTask = (APTR)input->fh_Type;
                        inisint = (long)input->fh_Port;
                        flagset |= 2;
                }
                output = pkt->cos;
        }
        if (!output) {
                flagset |= 1;
                output = Open("*", MODE_NEWFILE);
        }
        outisint = (long)((struct FileHandle *)BADDR(output))->fh_Port;
        mycli->cli_Background = (outisint && inisint) ? 0 : DOSTRUE;
        CurrentDir(pkt->cd);
        init(mycli, output, oldcli);
        mysegarr = (long *)BADDR(mytask->pr_SegList);
        mysegarr[3] = 0;
        retval = flag ? gv[42] /* putpkt */ : flagset;
printf("FINISHED retval=%lx\n", retval);
        mytask->pr_Result2 = bptr(pkt);
#asm
        dseg
        public  _a0
        cseg
        lea     _retval,a1
        move.l  (a1),d1
        lea     _a0,a0
        move.l  0(a0),a2
        move.l  8(a0),a6
        suba.l  a0,a0
        movem.l (a7)+,a1/a3
        unlk    a5
        jmp     (a6)
#endasm
}

init(cli, output, oldcli)
struct CommandLineInterface *cli, *oldcli; BPTR output; {
        long stsz, max, i;
        BPTR path, b;
        char *prompt, *curdir, *newprompt, *newcurdir, *bstr;

        b = oldcli ? oldcli->cli_Prompt : MakeBSTR("%N>");
        prompt = (char *)BADDR(b);
        newprompt = (char *)BADDR(cli->cli_Prompt);
        max = prompt[0];
        for (i=0; i<=max; i++) newprompt[i] = prompt[i];

        b = oldcli ? oldcli->cli_SetName : MakeBSTR("SYS:");
        curdir = (char *)BADDR(b);
        newcurdir = (char *)BADDR(cli->cli_SetName);
        max = curdir[0];
        for (i=0; i<=max; i++) newcurdir[i] = curdir[i];

        bstr = (char *)BADDR(cli->cli_CommandFile);
        bstr[0] = 0;

        stsz = oldcli ? oldcli->cli_DefaultStack : 1000;
        cli->cli_DefaultStack = stsz;

        path = oldcli ? bptr(copypath(oldcli->cli_CommandDir)) : 0;
        cli->cli_CommandDir = path;

        cli->cli_StandardOutput = cli->cli_CurrentOutput = output;
        cli->cli_FailLevel = 10;
}

struct pathlist *copypath(arg) BPTR arg; {
/* The PATH is stored in cli_CommandDir as a linked list of Locks */
/* Each newly created CLI must inherit the PATH of its creator */
        struct pathlist *oldlist, *newlist, *link, *lastlink;
        long *mem;

        newlist = NULL;
        lastlink = (struct pathlist *)&newlist;
        oldlist = (struct pathlist *)BADDR(arg);
        while (oldlist) {
                if (!(mem = (long *)AllocMem(12L, 1L))) break;
                mem[0] = 12L;
                link = (struct pathlist *)&mem[1];
                link->next = NULL;
                link->lock = DupLock(oldlist->lock);
                lastlink->next = bptr(link);
                lastlink = link;
                oldlist = (struct pathlist *)BADDR(oldlist->next);
        }
        return (struct pathlist *)(BADDR(newlist));
}
