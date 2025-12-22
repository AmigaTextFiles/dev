/* Application created by MUIBuild */

address DIRUTIL

MUIM_Notify = 0x8042c9cb
MUIM_Set = 0x8042549a
MUIA_Background = 0x8042545b
MUIA_Group_Columns = 0x8042f416
MUIA_List_Active = 0x8042391c
MUIV_EveryTime = 0x49893131
MUII_FILL = 131
MUII_TextBack = 4

window ID WDIR COMMAND """quit""" PORT DIRUTIL TITLE """Directory Utility"""
 text
 group HORIZ
  group REGISTER LABELS "Directory,Buffers,Volumes"
   group
    text ID TXT1
    dirlist ID DIR1 PATH "RAM:"
    string ID STR1
   endgroup
   group
    list
   endgroup
   group
    volumelist
   endgroup
  endgroup
  group REGISTER LABELS "Directory,Buffers,Volumes"
   group
    text ID TXT2
    dirlist ID DIR2 PATH "RAM:"
    string ID STR2
   endgroup
   group
    list
   endgroup
   group
    volumelist
   endgroup
  endgroup
 endgroup
 group HORIZ
  button COMMAND """dirlist ID DIR1 PATH df0:""" PORT DIRUTIL LABEL "DF0"
  button COMMAND """dirlist ID DIR1 PATH ram:""" PORT DIRUTIL LABEL "RAM"
  button COMMAND """dirlist ID DIR1 PATH system:""" PORT DIRUTIL LABEL "SYS"
  button COMMAND """dirlist ID DIR1 PATH programs:""" PORT DIRUTIL LABEL "PRG"
  button COMMAND """dirlist ID DIR1 PATH archives:""" PORT DIRUTIL LABEL "ARC"
  button COMMAND """dirlist ID DIR1 PATH apps:""" PORT DIRUTIL LABEL "APP"
  button COMMAND """dirlist ID DIR1 PATH tools:""" PORT DIRUTIL LABEL "TLS"
  button COMMAND """dirlist ID DIR1 PATH data:""" PORT DIRUTIL LABEL "DAT"
  button COMMAND """dirlist ID DIR2 PATH df0:""" PORT DIRUTIL LABEL "DF0"
  button COMMAND """dirlist ID DIR2 PATH ram:""" PORT DIRUTIL LABEL "RAM"
  button COMMAND """dirlist ID DIR2 PATH system:""" PORT DIRUTIL LABEL "SYS"
  button COMMAND """dirlist ID DIR2 PATH programs:""" PORT DIRUTIL LABEL "PRG"
  button COMMAND """dirlist ID DIR2 PATH archives:""" PORT DIRUTIL LABEL "ARC"
  button COMMAND """dirlist ID DIR2 PATH apps:""" PORT DIRUTIL LABEL "APP"
  button COMMAND """dirlist ID DIR2 PATH tools:""" PORT DIRUTIL LABEL "TLS"
  button COMMAND """dirlist ID DIR2 PATH data:""" PORT DIRUTIL LABEL "DAT"
 endgroup
 group ATTRS MUIA_Group_Columns 8
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
  button
 endgroup
endwindow
method ID DIR1 MUIM_Notify MUIA_List_Active MUIV_EveryTime @TXT1 3 MUIM_Set MUIA_Background MUII_FILL
method ID DIR1 MUIM_Notify MUIA_List_Active MUIV_EveryTime @TXT2 3 MUIM_Set MUIA_Background MUII_TextBack
method ID DIR2 MUIM_Notify MUIA_List_Active MUIV_EveryTime @TXT2 3 MUIM_Set MUIA_Background MUII_FILL
method ID DIR2 MUIM_Notify MUIA_List_Active MUIV_EveryTime @TXT1 3 MUIM_Set MUIA_Background MUII_TextBack
callhook ID DIR1 COMMAND """string ID STR1 CONTENT %s""" PORT DIRUTIL ATTRS MUIA_List_Active MUIV_EveryTime
callhook ID DIR2 COMMAND """string ID STR2 CONTENT %s""" PORT DIRUTIL ATTRS MUIA_List_Active MUIV_EveryTime
