/* Application created by MUIBuild */

address DragnDrop

MUIA_Cycle_Active = 0x80421788
MUIA_Dropable = 0x8042fbce
MUIA_List_DragSortable = 0x80426099
MUIA_List_ShowDropMarks = 0x8042c6f3
MUIA_Listview_DragType = 0x80425cd3
MUIA_Listview_MultiSelect = 0x80427e08
MUIV_List_Insert_Bottom = -3
MUIV_List_Insert_Sorted = -2
MUIV_Listview_DragType_Immediate = 1
MUIV_Listview_MultiSelect_Default = 1
TRUE = 1
FALSE = 0
MUIA_List_Quiet = 0x8042d8c7

window COMMAND """quit""" PORT DragnDrop TITLE """Drag&Drop Demo"""
 group HORIZ
  group
   label CENTER "Available Fields\n(alpha sorted)"
   list ID LST1,
    ATTRS MUIA_Listview_DragType MUIV_Listview_DragType_Immediate,
          MUIA_List_ShowDropMarks FALSE
  endgroup
  group
   label CENTER "Visible Fields\n(sortable)"
   list ID LST2,
    ATTRS MUIA_Listview_DragType MUIV_Listview_DragType_Immediate,
          MUIA_List_DragSortable TRUE
  endgroup
 endgroup
 group HORIZ
  group
   text LABEL "\033cListview without\nmultiple selection."
   list ID LST3,
    ATTRS MUIA_Listview_DragType MUIV_Listview_DragType_Immediate,
          MUIA_List_DragSortable TRUE,
          MUIA_Dropable TRUE
  endgroup
  group
   text LABEL "\033cListview with\nmultiple selection."
   list ID LST4,
    ATTRS MUIA_Listview_DragType MUIV_Listview_DragType_Immediate,
          MUIA_List_DragSortable TRUE,
          MUIA_Listview_MultiSelect MUIV_Listview_MultiSelect_Default,
          MUIA_Dropable TRUE
  endgroup
 endgroup
endwindow
callhook ID LST1 PORT INLINE INCLUDE "LST2" DROP,
     COMMAND """options results; 
                address DragnDrop; 
                line = '%s'; 
                'list ID LST1 INSERT POS "MUIV_List_Insert_Sorted" STRING' line; 
                'list ID LST2 REMOVE STRING' line;"""
callhook ID LST2 PORT INLINE INCLUDE "LST1" DROP,
     COMMAND """options results; 
                address DragnDrop; 
                line = '%s'; 
                'list ID LST2 INSERT STRING' line; 
                'list ID LST1 REMOVE STRING' line;"""
callhook ID LST3 INCLUDE "LST3"
callhook ID LST4 INCLUDE "LST4"
list ID LST1 ATTRS MUIA_List_Quiet TRUE
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Age"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Birthday"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "c/o"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "City"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Comment"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Country"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "EMail"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Fax"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "First name"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Job"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Name"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Phone"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Projects"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Salutation"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "State"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "Street"
list ID LST1 POS MUIV_List_Insert_Sorted INSERT STRING "ZIP"
list ID LST3 ATTRS MUIA_List_Quiet TRUE
list ID LST4 ATTRS MUIA_List_Quiet TRUE
do i = 1 to 50
 list ID LST3 POS MUIV_List_Insert_Bottom INSERT STRING "Line "right(i,2)
 list ID LST4 POS MUIV_List_Insert_Bottom INSERT STRING "Line "right(i,2)
end
list ID LST1 ATTRS MUIA_List_Quiet FALSE
list ID LST3 ATTRS MUIA_List_Quiet FALSE
list ID LST4 ATTRS MUIA_List_Quiet FALSE
