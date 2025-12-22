#ifndef PLOADELF_H
#define PLOADELF_H
#include "elfobject.h"

PElfObject *alloc_elfobject(void *elfptr);
void free_elfobject(PElfObject *obj);

#endif
