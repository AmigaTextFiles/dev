
#ifndef _EXPANSIONLIBRARY_H
#define _EXPANSIONLIBRARY_H

#include <exec/types.h>
#include <libraries/configvars.h>
#include <dos/filehandler.h>

class ExpansionLibrary
{
public:
	ExpansionLibrary();
	~ExpansionLibrary();

	static class ExpansionLibrary Default;

	VOID AddConfigDev(struct ConfigDev * configDev);
	BOOL AddBootNode(LONG bootPri, ULONG flags, struct DeviceNode * deviceNode, struct ConfigDev * configDev);
	VOID AllocBoardMem(ULONG slotSpec);
	struct ConfigDev * AllocConfigDev();
	APTR AllocExpansionMem(ULONG numSlots, ULONG slotAlign);
	VOID ConfigBoard(APTR board, struct ConfigDev * configDev);
	VOID ConfigChain(APTR baseAddr);
	struct ConfigDev * FindConfigDev(CONST struct ConfigDev * oldConfigDev, LONG manufacturer, LONG product);
	VOID FreeBoardMem(ULONG startSlot, ULONG slotSpec);
	VOID FreeConfigDev(struct ConfigDev * configDev);
	VOID FreeExpansionMem(ULONG startSlot, ULONG numSlots);
	UBYTE ReadExpansionByte(CONST APTR board, ULONG offset);
	VOID ReadExpansionRom(CONST APTR board, struct ConfigDev * configDev);
	VOID RemConfigDev(struct ConfigDev * configDev);
	VOID WriteExpansionByte(APTR board, ULONG offset, ULONG byte);
	VOID ObtainConfigBinding();
	VOID ReleaseConfigBinding();
	VOID SetCurrentBinding(struct CurrentBinding * currentBinding, ULONG bindingSize);
	ULONG GetCurrentBinding(CONST struct CurrentBinding * currentBinding, ULONG bindingSize);
	struct DeviceNode * MakeDosNode(CONST APTR parmPacket);
	BOOL AddDosNode(LONG bootPri, ULONG flags, struct DeviceNode * deviceNode);

private:
	struct Library *Base;
};

ExpansionLibrary ExpansionLibrary::Default;

#endif

