#include <exec/types.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/execbase.h>
#include <mmu/context.h>
#include <mmu/mmubase.h>
#include <mmu/mmutags.h>
#include <mmu/exceptions.h>
#include <utility/tagitem.h>

#define DOS_IO
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/mmu.h>
#include <string.h>

struct ExecBase *SysBase;
struct DosLibrary *DOSBase;
struct MMUBase *MMUBase;
/*
** This pointer is used as "window indicator" and keeps
** the window context once we switch. The mmulib stores
** here the currently active context in the window.
*/
struct ContextWindow *window = NULL;

/*
** This is a pointer to the memory we allocated.
** It is used by the exception handler to allow the
** switch
*/
UBYTE *magicpage = NULL;
ULONG  magicsize = 0;
struct MMUContext *defaultcontext;
struct MMUContext *window1;
struct MMUContext *window2;

int TestMMUFun(struct MMUContext *defctx,struct MMUContext *win1,struct MMUContext *win2,
               UBYTE *memory,ULONG pagesize,ULONG memflags);

int __asm __interrupt __saveds mySwapHandler(register __a0 struct ExceptionData *exc);


int __asm __saveds main(void)
{
int rc = 20;

        SysBase = *((struct ExecBase **)4L);
        DOSBase = (struct DosLibrary *)OpenLibrary("dos.library",40L);
        if (DOSBase) {
                MMUBase = (struct MMUBase *)OpenLibrary("mmu.library",46L);
                if (MMUBase) {
                        struct MMUContext *ctx  = DefaultContext();
                        ULONG pagesize          = GetPageSize(ctx);
                        struct MMUContext *set1 = CreateMMUContext(TAG_DONE);
                        struct MMUContext *set2 = CreateMMUContext(TAG_DONE);
                        struct MinList *mapping = GetMapping(ctx);
                        UBYTE *memrange         = AllocAligned(pagesize * 3,MEMF_PUBLIC|MEMF_CLEAR,pagesize);
                        window                  = CreateContextWindow(ctx,set1,set2,NULL);
                        if (memrange && set1 && set2 && mapping && window) {
                                BOOL working    = TRUE;
                                ULONG memflags  = GetMappingProperties(mapping,(ULONG)memrange,TAG_DONE);
                                /* Get the properties of the original memory at the page we want to access */
                                if (!SetProperties(set1,MAPP_INVALID,~0,0UL,1UL<<31,TAG_DONE))
                                        working = FALSE;
                                if (!SetProperties(set1,MAPP_INVALID,~0,1UL<<31,1UL<<31,TAG_DONE))
                                        working = FALSE;
                                /* Mark the full window area as USER0 so we get a distinct range and distict
                                ** descriptors for this range
                                */
                                if (!SetProperties(set1,MAPP_INVALID|MAPP_USER0,~0,(ULONG)memrange,pagesize * 3,TAG_DONE))
                                        working = FALSE;
                                /* Mark an area in the allocated region a remapping to the memrange */
                                if (!SetProperties(set1,MAPP_REMAPPED|memflags,~0,(ULONG)memrange+pagesize,pagesize,
                                        MAPTAG_DESTINATION,memrange,TAG_DONE))
                                        working = FALSE;
                                /* Quite the same for the second area */
                                if (!SetProperties(set2,MAPP_INVALID,~0,0UL,1UL<<31,TAG_DONE))
                                        working = FALSE;
                                if (!SetProperties(set2,MAPP_INVALID,~0,1UL<<31,1UL<<31,TAG_DONE))
                                        working = FALSE;
                                if (!SetProperties(set2,MAPP_INVALID|MAPP_USER0,~0,(ULONG)memrange,pagesize * 3,TAG_DONE))
                                        working = FALSE;
                                if (!SetProperties(set2,MAPP_REMAPPED|memflags,~0,(ULONG)memrange+pagesize * 2,pagesize,
                                        MAPTAG_DESTINATION,memrange,TAG_DONE))
                                        working = FALSE;
                                /* Create a window in the default context */
                                if (!SetProperties(ctx,MAPP_WINDOW,~0,(ULONG)memrange,pagesize * 3,
                                        MAPTAG_WINDOWCTXPTRPTR,window,TAG_DONE))
                                        working = FALSE;
                                Printf("Mapping windows into the default context\n");
                                /* Re-layout the context so it fits to the mapping */
                                if (!LayoutContextWindow(window))
                                        working = FALSE;
                                if (working) {
                                        rc = TestMMUFun(ctx,set1,set2,memrange,pagesize,memflags);
                                        ReleaseMapping(ctx,mapping);
                                        mapping = NULL;
                                } else {
                                        /* Undo the mapping */
                                        SetPropertyList(ctx,mapping);
                                        RebuildTree(ctx);
                                        ReleaseMapping(ctx,mapping);
                                        mapping = NULL;
                                }
                        }
                        /* Release all the structures */
                        if (memrange)
                                FreeMem(memrange,3 * pagesize);
                        if (mapping)
                                ReleaseMapping(ctx,mapping);
                        if (window)
                                ReleaseContextWindow(window);
                        if (set1)
                                DeleteMMUContext(set1);
                        if (set2)
                                DeleteMMUContext(set2);
                        CloseLibrary((struct Library *)MMUBase);
                }
                CloseLibrary((struct Library *)DOSBase);
        }
        return rc;
}

int TestMMUFun(struct MMUContext *ctx,struct MMUContext *win1,struct MMUContext *win2,
               UBYTE *memory,ULONG pagesize,ULONG memflags)
{
int     rc = 20;

        /* Create an exception hook we can react upon if the user trips onto
        ** the invalid page. Create a custom hook at priority 32.
        ** Note that MuForce has its hook at priority -64, hence is called
        ** *after* us, i.e. when we cannot handle the exception.
        */
struct ExceptionHook *hook = AddContextHook(MADTAG_CONTEXT,ctx,
                                            MADTAG_TYPE   ,MMUEH_SEGFAULT,
                                            MADTAG_CODE   ,mySwapHandler,
                                            MADTAG_NAME   ,"MyTestHook",
                                            MADTAG_PRI    ,32,
                                            TAG_DONE);
        if (hook) {
                /*
                ** Create some pattern here.
                */
                memset(memory,0xde,(size_t)pagesize);

                /* Ready to set fire! */
                magicpage = memory;
                magicsize = pagesize;
                defaultcontext = ctx;
                window1   = win1;
                window2   = win2;
                ActivateException(hook);
                /* Rebuild now all the trees.*/
                if (RebuildTrees(ctx,win1,win2,NULL) && RefreshContextWindow(window)) {
                        UBYTE *win1test = memory + pagesize; /* the first window */
                        UBYTE *win2test = memory + pagesize * 2;
                        UBYTE *laddr     = win2test + 2;
                        ULONG lsize     = pagesize * 3;
                        ULONG flags     = 0;
                        ULONG tsize     = lsize;
                        UBYTE *taddr    = laddr;
                        /*
                        ** run some tests here
                        */
                        Printf("Data at %08lx is %ld\n",win1test,*win1test);
                        Printf("Data at %08lx is %ld\n",win2test,*win2test);
                        /*
                        ** Test some DMA magic
                        */
                        Printf("DMA call for range %08lx size %08lx:\n",laddr,lsize);
                        do {
                                ULONG psize = tsize;
                                APTR  paddr = CachePreDMA(taddr,&psize,flags);
                                Printf("DMA chunk logical %08lx physical %08lx size %08lx\n",
                                        taddr,paddr,psize);
                                if (psize == tsize)
                                        break;
                                taddr += psize;
                                tsize -= psize;
                                flags |= DMA_Continue;
                        } while(TRUE);
                        CachePostDMA(laddr,&lsize,0);

                        rc = 0;
                }
                /*
                ** Install the old mapping
                */
                if (!SetProperties(ctx,memflags,~0,(ULONG)memory,pagesize * 3,TAG_DONE))
                        rc = 30;

                /*
                ** This should better work, or we're in deep trouble!
                */
                RebuildTree(ctx);
                
                DeactivateException(hook);
        }
        RemContextHook(hook);

        return rc;
}

int __asm __interrupt __saveds mySwapHandler(register __a0 struct ExceptionData *exc)
{
        /* Check where we are */
        UBYTE *fault = exc->exd_FaultAddress;
        UBYTE *next  = exc->exd_NextFaultAddress;
        /*
        ** Note that we do not get access to the pipeline here as the page
        ** is not mapped as "repairable". This is completely ok as we don't
        ** need the data.
        ** However, it may happen that an access spaws two pages in which
        ** case we cannot handle it. Let the code go GURU then (or rather,
        ** pass it over to MuForce if it is running).
        **
        ** Note that FaultAddress and NextFaultAddress are not necessarily
        ** in order if this is a descending movem. We really have to
        ** check them both.
        */
        if (fault >= magicpage + magicsize     && fault < magicpage + magicsize * 2 &&
            next  >= magicpage + magicsize     && fault < magicpage + magicsize * 2) {
                    /* Code hit the first window. Map it in,
                    ** let the code continue.
                    */
                    if (MapWindowCached(defaultcontext,window1,window))
                            return 0; /* Worked, return success */
        }
        if (fault >= magicpage + magicsize * 2 && fault < magicpage + magicsize * 3 &&
            next  >= magicpage + magicsize * 2 && next  < magicpage + magicsize * 3) {
                    /* Code hit the second window. Map it in.
                    */
                    if (MapWindowCached(defaultcontext,window2,window))
                            return 0;
        }
        /*
        ** None of the above worked. Bubble up to the next
        ** exception handler. Or go guru!
        */
        return 1;
}


