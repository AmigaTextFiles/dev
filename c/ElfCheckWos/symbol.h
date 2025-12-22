#ifndef PSYMBOL_H
#define PSYMBOL_H

typedef struct
{
	char *name;
	unsigned long value;	//relocated value(!)
	unsigned long size;
	unsigned long type;
	unsigned long sectionindex;
} PSymbol;

#endif
