#ifndef PSYMBOLS_H
#define PSYMBOLS_H
#include "elfobject.h"

int add_symbol_sect(PElfObject *obj,unsigned long sectionindex);
unsigned long get_symbol_by_name(PElfObject *obj,char *name);

#endif
