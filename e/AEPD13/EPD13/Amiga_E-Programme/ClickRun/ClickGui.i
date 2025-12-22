*************************************************
* Include ASM de ClickGui                       *
*************************************************
   include "exec/types.i"
   include "exec/nodes.i"

ID_CLRU    equ  $434C5255
ID_COMM    equ  $434F4D4D

   STRUCTURE CLICKNODE,0
      STRUCT cn_Node,LN_SIZE
      LONG   cn_Stack
      LONG   cn_Pri
      LONG   cn_CurrentDir   * STRING *
      LABEL CLICKNODE_SIZE

   STRUCTURE CLICKFILE,0
       LONG cf_Stack
       LONG cf_Pri
       LONG cf_CurrentDir    * STRING *
       LONG cf_Commande      * STRING *
       LABEL CLICKFILE_SIZE

