/*************************************************
 ** MuContextTest                               **
 **                                             **
 ** Build a task with a private context and its **
 ** own page size                               **
 **                                             **
 ** © 1999 THOR-Software                        **
 ** Version 1.01        01.06.1999              **
 *************************************************/

/// Includes
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#include <dos/dosextens.h>

/* MMU specific includes */
#include <mmu/mmutags.h>
#include <mmu/context.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/mmu.h>

#include <string.h>
///
/// Defines

/* This is the location we will remap accesses to. Should be
   available on all systems. */
#define TESTLOCATION 0x80000000
///
/// Protos

/* prototyping */

long __saveds main(void);
void MMUTaskTest(void);
void RunTests(struct MMUContext *privctx,UBYTE *testpage,UBYTE *pother);
void Sync(struct MsgPort *destination,struct Message *msg);
void __saveds TestProc(void);
///
/// Statics

/* Just the library bases we need */
char version[]="$VER: MuContextTest 1.02 (1.6.99) ©THOR";

struct MMUBase *MMUBase;
struct DosLibrary *DOSBase;
struct ExecBase *SysBase;
///

/// main
long __saveds main(void)
{
long err,rc;

        /* This program compiles without startup code, hence we have
           to setup ourselfs */

        SysBase=*((struct ExecBase **)(4L));
        rc=20;

        /* open the required libraries */

        if (DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",37)) {

                if (MMUBase=(struct MMUBase *)OpenLibrary("mmu.library",0L)) {

                        err=ERROR_REQUIRED_ARG_MISSING;

                        /* Check for a valid MMU. The mmu.library will also
                           open without! */

                        if (!GetMMUType()) {
                                Printf("MuFastRom requires a working MMU.\n");
                                err=10;
                        } else {
                                /* Run the tests */
                                MMUTaskTest();
                                err=0;
                        }

                        /* Check for error codes. Everything below 64
                           is considered to be a custom error and
                           passed thru as primary result code. */
                        if (err<64) {
                                rc=err;
                                err=0;
                        } else {
                                PrintFault(err,"MuContextTest failed");
                                rc=10;
                        }
                        SetIoErr(err);

                        /* Shut down: Close libraries */
                        CloseLibrary((struct Library *)MMUBase);
                } else PrintFault(ERROR_OBJECT_NOT_FOUND,"MuContextTest");
                CloseLibrary((struct Library *)DOSBase);
        }

        return rc;
}
///
/// MMUTaskTest
void MMUTaskTest(void)
{
struct MMUContext *ctx,*privctx;
UBYTE *testpage,*physical;
ULONG size,psize;
ULONG pother=TESTLOCATION;
ULONG error=0;

        /* This is the TRUE test, finally. */


        /* Get the public default context as template for the new
           context */
        Printf("Locating the default context...\n");
        ctx=DefaultContext();

/*
#define TL      0x90000000
#define PS      0x00001000

        SetProperties(ctx,MAPP_BUNDLED,MAPP_BUNDLED,TL+PS,PS*2,MAPTAG_DESTINATION,TL,TAG_DONE);
        SetProperties(ctx,MAPP_BUNDLED,MAPP_BUNDLED,TL+PS*5,PS*2,MAPTAG_DESTINATION,TL,TAG_DONE);
*/

        Printf("Building a new context...\n");
        if (privctx=CreateMMUContext(MCXTAG_COPY,ctx,
                /* make a copy of the already existing context */
                                     MCXTAG_PAGEBITS,13,
                /* but use 8K pages */
                                     MCXTAG_ERRORCODE,&error,
                /* and deliver an error code */
                                     TAG_DONE)) {

                /* I don't check here for an error, even though I should.
                   The library will build the context, provided there is
                   enough memory and the parameters are valid for the hard-
                   ware, but "error" should be checked for problems
                   the library found. This is only required if you tried
                   to make a table setup different to the default - here
                   the 8K pages. "error" should be checked for
                   CCERR_UNALIGNED. In this case, the mmu.library had to
                   round some descriptors heavely to be 8K aligned and the
                   resulting page setup is most likely not what you want.
                   For example, MAPP_REMAPPED pages have been trimmed, and
                   the setup is therefore incorrect at the boundary. */

                /* Find out the page size of this page. Well, we know
                   it is 8K, right? */
                size=GetPageSize(privctx);
                Printf("Getting the new page size. It is 0x%lx bytes.\n",size);

                /* allocate a test page */
                testpage=AllocAligned(size,MEMF_PUBLIC,size);
                if (testpage) {
                        /* Find out the physical location of this page.
                           Note that we use the public context since this
                           is the context we're running in. The other
                           context has not yet been loaded. */
                        physical=testpage;
                        psize=size;
                        Printf("Allocating a test page.\n");
                        PhysicalLocation(ctx,(void **)&physical,&psize);
                        if (psize==size) {

                                /* remap (mirror) it to pother. This is just
                                   for demonstrational purposes. */
                                Printf("Mirroring the page at 0x%08lx (0x%08lx phys.) to 0x%08lx\n",testpage,physical,pother);

                                if (SetProperties(privctx,MAPP_COPYBACK|MAPP_REMAPPED,~0,
                                                   pother,size,MAPTAG_DESTINATION,physical,TAG_DONE)) {

                                        /* the above call modified only the software abstraction
                                           level. Now rebuild the MMU tree for the private
                                           context to reflect the changes */


                                        Printf("Building a new MMU tree for the private context...\n");
                                        if (RebuildTree(privctx)) {

                                                /* and run the test */
                                                RunTests(privctx,testpage,(UBYTE *)pother);
                                                /* all the rest is shutdown code */

                                        } else Printf("Can't rebuild the tree.\n");
                                } else Printf("Failed to setup memory remapping.\n");
                        } else Printf("Can't handle fragmented memory.\n");

                        /* release the test page */

                        Printf("Releasing the test page.\n");
                        FreeMem(testpage,size);
                } else Printf("Failed to allocate a test page.\n");

                /* ... and the context */

                Printf("Releasing the private context.\n");
                DeleteMMUContext(privctx);

        } else Printf("Failed to build the MMUTaskTest.\n");

}
///
/// RunTests
void RunTests(struct MMUContext *privctx,UBYTE *testpage,UBYTE *pother)
{
struct Process *proc;
struct Message *msg;
struct Task *testtask,*mytask;
struct MsgPort *testport;
int i;

        /* given the MMU context created above, create a new task
           and run it in this context */

        /* Build a message with our process port as reply port. I'm here
           to lazy to setup a message port since we already have one. */

        mytask=FindTask(NULL);
        Printf("Building a new IO request for the test.\n");
        msg=CreateIORequest(&(((struct Process *)mytask)->pr_MsgPort),sizeof(struct IORequest));
        if (msg) {

                /* build a new process. It will start in the default
                   public context, but we will push it to the private
                   context as soon as it is set up. */

                Printf("Creating a new task, in the public context.\n");
                if (proc = CreateNewProcTags(   NP_Entry,&TestProc,
                                                NP_CurrentDir,NULL,
                                                NP_StackSize,512,
                                                NP_Name,"MuContextTest.task",
                                                NP_Priority,0,
                                                NP_ConsoleTask,NULL,
                                                NP_HomeDir,NULL,
                                                NP_CopyVars,FALSE,
                                                TAG_DONE)) {

                        /* Get the task (uhm, complicated) and its
                           process message port we use here for
                           communications */

                        testtask=&(proc->pr_Task);
                        testport=&(proc->pr_MsgPort);

                        /* This is the trick: Let the tast enter the
                           private context. From now on, the library will
                           exchange MMU trees on task switches, performing
                           TRUE "context switches". */

                        Printf("Let the task enter the private context.\n");
                        if (EnterMMUContext(privctx,testtask)) {

                                /* This demonstrates that the library keeps
                                   caches consistently across contexts. They
                                   will be flushed correctly on a context
                                   switch. We pass a stupid message to the
                                   testtask, get it modified there and print
                                   it here. */

                                Printf("Setup a test string.\n");
                                strcpy(testpage,"A silly test.\n");

                                /* print the original */
                                Printf("%s",testpage);

                                msg->mn_Node.ln_Name=pother;
                                for (i=0;i<10;i++) {
                                        /* pass over the message to the
                                           test task */
                                        Sync(testport,msg);

                                        /* print the result */
                                        Printf("%s",testpage);

                                        /* and restore the final A */
                                        *testpage='A';
                                }

                        } else Printf("Failed to add the test task to the context.\n");

                        /* tell the task to commit suicide. It will
                           remove itself from the private context.
                           This step is important and must be performed
                           somewhere, or you'll have a memory leak. */

                        Printf("Signalling the task to unload.\n");
                        msg->mn_Node.ln_Name=NULL;
                        Sync(testport,msg);

                } else Printf("Can't run child task.\n");

                Printf("Clean up the message.\n");
                DeleteIORequest((struct IORequest *)msg);
        } else Printf("Can't build communication message.\n");

}
///
/// Sync
void Sync(struct MsgPort *destination,struct Message *msg)
{
struct Task *mytask;
struct MsgPort *port;

        /* stupid sync between the calling task and the background
           task */

        mytask=FindTask(NULL);
        port=&(((struct Process *)mytask)->pr_MsgPort);

        PutMsg(destination,msg);
        WaitPort(port);
        GetMsg(port);

}
///
///TestProc
void __saveds TestProc(void)
{
int i=0;
struct Message *msg=NULL;
struct MsgPort *port;

        /* this is now the test task. Note that we have here our own
           MMU table. */

        port=&(((struct Process *)(FindTask(NULL)))->pr_MsgPort);
        for(;;) {
                WaitPort(port);
                msg=GetMsg(port);
                /* get the next message */

                /* end? If so, commit suicide */
                if (msg->mn_Node.ln_Name==NULL)
                        break;

                /* if not, just do something to make us known to the
                   user */
                (*(msg->mn_Node.ln_Name)) += i;
                i++;
                ReplyMsg(msg);
        }

        /* The next step is important: We shut down, and hence have to
           leave the private context. */
        LeaveMMUContext(FindTask(NULL));

        /* We're done. Make sure main doesn't unload us before we're
          shut down. */
        Forbid();
        ReplyMsg(msg);
}
///

