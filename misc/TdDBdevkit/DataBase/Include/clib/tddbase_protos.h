#ifndef CLIB_TDDBASE_H
#define CLIB_TDDBASE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

struct DBHandle *TDDB_CreateBaseA(STRPTR, ULONG, ULONG,struct TagItem *);
struct DBHandle *TDDB_CreateBase(STRPTR, ULONG, ULONG,Tag,...);
struct DBHandle *TDDB_OpenBase(STRPTR);
void TDDB_CloseBase(struct DBHandle *);
struct DBHandle *TDDB_CopyBase(struct DBHandle *,STRPTR);

struct DBNode *TDDB_NewNode(struct DBHandle *);
void TDDB_DeleteNode(struct DBHandle *,ULONG);
struct DBNode *TDDB_GetNode(struct DBHandle *, ULONG, ULONG);
void TDDB_FreeNode(struct DBHandle *, struct DBNode *);
void TDDB_LockNode(struct DBHandle *,ULONG);
void TDDB_UnLockNode(struct DBHandle *,ULONG);
int TDDB_CopyNode(struct DBHandle *,ULONG,struct DBHandle *,ULONG);
void TDDB_FlushNodes(struct DBHandle *);
void TDDB_SwapNodes(struct DBHandle *, ULONG, ULONG);

void TDDB_GetDataListA(struct DBNode *,ULONG *);
void TDDB_GetDataList(struct DBNode *,ULONG,...);
void TDDB_SetDataListA(struct DBHandle *,struct DBNode *,ULONG *);
void TDDB_SetDataList(struct DBHandle *,struct DBNode *,ULONG,...);
void TDDB_SetData(struct DBHandle *,struct DBNode *,ULONG,ULONG);
ULONG TDDB_GetDataValue(struct DBNode *,ULONG);
struct DataStorage *TDDB_GetDataItem(struct DBNode *,ULONG);

void TDDB_InstallMsg(struct DBHandle *,struct UpdateMsg *);
void TDDB_AbortMsg(struct DBHandle *,struct UpdateMsg *);
void TDDB_ForceUpdate(struct DBHandle *,ULONG,ULONG);

struct DBNode *TDDB_SeekBaseA(struct DBHandle *,struct Hook *,APTR,struct TagItem *);
struct DBNode *TDDB_SeekBase(struct DBHandle *,struct Hook *,APTR,Tag, ...);
struct DBNode *TDDB_FindIntA(struct DBHandle *,ULONG,ULONG,struct TagItem *);
struct DBNode *TDDB_FindInt(struct DBHandle *,ULONG,ULONG,Tag, ...);
struct DBNode *TDDB_FindStringA(struct DBHandle *,ULONG,STRPTR,struct TagItem *);
struct DBNode *TDDB_FindString(struct DBHandle *,ULONG,STRPTR,Tag,...);

LONG TDDB_MakeList(struct DBHandle *,struct List *,ULONG);
LONG TDDB_UpdateList(struct DBHandle *,struct List *,ULONG);
void TDDB_FreeList(struct DBHandle *,struct List *);

struct DataBase *TDDB_GetDBFromNode(struct DBNode *);
struct DBHandle *TDDB_GetHandle(struct DataBase *);

#endif