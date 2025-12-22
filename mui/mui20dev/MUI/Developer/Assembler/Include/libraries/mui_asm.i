***
*** Miscallenous stuff for MUI assembler usage
***

   IFND LIBRARIES_MUI_ASM_I
LIBRARIES_MUI_ASM_I SET 1

*** In case user forgets that this .i includes data

   bra   end_of_mui_asm_i

   IFND LIBRARIES_MUI_I
   INCLUDE "libraries/mui.i"
   ENDC  ;LIBRARIES_MUI_I

*** Pointers for strings

MUIC_Notify       dc.l  MUIC_Notify_s
MUIC_Application  dc.l  MUIC_Application_s
MUIC_Window       dc.l  MUIC_Window_s
MUIC_Area         dc.l  MUIC_Area_s
MUIC_Rectangle    dc.l  MUIC_Rectangle_s
MUIC_Image        dc.l  MUIC_Image_s
MUIC_Text         dc.l  MUIC_Text_s
MUIC_String       dc.l  MUIC_String_s
MUIC_Prop         dc.l  MUIC_Prop_s
MUIC_Slider       dc.l  MUIC_Slider_s
MUIC_List         dc.l  MUIC_List_s
MUIC_Floattext    dc.l  MUIC_Floattext_s
MUIC_Volumelist   dc.l  MUIC_Volumelist_s
MUIC_Dirlist      dc.l  MUIC_Dirlist_s
MUIC_Group        dc.l  MUIC_Group_s
MUIC_Scrollbar    dc.l  MUIC_Scrollbar_s
MUIC_Listview     dc.l  MUIC_Listview_s
MUIC_Radio        dc.l  MUIC_Radio_s
MUIC_Cycle        dc.l  MUIC_Cycle_s
MUIC_Gauge        dc.l  MUIC_Gauge_s
MUIC_Scale        dc.l  MUIC_Scale_s
MUIC_Boopsi       dc.l  MUIC_Boopsi_s

*** Strings

MUIC_Notify_s        dc.b  "Notify.mui",0
MUIC_Application_s   dc.b  "Application.mui",0
MUIC_Window_s        dc.b  "Window.mui",0
MUIC_Area_s          dc.b  "Area.mui",0
MUIC_Rectangle_s     dc.b  "Rectangle.mui",0
MUIC_Image_s         dc.b  "Image.mui",0
MUIC_Text_s          dc.b  "Text.mui",0
MUIC_String_s        dc.b  "String.mui",0
MUIC_Prop_s          dc.b  "Prop.mui",0
MUIC_Slider_s        dc.b  "Slider.mui",0
MUIC_List_s          dc.b  "List.mui",0
MUIC_Floattext_s     dc.b  "Floattext.mui",0
MUIC_Volumelist_s    dc.b  "Volumelist.mui",0
MUIC_Dirlist_s       dc.b  "Dirlist.mui",0
MUIC_Group_s         dc.b  "Group.mui",0
MUIC_Scrollbar_s     dc.b  "Scrollbar.mui",0
MUIC_Listview_s      dc.b  "Listview.mui",0
MUIC_Radio_s         dc.b  "Radio.mui",0
MUIC_Cycle_s         dc.b  "Cycle.mui",0
MUIC_Gauge_s         dc.b  "Gauge.mui",0
MUIC_Scale_s         dc.b  "Scale.mui",0
MUIC_Boopsi_s        dc.b  "Boopsi.mui",0

*** Strings needed by some macros

PreParse    dc.b  27,'c',0
PreParse2   dc.b  27,'r',0
            even

*** For Popup macro

dummy       dc.l  0

end_of_mui_asm_i

   ENDC  ;LIBRARIES_MUI_ASM_I
