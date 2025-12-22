#ifndef PROTO_TEXTFIELD_H
#define PROTO_TEXTFIELD_H

#include <exec/types.h>
#include <intuition/classes.h>

#ifndef __NOLIBBASE__
extern struct Library *TextFieldBase;
#endif

extern Class *TextFieldClass;
Class *TEXTFIELD_GetClass(void);
char *TEXTFIELD_GetCopyright(void);

#endif
