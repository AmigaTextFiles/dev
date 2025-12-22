/*****************************************************************
 ** MuFastRom                                                   **
 **                                                             **
 ** A MMU-Library compatible ROM remapper                       **
 ** Version 46.2 03.07.2016 © THOR-Software, by Thomas Richter  **
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
///
/// Defines
#define STRINGDATE "03.07.2016"
#define STRINGVERSION "46.2"
#define ROMEND 0x01000000L
#define MAGIC_ROMEND 0x14L
#define CD32ROMSTART 0x00e00000
#define CD32ROMEND   0x00e80000
#define CACHEFLAGS (MAPP_CACHEINHIBIT|MAPP_COPYBACK|MAPP_NONSERIALIZED|MAPP_IMPRECISE)
#define TEMPLATE "ON=FASTROM/S,OFF=NOFASTROM/S,HEAD/S,PROTECT/S,NOPROTECT/S"

#define OPT_ON  0
#define OPT_OFF 1
#define OPT_HEAD 2
#define OPT_PROTECT 3
#define OPT_NOPROTECT 4
#define OPT_WINDOW 5
#define OPT_COUNT 6
///
/// Statics
struct MMUBase *MMUBase;
struct DosLibrary *DOSBase;
struct ExecBase *SysBase;
struct Library *IconBase;
///
/// Protos
int __asm __saveds main(void);
int BuildFastRom(LONG head,LONG protect,LONG noprotect);
int RemoveFastRom(void);
BOOL MapToRom(struct MMUContext *ctx,BOOL cd32,ULONG oldlocation,ULONG oldlower,ULONG source,ULONG mem,ULONG size);
BOOL RemapToRam(struct MMUContext *ctx,BOOL cd32,ULONG source,ULONG pmem,ULONG mem,ULONG size,LONG protect,LONG noprotect,ULONG cacheflags);
struct RDArgs *ReadTTArgs(struct WBStartup *msg,LONG args[],struct RDArgs **tmp);
BOOL Detect1MBRom(void);
///
/// Strukturen
struct FastRomPort {
        struct MsgPort          frp_Port;
        UBYTE                   frp_NoProtect;
        UBYTE                   frp_Protect;
        void                   *frp_Logical;            /* Logical address of the remapped ROM */
        void                   *frp_Physical;           /* Physical location of the RAM used for remapping */
        void                   *frp_RomStart;
        ULONG                   frp_Size;               /* size of the allocated memory */
        struct Library         *frp_Base;               /* Keep the library open */
        ULONG                   frp_CacheFlags;         /* keeps the cache mode of the remapped ROM */
        void                   *frp_OldLocation;        /* In case the ROM was remapped before, it was here. */
        ULONG                   frp_AllocSize;          /* Size that had been allocated for the ROM */
        void                   *frp_OldLowerLocation;   /* In case this was a CD32 remapped ROM, this is where the lower ROM was mapped to */
        char                    frp_Name[32];           /* keeps the name of the port */
};
///

char version[]="$VER: MuFastRom " STRINGVERSION " (" STRINGDATE ") © THOR";

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
                                        Printf("MuFastRom requires a working MMU.\n");
                                        err=10;
                                } else {
                                        /* Argument parser worked, call main routine */
                                        if ((args[OPT_ON]) || (!args[OPT_OFF])) /* ON is the default if OFF is not given */
                                                err=BuildFastRom(args[OPT_HEAD],args[OPT_PROTECT],args[OPT_NOPROTECT]);

                                        if (args[OPT_OFF])
                                                err=RemoveFastRom();
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
                                if (!msg) PrintFault(err,"MuFastRom failed");
                                rc=10;
                        }
                        SetIoErr(err);

                        CloseLibrary((struct Library *)MMUBase);
                } else if (!msg) PrintFault(ERROR_OBJECT_NOT_FOUND,"MuFastRom requires the mmu.library V41 or better");
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
/// BuildFastRom
int BuildFastRom(LONG head,LONG protect,LONG noprotect)
{
void *mem,*source,*pmem,*oldlocation,*oldlower = NULL;
BOOL cd32 = FALSE;
ULONG size,psize,allocsize;
ULONG props;
struct FastRomPort *port;
struct MMUContext *ctx,*sctx;   /* default context, supervisorcontext */
struct MinList *ctxl,*sctxl;
int err=ERROR_NO_FREE_STORE;


        Forbid();                               /* Shut up PatchWork */

        /* If this is already installed, warn and return. */

        if (FindPort("« MuFastRom »")) {
                Permit();
                Printf("MuFastRom already running.\n");
                return 5;
        }
        if (Detect1MBRom())
                cd32 = TRUE;
        Permit();

        ctx=DefaultContext();   /* get the default context */
        sctx=SuperContext(ctx); /* get the supervisor context for this one */


        /* If this is a CD32, the ROM is 1MB in size */
        if (cd32) {
                size        = 0x00080000; /* size of an individual ROM */
                allocsize   = 0x00100000;
                source      = (void *)0x00f80000; /* source of the upper rom */
        } else {
                /* Read the size of the ROM */
                size        =*((ULONG *)(ROMEND-MAGIC_ROMEND));
                allocsize   = size;
                /* The start of the ROM */
                source      = ((UBYTE *)ROMEND)-size;
        }

        props       = GetProperties(sctx,(ULONG)source,TAG_DONE);
        props      |= GetProperties(ctx,(ULONG)source,TAG_DONE);
        oldlocation = source;

        if (props & MAPP_REMAPPED) {
                ULONG romsize = size;
                /*
                 * Find out where the ROM is going to
                 */
                PhysicalLocation(ctx,&oldlocation,&romsize);
                if (romsize > 0 && (TypeOfMem(oldlocation) & MEMF_FAST)) {
                        Printf("The ROM is already remapped to Fast RAM.\n");
                        return 5;
                }

                /* the lower ROM might also be remapped */
                if (cd32) {
                 romsize  = size;
                 oldlower = (void*)CD32ROMSTART;
                 PhysicalLocation(ctx,&oldlower,&romsize);
                 if (romsize > 0 && (TypeOfMem(oldlower) & MEMF_FAST)) {
                         Printf("The lower CD32 ROM is already remapped to Fast RAM.\n");
                         return 5;
                 }
                }
        }



        /* now allocate the memory for the ROM image. To keep the
           MMU tables as effective as possible, we try to align
           this */

        /* We request FAST here, explicitly. Taking chip memory for the
           ROM image doesn't make sense, this isn't fast either... */

        mem=AllocAligned(allocsize,(head)?(MEMF_PUBLIC|MEMF_FAST):(MEMF_REVERSE|MEMF_PUBLIC|MEMF_FAST),RemapSize(ctx));
        if (mem) {
                pmem=mem;
                psize=size;
                PhysicalLocation(ctx,&pmem,&psize);
                if (psize!=size) {
                        Printf("The destination memory is fragmentated, unsupported.\n");
                } else {

                 /* Read the cache flags */
                 props=GetProperties(ctx,(ULONG)mem,TAG_DONE) & CACHEFLAGS;

                 /* Copy the ROM */
                 if (cd32) {
                        /* The lower rom goes to the upper area */
                        CopyMemQuick((void *)CD32ROMSTART,(UBYTE *)mem + size,size);
                 }
                 CopyMemQuick(source,mem,size);

                 /* Write it out, really */
                 CacheClearU();

                 port=AllocMem(sizeof(struct FastRomPort),MEMF_PUBLIC|MEMF_CLEAR);
                 if (port) {
                        LockContextList();
                        LockMMUContext(ctx);
                        LockMMUContext(sctx);
                        if (ctxl=GetMapping(ctx)) {
                         if (sctxl=GetMapping(ctx)) {
                          if (RemapToRam(ctx,cd32,(ULONG)source,(ULONG)pmem,(ULONG)mem,size,protect,noprotect,props)) {
                           if (RemapToRam(sctx,cd32,(ULONG)source,(ULONG)pmem,(ULONG)mem,size,protect,noprotect,props)) {
                            if (RebuildTrees(ctx,sctx,NULL)) {

                                        /* we're done now */
                                        port->frp_Port.mp_Node.ln_Type=NT_MSGPORT;
                                        port->frp_Port.mp_Node.ln_Name=port->frp_Name;
                                        strcpy(port->frp_Name,"« MuFastRom »");
                                        port->frp_Port.mp_Flags=PA_IGNORE;
                                        NewList(&(port->frp_Port.mp_MsgList));

                                        port->frp_RomStart=source;
                                        port->frp_Physical=pmem;
                                        port->frp_Logical=mem;
                                        port->frp_Size=size;
                                        port->frp_AllocSize=allocsize;
                                        port->frp_NoProtect=noprotect;
                                        port->frp_Protect=protect;
                                        port->frp_CacheFlags=props;
                                        port->frp_OldLocation=oldlocation;
                                        port->frp_OldLowerLocation=oldlower;
                                        port->frp_Base=OpenLibrary("mmu.library",0L);
                                        AddPort(&(port->frp_Port));

                                        /* Do not release the memory or the port */
                                        mem=NULL;
                                        port=NULL;

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
                        if (port) FreeMem(port,sizeof(struct FastRomPort));
                 }
                }
                if (mem) FreeMem(mem,allocsize);
        }

        return err;
}
///
/// RemoveFastRom
int RemoveFastRom(void)
{
struct MMUContext *ctx,*sctx;
struct MinList *ctxl,*sctxl;
struct FastRomPort *port;
ULONG size,props,allocsize;
void *mem,*pmem,*source,*location,*lowerloc;
BOOL cd32 = FALSE;
int err=ERROR_NO_FREE_STORE;


        Forbid();                               /* Shut up PatchWork */

        /* If this is not installed, warn and return. */

        port=(struct FastRomPort *)FindPort("« MuFastRom »");

        if (port==NULL) {
                Permit();
                Printf("MuFastRom not installed.\n");
                return 5;
        }
        /* Remove it, to ensure nobody else tries to remove it */
        RemPort(&(port->frp_Port));

        Permit();

        ctx=DefaultContext();   /* get the default context */
        sctx=SuperContext(ctx); /* get the supervisor context for this one */

        size=port->frp_Size;
        allocsize=port->frp_AllocSize;
        /* If this is an older version of MuFastRom, then allocsize might be off...
        */
        if ((size << 1) == allocsize) {
                cd32 = TRUE;
        } else if (size != allocsize) {
                allocsize = size;
        }
        pmem=port->frp_Physical;
        mem=port->frp_Logical;
        source=port->frp_RomStart;
        location=port->frp_OldLocation;
        lowerloc=port->frp_OldLowerLocation;
        props=port->frp_CacheFlags;

        /* Remove the properties right here... */

        LockContextList();
        LockMMUContext(ctx);
        LockMMUContext(sctx);

        if (ctxl=GetMapping(ctx)) {
         if (sctxl=GetMapping(sctx)) {
          if (MapToRom(ctx,cd32,(ULONG)location,(ULONG)lowerloc,(ULONG)source,(ULONG)mem,size)) {
           if (MapToRom(sctx,cd32,(ULONG)location,(ULONG)lowerloc,(ULONG)source,(ULONG)mem,size)) {
            if (RebuildTrees(ctx,sctx,NULL)) {

                        /* CD32 allocates twice the indicated size
                        ** for both halves of the ROM.
                        */
                        FreeMem(mem,allocsize);

                        /* Close the mmu.lib so it can be flushed... */

                        if (port->frp_Base)
                                CloseLibrary(port->frp_Base);

                        FreeMem(port,sizeof(struct FastRomPort));
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

        if (err) {
                /* Better luck next time... */
                AddPort(&(port->frp_Port));
                Printf("Can't remove the FastRom node, sorry.\n");
        }

        return err;
}
///
/// RemapToRam
/* Remap ROM to RAM. source is the logical address to map, or the address of the upper ROM
** for CD32.
** pmem is the physical page address of the destination memory that contains the ROM mirror,
** or the physical address of the remapped upper ROM for CD32.
** mem is the logical page address of the destination memory that contains the ROM mirror,
** or the logical address of the remapped upper ROM for CD 32.
** size is the size of the ROM, or the size of the upper ROM half for CD32.
*/
BOOL RemapToRam(struct MMUContext *ctx,BOOL cd32,ULONG source,ULONG pmem,ULONG mem,ULONG size,LONG protect,LONG noprotect,ULONG cacheflags)
{
ULONG oldprops;
ULONG rommask,mirrormask;

        /* get the properties of the ROM */
        oldprops=GetProperties(ctx,source,TAG_DONE);

        oldprops |= MAPP_REMAPPED;
        rommask=MAPP_REMAPPED|MAPP_COPYBACK;   /* Define these bits for the ROM image */
        mirrormask=0;                          /* ...and these for the RAM mirror */

        /* Protection enabled? */
        if (protect) {
                /* active or passive protection? */
                if (oldprops & MAPP_WRITEPROTECTED) {
                        /* here aggressive, enable protection
                           and allow MuForce to repair access faults */
                        rommask |= MAPP_WRITEPROTECTED|MAPP_REPAIRABLE;
                        mirrormask |= MAPP_WRITEPROTECTED|MAPP_REPAIRABLE;
                } else {
                        rommask |= MAPP_ROM;
                        mirrormask |= MAPP_ROM;
                        oldprops |= MAPP_ROM;
                }
        } else if (noprotect) {
                /* disable all kinds of protection */
                oldprops &= ~(MAPP_ROM|MAPP_WRITEPROTECTED);
                rommask |= MAPP_ROM | MAPP_WRITEPROTECTED;
                mirrormask |= MAPP_ROM | MAPP_WRITEPROTECTED;
        }

        /* Enter caching mode */
        oldprops &= ~CACHEFLAGS;
        oldprops |= cacheflags;
        rommask  |= CACHEFLAGS;

        if (SetProperties(ctx,oldprops,rommask,source,size,MAPTAG_DESTINATION,pmem,TAG_DONE)) {
         if (SetProperties(ctx,oldprops,mirrormask,mem,size,TAG_DONE)) {
          if (cd32) {
                if (SetProperties(ctx,oldprops,rommask,CD32ROMSTART,size,MAPTAG_DESTINATION,pmem+size,TAG_DONE)) {
                 if (SetProperties(ctx,oldprops,mirrormask,mem+size,size,TAG_DONE)) {
                  return TRUE;
                 }
                }
          } else {
                return TRUE;
          }
         }
        }

        return FALSE;
}
///
/// MapToRom
/* oldlocation is the physical location where the ROM was mapped to before
** MuFastRom jumped in. source is the physical location of the upper ROM.
** mem is logical address where the ROM was mapped to.
*/
BOOL MapToRom(struct MMUContext *ctx,BOOL cd32,ULONG oldlocation,ULONG oldlower,ULONG source,ULONG mem,ULONG size)
{
BOOL res;


        if (oldlocation == source) {
                // No ROM remapping
                res = SetProperties(ctx,0,MAPP_REMAPPED|CACHEFLAGS,source,size,TAG_DONE);
                if (res && cd32)
                 res = SetProperties(ctx,0,MAPP_REMAPPED|CACHEFLAGS,CD32ROMSTART,size,TAG_DONE);
        } else {
                // ROM was remapped
                res = SetProperties(ctx,MAPP_REMAPPED,MAPP_REMAPPED|CACHEFLAGS,source,size,MAPTAG_DESTINATION,oldlocation,TAG_DONE);
                if (res && cd32 && oldlower)
                 res = SetProperties(ctx,MAPP_REMAPPED,MAPP_REMAPPED|CACHEFLAGS,CD32ROMSTART,size,MAPTAG_DESTINATION,oldlower,TAG_DONE);
        }

        if (res) {
         if (SetProperties(ctx,0,MAPP_ROM|MAPP_WRITEPROTECTED|MAPP_REPAIRABLE,mem,size,TAG_DONE)) {
          if (cd32) {
            if (SetProperties(ctx,0,MAPP_ROM|MAPP_WRITEPROTECTED|MAPP_REPAIRABLE,mem+size,size,TAG_DONE)) {
             return TRUE;
            }
           } else {
            return TRUE;
          }
         }
        }

        return FALSE;
}
///
/// Detect1MBRom
/* Detect the presence of a 1MB rom by checking the exec kick tags.
** If there is any kick tag in the 512K extended region, we must
** have a 1MB ROM.
*/
BOOL Detect1MBRom(void)
{
ULONG   *tagptr = (ULONG *)(SysBase->KickTagPtr);

        while(tagptr) {
              ULONG tag = *tagptr++;
              if (tag & (1UL << 31)) {
                        tagptr = (ULONG *)(tag & (~(1UL << 31)));
                        continue;
              } else if (tag == 0) {
                        break;
              }
              if (tag >= CD32ROMSTART && tag < CD32ROMEND) {
                        return TRUE;
              }
        }
        return FALSE;
}
///


