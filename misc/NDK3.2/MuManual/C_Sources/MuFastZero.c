/*****************************************************************
 ** MuFastZero                                                  **
 **                                                             **
 ** A MMU library compatible zeropage remapper                  **
 ** Version 40.20 28.4.2001 � THOR-Software, by Thomas Richter  **
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

#include <proto/exec.h>
#include <proto/mmu.h>
#include <proto/dos.h>
#include <proto/icon.h>

#include <string.h>
#include <dos.h>
///
/// Defines
#define STRINGDATE "21.7.2001"
#define STRINGVERSION "40.20"
#define CACHEFLAGS (MAPP_CACHEINHIBIT|MAPP_COPYBACK|MAPP_NONSERIALIZED|MAPP_IMPRECISE)

#define TEMPLATE "ON=FASTZERO/S,OFF=NOFASTZERO/S,FASTEXEC/S,FORCENATIVE/S,MOVESSP=FASTSSP/S,STACKSIZE/K/N,MOVEVBR=FASTVBR/S,CLEARVBR/S,IGNORE/S"

#define OPT_ON  0
#define OPT_OFF 1
#define OPT_FASTEXEC 2
#define OPT_FORCENATIVE 3
#define OPT_FASTSSP 4
#define OPT_STACKSIZE 5
#define OPT_FASTVBR 6
#define OPT_CLEARVBR 7
#define OPT_IGNORE 8
#define OPT_WINDOW 9
#define OPT_COUNT 10

#define LVO_SUMKICKDATA -612
///
/// Statics
struct MMUBase *MMUBase;
struct DosLibrary *DOSBase;
struct ExecBase *SysBase;
struct Library *IconBase;
///
/// Protos
int __asm __saveds main(void);
int BuildFastZero(LONG fastexec,LONG ignore);
int RemoveFastZero(void);
ULONG ChipLowEnd(void);
int KillFastZero(void);
struct RDArgs *ReadTTArgs(struct WBStartup *msg,LONG args[],struct RDArgs **tmp);
BOOL SetPages(struct MMUContext *ctx,ULONG props,ULONG lower,ULONG size,ULONG pagesize,ULONG dest);
int MoveSSP(LONG size);
int MoveVBR(void);
int ClearVBR(void);
void SuperStackSwap(UBYTE *newstack,ULONG size);
///
/// Strukturen
struct FastZeroPort {
        struct MsgPort          frp_Port;
        UWORD                   frp_cludgefill;
        void                   *frp_Logical;            /* Logical position this is remapped to */
        void                   *frp_Physical;           /* Physical location of the RAM used for remapping */
        ULONG                   frp_Lower;              /* where remapping was started */
        ULONG                   frp_Size;               /* size of the allocated memory */
        struct Library         *frp_Base;               /* Keep the library open */
        struct MemHeader       *frp_LowMemHeader;
        ULONG                   frp_CacheFlags;         /* Keeps the caching mode for the remapping destination */
        char                    frp_Name[32];           /* keeps the name of the port */

        struct Library         *frp_MMUBase;
        APTR                    frp_OldSumKickData;     /* the old function to sum up the resident kicks */
};

/* This is the port build by MuMove4k */

struct MuMove4KPort {
        struct MsgPort          mrp_Port;
        UWORD                   mrp_cludgefill;
        void                   *mrp_private;
        struct MemHeader       *mrp_LowMemHeader;
        ULONG                   mrp_UpperEnd;
};


struct FastVBRPort {
        struct MsgPort          fvp_Port;
        char                    fvp_Name[30];           /* Keeps the name of the port, and aligns it */
        ULONG                   fvp_Vectors[0x100];
};

///
/// Externals
extern void __asm CopyMMULess(register __a1 void *to,register __a0 void *from,register __d0 ULONG size);
extern ULONG __asm *GetVBR(void);
extern void __asm SetVBR(register __a0 ULONG *vbr);
extern ULONG __asm NewSumKickData(void);
extern void __asm NewSumKickDataEnd(void);
///

char version[]="$VER: MuFastZero " STRINGVERSION " (" STRINGDATE ") � THOR";

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
LONG stack;


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
                                        Printf("MuFastZero requires a working MMU.\n");
                                        err=10;
                                } else {
                                        /* Argument parser worked, call main routine */
                                        err=0;

                                        if (args[OPT_FORCENATIVE])
                                                err=KillFastZero();

                                        if (err<10 && ((args[OPT_ON]) || ((!args[OPT_OFF]) && (!args[OPT_FASTSSP])
                                                    && (!args[OPT_FASTVBR]) && (!args[OPT_CLEARVBR]))))
                                                        err=BuildFastZero(args[OPT_FASTEXEC],args[OPT_IGNORE]);

                                        if (err<10 && args[OPT_OFF])
                                                err=RemoveFastZero();

                                        if (err<10 && args[OPT_FASTSSP]) {
                                                if (args[OPT_STACKSIZE]) {
                                                        stack=*(LONG *)args[OPT_STACKSIZE];
                                                } else  stack=0;
                                                err=MoveSSP(stack);
                                        }

                                        if (err<10 && args[OPT_CLEARVBR]) {
                                                err=ClearVBR();
                                        }

                                        if (err<10 && args[OPT_FASTVBR]) {
                                                err=MoveVBR();
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
                                if (!msg) PrintFault(err,"MuFastZero failed");
                                rc=10;
                        }
                        SetIoErr(err);

                        CloseLibrary((struct Library *)MMUBase);
                } else if (!msg) PrintFault(ERROR_OBJECT_NOT_FOUND,"MuFastZero requires the mmu.library V41 or better");
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
/// SetPages
BOOL SetPages(struct MMUContext *ctx,ULONG props,ULONG lower,ULONG size,ULONG pagesize,ULONG dest)
{
ULONG pages,i;
ULONG base;

        pages=size/pagesize;
        base=0;
        for(i=0;i<pages;i++) {
                if (!SetPageProperties(ctx,props,~0L,lower+base,MAPTAG_DESTINATION,dest+base,TAG_DONE))
                        return FALSE;
                base+=pagesize;
        }

        return TRUE;
}
///
/// BuildFastZero
int BuildFastZero(LONG fastexec,LONG ignore)
{
void *mem=NULL,*pmem=NULL;
ULONG portsize,codesize;
ULONG pagesize,size,psize,align;
ULONG lower;
struct FastZeroPort *port;
struct MuMove4KPort *mport;
struct MMUContext *ctx,*sctx;   /* default context, supervisorcontext */
struct MinList *ctxl,*sctxl;    /* Copies of the mappings currently active */
int err=ERROR_NO_FREE_STORE;
ULONG props,cacheflags;
BOOL retry;


        Forbid();                               /* Shut up PatchWork */

        /* If this is already installed, warn and return. */

        if (FindPort("� MuFastZero �")) {
                Permit();
                Printf("MuFastZero already running.\n");
                return 5;
        }

        Permit();

        ctx=DefaultContext();   /* get the default context */
        sctx=SuperContext(ctx); /* get the supervisor context for this one */

        /* Read the size */
        pagesize=GetPageSize(ctx);

        /*
        size = pagesize;
        */
        size = ChipLowEnd() & -pagesize;

        if (size>ChipLowEnd()) {
                size=0;
        }
        align=RemapSize(ctx);

        if (fastexec) {
                ULONG infast = 1;
                struct Library *ExpansionBase=NULL;

                Forbid();
                mport=(struct MuMove4KPort *)FindPort("� MuMove4K �");
                if (mport) {
                        size=mport->mrp_UpperEnd;
                }
                Permit();

                ExpansionBase = OpenLibrary("expansion.library",0);
                if (ExpansionBase) {
                        if ((TypeOfMem(ExpansionBase) & MEMF_FAST) == 0)
                                infast = 0;
                        CloseLibrary(ExpansionBase);
                }
                if ((TypeOfMem(SysBase) & MEMF_FAST) == 0)
                        infast = 0;

                if (infast) {
                        Printf("ExecBase is already in fast memory, can't remap ExecBase.\n");
                        return 10;
                }

                if (mport==NULL) {
                        Printf("MuMove4K is not installed, can't remap ExecBase.\n");
                        return 10;
                }
        } else mport=NULL;

        if (size==0) {
                Printf("The MMU page size is too large for MuFastZero.\n");
                return 10;
        }

        codesize = (ULONG)(&NewSumKickDataEnd) - (ULONG)(&NewSumKickData);
        portsize = sizeof(struct FastZeroPort) + codesize;
        port     = AllocVec(portsize,MEMF_CLEAR|MEMF_PUBLIC);
        if (port) {

         memcpy(port+1,&NewSumKickData,(size_t)codesize);

         /* Lock the context, make sure nobody is messing with the memory */
         LockContextList();      /* We've to lock the list first, we want to lock more than one */
         LockMMUContext(ctx);
         LockMMUContext(sctx);
         err=0;

         /* Read the properties of the zeropage. If this is either invalid
            or already remapped, don't touch. */

         lower=0;

         do {

                retry=FALSE;
                props=GetPageProperties(ctx,lower,TAG_DONE);
                props|=GetPageProperties(sctx,lower,TAG_DONE);

                if ((props & MAPP_INVALID) || (props & MAPP_SWAPPED) ||
                    (props & MAPP_SUPERVISORONLY)) {

                        if (fastexec && (size>pagesize)) {
                                size-=pagesize;
                                lower+=pagesize;
                                retry=TRUE;
                        } else {
                                Printf("The zero page is invalidated and can't be remapped.\n");
                                err=10;
                        }
                }
         } while(retry);

         if ((props & MAPP_REMAPPED) && (err==0)) {
                if (!ignore) {
                        Printf("The zero page is already remapped.\n"
                               "In case you want to disable remapping, or want to use the\n"
                               "FASTEXEC option, specify FORCENATIVE to override the\n"
                               "remapping.\n");
                                err=10;
                } else err=2;
         }

         if (err==0L) {

          /* We request FAST here, explicitly. Taking chip memory for the
             image doesn't make sense, this isn't fast either... */

          mem=AllocAligned(size+lower,MEMF_PUBLIC|MEMF_FAST|MEMF_CLEAR,align);
          if (mem) {
           psize=size+lower;
           pmem=mem;
           PhysicalLocation(ctx,&pmem,&psize);
           if (psize!=size+lower) {
                Printf("The allocated memory is fragmentated, unsupported by MuFastZero.\n");
                err=10;
           }
          } else err=ERROR_NO_FREE_STORE;
         }

         if (err==0L) {

            cacheflags=GetProperties(ctx,(ULONG)mem,TAG_DONE) & CACHEFLAGS;

            /* Make a copy of the software levels to be able to restore
               them later in case of an error. */

            if (ctxl=GetMapping(ctx)) {
             if (sctxl=GetMapping(sctx)) {

              /* Modify both contexts such that the zeropage is SINGLE.
                 This operation is very costy, but it doesn't matter
                 except for speed penalties if this is not un-done */

              err=ERROR_NO_FREE_STORE;
              props=MAPP_SINGLEPAGE;

              if (SetProperties(ctx,props,props,lower,size,TAG_DONE)) {
               if (SetProperties(sctx,props,props,lower,size,TAG_DONE)) {
                if (RebuildTrees(ctx,sctx,NULL)) {

                  /* Copy the zeropage over */
                  Disable();

                  /* Fill in SysBase at location 4 */
                  ((ULONG *)mem)[1]=(ULONG)SysBase;
                  memcpy((char *)mem+lower,(char *)lower,(size_t)size);

                  /* The new property flags, or in the cache flags */
                  props=MAPP_REMAPPED|MAPP_SINGLEPAGE|cacheflags;
                  CacheClearU();

                  /* Map in the properties immediately. This should always work,
                     except the parameters are invalid - which they aren't.
                     This extra step is required because all other calls might
                     break the Disable() above. */
                  if (SetPages(ctx,props,lower,size,pagesize,(ULONG)pmem+lower)) {
                   if (SetPages(sctx,props,lower,size,pagesize,(ULONG)pmem+lower)) {

                    /* Tell the contexts to relocate the zero page even in case MuForce
                       is installed later, i.e. the software emulation should read
                       the data from the relocated position, not from the original. */

                    SetMMUContextData(ctx,MCXTAG_ZEROBASE,pmem,TAG_DONE);
                    SetMMUContextData(sctx,MCXTAG_ZEROBASE,pmem,TAG_DONE);

                    /* Now make the modifications in the abstraction level. */
                    if (SetProperties(ctx,props,~0L,lower,size,MAPTAG_DESTINATION,(ULONG)pmem+lower,TAG_DONE)) {
                     if (SetProperties(sctx,props,~0L,lower,size,MAPTAG_DESTINATION,(ULONG)pmem+lower,TAG_DONE)) {

                        /* The modifications in the hardware level are actually already done.
                           Calling RebuildTree isn't stricly required here, but we do it
                           anyways to clear the dirty flags. This might or might not fail,
                           but the resulting MMU trees are always what we want. In
                           case it fails, the dirty flags are set. So what... */

                        /* The RebuildTree's are below... */

                        /* Everything worked fine so far.... */
                        port->frp_Port.mp_Node.ln_Type=NT_MSGPORT;
                        port->frp_Port.mp_Node.ln_Name=port->frp_Name;
                        port->frp_Port.mp_Node.ln_Pri=-100;
                        strcpy(port->frp_Name,"� MuFastZero �");
                        port->frp_Port.mp_Flags=PA_IGNORE;
                        NewList(&(port->frp_Port.mp_MsgList));

                        port->frp_Physical=pmem;
                        port->frp_Logical=mem;
                        port->frp_Size=size;
                        port->frp_Lower=lower;
                        port->frp_CacheFlags=cacheflags;
                        if (mport) {
                                port->frp_LowMemHeader=mport->mrp_LowMemHeader;
                                port->frp_LowMemHeader->mh_Attributes=MEMF_FAST;   /* remove the chip and public attributes */
                        }

                        port->frp_Base=OpenLibrary("mmu.library",0L);
                        port->frp_MMUBase = port->frp_Base;
                        Disable();
                        port->frp_OldSumKickData = SetFunction((struct Library *)SysBase,LVO_SUMKICKDATA,(APTR)(port+1));
                        AddPort(&(port->frp_Port));
                        Enable();

                        /* We're done here. Fine. */
                        err=0;
                        mem=NULL;
                        port=NULL;

                     }
                    }

                   /* We can't set the software level. Urgh. At least, we can
                      restore it how it looked like before. */
                   }
                  }

                  /* We try to restore the hardware tables now. */
                  if (err) {
                        props=MAPP_IMPRECISE|MAPP_NONSERIALIZED|MAPP_CACHEINHIBIT|MAPP_SINGLEPAGE;

                        if ((!SetPageProperties(ctx,props,~0L,0L,TAG_DONE)) ||
                            (!SetPageProperties(sctx,props,~0L,0L,TAG_DONE))) {
                                /* We can't restore the hardware tables either! */
                                Alert(0xbe000101);
                                /* Sorry, go guru. We can't do much more here... */
                        }
                  }
                  Enable();
                }
               }
              }

              /* We can't build the software level. In the one way or the other,
                 just restore the previous software abstraction level. */

              if (err) {
                SetPropertyList(ctx,ctxl);
                SetPropertyList(sctx,sctxl);
              }

              /* The software level is now restored. The
                 hardware level has been restored above.
                 Now call RebuildTree() to clear the dirty
                 flags.
                 If this fails, tough luck. Both levels are
                 actually fine, except for the busy flags. */

              RebuildTrees(ctx,sctx,NULL);

              ReleaseMapping(sctx,sctxl);
             }
             ReleaseMapping(ctx,ctxl);
            }
         }

           /* Release the locks */
         UnlockMMUContext(sctx);
         UnlockMMUContext(ctx);
         UnlockContextList();

         if (mem) FreeMem(mem,size+lower);
         if (port) FreeVec(port);
        }

        return err;
}
///
/// RemoveFastZero
int RemoveFastZero(void)
{
struct MMUContext *ctx,*sctx;
struct MinList *ctxl,*sctxl;
struct FastZeroPort *port;
ULONG size,pagesize,lower;
void *mem,*pmem;
ULONG props,cacheflags;
int err;

        Forbid();                               /* Shut up PatchWork */

        /* If this is not installed, warn and return. */

        port=(struct FastZeroPort *)FindPort("� MuFastZero �");

        if (port==NULL) {
                Permit();
                Printf("MuFastZero not installed.\n");
                return 5;
        }
        /* Remove it, to ensure nobody else tries to remove it */
        RemPort(&(port->frp_Port));
        Permit();

        ctx=DefaultContext();   /* get the default context */
        sctx=SuperContext(ctx); /* get the supervisor context for this one */

        pagesize=GetPageSize(ctx);
        if (GetPageSize(sctx)!=pagesize) {
                Printf("Supervisor and user page size are different,\n"
                       "MuFastZero can't be removed.\n");
                return 10;
        }

        LockContextList();      /* We've to lock the list first, we want to lock more than one */
        LockMMUContext(ctx);
        LockMMUContext(sctx);

        err=ERROR_NO_FREE_STORE;

        /* Make a copy of the mapping like it is now */
        if (ctxl=GetMapping(ctx)) {
         if (sctxl=GetMapping(sctx)) {

          /* Read the properties of the zeropage. If this is either invalid
             or already remapped, don't touch. */

          lower=port->frp_Lower;
          props=GetPageProperties(ctx,lower,TAG_DONE);
          props|=GetPageProperties(sctx,lower,TAG_DONE);
          err=0;

          if ((props & MAPP_INVALID) || (props & MAPP_SWAPPED) ||
              (props & MAPP_SUPERVISORONLY)) {
                Printf("The zero page is now invalidated and can't be restored for that reason.\n");
                err=10;
          }

          if ((err==0) && ((props & MAPP_REMAPPED)==0)) {
                Printf("The zero page is no longer remapped to FastMem.\n");
                err=10;
          }

          /* If everything is fine so far, start removing things */
          if (err==0) {
           size=port->frp_Size;
           pmem=port->frp_Physical;
           mem=port->frp_Logical;
           lower=port->frp_Lower;
           cacheflags=port->frp_CacheFlags;
           Disable();

           err=ERROR_NO_FREE_STORE;
           props=MAPP_NONSERIALIZED|MAPP_IMPRECISE|MAPP_CACHEINHIBIT|MAPP_SINGLEPAGE;       /* This is the only flag for chip memory */

           /* Now copy the data back to the zeropage */
           CopyMMULess((char *)lower,(char *)pmem+lower,size);

           /* First, try to modify the hardware tables. */
           if (SetPages(ctx,props,lower,size,pagesize,lower)) {
            if (SetPages(sctx,props,lower,size,pagesize,lower)) {

             /* read the data again from the real stuff */
             SetMMUContextData(ctx,MCXTAG_ZEROBASE,0L,TAG_DONE);
             SetMMUContextData(sctx,MCXTAG_ZEROBASE,0L,TAG_DONE);

             /* Restore the software level,singlepage is no longer required */

             props=MAPP_NONSERIALIZED|MAPP_IMPRECISE|MAPP_CACHEINHIBIT;
             if (SetProperties(ctx,props,~0L,lower,size,TAG_DONE)) {
              if (SetProperties(sctx,props,~0L,lower,size,TAG_DONE)) {

                        if (port->frp_LowMemHeader) {
                                /* No, neither public nor anything else */
                                port->frp_LowMemHeader->mh_Attributes=MEMF_CHIP;
                        }

                        Forbid();
                        SetFunction((struct Library *)SysBase,LVO_SUMKICKDATA,port->frp_OldSumKickData);
                        Permit();
                        FreeMem(mem,size+lower);
                        if (port->frp_Base)
                                CloseLibrary(port->frp_Base);

                        FreeVec(port);
                        err=0;
              }
             }

              /* We can't setup the software level. Urgh. At least,
                 we should try to set things back how they used to be. */
            }
           }


           /* We try to restore the hardware tables now. */
           if (err) {
                props=MAPP_REMAPPED|MAPP_SINGLEPAGE|cacheflags;
                SetMMUContextData(ctx,MCXTAG_ZEROBASE,(ULONG)pmem+lower,TAG_DONE);
                SetMMUContextData(sctx,MCXTAG_ZEROBASE,(ULONG)pmem+lower,TAG_DONE);

                if ((!SetPages(ctx,props,lower,size,pagesize,(ULONG)pmem+lower)) ||
                    (!SetPages(sctx,props,lower,size,pagesize,(ULONG)pmem+lower))) {
                        /* We can't restore the hardware tables either! */
                        Alert(0xbe000101);
                        /* Sorry, go guru. We can't do much more here... */
                }
           }
           Enable();

           if (err) {
                SetPropertyList(ctx,ctxl);
                SetPropertyList(sctx,sctxl);
                /* More luck next time */
                AddPort(&(port->frp_Port));
           }

             /* The software level is now restored. The
                hardware level has been restored above.
                Now call RebuildTree() to clear the dirty
                flags.
                If this fails, tough luck. Both levels are
                actually fine, except for the busy flags. */

           RebuildTrees(ctx,sctx,NULL);
          }
          ReleaseMapping(sctx,sctxl);
         }
         ReleaseMapping(ctx,ctxl);
        }


        UnlockMMUContext(sctx);
        UnlockMMUContext(ctx);
        UnlockContextList();      /* We've to lock the list first, we want to lock more than one */

        if (err) {
                /* Uhoh, things didn't work here... */
                Printf("Can't remove the FastZero node, sorry.\n");
        }

        return err;
}
///
/// KillFastZero
int KillFastZero(void)
{
struct FastZeroPort *port;
struct MMUContext *ctx,*sctx;   /* default context, supervisorcontext */
struct MinList *ctxl,*sctxl;    /* Copies of the mappings currently active */
ULONG pagesize;
ULONG lower,size,props;
ULONG userpos,superpos,base;
int err;
BOOL retry;


        Forbid();                               /* Shut up PatchWork */

        /* If MuFastZero is installed, remove it the easy way */

        port=(struct FastZeroPort *)FindPort("� MuFastZero �");

        if (port) {
                Permit();
                return RemoveFastZero();
        }

        Permit();

        ctx=DefaultContext();   /* get the default context */
        sctx=SuperContext(ctx); /* get the supervisor context for this one */

        /* Read the size */
        pagesize=GetPageSize(ctx);

        if (GetPageSize(sctx)!=pagesize) {
                Printf("Supervisor and user page size are different,\n"
                       "MuFastZero failed.\n");
                return 10;
        }

        /* Lock the context, make sure nobody is messing with the memory */
        LockContextList();      /* We've to lock the list first, we want to lock more than one */
        LockMMUContext(ctx);
        LockMMUContext(sctx);
        err=0;

        /* Read the properties of the zeropage. If this is either invalid
           or not remapped, don't touch. */

        lower=0;
        size=0;
        base=0;

        do {

                retry=FALSE;
                userpos=superpos=0;
                props=GetPageProperties(ctx,lower+size,
                                        MAPTAG_DESTINATION,&userpos,
                                        TAG_DONE);
                props|=GetPageProperties(sctx,lower+size,
                                         MAPTAG_DESTINATION,&superpos,
                                         TAG_DONE);

                if ((props & MAPP_INVALID) || (props & MAPP_SWAPPED) ||
                    (props & MAPP_SUPERVISORONLY)) {

                        lower += pagesize;
                        retry = TRUE;

                } else if (props & MAPP_REMAPPED) {
                        if (userpos == superpos) {

                                if (base==0) {
                                        base = userpos;
                                }
                                /* Adjacent? */
                                if (base+size == userpos) {
                                        size += pagesize;
                                        retry = TRUE;
                                }
                        }
                }

        } while(retry);

        if (size==0L) {
                Printf("MuFastZero: FORCENATIVE option is not required.\n");
                err = 5;
        }

         /* lower is now the lower end which is remapped.
            size is the length of the remapped memory
            base is the address it is remapped to */

        if (err==0L) {

         /* Make a copy of the software levels to be able to restore
            them later in case of an error. */

         if (ctxl=GetMapping(ctx)) {
          if (sctxl=GetMapping(sctx)) {

           /* Modify both contexts such that the zeropage is SINGLE.
              This operation is very costy, but it doesn't matter
              except for speed penalties if this is not un-done */

              err=ERROR_NO_FREE_STORE;
              props=MAPP_SINGLEPAGE;

           if (SetProperties(ctx,props,props,lower,size,TAG_DONE)) {
            if (SetProperties(sctx,props,props,lower,size,TAG_DONE)) {
             if (RebuildTrees(ctx,sctx,NULL)) {

               Disable();

               /* The new property flags */
               props=MAPP_NONSERIALIZED|MAPP_IMPRECISE|MAPP_SINGLEPAGE|MAPP_CACHEINHIBIT;
               CacheClearU();
               CopyMMULess((void *)lower,(void *)base,size);

               /* Map in the properties immediately. This should always work,
                  except the parameters are invalid - which they aren't.
                  This extra step is required because all other calls might
                  break the Disable() above. */

               if (SetPages(ctx,props,lower,size,pagesize,0L)) {
                if (SetPages(sctx,props,lower,size,pagesize,0L)) {

                 /* Tell the contexts not to relocate the zero page even in case MuForce
                    is installed later, i.e. the software emulation should read
                    the data from the relocated position, not from the original. */

                 SetMMUContextData(ctx,MCXTAG_ZEROBASE,0L,TAG_DONE);
                 SetMMUContextData(sctx,MCXTAG_ZEROBASE,0L,TAG_DONE);

                 /* Now make the modifications in the abstraction level. */
                 if (SetProperties(ctx,props,~0L,lower,size,TAG_DONE)) {
                  if (SetProperties(sctx,props,~0L,lower,size,TAG_DONE)) {

                        /* The modifications in the hardware level are actually already done.
                           Calling RebuildTree isn't stricly required here, but we do it
                           anyways to clear the dirty flags. This might or might not fail,
                           but the resulting MMU trees are always what we want. In
                           case it fails, the dirty flags are set. So what... */

                        /* We're done here. Fine. */
                        err=0;
                  }
                 }
                 /* We can't set the software level. Urgh. At least, we can
                    restore it how it looked like before. */
                }
               } /* of if SetPages */

               /* We try to restore the hardware tables now. */
               if (err) {
                props=MAPP_REMAPPED|MAPP_SINGLEPAGE|MAPP_COPYBACK;
                SetMMUContextData(ctx,MCXTAG_ZEROBASE,base,TAG_DONE);
                SetMMUContextData(sctx,MCXTAG_ZEROBASE,base,TAG_DONE);

                if ((!SetPages(ctx,props,lower,size,pagesize,base)) ||
                    (!SetPages(sctx,props,lower,size,pagesize,base))) {
                        /* We can't restore the hardware tables either! */
                        Alert(0xbe000101);
                        /* Sorry, go guru. We can't do much more here... */
                }
               }

               Enable();
             }
            }
           } /* of if SetProperties() */

           /* We can't build the software level. In the one way or the other,
              just restore the previous software abstraction level. */

           if (err) {
                SetPropertyList(ctx,ctxl);
                SetPropertyList(sctx,sctxl);
           }

           /* The software level is now restored. The
              hardware level has been restored above.
              Now call RebuildTree() to clear the dirty
              flags.
              If this fails, tough luck. Both levels are
              actually fine, except for the busy flags. */

           RebuildTrees(ctx,sctx,NULL);

           ReleaseMapping(sctx,sctxl);
          } /* of if made copy */
          ReleaseMapping(ctx,ctxl);
         } /* of if made copy */
        } /* of if (err==0) */

          /* Release the locks */
        UnlockMMUContext(sctx);
        UnlockMMUContext(ctx);
        UnlockContextList();

        return err;
}
///
/// ChipLowEnd
ULONG ChipLowEnd(void)
{
ULONG low;
struct MemHeader *head;

        low=0x00200000;         /* This is definitely the upper end of chip mem */

        Forbid();
        for(head=(struct MemHeader *)SysBase->MemList.lh_Head;
                   head->mh_Node.ln_Succ;
                   head=(struct MemHeader *)(head->mh_Node.ln_Succ)) {
                if (head->mh_Attributes & MEMF_CHIP) {
                        if ((ULONG)(head->mh_Lower)<low) {
                                low=(ULONG)(head->mh_Lower);
                        }
                }
        }
        Permit();

        return low;
}
///
/// MoveSSP
int MoveSSP(LONG stacksize)
{
ULONG minsize;
struct Task *task;
UBYTE *newstack;

        minsize=(UBYTE *)SysBase->SysStkUpper-(UBYTE *)SysBase->SysStkLower;
        if (stacksize<minsize) {
                task=FindTask(NULL);
                stacksize=(UBYTE *)(task->tc_SPUpper)-(UBYTE *)(task->tc_SPLower);
        }
        if (stacksize<minsize)
                stacksize=minsize;

        /* Round this to two cache lines */

        stacksize += 0x1f;
        stacksize &= ~0x1f;

        /* This must be fast, or this function is a joke... */
        newstack=AllocMem(stacksize,MEMF_CLEAR|MEMF_PUBLIC|MEMF_FAST);

        if (newstack==NULL) {
                return ERROR_NO_FREE_STORE;
        }

        SuperStackSwap(newstack,stacksize);

        return 0;
}
///
/// SuperStackSwap
void SuperStackSwap(UBYTE *newstack,ULONG size)
{
UBYTE *oldsp,*newsp;
size_t oldsize;
UWORD sum;
UWORD *p;

        /* Yup, this is possible in C */
        Disable();
        oldsp=SuperState();

        /* copy the stack over to the upper limit */
        oldsize=(UBYTE *)(SysBase->SysStkUpper)-oldsp;
        if (oldsize>0 && oldsize<size) {
                newsp=newstack+size-oldsize;
                memcpy(newsp,oldsp,oldsize);
        } else  newsp=newstack+size;
        UserState(newsp);

        /* Now tell this exec! */
        SysBase->SysStkUpper=newstack+size;
        SysBase->SysStkLower=newstack;

        /* Recalculate the checksum */
        p=&SysBase->SoftVer;
        sum=0xffff;
        while(p<&SysBase->ChkSum)
                sum -= *p++;

        SysBase->ChkSum=sum;
        Enable();

}
///
/// MoveVBR
int MoveVBR(void)
{
ULONG *vbr;
struct FastVBRPort *fvp;
struct MsgPort *old;


        if ((SysBase->AttnFlags & AFF_68010)==0) {
                Printf("MuFastZero failed: MoveVBR requires at least an 68010 or better.\n");
                return 10;
        }

        vbr=GetVBR();

        if (TypeOfMem(vbr) & MEMF_FAST) {
                Printf("The vector base register is already in fast memory.\n");
                return 5;
        }

        if (fvp=AllocVec(sizeof(struct FastVBRPort),MEMF_PUBLIC | MEMF_FAST | MEMF_CLEAR)) {

                fvp->fvp_Port.mp_Node.ln_Type   =       NT_MSGPORT;
                fvp->fvp_Port.mp_Node.ln_Pri    =       -100;
                fvp->fvp_Port.mp_Node.ln_Name   =       fvp->fvp_Name;
                fvp->fvp_Port.mp_Flags          =       PA_IGNORE;
                NewList(&(fvp->fvp_Port.mp_MsgList));
                strcpy(fvp->fvp_Name,"� FastVBR �");

                Forbid();
                Disable();
                memcpy(fvp->fvp_Vectors,GetVBR(),0x400);
                CacheClearU();
                SetVBR(fvp->fvp_Vectors);
                Enable();
                /* Check whether we have an old instance of us. Strange... */
                old=FindPort("� FastVBR �");

                if (old) {
                        RemPort(old);
                        FreeVec(old);
                }
                AddPort(&(fvp->fvp_Port));
                Permit();

                return 0;
        }

        return ERROR_NO_FREE_STORE;
}
///
/// ClearVBR
int ClearVBR(void)
{
ULONG *vbr;
ULONG props;
struct MsgPort *old;

        if ((SysBase->AttnFlags & AFF_68010)==0) {
                vbr = 0;
        } else  vbr = GetVBR();

        if (vbr == 0L) {
                Printf("The vector base register is already cleared.\n");
                return 5;
        }

        props = GetProperties(DefaultContext(),0L,TAG_DONE);

        if (props & (MAPP_INVALID | MAPP_SWAPPED | MAPP_SUPERVISORONLY | MAPP_WRITEPROTECTED)) {
                Printf("The zero page is invalidated, can't reset the vector base.\n");
                return 5;
        }

        /* Hence, re-set it */
        Forbid();
        Disable();
        /* Copy the vectors back */
        memcpy((void *)(8L),2L+GetVBR(),0x400-8L);
        CacheClearU();
        SetVBR(0L);
        Enable();

        old=FindPort("� FastVBR �");

        if (old) {
                RemPort(old);
                FreeVec(old);
        }
        Permit();

        return 0;
}
///

