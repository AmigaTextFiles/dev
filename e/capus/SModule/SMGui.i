   include "exec/types.i"
   include "exec/nodes.i"

   STRUCTURE SMBASE,0
      LONG   sm_EmptyList
      LONG   sm_ModuleList
      LABEL  SMBASE_SIZE

   STRUCTURE MODULENODE,0
      STRUCT mn_Node,LN_SIZE
      LONG   mn_DataList
      LABEL  MODULENODE_SIZE



