#ifndef API_APICALLS_H
#define API_APICALLS_H

/* f_void either needs to be redefined, or whatever uses it.
   It's only used in 2 files - amiga_api.c and amiga_libtables.c,
   both in api subdir.
*/

typedef VOID (* REGARGFUN f_void)();

#if __SASC
#include <api/apicalls_sasc.h>
#elif __GNUC__
#include <api/apicalls_gnuc.h>
#else
#error "GGTCP/IP internal API calls are not defined for your compiler!"
#endif

#endif /* API_APICALLS_H */
