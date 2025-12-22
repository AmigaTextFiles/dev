/*
 * RTrack Test Program
 *
 * (C) 1995 by PROXITY SOFTWORKS
 */

#include <proto/rtrack.h>
#include <exec/memory.h>						/* For MEMF_ANY */

main(void)
{
	APTR mem;
	APTR dobj;

	rkAutoExit(TRUE);								/* exit if something fails. */

	dobj=rkAllocDosObject(DOS_FIB, NULL);	/* allocate something		*/

	rkAllocVec(100, MEMF_ANY);
	mem = rkAllocVec(200, MEMF_ANY);
	rkAllocVec(300, MEMF_ANY);

	rkDump();										/* Dump list information	*/

	rkFreeDosObj(dobj);							/* Needs only the pointer! */
	rkFreeVec(mem);								/* Explicitly free mem		*/

	rkFreeVec((APTR)-1);							/* Attempt invalid free    */

	return 0;
}
