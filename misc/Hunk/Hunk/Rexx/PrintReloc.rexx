/*  Print the complete relocation table with "Hunk". © 1996 THOR */

IF OPEN(Printer, 'PRT:', 'W') THEN DO
   CALL WRITELN(Printer, 'List of reloc entries')
   CALL WRITELN(Printer, '')
   EDITHUNK
   DELOCATE
   EDITRELOC 0
   RELOC 'CNT'
   SAY CNT.COUNT 'reloc entries'
   LAST=0
   X=0
   EDITENTRY 0
   DO i=0 TO CNT.COUNT-1
      ENTRY 0 0 i 'HERE'
      CALL WRITECH(Printer,INSERT('0x' || D2X(HERE.OFFSET),'',1,8,' ') INSERT('>0x' || D2X(HERE.OFFSET-LAST),'',1,7,' '))
      X=X+1
      IF X=4 THEN DO
         X=0
         CALL WRITELN(Printer,'')
      END
      LAST=HERE.OFFSET
   END
END


