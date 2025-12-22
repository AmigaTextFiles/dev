/* Dwindow.rexx - SAY EE window dimensions. */

ADDRESS 'EE.0'
OPTIONS RESULTS

LockWindow
?WindowDimensions; wd=RESULT

PARSE VALUE wd WITH leftedge topedge width height .

SAY "leftedge="leftedge
SAY "topedge ="topedge
SAY "width   ="width
SAY "height  ="height

UnlockWindow
