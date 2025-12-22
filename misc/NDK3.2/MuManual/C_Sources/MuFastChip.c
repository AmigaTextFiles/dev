/*****************************************************************
 ** MuFastChip                                                  **
 **                                                             **
 ** Enable imprecise/nonserial flags for Chip memory            **
 ** Release 40.3, © 1999,2001 THOR-Software inc.                **
 ** 28.04.2001 Thomas Richter                                   **
 *****************************************************************/

/// Includes
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/execbase.h>
#include <dos/dos.h>
#include <mmu/mmubase.h>
#include <mmu/context.h>
#include <mmu/mmutags.h>
#include <workbench/startup.h>

#include <thor/conversions.h>

#include <proto/exec.h>
#include <proto/mmu.h>
#include <proto/dos.h>
#include <proto/icon.h>
#include <string.h>
///
/// Defines
#define STRINGDATE "28.4.2001"
#define STRINGVERSION "40.3"
#define TEMPLATE "ON/S,OFF/S"

#define OPT_ON 0
#define OPT_OFF 1
#define OPT_WINDOW 2
#define OPT_COUNT 3
///
/// Statics
struct MMUBase *MMUBase;
struct DosLibrary *DOSBase;
struct ExecBase *SysBase;
struct Library *IconBase;
///
/// Protos
int __asm __saveds main(void);
int SetCacheMode(ULONG from,ULONG size,ULONG flags,ULONG mask);
struct RDArgs *ReadTTArgs(struct WBStartup *msg,LONG args[],struct RDArgs **tmp);
int DisableFastChip(void);
int EnableFastChip(void);
BOOL FindChipLimits(ULONG *from,ULONG *size);
ULONG FindProperties(ULONG address);
///

char version[]="$VER: MuFastChip " STRINGVERSION " (" STRINGDATE ") © THOR";

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

        SysBase=*((struct ExecBase **)(4L));

        memset(args,0,sizeof(LONG)*OPT_COUNT);

        /* Wait for the workbench startup, if any */
        proc=(struct Process *)FindTask(NULL);

        if (!(proc->pr_CLI)) {
                WaitPort(&(proc->pr_MsgPort));
                msg=(struct WBStartup *)GetMsg(&(proc->pr_MsgPort));
        } else  msg=NULL;

        if (DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",37L)) {
                if (MMUBase=(struct MMUBase *)OpenLibrary("mmu.library",41L)) {

                        err=ERROR_REQUIRED_ARG_MISSING;

                        myrd=NULL;      /* reset the temporary ReadArgs */
                        oldout=NULL;
                        oldconsole=NULL;
                        if (msg) {
                                oldout=SelectOutput(NULL);
                                oldconsole=SetConsoleTask(NULL);
                                rd=ReadTTArgs(msg,args,&myrd);
                        } else  rd=ReadArgs(TEMPLATE,args,NULL);

                        if (rd) {
                                if (!GetMMUType()) {
                                        Printf("MuFastChip requires a working MMU.\n");
                                        err=10;
                                } else {

                                        err=0;

                                        if (args[OPT_ON] || (!args[OPT_OFF])) {
                                                err=EnableFastChip();
                                        }

                                        if (args[OPT_OFF]) {
                                                err=DisableFastChip();
                                        }
                                }

                                FreeArgs(rd);
                                if (myrd) FreeDosObject(DOS_RDARGS,myrd);
                                if (msg)  Close(SelectOutput(NULL));
                        } else  err=IoErr();

                        if (msg) {
                                SelectOutput(oldout);
                                SetConsoleTask(oldconsole);
                        }

                        if (err<64) {
                                rc=err;
                                err=0;
                        } else {
                                if (!msg) PrintFault(err,"MuFastChip failed");
                                rc=10;
                        }
                        SetIoErr(err);

                        CloseLibrary((struct Library *)MMUBase);
                } else if (!msg) PrintFault(ERROR_OBJECT_NOT_FOUND,"MuFastChip requires the mmu.library V41 or better");
                CloseLibrary((struct Library *)DOSBase);
        }

        if (msg) {
                Forbid();
                ReplyMsg((struct Message *)msg);
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
/// EnableFastChip
int EnableFastChip(void)
{
ULONG from,size;

        if (FindChipLimits(&from,&size)) {
                if ((FindProperties(from) & (MAPP_IMPRECISE|MAPP_NONSERIALIZED)) == (MAPP_IMPRECISE|MAPP_NONSERIALIZED)) {
                        Printf("The chip memory caching mode is already optimal.\n"
                               "MuFastChip is not required.\n");
                        return 5;
                }
                return SetCacheMode(from,size,MAPP_IMPRECISE|MAPP_NONSERIALIZED,MAPP_IMPRECISE|MAPP_NONSERIALIZED);
        } else  return 20;

}
///
/// DisableFastChip
int DisableFastChip(void)
{
ULONG from,size;

        if (FindChipLimits(&from,&size)) {
                if ((FindProperties(from) & (MAPP_IMPRECISE|MAPP_NONSERIALIZED)) == 0) {
                        Printf("MuFastChip is not activated.\n");
                        return 5;
                }
                return SetCacheMode(from,size,0,MAPP_IMPRECISE|MAPP_NONSERIALIZED);
        } else  return 20;

}
///
/// FindProperties
ULONG FindProperties(ULONG address)
{
        return GetProperties(DefaultContext(),address,TAG_DONE);
}
///
/// FindChipLimits
BOOL FindChipLimits(ULONG *from,ULONG *size)
{
struct MMUContext *ctx;
ULONG psize;
ULONG upper,lower;
struct MemHeader *memh;

        ctx=DefaultContext();
        psize=GetPageSize(ctx);
        lower=0xffffffff;
        upper=0;
        Forbid();
        for(memh=(struct MemHeader *)SysBase->MemList.lh_Head;
            memh->mh_Node.ln_Succ;
            memh=(struct MemHeader *)memh->mh_Node.ln_Succ) {

                if (memh->mh_Attributes & MEMF_CHIP) {
                        if ((ULONG)(memh->mh_Lower) < lower) {
                                lower=(ULONG)(memh->mh_Lower);
                        }
                        if ((ULONG)(memh->mh_Upper) > upper) {
                                upper=(ULONG)(memh->mh_Upper);
                        }
                }
        }
        Permit();

        if (lower>=upper) {
                Printf("MuFastChip failed: no MEMF_CHIP memory found.\n");
                return FALSE;
        }

        upper += psize-1;
        lower &= -psize;
        upper &= -psize;


        *from=lower;
        *size=upper-lower;

        return TRUE;
}
///
/// SetCacheMode
int SetCacheMode(ULONG from,ULONG size,ULONG flags,ULONG mask)
{
struct MMUContext *ctx,*sctx;   /* default context, supervisorcontext */
struct MinList *ctxl,*sctxl;
int err;

        ctx=DefaultContext();   /* get the default context */
        sctx=SuperContext(ctx); /* get the supervisor context for this one */

        LockContextList();
        LockMMUContext(ctx);
        LockMMUContext(sctx);

        err=ERROR_NO_FREE_STORE;

        if (ctxl=GetMapping(ctx)) {
         if (sctxl=GetMapping(sctx)) {
          if (SetProperties(ctx,flags,mask,from,size,TAG_DONE)) {
           if (SetProperties(sctx,flags,mask,from,size,TAG_DONE)) {
            if (RebuildTrees(ctx,sctx,NULL)) {
                    err=0;
            }
           }
          }

          if (err) {
                  SetPropertyList(ctx,ctxl);
                  SetPropertyList(sctx,sctxl);
          }

         ReleaseMapping(sctx,sctxl);
         }
        ReleaseMapping(ctx,ctxl);
        }

        UnlockMMUContext(sctx);
        UnlockMMUContext(ctx);
        UnlockContextList();

        return err;
}
///

