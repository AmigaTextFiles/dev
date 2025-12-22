#ifndef PSECTION_H
#define PSECTION_H

typedef struct
{
	unsigned char *name;		//Section Name
	unsigned char *elfadr;		//Address of Section in Elf-image
	unsigned char *virtadr;		//Address of relocated section
	unsigned long size;		//Size of Section
	unsigned long type;
	unsigned long flags;
	unsigned long link;		//Symbol section for reloc
					//String section for symbol
	unsigned long info;		//Target section for reloc
					//first external symbol for symbol
	unsigned long entsize;		//Entrysize for table section
} PSection;

#endif
