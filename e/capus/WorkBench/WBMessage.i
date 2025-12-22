   include "exec/types.i"
   include "exec/ports.i"
   STRUCTURE WBSTARTMSG,0
      STRUCT wb_msg,MN_SIZE
      LONG   wb_name
      LONG   wb_dirlock
      LONG   wb_stack
      LONG   wb_prio
      LONG   wb_numargs
      LONG   wb_arglist
      LABEL WBSTARTMSG_SIZE

