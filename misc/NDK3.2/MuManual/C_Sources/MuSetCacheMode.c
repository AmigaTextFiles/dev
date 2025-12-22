/*****************************************************************
 ** MuSetCacheMode                                              **
 **                                                             **
 ** Reprogram MMU tables selectively.                           **
 ** Release 40.7, © 1999 THOR-Software inc.                     **
 ** 28.11.1999 Thomas Richter                                   **
 *****************************************************************/

/// Includes
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
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
#define STRINGDATE "28.11.99"
#define STRINGVERSION "40.7"
#define TEMPLATE "ADDRESS=FROM/A,SIZE/A,COPYBACK/S,WRITETHROUGH/S,NOCACHESERIALIZED=CACHEINHIBIT/S,NONSERIAL/S,NOCACHE=IMPRECISE/S,VALID/S,INVALID/S,BLANK/S,IO=IOSPACE/S,NOIO=NOIOSPACE/S,ROM/S,NOROM/S,WRITEPROTECTED/S,NOTWRITEPROTECTED/S,USERONLY/S,SUPERVISORONLY/S,VERBOSE/S"
#define CACHEFLAGS (MAPP_CACHEINHIBIT|MAPP_NONSERIALIZED|MAPP_IMPRECISE|MAPP_COPYBACK)
#define ROMFLAGS (MAPP_ROM|MAPP_WRITEPROTECTED)

#define OPT_ADDRESS 0
#define OPT_SIZE 1
#define OPT_COPYBACK 2
#define OPT_WRITETHROUGH 3
#define OPT_NOCACHE 4
#define OPT_NOCACHESERIALIZED 5
#define OPT_NOCACHEIMPRECISE 6
#define OPT_VALID 7
#define OPT_INVALID 8
#define OPT_BLANK 9
#define OPT_IO 10
#define OPT_NOIO 11
#define OPT_ROM 12
#define OPT_NOROM 13
#define OPT_WRITEPROTECTED 14
#define OPT_NOTWRITEPROTECTED 15
#define OPT_USERONLY 16
#define OPT_SUPERVISORONLY 17
#define OPT_VERBOSE 18
#define OPT_WINDOW 19
#define OPT_COUNT 20

#define WHICH_ALL       3
#define WHICH_USER      1
#define WHICH_SUPER     2
///
/// Statics
struct MMUBase *MMUBase;
struct DosLibrary *DOSBase;
struct ExecBase *SysBase;
struct Library *IconBase;
///
/// Protos
int __asm __saveds main(void);
int SetCacheMode(ULONG from,ULONG size,ULONG flags,ULONG mask,ULONG which);
struct RDArgs *ReadTTArgs(struct WBStartup *msg,LONG args[],struct RDArgs **tmp);
///

char version[]="$VER: MuSetCacheMode " STRINGVERSION " (" STRINGDATE ") © THOR";

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
LONG flags,which;
char *whichmsg;
int from=0,size=0;
ULONG mask;
char flagsmsg[256];


        SysBase=*((struct ExecBase **)(4L));

        memset(args,0,sizeof(LONG)*OPT_COUNT);
        flagsmsg[0]='\0';                       /* Clear this string */

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
                                        Printf("MuSetCacheMode requires a working MMU.\n");
                                        err=10;
                                } else {

                                        err=0;

                                        if (args[OPT_ADDRESS]==NULL || args[OPT_SIZE]==NULL)
                                                err=ERROR_REQUIRED_ARG_MISSING;

                                        if (err==0) {

                                                if (!StrToL((char *)(args[OPT_ADDRESS]),NULL,&from,16))
                                                        err=ERROR_BAD_NUMBER;

                                                if (!StrToL((char *)(args[OPT_SIZE]),NULL,&size,16)) {
                                                        err=ERROR_BAD_NUMBER;
                                                } else if (size==0) err=ERROR_BAD_NUMBER;


                                        }       
                                        if (err==0) {

                                                flags=0;
                                                mask=0;

                                                if (args[OPT_VALID]) {
                                                        mask |= MAPP_INVALID | MAPP_BLANK | MAPP_REPAIRABLE;
                                                        strcat(flagsmsg,"valid ");
                                                }
                                                if (args[OPT_IO]) {
                                                        flags &= ~CACHEFLAGS;
                                                        flags |= MAPP_IO|MAPP_CACHEINHIBIT;
                                                        mask |= MAPP_IO|CACHEFLAGS;
                                                        strcat(flagsmsg,"IO space ");
                                                }
                                                if (args[OPT_NOIO]) {
                                                        mask |= MAPP_IO;
                                                        flags &= ~MAPP_IO;
                                                        strcat(flagsmsg,"memory space ");
                                                }
                                                if (args[OPT_COPYBACK]) {
                                                        flags &= ~CACHEFLAGS;
                                                        flags |= MAPP_COPYBACK;
                                                        mask |= CACHEFLAGS;
                                                        strcat(flagsmsg,"copyback ");
                                                }
                                                if (args[OPT_WRITETHROUGH]) {
                                                        flags &= ~CACHEFLAGS;    /* writethrough is the default */
                                                        mask |= CACHEFLAGS;
                                                        strcat(flagsmsg,"writethrough ");
                                                }
                                                if (args[OPT_NOCACHE]) {
                                                        flags &= ~CACHEFLAGS;
                                                        flags |= MAPP_CACHEINHIBIT;
                                                        mask |= CACHEFLAGS;
                                                        strcat(flagsmsg,"cacheinhibit ");
                                                }
                                                if (args[OPT_NOCACHESERIALIZED]) {
                                                        flags &= ~CACHEFLAGS;
                                                        flags |= MAPP_CACHEINHIBIT | MAPP_NONSERIALIZED;
                                                        mask |= CACHEFLAGS;
                                                        if (!args[OPT_NOCACHEIMPRECISE]) {
                                                                strcat(flagsmsg,"cacheinhibit non-serialized ");
                                                        }
                                                }
                                                if (args[OPT_NOCACHEIMPRECISE]) {
                                                        flags &= ~CACHEFLAGS;
                                                        flags |= MAPP_CACHEINHIBIT | MAPP_IMPRECISE;
                                                        mask |= CACHEFLAGS;
                                                        strcat(flagsmsg,"cacheinhibit imprecise ");
                                                        if (args[OPT_NOCACHESERIALIZED]) {
                                                                flags |= MAPP_NONSERIALIZED;
                                                                strcat(flagsmsg,"non-serialized ");
                                                        }
                                                }
                                                if (args[OPT_ROM]) {
                                                        flags &= ~ROMFLAGS;
                                                        flags |= MAPP_ROM;
                                                        mask |= ROMFLAGS;
                                                        strcat(flagsmsg,"ROM ");
                                                }
                                                if (args[OPT_NOROM]) {
                                                        mask |= MAPP_ROM;
                                                        flags &= ~MAPP_ROM;
                                                        strcat(flagsmsg,"no ROM ");
                                                }
                                                if (args[OPT_WRITEPROTECTED]) {
                                                        flags &= ~ROMFLAGS;
                                                        flags |= MAPP_WRITEPROTECTED;
                                                        mask |= ROMFLAGS;
                                                        strcat(flagsmsg,"read only ");
                                                }
                                                if (args[OPT_NOTWRITEPROTECTED]) {
                                                        mask |= MAPP_WRITEPROTECTED;
                                                        flags &= ~MAPP_WRITEPROTECTED;
                                                        strcat(flagsmsg,"read/write ");
                                                }
                                                if (args[OPT_INVALID]) {
                                                        mask = 0xffffffff;
                                                        flags = MAPP_INVALID | MAPP_REPAIRABLE;
                                                        strcpy(flagsmsg,"invalid ");
                                                }
                                                if (args[OPT_BLANK]) {
                                                        mask = 0xffffffff;
                                                        flags = MAPP_BLANK;
                                                        strcpy(flagsmsg,"blank ");
                                                }
                                                which=WHICH_ALL;
                                                whichmsg = "user and supervisor";
                                                if (args[OPT_USERONLY]) {
                                                        which = WHICH_USER;
                                                        whichmsg = "user";
                                                }
                                                if (args[OPT_SUPERVISORONLY]) {
                                                        which=WHICH_SUPER;
                                                        whichmsg = "supervisor";
                                                }

                                                if (flagsmsg[0]=='\0') {
                                                        err=ERROR_REQUIRED_ARG_MISSING;
                                                } else {
                                                        err=SetCacheMode((ULONG)from,(LONG)size,flags,mask,which);
                                                        if ((err==0) && args[OPT_VERBOSE]) {
                                                                Printf("%s.\n"
                                                                       "Set %s mode from 0x%lx, size 0x%lx to %s\n",
                                                                       version+6,whichmsg,from,size,flagsmsg);
                                                        }
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
                                if (!msg) PrintFault(err,"MuSetCacheMode failed");
                                rc=10;
                        }
                        SetIoErr(err);

                        CloseLibrary((struct Library *)MMUBase);
                } else if (!msg) PrintFault(ERROR_OBJECT_NOT_FOUND,"MuSetCacheMode requires the mmu.library V41 or better");
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
/// SetCacheMode
int SetCacheMode(ULONG from,ULONG size,ULONG flags,ULONG mask,ULONG which)
{
struct MMUContext *ctx,*sctx;   /* default context, supervisorcontext */
struct MinList *ctxl,*sctxl;
ULONG psize;
int err;

        ctx=DefaultContext();   /* get the default context */
        sctx=SuperContext(ctx); /* get the supervisor context for this one */

        psize=GetPageSize(ctx);
        if (size & (psize-1)) {
                Printf("The given size 0x%lx is not divisible by the page size 0x%lx.\n",size,psize);
                return ERROR_BAD_NUMBER;
        }
        if (from & (psize-1)) {
                Printf("The given address 0x%lx is not divisible by the page size 0x%lx.\n",from,psize);
                return ERROR_BAD_NUMBER;
        }
        if (psize!=GetPageSize(sctx)) {
                Printf("MuSetCacheMode does not support different user and supervisor page sizes.\n");
                return ERROR_OBJECT_WRONG_TYPE;
        }

        LockContextList();
        LockMMUContext(ctx);
        LockMMUContext(sctx);

        err=ERROR_NO_FREE_STORE;

        if (ctxl=GetMapping(ctx)) {
         if (sctxl=GetMapping(sctx)) {

           err=0;

           if (which & WHICH_USER) {
                if (!SetProperties(ctx,flags,mask,from,size,TAG_DONE)) {
                        err=ERROR_NO_FREE_STORE;
                }
           }

           if (which & WHICH_SUPER) {
                if (!SetProperties(sctx,flags,mask,from,size,TAG_DONE)) {
                        err=ERROR_NO_FREE_STORE;
                }
           }

           if (err==0) {
                if (!RebuildTrees(ctx,sctx,NULL)) {
                           err=ERROR_NO_FREE_STORE;
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

