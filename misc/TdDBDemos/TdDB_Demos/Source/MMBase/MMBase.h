
// Private includefile for MMBase

#ifndef LIBRARIES_TDDBASE_H
#include <libraries/tddbase.h>
#endif

// This fields are we using.

#define ID_Name		StrTag(1)
#define ID_Comment	StrTag(2)
#define ID_Data		BinTag(3)

// Datas...
extern struct DBHandle *DBase;
extern struct FileRequester *FilReq;

// protos
int InitGUI(int NodeNr);
BOOL GetFile(STRPTR Buffer, ULONG StrLen);
