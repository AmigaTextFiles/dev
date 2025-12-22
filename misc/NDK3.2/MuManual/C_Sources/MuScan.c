/*************************************************************************
 ** mmu.library                                                         **
 **                                                                     **
 ** a system library for arbitration and control of the MC68K MMUs      **
 **                                                                     **
 ** © 1998,1999 THOR-Software, Thomas Richter                           **
 ** No commercial use, reassembly, modification without prior, written  **
 ** permission of the authors.                                          **
 ** Including this library in any commercial software REQUIRES a        **
 ** written permission and the payment of a small fee.                  **
 **                                                                     **
 ** This sample source demonstrates how to print out the mapping of the **
 ** MMU library. It's here done for the default context                 **
 *************************************************************************/

/// Includes
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <mmu/mmubase.h>
#include <mmu/context.h>
#include <mmu/config.h>
#include <workbench/startup.h>

#include <proto/exec.h>
#include <proto/mmu.h>
#include <proto/dos.h>
#include <proto/icon.h>

#include <string.h>
///
/// Defines
#define STRINGDATE "02.07.2016"
#define STRINGVERSION "46.1"
#define TEMPLATE "TO/K"

#define OPT_TO  0
#define OPT_WINDOW 1
#define OPT_COUNT 2
///
/// Statics
struct MMUBase *MMUBase;
struct DosLibrary *DOSBase;
struct ExecBase *SysBase;
struct Library *IconBase;
///
/// Protos
int __asm __saveds main(void);
void ScanMMU(BPTR to);
struct RDArgs *ReadTTArgs(struct WBStartup *msg,LONG args[],struct RDArgs **tmp);
///

char version[]="$VER: MuScan " STRINGVERSION " (" STRINGDATE ") © THOR";

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
BPTR out;


        SysBase=*((struct ExecBase **)(4L));

        memset(args,0,sizeof(LONG)*OPT_COUNT);
        /* Wait for the workbench startup, if any */
        proc=(struct Process *)FindTask(NULL);

        if (!(proc->pr_CLI)) {
                WaitPort(&(proc->pr_MsgPort));
                msg=(struct WBStartup *)GetMsg(&(proc->pr_MsgPort));
        } else  msg=NULL;

        if (DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",37L)) {
                if (MMUBase=(struct MMUBase *)OpenLibrary("mmu.library",40L)) {

                        myrd=NULL;      /* reset the temporary ReadArgs */
                        oldout=NULL;
                        oldconsole=NULL;
                        if (msg) {
                                oldout=SelectOutput(NULL);
                                oldconsole=SetConsoleTask(NULL);
                                rd=ReadTTArgs(msg,args,&myrd);
                        } else  rd=ReadArgs(TEMPLATE,args,NULL);

                        if (rd) {
                                /* Argument parser worked, call main routine */
                                if (args[OPT_TO])       out=Open((char *)(args[0]),MODE_NEWFILE);
                                else                    out=Output();

                                if (out) {
                                        ScanMMU(out);
                                        err=0;
                                        if (args[OPT_TO])
                                                Close(out);
                                } else err=IoErr();

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
                                if (!msg) PrintFault(err,"MuScan failed");
                                rc=10;
                        }
                        SetIoErr(err);

                        CloseLibrary((struct Library *)MMUBase);
                } else PrintFault(ERROR_OBJECT_NOT_FOUND,"MuScan requires the mmu.library V40 or better");
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
/// ScanMMU
void ScanMMU(BPTR to)
{
struct MinList *list;
struct MappingNode *mn;

        FPrintf(to,version+6);
        FPrintf(to,"\n\n");

        switch (GetMMUType()) {
                case MUTYPE_NONE:
                        FPrintf(to,"No MMU available.\n");
                        break;
                case MUTYPE_68851:
                        FPrintf(to,"68851 MMU detected.\n");
                        break;
                case MUTYPE_68030:
                        FPrintf(to,"68030 MMU detected.\n");
                        break;
                case MUTYPE_68040:
                        FPrintf(to,"68040 MMU detected.\n");
                        break;
                case MUTYPE_68060:
                        FPrintf(to,"68060 MMU detected.\n");
                        break;
        };

        /* Read now the page size of the MMU for the default
           (public) context */

        FPrintf(to,"MMU page size is 0x%lx bytes.\n\n",GetPageSize(NULL));


        /* Get the mapping of the default context */
        list=GetMapping(NULL);

        /* next, we print it out. Usually, you should
           make a copy first since the context is now
           blocked, i.e. nobody else will be allowed to
           make changes to it. */

        FPrintf(to,"Memory map:\n");

        for(mn=(struct MappingNode *)(list->mlh_Head);mn->map_succ;mn=mn->map_succ) {

                FPrintf(to,"0x%08lx - 0x%08lx ",mn->map_Lower,mn->map_Higher);

                if (mn->map_Properties & MAPP_WINDOW) {
                        FPrintf(to,"Window at 0x%08lx\n",mn->map_un.map_UserData);
                        /* All other flags do not care then */
                        continue;
                }

                if (mn->map_Properties & MAPP_WRITEPROTECTED)
                        FPrintf(to,"WriteProtected ");

                if (mn->map_Properties & MAPP_USED)
                        FPrintf(to,"U ");

                if (mn->map_Properties & MAPP_MODIFIED)
                        FPrintf(to,"M ");

                if (mn->map_Properties & MAPP_GLOBAL)
                        FPrintf(to,"Global ");

                if (mn->map_Properties & MAPP_TRANSLATED)
                        FPrintf(to,"TT ");

                if (mn->map_Properties & MAPP_ROM)
                        FPrintf(to,"ROM ");

                if (mn->map_Properties & MAPP_USERPAGE0)
                        FPrintf(to,"UP0 ");

                if (mn->map_Properties & MAPP_USERPAGE1)
                        FPrintf(to,"UP1 ");

                if (mn->map_Properties & MAPP_CACHEINHIBIT)
                        FPrintf(to,"CacheInhibit ");

                if (mn->map_Properties & MAPP_IMPRECISE)
                        FPrintf(to,"Imprecise ");

                if (mn->map_Properties & MAPP_NONSERIALIZED)
                        FPrintf(to,"NonSerial ");

                if (mn->map_Properties & MAPP_COPYBACK)
                        FPrintf(to,"CopyBack ");

                if (mn->map_Properties & MAPP_SUPERVISORONLY)
                        FPrintf(to,"SuperOnly ");

                if (mn->map_Properties & MAPP_BLANK)
                        FPrintf(to,"Blank ");

                if (mn->map_Properties & MAPP_SHARED)
                        FPrintf(to,"Shared ");

                if (mn->map_Properties & MAPP_SINGLEPAGE)
                        FPrintf(to,"Single ");

                if (mn->map_Properties & MAPP_REPAIRABLE)
                        FPrintf(to,"Repairable ");

                if (mn->map_Properties & MAPP_IO)
                        FPrintf(to,"I/O space ");

                if (mn->map_Properties & MAPP_USER0)
                        FPrintf(to,"U0 ");

                if (mn->map_Properties & MAPP_USER1)
                        FPrintf(to,"U1 ");

                if (mn->map_Properties & MAPP_USER2)
                        FPrintf(to,"U2 ");

                if (mn->map_Properties & MAPP_USER3)
                        FPrintf(to,"U3 ");

                if (mn->map_Properties & MAPP_INVALID)
                        FPrintf(to,"Invalid (0x%08lx) ",mn->map_un.map_UserData);

                if (mn->map_Properties & MAPP_SWAPPED)
                        FPrintf(to,"Swapped (0x%08lx) ",mn->map_un.map_UserData);

                if (mn->map_Properties & MAPP_REMAPPED)
                        FPrintf(to,"Remapped to 0x%08lx ",mn->map_un.map_Delta+mn->map_Lower);

                if (mn->map_Properties & MAPP_BUNDLED)
                        FPrintf(to,"Bundled to 0x%08lx ",mn->map_un.map_Page);

                if (mn->map_Properties & MAPP_INDIRECT)
                        FPrintf(to,"Indirect at 0x%08lx ",mn->map_un.map_Descriptor);

                FPrintf(to,"\n");
        }

        ReleaseMapping(NULL,list);
}
///

