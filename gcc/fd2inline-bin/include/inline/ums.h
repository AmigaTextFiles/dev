/* Automatically generated header! Do not edit! */

#ifndef _INLINE_UMS_H
#define _INLINE_UMS_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif /* !__INLINE_MACROS_H */

#ifndef UMS_BASE_NAME
#define UMS_BASE_NAME UMSBase
#endif /* !UMS_BASE_NAME */

#define UMSCannotExport(account, msgnum, errtext) \
	LP3(0xf0, BOOL, UMSCannotExport, UMSAccount, account, d2, UMSMsgNum, msgnum, d3, STRPTR, errtext, d4, \
	, UMS_BASE_NAME)

#define UMSDeleteMsg(account, msgnum) \
	LP2(0x84, BOOL, UMSDeleteMsg, UMSAccount, account, d2, UMSMsgNum, msgnum, d3, \
	, UMS_BASE_NAME)

#define UMSDupAccount(account) \
	LP1(0x14a, UMSAccount, UMSDupAccount, UMSAccount, account, d2, \
	, UMS_BASE_NAME)

#define UMSErrNum(account) \
	LP1(0x78, UMSError, UMSErrNum, UMSAccount, account, d2, \
	, UMS_BASE_NAME)

#define UMSErrTxt(account) \
	LP1(0x7e, STRPTR, UMSErrTxt, UMSAccount, account, d2, \
	, UMS_BASE_NAME)

#define UMSErrTxtFromNum(num) \
	LP1(0x144, STRPTR, UMSErrTxtFromNum, UMSError, num, d2, \
	, UMS_BASE_NAME)

#define UMSExportedMsg(account, msgnum) \
	LP2NR(0xea, UMSExportedMsg, UMSAccount, account, d2, UMSMsgNum, msgnum, d3, \
	, UMS_BASE_NAME)

#define UMSFreeConfig(acc, string) \
	LP2NR(0x126, UMSFreeConfig, UMSAccount, acc, d2, STRPTR, string, d3, \
	, UMS_BASE_NAME)

#define UMSFreeMsg(acc, msgnum) \
	LP2NR(0x10e, UMSFreeMsg, UMSAccount, acc, d2, UMSMsgNum, msgnum, d3, \
	, UMS_BASE_NAME)

#define UMSLogin(user, passwd) \
	LP2(0x1e, UMSAccount, UMSLogin, STRPTR, user, d2, STRPTR, passwd, d3, \
	, UMS_BASE_NAME)

#define UMSLogout(account) \
	LP1NR(0x24, UMSLogout, UMSAccount, account, d2, \
	, UMS_BASE_NAME)

#define UMSMatchConfig(account, tagitems) \
	LP2(0x13e, BOOL, UMSMatchConfig, UMSAccount, account, d2, struct TagItem *, tagitems, d3, \
	, UMS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define UMSMatchConfigTags(a0, tags...) \
	({ULONG _tags[] = { tags }; UMSMatchConfig((a0), (struct TagItem *)_tags);})
#endif /* !NO_INLINE_STDARG */

#define UMSRLogin(server, user, passwd) \
	LP3(0xfc, UMSAccount, UMSRLogin, STRPTR, server, d2, STRPTR, user, d3, STRPTR, passwd, d4, \
	, UMS_BASE_NAME)

#define UMSReadConfig(acc, tagitems) \
	LP2(0x120, STRPTR, UMSReadConfig, UMSAccount, acc, d2, struct TagItem *, tagitems, d3, \
	, UMS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define UMSReadConfigTags(a0, tags...) \
	({ULONG _tags[] = { tags }; UMSReadConfig((a0), (struct TagItem *)_tags);})
#endif /* !NO_INLINE_STDARG */

#define UMSReadMsg(acc, tagitems) \
	LP2(0x108, BOOL, UMSReadMsg, UMSAccount, acc, d2, struct TagItem *, tagitems, d3, \
	, UMS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define UMSReadMsgTags(a0, tags...) \
	({ULONG _tags[] = { tags }; UMSReadMsg((a0), (struct TagItem *)_tags);})
#endif /* !NO_INLINE_STDARG */

#define UMSSearch(acc, tagitems) \
	LP2(0x11a, UMSMsgNum, UMSSearch, UMSAccount, acc, d2, struct TagItem *, tagitems, d3, \
	, UMS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define UMSSearchTags(a0, tags...) \
	({ULONG _tags[] = { tags }; UMSSearch((a0), (struct TagItem *)_tags);})
#endif /* !NO_INLINE_STDARG */

#define UMSSelect(acc, tagitems) \
	LP2(0x114, LONG, UMSSelect, UMSAccount, acc, d2, struct TagItem *, tagitems, d3, \
	, UMS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define UMSSelectTags(a0, tags...) \
	({ULONG _tags[] = { tags }; UMSSelect((a0), (struct TagItem *)_tags);})
#endif /* !NO_INLINE_STDARG */

#define UMSServerControl(server, action) \
	LP2(0x138, UMSError, UMSServerControl, STRPTR, server, d2, LONG, action, d3, \
	, UMS_BASE_NAME)

#define UMSVLog(account, level, format, args) \
	LP4NR(0xf6, UMSVLog, UMSAccount, account, d2, LONG, level, d4, STRPTR, format, d5, APTR, args, d6, \
	, UMS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define UMSLog(a0, a1, a2, tags...) \
	({ULONG _tags[] = { tags }; UMSVLog((a0), (a1), (a2), (APTR)_tags);})
#endif /* !NO_INLINE_STDARG */

#define UMSWriteConfig(acc, tagitems) \
	LP2(0x12c, BOOL, UMSWriteConfig, UMSAccount, acc, d2, struct TagItem *, tagitems, d3, \
	, UMS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define UMSWriteConfigTags(a0, tags...) \
	({ULONG _tags[] = { tags }; UMSWriteConfig((a0), (struct TagItem *)_tags);})
#endif /* !NO_INLINE_STDARG */

#define UMSWriteMsg(acc, tagitems) \
	LP2(0x102, UMSMsgNum, UMSWriteMsg, UMSAccount, acc, d2, struct TagItem *, tagitems, d3, \
	, UMS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define UMSWriteMsgTags(a0, tags...) \
	({ULONG _tags[] = { tags }; UMSWriteMsg((a0), (struct TagItem *)_tags);})
#endif /* !NO_INLINE_STDARG */

#endif /* !_INLINE_UMS_H */
