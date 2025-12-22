/*********************************************************
 ** IndirectTest                                        **
 **                                                     **
 ** Test indirect page descriptors of the MuLib         **
 ** Release 1.01                                        **
 **                                                     **
 ** © 19.03.2000 Thomas Richter                         **
 *********************************************************/

/// Includes
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <mmu/context.h>
#include <mmu/mmutags.h>
#include <mmu/descriptor.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/mmu.h>

#include <string.h>
///
/// Defines
///
/// Protos
int __saveds main(void);
int RunTests(void);
void DumpData(UBYTE *src,ULONG size);
///
/// Statics
char version[]="$VER: IndirectTest 1.01 (19.03.2000) © THOR";
struct ExecBase         *SysBase;
struct DosLibrary       *DOSBase;
struct MMUBase          *MMUBase;
///

///main
int __saveds main(void)
{
int rc=25;

        /*
        ** Since we want to link without startup code,
        ** we need to open the system libraries here...
        */
        SysBase = *((struct ExecBase **)(4L));

        /*
        ** Open DOS and MMU
        **/

        if (DOSBase = (struct DosLibrary *)OpenLibrary("dos.library",37L)) {
                if (MMUBase = (struct MMUBase *)OpenLibrary("mmu.library",42L)) {

                        rc = RunTests();

                        CloseLibrary((struct Library *)MMUBase);
                } else {
                        Printf("IndirectTest failed: This program requires the mmu.library V42 or better.\n");
                        rc = 10;
                }

                /*
                ** Everything above 64 is a system
                ** error code we print over the console.
                */

                if (rc>64) {
                        PrintFault((LONG)rc,"IndirectTest failed");
                        rc = 10;
                }
                CloseLibrary((struct Library *)DOSBase);
        }

        return rc;
}
///
/// RunTests
int RunTests(void)
{
struct MMUContext *ctx;
struct MinList *ctxl;
ULONG pagesize;
ULONG *descriptor,*descriptorp;
ULONG values[2];
ULONG props[2];
UBYTE *page,*pagep[2];
int rc=25;

        /*
        ** Get the context we're currently using
        ** and its page size
        ** furthermore, allocate a page.
        */

        ctx             = CurrentContext(NULL);
        pagesize        = GetPageSize(ctx);
        page            = AllocAligned(pagesize*2,MEMF_PUBLIC|MEMF_CLEAR,pagesize);

        if (page) {

         /*
         ** Now allocate memory for the descriptor
         ** this must be long-word aligned, hence
         ** an AllocMem is fine here.
         ** However, we need to know the physical location
         ** of the descriptor.
         */
         descriptor     = AllocMem(sizeof(ULONG),MEMF_PUBLIC);

         if (descriptor) {


          /*
          ** Compute physical locations
          ** We do not assume that PhysicalLocation()
          ** truncates the address. All values are
          ** long/page aligned longs/pages, hence never cross a
          ** page boundary.
          */

          descriptorp    = descriptor;
          PhysicalLocation(ctx,(void **)&descriptorp,&pagesize);

          /* And now for the pages */

          pagep[0]       = page;
          props[0]       = PhysicalLocation(ctx,(void **)&pagep[0],&pagesize);
          pagep[1]       = page+pagesize;
          props[1]       = PhysicalLocation(ctx,(void **)&pagep[1],&pagesize);


          if (pagep[0] && pagep[1] && descriptorp) {

           /*
           ** Lock the context and make a backup of it.
           **
           */
           LockMMUContext(ctx);

           if (ctxl=GetMapping(ctx)) {

                /*
                ** Pre-calculate the values for the descriptors.
                ** The first descriptor maps the page to its TRUE physical
                ** location, the second one to the ROM, writeprotecting
                ** it.
                ** Note that we need to use the physical addresses here.
                **
                ** MAPP_ROM protection must be archived by setting this
                ** property bit "one level up".
                **
                ** We furthermore set USED and MODIFIED to avoid unnecessary
                ** MMU writebacks, and transfer the old properties back
                ** into the descriptor properties
                **
                ** Note that this call returns BAD_DESCRIPTOR in case
                ** of an error, not NULL.
                */

                values[0] = BuildIndirect(ctx,(ULONG)(pagep[0]),props[0]|MAPP_USED|MAPP_MODIFIED);
                values[1] = BuildIndirect(ctx,(ULONG)(pagep[1]),props[1]|MAPP_USED|MAPP_WRITEPROTECTED);

                if ((values[0] != BAD_DESCRIPTOR) &&
                    (values[1] != BAD_DESCRIPTOR)) {
                 /*
                 ** Install the descriptor
                 ** The first parameter is the physical address
                 ** of the descriptor, the second the
                 ** logical address of the page
                 ** and the last the descriptor to install
                 */

                 SetIndirect(descriptorp,(ULONG)page,values[0]);

                 /*
                 ** Now install this descriptor
                 ** We set this to MAPP_ROM because we want emulated
                 ** ROM writeprotection.
                 ** This is ignored if the descriptor itself is
                 ** not write protected anyhow.
                 ** We need the physical location of the descriptor
                 ** here.
                 */

                 if (SetProperties(ctx,MAPP_ROM|MAPP_INDIRECT,MAPP_ROM|MAPP_INDIRECT,
                                      (ULONG)page,pagesize,
                                      MAPTAG_DESCRIPTOR,descriptorp,
                                      TAG_DONE)) {

                  if (RebuildTree(ctx)) {

                   /* Everything's fine.
                   ** copy some dummy data into the page
                   */
                   memset(page,'*',(size_t)pagesize);

                   /* now print parts of it */
                   DumpData(page,0x10);

                   /*
                   ** install the other descriptor
                   */
                   SetIndirect(descriptorp,(ULONG)page,values[1]);

                   /*
                   ** Dump it again. Should be all zero now.
                   */
                   DumpData(page,0x10);

                   /* Try to write to it. This should
                   ** fail quietly.
                   */

                   *page = 'A';

                   /* And dump it again */
                   DumpData(page,0x10);

                   /*
                   ** install the old descriptor
                   ** again
                   */
                   SetIndirect(descriptorp,(ULONG)page,values[0]);

                   /*
                   ** Now reset the context data.
                   ** Disable the MAPP_ROM and MAPP_INDIRECT
                   ** features. This call shouldn't fail or
                   ** we are in trouble
                   */

                   if (SetProperties(ctx,0,MAPP_ROM|MAPP_INDIRECT,
                                    (ULONG)page,pagesize,TAG_DONE)) {

                        /* Restore the former MMU tree */
                        if (RebuildTree(ctx)) {

                                /*
                                ** everything is fine now.
                                */
                                rc = 0;
                        }
                   }

                   if (rc) {
                        /*
                        ** We're now in trouble.
                        ** The old context couldn't be restored.
                        ** Therefore, we do not release the descriptors
                        ** such that the accesses are at least right,
                        ** and restore the high-level by SetPropertyList()
                        ** below. This will cause a mild memory leak,
                        ** but the system will be fine.
                        */
                        Printf("IndirectTest: Can't restore the context.\n");
                        descriptor = NULL;
                   }
                  }  else Printf("IndirectTest: Building the context failed.\n");
                 } else Printf("IndirectTest: Can't install the new descriptor.\n");

                 /*
                 ** In case of an error, we restore now the high
                 ** level of the context.
                 ** This is all we could do.
                 ** The high-level looks then fine again,
                 ** and the low level contains either an
                 ** indirect descriptor which we can't get
                 ** rid of, but which maps ok, or is
                 ** unchanged. The system will be fine
                 ** in both cases.
                 */

                 if (rc) {
                        SetPropertyList(ctx,ctxl);
                 }

                } else Printf("Can't build the new descriptors.\n");
                /* Release the mapping */
                ReleaseMapping(ctx,ctxl);

           } else rc = ERROR_NO_FREE_STORE;

           /*
           ** Release the MMU Context lock
           */
           UnlockMMUContext(ctx);

          } else Printf("IndirectTest: Can't perform the logical to physical translation.\n");

          /*
          ** now release the descriptor
          */
          if (descriptor) {
                  FreeMem(descriptor,sizeof(ULONG));
          }
         } else rc = ERROR_NO_FREE_STORE; /* of if descriptor */

         FreeMem(page,pagesize*2);
        } else rc = ERROR_NO_FREE_STORE; /* of if page */

        return rc;
}
///
/// DumpData
void DumpData(UBYTE *src,ULONG size)
{
        /*
        ** A pretty dumb memory dump
        */

        Printf("Memory contents at 0x%08lx : ",src);
        while(size) {
                Printf("%02lx ",*src);
                src++;
                size--;
        }
        Printf("\n");
}
///


