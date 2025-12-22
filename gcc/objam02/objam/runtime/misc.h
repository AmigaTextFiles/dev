/*
** ObjectiveAmiga: Misc functions
** See GNU:lib/libobjam/ReadMe for details
*/


#include <exec/lists.h>


/* standard function emulations */

void   __objc_sprintf (const char *buf, const char *format,...);
void   __objc_printf (const char *format,...);
int    __objc_strcmp (const char *a, const char *b);
char * __objc_strcpy (char *to, const char *from);

void   __objc_NewList (struct List *list);

void   __objc_abort (void);


/* standard functions */

#define sprintf __objc_sprintf
#define printf __objc_printf
#define strcmp(a,b) __objc_strcmp(a,b)
#define strcpy(a,b) __objc_strcpy(a,b)
#define NewList(a) __objc_NewList(a)
#define abort() __objc_abort()


/* assertion */

#undef assert
#undef __assert

#ifdef NDEBUG
#define assert(ignore) ((void) 0)
#else
#define assert(expression)  \
  ((void) ((expression) ? 0 : __assert (expression, __FILE__, __LINE__)))
#define __assert(expression, file, lineno)  \
  (printf ("%s:%u: failed assertion\n", file, lineno), abort(), 0)
#endif
