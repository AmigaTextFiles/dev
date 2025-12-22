/* Application created by MUIBuild */

address ShowHide

MUIA_Background = 0x8042545b
MUII_WindowBack = 0
MUIA_ShowMe = 0x80429ba8
FALSE = 0
MUIA_Selected = 0x8042654b
TRUE = 1

window COMMAND """quit""" PORT ShowHide TITLE """ShowHide"""
 group FRAME ATTRS MUIA_Background ""MUII_WindowBack""
  group HORIZ
   check COMMAND """button ID BUT1 ATTRS "MUIA_ShowMe" %s""" PORT ShowHide ATTRS MUIA_Selected TRUE
   check COMMAND """button ID BUT2 ATTRS "MUIA_ShowMe" %s""" PORT ShowHide ATTRS MUIA_Selected TRUE
   check COMMAND """button ID BUT3 ATTRS "MUIA_ShowMe" %s""" PORT ShowHide
   check COMMAND """button ID BUT4 ATTRS "MUIA_ShowMe" %s""" PORT ShowHide ATTRS MUIA_Selected TRUE
   check COMMAND """button ID BUT5 ATTRS "MUIA_ShowMe" %s""" PORT ShowHide ATTRS MUIA_Selected TRUE
  endgroup
  button ID BUT1 LABEL "Button 1"
  button ID BUT2 LABEL "Button 2"
  button ID BUT3 ATTRS MUIA_ShowMe FALSE LABEL "Button 3"
  button ID BUT4 LABEL "Button 4"
  button ID BUT5 LABEL "Button 5"
  space
 endgroup
endwindow
