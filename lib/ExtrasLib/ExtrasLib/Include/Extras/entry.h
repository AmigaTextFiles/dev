#ifndef EXTRAS_ENTRY_H
#define EXTRAS_ENTRY_H

#ifndef	EXEC_TYPES_H
#include <exec/types.h>
#endif

struct EItem
{
  STRPTR Name;
  STRPTR *ReturnString;
};

#endif
