
#ifndef _REALTIMELIBRARY_H
#define _REALTIMELIBRARY_H

#include <exec/types.h>
#include <libraries/realtime.h>
#include <utility/tagitem.h>

class RealTimeLibrary
{
public:
	RealTimeLibrary();
	~RealTimeLibrary();

	static class RealTimeLibrary Default;

	APTR LockRealTime(ULONG lockType);
	VOID UnlockRealTime(APTR lock);
	struct Player * CreatePlayerA(CONST struct TagItem * tagList);
	VOID DeletePlayer(struct Player * player);
	BOOL SetPlayerAttrsA(struct Player * player, CONST struct TagItem * tagList);
	LONG SetConductorState(struct Player * player, ULONG state, LONG time);
	BOOL ExternalSync(struct Player * player, LONG minTime, LONG maxTime);
	struct Conductor * NextConductor(CONST struct Conductor * previousConductor);
	struct Conductor * FindConductor(CONST_STRPTR name);
	ULONG GetPlayerAttrsA(CONST struct Player * player, CONST struct TagItem * tagList);

private:
	struct Library *Base;
};

RealTimeLibrary RealTimeLibrary::Default;

#endif

