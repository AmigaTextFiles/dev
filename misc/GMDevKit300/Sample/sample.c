/***************************************/
/*** Sample Program for vmem.library ***/
/***************************************/

#include <proto/exec.h>
#include <proto/dos.h>
#include <exec/memory.h>
#include <stdio.h>

#include <proto/vmem.h>
#include "vmemsupport.h"

/********* Main Sample Program *********/
LONG main(int argc, char **argv)
{
	ULONG chipmem, chipmeml, fastmem, fastmeml, vmem, vmeml;

	OpenVMem();		/* Open vmem.library if present */

	printf("Type\tAvailable\tLargest\n");

	/* Get available chip memory	*/
	chipmem = VAvailMem(MEMF_CHIP, 0);
	/* Get largest chip memory		*/
	chipmeml= VAvailMem(MEMF_CHIP|MEMF_LARGEST, 0);
	/* Get available fast memory	*/
	fastmem = VAvailMem(MEMF_FAST, 0);
	/* Get largest fast memory		*/
	fastmeml= VAvailMem(MEMF_FAST|MEMF_LARGEST, 0);
	/* Get available virtual memory	*/
	vmem    = VAvailMem(MEMF_ANY, VMEMF_VIRTUAL);
	/* Get largest virtual memory	*/
	vmeml   = VAvailMem(MEMF_LARGEST, VMEMF_VIRTUAL);

	/* Print memory status */
	printf("chip%13ld%14ld\nfast%13ld%14ld\nvmem%13ld%14ld\n",
		chipmem, chipmeml, fastmem, fastmeml, vmem, vmeml);

	printf("total%12ld%14ld\n",	chipmem+fastmem+vmem,
		max(vmem, max(fastmem, chipmem)));					/* Print memory totals */

	CloseVMem();	/* Close if opened */

	if(!argc) Delay(150); 	/* Delay 3 sec */

	return 0;
}

