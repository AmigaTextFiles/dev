; Hook Structure
   IFND  EXEC_TYPES_I
   INCLUDE  "exec/types.i"
   ENDC

   IFND  EXEC_NODES_I
   INCLUDE  "exec/nodes.i"
   ENDC


  IFND  HOOK_I
HOOK_I SET 1



   STRUCTURE Hook,MLN_SIZE
   LONG    h_Entry
   LONG    h_SubEntry
   LONG    h_Data
   LABEL   Hook_SIZEOF

  ENDC