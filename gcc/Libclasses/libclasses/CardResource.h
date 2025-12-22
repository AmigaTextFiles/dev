
#ifndef _CARDRESOURCE_H
#define _CARDRESOURCE_H

#include <exec/types.h>
#include <exec/resident.h>
#include <resources/card.h>

class CardResource
{
public:
	CardResource();
	~CardResource();

	static class CardResource Default;

	struct CardHandle * OwnCard(struct CardHandle * handle);
	VOID ReleaseCard(struct CardHandle * handle, ULONG flags);
	struct CardMemoryMap * GetCardMap();
	BOOL BeginCardAccess(struct CardHandle * handle);
	BOOL EndCardAccess(struct CardHandle * handle);
	UBYTE ReadCardStatus();
	BOOL CardResetRemove(struct CardHandle * handle, ULONG flag);
	UBYTE CardMiscControl(struct CardHandle * handle, ULONG control_bits);
	ULONG CardAccessSpeed(struct CardHandle * handle, ULONG nanoseconds);
	LONG CardProgramVoltage(struct CardHandle * handle, ULONG voltage);
	BOOL CardResetCard(struct CardHandle * handle);
	BOOL CopyTuple(CONST struct CardHandle * handle, UBYTE * buffer, ULONG tuplecode, ULONG size);
	ULONG DeviceTuple(CONST UBYTE * tuple_data, struct DeviceTData * storage);
	struct Resident * IfAmigaXIP(CONST struct CardHandle * handle);
	BOOL CardForceChange();
	ULONG CardChangeCount();
	ULONG CardInterface();

private:
	struct Library *Base;
};

CardResource CardResource::Default;

#endif

