/*****************************************************************
 ** CheckSCSINest                                               **
 **                                                             **
 ** Check the nest count for CachePre/PostDMA                   **
 ** (c) 1998 THOR-Software, inc. Thomas Richter                 **
 *****************************************************************/

/// Includes
#include <exec/types.h>
#include <exec/execbase.h>
#include <dos/dos.h>
#include <proto/exec.h>
#include <proto/dos.h>
///
/// Typedefs
typedef __asm APTR CachePreDMAType(register __a0 APTR virtual,register __a1 LONG *length,register __d0 LONG flags);
typedef __asm void CachePostDMAType(register __a0 APTR virtual,register __a1 LONG *length,register __d0 LONG flags);
///
/// Protos
int __saveds main(void);
APTR __asm __saveds NewCachePreDMA(register __a0 APTR virtual,register __a1 LONG *length,register __d0 LONG flags);
void __asm __saveds NewCachePostDMA(register __a0 APTR virtual,register __a1 LONG *length,register __d0 LONG flags);
///
/// Statics
struct ExecBase *SysBase;
struct DosLibrary *DOSBase;
CachePreDMAType *oldpre;
CachePostDMAType *oldpost;
LONG counter;
LONG precounter;
LONG precounternon;
LONG postcounter;
///

/// main
int __saveds main(void)
{

        SysBase=*((struct ExecBase **)(4L));

        if (DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",37L)) {
                Disable();
                oldpre=(CachePreDMAType *)SetFunction((struct Library *)SysBase,-762,(APTR)(&NewCachePreDMA));
                oldpost=(CachePostDMAType *)SetFunction((struct Library *)SysBase,-768,(APTR)(&NewCachePostDMA));
                counter=0;
                precounter=0;
                postcounter=0;
                precounternon=0;
                Enable();
                Printf("CachePreDMA/PostDMA patches installed. Please start massive\n"
                       "disk activity now, keep the program running for several minutes.\n"
                       "Then remove it with ^C.\n\n");
                SetSignal(0L,SIGBREAKF_CTRL_C);
                Wait(SIGBREAKF_CTRL_C);
                Disable();
                SetFunction((struct Library *)SysBase,-762,(APTR)(oldpre));
                SetFunction((struct Library *)SysBase,-768,(APTR)(oldpost));
                Enable();
                Printf("The patches have been removed.\n"
                       "The DMA activity counter is %ld. "
                       "CachePreDMA called %ld times,\n"
                       "%ld times without DMA_Continue, "
                       "CachePostDMA called %ld times.\n\n",
                       counter,precounter,precounternon,postcounter);
                CloseLibrary((struct Library *)DOSBase);
        }

        return 0;
}
///
/// CachePreDMA
APTR __asm __saveds NewCachePreDMA(register __a0 APTR virtual,register __a1 LONG *length,register __d0 LONG flags)
{
        precounter++;
        if (!(flags & DMA_Continue)) {
                counter++;
                precounternon++;
        }
        return (*oldpre)(virtual,length,flags);
}
///
/// CachePostDMA
void __asm __saveds NewCachePostDMA(register __a0 APTR virtual,register __a1 LONG *length,register __d0 LONG flags)
{
        counter--;
        postcounter++;
        (*oldpost)(virtual,length,flags);
}
///

