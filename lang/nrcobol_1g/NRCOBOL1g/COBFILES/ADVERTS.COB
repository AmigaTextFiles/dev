       IDENTIFICATION DIVISION.
       PROGRAM-ID.   ADVERTS.
      *PROGRAM DISCRIPTION.
      *  A program to print an income report for an advertising agency.
      * The advertisements will be in several different newspapers
      * and will be grouped according to the catergory of ad.
      * The program uses table lookup filess to translate the codes from
      * the input file to report data.
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
            SELECT           IN-ADVERT-FILE
            ASSIGN TO        DISK
            ORGANIZATION  IS LINE SEQUENTIAL
            ACCESS MODE   IS SEQUENTIAL
            FILE STATUS   IS WS-FILE-STATUS.

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

            SELECT           OUT-INCOME-REPORT
            ASSIGN TO        PRINTER
            ORGANIZATION  IS SEQUENTIAL
            ACCESS MODE   IS SEQUENTIAL
            FILE STATUS   IS WS-PRINT-STATUS.
      *
       DATA DIVISION.
       FILE SECTION.
       FD IN-ADVERT-FILE
            LABEL RECORD IS  STANDARD
            VALUE OF FILE-ID IS "ADVERTS.FIL".
       01 ER-ADVERT-FILE.
           03 ER-NEWSPAPER-CODE     PIC X(3).
           03 ER-AD-TYPE-CODE       PIC 9(3).
           03 ER-ACCOUNT-NUMBER     PIC 9(6).
           03 ER-ACCOUNT-NAME       PIC X(20).
           03 ER-NUMBER-OF-LINES    PIC 99.
           03 ER-AD-DURATION        PIC 999.
           03 ER-STARTING-DATE      PIC 9(6).
      *
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
       FD OUT-INCOME-REPORT
            LABEL RECORD IS  OMITTED.
       01 PRT-INCOME-REPORT.
           03 FILLER                PIC A(80).
      *
       WORKING-STORAGE SECTION.
       01 WS-ADVERT-FILE.
           03 WS-NEWSPAPER-CODE     PIC X(3).
           03 WS-AD-TYPE-CODE       PIC 9(3).
           03 WS-ACCOUNT-NUMBER     PIC 9(6).
           03 WS-ACCOUNT-NAME       PIC X(20).
           03 WS-NUMBER-OF-LINES    PIC 99.
           03 WS-AD-DURATION        PIC 999.
           03 WS-STARTING-DATE.
              05 WS-STARTING-DAY    PIC 99.
              05 WS-STARTING-MONTH  PIC 99.
              05 WS-STARTING-YEAR   PIC 99.
      *
       01 WS-NEWSPAPER-NAME.
           03 WS-PAPER-CODE         PIC X(3).
           03 WS-PAPER-NAME         PIC X(25).
      *
       01 WS-ADVERT-TYPE.
           03 WS-IN-AD-CODE         PIC 9(3).
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
           03 WS-NUMBER-OF-ACCOUNTS     PIC 9999.
           03 WS-AVG-PRICE-PER-LINE     PIC 9999V99.
           03 WS-TOTAL-LINES            PIC 999999.
           03 WS-AVG-NUMBER-OF-LINES    PIC 999999.
           03 WS-INCOME-EARNED          PIC 99999V99.
           03 WS-TOTAL-INCOME-EARNED    PIC 99999V99.
       01 WS-STOP-RUN-FLAG          PIC X   VALUE " ".
       01 WS-END-FILE-FLAG          PIC X   VALUE " ".
       01 WS-ABORT-READ-FLAG        PIC X   VALUE " ".
       01 WS-FILE-STATUS            PIC XX  VALUE "00".
       01 WS-PAPER-FILE-STATUS      PIC XX  VALUE "00".
       01 WS-AD-TYPE-STATUS         PIC XX  VALUE "00".
       01 WS-PRINT-STATUS           PIC XX  VALUE "00".
       01 WS-RESPONCE               PIC X.
           88  WS-RESPONCE-Q        VALUE  "Q" "q".
           88  WS-RESPONCE-P        VALUE  "P" "p".
           88  WS-RESPONCE-S        VALUE  "S" "s".
           88  WS-RESPONCE-YN       VALUE  "Y" "N"
                                           "y" "n".
           88  WS-RESPONCE-Y        VALUE  "Y" "y".
           88  WS-RESPONCE-N        VALUE  "N" "n".
      *
       01 PRINT-PROG-TITLE.
           03 WS-PRT-TEMP-DATE       PIC X(8).
           03 FILLER                 PIC X(14) VALUE SPACES.
           03 FILLER                 PIC X(36) VALUE
           "CLASSIFIED ADVERTISING INCOME REPORT".
           03 FILLER                 PIC X(7)  VALUE SPACES.
           03 FILLER                 PIC X(5)  VALUE "PAGE ".
           03 WS-PRT-PAGE-COUNTER    PIC 99.
       01 PRINT-RECORD.
           03 PRT-PAPER-NAME.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(26)  VALUE "NEWSPAPER NAME          : ".
              05 WS-PRT-PAPER-NAME   PIC X(25).
           03 PRT-TYPE-OF-AD.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(26)  VALUE "TYPE OF ADVERT          : ".
              05 WS-PRT-TYPE-OF-AD   PIC X(20).
           03 PRT-ACCOUNT-NUMBER.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(26)  VALUE "ACCOUNT NUMBER          : ".
              05 WS-PRT-ACCOUNT-NUMBER  PIC 9(6).
           03 PRT-ACCOUNT-NAME.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(26)  VALUE "ACCOUNT NAME            : ".
              05 WS-PRT-ACCOUNT-NAME PIC X(20).
           03 PRT-NUMBER-OF-LINES.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(26)  VALUE "NUMBER OF LINES         : ".
              05 WS-PRT-NUMBER-OF-LINES PIC Z9.
           03 PRT-AD-DURATION.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(26)  VALUE "ADVERT'S DURATION (DAYS): ".
              05 WS-PRT-AD-DURATION  PIC ZZ9.
           03 PRT-PRICE-PER-LINE.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(29)  VALUE "PRICE PER LINE          : ".
              05 WS-PRT-PRICE-PER-LINE PIC $9.99.
           03 PRT-INCOME-EARNED.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(26)  VALUE "INCOME EARNED           : ".
              05 WS-PRT-INCOME-EARNED  PIC $$$$9.99.
       01 PRINT-TOTALS.
           03 PRT-NUMBER-OF-ACCOUNTS.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(28)  VALUE "NUMBER OF ACCOUNTS      : ".
              05 WS-PRT-NUMBER-OF-ACCOUNTS PIC ZZZ9.
           03 PRT-AVG-NUMBER-OF-LINES.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(26)  VALUE "AVERAGE NUMBER OF LINES : ".
              05 WS-PRT-AVG-NUMBER-OF-LINES PIC ZZZZZ9. 
           03 PRT-AVG-PRICE-PER-LINE.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(27)  VALUE "AVERAGE PRICE PER LINE  : ".
              05 WS-PRT-AVG-PRICE-PER-LINE      PIC $$$9.99.
           03 PRT-TOTAL-INCOME-EARNED.
              05 FILLER   PIC X(5)   VALUE SPACES.
              05 FILLER   PIC X(26)  VALUE "TOTAL INCOME EARNED     : ".
              05 WS-PRT-TOTAL-INCOME-EARNED     PIC $$$$9.99.
      *
       SCREEN SECTION.
       01 BLANK-SCREEN.
           03 BLANK SCREEN.
       01 PROG-DISCRIPTION.
           03 LINE 1 COLUMN 5      VALUE 
           "A PROGRAM TO PRODUCE CLASSIFIED ADVERTISING INCOME REPORT".
       01 DIS-PROG-TITLE.
           03 LINE 3 COLUMN 1   PIC X(8) FROM WS-TEMP-DATE.
           03 LINE 3 COLUMN 22     HIGHLIGHT VALUE
                               "CLASSIFIED ADVERTISING INCOME REPORT".
           03 LINE 3 COLUMN 65     VALUE "PAGE ".
           03 LINE 3 COLUMN 70  PIC X(8) FROM WS-PAGE-COUNTER.
       01 DIS-RECORD.
           03 LINE 6  COLUMN 5      VALUE "NEWSPAPER NAME          : ".
           03 LINE 6  COLUMN 31 PIC X(25) FROM  WS-PAPER-NAME.
           03 LINE 7  COLUMN 5      VALUE "TYPE OF ADVERT          : ".
           03 LINE 7  COLUMN 31 PIC X(20) FROM  WS-TYPE-OF-AD.
           03 LINE 8  COLUMN 5      VALUE "ACCOUNT NUMBER          : ".
           03 LINE 8  COLUMN 31 PIC 9(6) FROM  WS-ACCOUNT-NUMBER.
           03 LINE 9  COLUMN 5      VALUE "ACCOUNT NAME            : ".
           03 LINE 9  COLUMN 31 PIC X(20) FROM  WS-ACCOUNT-NAME.
           03 LINE 10 COLUMN 5      VALUE "NUMBER OF LINES         : ".
           03 LINE 10 COLUMN 31 PIC 99 FROM  WS-NUMBER-OF-LINES.
           03 LINE 11 COLUMN 5      VALUE "ADVERT'S DURATION (DAYS): ".
           03 LINE 11 COLUMN 31 PIC 999 FROM  WS-AD-DURATION.
           03 LINE 12 COLUMN 5      VALUE "PRICE PER LINE          : $".
           03 LINE 12 COLUMN 32 PIC 9V99 FROM  WS-PRICE-PER-LINE.
           03 LINE 13 COLUMN 5      VALUE "INCOME EARNED           : $".
           03 LINE 13 COLUMN 32 PIC 9(5)V99 FROM  WS-INCOME-EARNED.
           03 LINE 15 COLUMN 5      VALUE "RECORD NUMBER           :  ".
           03 LINE 15 COLUMN 31 PIC 9(4)    FROM  WS-NUMBER-OF-ACCOUNTS.
       01 DIS-TOTALS.
           03 LINE 19 COLUMN 5      VALUE "NUMBER OF ACCOUNTS      : ".
           03 LINE 19 COLUMN 31 PIC 9(4) FROM WS-NUMBER-OF-ACCOUNTS.
           03 LINE 20 COLUMN 5      VALUE "AVERAGE NUMBER OF LINES : ".
           03 LINE 20 COLUMN 31 PIC 9(6) FROM WS-AVG-NUMBER-OF-LINES.
           03 LINE 21 COLUMN 5      VALUE "AVERAGE PRICE PER LINE  : $".
           03 LINE 21 COLUMN 32 PIC 9(4)V99 FROM WS-AVG-PRICE-PER-LINE.
           03 LINE 22 COLUMN 5      VALUE "TOTAL INCOME EARNED     : $".
           03 LINE 22 COLUMN 32 PIC 9(5)V99 FROM WS-TOTAL-INCOME-EARNED.
       01 MENU.
           03 LINE 8  COLUMN 33    UNDERLINE  VALUE "MENU".
           03 LINE 13 COLUMN 22    VALUE "PRESS 'P' to list to PRINTER".
           03 LINE 15 COLUMN 22    VALUE "      'S' to list to SCREEN ".
           03 LINE 17 COLUMN 22    VALUE "      'Q' to quit    MENU   ".
       01 MENU-INPUT.
           03 LINE 20 COLUMN 22    PIC X TO WS-RESPONCE AUTO.
       01 TASK-RUNING.
           03 LINE 23 COLUMN 5     HIGHLIGHT VALUE 
                                            "REPORT NOW BEING PRINTED". 
       01 PROG-FINISH.
           03 LINE 25 COLUMN 1     BLANK LINE.
           03 LINE 25 COLUMN 5     VALUE "TASK COMPLEATE".
       01 ANY-KEY.
           03 LINE 25 COLUMN 48    PIC X TO WS-RESPONCE AUTO.
       01 RESPONCE-LINE.
           03 LINE 25 COLUMN 5     VALUE 
              "PRINT ANY KEY TO CONTINUE ('Q' TO QUIT) > ".
      * 
       01 ERROR-MESSAGES.
           03 LINE 23 COLUMN 5  VALUE 
                     "FILE WOULD NOT OPEN :ADS:PAP:TYP:PRT:".
           03 LINE 24 COLUMN 5  VALUE 
                     "STATUS ERROR CODES  :   :   :   :   :".
           03 LINE 24 COLUMN 26  HIGHLIGHT  PIC XX
              FROM WS-FILE-STATUS.
           03 LINE 24 COLUMN 30  HIGHLIGHT  PIC XX
              FROM WS-PAPER-FILE-STATUS.
           03 LINE 24 COLUMN 34  HIGHLIGHT  PIC XX
              FROM WS-AD-TYPE-STATUS.
           03 LINE 24 COLUMN 38  HIGHLIGHT  PIC XX
              FROM WS-PRINT-STATUS.
      *
       PROCEDURE DIVISION.
      *
      *****************************************************
      *  This paragraph opens all files for either input or output.
      * These files are then tested for errors.An error message is
      * displayed and the program terminated if any errors are found
      * other wise 1000-DISPLAY is performed until WS-STOP-RUN-FLAG
      * equals "S".
      *
       0000-MAIN.
           OPEN INPUT  IN-ADVERT-FILE.
           OPEN INPUT  IN-NEWSPAPER-NAME.
           OPEN INPUT  IN-ADVERT-TYPE.
           OPEN OUTPUT OUT-INCOME-REPORT.
                IF WS-FILE-STATUS       = "00"  AND
                   WS-PAPER-FILE-STATUS = "00"  AND
                   WS-AD-TYPE-STATUS    = "00"  AND
                   WS-PRINT-STATUS      = "00"
                         PERFORM 1000-DISPLAY 
                                 UNTIL WS-STOP-RUN-FLAG = "S"
                   ELSE
                         DISPLAY ERROR-MESSAGES.
           CLOSE IN-ADVERT-FILE.
           CLOSE IN-NEWSPAPER-NAME.
           CLOSE IN-ADVERT-TYPE.
           CLOSE OUT-INCOME-REPORT.
           STOP RUN.
      *
      **********************************************************
      *  This paragraph displays the program's discription, accepts
      * the system's date then display's a MENU for the user's input.
      * Acceptable input are 'Q' to quit the praragraph and program,
      * 'S' to display the income report on the screen until the
      * end file flag is equal to 'S' or 'P' to display the the income
      * report on the printer, again until the end file flag  equal 'S'.
      *  Note the IN-ADVERT-FILE is closed and opened at the end of this
      * file so that the file pointer is again set to the start of this
      * file.
      *
       1000-DISPLAY.
           MOVE ZEROS TO WS-COUNTERS.
           MOVE SPACE TO WS-END-FILE-FLAG.
           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.
           ACCEPT WS-REAL-DATE FROM DATE.
           MOVE WS-REAL-DAY   TO WS-TEMP-DAY.
           MOVE WS-REAL-MONTH TO WS-TEMP-MONTH.
           MOVE WS-REAL-YEAR  TO WS-TEMP-YEAR.
           DISPLAY DIS-PROG-TITLE. 

           DISPLAY MENU.
           ACCEPT  MENU-INPUT.
           IF WS-RESPONCE-Q
                 MOVE "S" TO WS-STOP-RUN-FLAG
                 DISPLAY PROG-FINISH
             ELSE
             IF WS-RESPONCE-S
                   PERFORM 1100-DISPLAY-FILE
                                UNTIL WS-END-FILE-FLAG = "S"
               ELSE
               IF WS-RESPONCE-P
                     DISPLAY TASK-RUNING
                     PERFORM 1210-PRINT-TITLE
                     PERFORM 1200-PRINT-FILE   
                                  UNTIL WS-END-FILE-FLAG = "S".
           CLOSE      IN-ADVERT-FILE.
           OPEN INPUT IN-ADVERT-FILE.
      *
      **********************************************************
      *  This paragraph display the contents of IN-ADVERT-FILE to the
      * screen until WS-END-FILE-FLAG IS 'S', this can be forced by
      * returning 'Q' for quit at the responce line prompt. The
      * pararagraph performs 1300-READ-FILE to read all files into
      * working storage, these are then displayed to screen by  DISPLAY
      * DIS-RECORD. At the file end or when forced, the file's totals
      * are displayed to the screen by DISPLAY DIS-TOTALS.
      *
       1100-DISPLAY-FILE.
           PERFORM 1300-READ-FILE.
           IF WS-END-FILE-FLAG NOT EQUAL  "S"
                PERFORM 1110-DISPLAY-TITLE
                ADD 1 TO WS-NUMBER-OF-ACCOUNTS
                ADD WS-NUMBER-OF-LINES TO WS-TOTAL-LINES
                MULTIPLY WS-NUMBER-OF-LINES BY WS-PRICE-PER-LINE
                                       GIVING  WS-INCOME-EARNED
                ADD WS-INCOME-EARNED TO WS-TOTAL-INCOME-EARNED
                DISPLAY DIS-RECORD
                DISPLAY RESPONCE-LINE
                ACCEPT ANY-KEY.
                IF WS-RESPONCE-Q MOVE "S" TO WS-END-FILE-FLAG.

                IF WS-END-FILE-FLAG EQUAL "S"
                      DIVIDE WS-TOTAL-LINES BY WS-NUMBER-OF-ACCOUNTS
                                       GIVING WS-AVG-NUMBER-OF-LINES
                      DIVIDE WS-TOTAL-INCOME-EARNED BY WS-TOTAL-LINES
                                       GIVING WS-AVG-PRICE-PER-LINE
                      DISPLAY DIS-TOTALS
                      DISPLAY RESPONCE-LINE
                      ACCEPT ANY-KEY.
      *
      **********************************************************
      *  This paragraph increments the page counter then display's 
      * the date, program title and page number by DISPLAY DIS-TITLE.
      *
       1110-DISPLAY-TITLE.
           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.
           ADD 1 TO WS-PAGE-COUNTER.
           DISPLAY DIS-PROG-TITLE.
      *
      **********************************************************
      *  This paragraph display the contents of IN-ADVERT-FILE to the
      * printer until WS-END-FILE-FLAG IS 'S'. The pararagraph performs
      * 1300-READ-FILE to read all files into working storage, these
      * are then displayed to the printer by perform 1220-PRINT-RECORD.
      * At the file's end  the file's totals are displayed to the screen
      * by perform 1230-PRINT-TOTALS. NOTE 1210-PRINT-TITLE is performed
      * initially by the calling paragraph and then when WS-LINE-COUNTER
      * is greater than 55. 
      *
       1200-PRINT-FILE.
           PERFORM 1300-READ-FILE.
           IF WS-END-FILE-FLAG NOT EQUAL  "S"
                 ADD 1 TO WS-NUMBER-OF-ACCOUNTS
                 ADD WS-NUMBER-OF-LINES TO WS-TOTAL-LINES
                 MULTIPLY WS-NUMBER-OF-LINES BY WS-PRICE-PER-LINE
                                        GIVING  WS-INCOME-EARNED
                 ADD WS-INCOME-EARNED TO WS-TOTAL-INCOME-EARNED

                 IF WS-LINE-COUNTER GREATER 55
                        PERFORM 1210-PRINT-TITLE
                        PERFORM 1220-PRINT-RECORD
                   ELSE
                        PERFORM 1220-PRINT-RECORD

            ELSE
                 DIVIDE WS-TOTAL-LINES BY WS-NUMBER-OF-ACCOUNTS
                                   GIVING WS-AVG-NUMBER-OF-LINES
                 DIVIDE WS-TOTAL-INCOME-EARNED BY WS-TOTAL-LINES
                                   GIVING WS-AVG-PRICE-PER-LINE
                 PERFORM 1230-PRINT-TOTALS.
      *
      **********************************************************
      *  This paragraph increments the page counter then display's 
      * the date, program title and page number by DISPLAY DIS-TITLE.
      *
       1210-PRINT-TITLE.
           ADD 1 TO WS-PAGE-COUNTER.
           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-TEMP-DATE TO WS-PRT-TEMP-DATE.
           MOVE WS-PAGE-COUNTER TO WS-PRT-PAGE-COUNTER.
           MOVE PRINT-PROG-TITLE TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER PAGE.
           MOVE 1 TO WS-LINE-COUNTER.
      *
      **********************************************************
      *  This paragraph sends the data of the required fields to
      * the printer, then incrementes WS-LINE-COUNTER by 8.
      *
       1220-PRINT-RECORD.
           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-PAPER-NAME  TO WS-PRT-PAPER-NAME.
           MOVE PRT-PAPER-NAME TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 2.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-TYPE-OF-AD  TO WS-PRT-TYPE-OF-AD.
           MOVE PRT-TYPE-OF-AD TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-ACCOUNT-NUMBER  TO WS-PRT-ACCOUNT-NUMBER.
           MOVE PRT-ACCOUNT-NUMBER TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-ACCOUNT-NAME  TO  WS-PRT-ACCOUNT-NAME.
           MOVE PRT-ACCOUNT-NAME TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-NUMBER-OF-LINES  TO WS-PRT-NUMBER-OF-LINES.
           MOVE PRT-NUMBER-OF-LINES TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-AD-DURATION  TO WS-PRT-AD-DURATION.
           MOVE PRT-AD-DURATION TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-PRICE-PER-LINE  TO WS-PRT-PRICE-PER-LINE.
           MOVE PRT-PRICE-PER-LINE TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-INCOME-EARNED  TO  WS-PRT-INCOME-EARNED.
           MOVE PRT-INCOME-EARNED TO  PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           ADD 8 TO WS-LINE-COUNTER.
      *
      **********************************************************
      *  This papragraph sends the required total fields to the printer.
      *
       1230-PRINT-TOTALS.
           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-NUMBER-OF-ACCOUNTS  TO WS-PRT-NUMBER-OF-ACCOUNTS.
           MOVE PRT-NUMBER-OF-ACCOUNTS TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 2.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-AVG-NUMBER-OF-LINES  TO WS-PRT-AVG-NUMBER-OF-LINES.
           MOVE PRT-AVG-NUMBER-OF-LINES TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-AVG-PRICE-PER-LINE  TO WS-PRT-AVG-PRICE-PER-LINE.
           MOVE PRT-AVG-PRICE-PER-LINE TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           MOVE SPACES TO PRT-INCOME-REPORT.
           MOVE WS-TOTAL-INCOME-EARNED  TO WS-PRT-TOTAL-INCOME-EARNED.
           MOVE PRT-TOTAL-INCOME-EARNED TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.

           MOVE SPACES TO PRT-INCOME-REPORT.
           WRITE PRT-INCOME-REPORT AFTER 1.
      *
      **********************************************************
      *  This papragraph reads IN-ADVERT-FILE to working storage
      * and sets WS-END-FILE-FLAG, if the end is reached.It also reads
      * IN-NEWSPAPER-NAME and  IN-ADVERT-TYPE to working storage, any
      * errors are indicated in WS-ABORT-READ-FLAG for later DEBUGGING.
      *
       1300-READ-FILE.
           READ IN-ADVERT-FILE INTO WS-ADVERT-FILE 
                   AT END MOVE "S" TO WS-END-FILE-FLAG.
           IF WS-END-FILE-FLAG NOT EQUAL "S"
                MOVE WS-NEWSPAPER-CODE TO ER-PAPER-CODE
                READ IN-NEWSPAPER-NAME INTO WS-NEWSPAPER-NAME
                        INVALID KEY MOVE "A" TO WS-ABORT-READ-FLAG.
           IF WS-ABORT-READ-FLAG NOT EQUAL "A"  AND
                WS-END-FILE-FLAG NOT EQUAL "S"
                MOVE WS-AD-TYPE-CODE TO ER-IN-AD-CODE
                READ IN-ADVERT-TYPE INTO WS-ADVERT-TYPE
                        INVALID KEY MOVE "B" TO WS-ABORT-READ-FLAG.
           
      * 
      ***************************************************************
