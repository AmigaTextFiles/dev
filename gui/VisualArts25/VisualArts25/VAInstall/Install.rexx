/* Visual Arts installation */

address command
say "copying..."

'makedir libs:gadgets'
'copy VisualArts.h include:'
'copy PopUpMenuClass.h include:'
'copy gadgets/#? libs:gadgets'
'copy #?.lib lib:'
'copy #?.key S:'
'copy clib/#? include:clib'
'copy datatypes/#? include:datatypes'
'copy pragmas/#? include:pragmas'

say "done."
 
