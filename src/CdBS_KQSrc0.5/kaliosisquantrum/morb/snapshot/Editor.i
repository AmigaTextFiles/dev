*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Include file for text editor engine and related classes
* $Id$
*

***** RawEditorClass *****
         CLASS     RawEditorClass,GuiRootClass

         METHOD    RED_DigestBuffer
         METHOD    RED_VomitBuffer

         DATA_LONG red,REDT_Scroller,1
         DATA_LONG red,REDT_ShowScroller,1
         DATA_LONG red,REDT_ClearScroller,1

         DATA_LONG red,REDT_BufListMemPool,1

         DATA_LONG red,REDT_DispTable,1
         DATA_LONG red,REDT_DispEntNum,1

         DATA_LONG red,REDT_Buffer,1
         DATA_BYTE red,REDT_BufferList,MLH_SIZE
         DATA_LONG red,REDT_NumLines,1
         DATA_LONG red,REDT_NumVis,1

         DATA_LONG red,REDT_FirstLine,1
         DATA_LONG red,REDT_FirstLineNumber,1

         DATA_LONG red,REDT_ClrTop,1
         DATA_LONG red,REDT_ClrHeight,1

         DATA_LONG red,REDT_Width,1
         DATA_LONG red,REDT_Right,1
         DATA_SIZE red_DataSize

;LISTVIEW macro     ; list,selected,first,hook,hookdata
;         dc.l      OBJ_Begin,_ListViewClass
;         dc.l      LVDT_List,\1
;         dc.l      LVDT_Selected,\2
;         dc.l      LVDT_FirstVis,\3
;         SETHOOK   \4,\5
;         dc.l      OBJ_End
;         endm

         rsreset
BufListEntry       rs.b      0
bve_Next           rs.l      1
bve_Prev           rs.l      1
bve_Length         rs.l      1
bve_String         rs.l      1
bve_Size           rs.b      0
**************************

