
#ifdef HAVE_CAT
#include <nl_types.h>
#else
typedef UNIV nl_catd;
#endif

/* Don't use prototypes here in case nl_types.h declares a conflicting
prototype. */

nl_catd catopen(char *name, int oflag);
int catclose(nl_catd catd);
char *catgets(nl_catd catd, int setnum, int msgnum, char *dflt);
