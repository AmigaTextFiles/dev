#ifndef _INLINE_AML_H
#define _INLINE_AML_H

#ifndef CLIB_AML_PROTOS_H
#define CLIB_AML_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif
#ifndef  REXX_STORAGE_H
#include <rexx/storage.h>
#endif
#ifndef  LIBRARIES_AML_H
#include <libraries/aml.h>
#endif

#ifndef AML_BASE_NAME
#define AML_BASE_NAME AmlBase
#endif

#define RexxDispatcher(rxm) \
	LP1(0x1e, LONG, RexxDispatcher, struct RexxMsg *, rxm, a0, \
	, AML_BASE_NAME)

#define CreateServerA(tags) \
	LP1(0x24, APTR, CreateServerA, struct TagItem *, tags, a0, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CreateServer(tags...) \
	({ULONG _tags[] = {tags}; CreateServerA((struct TagItem *) _tags);})
#endif

#define DisposeServer(server) \
	LP1NR(0x2a, DisposeServer, APTR, server, a0, \
	, AML_BASE_NAME)

#define SetServerAttrsA(server, tags) \
	LP2(0x30, ULONG, SetServerAttrsA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetServerAttrs(server, tags...) \
	({ULONG _tags[] = {tags}; SetServerAttrsA((server), (struct TagItem *) _tags);})
#endif

#define GetServerAttrsA(server, tags) \
	LP2(0x36, ULONG, GetServerAttrsA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetServerAttrs(server, tags...) \
	({ULONG _tags[] = {tags}; GetServerAttrsA((server), (struct TagItem *) _tags);})
#endif

#define GetServerHeaders(server, flags) \
	LP2(0x3c, ULONG, GetServerHeaders, APTR, server, a0, ULONG, flags, d0, \
	, AML_BASE_NAME)

#define GetServerArticles(server, folder, hook, flags) \
	LP4(0x42, LONG, GetServerArticles, APTR, server, a0, APTR, folder, a1, struct Hook *, hook, a2, ULONG, flags, d0, \
	, AML_BASE_NAME)

#define CreateFolderA(server, tags) \
	LP2(0x48, APTR, CreateFolderA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CreateFolder(server, tags...) \
	({ULONG _tags[] = {tags}; CreateFolderA((server), (struct TagItem *) _tags);})
#endif

#define DisposeFolder(folder) \
	LP1(0x4e, BOOL, DisposeFolder, APTR, folder, a0, \
	, AML_BASE_NAME)

#define OpenFolderA(server, tags) \
	LP2(0x54, APTR, OpenFolderA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define OpenFolder(server, tags...) \
	({ULONG _tags[] = {tags}; OpenFolderA((server), (struct TagItem *) _tags);})
#endif

#define SaveFolder(folder) \
	LP1(0x5a, BOOL, SaveFolder, APTR, folder, a0, \
	, AML_BASE_NAME)

#define RemFolder(folder) \
	LP1(0x60, BOOL, RemFolder, APTR, folder, a0, \
	, AML_BASE_NAME)

#define SetFolderAttrsA(folder, tags) \
	LP2(0x66, ULONG, SetFolderAttrsA, APTR, folder, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetFolderAttrs(folder, tags...) \
	({ULONG _tags[] = {tags}; SetFolderAttrsA((folder), (struct TagItem *) _tags);})
#endif

#define GetFolderAttrsA(folder, tags) \
	LP2(0x6c, ULONG, GetFolderAttrsA, APTR, folder, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetFolderAttrs(folder, tags...) \
	({ULONG _tags[] = {tags}; GetFolderAttrsA((folder), (struct TagItem *) _tags);})
#endif

#define AddFolderArticle(folder, type, data) \
	LP3(0x72, BOOL, AddFolderArticle, APTR, folder, a0, ULONG, type, d0, APTR, data, a1, \
	, AML_BASE_NAME)

#define RemFolderArticle(folder, article) \
	LP2(0x78, BOOL, RemFolderArticle, APTR, folder, a0, APTR, article, a1, \
	, AML_BASE_NAME)

#define ReadFolderSpool(folder, importfile, flags) \
	LP3(0x7e, ULONG, ReadFolderSpool, APTR, folder, a0, STRPTR, importfile, a1, ULONG, flags, d0, \
	, AML_BASE_NAME)

#define WriteFolderSpool(folder, exportfile, flags) \
	LP3(0x84, ULONG, WriteFolderSpool, APTR, folder, a0, STRPTR, exportfile, a1, ULONG, flags, d0, \
	, AML_BASE_NAME)

#define ScanFolderIndex(folder, hook, flags) \
	LP3(0x8a, ULONG, ScanFolderIndex, APTR, folder, a0, struct Hook *, hook, a1, ULONG, flags, d0, \
	, AML_BASE_NAME)

#define ExpungeFolder(folder, trash, hook) \
	LP3(0x90, BOOL, ExpungeFolder, APTR, folder, a0, APTR, trash, a1, struct Hook *, hook, a2, \
	, AML_BASE_NAME)

#define CreateFolderIndex(folder) \
	LP1(0x96, ULONG, CreateFolderIndex, APTR, folder, a0, \
	, AML_BASE_NAME)

#define SortFolderIndex(folder, field) \
	LP2(0x9c, ULONG, SortFolderIndex, APTR, folder, a0, ULONG, field, d0, \
	, AML_BASE_NAME)

#define CreateArticleA(folder, tags) \
	LP2(0xa2, APTR, CreateArticleA, APTR, folder, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CreateArticle(folder, tags...) \
	({ULONG _tags[] = {tags}; CreateArticleA((folder), (struct TagItem *) _tags);})
#endif

#define DisposeArticle(article) \
	LP1(0xa8, BOOL, DisposeArticle, APTR, article, a0, \
	, AML_BASE_NAME)

#define OpenArticle(server, folder, MsgID, Flags) \
	LP4(0xae, APTR, OpenArticle, APTR, server, a0, APTR, folder, a1, ULONG, MsgID, d0, ULONG, Flags, d1, \
	, AML_BASE_NAME)

#define CopyArticle(folder, article) \
	LP2(0xb4, BOOL, CopyArticle, APTR, folder, a0, APTR, article, a1, \
	, AML_BASE_NAME)

#define SetArticleAttrsA(article, tags) \
	LP2(0xba, ULONG, SetArticleAttrsA, APTR, article, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetArticleAttrs(article, tags...) \
	({ULONG _tags[] = {tags}; SetArticleAttrsA((article), (struct TagItem *) _tags);})
#endif

#define GetArticleAttrsA(article, tags) \
	LP2(0xc0, ULONG, GetArticleAttrsA, APTR, article, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetArticleAttrs(article, tags...) \
	({ULONG _tags[] = {tags}; GetArticleAttrsA((article), (struct TagItem *) _tags);})
#endif

#define SendArticle(server, article, from_file) \
	LP3(0xc6, BOOL, SendArticle, APTR, server, a0, APTR, article, a1, UBYTE *, from_file, a2, \
	, AML_BASE_NAME)

#define AddArticlePartA(article, part, tags) \
	LP3(0xcc, BOOL, AddArticlePartA, APTR, article, a0, APTR, part, a1, struct TagItem *, tags, a2, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AddArticlePart(article, part, tags...) \
	({ULONG _tags[] = {tags}; AddArticlePartA((article), (part), (struct TagItem *) _tags);})
#endif

#define RemArticlePart(article, part) \
	LP2NR(0xd2, RemArticlePart, APTR, article, a0, APTR, part, d0, \
	, AML_BASE_NAME)

#define GetArticlePart(article, partnum) \
	LP2(0xd8, APTR, GetArticlePart, APTR, article, a0, ULONG, partnum, d0, \
	, AML_BASE_NAME)

#define GetArticlePartAttrsA(part, tags) \
	LP2(0xde, ULONG, GetArticlePartAttrsA, APTR, part, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetArticlePartAttrs(part, tags...) \
	({ULONG _tags[] = {tags}; GetArticlePartAttrsA((part), (struct TagItem *) _tags);})
#endif

#define SetArticlePartAttrsA(part, tags) \
	LP2(0xe4, ULONG, SetArticlePartAttrsA, APTR, part, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetArticlePartAttrs(part, tags...) \
	({ULONG _tags[] = {tags}; SetArticlePartAttrsA((part), (struct TagItem *) _tags);})
#endif

#define CreateArticlePartA(article, tags) \
	LP2(0xea, APTR, CreateArticlePartA, APTR, article, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CreateArticlePart(article, tags...) \
	({ULONG _tags[] = {tags}; CreateArticlePartA((article), (struct TagItem *) _tags);})
#endif

#define DisposeArticlePart(part) \
	LP1NR(0xf0, DisposeArticlePart, APTR, part, a0, \
	, AML_BASE_NAME)

#define GetArticlePartDataA(article, part, tags) \
	LP3(0xf6, BOOL, GetArticlePartDataA, APTR, article, a0, APTR, part, a1, struct TagItem *, tags, a2, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetArticlePartData(article, part, tags...) \
	({ULONG _tags[] = {tags}; GetArticlePartDataA((article), (part), (struct TagItem *) _tags);})
#endif

#define SetArticlePartDataA(part, tags) \
	LP2(0xfc, BOOL, SetArticlePartDataA, APTR, part, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetArticlePartData(part, tags...) \
	({ULONG _tags[] = {tags}; SetArticlePartDataA((part), (struct TagItem *) _tags);})
#endif

#define CreateAddressEntryA(tags) \
	LP1(0x102, APTR, CreateAddressEntryA, struct TagItem *, tags, a0, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CreateAddressEntry(tags...) \
	({ULONG _tags[] = {tags}; CreateAddressEntryA((struct TagItem *) _tags);})
#endif

#define DisposeAddressEntry(addr) \
	LP1(0x108, BOOL, DisposeAddressEntry, APTR, addr, a0, \
	, AML_BASE_NAME)

#define OpenAddressEntry(server, fileid) \
	LP2(0x10e, APTR, OpenAddressEntry, APTR, server, a0, ULONG, fileid, d0, \
	, AML_BASE_NAME)

#define SaveAddressEntry(server, addr) \
	LP2(0x114, LONG, SaveAddressEntry, APTR, server, a0, APTR, addr, a1, \
	, AML_BASE_NAME)

#define RemAddressEntry(server, addr) \
	LP2(0x11a, BOOL, RemAddressEntry, APTR, server, a0, APTR, addr, a1, \
	, AML_BASE_NAME)

#define GetAddressEntryAttrsA(addr, tags) \
	LP2(0x120, ULONG, GetAddressEntryAttrsA, APTR, addr, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetAddressEntryAttrs(addr, tags...) \
	({ULONG _tags[] = {tags}; GetAddressEntryAttrsA((addr), (struct TagItem *) _tags);})
#endif

#define SetAddressEntryAttrsA(addr, tags) \
	LP2(0x126, ULONG, SetAddressEntryAttrsA, APTR, addr, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetAddressEntryAttrs(addr, tags...) \
	({ULONG _tags[] = {tags}; SetAddressEntryAttrsA((addr), (struct TagItem *) _tags);})
#endif

#define MatchAddressA(addr, tags) \
	LP2(0x12c, BOOL, MatchAddressA, APTR, addr, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define MatchAddress(addr, tags...) \
	({ULONG _tags[] = {tags}; MatchAddressA((addr), (struct TagItem *) _tags);})
#endif

#define FindAddressEntryA(server, tags) \
	LP2(0x132, APTR, FindAddressEntryA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define FindAddressEntry(server, tags...) \
	({ULONG _tags[] = {tags}; FindAddressEntryA((server), (struct TagItem *) _tags);})
#endif

#define HuntAddressEntryA(server, tags) \
	LP2(0x138, APTR, HuntAddressEntryA, APTR, server, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define HuntAddressEntry(server, tags...) \
	({ULONG _tags[] = {tags}; HuntAddressEntryA((server), (struct TagItem *) _tags);})
#endif

#define ScanAddressIndex(server, hook, type, flags) \
	LP4(0x13e, ULONG, ScanAddressIndex, APTR, server, a0, struct Hook *, hook, a1, ULONG, type, d0, ULONG, flags, d1, \
	, AML_BASE_NAME)

#define AddCustomField(addr, field, data) \
	LP3(0x144, BOOL, AddCustomField, APTR, addr, a0, STRPTR, field, a1, STRPTR, data, a2, \
	, AML_BASE_NAME)

#define RemCustomField(addr, field) \
	LP2(0x14a, BOOL, RemCustomField, APTR, addr, a0, STRPTR, field, a1, \
	, AML_BASE_NAME)

#define GetCustomFieldData(addr, field) \
	LP2(0x150, STRPTR, GetCustomFieldData, APTR, addr, a0, STRPTR, field, a1, \
	, AML_BASE_NAME)

#define CreateDecoderA(tags) \
	LP1(0x156, APTR, CreateDecoderA, struct TagItem *, tags, a0, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CreateDecoder(tags...) \
	({ULONG _tags[] = {tags}; CreateDecoderA((struct TagItem *) _tags);})
#endif

#define DisposeDecoder(dec) \
	LP1NR(0x15c, DisposeDecoder, APTR, dec, a0, \
	, AML_BASE_NAME)

#define GetDecoderAttrsA(dec, tags) \
	LP2(0x162, ULONG, GetDecoderAttrsA, APTR, dec, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetDecoderAttrs(dec, tags...) \
	({ULONG _tags[] = {tags}; GetDecoderAttrsA((dec), (struct TagItem *) _tags);})
#endif

#define SetDecoderAttrsA(dec, tags) \
	LP2(0x168, ULONG, SetDecoderAttrsA, APTR, dec, a0, struct TagItem *, tags, a1, \
	, AML_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetDecoderAttrs(dec, tags...) \
	({ULONG _tags[] = {tags}; SetDecoderAttrsA((dec), (struct TagItem *) _tags);})
#endif

#define Decode(dec, type) \
	LP2(0x16e, LONG, Decode, APTR, dec, a0, ULONG, type, d0, \
	, AML_BASE_NAME)

#define Encode(dec, type) \
	LP2(0x174, LONG, Encode, APTR, dec, a0, ULONG, type, d0, \
	, AML_BASE_NAME)

#endif /*  _INLINE_AML_H  */
