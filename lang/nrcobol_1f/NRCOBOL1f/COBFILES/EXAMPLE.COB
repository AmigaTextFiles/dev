
      *ROUTINE TO DISPLAY A MULTIPLICATION GRID.
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  EXAMPLE.
       AUTHOR. C HARRIOTT.
      *
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  AMIGA A1200 WITH DEBUGGING MODE.
      *
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-X-SCREEN-DFT    PIC 99 VALUE  10.
       01  WS-Y-SCREEN-DFT    PIC 99 VALUE  05.
       01  WS-XY-PRODUCT      PIC 9(3).

       01  WS-COUNTERS.
           05  WS-Y-ROW           PIC 99.
           05  WS-X-COLUMN        PIC 99.
           05  WS-X-POS           PIC 99.
           05  WS-Y-POS           PIC 99.
       01  WS-BUTTON          PIC X(8) VALUE "PRESS ME".
      *
      *
       PROCEDURE DIVISION.
       001-MAIN.
           DISPLAY (1 , 10)
           "Routine to CALCULATE and DISPLAY a MULTIPLICATION TABLE".
           MOVE ZEROS TO WS-COUNTERS.
           PERFORM 002-ROWS
               VARYING WS-Y-ROW FROM 1 BY 1 UNTIL WS-Y-ROW > 10.
           STOP RUN.
      *
      *
       002-ROWS.
           MOVE ZEROS TO WS-X-COLUMN.
           PERFORM 003-COLUMNS
               VARYING WS-X-COLUMN FROM 1 BY 1 UNTIL WS-X-COLUMN > 10.
      *
      *
       003-COLUMNS.
           MOVE ZEROS TO WS-X-POS.
           MULTIPLY WS-X-COLUMN BY 5 GIVING WS-X-POS.
           ADD WS-X-SCREEN-DFT TO WS-X-POS.
      *
           MOVE ZEROS TO WS-Y-POS.
           MOVE WS-Y-ROW TO WS-Y-POS.
           ADD WS-Y-SCREEN-DFT TO WS-Y-POS.
      *
           MULTIPLY WS-Y-ROW BY WS-X-COLUMN
                          GIVING  WS-XY-PRODUCT.
           PERFORM 004-DISPLAY-PRODUCT.
      *
      *
       004-DISPLAY-PRODUCT.
      D    PERFORM 005-DEBUG.
           MOVE WS-Y-POS  TO LIN.
           MOVE WS-X-POS  TO COL.
           DISPLAY (LIN , COL) WS-XY-PRODUCT.
      *
      D005-DEBUG.
      D    DISPLAY (24 1) "Debug optioned:  X-POS = " WS-X-POS
      D      " , Y-POS = " WS-Y-POS.
      D    ACCEPT (24 50) WS-BUTTON FROM AMIGA-BUTTON.
      *****END*******************************************Š

