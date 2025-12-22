/* Automatically generated header! Do not edit! */

#ifndef _INLINE_DOSPATH_H
#define _INLINE_DOSPATH_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif /* !__INLINE_MACROS_H */

#ifndef DOSPATH_BASE_NAME
#define DOSPATH_BASE_NAME DOSPathBase
#endif /* !DOSPATH_BASE_NAME */

#define BuildPathListTagList(anchor, tags) \
	LP2(0x30, struct PathListEntry *, BuildPathListTagList, struct PathListEntry **, anchor, a0, struct TagItem *, tags, a1, \
	, DOSPATH_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define BuildPathListTags(a0, tags...) \
	({ULONG _tags[] = { tags }; BuildPathListTagList((a0), (struct TagItem *)_tags);})
#endif /* !NO_INLINE_STDARG */

#define CopyPathList(orig, anchor) \
	LP2(0x2a, struct PathListEntry *, CopyPathList, struct PathListEntry *, orig, a0, struct PathListEntry **, anchor, a1, \
	, DOSPATH_BASE_NAME)

#define CopyWorkbenchPathList(startup, anchor) \
	LP2(0x4e, struct PathListEntry *, CopyWorkbenchPathList, struct WBStartup *, startup, a0, struct PathListEntry **, anchor, a1, \
	, DOSPATH_BASE_NAME)

#define FindFileInPathList(state, file) \
	LP2(0x36, BPTR, FindFileInPathList, struct PathListEntry **, state, a0, const char *, file, a1, \
	, DOSPATH_BASE_NAME)

#define FreePathList(list) \
	LP1NR(0x24, FreePathList, struct PathListEntry *, list, a0, \
	, DOSPATH_BASE_NAME)

#define GetProcessPathList(process) \
	LP1(0x42, struct PathListEntry *, GetProcessPathList, struct Process *, process, a0, \
	, DOSPATH_BASE_NAME)

#define RemoveFromPathList(path, lock) \
	LP2(0x3c, struct PathListEntry *, RemoveFromPathList, struct PathListEntry *, path, a0, BPTR, lock, a1, \
	, DOSPATH_BASE_NAME)

#define SetProcessPathList(process, path) \
	LP2(0x48, struct PathListEntry *, SetProcessPathList, struct Process *, process, a0, struct PathListEntry *, path, a1, \
	, DOSPATH_BASE_NAME)

#endif /* !_INLINE_DOSPATH_H */
