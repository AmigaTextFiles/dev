/*
** Name......: systemcheckTest.e
** Version...: 0.1
** Author....: Jørgen 'Da' Larsen (Posse Pro. DK)
**
** History...: Version 0.1
**              o First release
**
*/

MODULE '*systemcheck'

PROC main()
 DEF systemcheck:PTR TO systemcheck
 NEW systemcheck.new()
 PrintF('CPU...........: \d\n',systemcheck.getcpunumber())
 PrintF('FPU...........: \d\n',systemcheck.getfpunumber())
 PrintF('AGA Chip......: \s\n',IF systemcheck.checkaga()=TRUE THEN 'TRUE' ELSE 'FALSE')
 PrintF('VBlank freq...: \d Hz\n',systemcheck.getvblankfrequency())
 PrintF('Kickstart Ver.: \d\n',systemcheck.getkickstartversion())
 PrintF('Kickstart Rev.: \d\n',systemcheck.getkickstartrevision())
 END systemcheck
ENDPROC
