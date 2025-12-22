***
*** Miscallenous stuff for MUI assembler usage
***
*
*   IFND LIBRARIES_MUI_ASM_I
* LIBRARIES_MUI_ASM_I SET 1
*
*** In case user forgets that this .i includes data

*   bra   end_of_mui_asm_i

*   IFND LIBRARIES_MUI_I
*   INCLUDE "libraries/mui.i"
*   ENDC  ;LIBRARIES_MUI_I

*** Pointers for strings

MUIC_Notify       dc.l  MUIC_Notify_s
MUIC_Family       dc.l  MUIC_Family_s
MUIC_Menustrip    dc.l  MUIC_Menustrip_s
MUIC_Menu         dc.l  MUIC_Menu_s
MUIC_Menuitem     dc.l  MUIC_Menuitem_s
MUIC_Application  dc.l  MUIC_Application_s
MUIC_Window       dc.l  MUIC_Window_s
MUIC_Area         dc.l  MUIC_Area_s
MUIC_Rectangle    dc.l  MUIC_Rectangle_s
MUIC_Image        dc.l  MUIC_Image_s
MUIC_Bitmap       dc.l  MUIC_Bitmap_s
MUIC_Bodychunk    dc.l  MUIC_Bodychunk_s
MUIC_Text         dc.l  MUIC_Text_s
MUIC_String       dc.l  MUIC_String_s
MUIC_Prop         dc.l  MUIC_Prop_s
MUIC_Gauge        dc.l  MUIC_Gauge_s
MUIC_Scale        dc.l  MUIC_Scale_s
MUIC_Boopsi       dc.l  MUIC_Boopsi_s
MUIC_Colorfield   dc.l  MUIC_Colorfield_s
MUIC_List         dc.l  MUIC_List_s
MUIC_Floattext    dc.l  MUIC_Floattext_s
MUIC_Volumelist   dc.l  MUIC_Volumelist_s
MUIC_Scrmodelist  dc.l  MUIC_Scrmodelist_s
MUIC_Dirlist      dc.l  MUIC_Dirlist_s
MUIC_Group        dc.l  MUIC_Group_s
MUIC_Register     dc.l  MUIC_Register_s
MUIC_Virtgroup    dc.l  MUIC_Virtgroup_s
MUIC_Scrollgroup  dc.l  MUIC_Scrollgroup_s
MUIC_Scrollbar    dc.l  MUIC_Scrollbar_s
MUIC_Listview     dc.l  MUIC_Listview_s
MUIC_Radio        dc.l  MUIC_Radio_s
MUIC_Cycle        dc.l  MUIC_Cycle_s
MUIC_Slider       dc.l  MUIC_Slider_s
MUIC_Coloradjust  dc.l  MUIC_Coloradjust_s
MUIC_Palette      dc.l  MUIC_Palette_s
MUIC_Colorpanel   dc.l  MUIC_Colorpanel_s
MUIC_Popstring    dc.l  MUIC_Popstring_s
MUIC_Popobject    dc.l  MUIC_Popobject_s
MUIC_Poplist      dc.l  MUIC_Poplist_s
MUIC_Popasl       dc.l  MUIC_Popasl_s


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
MUIC_Register_s      dc.b  "Register.mui",0
MUIC_Menustrip_s     dc.b  "Menustrip.mui",0
MUIC_Menuitem_s      dc.b  "Menuitem.mui",0
MUIC_Menu_s          dc.b  "Menu.mui",0
MUIC_Bitmap_s        dc.b  "Bitmap.mui",0
MUIC_Bodychunk_s     dc.b  "Bodychunk.mui",0
MUIC_Colorfield_s    dc.b  "Colorfield.mui",0
MUIC_Scrmodelist_s   dc.b  "Scrmodelist.mui",0
MUIC_Virtgroup_s     dc.b  "Virtgroup.mui",0
MUIC_Scrollgroup_s   dc.b  "Scrollgroup.mui",0
MUIC_Coloradjust_s   dc.b  "Coloradjust.mui",0
MUIC_Palette_s       dc.b  "Palette.mui",0
MUIC_Colorpanel_s    dc.b  "Colorpanel.mui",0
MUIC_Popstring_s     dc.b  "Popstring.mui",0
MUIC_Popobject_s     dc.b  "Popobject.mui",0
MUIC_Poplist_s       dc.b  "Poplist.mui",0
MUIC_Popasl_s        dc.b  "Popasl.mui",0
MUIC_Family_s        dc.b  "Family.mui",0

*** Strings needed by some macros

PreParse    dc.b  27,'c',0
PreParse2   dc.b  27,'r',0
            even

*** For Popup macro

dummy       dc.l  0

*end_of_mui_asm_i

*   ENDC  ;LIBRARIES_MUI_ASM_I
