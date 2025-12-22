
#ifdef MACHINE_AMIGA
 #include <clib/exec_protos.h>
 #include <exec/memory.h>
#endif

#define MEMHEADER    20             /* 16 bytes at start, 4 at end */
#define MEMF_REVERSE (1L<<18)
#define CODE_MEMH    0x4D454D48L
#define CODE_MEMT    0x4D454D54L

/***********************************************************************************
** Function: AllocSoundMem()
** Synopsis: Memory = AllocSoundMem(Size, Flags);
**
** Allocates memory that can be used to play audio samples.
*/

LIBFUNC APTR LIBAllocSoundMem(mreg(__d0) LONG Size, mreg(__d1) LONG Flags)
{
   struct DPKTask *Task;
   LONG *Memory, *EndMemory, AFlags;
   WORD i;

   if (Size > NULL) {
      if (Size & 0x00000001) {     /* Check if uneven, if so raise the size */
         Size++;
      }

      Size  += MEMHEADER;           /* ++MEMHEADER */
      AFlags = MEMF_CHIP;           /* Clear, Chip */

      if ((Flags & MEM_NOCLEAR) IS NULL) {
         AFlags |= MEMF_CLEAR;
      }

      if (Size > 32767) {           /* Large chunks go to the other side of the  */
         AFlags |= MEMF_REVERSE;    /* memory boundary to prevent fragmentation. */
      }

      /* Allocate the memory using the exec.library
      ** routines.
      */

      if (Memory = AllocMem(Size,AFlags)) {
         Task = FindDPKTask();

         if (Task IS NULL) {
            Flags |= MEM_UNTRACKED;
         }

         EndMemory    = (LONG *)(((BYTE *)Memory)+Size-4);
         EndMemory[0] = CODE_MEMT;

         i = NULL;
         Memory[i++] = Flags;            /* Remember memory type */
         Memory[i++] = Size-MEMHEADER;   /* Remember size */

         if ((Flags & MEM_UNTRACKED) OR (Task IS NULL)) {
            if (Memory[i++] = (LONG)GVBase->SystemTask) {
               AddResource(GVBase->SystemTask, RSF_MEMORY, (APTR)(Memory + 4));
               GVBase->SystemTask->Head.Stats->TotalSound += Size;
            }
         }
         else {
            if (Task->prvContext) {
               AddResource(Task->prvContext, RSF_MEMORY, (APTR)(Memory + 4));
               Memory[i++] = (LONG)Task->prvContext;
               Task->prvContext->Stats->TotalSound += Size;
            }
            else DPrintF("!AllocMemBlock:","This Task has no context!");
         }

         Memory[i++] = CODE_MEMH;        /* Memory header */

         if (GVBase->Debug) GVBase->Debug->AllocSoundMem(Size,Flags,Memory+i);
         StepBack();
         return(Memory+i);
      }
      else DPrintF("AllocSoundMem()","Could not allocate memory space.");
   }
   else DPrintF("AllocSoundMem()","You requested a memory size of NULL.");

   StepBack();
   return(NULL);
}

/***********************************************************************************
** Function: FreeSoundMem()
*/

LIBFUNC LONG LIBFreeSoundMem(mreg(__d0) APTR MemBlock)
{
  return(FreeMemBlock(MemBlock));
}

