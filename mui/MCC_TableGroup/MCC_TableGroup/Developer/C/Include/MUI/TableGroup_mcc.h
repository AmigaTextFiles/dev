/*
**
** $VER: TableGroup_mcc.h V1.0 (23-Jan-98)
** Copyright © 1998 Henning Thielemann. All rights reserved.
**
*/

#ifndef   TABLEGROUP_MCC_H
#define   TABLEGROUP_MCC_H

#ifndef   EXEC_TYPES_H
#include  <exec/types.h>
#endif

#define   MUIC_TableGroup     "TableGroup.mcc"
#define   TableGroupObject    MUI_NewObject(MUIC_TableGroup

#define   MUIA_TableGroup_CellHorizWeight   0xF9F8010F
#define   MUIA_TableGroup_CellVertWeight    0xF9F8010E
#define   MUIA_TableGroup_Column            0xF9F80101
#define   MUIA_TableGroup_Columns           0xF9F8010C
#define   MUIA_TableGroup_ColumnSpace       0xF9F80109
#define   MUIA_TableGroup_ColumnSpan        0xF9F80103
#define   MUIA_TableGroup_ColumnWeight      0xF9F80113
#define   MUIA_TableGroup_EmptyCells        0xF9F8010D
#define   MUIA_TableGroup_Error             0xF9F80114
#define   MUIA_TableGroup_Find              0xF9F80117
#define   MUIA_TableGroup_GrowsTo           0xF9F80107
#define   MUIA_TableGroup_NextColumn        0xF9F80111
#define   MUIA_TableGroup_NextRow           0xF9F80110
#define   MUIA_TableGroup_Pool              0xF9F80104
#define   MUIA_TableGroup_PoolPuddleSize    0xF9F80105
#define   MUIA_TableGroup_PoolThreshSize    0xF9F80106
#define   MUIA_TableGroup_Row               0xF9F80100
#define   MUIA_TableGroup_Rows              0xF9F8010B
#define   MUIA_TableGroup_RowSpace          0xF9F8010A
#define   MUIA_TableGroup_RowSpan           0xF9F80102
#define   MUIA_TableGroup_RowWeight         0xF9F80112
#define   MUIA_TableGroup_SkipColumns       0xF9F80116
#define   MUIA_TableGroup_SkipRows          0xF9F80115

#define   MUIM_TableGroup_Clear             0xF9F80103
#define   MUIM_TableGroup_Insert            0xF9F80102
#define   MUIM_TableGroup_Remove            0xF9F80100
#define   MUIM_TableGroup_Replace           0xF9F80101
struct    MUIP_TableGroup_Clear             { ULONG MethodID; LONG row, column, rows, columns; };
struct    MUIP_TableGroup_Insert            { ULONG MethodID; LONG pos, num; ULONG dir; };
struct    MUIP_TableGroup_Remove            { ULONG MethodID; LONG pos, num; ULONG dir; };
struct    MUIP_TableGroup_Replace           { ULONG MethodID; Object *obj, ULONG row, column; };

#define	  MUIV_TableGroup_Error_None                  0
#define	  MUIV_TableGroup_Error_NotEnoughMemory       1
#define	  MUIV_TableGroup_Error_NoSize                2
#define	  MUIV_TableGroup_Error_ObjectAlreadyMember   3
#define	  MUIV_TableGroup_Error_ObjectNotAMember      4

#define	  MUIV_TableGroup_Direction_Down              0
#define	  MUIV_TableGroup_Direction_Right             1

#define	  MUIV_TableGroup_Clear_Row_Current          -1
#define	  MUIV_TableGroup_Clear_Column_Current       -1
#define	  MUIV_TableGroup_Clear_Rows_All             -1
#define	  MUIV_TableGroup_Clear_Columns_All          -1

#define	  MUIV_TableGroup_Insert_Current             -1
#define	  MUIV_TableGroup_Insert_Row                  0
#define	  MUIV_TableGroup_Insert_Column               1

#define	  MUIV_TableGroup_Remove_Current             -1
#define	  MUIV_TableGroup_Remove_All                 -1
#define	  MUIV_TableGroup_Remove_Row                  0
#define	  MUIV_TableGroup_Remove_Column               1

#endif /* TABLEGROUP_MCC_H */
