/*****************************************************************
 ** FPU                                                         **
 **                                                             **
 ** A program similar to the "CPU" program of the workbench     **
 ** used to control some of the flags the FPU offers.           **
 ** This uses the 680x0.library and hence requires the special  **
 ** editions of the 68040.library and related libraries         **
 ** It won't do much on other systems.                          **
 *****************************************************************/

/// Includes
#include <exec/types.h>
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <libraries/680x0.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/680x0.h>

#include <string.h>
///
/// Defines
#define ARGS "BSUN/S,NOBSUN/S,INEX/S,NOINEX/S,DIVZ/S,NODIVZ/S,UNFL/S," \
             "NOUNFL/S,OVFL/S,NOOVFL/S,SNAN/S,NOSNAN/S,"               \
             "OPERR/S,NOOPERR/S,NONE/S,ALL/S"

#define ARG_BSUN        0L
#define ARG_NOBSUN      1L
#define ARG_INEX        2L
#define ARG_NOINEX      3L
#define ARG_DIVZ        4L
#define ARG_NODIVZ      5L
#define ARG_UNFL        6L
#define ARG_NOUNFL      7L
#define ARG_OVFL        8L
#define ARG_NOOVFL      9L
#define ARG_SNAN        10L
#define ARG_NOSNAN      11L
#define ARG_OPERR       12L
#define ARG_NOOPERR     13L
#define ARG_NONE        14L
#define ARG_ALL         15L

#define ARG_COUNT       16L
///
/// Statics
char version[]="$VER: FPU 40.1 (28.8.99) © THOR";
///
/// Prototyping
int main(void);
///

/// main
int main(void)
{
struct ExecBase         *SysBase;
struct DosLibrary       *DOSBase;
struct MC680x0Base      *MC680x0Base;
int rc;
ULONG   flags,mask;
struct RDArgs *rd;
LONG    args[ARG_COUNT];

        SysBase=*((struct ExecBase **)(4L));
        rc=25;
        memset(args,0,sizeof(args));

        if (DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",36L)) {
         if (rd=ReadArgs(ARGS,args,NULL)) {
          if (MC680x0Base=(struct MC680x0Base *)OpenLibrary("680x0.library",40L)) {

           flags=0;
           mask=0;

           if (args[ARG_BSUN]) {
                   mask |= FPUCtrlF_BSUN;
           }
           if (args[ARG_NOBSUN]) {
                   mask |= FPUCtrlF_BSUN;
                   flags |= FPUCtrlF_BSUN;
           }
           if (args[ARG_INEX]) {
                   mask |= FPUCtrlF_INEX;
           }
           if (args[ARG_NOINEX]) {
                   mask |= FPUCtrlF_INEX;
                   flags |= FPUCtrlF_INEX;
           }
           if (args[ARG_DIVZ]) {
                   mask |= FPUCtrlF_DIVZ;
           }
           if (args[ARG_NODIVZ]) {
                   mask |= FPUCtrlF_DIVZ;
                   flags |= FPUCtrlF_DIVZ;
           }
           if (args[ARG_UNFL]) {
                   mask |= FPUCtrlF_UNFL;
           }
           if (args[ARG_NOUNFL]) {
                   mask |= FPUCtrlF_UNFL;
                   flags |= FPUCtrlF_UNFL;
           }
           if (args[ARG_OVFL]) {
                   mask |= FPUCtrlF_OVFL;
           }
           if (args[ARG_NOOVFL]) {
                   mask |= FPUCtrlF_OVFL;
                   flags |= FPUCtrlF_OVFL;
           }
           if (args[ARG_SNAN]) {
                   mask |= FPUCtrlF_SNAN;
           }
           if (args[ARG_OPERR]) {
                   mask |= FPUCtrlF_OPERR;
           }
           if (args[ARG_NOOPERR]) {
                   mask |= FPUCtrlF_OPERR;
                   flags |= FPUCtrlF_OPERR;
           }
           if (args[ARG_ALL]) {
                   mask |= FPUCtrlF_OPERR|FPUCtrlF_SNAN|FPUCtrlF_OVFL|
                           FPUCtrlF_UNFL|FPUCtrlF_DIVZ|FPUCtrlF_INEX|
                           FPUCtrlF_BSUN;
                   flags = 0;
           }
           if (args[ARG_NONE]) {
                   mask |= FPUCtrlF_OPERR|FPUCtrlF_SNAN|FPUCtrlF_OVFL|
                           FPUCtrlF_UNFL|FPUCtrlF_DIVZ|FPUCtrlF_INEX|
                           FPUCtrlF_BSUN;
                   flags |= FPUCtrlF_OPERR|FPUCtrlF_SNAN|FPUCtrlF_OVFL|
                           FPUCtrlF_UNFL|FPUCtrlF_DIVZ|FPUCtrlF_INEX|
                           FPUCtrlF_BSUN;
           }

           SetFPUExceptions(flags,mask);
           flags = SetFPUExceptions(0L,0L);

           Printf("FPU : ");
           switch (FPUType()) {
                   case FPUTYPE_NONE:
                           Printf("no FPU");
                           break;
                   case FPUTYPE_68881:
                           Printf("68881");
                           break;
                   case FPUTYPE_68882:
                           Printf("68882");
                           break;
                   case FPUTYPE_68040:
                           Printf("68040");
                           break;
                   case FPUTYPE_68060:
                           Printf("68060");
                           break;
                   default:
                           Printf("unknown");
                           break;
           }
           Printf(" (");

           if (flags & FPUCtrlF_BSUN)
                Printf("No");

           Printf("BSUN ");

           if (flags & FPUCtrlF_INEX)
                Printf("No");
           Printf("INEX ");

           if (flags & FPUCtrlF_DIVZ)
                Printf("No");
           Printf("DIVZ ");

           if (flags & FPUCtrlF_UNFL)
                Printf("No");
           Printf("UNFL ");

           if (flags & FPUCtrlF_OVFL)
                Printf("No");
           Printf("OVFL ");

           if (flags & FPUCtrlF_SNAN)
                Printf("No");
           Printf("SNAN ");

           if (flags & FPUCtrlF_OPERR)
                Printf("No");
           Printf("OPERR");

           Printf(")\n");

           rc=0;
           CloseLibrary((struct Library *)MC680x0Base);
          } else {
                Printf("FPU failed: 680x0.library required.\n");
                rc=20;
          }
          FreeArgs(rd);
         } else {
                PrintFault(IoErr(),"FPU failed");
                rc=10;
         }
         CloseLibrary((struct Library *)DOSBase);
        }

        return rc;
}
///
