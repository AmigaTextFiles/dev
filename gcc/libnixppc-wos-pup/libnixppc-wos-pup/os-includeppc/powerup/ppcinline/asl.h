/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_ASL_H
#define _PPCINLINE_ASL_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef ASL_BASE_NAME
#define ASL_BASE_NAME AslBase
#endif /* !ASL_BASE_NAME */

#define AbortAslRequest(requester) \
	LP1NR(0x4e, AbortAslRequest, APTR, requester, a0, \
	, ASL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ActivateAslRequest(requester) \
	LP1NR(0x54, ActivateAslRequest, APTR, requester, a0, \
	, ASL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AllocAslRequest(reqType, tagList) \
	LP2(0x30, APTR, AllocAslRequest, ULONG, reqType, d0, struct TagItem *, tagList, a0, \
	, ASL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AllocAslRequestTags(a0, tags...) \
	({ULONG _tags[] = { tags }; AllocAslRequest((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AllocFileRequest() \
	LP0(0x1e, struct FileRequester *, AllocFileRequest, \
	, ASL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AslRequest(requester, tagList) \
	LP2(0x3c, BOOL, AslRequest, APTR, requester, a0, struct TagItem *, tagList, a1, \
	, ASL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AslRequestTags(a0, tags...) \
	({ULONG _tags[] = { tags }; AslRequest((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define FreeAslRequest(requester) \
	LP1NR(0x36, FreeAslRequest, APTR, requester, a0, \
	, ASL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeFileRequest(fileReq) \
	LP1NR(0x24, FreeFileRequest, struct FileRequester *, fileReq, a0, \
	, ASL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RequestFile(fileReq) \
	LP1(0x2a, BOOL, RequestFile, struct FileRequester *, fileReq, a0, \
	, ASL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_ASL_H */
