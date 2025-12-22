       IDENTIFICATION DIVISION.
       PROGRAM-ID.  INSURE.
      *PROGRAM DISCRIPTION.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.
       OBJECT-COMPUTER.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CLIENT-FILE ASSIGN TO DISK
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-FILE-STATUS.
      *
           SELECT CLIENT-PRINT ASSIGN TO PRINTER
           ORGANIZATION IS SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-PRINT-STATUS.
      *
       DATA DIVISION.
       FILE SECTION.
       FD CLIENT-FILE
           LABEL RECORDS STANDARD
           VALUE OF FILE-ID IS "CLIENT.DAT".
       01  IN-CLIENT-REC.
           03  ER-CLAIM-NUMBER          PIC 999V9(4).
           03  ER-CLASS-CODE            PIC 9(6).
           03  ER-REGION                PIC X(4).
           03  ER-PREV-CLAIMS           PIC 99.
           03  ER-PREV-CLAIMS-TOTAL     PIC 9(9).
           03  ER-AMOUNT-CLAIMED        PIC 9(7).
      *
       FD CLIENT-PRINT
           LABEL RECORDS OMITTED.
       01 OUT-CLIENT-REC.
           03 FILLER                     PIC A(80).
      *
       WORKING-STORAGE SECTION.
       01 WS-COUNTERS.
           03 WS-PAGE-COUNT      PIC 99 VALUE 00.
           03 WS-LINE-COUNT      PIC 99 VALUE 00.
           03 WS-CLAIMS-TOTAL        PIC 9(9).
           03 WS-CLAIMS-NUM-TOTAL    PIC 999.
           03 WS-AVERAGE-CLAIM       PIC 9(7).
       01 WS-STOP-RUN-FLAG       PIC X  VALUE " ".
       01 WS-END-FILE-FLAG       PIC X  VALUE " ".
       01 WS-FILE-STATUS         PIC XX VALUE "00".
       01 WS-PRINT-STATUS        PIC XX VALUE "00".
      *
       01 WS-TITLE-1.
           03 FILLER  PIC X(22)  VALUE "ASSIGNMENT    10/08/89".
           03 FILLER  PIC X(5)   VALUE SPACES.
           03 FILLER  PIC X(26)  VALUE "FAIL SAFE INSURANCE AGENCY".
           03 FILLER  PIC X(5)   VALUE SPACES.
           03 WS-TITLE-DATE      PIC X(8).
           03 FILLER             PIC X(7).
           03 FILLER             PIC X(5)   VALUE "PAGE ".
           03 WS-TITLE-PAGE-NO   PIC 99.
       01 WS-TITLE-3.
           03 FILLER  PIC X(29)  VALUE SPACES.
           03 FILLER  PIC X(22)  VALUE "INSURANCE CLAIM REPORT".
       01 WS-HEADER-4.
           03 FILLER  PIC X(12)  VALUE "CLAIM NUMBER".
           03 FILLER  PIC X(12)  VALUE SPACES.
           03 FILLER  PIC X(6)   VALUE "REGION".
           03 FILLER  PIC X(12)  VALUE SPACES.
           03 FILLER  PIC X(13)  VALUE "TOTAL CLAIMED".
           03 FILLER  PIC X(10)  VALUE SPACES.
           03 FILLER  PIC X(15)  VALUE "AMOUNT OF CLAIM".
       01 WS-HEADER-5.
           03 FILLER  PIC X(13)  VALUE SPACES.
           03 FILLER  PIC X(10)  VALUE "CLASS CODE".
           03 FILLER  PIC X(6)   VALUE SPACES.
           03 FILLER  PIC X(15)  VALUE "PREVIOUS CLAIMS".
           03 FILLER  PIC X(8)   VALUE SPACES.
           03 FILLER  PIC X(16)  VALUE "AVERAGED CLAIMED".
       01 WS-INSURENCE-REC.
           03 FILLER             PIC X(3)   VALUE SPACES.
           03 FLD-CLAIM-NUMBER   PIC 999V9(4).
           03 FILLER             PIC X(5)   VALUE SPACES.
           03 FLD-CLASS-CODE     PIC X(6).
           03 FILLER             PIC X(4)   VALUE SPACES.
           03 FLD-REGION         PIC X(6).
           03 FILLER             PIC X(6)   VALUE SPACES.
           03 FLD-PREV-CLAIMS    PIC Z9.
           03 FILLER             PIC X(5)   VALUE SPACES.
           03 FLD-PREV-CLAIMS-TOTAL  PIC Z(8)9.
           03 FILLER             PIC X(5)   VALUE SPACES.
           03 FLD-AVG-CLAIMED    PIC Z(6)9.
           03 FILLER             PIC X(5)   VALUE SPACES.
           03 FLD-AMOUNT-CLAIMED PIC Z(8)9.
      *
       01 WS-TOTALS-1.
           03 FILLER             PIC X(35)  VALUE SPACES.
           03 FILLER             PIC X(22)  VALUE
                         "CURRENT TOTAL CLAIMS :".
           03 TOTALS-CURR-CLAIMS PIC ZZZ,ZZZ,ZZ9.
       01 WS-TOTALS-2.
           03 FILLER             PIC X(35)  VALUE SPACES.
           03 FILLER             PIC X(22)  VALUE
                         "NUMBER OF CLAIMS     :".
           03 TOTALS-MAX-CLAIMS  PIC ZZ9.
       01 WS-TOTALS-3.
           03 FILLER             PIC X(35)  VALUE SPACES.
           03 FILLER             PIC X(22)  VALUE
                         "AVERAGE CLAIM        :".
           03 TOTALS-AVG-CLAIMS  PIC Z,ZZZ,ZZ9.


       01 WS-REAL-DATE.
           03 WS-REAL-YEAR       PIC XX.
           03 WS-REAL-MONTH      PIC XX.
           03 WS-REAL-DAY        PIC XX.
       01 WS-TEMP-DATE.
           03 WS-TEMP-DAY        PIC XX.
           03 FILLER             PIC X    VALUE  "/".
           03 WS-TEMP-MONTH      PIC XX.
           03 FILLER             PIC X    VALUE  "/".
           03 WS-TEMP-YEAR       PIC XX.
       01 WS-CLIENT-REC.
           03  WS-CLAIM-NUMBER          PIC 999V9(4).
           03  WS-CLASS-CODE            PIC 9(6).
           03  WS-REGION                PIC X(4).
           03  WS-PREV-CLAIMS           PIC 99.
           03  WS-PREV-CLAIMS-TOTAL     PIC 9(9).
           03  WS-AMOUNT-CLAIMED        PIC 9(7).
      *
       01 WS-RESPONCE            PIC X.
           88 WS-RESPONCE-S             VALUE "S" "s".
           88 WS-RESPONCE-P             VALUE "P" "p".
           88 WS-RESPONCE-Q             VALUE "Q" "q".
      *
       SCREEN SECTION.
       01 BLANK-SCREEN.
           03 BLANK SCREEN.
       01 BLANK-LINE.
           03 BLANK LINE.
       01 PROG-DISCRIPTION.
       01 PRINTING-DOC-MESSG.
           03 LINE 3 COLUMN 8        VALUE   "PAGE ".
           03 LINE 3 COLUMN 13       PIC 99   FROM  WS-PAGE-COUNT.
           03 LINE 3 COLUMN 15       VALUE
                   " OF RECORD IS NOW BEING PRINTED".
       01 PROG-FINISH.
           03 LINE 24 COLUMN 8       VALUE
                   "TASK COMPLETE".
       01 MENU.
           03 LINE 10 COLUMN 30   VALUE "MENU".
           03 LINE 11 COLUMN 30   VALUE "----".
           03 LINE 15 COLUMN 19   VALUE "PRESS 'P' to list to PRINTER".
           03 LINE 17 COLUMN 19   VALUE "      'S' to list to SCREEN ".
           03 LINE 19 COLUMN 19   VALUE "      'Q' to quit    MENU   ".
       01 RESPONCE-LINE.
           03 LINE 22 COLUMN 19   PIC X
             TO WS-RESPONCE AUTO.
      *
       01 DIS-TITLE.
           03 LINE 1 COLUMN 1    VALUE "ASSIGNMENT    10/08/89".
           03 LINE 1 COLUMN 28   VALUE "FAIL SAFE INSURANCE AGENCY".
           03 LINE 1 COLUMN 58   PIC X(8)  FROM WS-TEMP-DATE.

           03 LINE 1 COLUMN 71   VALUE "PAGE ".
           03 LINE 1 COLUMN 76   PIC 99 FROM WS-PAGE-COUNT.
           03 LINE 3 COLUMN 30   HIGHLIGHT  VALUE
              "INSURANCE CLAIM REPORT".
       01 DIS-HEADER.
           03 LINE 5 COLUMN 1    VALUE "CLAIM NUMBER".
           03 LINE 6 COLUMN 14   VALUE "CLASS CODE".
           03 LINE 5 COLUMN 24   VALUE "REGION".
           03 LINE 6 COLUMN 31   VALUE "PREVIOUS CLAIMES".
           03 LINE 5 COLUMN 42   VALUE "TOTAL CLAIMED".
           03 LINE 6 COLUMN 55   VALUE "AVERAGED CLAIMED".
           03 LINE 5 COLUMN 66   VALUE "AMOUNT OF CLAIM".
       01 NEW-PAGE.
           03 LINE 25 COLUMN 3   VALUE "PRESS ANY KEY FOR NEXT PAGE".
       01 ANY-KEY.
           03 LINE 25 COLUMN 31  PIC X TO WS-RESPONCE AUTO.
     *
       01 ERROR-MESSAGES.
           03 LINE 21 COLUMN 8   VALUE "FILE WOULD NOT OPEN :".
           03 LINE 22 COLUMN 8   VALUE "STATUS ERROR CODE   :".
           03 LINE 22 COLUMN 29  HIGHLIGHT PIC XX
              FROM WS-FILE-STATUS.
           03 LINE 23 COLUMN 8   VALUE "STATUS ERROR CODE   :".
           03 LINE 23 COLUMN 29  HIGHLIGHT PIC XX
              FROM WS-PRINT-STATUS.
      *
       PROCEDURE DIVISION.
      *
      *********************************************************
      *  Paragraph to open CLIENT-FILE for import and CLIENT-PRINT
      * for export.Should the either file's status be in error,
      * the files are closed and an error message printed along
      * with the status value, Other wise 1000-DISPLAY is called.
      *
       0000-MAIN.
           OPEN INPUT  CLIENT-FILE.
      *     OPEN OUTPUT CLIENT-PRINT.
                IF WS-FILE-STATUS = "00" AND WS-PRINT-STATUS = "00"
                   PERFORM 1000-DISPLAY
                ELSE
                   DISPLAY ERROR-MESSAGES.
           CLOSE CLIENT-FILE.
           CLOSE CLIENT-PRINT.
           STOP RUN.
      *
      *******************************************************
      *  This Paragraph displays the program's title and then
      * calls 1100-MENU. When done the paragraph displays a
      * finished message.
      *
       1000-DISPLAY.
           DISPLAY PROG-DISCRIPTION.
           ACCEPT WS-REAL-DATE FROM DATE.
           MOVE WS-REAL-DAY   TO WS-TEMP-DAY.
           MOVE WS-REAL-MONTH TO WS-TEMP-MONTH.
           MOVE WS-REAL-YEAR  TO WS-TEMP-YEAR.
           PERFORM 1100-MENU
                      UNTIL WS-STOP-RUN-FLAG = "S".
           DISPLAY PROG-FINISH.
      *
      *******************************************************
      *  This paragraph provides the user with an option on how
      * to continue.
      *  Expected responce to MENU ;Q TO          QUIT
      *                             S TO LIST TO 'SCREEN'
      *                             P TO LIST TO 'PRINTER'
      *
       1100-MENU.
           MOVE ZERO TO WS-COUNTERS.
           MOVE " " TO WS-END-FILE-FLAG.
           DISPLAY BLANK-SCREEN.
           DISPLAY MENU.
           ACCEPT RESPONCE-LINE.
           IF WS-RESPONCE-Q
                 MOVE "S" TO WS-STOP-RUN-FLAG
              ELSE
              IF WS-RESPONCE-P
                          PERFORM 1200-PRINT-RECORD
                                       UNTIL WS-END-FILE-FLAG = "S"
                   ELSE
                   IF WS-RESPONCE-S
                             PERFORM 1300-LIST-RECORD
                                          UNTIL WS-END-FILE-FLAG = "S".
           CLOSE CLIENT-FILE.
           OPEN INPUT CLIENT-FILE.
      *
      *
      ******************************************************
      *  This paragraph initialise the programme's main variables,
      * sends to the printer the comands for a  new page then the
      * document's title and page number (1210-PRINT-TITLE), then
      * prints the file,s contents until the line  count is greater
      * than 55 (assumed page length).If WS-END-FILE-FLAG is not "S"
      * then this paragraph continues to be executed.
      *  While the contents of "CLIENT-FILE" is being printed
      * a message is displayed on the screen stating that the
      * printer is in operation.

       1200-PRINT-RECORD.
           ADD  1 TO WS-PAGE-COUNT.
           DISPLAY PRINTING-DOC-MESSG.
           PERFORM 1210-PRINT-TITLE.
           PERFORM 1220-READ-PRINT-FILE
                           UNTIL WS-LINE-COUNT IS GREATER 55.
           IF WS-END-FILE-FLAG = "S"
                PERFORM 1230-PRINT-TOTALS.
      *
      ****************************************************
      *  This paragraph prints the the document's title along with
      * the current page number and the file's column headings.
      *
       1210-PRINT-TITLE.

           MOVE WS-TEMP-DATE TO WS-TITLE-DATE.
           MOVE WS-PAGE-COUNT TO WS-TITLE-PAGE-NO.
           MOVE   SPACES    TO OUT-CLIENT-REC.
           MOVE WS-TITLE-1  TO OUT-CLIENT-REC.
           WRITE OUT-CLIENT-REC AFTER PAGE.

           MOVE   SPACES    TO OUT-CLIENT-REC.
           MOVE WS-TITLE-3  TO OUT-CLIENT-REC.
           WRITE OUT-CLIENT-REC AFTER 2.

           MOVE   SPACES    TO OUT-CLIENT-REC.
           MOVE WS-HEADER-4 TO OUT-CLIENT-REC.
           WRITE OUT-CLIENT-REC  AFTER 3.

           MOVE   SPACES    TO OUT-CLIENT-REC.
           MOVE WS-HEADER-5 TO OUT-CLIENT-REC.
           WRITE OUT-CLIENT-REC  AFTER 1.
           MOVE 09 TO WS-LINE-COUNT.
      *
      ***********************************************
      *  This paragrph reads and send to the printer the contents of
      * CLIENT-FILE until the  end is reached ,at which point
      * WS-END-FILE-FLAG is made equal to "S" and the line count is
      * forced to 56 to terminate the perform until loop in 1200-PRINT
      * -RECORD.
      *
       1220-READ-PRINT-FILE.

           READ CLIENT-FILE AT END MOVE "S" TO WS-END-FILE-FLAG.
           IF WS-END-FILE-FLAG NOT EQUAL "S"
                 MOVE IN-CLIENT-REC TO WS-CLIENT-REC

                 MOVE SPACES TO OUT-CLIENT-REC
                 MOVE WS-CLAIM-NUMBER      TO FLD-CLAIM-NUMBER
                 MOVE WS-CLASS-CODE        TO FLD-CLASS-CODE
                 MOVE WS-REGION            TO FLD-REGION
                 MOVE WS-PREV-CLAIMS       TO FLD-PREV-CLAIMS
                 MOVE WS-PREV-CLAIMS-TOTAL TO FLD-PREV-CLAIMS-TOTAL
                 MOVE WS-AMOUNT-CLAIMED    TO FLD-AMOUNT-CLAIMED

                 DIVIDE WS-PREV-CLAIMS INTO WS-PREV-CLAIMS-TOTAL
                                     GIVING FLD-AVG-CLAIMED
                 ADD WS-AMOUNT-CLAIMED  TO  WS-CLAIMS-TOTAL
                 ADD 1 TO WS-CLAIMS-NUM-TOTAL

                 MOVE WS-INSURENCE-REC TO OUT-CLIENT-REC
                 WRITE OUT-CLIENT-REC AFTER 2
                 ADD 2 TO WS-LINE-COUNT
           ELSE
                 MOVE 56 TO WS-LINE-COUNT.
      *
      ******************************************************
      *
      *
       1230-PRINT-TOTALS.

           MOVE SPACE TO OUT-CLIENT-REC.
           WRITE OUT-CLIENT-REC AFTER 2.
           DIVIDE WS-CLAIMS-NUM-TOTAL INTO WS-CLAIMS-TOTAL
                                    GIVING  WS-AVERAGE-CLAIM.

           MOVE SPACE TO OUT-CLIENT-REC.
           MOVE WS-CLAIMS-TOTAL TO TOTALS-CURR-CLAIMS.
           MOVE WS-TOTALS-1 TO OUT-CLIENT-REC.
           WRITE OUT-CLIENT-REC AFTER 1.

           MOVE SPACES TO OUT-CLIENT-REC.
           MOVE WS-CLAIMS-NUM-TOTAL TO TOTALS-MAX-CLAIMS.
           MOVE WS-TOTALS-2 TO OUT-CLIENT-REC.
           WRITE OUT-CLIENT-REC AFTER 1.

           MOVE SPACES TO OUT-CLIENT-REC.
           MOVE WS-AVERAGE-CLAIM TO TOTALS-AVG-CLAIMS.
           MOVE WS-TOTALS-3 TO OUT-CLIENT-REC.
           WRITE OUT-CLIENT-REC AFTER 1.
           MOVE SPACES TO OUT-CLIENT-REC.
           WRITE OUT-CLIENT-REC AFTER 1.
      *
      *******************************************************
      *  As with 1200-PRINT-RECORD except when the screen is full
      * (ie when line count is greater than 22) the screen is paused
      * until any key on the keyboard is pressed.
      *
       1300-LIST-RECORD.

           PERFORM 1310-LIST-TITLE.
           PERFORM 1320-READ-LIST-FILE
                         UNTIL WS-LINE-COUNT IS GREATER 21.
           IF WS-END-FILE-FLAG = "S"
                         PERFORM 1330-LIST-TOTALS.
           DISPLAY NEW-PAGE.
           ACCEPT ANY-KEY.

      *
      *****************************************************

       1310-LIST-TITLE.

           ADD 1 TO WS-PAGE-COUNT.
           DISPLAY BLANK-SCREEN.
           MOVE WS-TEMP-DATE TO WS-TITLE-DATE.
           DISPLAY DIS-TITLE.
           DISPLAY DIS-HEADER.
           MOVE 8 TO WS-LINE-COUNT.
      *
      *****************************************************

       1320-READ-LIST-FILE.

           READ CLIENT-FILE AT END MOVE "S" TO WS-END-FILE-FLAG.
           IF WS-END-FILE-FLAG NOT EQUAL "S"
                 MOVE IN-CLIENT-REC TO WS-CLIENT-REC
                 MOVE WS-LINE-COUNT TO LIN
                 ADD 1 TO WS-PREV-CLAIMS
                 DIVIDE WS-PREV-CLAIMS INTO WS-PREV-CLAIMS-TOTAL
                                     GIVING WS-AVERAGE-CLAIM

                 DISPLAY (LIN, 3)  WS-CLAIM-NUMBER        NO
                 DISPLAY (LIN, 16) WS-CLASS-CODE          NO
                 DISPLAY (LIN, 25) WS-REGION              NO
                 DISPLAY (LIN, 35) WS-PREV-CLAIMS         NO
                 DISPLAY (LIN, 44) WS-PREV-CLAIMS-TOTAL   NO
                 DISPLAY (LIN, 58) WS-AVERAGE-CLAIM       NO
                 DISPLAY (LIN, 70) WS-AMOUNT-CLAIMED      NO

                 ADD WS-AMOUNT-CLAIMED TO WS-CLAIMS-TOTAL
                 ADD 1 TO WS-CLAIMS-NUM-TOTAL
                 ADD 1 TO WS-LINE-COUNT
           ELSE
                 MOVE 22 TO WS-LINE-COUNT.
      *
      ******************************************************
      *
       1330-LIST-TOTALS.

           DIVIDE WS-CLAIMS-NUM-TOTAL INTO WS-CLAIMS-TOTAL
                                   GIVING  WS-AVERAGE-CLAIM.
           MOVE WS-LINE-COUNT TO LIN.
           DISPLAY (LIN  , 35) "CURRENT TOTAL CLAIMS :" NO.
           DISPLAY (LIN  , 65) WS-CLAIMS-TOTAL.
           ADD  1 TO WS-LINE-COUNT.
           MOVE WS-LINE-COUNT TO LIN.
           DISPLAY (LIN  , 35) "NUMBER OF CLAIMS     :" NO.
           DISPLAY (LIN  , 65) WS-CLAIMS-NUM-TOTAL.
           ADD  1 TO WS-LINE-COUNT.
           MOVE WS-LINE-COUNT TO LIN.
           DISPLAY (LIN  , 35) "AVERAGE CLAIM        :" NO.
           DISPLAY (LIN  , 65) WS-AVERAGE-CLAIM.
      *
      *****************************************************
      *
