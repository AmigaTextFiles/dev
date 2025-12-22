#ifndef _INLINE_WBSTART_H
#define _INLINE_WBSTART_H

/*
 * wbstart.h  V2.2
 *
 * GCC inline library calls for wbstart.library functions
 *
 * (c) 1991-1996 Stefan Becker
 */

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef WBSTART_BASE_NAME
#define WBSTART_BASE_NAME WBStartBase
#endif

#define WBStartTagList(tags) \
        LP1(0x24, LONG, WBStartTagList, struct TagItem *, tags, a0, \
        , WBSTART_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WBStartTags(tags...) \
        ({ULONG _tags[] = { tags }; WBStartTagList((struct TagItem *)_tags);})
#endif /* !NO_INLINE_STDARG */

#endif /* _INLINE_WBSTART_H */
