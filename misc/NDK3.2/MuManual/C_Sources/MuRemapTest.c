/*************************************************
 ** MuRemapTest                                 **
 ** experimental MMU memory remapper            **
 **                                             **
 ** This program checks for correctness of the  **
 ** device drivers and correct MMU support      **
 **                                             **
 ** Note that device drivers have to call       **
 ** CachePreDMA() and CachePostDMA() to be      **
 ** notified about the TRUE physical addresses  **
 ** some devices might fail here                **
 **                                             **
 ** Version 40.0        26 May 1999             **
 ** © THOR Thomas Richter                       **
 *************************************************/

/// Includes
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/execbase.h>
#include <dos/dos.h>

/* MMU specific includes */
#include <mmu/mmubase.h>
#include <mmu/context.h>
#include <mmu/mmutags.h>

#include <workbench/startup.h>

#include <proto/exec.h>
#include <proto/mmu.h>
#include <proto/dos.h>
#include <proto/icon.h>
#include <string.h>
///
/// Defines
#define STRINGDATE "5.3.99"
#define STRINGVERSION "40.0"

/* Defines for the shell template */
#define TEMPLATE "TEMPFILE/A"

#define OPT_DEVICE 0
#define OPT_WINDOW 1
#define OPT_COUNT 2
///
/// Statics

/* just the library bases */
struct MMUBase *MMUBase;
struct DosLibrary *DOSBase;
struct ExecBase *SysBase;
struct Library *IconBase;
///
/// Protos

/* prototyping */
int __asm __saveds main(void);
struct RDArgs *ReadTTArgs(struct WBStartup *msg,LONG args[],struct RDArgs **tmp);
int CheckRemapping(char *filename);
BOOL SetRemap(struct MMUContext *ctx,struct MemHeader *physical,struct MemHeader *logical,ULONG size);
void FileTest(char *filename,void *physical,void *logical,ULONG size);
BOOL ForceRebuild(struct MMUContext *ctx);
struct MemHeader *MemHeaderOf(void *mem);
///

char version[]="$VER: MuRemapTest " STRINGVERSION " (" STRINGDATE ") © THOR";

/// main
int __asm __saveds main(void)
{
LONG args[OPT_COUNT];
struct RDArgs *rd,*myrd;
struct Process *proc;
int rc=20;
LONG err;
struct WBStartup *msg;
BPTR oldout;
struct MsgPort *oldconsole;


        /* This program is compiled without startup code, hence we have
           to setup ourselfs */

        SysBase=*((struct ExecBase **)(4L));

        /* clear the arguments */
        memset(args,0,sizeof(LONG)*OPT_COUNT);

        /* Wait for the workbench startup, if any */
        proc=(struct Process *)FindTask(NULL);

        if (!(proc->pr_CLI)) {
                WaitPort(&(proc->pr_MsgPort));
                msg=(struct WBStartup *)GetMsg(&(proc->pr_MsgPort));
        } else  msg=NULL;


        /* Open the libraries we need */

        if (DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",37L)) {
                if (MMUBase=(struct MMUBase *)OpenLibrary("mmu.library",0L)) {

                        err=ERROR_REQUIRED_ARG_MISSING;

                        myrd=NULL;      /* reset the temporary ReadArgs */
                        oldout=NULL;
                        oldconsole=NULL;

                        /* Check whether we're run from workbench or
                           shell. On a WBRun, we parse the tool types
                           and setup our own output stream, keeping
                           the old one - which will be NULL anyways... */

                        if (msg) {
                                oldout=SelectOutput(NULL);
                                oldconsole=SetConsoleTask(NULL);
                                rd=ReadTTArgs(msg,args,&myrd);
                        } else  rd=ReadArgs(TEMPLATE,args,NULL);

                        if (rd) {

                                /* Check for a working MMU. The mmu library
                                   will open anyways, even without one. */

                                if (!GetMMUType()) {
                                        Printf("MuRemapTest requires a working MMU.\n");
                                        err=10;
                                } else {
                                        /* Argument parser worked, call main routine */
                                        err=CheckRemapping((char *)(args[OPT_DEVICE]));
                                }

                                /* Shut down */

                                FreeArgs(rd);
                                if (myrd) FreeDosObject(DOS_RDARGS,myrd);
                                if (msg)  Close(SelectOutput(NULL));
                        } else  err=IoErr();

                        if (msg) {
                                SelectOutput(oldout);
                                SetConsoleTask(oldconsole);
                        }

                        /* we're done. Check for the result code. If
                           it is below 64, it is passed over as primary
                           result code. */

                        if (err<64) {
                                rc=err;
                                err=0;
                        } else {
                                if (!msg) PrintFault(err,"MuRemapTest failed");
                                rc=10;
                        }
                        SetIoErr(err);

                        CloseLibrary((struct Library *)MMUBase);
                } else PrintFault(ERROR_OBJECT_NOT_FOUND,"MuRemapTest requires the mmu.library");
                CloseLibrary((struct Library *)DOSBase);
        }

        return rc;
}
///
/// ReadTTArgs
struct RDArgs *ReadTTArgs(struct WBStartup *msg,LONG args[],struct RDArgs **tmp)
{
struct WBArg *wbarg;
struct DiskObject *dop;
char **tt;                      /* ToolTypes array */
char *wbstr;                    /* Our self-made workbench argument string */
char *here;
BPTR oldlock;
ULONG len;
struct RDArgs *rd=NULL,*myrd=NULL;
LONG err=0;
BPTR newout;


        /* Parse the tool type string for arguments...
           this is mainly Mike's code. */

        if (IconBase=OpenLibrary("icon.library",37L)) {
                if (wbarg=msg->sm_ArgList) {
                        /* use a project icon if there is one... */
                        if (msg->sm_NumArgs > 1) wbarg++;

                        /* go into the directory */
                        oldlock=CurrentDir(wbarg->wa_Lock);

                        if (dop=GetDiskObject(wbarg->wa_Name)) {
                                if (tt=dop->do_ToolTypes) {
                                        /* Read a special tool type for the output window */

                                        /* Calc the size of the argument string */

                                        len = 3;        /* reserve space for SPC,LF,NUL */
                                        while (*tt) {
                                                len += strlen(*tt)+1;   /* string, plus space */
                                                tt++;
                                        }

                                        if (wbstr=AllocVec(len,MEMF_PUBLIC)) {
                                                /* Now copy the arguments into this string, one by one
                                                   and check whether the argument string is still valid. */

                                                tt=dop->do_ToolTypes;
                                                here=wbstr;
                                                do{
                                                        *here='\0';                     /* terminate string */
                                                        /* Check whether this tool type is
                                                           commented out. Just ignore it in this case */
                                                        if (*tt) {
                                                                if (**tt=='(' || **tt==';')
                                                                        continue;

                                                                strcpy(here,*tt);      /* Add TT string */
                                                        }
                                                        len=strlen(here);
                                                        here[len]='\n';
                                                        here[len+1]='\0';               /* terminate string */

                                                        /* Now try to ReadArg' this string */

                                                        /* release old arguments left over from last loop */
                                                        if (rd) FreeArgs(rd);
                                                        if (myrd) FreeDosObject(DOS_RDARGS,myrd);
                                                        rd=NULL;
                                                        memset(args,0,sizeof(LONG)*OPT_COUNT);

                                                        if (myrd=AllocDosObject(DOS_RDARGS,NULL)) {
                                                                /* Allocate and setup the ReadArgs source */
                                                                myrd->RDA_Source.CS_Buffer=wbstr;
                                                                myrd->RDA_Source.CS_Length=strlen(wbstr);

                                                                if (rd=ReadArgs(TEMPLATE ",WINDOW/K",args,myrd)) {
                                                                        /* Is this still valid? */
                                                                        here[len]=' ';
                                                                        here+=len+1;
                                                                        /* if so, accept this argument and go on */
                                                                } else {
                                                                        err=IoErr();
                                                                        if (err==ERROR_NO_FREE_STORE) break;
                                                                        else    err=0;  /* Ignore unknown or invalid arguments silently */
                                                                }
                                                        } else {
                                                                err=ERROR_NO_FREE_STORE;
                                                                break;
                                                        }
                                                }while(*tt++);

                                                FreeVec(wbstr);
                                        } else err=ERROR_NO_FREE_STORE;
                                } else err=ERROR_REQUIRED_ARG_MISSING; /* Huh, how should this happen ? */
                                FreeDiskObject(dop);
                        } else err=IoErr();
                        CurrentDir(oldlock);
                } else err=ERROR_REQUIRED_ARG_MISSING; /* This should not happen either */
                CloseLibrary(IconBase);
        } else err=ERROR_OBJECT_NOT_FOUND;    /* This should not happen */

        /* Open an output stream */

        if (err==0) {
                if (newout=Open((args[OPT_WINDOW])?((char *)args[OPT_WINDOW]):("NIL:"),MODE_NEWFILE)) {
                        SelectOutput(newout);
                        /* Hack in the output console. Well, well... */
                        SetConsoleTask(((struct FileHandle *)(BADDR(newout)))->fh_Type);
                } else err=IoErr();
        }

        if (err) {
                if (rd)   FreeArgs(rd);
                if (myrd) FreeDosObject(DOS_RDARGS,myrd);
                SetIoErr(err);
                rd=NULL;
                myrd=NULL;
        }

        *tmp=myrd;
        return rd;
}
///
/// CheckRemapping
int CheckRemapping(char *testfile)
{
struct MMUContext *ctx,*sctx;   /* default context, supervisorcontext */
ULONG psize,ssize;
ULONG largest;
struct MemHeader *mem,*oldheader,*dest;

        /* This is the main routine. It mirrors RAM to somehwere else
           and tries to write it to disk. If this fails, the disk
           driver is misdesigned because it fails to call
           the CachePre/PostDMA functions. Yuck! */

        ctx=DefaultContext();   /* get the default context */
        sctx=SuperContext(ctx); /* get the supervisor context for this one */

        psize=RemapSize(ctx);
        ssize=RemapSize(sctx);
        if (ssize>psize)
                psize=ssize;    /* Largest required alignment. Well
                                   actually, the two should be identically,
                                   usually. */

        Forbid();

        /* Get a huge memory block. The largest available, but only the
           half of it. */

        largest=AvailMem(MEMF_FAST|MEMF_PUBLIC|MEMF_LARGEST)>>1;
        largest &= -(LONG)psize;

        /* and allocate what remains after correct alignment */

        if (largest)    mem=AllocAligned(largest,MEMF_FAST|MEMF_PUBLIC,psize);
        else            mem=NULL;
        Permit();

        if (mem==NULL) {
                return ERROR_NO_FREE_STORE;
        }


        /* mirror this memory to below 0x80000000 */

        dest=(struct MemHeader *)(0x80000000-largest);        /* remap memory to top area */

        /* And remap it */
        if (!SetRemap(ctx,mem,dest,largest)) {
                return ERROR_NO_FREE_STORE;
        }

        /* For the supervisor as well */

        if (!SetRemap(sctx,mem,dest,largest)) {
                if (!SetRemap(ctx,mem,NULL,largest))    /* Ouch! Can't restore! */
                        Alert(0x3e020000);
                return ERROR_NO_FREE_STORE;
        }

        /* Run the file test */
        FileTest(testfile,(void *)mem,(void *)dest,largest);
        DeleteFile(testfile);

        /* Now initialize this memory as fast and setup a MemHeader */
        Forbid();
        dest->mh_Node.ln_Pri=64;                /* Use this first */
        dest->mh_Node.ln_Type=NT_MEMORY;
        dest->mh_Attributes=MEMF_FAST|MEMF_PUBLIC;
        dest->mh_Lower=(APTR)(((UBYTE *)dest)+sizeof(struct MemHeader));
        dest->mh_Upper=(APTR)(0x80000000);
        dest->mh_First=(struct MemChunk *)(dest->mh_Lower);
        dest->mh_First->mc_Next=NULL;
        dest->mh_First->mc_Bytes=((UBYTE *)(dest->mh_Upper))-((UBYTE *)(dest->mh_Lower));
        dest->mh_Free=dest->mh_First->mc_Bytes;
        oldheader=MemHeaderOf(mem);
        dest->mh_Node.ln_Name=oldheader->mh_Node.ln_Name;

        /* I don't use AddMem here because this is hacked by Ralphie. */
        Enqueue(&(SysBase->MemList),&(dest->mh_Node));
        oldheader->mh_Attributes &= ~(MEMF_PUBLIC);
        Permit();

        /* Force rebuilding this property list to test the MMU table
           allocation */
        ForceRebuild(ctx);
        Delay(50L);

        /* Since the system allocates now memory from this new public
           header, we can't exit here safely! Say bye, bye! */

        Printf("Now just work with your system. Everything should behaive\n"
               "normal, provided the previous test worked! In case it didn't\n"
               "please reboot now or you risk your HD! There is\n"
               "no exit here, unfortunately.\n");

        /* sigh */
        Wait(0L);


        /* This is how it *should* work, provided none of our faked memory
           is allocated */

        Forbid();
        /* Make this public again */
        oldheader->mh_Attributes |= MEMF_PUBLIC;
        /* Lower the priority of this pool again */
        dest->mh_Node.ln_Pri=-128;
        dest->mh_Attributes &= ~(MEMF_PUBLIC);
        Remove(&(dest->mh_Node));
        /* Add it again to the memory list */
        Enqueue(&(SysBase->MemList),&(dest->mh_Node));
        Permit();

        /* Again, to the old location */
        ForceRebuild(ctx);

        /* This will hopefully release all the memory allocated from
           this pool. It's only a test, anyways... */

        /* Un-do the relocation */

        if (!SetRemap(sctx,mem,NULL,largest)) {
                Alert(0x3e020000);
                return ERROR_NO_FREE_STORE;
        }

        if (!SetRemap(ctx,mem,NULL,largest)) {
                Alert(0x3e020000);
                return ERROR_NO_FREE_STORE;
        }

        /* Free the private pool */
        Forbid();
        Remove(&(mem->mh_Node));
        Permit();

        FreeMem(mem,largest);

        return 0;
}
///
/// SetRemap
BOOL SetRemap(struct MMUContext *ctx,struct MemHeader *physical,struct MemHeader *logical,ULONG size)
{
struct MinList *ctxl;
ULONG new;

        /* remap a memory block to a different position, using the MMU
           library */
        if (logical) {
                new=MAPP_REMAPPED|MAPP_COPYBACK;
        } else  new=MAPP_REPAIRABLE|MAPP_INVALID;

        /* Make a backup of the current mapping */
        if (ctxl=GetMapping(ctx)) {
                /* remap it */
                if (SetProperties(ctx,new,~0,(ULONG)logical,size,MAPTAG_DESTINATION,(ULONG)physical,TAG_DONE)) {
                        /* and rebuild the MMU tree */
                        if (RebuildTree(ctx)) {
                                /* if this worked, release the backup */
                                ReleaseMapping(ctx,ctxl);
                                return TRUE;
                        }
                }
                /* if it did not work, restore the backup */
                SetPropertyList(ctx,ctxl);
                ReleaseMapping(ctx,ctxl);
        }

        return FALSE;
}
///
/// FileTest
void FileTest(char *filename,void *physical,void *logical,ULONG size)
{
BPTR file;
UWORD buffer;
UWORD *buf;
ULONG i;

        /* This runs a stupid test to check whether the device really
           knows about the MMU. A correctly written device should call
           CachePreDMA() and CachePostDMA() to get the physical address
           from the logical address. */

        Printf("Running the filing system MMU awarenest tests.\n");


        /* Limit this to 64K */
        if (size>65536)
                size=65536;

        file=Open(filename,MODE_NEWFILE);

        if (!file) {
                PrintFault(IoErr(),"MuRemapTest failed to open the tempfile");
                return;
        }

        /* Fill the buffer with a write pattern */
        for(buf=(UWORD *)logical,i=size>>1;i;i--,buf++) {
                *buf=i;
        }

        /* Now write the pattern */
        Printf("Running the write test.\n");
        if (Write(file,logical,size)!=size) {
                PrintFault(IoErr(),"Failed writing the test pattern");
                Close(file);
                return;
        }

        /* Done writing the data */
        Close(file);

        /* Now check for the pattern, reading byte for byte */

        file=Open(filename,MODE_OLDFILE);
        if (!file) {
                PrintFault(IoErr(),"MuRemapTest failed to reopen the tempfile");
                return;
        }

        /* Now read the data, word by word */
        for(i=size>>1;i;i--) {
                if (Read(file,&buffer,sizeof(UWORD))!=sizeof(UWORD)) {
                        PrintFault(IoErr(),"MuRemapTest failed to re-read the data");
                        Close(file);
                        return;
                }
                if (buffer!=i) {
                        Printf("The write test failed, the device is not MMU aware.\n");
                        Close(file);
                        return;
                }
        }

        Close(file);
        Printf("The write test passed.\n");

        /* Now try again reading it back as a whole */

        file=Open(filename,MODE_OLDFILE);
        if (!file) {
                PrintFault(IoErr(),"MuRemapTest failed to reopen the tempfile");
                return;
        }

        /* Fill the memory area with zeros */
        memset(logical,0,(size_t)size);
        /* Really! */
        CacheClearU();

        /* Read in one big block. This should use DMA again. */

        Printf("Now running the read test.\n");
        if (Read(file,logical,size)!=size) {
                PrintFault(IoErr(),"MuRemapTest failed to re-read the tempfile");
                Close(file);
        }

        Close(file);

        /* Compare the read data */
        for(buf=(UWORD *)logical,i=size>>1;i;i--,buf++) {
                if (*buf!=i) {
                        Printf("The read test failed.\n");
                        return;
                }
        }

        Printf("All tests passed.\n");

}
///
/// MemHeaderOf
struct MemHeader *MemHeaderOf(void *mem)
{
struct MemHeader *mh;
ULONG adr;
ULONG lower,upper;

        /* Find the memory header of a given address.
           This MUST be called in FORBID state. */

        adr=(ULONG)mem;

        for(mh=(struct MemHeader *)(SysBase->MemList.lh_Head);mh->mh_Node.ln_Succ;mh=(struct MemHeader *)(mh->mh_Node.ln_Succ)) {
                lower=(ULONG)(mh->mh_Lower);
                upper=(ULONG)(mh->mh_Upper);
                if (adr>=lower && adr<upper)
                        return mh;
        }

        return NULL;
}
///
/// ForceRebuild
BOOL ForceRebuild(struct MMUContext *ctx)
{
struct MinList *ctxl;

        /* Force a complete rebuild of the MMU tree */

        if (ctxl=GetMapping(ctx)) {
                TouchPropertyList(ctxl);        /* This is intentionally undocumented */
                SetPropertyList(ctx,ctxl);
                ReleaseMapping(ctx,ctxl);
                if (RebuildTree(ctx))
                        return TRUE;
        }

        return FALSE;
}
///

