/* Mynewcli.c - a C language replacement for NEWCLI
Compile and link with Manx 3.4:
  cc mynewcli
  ln mynewcli.o bcpllib.o -lc
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

long *gv;
struct rsdnt {
        BPTR    next;
        long    count;
        BPTR    seg;
        char    length;
        char    name[1];
};

struct pathlist {
        BPTR next;
        BPTR lock;
};

long cli_init();
struct pathlist *copypath();

main(argc, argv) char *argv[]; {
        struct RootNode *root;
        struct DosLibrary *doslib;
        struct DosInfo *dosinfo;
        struct rsdnt *list;
        struct pathlist *sub;
        struct MsgPort *fst;
        struct Process *myproc, *newproc;
        struct CommandLineInterface *cli;
        struct DosPacket *pkt;
        struct FileLock *lock;
        long clitask, *tskarr, taskno;
        long stsz, sz, *oldseglist, *newseglist, res;
        BPTR cd=0, procname=0;
        char *wdwname;
        short i, len;

        BCPLInit();
        myproc = (struct Process *)FindTask(0L);
        stsz = myproc->pr_StackSize;
        cli = (struct CommandLineInterface *)BADDR(myproc->pr_CLI);
        gv = (long *)myproc->pr_GlobVec;

        oldseglist = (long *)BADDR(myproc->pr_SegList);
        newseglist = (long *)AllocMem(24L, MEMF_CLEAR);
        *newseglist = 24;
        newseglist++;
        for (i=0; i<4; i++) newseglist[i] = oldseglist[i];

        doslib = (struct DosLibrary *)OpenLibrary("dos.library", 0L);
        root = (struct RootNode *)doslib->dl_Root;
        tskarr = (long *)BADDR(root->rn_TaskArray);
        dosinfo = (struct DosInfo *)BADDR(root->rn_Info);

        for (list = (struct rsdnt *)BADDR(dosinfo->di_NetHand);
                list; list = (struct rsdnt *)BADDR(list->next))
                if (strcmp("CLI", list->name)==0) {
                        newseglist[4] = list->seg;
                        if (list->count != -1) list->count++;
                        break;
                }

        wdwname = (argc>1) ? argv[1] : "CON:0/0/640/100/MyNewCLI";

        Forbid();
        sz = tskarr[0];
        for (taskno=1; taskno<=sz; taskno++) if (!tskarr[taskno]) break;
        if (taskno>sz) {
                Permit();
                FreeMem(--newseglist, 24L);
                printf("Too many tasks\n");
                goto failure;
        }
        stsz = 3000;
        procname = MakeBSTR("MyNewCLI");
        if (!(clitask = BCPL(CREATEPROCB, bptr(newseglist), stsz>>2, 0L,
                procname, bptr(gv)))) {
                Permit();
                FreeMem(--newseglist, 24L);
                printf("Unable to create new process\n");
                goto failure;
        }
        tskarr[taskno] = (long)clitask;
        newproc =(struct Process *)((long)clitask-(long)sizeof(struct Task));
        newproc->pr_TaskNum = taskno;
        Permit();

        cd = DupLock(myproc->pr_CurrentDir);

        if (sub = copypath(cli->cli_CommandDir)) {
                lock = (struct FileLock *)BADDR(sub->lock);
                fst = lock->fl_Task;
        }
        else fst = (struct MsgPort *)myproc->pr_FileSystemTask;

        if (BCPL(SENDPKT, 0L, clitask, cli_init, -1L, 0L, cd,
                wdwname, bptr(sub), bptr(cli), fst))
                {FreeBSTR(procname); BCPLQuit(); exit(0);}

        printf("Unable to Open Window\n");
failure:
        printf("MyNewCLI Failed\n");
        if (cd) UnLock(cd);
        if (taskno) tskarr[taskno] = 0;
        if (list) if (list->count != -1) list->count--;
        if (procname) FreeBSTR(procname);
        BCPLQuit();
        exit(20);
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

struct clistartup {
        long notused[5];
        BPTR curdir, window, path, oldCLI;
        APTR FSTask;
};

extern long a0[3];
long retval;
long cli_init(arg) BPTR arg; {
        struct clistartup *pkt; /* this MUST be the first local */
        struct Process *mytask;
        struct CommandLineInterface *oldcli, *mycli;
        struct FileHandle *fh;
        BPTR input, output;
        long saveres, *array, max, i, putpkt, remtask;
        char *bstr, *prompt, *newprompt, *curdir, *newcurdir;

#asm
        movem.l a1/a3,-(a7)
        asl.l   #2,d1
        move.l  d1,-4(a5)       ;this initializes pkt */
#endasm
        geta4();
        remtask = gv[34];
        putpkt = gv[42];

        oldcli = (struct CommandLineInterface *)BADDR(pkt->oldCLI);
        prompt = (char *)BADDR(oldcli->cli_Prompt);
        curdir = (char *)BADDR(oldcli->cli_SetName);

        mytask = (struct Process *)FindTask(0L);
        mycli = (struct CommandLineInterface *)BADDR(mytask->pr_CLI);
        newprompt = (char *)BADDR(mycli->cli_Prompt);
        newcurdir = (char *)BADDR(mycli->cli_SetName);
        mytask->pr_CurrentDir = pkt->curdir;
        mytask->pr_FileSystemTask = pkt->FSTask;
        mytask->pr_WindowPtr = 0L;

        if (!(input = Open(pkt->window, MODE_OLDFILE))) {
                saveres = mytask->pr_Result2;
                returnpkt(pkt, 0L, saveres);
                mytask->pr_Result2 = saveres;
                retval = remtask;
                goto ret;
        }
        if (!IsInteractive(input)) {
                Close(input);
                mytask->pr_Result2 = 206;
                input = 0L;
        }
        mycli->cli_StandardInput = input;
        mytask->pr_CIS = input;

        fh = (struct FileHandle *)BADDR(input);
        mytask->pr_ConsoleTask = (APTR)fh->fh_Type;

        if (!(output = Open("*", MODE_NEWFILE))) {
                Close(input);
                saveres = mytask->pr_Result2;
                returnpkt(pkt, 0L, saveres);
                mytask->pr_Result2 = saveres;
                retval = remtask;
                goto ret;
        }
        mycli->cli_StandardOutput = output;
        mytask->pr_COS = output;
        mycli->cli_CurrentInput = mycli->cli_StandardInput;
        mycli->cli_CurrentOutput = mycli->cli_StandardOutput;
        mycli->cli_Background = 0;
        mycli->cli_CommandDir = pkt->path;
        mycli->cli_ReturnCode = 0;
        mycli->cli_FailLevel = oldcli->cli_FailLevel;
        mycli->cli_Result2 = 0;
        bstr = (char *)BADDR(mycli->cli_CommandFile);
        bstr[0] = 0;
        mycli->cli_DefaultStack = oldcli->cli_DefaultStack;
        mycli->cli_Module = 0;

        max = prompt[0];
        for (i=0; i<=max; i++) newprompt[i] = prompt[i];

        max = curdir[0];
        for (i=0; i<=max; i++) newcurdir[i] = curdir[i];

        printf("New CLI Task %ld\n", mytask->pr_TaskNum);
        array = (long *)BADDR(mytask->pr_SegList);
        array[3] = 0;
        mytask->pr_Result2 = bptr(pkt);
        retval = putpkt;
/* After we return, the new CLI will call retval with argument pr_Result2 */
ret:    ;
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

returnpkt(pkt, res1, res2) struct DosPacket *pkt; long res1, res2; {
        struct Message *msg;
        struct MsgPort *port;

        port = pkt->dp_Port;
        msg = pkt->dp_Link;
        msg->mn_Node.ln_Name = (char *)pkt;
        msg->mn_Node.ln_Succ = msg->mn_Node.ln_Pred = 0L;
        pkt->dp_Res1 = res1;
        pkt->dp_Res2 = res2;
        PutMsg(port, msg);
}

/*struct DosPacket *taskwait() {
        struct Process *mytask;
        struct MsgPort *myport;
        struct Message *msg;

        mytask = (struct Process *)FindTask(0L);
        myport = &mytask->pr_MsgPort;
        WaitPort(myport);
        msg = GetMsg(myport);
        return((struct DosPacket *)msg->mn_Node.ln_Name);
}*/
