/* Dieses ist das Script-File für das erstellen der E-Arbeitsdiskette.
   © 1993 by Jörg Wach (JCL_POWER)
*/

PROC main()
    Execute(':c/copy MakeWorkDisk.imp TO ram:',0,0)
    WriteF('Bitte lege die LEERE Diskette in das Laufwerk DF0:\n')
    Execute(':c/cd ram:',0,0)
    Execute('ram:MakeWorkDisk.imp df0:',stdout,stdout)
    Execute(':c/delete ram:MakeWorkDisk.imp',0,0)
    WriteF('O.K., das wars. Bitte nochmals die <RETURN>-Taste drücken.')
ENDPROC
