#ifndef _INLINE_ASL_H
#define _INLINE_ASL_H

#ifndef CLIB_ASL_PROTOS_H
#define CLIB_ASL_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  LIBRARIES_ASL_H
#include <libraries/asl.h>
#endif

#ifndef ASL_BASE_NAME
#define ASL_BASE_NAME AslBase
#endif

#define AllocFileRequest() \
	LP0(0x1e, struct FileRequester *, AllocFileRequest, \
	, ASL_BASE_NAME)

#define FreeFileRequest(fileReq) \
	LP1NR(0x24, FreeFileRequest, struct FileRequester *, fileReq, a0, \
	, ASL_BASE_NAME)

#define RequestFile(fileReq) \
	LP1(0x2a, BOOL, RequestFile, struct FileRequester *, fileReq, a0, \
	, ASL_BASE_NAME)

#define AllocAslRequest(reqType, tagList) \
	LP2(0x30, APTR, AllocAslRequest, ULONG, reqType, d0, struct TagItem *, tagList, a0, \
	, ASL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocAslRequestTags(reqType, tags...) \
	({ULONG _tags[] = {tags}; AllocAslRequest((reqType), (struct TagItem *) _tags);})
#endif

#define FreeAslRequest(requester) \
	LP1NR(0x36, FreeAslRequest, APTR, requester, a0, \
	, ASL_BASE_NAME)

#define AslRequest(requester, tagList) \
	LP2(0x3c, BOOL, AslRequest, APTR, requester, a0, struct TagItem *, tagList, a1, \
	, ASL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AslRequestTags(requester, tags...) \
	({ULONG _tags[] = {tags}; AslRequest((requester), (struct TagItem *) _tags);})
#endif

#define AbortAslRequest(requester) \
	LP1NR(0x4e, AbortAslRequest, APTR, requester, a0, \
	, ASL_BASE_NAME)

#define ActivateAslRequest(requester) \
	LP1NR(0x54, ActivateAslRequest, APTR, requester, a0, \
	, ASL_BASE_NAME)

#endif /*  _INLINE_ASL_H  */
