#ifndef KERN_AMIGA_REXX_H
#define KERN_AMIGA_REXX_H

#ifndef EXEC_TYPES_H
#include <exec_types.h>
#endif

ULONG rexx_init(void);
BOOL rexx_show(void);
BOOL rexx_hide(void);
void rexx_deinit(void);
BOOL rexx_poll(void);

#endif /* KERN_AMIGA_REXX_H */
