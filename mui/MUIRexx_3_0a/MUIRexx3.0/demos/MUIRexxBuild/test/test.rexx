/* Application created by MUIBuild */

address TEST


window COMMAND """quit""" PORT TEST TITLE """A Test"""
 menu LABEL "Project"
  item COMMAND "quit" PORT TEST LABEL "Quit"
 endmenu
 group HORIZ
  group
   label DOUBLE """Label 1:"""
   label DOUBLE """Label 2:"""
  endgroup
  group
   string
   string
  endgroup
 endgroup
 group HORIZ
  space HORIZ
  button ICON "MUIREXX:demos/icons/paint"
  space HORIZ
 endgroup
 space
endwindow
