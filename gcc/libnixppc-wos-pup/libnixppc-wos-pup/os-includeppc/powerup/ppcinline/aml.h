/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_AML_H
#define _PPCINLINE_AML_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef AML_BASE_NAME
#define AML_BASE_NAME AmlBase
#endif /* !AML_BASE_NAME */

#define AddArticlePartA(article, part, tags) \
	LP3(0xcc, BOOL, AddArticlePartA, APTR, article, a0, APTR, part, a1, struct TagItem *, tags, a2, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AddArticlePart(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; AddArticlePartA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AddCustomField(addr, field, data) \
	LP3(0x144, BOOL, AddCustomField, APTR, addr, a0, STRPTR, field, a1, STRPTR, data, a2, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AddFolderArticle(folder, type, data) \
	LP3(0x72, BOOL, AddFolderArticle, APTR, folder, a0, ULONG, type, d0, APTR, data, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CopyArticle(folder, article) \
	LP2(0xb4, BOOL, CopyArticle, APTR, folder, a0, APTR, article, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CreateAddressEntryA(tags) \
	LP1(0x102, APTR, CreateAddressEntryA, struct TagItem *, tags, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define CreateAddressEntry(tags...) \
	({ULONG _tags[] = { tags }; CreateAddressEntryA((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define CreateArticleA(folder, tags) \
	LP2(0xa2, APTR, CreateArticleA, APTR, folder, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define CreateArticle(a0, tags...) \
	({ULONG _tags[] = { tags }; CreateArticleA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define CreateArticlePartA(article, tags) \
	LP2(0xea, APTR, CreateArticlePartA, APTR, article, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define CreateArticlePart(a0, tags...) \
	({ULONG _tags[] = { tags }; CreateArticlePartA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define CreateDecoderA(tags) \
	LP1(0x156, APTR, CreateDecoderA, struct TagItem *, tags, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define CreateDecoder(tags...) \
	({ULONG _tags[] = { tags }; CreateDecoderA((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define CreateFolderA(server, tags) \
	LP2(0x48, APTR, CreateFolderA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define CreateFolder(a0, tags...) \
	({ULONG _tags[] = { tags }; CreateFolderA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define CreateFolderIndex(folder) \
	LP1(0x96, ULONG, CreateFolderIndex, APTR, folder, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CreateServerA(tags) \
	LP1(0x24, APTR, CreateServerA, struct TagItem *, tags, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define CreateServer(tags...) \
	({ULONG _tags[] = { tags }; CreateServerA((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define Decode(dec, type) \
	LP2(0x16e, LONG, Decode, APTR, dec, a0, ULONG, type, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DisposeAddressEntry(addr) \
	LP1(0x108, BOOL, DisposeAddressEntry, APTR, addr, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DisposeArticle(article) \
	LP1(0xa8, BOOL, DisposeArticle, APTR, article, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DisposeArticlePart(part) \
	LP1NR(0xf0, DisposeArticlePart, APTR, part, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DisposeDecoder(dec) \
	LP1NR(0x15c, DisposeDecoder, APTR, dec, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DisposeFolder(folder) \
	LP1(0x4e, BOOL, DisposeFolder, APTR, folder, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DisposeServer(server) \
	LP1NR(0x2a, DisposeServer, APTR, server, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define Encode(dec, type) \
	LP2(0x174, LONG, Encode, APTR, dec, a0, ULONG, type, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ExpungeFolder(folder, trash, hook) \
	LP3(0x90, BOOL, ExpungeFolder, APTR, folder, a0, APTR, trash, a1, struct Hook *, hook, a2, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindAddressEntryA(server, tags) \
	LP2(0x132, APTR, FindAddressEntryA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define FindAddressEntry(a0, tags...) \
	({ULONG _tags[] = { tags }; FindAddressEntryA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define GetAddressEntryAttrsA(addr, tags) \
	LP2(0x120, ULONG, GetAddressEntryAttrsA, APTR, addr, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetAddressEntryAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetAddressEntryAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define GetArticleAttrsA(article, tags) \
	LP2(0xc0, ULONG, GetArticleAttrsA, APTR, article, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetArticleAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetArticleAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define GetArticlePart(article, partnum) \
	LP2(0xd8, APTR, GetArticlePart, APTR, article, a0, ULONG, partnum, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetArticlePartAttrsA(part, tags) \
	LP2(0xde, ULONG, GetArticlePartAttrsA, APTR, part, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetArticlePartAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetArticlePartAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define GetArticlePartDataA(article, part, tags) \
	LP3(0xf6, BOOL, GetArticlePartDataA, APTR, article, a0, APTR, part, a1, struct TagItem *, tags, a2, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetArticlePartData(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; GetArticlePartDataA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define GetCustomFieldData(addr, field) \
	LP2(0x150, STRPTR, GetCustomFieldData, APTR, addr, a0, STRPTR, field, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetDecoderAttrsA(dec, tags) \
	LP2(0x162, ULONG, GetDecoderAttrsA, APTR, dec, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetDecoderAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetDecoderAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define GetFolderAttrsA(folder, tags) \
	LP2(0x6c, ULONG, GetFolderAttrsA, APTR, folder, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetFolderAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetFolderAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define GetServerArticles(server, folder, hook, flags) \
	LP4(0x42, LONG, GetServerArticles, APTR, server, a0, APTR, folder, a1, struct Hook *, hook, a2, ULONG, flags, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetServerAttrsA(server, tags) \
	LP2(0x36, ULONG, GetServerAttrsA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetServerAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetServerAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define GetServerHeaders(server, flags) \
	LP2(0x3c, ULONG, GetServerHeaders, APTR, server, a0, ULONG, flags, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define HuntAddressEntryA(server, tags) \
	LP2(0x138, APTR, HuntAddressEntryA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define HuntAddressEntry(a0, tags...) \
	({ULONG _tags[] = { tags }; HuntAddressEntryA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define MatchAddressA(addr, tags) \
	LP2(0x12c, BOOL, MatchAddressA, APTR, addr, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define MatchAddress(a0, tags...) \
	({ULONG _tags[] = { tags }; MatchAddressA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define OpenAddressEntry(server, fileid) \
	LP2(0x10e, APTR, OpenAddressEntry, APTR, server, a0, ULONG, fileid, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OpenArticle(server, folder, msgID, flags) \
	LP4(0xae, APTR, OpenArticle, APTR, server, a0, APTR, folder, a1, ULONG, msgID, d0, ULONG, flags, d1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OpenFolderA(server, tags) \
	LP2(0x54, APTR, OpenFolderA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define OpenFolder(a0, tags...) \
	({ULONG _tags[] = { tags }; OpenFolderA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define ReadFolderSpool(folder, importfile, flags) \
	LP3(0x7e, ULONG, ReadFolderSpool, APTR, folder, a0, STRPTR, importfile, a1, ULONG, flags, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemAddressEntry(server, addr) \
	LP2(0x11a, BOOL, RemAddressEntry, APTR, server, a0, APTR, addr, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemArticlePart(article, part) \
	LP2NR(0xd2, RemArticlePart, APTR, article, a0, APTR, part, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemCustomField(addr, field) \
	LP2(0x14a, BOOL, RemCustomField, APTR, addr, a0, STRPTR, field, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemFolder(folder) \
	LP1(0x60, BOOL, RemFolder, APTR, folder, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemFolderArticle(folder, article) \
	LP2(0x78, BOOL, RemFolderArticle, APTR, folder, a0, APTR, article, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RexxDispatcher(rxm) \
	LP1(0x1e, LONG, RexxDispatcher, struct RexxMsg *, rxm, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SaveAddressEntry(server, addr) \
	LP2(0x114, LONG, SaveAddressEntry, APTR, server, a0, APTR, addr, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SaveFolder(folder) \
	LP1(0x5a, BOOL, SaveFolder, APTR, folder, a0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ScanAddressIndex(server, hook, type, flags) \
	LP4(0x13e, ULONG, ScanAddressIndex, APTR, server, a0, struct Hook *, hook, a1, ULONG, type, d0, ULONG, flags, d1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ScanFolderIndex(folder, hook, flags) \
	LP3(0x8a, ULONG, ScanFolderIndex, APTR, folder, a0, struct Hook *, hook, a1, ULONG, flags, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SendArticle(server, article, from_file) \
	LP3(0xc6, BOOL, SendArticle, APTR, server, a0, APTR, article, a1, UBYTE *, from_file, a2, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetAddressEntryAttrsA(addr, tags) \
	LP2(0x126, ULONG, SetAddressEntryAttrsA, APTR, addr, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetAddressEntryAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetAddressEntryAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetArticleAttrsA(article, tags) \
	LP2(0xba, ULONG, SetArticleAttrsA, APTR, article, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetArticleAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetArticleAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetArticlePartAttrsA(part, tags) \
	LP2(0xe4, ULONG, SetArticlePartAttrsA, APTR, part, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetArticlePartAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetArticlePartAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetArticlePartDataA(part, tags) \
	LP2(0xfc, BOOL, SetArticlePartDataA, APTR, part, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetArticlePartData(a0, tags...) \
	({ULONG _tags[] = { tags }; SetArticlePartDataA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetDecoderAttrsA(dec, tags) \
	LP2(0x168, ULONG, SetDecoderAttrsA, APTR, dec, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetDecoderAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetDecoderAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetFolderAttrsA(folder, tags) \
	LP2(0x66, ULONG, SetFolderAttrsA, APTR, folder, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetFolderAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetFolderAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetServerAttrsA(server, tags) \
	LP2(0x30, ULONG, SetServerAttrsA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetServerAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetServerAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SortFolderIndex(folder, field) \
	LP2(0x9c, ULONG, SortFolderIndex, APTR, folder, a0, ULONG, field, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteFolderSpool(folder, exportfile, flags) \
	LP3(0x84, ULONG, WriteFolderSpool, APTR, folder, a0, STRPTR, exportfile, a1, ULONG, flags, d0, \
	, AML_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_AML_H */
