/*

$VER: F_Atoms 1.00 (2006/03/07)

   Written by Olivier LAVIALE (gofromiel@gofromiel.com)

   This tool is for debuggin purpose only !! It travels  trough  pools  and
   puddles to print every memory allocated by F_New() or F_NewP().

*/

#include <exec/execbase.h>

#include "Feelin:Sources/Feelin/Private.h"
#include "Feelin:Sources/Feelin/lib_Atoms.h"

#undef SysBase
#undef DOSBase
				
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>

struct in_FeelinBase               *FeelinBase;

int main(void)
{
	if (!FindName(&SysBase -> LibList,"feelin.library"))
	{
		Printf("Feelin is not running.\n");
	}
	else if ((FeelinBase = (struct in_FeelinBase *) OpenLibrary("feelin.library",FV_FEELIN_VERSION)) != NULL)
	{
		uint32 i;
		uint32 count = 0;
		uint32 free_slots = 0;
		uint32 max_chain = 0;
		uint32 min_chain = 0;

		F_ATOMS_LOCK;

		for (i = 0 ; i < F_ATOMS_TABLE->Size ; i++)
		{
			struct in_Atom *atom = (struct in_Atom *) F_ATOMS_TABLE->Entries[i];

			if (atom)
			{
				uint32 chain = 0;

				for ( ; atom ; atom = atom->next)
				{
					chain++;
				}

				max_chain = MAX(max_chain, chain);
				min_chain = MIN(min_chain, chain);
				count += chain;
			}
			else
			{
				free_slots++;
			}
		}

		Printf("%ld atoms - free slots (%ld / %ld) - chain min (%ld) max (%ld)\n", count, free_slots, F_ATOMS_TABLE->Size, min_chain, max_chain);

		for (i = 0 ; i < F_ATOMS_TABLE->Size ; i++)
		{
			struct in_Atom *atom;

			for (atom = (struct in_Atom *) F_ATOMS_TABLE->Entries[i] ; atom ; atom = atom->next)
			{
				Printf("atom (0x%08lx) users (%3ld) key (%s)\n", (int32) atom, atom->refs, (int32) atom->public.Key);
			}
		}

		F_ATOMS_UNLOCK;

		F_FEELIN_CLOSE;
	}

	return 0;
}
