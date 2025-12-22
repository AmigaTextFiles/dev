   include "exec/types.i"
   include "exec/nodes.i"

ID_WVPR  EQU  $57565052
ID_WVAC  EQU  $57564143
ID_DEFA  EQU  $44454641

   STRUCTURE WVBASE,0
      LONG   wv_AdrIdList
      LONG   wv_AdrActionList
      LONG   wv_AdrEmptyList
      LABEL WVBASE_SIZE

   STRUCTURE ACTIONNODE,0
      STRUCT    ac_Node,LN_SIZE     * node.name content the idstring of the whatis.library *
      WORD      ac_ExecType         * exectype MODE_WB or MODE_CLI *
      LONG      ac_Command          * String *
      LONG      ac_CurrentDir       * String *
      LONG      ac_Stack
      LONG      ac_Priority
      LONG      ac_NumArg
      LONG      ac_usesubtype
      STRUCT    ac_ArgList,160
      LONG      ac_cmd
      LABEL ACTIONNODE_SIZE

MODE_WB   equ 0
MODE_CLI  equ 1

   STRUCTURE WVARG,0
      STRUCT wa_Node,LN_SIZE        * node.name content the filename *
      LONG   wa_Lock                * the lock of the filename *
      LONG   wa_Size                * the size of the filename *
      LONG   wa_Date                * the date of the filename *
      LONG   wa_IdString            * the idstring of the filename *
      LABEL WVARG_SIZE

   STRUCTURE WVMSG,0
      STRUCT wm_Msg,20
      LONG   wm_Name
      LONG   wm_Lock
      LABEL WVMSG_SIZE


