/*

Code:       dock.rexx
Author:     Russell Leighton
Revision:   1 May 1997

*/

options results
parse arg m

address dock

MUIM_Application_OpenConfigWindow = 0x804299ba
MUIM_Window_Snapshot = 0x8042945e

MUIA_Draggable = 0x80420b6e
MUIA_FixWidth = 0x8042a3f1
MUIA_Frame = 0x8042ac64
MUIA_Group_Spacing = 0x8042866d
MUIA_InnerBottom = 0x8042f2c0
MUIA_InnerLeft = 0x804228f8
MUIA_InnerRight = 0x804297ff
MUIA_InnerTop = 0x80421eb6
MUIA_Menuitem_Shortcut = 0x80422030
MUIA_Menuitem_Title = 0x804218be
MUIA_Selected = 0x8042654b
MUIA_Window_Borderless = 0x80429b79
MUIA_Window_DepthGadget = 0x80421923
MUIA_Window_DragBar = 0x8042045d
MUIA_Window_SizeGadget = 0x8042e33d

MUIV_Frame_None = 0
FALSE = 0
TRUE = 1

if m = '' then do
    m = 1
    setvar EDIT 0
end

nextdock = ''
horiz = ''
frame = ''
virtual = ''
dragbar = TRUE
n = 0
dockname = 'DOCK'm
if exists(dockname) then do
    call open('dock',dockname,'R')
    nextdock = readln('dock')
    flags = readln('dock')
    if index(flags,'HORIZ') ~= 0 then horiz = 'HORIZ'
    if index(flags,'FRAME') ~= 0 then frame = 'FRAME'
    if index(flags,'VIRTUAL') ~= 0 then virtual = 'VIRTUAL'
    if index(flags,'DRAGBAR') = 0 then dragbar = FALSE
    line = readln('dock')
    do while ~eof('dock')
        n = n + 1
        setvar 'B'||m||n line
        line = readln('dock')
    end
    call close('dock')
end
else flags = 'DRAGBAR'

setvar 'X'||m nextdock
setvar 'F'||m flags
setvar 'D'||m n

window ID dockname CLOSE
window ID dockname ATTRS MUIA_Window_DragBar dragbar,
                         MUIA_Window_DepthGadget FALSE,
                         MUIA_Window_SizeGadget dragbar,
                         MUIA_Window_Borderless TRUE,
                         MUIA_InnerBottom 0,
                         MUIA_InnerLeft 0,
                         MUIA_InnerRight 0,
                         MUIA_InnerTop 0
 menu LABEL "Project"
  item COMMAND """about""" ATTRS MUIA_Menuitem_Shortcut 'A' LABEL "About"
  menu LABEL "Settings"
   item COMMAND """method "MUIM_Application_OpenConfigWindow" 0""" PORT dock ATTRS MUIA_Menuitem_Shortcut 'M' LABEL "MUI..."
   item COMMAND """method ID "dockname" "MUIM_Window_Snapshot" 1""" PORT dock ATTRS MUIA_Menuitem_Shortcut 'S' LABEL "Snapshot"
  endmenu
  item COMMAND """edit_open "m"""" ATTRS MUIA_Menuitem_Shortcut 'E' LABEL "Edit Dock" m
  item COMMAND """dock "m"""" ATTRS MUIA_Menuitem_Shortcut 'R' LABEL "Reset Dock" m
  item ATTRS MUIA_Menuitem_Title '-1'
  item COMMAND """quit""" PORT dock ATTRS MUIA_Menuitem_Shortcut 'Q' LABEL "Quit"
 endmenu
 menu LABEL "Monitor"
   item COMMAND '"monitor on con:0/660/840/240//auto"' PORT DOCK LABEL "On"
   item COMMAND '"monitor off"' PORT DOCK LABEL "Off"
   item COMMAND '"monitor error con:0/660/840/240//auto"' PORT DOCK LABEL "Error"
 endmenu
 group ID 'I'||m frame virtual horiz ATTRS MUIA_Group_Spacing 0,
                                           MUIA_InnerBottom 0,
                                           MUIA_InnerLeft 0,
                                           MUIA_InnerRight 0,
                                           MUIA_InnerTop 0
  if n > 0 then call dock_object m 0
  else do
   group ID 'G'||m||1 ATTRS MUIA_Group_Spacing 0
    button ID m||1 ATTRS MUIA_Frame MUIV_Frame_None MUIA_FixWidth 40
   endgroup
  end
 endgroup
endwindow

call dock_mode m 0 1

if nextdock ~= '' then do
    getvar EDIT
    if result = 0 then call dock m+1
end
