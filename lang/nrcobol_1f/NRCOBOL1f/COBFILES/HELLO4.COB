      * ROUTINE TO DISPLAY A MULTIPLICATION GRID.
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  HELLO4.
       AUTHOR. cHArRiOTt.
      * 
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Y-ROW           PIC 99.
       01  X-COLUMN        PIC 99.
      
      *
      *  
       PROCEDURE DIVISION.
       001-MAIN.
           DISPLAY (1 , 10)
           "Routine to CALCULATE and DISPLAY a MULTIPLICATION TABLE".
            MOVE 1 TO Y-ROW
            perform  23 times
                DISPLAY "line : " Y-ROW
                add 1 to Y-ROW
            end-perform.
      *001-SOMETHING
           STOP RUN.

       001-SOMETHING.
           DISPLAY "line : " Y-ROW
           add 1 to Y-ROW
