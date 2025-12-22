
#ifndef _AMLLIBRARY_H
#define _AMLLIBRARY_H

#include <utility/tagitem.h>
#include <libraries/aml.h>

class AmlLibrary
{
public:
	AmlLibrary();
	~AmlLibrary();

	static class AmlLibrary Default;

	LONG RexxDispatcher(struct RexxMsg * rxm);
	APTR CreateServerA(struct TagItem * tags);
	VOID DisposeServer(APTR server);
	ULONG SetServerAttrsA(APTR server, struct TagItem * tags);
	ULONG GetServerAttrsA(APTR server, struct TagItem * tags);
	ULONG GetServerHeaders(APTR server, ULONG flags);
	LONG GetServerArticles(APTR server, APTR folder, struct Hook * hook, ULONG flags);
	APTR CreateFolderA(APTR server, struct TagItem * tags);
	BOOL DisposeFolder(APTR folder);
	APTR OpenFolderA(APTR server, struct TagItem * tags);
	BOOL SaveFolder(APTR folder);
	BOOL RemFolder(APTR folder);
	ULONG SetFolderAttrsA(APTR folder, struct TagItem * tags);
	ULONG GetFolderAttrsA(APTR folder, struct TagItem * tags);
	BOOL AddFolderArticle(APTR folder, ULONG type, APTR data);
	BOOL RemFolderArticle(APTR folder, APTR article);
	ULONG ReadFolderSpool(APTR folder, STRPTR importfile, ULONG flags);
	ULONG WriteFolderSpool(APTR folder, STRPTR exportfile, ULONG flags);
	ULONG ScanFolderIndex(APTR folder, struct Hook * hook, ULONG flags);
	BOOL ExpungeFolder(APTR folder, APTR trash, struct Hook * hook);
	ULONG CreateFolderIndex(APTR folder);
	ULONG SortFolderIndex(APTR folder, ULONG field);
	APTR CreateArticleA(APTR folder, struct TagItem * tags);
	BOOL DisposeArticle(APTR article);
	APTR OpenArticle(APTR server, APTR folder, ULONG msgID, ULONG flags);
	BOOL CopyArticle(APTR folder, APTR article);
	ULONG SetArticleAttrsA(APTR article, struct TagItem * tags);
	ULONG GetArticleAttrsA(APTR article, struct TagItem * tags);
	BOOL SendArticle(APTR server, APTR article, UBYTE * from_file);
	BOOL AddArticlePartA(APTR article, APTR part, struct TagItem * tags);
	VOID RemArticlePart(APTR article, APTR part);
	APTR GetArticlePart(APTR article, ULONG partnum);
	ULONG GetArticlePartAttrsA(APTR part, struct TagItem * tags);
	ULONG SetArticlePartAttrsA(APTR part, struct TagItem * tags);
	APTR CreateArticlePartA(APTR article, struct TagItem * tags);
	VOID DisposeArticlePart(APTR part);
	BOOL GetArticlePartDataA(APTR article, APTR part, struct TagItem * tags);
	BOOL SetArticlePartDataA(APTR part, struct TagItem * tags);
	APTR CreateAddressEntryA(struct TagItem * tags);
	BOOL DisposeAddressEntry(APTR addr);
	APTR OpenAddressEntry(APTR server, ULONG fileid);
	LONG SaveAddressEntry(APTR server, APTR addr);
	BOOL RemAddressEntry(APTR server, APTR addr);
	ULONG GetAddressEntryAttrsA(APTR addr, struct TagItem * tags);
	ULONG SetAddressEntryAttrsA(APTR addr, struct TagItem * tags);
	BOOL MatchAddressA(APTR addr, struct TagItem * tags);
	APTR FindAddressEntryA(APTR server, struct TagItem * tags);
	APTR HuntAddressEntryA(APTR server, struct TagItem * tags);
	ULONG ScanAddressIndex(APTR server, struct Hook * hook, ULONG type, ULONG flags);
	BOOL AddCustomField(APTR addr, STRPTR field, STRPTR data);
	BOOL RemCustomField(APTR addr, STRPTR field);
	STRPTR GetCustomFieldData(APTR addr, STRPTR field);
	APTR CreateDecoderA(struct TagItem * tags);
	VOID DisposeDecoder(APTR dec);
	ULONG GetDecoderAttrsA(APTR dec, struct TagItem * tags);
	ULONG SetDecoderAttrsA(APTR dec, struct TagItem * tags);
	LONG Decode(APTR dec, ULONG type);
	LONG Encode(APTR dec, ULONG type);

private:
	struct Library *Base;
};

AmlLibrary AmlLibrary::Default;

#endif

