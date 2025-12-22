#ifndef PROTO_CALENDAR_MCC_H
#define PROTO_CALENDAR_MCC_H

#ifndef __NOLIBBASE__
extern struct Library *
#ifdef __CONSTLIBBASEDECL__
__CONSTLIBBASEDECL__
#endif /* __CONSTLIBBASEDECL__ */
CalendarBase;
#endif /* !__NOLIBBASE__ */

#include <clib/Calendar_mcc_protos.h>

#ifdef __GNUC__
#ifdef __PPC__
#ifndef _NO_PPCINLINE
#include <ppcinline/Calendar_mcc.h>
#endif /* _NO_PPCINLINE */
#else
#ifndef _NO_INLINE
#include <inline/Calendar_mcc.h>
#endif /* _NO_INLINE */
#endif /* __PPC__ */
#else
#include <pragmas/Calendar_mcc_pragmas.h>
#endif /* __GNUC__ */

#endif /* !PROTO_CALENDAR_MCC_H */
