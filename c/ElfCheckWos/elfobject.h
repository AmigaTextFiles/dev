#ifndef PELFOBJECT_H
#define PELFOBJECT_H
#include "section.h"
#include "symbol.h"

#define MAX_SECTIONS 100

typedef struct
{
	unsigned long	sectcnt;
	char 		*elfptr;
	PSection 	sections[MAX_SECTIONS];
	unsigned long	symbolscnt;
	PSymbol		*symbols;
} PElfObject;

#endif
