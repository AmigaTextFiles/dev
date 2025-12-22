#ifndef CLIB_TEXTFIELD_PROTOS_H
#define CLIB_TEXTFIELD_PROTOS_H

#include <exec/types.h>
#include <intuition/classes.h>

extern struct Library *TextFieldBase;
extern Class *TextFieldClass;

Class *TEXTFIELD_GetClass(void);
char *TEXTFIELD_GetCopyright(void);

#endif
