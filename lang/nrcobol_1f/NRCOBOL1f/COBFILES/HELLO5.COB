      * ROUTINE TO DISPLAY A MULTIPLICATION GRID.                      
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  HELLO5.
       AUTHOR.  cHArRiOTt.
      * 
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  X-SCREEN-DFT    PIC 99 VALUE  10.
       01  Y-SCREEN-DFT    PIC 99 VALUE  5.
       01  Y-ROW           PIC 99.
       01  X-COLUMN        PIC 99.
       01  X-POS           PIC 99.
       01  Y-POS           PIC 99.
       01  XY-PRODUCT      PIC 9(3).
       78  CON-8    VALUE 606.
       78  CON-7    VALUE 66.

      *
      *  
       PROCEDURE DIVISION.
       001-MAIN.
           DISPLAY (1 , 10)
           "Routine to CALCULATE and DISPLAY a MULTIPLICATION TABLE".
           MOVE ZEROS TO Y-ROW.
           PERFORM 002-ROWS
               VARYING Y-ROW FROM 1 BY 1 UNTIL Y-ROW > 10.
           STOP RUN.
      *
      *
      $SET CONSTANT CON-9 con-8
      $if con-9  > 99
       002-ROWS.
           MOVE ZEROS TO X-COLUMN.
           PERFORM 003-COLUMNS
               VARYING X-COLUMN FROM 1 BY 1 UNTIL X-COLUMN > 10.
      $if con-7 defined
           display (22 , 30) "AOK!".
      $END-IF
      *
      $else
       002-ROWS.
           MOVE ZEROS TO X-COLUMN.
           PERFORM 003-COLUMNS
               VARYING X-COLUMN FROM 1 BY 1 UNTIL X-COLUMN > 5.
      $end
      *
      *
       003-COLUMNS.
           MOVE ZEROS TO X-POS.
           MULTIPLY X-COLUMN BY 5 GIVING  X-POS.
           ADD X-SCREEN-DFT TO X-POS.
      * 
           MOVE ZEROS TO Y-POS.
           MOVE Y-ROW TO Y-POS.
           ADD Y-SCREEN-DFT TO Y-POS.
      *
           MULTIPLY Y-ROW BY X-COLUMN 
                          GIVING    XY-PRODUCT.
           PERFORM 004-DISPLAY-PRODUCT.
      *     ADD 1 TO X-COLUMN.
      *
      *                                                                
       004-DISPLAY-PRODUCT.
           MOVE Y-POS  TO LIN.
           MOVE X-POS  TO COL.
           DISPLAY (LIN , COL) XY-PRODUCT.
      *
      *
      *****END*******************************************Š   
