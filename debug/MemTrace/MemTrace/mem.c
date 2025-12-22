/*
 * mem.c - This file contains the routines which trace memory allocations
 * (c)1988 Jojo Wesener
 */

#include <stdio.h>
/*
 * use FreeMem() and AllocMem() as usual and then call freeall()
 * when your program exits.
 */

#ifdef MEMTRACE

struct membkt {
	char * addr;
	long amt;
	long type;
	char * func, * file;
	long line;
	struct membkt * next;
};

typedef struct membkt membkt_t;

membkt_t * Mem_list = NULL;

char * malloc();

membkt_t *
get_bkt()
{
	return (membkt_t *)malloc(sizeof(membkt_t));
}

put_bkt(bkt)
	membkt_t *bkt;
{
	free( (char *)bkt );
}

membkt_t *
find_bkt(addr)
	char * addr;
{
	membkt_t * bkt, *pre;

	bkt = Mem_list;

	for( ; bkt != NULL ; bkt = bkt->next )
		if( bkt->addr == addr )
			break;

	if( bkt == NULL )
		return NULL;

	/* remove it from the list */
	if( bkt == Mem_list ) {
		Mem_list = Mem_list->next;
		return bkt;
	}

	for( pre = Mem_list ; pre->next != bkt ; pre = pre->next );

	pre->next = bkt->next;

	return bkt;
}

store_bkt( bkt )
	membkt_t *bkt;
{
	bkt->next = Mem_list;
	Mem_list = bkt;
}

char *
alloctrack(amt,type,file,func,line)
	long amt;
	long type;
	char * file, * func;
	long line;
{
	char * mem;
	membkt_t * bkt;

	mem = (char *)AllocMem(amt,type);

	if( mem  == NULL )
		return mem;

	if( (bkt = get_bkt()) == NULL ) {
		printf("alloctrack: unable to alloc bucket\n");
		exit( 1 );
	}

	bkt->addr = mem;
	bkt->amt = amt;
	bkt->type = type;
	bkt->file = file;
	bkt->func = func;
	bkt->line = line;

	store_bkt( bkt );

	return mem;
}

freetrack(addr,amt,file,func,line)
	char * addr;
	long amt;
	char * file, * func, * line;
{
	membkt_t * bkt;

	if( (bkt = find_bkt( addr )) == NULL ) {
		printf("freetrack: error %s, %s, %d, 0x%x -- 0x%x\n",file,func,line,
			addr,amt);
		return;
	}

	(void)FreeMem(addr,amt);

	put_bkt(bkt);
}

freeall()
{
	membkt_t *bkt;

	printf("freeall:\n");
	for( bkt = Mem_list; bkt != NULL ; bkt = bkt->next ) {
		(void)FreeMem(bkt->addr, bkt->amt);
		printf("\t%s, %s, %d, 0x%x --0x%x --0x%x\n",bkt->file,bkt->func,
			bkt->line, bkt->addr, bkt->amt, bkt->type);
		put_bkt( bkt );
	}
	printf("end freeall\n");
}
#endif MEMTRACE

/* Lint Output
mem.c:
*/
