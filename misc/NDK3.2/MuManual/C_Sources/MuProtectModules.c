/*****************************************************************
 ** MuProtectModules                                            **
 **                                                             **
 ** Write-protect modules read by LoadModule for optimal safety **
 ** Release 40.2, © 2001 THOR-Software inc.                     **
 ** 12.05.2001 Thomas Richter                                   **
 *****************************************************************/

/// Includes
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/execbase.h>
#include <exec/resident.h>
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
#define STRINGDATE "40.2.2001"
#define STRINGVERSION "40.2"
#define TEMPLATE "ON/S,OFF/S"

#define OPT_ON 0
#define OPT_OFF 1
#define OPT_WINDOW 2
#define OPT_COUNT 3
///
/// Structures
/*
 * The following is the main structure keeping all the resident data
 * together.
 *
 */
struct LoadResidentModule {
     /* struct MemChunk         lrm_Trash;                 might be trashed by Exec on AllocAbs(): Not included here */
        struct Resident         lrm_Resident;           /* our own resident structure */
        UWORD                   lrm_cludgefill1;
        /* the next two are for easy Kick-Tag-pointing... */
        struct Resident        *lrm_ResidentPtr;
        ULONG                   lrm_LastKickTag;        /* old KickTag ptr if required */
        struct MemList          lrm_MemList;            /* memory for this node */
        char                    lrm_Name[16];           /* name of this guy */
        char                    lrm_IdString[32];       /* IDString */
        ULONG                   lrm_AllocSize;          /* Includes the stack saveback */
        /* pointer to the first resident module follows here */
        APTR                    lrm_NULL;               /* as said, must remain blank for backwards compatibility */
        APTR                    lrm_AbsLocation;        /* all of the memory at once */
        ULONG                   lrm_AbsSize;            /* the size of the memory */
        APTR                   *lrm_Head;
        /* and now for the messy part... Embedded MC68K code */
        UWORD                   lrm_LEA0;               /* load A0 with the resident structure */
        UWORD                   lrm_ResidentOffset;
        /* resident code follows here... */
};
///
/// Statics
struct MMUBase *MMUBase;
struct DosLibrary *DOSBase;
struct ExecBase *SysBase;
struct Library *IconBase;
///
/// Protos
int __asm __saveds main(void);
struct RDArgs *ReadTTArgs(struct WBStartup *msg,LONG args[],struct RDArgs **tmp);
int DisableProtection(struct LoadResidentModule *lrm);
int EnableProtection(struct LoadResidentModule *lrm,BOOL aggressive);
int SetModuleProtection(struct LoadResidentModule *lrm,ULONG flags,ULONG mask);
///

char version[]="$VER: MuProtectModules " STRINGVERSION " (" STRINGDATE ") © THOR";

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
struct LoadResidentModule *lrm;


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

                        err = ERROR_REQUIRED_ARG_MISSING;

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
                                        Printf("MuProtectModules requires a working MMU.\n");
                                        err=10;
                                } else {
                                        lrm = (struct LoadResidentModule *)FindResident("« LoadModule »");

                                        if (lrm == NULL) {
                                                Printf("MuProtectModules failed: no resident modules found\n");
                                                err = 10;
                                        } else {

                                                err=0;

                                                if (args[OPT_ON] || (!args[OPT_OFF])) {
                                                        BOOL agressive = FALSE;

                                                        Forbid();
                                                        if (FindTask("« MuForce »"))
                                                                agressive = TRUE;
                                                        Permit();
                                                        err=EnableProtection(lrm,agressive);
                                                }

                                                if (args[OPT_OFF]) {
                                                        err=DisableProtection(lrm);
                                                }
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
                                if (!msg) PrintFault(err,"MuProtectModules failed");
                                rc=10;
                        }
                        SetIoErr(err);

                        CloseLibrary((struct Library *)MMUBase);
                } else if (!msg) PrintFault(ERROR_OBJECT_NOT_FOUND,"MuProtectModules requires the mmu.library V41 or better");
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
/// EnableProtection
int EnableProtection(struct LoadResidentModule *lrm,BOOL aggressive)
{
        return SetModuleProtection(lrm,(aggressive)?(MAPP_WRITEPROTECTED|MAPP_REPAIRABLE):(MAPP_ROM),MAPP_WRITEPROTECTED|MAPP_ROM|MAPP_REPAIRABLE);
}
///
/// DisableProtection
int DisableProtection(struct LoadResidentModule *lrm)
{
        return SetModuleProtection(lrm,0,MAPP_WRITEPROTECTED|MAPP_ROM|MAPP_REPAIRABLE);
}
///
/// SetModuleProtection
int SetModuleProtection(struct LoadResidentModule *lrm,ULONG flags,ULONG mask)
{
struct MMUContext *ctx,*sctx;   /* default context, supervisorcontext */
struct MinList *ctxl,*sctxl;
ULONG  pagemask;
int err = 0;

        ctx=DefaultContext();   /* get the default context */
        sctx=SuperContext(ctx); /* get the supervisor context for this one */

        LockContextList();
        LockMMUContext(ctx);
        LockMMUContext(sctx);

        /*
         * first check me for page size alignment
         */

        pagemask = GetPageSize(ctx) - 1;
        if ((ULONG)(lrm->lrm_AbsLocation) & pagemask)
                err = 10;
        if ((ULONG)(lrm->lrm_AbsSize    ) & pagemask)
                err = 10;

        if (lrm->lrm_NULL)
                err = 11;

        if (err == 0) {
         err = ERROR_NO_FREE_STORE;

         if (ctxl=GetMapping(ctx)) {
          if (sctxl=GetMapping(sctx)) {
                if (SetProperties(ctx, flags,mask,(ULONG)(lrm->lrm_AbsLocation),lrm->lrm_AbsSize,TAG_DONE)) {
                        if (SetProperties(sctx,flags,mask,(ULONG)(lrm->lrm_AbsLocation),lrm->lrm_AbsSize,TAG_DONE)) {
                                if (RebuildTrees(ctx,sctx,NULL)) {
                                        err = 0;
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
        } 

        UnlockMMUContext(sctx);
        UnlockMMUContext(ctx);
        UnlockContextList();

        if (err == 10) {
                Printf("MuProtectModules failed: ROM modules are not page aligned.\n");
        } else if (err == 11) {
                Printf("MuProtectModules failed: incompatible version of LoadModule.\n");
        }

        return err;
}
///

