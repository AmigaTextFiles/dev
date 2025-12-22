/**/
/* Basic database-managment */
/**/
#pragma libcall TdDBase TDDB_CreateBaseA 1e 910804
#pragma libcall TdDBase TDDB_OpenBase 24 801
#pragma libcall TdDBase TDDB_CloseBase 2a 801
#pragma libcall TdDBase TDDB_CopyBase 30 9802
/**/
/* Nodehanteringsrutiner*/
/**/
#pragma libcall TdDBase TDDB_NewNode 36 801
#pragma libcall TdDBase TDDB_DeleteNode 3c 0802
#pragma libcall TdDBase TDDB_GetNode 42 10803
#pragma libcall TdDBase TDDB_FreeNode 48 9802
#pragma libcall TdDBase TDDB_LockNode 4e 0802
#pragma libcall TdDBase TDDB_UnLockNode 54 0802
#pragma libcall TdDBase TDDB_CopyNode 5a 190804
#pragma libcall TdDBase TDDB_FlushNodes 60 801
#pragma libcall TdDBase TDDB_SwapNodes 66 10803
/**/
/* Datahanteringsrutiner*/
/**/
#pragma libcall TdDBase TDDB_GetDataListA 6c 9802
#pragma libcall TdDBase TDDB_SetDataListA 72 A9803
#pragma libcall TdDBase TDDB_SetData 78 109804
#pragma libcall TdDBase TDDB_GetDataValue 7e 0802
#pragma libcall TdDBase TDDB_GetDataItem 84 0802
/**/
/* Meddelandefunktioner*/
/**/
#pragma libcall TdDBase TDDB_InstallMsg 8a 9802
#pragma libcall TdDBase TDDB_AbortMsg 90 9802
#pragma libcall TdDBase TDDB_ForceUpdate 96 0802
/**/
/* Sökfunktioner*/
/**/
#pragma libcall TdDBase TDDB_SeekBaseA 9c BA9804
#pragma libcall TdDBase TDDB_FindIntA a2 910804
#pragma libcall TdDBase TDDB_FindStringA a8 A90804
/**/
/* Rutiner för skapandet av listor.*/
/**/
#pragma libcall TdDBase TDDB_MakeList ae 09803
#pragma libcall TdDBase TDDB_UpdateList b4 09803
#pragma libcall TdDBase TDDB_FreeList ba 9802
/**/
/* Rutiner för att hitta mer matnyttiga strukturer.*/
/**/
#pragma libcall TdDBase TDDB_GetDBFromNode c0 801
#pragma libcall TdDBase TDDB_GetHandle c6 801


/* Pragmas to define VarArg calls. */

#ifndef _NOTAGCALL
#pragma tagcall TdDBase TDDB_CreateBase 1e 910804
#pragma tagcall TdDBase TDDB_GetDataList 6c 9802
#pragma tagcall TdDBase TDDB_SetDataList 72 A9803
#pragma tagcall TdDBase TDDB_SeekBase 9c BA9804
#pragma tagcall TdDBase TDDB_FindInt a2 910804
#pragma tagcall TdDBase TDDB_FindString a8 A90804
#endif
