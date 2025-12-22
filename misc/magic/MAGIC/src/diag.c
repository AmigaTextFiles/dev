/*
 * MAGIC Image Diagnostic Tool - shows current list of MAGIC images.
 *
 * Written by Thomas Krehbiel
 *
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/dos.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <magic/magic.h>
#include <magic/magic_protos.h>
#include <magic/magic_pragmas.h>

struct MagicBase *MagicBase;


void main (void)
{
   struct MagicImage *pi;
   struct Task *task;

   if (MagicBase = (struct MagicBase *)OpenLibrary("magic.library", 0)) {
      printf("Counter = %ld\n\n", MagicBase->Counter);

      pi = (struct MagicImage *)MagicBase->MagicImageList.lh_Head;
      while (pi->Node.ln_Succ) {
         printf("\"%ls\" (W=%ld, H=%ld, D=%ld)\n", pi->Name, pi->Width, pi->Height, pi->Depth);
         task = pi->Owner;
         if (task->tc_Node.ln_Name) printf("  (Owned by %ls)\n", task->tc_Node.ln_Name);
         pi = (struct MagicImage *)pi->Node.ln_Succ;
      }
      CloseLibrary((struct Library *)MagicBase);
   }
}
