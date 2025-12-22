/* Application created by MUIBuild */

address DOCK

MUIA_Background  = 0x8042545b
MUIA_ControlChar = 0x8042120b
MUIA_Frame  = 0x8042ac64
MUIA_Text_HiChar = 0x804218ff
MUIA_Window_DepthGadget  = 0x80421923
MUIA_Window_DragBar  = 0x8042045d
MUIA_Window_SizeGadget  = 0x8042e33d

MUII_WindowBack  = 0
MUIV_Frame_None  = 0
FALSE = 0

AboutWindow = "window ID ABOUT"

AboutWindow ATTRS MUIA_Window_DepthGadget FALSE MUIA_Window_DragBar FALSE MUIA_Window_SizeGadget FALSE
 group HORIZ
  button PICT "MUIREXX:demos/muirexx.brush" TRANS ATTRS MUIA_Background MUII_WindowBack MUIA_Frame MUIV_Frame_None
  text ATTRS MUIA_Background MUII_WindowBack MUIA_Frame MUIV_Frame_None LABEL "This is a MUIRexx application for\nbuilding and maintaining Docks!\nThis is a preliminary release."
 endgroup
 group HORIZ
  space HORIZ
  button PRESS COMMAND """"AboutWindow" CLOSE""" PORT DOCK ATTRS MUIA_Text_HiChar c2d('O') MUIA_ControlChar c2d('o') LABEL "Ok"
  space HORIZ
 endgroup
endwindow
