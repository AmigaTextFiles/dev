/*
; Program which should force should trip the low memory server
*/

extern void *AllocMem();

main()
{
	char *p = AllocMem(7000000 , 0L);

	if (*p) FreeMem(p , 7000000);
}

