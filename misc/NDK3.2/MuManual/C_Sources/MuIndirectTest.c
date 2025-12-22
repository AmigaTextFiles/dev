/*************************************************
 ** MuIndirectTest                              **
 **                                             **
 ** Use indirect page descriptors and fast      **
 ** page swapping                               **
 **                                             **
 ** © 1999 THOR-Software                        **
 ** Version 1.00        11.07.1999              **
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
#include <mmu/descriptor.h>

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
void MMUIndirectTest(void);
///
/// Statics

/* Just the library bases we need */
char version[]="$VER: MuIndirectTest 1.00 (11.7.99) ©THOR";

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
                                MMUIndirectTest();
                                err=0;
                        }

                        /* Check for error codes. Everything below 64
                           is considered to be a custom error and
                           passed thru as primary result code. */
                        if (err<64) {
                                rc=err;
                                err=0;
                        } else {
                                PrintFault(err,"MuIndirectTest failed");
                                rc=10;
                        }
                        SetIoErr(err);

                        /* Shut down: Close libraries */
                        CloseLibrary((struct Library *)MMUBase);
                } else PrintFault(ERROR_OBJECT_NOT_FOUND,"MuIndirectTest");
                CloseLibrary((struct Library *)DOSBase);
        }

        return rc;
}
///
/// MMUIndirectTest
void MMUIndirectTest(void)
{
struct MMUContext *ctx;
ULONG pagesize,size;
void *testpage[2],*physical[2];
ULONG descriptor[2];
ULONG *desmem,*desphysical;
struct MinList *map;
char *dummy;
int i;

        /* This is the TRUE test, finally. */

        /* Get the public default context as template for the new
           context */
        Printf("Locating the default context...\n");
        ctx=DefaultContext();

        pagesize=GetPageSize(ctx);

        Printf("Allocating the test pages...\n");
        /* Allocate memory for the two pages */
        if (testpage[0]=AllocAligned(pagesize,MEMF_PUBLIC,pagesize)) {
         if (testpage[1]=AllocAligned(pagesize,MEMF_PUBLIC,pagesize)) {

          /* Get the physical addresses of the pages */
          size=pagesize;
          physical[0]=testpage[0];
          physical[1]=testpage[1];

          /* We don't check here for errors. The pages are aligned correctly */
          PhysicalLocation(ctx,physical,&size);
          PhysicalLocation(ctx,physical+1,&size);

          Printf("Test pages allocated.\n"
                 "Page 0 is at 0x%08lx, physical 0x%08lx,\n"
                 "Page 1 is at 0x%08lx, physical 0x%08lx\n",
                 testpage[0],physical[0],
                 testpage[1],physical[1]);

          /* Allocate memory for the descriptors. AllocMem is good
             enough here, we need only long word alignment */
          Printf("Allocating memory for the descriptors.\n");
          if (desmem=AllocMem(sizeof(ULONG),MEMF_PUBLIC)) {
           desphysical=desmem;
           size=sizeof(ULONG);

           /* Again, we need the TRUE physical location */
           PhysicalLocation(ctx,(void **)(&desphysical),&size);

           Printf("Descriptor allocated.\n"
                  "Indirect descriptor at 0x%08lx, physical 0x%08lx,\n",
                  desmem,desphysical);

           Printf("Building the descriptors.\n");

           /* We use here "used, modified" descriptors to avoid
              unnecessary MMU writebacks of descriptors we exchange
              anyways. Copyback cache mode is turned on, but the
              call might not set it if it is not available. However,
              it will not fail in this case. */
           descriptor[0]=BuildIndirect(ctx,(ULONG)(physical[0]),MAPP_USED|MAPP_MODIFIED|MAPP_COPYBACK);
           descriptor[1]=BuildIndirect(ctx,(ULONG)(physical[1]),MAPP_USED|MAPP_MODIFIED|MAPP_COPYBACK);

           /* Check for errors */
           if (descriptor[0]!=BAD_DESCRIPTOR) {
            if (descriptor[1]!=BAD_DESCRIPTOR) {

                Printf("Descriptors are build.\n"
                       "Descriptor 0 is 0x%08lx,\n"
                       "Descriptor 1 is 0x%08lx\n",
                       descriptor[0],descriptor[1]);

                /* Now modify the MMU tree to include the descriptors */
                Printf("Mirroring the memory at 0x%08lx to the first descriptor.\n",
                       TESTLOCATION);

                /* Write the first descriptor out to memory */
                SetIndirect(desphysical,TESTLOCATION,descriptor[0]);

                /* Make a backup of the current MMU setup */
                if (map=GetMapping(ctx)) {
                 if (SetProperties(ctx,MAPP_INDIRECT,~0,TESTLOCATION,pagesize,
                                   MAPTAG_DESCRIPTOR,desphysical,TAG_DONE)) {

                  Printf("Building a new MMU tree.\n");
                   if (RebuildTree(ctx)) {
                        Printf("Running the tests.\n");
                        /* Copy a string into the first and second page */
                        strcpy((char *)testpage[0],"This is page 0.");
                        strcpy((char *)testpage[1],"This is page 1.");

                        /* Now, VERY important! Since we access these
                           data from elsewhere, we MUST flush the cache
                           to make sure the data is really written out
                           to memory. */
                        CacheClearU();

                        /* Get a pointer to the test page */
                        dummy=(char *)TESTLOCATION;

                        for(i=0;i<10;i++) {
                                Printf("%s\n",dummy);
                                /* now swap the pages, and print
                                   a different string of the
                                   same address... This is the magic.
                                   The call below is very fast!*/
                                SetIndirect(desphysical,TESTLOCATION,descriptor[1]);
                                Printf("%s\n",dummy);
                                /* And back! */
                                SetIndirect(desphysical,TESTLOCATION,descriptor[0]);
                        }
                        Printf("Test done.\n");
                   } else Printf("Failed to rebuild the MMU tree.\n");

                   if (!SetPropertiesMapping(ctx,map,TESTLOCATION,pagesize,~0)) {
                        Printf("Fatal! Can't restore the altered page.\n");
                   }
                   if (!RebuildTree(ctx)) {
                           Printf("Fatal! Can't restore the previous MMU tree!\n");
                   }
                 } else Printf("Failed to install the indirect descriptor.\n");
                 ReleaseMapping(ctx,map);
                } else Printf("Failed to make a backup of the MMU map.\n");
            } else Printf("Could not build descriptor 0.\n");
           } else Printf("Could not build descriptor 1.\n");

           /* Release the descriptor */
           FreeMem(desmem,sizeof(ULONG));
          } else Printf("No memory for the indirect descriptor.\n");
          FreeMem(testpage[1],pagesize);
         } else Printf("No memory for the test page 1.\n");
         FreeMem(testpage[0],pagesize);
        } else Printf("No memory for the test page 0.\n");

}
///

