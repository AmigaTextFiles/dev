*******************************************************
* Asm Source of ReadGUIFile.m                         *
*******************************************************
   include "exec/types.i"
   include "exec/nodes.i"
   include "exec/lists.i"

* GuiBase *

   STRUCTURE GUIBASE,0
      LONG gui_adrlistdef
      LONG gui_adrlistwindow
      LONG currentwindow
      LONG currentgadget
      LABEL GUIBASE_SIZE

* WindowNode *

   STRUCTURE WINDOWNODE,0
      STRUCT win_node,LN_SIZE
      LONG   win_left
      LONG   win_top
      LONG   win_width
      LONG   win_height
      LONG   win_idcmp
      LONG   win_flags
      LONG   win_adrgadgetlist
      LONG   win_adrmenulist
      LONG   win_adrbboxlist
      LONG   win_adritextlist
      LONG   win_title              * STRING *
      LONG   win_screen             * STRING *
      LABEL WINDOWNODE_SIZE

* Gadget Node *

   STRUCTURE GADGETNODE,0
      STRUCT ga_node,LN_SIZE
      WORD   ga_kind
      WORD   ga_leftedge
      WORD   ga_topedge
      WORD   ga_width
      WORD   ga_height
      LONG   ga_gadgettext     * STRING *
      LONG   ga_flags
      LABEL GADGETNODE_SIZE

* Menu Node *

   STRUCTURE MENUNODE,0
      STRUCT mn_node,LN_SIZE
      WORD   mn_type
      LONG   mn_text             * STRING *
      LONG   mn_comkey           * STRING *
      LONG   mn_flags
      LONG   mn_mutualexclude
      LABEL MENUNODE_SIZE

* Bbox Node *

   STRUCTURE BBOXNODE,0
      STRUCT bb_node,LN_SIZE
      WORD   left
      WORD   top
      WORD   width
      WORD   height
      WORD   flags
      LABEL BBOXNODE_SIZE

* Itext Node *

   STRUCTURE ITEXTNODE,0
      STRUCT it_node,LN_SIZE
      WORD   it_left
      WORD   it_top
      LONG   it_text         * STRING *
      LABEL ITEXTNODE_SIZE


