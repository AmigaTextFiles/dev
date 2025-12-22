/*-- AutoRev header do NOT edit!
*
*   Program         :   main.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   28-Sep-91
*   Current version :   1.0
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   28-Sep-91     1.0             main routine
*
*-- REV_END --*/

#include	"defs.h"

struct MemoryChain	*GetMemoryChain(ULONG value) {
	struct MemoryChain	*chain;

	chain = (struct MemoryChain *)malloc(value);
	return chain;
}

void	FreeMemoryChain(struct MemoryChain *chain, BOOL flag) {
	free(chain);
	return;
}

APTR	AllocItem(struct MemoryChain *chain, ULONG size, ULONG requirements) {
	APTR	buf = (APTR)malloc(size);
	return buf;
}

void	FreeItem(struct MemoryChain *chain, APTR item, ULONG size) {
	free(item);
}
