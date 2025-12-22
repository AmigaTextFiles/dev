/* */
options results
parse arg m

address dock

MUIA_CycleChain = 0x80421ce7
MUIA_Dropable = 0x8042fbce
MUIA_FixWidth = 0x8042a3f1
MUIA_Frame = 0x8042ac64
MUIA_Listview_DragType = 0x80425cd3
MUIA_List_DragSortable = 0x80426099
MUIA_Menuitem_Title = 0x804218be
MUIA_Selected = 0x8042654b
MUIA_String_MaxLen = 0x80424984
MUIA_Weight = 0x80421d1f

MUIV_Frame_Group = 9
MUIV_List_GetEntry_Active = -1
MUIV_List_Insert_Bottom = -3
MUIV_Listview_DragType_Immediate = 1
FALSE = 0
TRUE = 1

call dock_mode m 0 0

getvar 'F'||m
flags = result
if index(flags,'HORIZ') = 0 then hflag = FALSE
else hflag = TRUE
if index(flags,'FRAME') = 0 then fflag = FALSE
else fflag = TRUE
if index(flags,'VIRTUAL') = 0 then vflag = FALSE
else vflag = TRUE
if index(flags,'DRAGBAR') = 0 then dflag = FALSE
else dflag = TRUE

getvar EDIT
n = result
if n ~= 0 then do
    window ID EDIT CLOSE
    call dock n
end
setvar EDIT m
setvar ITEM 0
dockname = 'DOCK'm
window ID EDIT TITLE """Edit Dock "m"""",
    PORT INLINE COMMAND """
        address dock;
        window ID EDIT CLOSE;
        call dock "m";
        setvar EDIT 0;""" 
 menu LABEL "Project"
  menu LABEL "Next Dock"
   item COMMAND """dock_save "m" DOCK 1""" LABEL "New"
   item COMMAND """dock_save "m" DOCK 0""" LABEL "Remove"
  endmenu
  item COMMAND """MUIREXX:demos/MUIRexxDir/muidir DOCK""" LABEL "Open DirUtil"
  item ATTRS MUIA_Menuitem_Title '-1'
  item PORT INLINE COMMAND """
        address dock;
        window ID EDIT CLOSE;
        call dock "m";
        setvar EDIT 0;""" LABEL "Close"
 endmenu
 group HORIZ FRAME
  space HORIZ
  label 'Horiz'
  check COMMAND """dock_save "m" HORIZ %s""" ATTRS MUIA_Selected hflag HELP """If checked then the dock\nwill be horizontal."""
  label 'Frame'
  check COMMAND """dock_save "m" FRAME %s""" ATTRS MUIA_Selected fflag HELP """If checked then the dock\nwill have a frame."""
  label 'Virtual'
  check COMMAND """dock_save "m" VIRTUAL %s""" ATTRS MUIA_Selected vflag HELP """If checked then the dock\nwill be a virtual group."""
  label 'Dragbar'
  check COMMAND """dock_save "m" DRAGBAR %s""" ATTRS MUIA_Selected dflag HELP """If checked then the dock\nwill have a drag bar."""
  space HORIZ
 endgroup
 group HORIZ
  group FRAME
   group ID BICON ATTRS MUIA_Weight 0 HELP """Drop an icon from either\nthe dock or the Workbench.\nDrag this icon to the\ndock to change a dock icon.\nNote that dock icons can be\nrearranged by drag and drop."""
    group ID 'G00'
     button ID '00' ATTRS MUIA_Frame MUIV_Frame_Group MUIA_FixWidth 40
    endgroup
   endgroup
   cycle ID BTYPE HELP """Select the type of icon.""" LABELS "button,switch,pop"
  endgroup
  group ID MGRP REGISTER LABELS "Press,App,Drop,Pop,Add"
   group ID PGRP HORIZ
    group
     label DOUBLE "command:"
     label DOUBLE "port:"
    endgroup
    group
     popasl ID PCOMM ATTRS MUIA_CycleChain TRUE MUIA_String_MaxLen 160 HELP """Enter a command or drop command\nfrom Workbench or directory utility."""
     string ID PPORT ATTRS MUIA_CycleChain TRUE HELP """Enter port name for command."""
    endgroup
   endgroup
   group ID AGRP HORIZ
    group
     label DOUBLE "command:"
     label DOUBLE "port:"
    endgroup
    group
     popasl ID ACOMM ATTRS MUIA_CycleChain TRUE MUIA_String_MaxLen 160 HELP """Enter a command or drop command\nfrom Workbench or directory utility."""
     string ID APORT ATTRS MUIA_CycleChain TRUE HELP """Enter port name for command."""
    endgroup
   endgroup
   group ID DGRP HORIZ
    group
     label DOUBLE "command:"
     label DOUBLE "port:"
    endgroup
    group
     popasl ID DCOMM ATTRS MUIA_CycleChain TRUE MUIA_String_MaxLen 160 HELP """Enter a command or drop command\nfrom Workbench or directory utility."""
     string ID DPORT ATTRS MUIA_CycleChain TRUE HELP """Enter port name for command."""
    endgroup
   endgroup
   group ID LGRP
    list ID LLST,
        ATTRS MUIA_Listview_DragType MUIV_Listview_DragType_Immediate,
              MUIA_List_DragSortable TRUE,
              MUIA_Dropable TRUE,
        COMMAND """string ID LSTR CONTENT %s""" PORT DOCK,
        HELP """Drop a command from Workbench\nor directory utility.\nDouble click entry to edit."""
    group HORIZ
     string ID LSTR COMMAND """list ID LLST INSERT POS '"MUIV_List_Insert_Bottom"' STRING =%s""" PORT DOCK ATTRS MUIA_String_MaxLen 160 HELP """Enter a MUIRexx command."""
     button COMMAND """list ID LLST POS "MUIV_List_GetEntry_Active" STRING""" PORT DOCK ATTRS MUIA_Weight 0 HELP """Delete selected command from list.""" LABEL "Del"
    endgroup
   endgroup
   group ID IGRP
    list ID ILST,
        ATTRS MUIA_Listview_DragType MUIV_Listview_DragType_Immediate,
              MUIA_List_DragSortable TRUE,
              MUIA_Dropable TRUE,
        COMMAND """string ID ISTR CONTENT %s""" PORT DOCK,
        HELP """Double click entry to edit."""
    group HORIZ
     string ID ISTR COMMAND """list ID ILST INSERT POS '"MUIV_List_Insert_Bottom"' STRING =%s""" PORT DOCK ATTRS MUIA_String_MaxLen 160 HELP """Enter a MUIRexx command."""
     button COMMAND """list ID ILST POS "MUIV_List_GetEntry_Active" STRING""" PORT DOCK ATTRS MUIA_Weight 0 HELP """Delete selected command from list.""" LABEL "Del"
    endgroup
   endgroup
  endgroup
 endgroup
 group HORIZ
  button ID BADD HELP """Add the icon to the end of\nthe dock.""" PORT INLINE COMMAND """
    options results;
    address dock;
    getvar EDIT;
    m = result;
    getvar 'D'||m;
    n = result+1;
    setvar 'D'||m n;
    call dock_set m n;
    call dock_save m;
    getvar 'N'||m;
    call dock result m;
    call dock_mode m 0 0;
    setvar ITEM n;""" LABEL "add"
  button ID BDEL HELP """Delete this icon from the dock.""" PORT INLINE COMMAND """
    options results;
    address dock;
    getvar ITEM;
    n = result;
    if n ~= 0 then do;
    getvar EDIT;
    m = result;
    setvar 'B'||m||n '';
    call dock_save m;
    getvar 'N'||m;
    call dock result m;
    call dock_mode m 0 0;
    setvar ITEM 0;
    end;""" LABEL "delete"
 endgroup
endwindow
callhook ID BICON APP COMMAND """dock_change "m" 0 OBJ 0 %s"""
callhook ID BICON DROP COMMAND """dock_change "m" 0 OBJ %s""" EXCLUDE "00"
group ID G00 ATTRS MUIA_Dropable FALSE
callhook ID ILST INCLUDE "ILST"
callhook ID PCOMM APP DROP INCLUDE "DIR1,DIR2" PORT INLINE COMMAND """
    address dock;
    comm = '%s';
    port = '';
    if index(comm,'.rexx') ~= 0 then comm = substr(comm,1,index(comm,'.rexx')-1);
    else port = 'COMMAND';
    popasl ID PCOMM CONTENT comm;
    string ID PPORT CONTENT port;"""
callhook ID ACOMM APP DROP INCLUDE "DIR1,DIR2" PORT INLINE COMMAND """
    address dock;
    comm = '%s';
    port = '';
    if index(comm,'.rexx') ~= 0 then comm = substr(comm,1,index(comm,'.rexx')-1);
    else port = 'COMMAND';
    popasl ID ACOMM CONTENT comm;
    string ID APORT CONTENT port;"""
callhook ID DCOMM APP DROP INCLUDE "DIR1,DIR2" PORT INLINE COMMAND """
    address dock;
    comm = '%s';
    port = '';
    if index(comm,'.rexx') ~= 0 then comm = substr(comm,1,index(comm,'.rexx')-1);
    else port = 'COMMAND';
    popasl ID DCOMM CONTENT comm;
    string ID DPORT CONTENT port;"""
callhook ID LLST APP DROP INCLUDE "LLST,DIR1,DIR2" PORT INLINE COMMAND """
    address dock;
    comm = '%s';
    if lastpos('/',comm) ~= 0 then lab = substr(comm,lastpos('/',comm)+1);
    else lab = substr(comm,lastpos(':',comm)+1);
    if index(comm,'.rexx') ~= 0 then comm = ''''substr(comm,1,index(comm,'.rexx')-1)'''';
    else comm = ''''comm''' PORT COMMAND';
    list ID LLST INSERT POS '-3' STRING 'button COMMAND 'comm' LABEL '''lab'''';"""
