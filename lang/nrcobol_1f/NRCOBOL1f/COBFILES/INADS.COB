       IDENTIFICATION DIVISION.
       PROGRAM-ID.   INADS.
      *PROGRAM DISCRIPTION.
      *
      *program to create data for index files paper.nam and advert.typ
      *
      *AUTHOR.        cHArRiOTt.
      *INSTALLATION.
      *DATE-WRITTEN.  24th AUG 89.
      *DATE-COMPILLED.
      *SECURITY.
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SOURCE-COMPUTER.   AMSTRAD 1512.
       OBJECT-COMPUTER.
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL.

            SELECT           IN-NEWSPAPER-NAME
            ASSIGN TO        DISK
            ORGANIZATION IS  INDEXED
            ACCESS MODE  IS  RANDOM
            RECORD KEY   IS  ER-PAPER-CODE
            FILE STATUS  IS  WS-PAPER-FILE-STATUS.

            SELECT           IN-ADVERT-TYPE
            ASSIGN TO        DISK
            ORGANIZATION IS  INDEXED
            ACCESS MODE  IS  RANDOM
            RECORD KEY   IS  ER-IN-AD-CODE
            FILE STATUS  IS  WS-AD-TYPE-STATUS.

      *
       DATA DIVISION.
       FILE SECTION.
       FD IN-NEWSPAPER-NAME
            LABEL RECORD IS  STANDARD
            VALUE OF FILE-ID IS "PAPER.NAM".
       01 ER-NEWSPAPER-NAME.
           03 ER-PAPER-CODE         PIC X(3).
           03 ER-PAPER-NAME         PIC X(25).
      *
       FD IN-ADVERT-TYPE
            LABEL RECORD IS  STANDARD
            VALUE OF FILE-ID IS "ADVERT.TYP".
       01 ER-ADVERT-TYPE.
           03 ER-IN-AD-CODE         PIC 9(3).
           03 ER-TYPE-OF-AD         PIC X(20).
           03 ER-PRICE-PER-LINE     PIC 9V99.
      *
      **********************************************************
      *
       WORKING-STORAGE SECTION.
       01 WS-NEWSPAPER-NAME.
           03 WS-PAPER-CODE         PIC X(3).
              88 WS-TERMINATE-PAPER VALUE "999".
           03 WS-PAPER-NAME         PIC X(25).
      *
       01 WS-ADVERT-TYPE.
           03 WS-IN-AD-CODE         PIC 9(3).
              88 WS-TEMINATE-ADVERTS VALUE 999.
           03 WS-TYPE-OF-AD         PIC X(20).
           03 WS-PRICE-PER-LINE     PIC 9V99.
      *
       01 WS-REAL-DATE.
           03 WS-REAL-YEAR          PIC XX.
           03 WS-REAL-MONTH         PIC XX.
           03 WS-REAL-DAY           PIC XX.
       01 WS-TEMP-DATE.
           03 WS-TEMP-DAY           PIC XX.
           03 FILLER                PIC X  VALUE "/".
           03 WS-TEMP-MONTH         PIC XX.
           03 FILLER                PIC X  VALUE "/".
           03 WS-TEMP-YEAR          PIC XX.
      *
       01 WS-COUNTERS.
           03 WS-PAGE-COUNTER           PIC 99.
           03 WS-LINE-COUNTER           PIC 99.
           03 ws-file-counter           pic 999 value 0.
           
       01 WS-END-ENTRY              PIC X   VALUE " ".
       01 WS-STOP-RUN-FLAG          PIC X   VALUE " ".
       01 WS-END-FILE-FLAG          PIC X   VALUE " ".
       01 WS-ABORT-READ-FLAG        PIC X   VALUE " ".
       01 WS-PAPER-FILE-STATUS      PIC XX  VALUE "00".
       01 WS-AD-TYPE-STATUS         PIC XX  VALUE "00".
       01 WS-RESPONCE               PIC X.
           88  WS-RESPONCE-Q        VALUE  "Q" "q".
           88  WS-RESPONCE-A        VALUE  "A" "a".
           88  WS-RESPONCE-P        VALUE  "P" "p".
           88  WS-RESPONCE-YN       VALUE  "Y" "N"
                                           "y" "n".
           88  WS-RESPONCE-Y        VALUE  "Y" "y".
           88  WS-RESPONCE-N        VALUE  "N" "n".
      *
      **********************************************************
      *
       SCREEN SECTION.
       01 BLANK-SCREEN.
           03 BLANK SCREEN.
       01 PROG-DISCRIPTION.
           03 LINE 1 COLUMN 5      VALUE 
           "A PROGRAM TO PRODUCE DATA FOR CLASSIFIED ADVERTISING INCOME 
      -    " REPORT".
       01 DIS-PROG-TITLE.
           03 LINE 3 COLUMN 1   PIC X(8) FROM WS-TEMP-DATE.
           03 LINE 3 COLUMN 22     HIGHLIGHT VALUE
                               "DATA FOR ADVERTISING INCOME REPORT".
           03 LINE 3 COLUMN 65     VALUE "PAGE ".
           03 LINE 3 COLUMN 70  PIC X(8) FROM WS-PAGE-COUNTER.
       01 PAPER-REC.
           03 LINE 6  COLUMN 5  VALUE     
                   "NEWSPAPER DATABASE,   Please enter as directed".
           03 LINE 10 COLUMN 5  VALUE  "NEWSPAPER NAME : ".
           03 LINE 10 COLUMN 22 PIC X(25) TO WS-PAPER-NAME.
           03 LINE 12 column 5  value  "NEWSPAPER CODE : ".
           03 LINE 12 COLUMN 22 PIC X(3)  USING WS-PAPER-CODE.
           03 LINE 18 COLUMN 5  VALUE  "NEWSPAPER CODE '999' TO EXIT".
       01 ADVERTS-REC.
           03 LINE 6  COLUMN 5  VALUE     
                   "ADVERTS DATABASE      Please enter as directed".
           03 LINE 10 COLUMN 5  VALUE  "ADVERT CODE (numeric)  : ".
           03 LINE 10 COLUMN 30 PIC 9(3)  TO WS-IN-AD-CODE.
           03 LINE 12 COLUMN 5  VALUE  "TYPE OF ADVERT (20 MAX): ".
           03 LINE 12 COLUMN 30 PIC X(20) TO WS-TYPE-OF-AD.
           03 LINE 14 COLUMN 5  VALUE  "COST OF ADVERT (9.99)  : ".
           03 LINE 14 COLUMN 30 PIC 9V99  TO WS-PRICE-PER-LINE.
           03 LINE 18 COLUMN 5  VALUE  "ADVERT CODE '999' TO EXIT".
       01 BAD-KEY.
           03 LINE 18 COLUMN 5  VALUE "BAD KEY FIELD PLEASE TRY AGAIN".

       01 MENU.
           03 LINE 8  COLUMN 33    UNDERLINE  VALUE "MENU".
           03 LINE 13 COLUMN 22 VALUE "PRESS 'A' to create ADVERT.TYP".
           03 LINE 15 COLUMN 22 VALUE "      'P' to create PAPER.NAME".
           03 LINE 17 COLUMN 22 VALUE "      'Q' to quit     MENU   ".
           03 LINE 20 COLUMN 19 VALUE "NOW WHAT? ".
       01 MENU-INPUT.
           03 LINE 20 COLUMN 29    PIC X TO WS-RESPONCE AUTO.
       01 TASK-RUNING.
           03 LINE 23 COLUMN 5     HIGHLIGHT VALUE 
                                            "REPORT NOW BEING PRINTED". 
       01 PROG-FINISH.
           03 LINE 25 COLUMN 1     BLANK LINE.
           03 LINE 25 COLUMN 5     VALUE "TASK COMPLEATE".
       01 ANY-KEY.
           03 LINE 25 COLUMN 33    PIC X TO WS-RESPONCE AUTO.
       01 RESPONCE-LINE.
           03 LINE 25 COLUMN 5     VALUE 
              "PRINT ANY KEY TO CONTINUE > ".
      * 
       01 ERROR-MESSAGES.
           03 LINE 23 COLUMN 5  VALUE 
                     "FILE WOULD NOT OPEN :ADS:PAP:TYP:PRT:".
           03 LINE 24 COLUMN 5  VALUE 
                     "STATUS ERROR CODES  :   :   :   :   :".
           03 LINE 24 COLUMN 30  HIGHLIGHT  PIC XX
              FROM WS-PAPER-FILE-STATUS.
           03 LINE 24 COLUMN 34  HIGHLIGHT  PIC XX
              FROM WS-AD-TYPE-STATUS.           
      *
      **********************************************************
      *
       PROCEDURE DIVISION.
      *
       0000-MAIN.
           OPEN OUTPUT  IN-NEWSPAPER-NAME.
           OPEN OUTPUT  IN-ADVERT-TYPE.
                IF WS-PAPER-FILE-STATUS = "00"  AND
                   WS-AD-TYPE-STATUS    = "00"
                         PERFORM 1000-DISPLAY 
                                 UNTIL WS-STOP-RUN-FLAG = "S"
                   ELSE
                         DISPLAY ERROR-MESSAGES.
           CLOSE IN-NEWSPAPER-NAME.
           CLOSE IN-ADVERT-TYPE.
           STOP RUN.
      *
      **********************************************************
      *
       1000-DISPLAY.
           ACCEPT WS-REAL-DATE FROM DATE.
           MOVE WS-REAL-DAY   TO WS-TEMP-DAY.
           MOVE WS-REAL-MONTH TO WS-TEMP-MONTH.
           MOVE WS-REAL-YEAR  TO WS-TEMP-YEAR.
           MOVE 1 TO WS-PAGE-COUNTER.
           MOVE SPACE TO WS-END-ENTRY.
           PERFORM 1005-NEWSCREEN.

           DISPLAY MENU.
           ACCEPT  MENU-INPUT.
           IF WS-RESPONCE-Q
                 MOVE "S" TO WS-STOP-RUN-FLAG
                 DISPLAY PROG-FINISH
             ELSE
             IF WS-RESPONCE-A
                   PERFORM 1100-ADVERTS-REC
                                UNTIL WS-END-ENTRY = "S"
               ELSE
               IF WS-RESPONCE-P
                     PERFORM 1200-PAPER-REC   
                                  UNTIL WS-END-ENTRY = "S".
      *
       1005-NEWSCREEN.
           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.
           DISPLAY DIS-PROG-TITLE. 

      *
      **********************************************************
      *
       1100-ADVERTS-REC. 
           PERFORM 1005-NEWSCREEN.
           PERFORM 1105-BLANK-ADVERTS.
           DISPLAY ADVERTS-REC.
           ACCEPT  ADVERTS-REC.
           IF NOT WS-TEMINATE-ADVERTS
              WRITE ER-ADVERT-TYPE FROM WS-ADVERT-TYPE
              INVALID KEY DISPLAY BAD-KEY
                          DISPLAY RESPONCE-LINE
                          ACCEPT  ANY-KEY
           ELSE
              MOVE "S" TO WS-END-ENTRY.
            
      *
       1105-BLANK-ADVERTS.
           MOVE SPACES TO WS-TYPE-OF-AD.
           MOVE ZERO   TO WS-IN-AD-CODE.
           MOVE ZERO   TO WS-PRICE-PER-LINE. 
      *
      **********************************************************
      *
       1200-PAPER-REC. 
           PERFORM 1005-NEWSCREEN.
           PERFORM 1205-BLANK-PAPER.
           DISPLAY PAPER-REC.
           ACCEPT  PAPER-REC.
           IF NOT WS-TERMINATE-PAPER
              WRITE ER-NEWSPAPER-NAME FROM WS-NEWSPAPER-NAME
              INVALID KEY DISPLAY BAD-KEY
                          DISPLAY RESPONCE-LINE
                          ACCEPT  ANY-KEY
           ELSE
              MOVE "S" TO WS-END-ENTRY.
      *
       1205-BLANK-PAPER.
           MOVE SPACES TO WS-NEWSPAPER-NAME.
           add 37 to ws-file-counter.
           move ws-file-counter to WS-PAPER-CODE.
      *
      **********************************************************
      



