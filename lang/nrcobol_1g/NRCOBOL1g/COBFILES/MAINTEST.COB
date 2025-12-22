       IDENTIFICATION DIVISION.
       PROGRAM-ID.   MAINTEST.
      *AUTHOR.       cHArRiOTt.
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SOURCE-COMPUTER.   AMSTRAD 1512.
       OBJECT-COMPUTER.
       SPECIAL-names.
           CURRENCY IS "£".

      *
       DATA DIVISION.
       FILE SECTION.
      *
       WORKING-STORAGE SECTION.
       01 WS-TEST PIC X(10) VALUE SPACES.
       01 WORKING-DATA.
           03 WS-BLOCK-DATA PIC X(40) VALUE
              "123456789012345678901234EFGH901234567890".
      *        1   2   3   4   5   1   2   3   4   5
       01 WORKING-TABLE REDEFINES WORKING-DATA.
           03 WS-OUTER OCCURS 2 TIMES.
              05 WS-TABLE-DATA PIC X(4) OCCURS 5 TIMES.

       01 ws-search-table redefines working-data.
           03 ws-search occurs 20 times 
                        descending key is ws-text indexed by index-temp.
              05 ws-text pic xx.
       01 ws-number      pic 9(5) value 1.
      * SIGN TRAILING
       01 WS-TEST1 PIC S9(8)V999  SIGN TRAILING VALUE +8.54.
       01 WS-TEST2 PIC S9(8)V999 VALUE +94.33.
       01 WS-TEST3 PIC S9(8)V999  SIGN LEADING VALUE -24.85.
       01 WS-TEST4 PIC 9999      VALUE 00.
       01 WS-TEST5 PIC S9(6)V999 VALUE 2.
       01 WS-TEST6 PIC £(6).999+ .
       01 WS-TEST6a PIC £(6)+ .
       01 WS-TEST7 PIC S9(6)     VALUE 2.
       01 WS-TEMP-DATA PIC X(40) VALUE
             "1 2 3 4 5 6 7 8 9 1011121314151617181920".
       01 WS-TEST8 PIC X(14).
       01 WS-TIME.
           03 WS-HRS PIC 9(2) VALUE 00.
           03 WS-MIN PIC 9(2) VALUE 00.
           03 WS-SEC PIC 9(2) VALUE 00.
           03 WS-MIC PIC 9(2) VALUE 00.
      * 01 WS-TIME REDEFINES WS-TIME0 PIC 9(8).

       01 WS-TIME2.
           03 WS-HRS2 PIC 9(2) VALUE 00.
           03 WS-MIN2 PIC 9(2) VALUE 00.
           03 WS-SEC2 PIC 9(2) VALUE 00.
      * 01 WS-TIME2 REDEFINES WS-TIME1 PIC 9(6). 

       01 WS-PAGE-COUNTER  PIC 9(8)V9999999999   VALUE 00.
       01 WS-PAGE-COUNTER2 PIC +(7)9.9999999999 .
       01 WS-TESTJUMP      PIC 9.
       01 WS-FIND          PIC XXX VALUE "456".
       01 WS-JUSTTEST.
           03 JL PIC X(5).
           03 JR PIC X(5) JUST RIGHT.


       01 WS-STRINGTEST.
           03 WS-STRING1 PIC X(12).
           03 WS-STRING2 PIC X(12).
           03 WS-STRING3 PIC X(12).
           03 WS-STRING4 PIC X(12).

       01 WS-TEST-DIS.
           03 NUMBER1 PIC 99 VALUE 14.
           03 NUMBER2 PIC 99 VALUE 28.
       01 ws-long-string pic x(120) value  "1 2 3 4 5 6 7 8 9 1011121314
      -    "1516171819201 2 3 4 5 6 7 8 9 10111213141516171819201 2 3  5
      -    " 6 7 8 9 1011121314151617181920".
      *
       SCREEN SECTION.
       01 BLANK-SCREEN.
           03 BLANK SCREEN.
       01 PROG-DISCRIPTION.
           03 LINE 2 COLUMN 20  VALUE
              "SHORT PROGRAM TO TEST DISPLAY FUNCTION  ".
           03 LINE 2 COLUMN 60 PIC 99I:99I:99 FROM WS-TIME2.
       01 SET-COLOURS.
           03 FOREGROUND-COLOR 4 BACKGROUND-COLOR 0.
      *
       PROCEDURE DIVISION.
      *
       0000-MAIN.
           DISPLAY SET-COLOURS.
           ACCEPT WS-TIME FROM TIME.
           MOVE WS-HRS TO WS-HRS2.
           MOVE WS-MIN TO WS-MIN2.
           MOVE WS-SEC TO WS-SEC2.

           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.
           DISPLAY (4  1)  "ENTER VALUE FOR WS-TABLE-BLOCK 40 MAX :"
           ACCEPT  (4  39) WS-BLOCK-DATA.
      *
      *     
           INSPECT WS-BLOCK-DATA 
                   TALLYING WS-TEST4 FOR ALL "456"  ALL "789"
                            WS-TEST4 FOR ALL "789"
                   REPLACING ALL "456" BY "ACE" AFTER INITIAL "8"
                             ALL "901" BY "WOW"
                             ALL LOW-VALUES BY SPACE.

           DISPLAY (5  5)  "THE VALUE OF WS-TABLE-BLOCK :".
           DISPLAY (6 10) "'" WS-BLOCK-DATA "'".
           DISPLAY (7 10) "'" WS-TEMP-DATA "'".
      *    DISPLAY (8 5)  "NUMBER OF '456' FOUND IN WS-BLOCK-DATA IS "
      *                    WS-TEST4.

           DISPLAY (9  5)  "THE VALUE OF WS-TABLE-DATA :".
           DISPLAY (11 24) "(1 3) = " WS-TABLE-DATA (1 3).
           DISPLAY (12 24) "(2 3) = " WS-TABLE-DATA (2 3).
           DISPLAY (13 24) "(1 5) = " WS-TABLE-DATA (1 5).
           DISPLAY (14 24) "(1 4) = " WS-TABLE-DATA (1 4).

           DISPLAY (15 5) "ENTER JUMP CODE 1 - 3 : " NO ADVANCING.
           ACCEPT  WS-TESTJUMP.

           IF (WS-TABLE-DATA (1 3) IS NUMERIC)
              COMPUTE WS-PAGE-COUNTER = 6 * (7 + 2 / (4 ** 3))
              MOVE WS-PAGE-COUNTER TO WS-PAGE-COUNTER2
              DISPLAY (15 5)
                   "TESTING COMPUTE: 6 * (7 + 2 / (4 ** 3)) = "
                   WS-PAGE-COUNTER2
      *       compute ws-page-counter = 22 / 7
              DIVIDE 22 BY 7 GIVING ws-page-counter rounded
              move ws-page-counter to ws-page-counter2
              display (18 5)
                   "TESTING DIVIDE FUNCTION : 22 / 7 = "
                   WS-PAGE-COUNTER2
              compute ws-page-counter = 457985 / 7
              move ws-page-counter to ws-page-counter2
      *        move ws-page-counter2 to ws-page-counter
              display (17 5)
                   "TESTING DIVIDE FUNCTION : 457985 / 7 = "
                   WS-PAGE-COUNTER2

              set index-temp to 1
              search all ws-search 
                   at end display (20 5) "ending search test!"
                   when ws-text (index-temp) = "22"
                        set ws-number to index-temp
                        display (21 5) "search found 22 at " ws-number
              end-search
      *       display (20 47) "test too long string : " ws-long-string
              move ws-test2 to WS-PAGE-COUNTER2
              display (22 10) "leading sign ok?  " WS-PAGE-COUNTER2
      *       move ws-test2 to ws-test3
              move ws-test3 to ws-test8
              move ws-test3 to WS-PAGE-COUNTER2
              display (23 10) "trailing sign ok? " ws-test8
           ELSE
              EVALUATE WS-TESTJUMP
                 WHEN  1          GO TO 200-DISPLAY-EXIT
                 WHEN  2          GO TO 300-DISPLAY-EXIT
                 WHEN  3  THRU 6  GO TO 400-DISPLAY-EXIT
                 WHEN OTHER GO TO 500-DISPLAY-EXIT.

       100-EXIT.               
           STOP RUN.

       200-DISPLAY-EXIT.
           DISPLAY (16 5)
              "TEST DATA JUMP 1".
           CALL "TEST1" .
           CALL "TEST2" USING CONTENT NUMBER1 CONTENT NUMBER2.
      *    CALL "TEST2" USING CONTENT NUMBER1 REFERENCE NUMBER2.
           DISPLAY "TEST CALL 2: 14 + 28 = " NUMBER2.

           GO TO 100-EXIT.

       300-DISPLAY-EXIT.
           DISPLAY (16 5) 
              "TEST DATA JUMP 2".
           GO TO 100-EXIT.

       400-DISPLAY-EXIT.
           DISPLAY (16 5) 
              "TEST DATA JUMP 3".
           GO TO 100-EXIT.

       500-DISPLAY-EXIT.
           DISPLAY (16 5)
              "TEST DATA JUMP 4: DATA SHOULD BE IN RANGE 1-3".
           MOVE 6 TO WS-TEST4.
           MOVE "THREE FOUR  "  TO WS-STRING1.
           MOVE "FIVE SIX    "  TO WS-STRING2.
           MOVE "SEVEN EIGHT "  TO WS-STRING3.
           MOVE "NINE TEN.   "  TO WS-STRING4.

           STRING " ONE TWO " DELIMITED BY SIZE
                  WS-STRING1  "," WS-STRING2 DELIMITED BY SPACE
                  "," WS-STRING3 "END" DELIMITED BY "."
                 INTO WS-BLOCK-DATA POINTER WS-TEST4
                 OVERFLOW DISPLAY "WARNING WS-BLOCK-DATA OVERFLOW!!".

           DISPLAY (18 5) "TEST USING " " ONE TWO " WS-STRING1 
                 "," WS-STRING2 "," WS-STRING3.

           DISPLAY (19 5) "STRING TEST :" WS-BLOCK-DATA.

      * had test here for UNSTRING function later....

           MOVE 6 TO WS-TEST4.
           UNSTRING WS-BLOCK-DATA 
               INTO WS-STRING1 WS-STRING2 WS-STRING3 WS-STRING4  
               POINTER WS-TEST4
               OVERFLOW DISPLAY "WARNING WS-BLOCK-DATA OVERFLOW!!".

           DISPLAY (20 5) "'" WS-BLOCK-DATA "'". 
           DISPLAY (21 5) "WS-BLOCK-DATA UNSTRINGS TO FORM ...".
           DISPLAY (22 5) "'" WS-STRING1 "' , '" WS-STRING2 "' , '" 
                          WS-STRING3 "' , '" WS-STRING4 "'.".

           MOVE "JIM" TO JL JR.
           DISPLAY (23 5) "JUSTIFICATION TEST :USING 'JIM' > " 
                          "'" JL "','" JR "'".
           MOVE "WINTERBOTTOM" TO JL JR.
           DISPLAY (24 5) "JUSTIFICATION TEST :USING 'WINTERBOTTOM' > " 
                          "'" JL "','" JR "'".

           GO TO 100-EXIT.

           DISPLAY "CRAP TEST...FUCKING DOPE FUMES!!".
           DISPLAY "CRAP TEST...FUCKING GAS  FUMES!!".
      **************************************************************
