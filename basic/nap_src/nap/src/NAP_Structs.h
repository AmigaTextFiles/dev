STRUCT Node                           {* Node is from EXEC/NODES.H *}
 ADDRESS   ln_Succ
 ADDRESS   ln_Pred
 BYTE      ln_Type
 BYTE      ln_Pri
 ADDRESS   ln_Name
END STRUCT

STRUCT _List
 ADDRESS   lh_Head
 ADDRESS   lh_Tail
 ADDRESS   lh_TailPred
 BYTE      lh_Type
 BYTE      l_pad
END STRUCT

STRUCT StructNode
 ADDRESS   ln_Succ
 ADDRESS   ln_Pred
 BYTE      ln_Type
 BYTE      ln_Pri
 ADDRESS   ln_Name
 ADDRESS   member_types_list
END STRUCT

STRUCT DefineNode
 ADDRESS   ln_Succ
 ADDRESS   ln_Pred
 BYTE      ln_Type
 BYTE      ln_Pri
 ADDRESS   ln_Name
 ADDRESS   replace
 SHORTINT  countparam
END STRUCT

{*
** This structure is used to save the different conditions.
*}

STRUCT optionStruct
 BYTE Remove_Structs
 BYTE Remove_Comments
 BYTE Remove_Defines
 BYTE Const_Defines
 BYTE Replace_Defines
 BYTE Print_Errors
 BYTE ShowTime
 BYTE Tracing
 BYTE Remove_Lines
 BYTE Comment_Source
END STRUCT

' For list handling
STRUCT listbasesStruct
 ADDRESS defines
 ADDRESS include
 ADDRESS needed_structs
 ADDRESS structures
END STRUCT
