   INCLUDE "exec/types.i"
   INCLUDE "exec/nodes.i"

   STRUCTURE EuBase,0
      LONG eu_pmodulelist
      LONG eu_proclist
      LONG eu_infolist
      LABEL EuBase_SIZE

   STRUCTURE FileNode,0
      STRUCT f_Node,LN_SIZE
      LONG   f_deflist
      LONG   f_proclist
      LABEL FileNode_SIZE

   STRUCTURE ProcNode,0
      STRUCT p_Node,LN_SIZE
      LONG   p_Buffer
      LONG   p_Length
      LABEL ProcNode_SIZE

