
#ifndef _ASLLIBRARY_H
#define _ASLLIBRARY_H

#include <exec/types.h>
#include <utility/tagitem.h>
#include <libraries/asl.h>

class AslLibrary
{
public:
	AslLibrary();
	~AslLibrary();

	static class AslLibrary Default;

	struct FileRequester * AllocFileRequest();
	VOID FreeFileRequest(struct FileRequester * fileReq);
	BOOL RequestFile(struct FileRequester * fileReq);
	APTR AllocAslRequest(ULONG reqType, struct TagItem * tagList);
	VOID FreeAslRequest(APTR requester);
	BOOL AslRequest(APTR requester, struct TagItem * tagList);
	VOID AbortAslRequest(APTR requester);
	VOID ActivateAslRequest(APTR requester);

private:
	struct Library *Base;
};

AslLibrary AslLibrary::Default;

#endif

