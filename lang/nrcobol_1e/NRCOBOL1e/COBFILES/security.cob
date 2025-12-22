       IDENTIFICATION DIVISION.
       PROGRAM-ID.   SECURITY.
      *PROGRAM DISCRIPTION.
      *
      *  Program to allow ACCESS  and/ or MODIFICATION of student 
      * records, according to the user's security level. This is
      * determined according to the job-code entered.
      * RESPONCE-JOB-CODE  .... AO9-A99 to DO9-D99
      * 
      *AUTHOR.        cHArRiOTt.
      *INSTALLATION.
      *DATE-WRITTEN.
      *DATE-COMPILLED.
      *SECURITY.
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SOURCE-COMPUTER.   AMSTRAD 1512.
       OBJECT-COMPUTER.
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL.
            SELECT           SECURE-FILE
            ASSIGN TO        DISK
            ORGANIZATION IS  LINE SEQUENTIAL
            ACCESS MODE IS   SEQUENTIAL
            FILE STATUS IS   WS-FILE-STATUS.

            SELECT           SECURE-BAK-FILE
            ASSIGN TO        DISK
            ORGANIZATION IS  LINE SEQUENTIAL
            ACCESS MODE IS   SEQUENTIAL
            FILE STATUS IS   WS-FILE-BAK-STATUS.

            SELECT           SECURE-PRINT
            ASSIGN TO        PRINTER
            ORGANIZATION IS  SEQUENTIAL
            ACCESS MODE IS   SEQUENTIAL
            FILE STATUS IS   WS-PRINT-STATUS.
      *
       DATA DIVISION.
       FILE SECTION.
       FD SECURE-FILE
            LABEL RECORD IS STANDARD
            VALUE OF FILE-ID IS "SECURITY.DAT2".
       01 IN-STUDENT-REC.
           03 ST-NUMBER        PIC 9(6).
           03 ST-LAST-NAME     PIC X(16).
           03 ST-FIRST-NAME    PIC X(12).
           03 ST-CLASS-STAND   PIC XX.
           03 ST-GRADE-PNT-AVG PIC 9V99.
           03 ST-ACADEM-STATUS PIC X.
           03 ST-PHONE-NUMBER  PIC 9(10).
           03 ST-BIRTH-DATE    PIC 9(6).
      *
       FD SECURE-BAK-FILE
            LABEL RECORD IS STANDARD
            VALUE OF FILE-ID IS "SECURITY.NEW".
       01 OUT-STUDENT-REC.
           03 ST2-NUMBER        PIC 9(6).
           03 ST2-LAST-NAME     PIC X(16).
           03 ST2-FIRST-NAME    PIC X(12).
           03 ST2-CLASS-STAND   PIC XX.
           03 ST2-GRADE-PNT-AVG PIC 9V99.
           03 ST2-ACADEM-STATUS PIC X.
           03 ST2-PHONE-NUMBER  PIC 9(10).
           03 ST2-BIRTH-DATE    PIC 9(6).
      * 
       FD SECURE-PRINT
           LABEL RECORD IS STANDARD
            VALUE OF FILE-ID IS "SECURITY.PRT".
       01 PRT-STUDENT-REC.
           03 FILLER           PIC A(80).
      *
       WORKING-STORAGE SECTION.
       01 WS-STUDENT-REC.
           03 WS-ST-NUMBER        PIC 9(6).
           03 WS-ST-LAST-NAME     PIC X(16).
           03 WS-ST-FIRST-NAME    PIC X(12).
           03 WS-ST-CLASS-STAND   PIC XX.
           03 WS-ST-GRADE-PNT-AVG PIC 9V99.
           03 WS-ST-ACADEM-STATUS PIC X.
           03 WS-ST-PHONE-NUMBER  PIC 9(10).
           03 WS-ST-BIRTH-DATE.
               05 WS-ST-BIRTH-YEAR   PIC 99.
               05 WS-ST-BIRTH-MONTH  PIC 99.
               05 WS-ST-BIRTH-DAY    PIC 99.
      *
       01 WS-COUNTERS.
           03 WS-PAGE-COUNT       PIC 99.
           03 WS-LINE-COUNT       PIC 99.
           03 WS-ST-RECORD-NUMBER PIC 999 VALUE 0.
       01 WS-SECURITY-LEVEL       PIC 9 VALUE 0.
       01 WS-VALIDATE             PIC X.
       01 WS-STOP-RUN-FLAG        PIC X  VALUE " ".
       01 WS-END-FILE-FLAG        PIC X  VALUE " ".
       01 WS-FILE-STATUS          PIC XX VALUE "00".
       01 WS-FILE-BAK-STATUS      PIC XX VALUE "00".
       01 WS-PRINT-STATUS         PIC XX VALUE "00".
       01 WS-REAL-DATE.
           03 WS-REAL-YEAR        PIC XX.
           03 WS-REAL-MONTH       PIC XX.
           03 WS-REAL-DAY         PIC XX.
       01 WS-TEMP-DATE.
           03 WS-TEMP-DAY         PIC XX.
           03 FILLER              PIC X  VALUE  "/".
           03 WS-TEMP-MONTH       PIC XX.
           03 FILLER              PIC X  VALUE  "/".
           03 WS-TEMP-YEAR        PIC XX.
       01 WS-RESPONCE             PIC X  VALUE SPACE.
           88 WS-RESPONCE-S       VALUE "S" "s".
           88 WS-RESPONCE-P       VALUE "P" "p".
           88 WS-RESPONCE-Q       VALUE "Q" "q".
           88 WS-RESPONCE-Y       VALUE "Y" "y".
           88 WS-RESPONCE-YN      VALUE "Y" "y"
                                        "N" "n".
       01 WS-RESPONCE-JOB-CODE.
           03 WS-ALPHA-RESPONCE   PIC XX.
              88 WS-RESPONCE-A1   VALUE "AO" "Ao" "aO" "ao".
              88 WS-RESPONCE-B1   VALUE "BO" "Bo" "bO" "bo".
              88 WS-RESPONCE-C1   VALUE "CO" "Co" "cO" "co".
              88 WS-RESPONCE-D1   VALUE "DO" "Do" "dO" "do".
           03 WS-NUM-RESPONCE     PIC 9.
           03 FILLER              PIC X   VALUE "-".
           03 WS-ALPHA-2-REPONCE  PIC X.
              88 WS-RESPONCE-A2   VALUE "A" "a".
              88 WS-RESPONCE-B2   VALUE "B" "b".
              88 WS-RESPONCE-C2   VALUE "C" "c".
              88 WS-RESPONCE-D2   VALUE "D" "d".
           03 WS-NUM-2-RESPONCE   PIC 99.
       01 WS-VALIDATE-CLASS-STAND PIC XX.
           88 WS-CLASS-STANDING   VALUE "FR" "fr"
                                        "SO" "so"
                                        "JU" "ju"
                                        "SR" "sr".
       01 WS-VALIDATE-ACADEMIC    PIC X.
           88 WS-ACADEM-STANDING  VALUE "G" "g"
                                        "W" "w"
                                        "P" "p".
       01 PRT-SCREEN-TITLE.
           03 PRT-TEMP-DATE       PIC X(8).
           03 FILLER    PIC X(18) VALUE SPACES.
           03 FILLER    PIC X(28) VALUE "A DISPLAY OF STUDENT RECORDS".
           03 FILLER    PIC X(9)  VALUE SPACES.
           03 FILLER    PIC X(15) VALUE "SECURITY LEVEL ".      
           03 PRT-SECURITY-LEVEL  PIC 9.
       01 PRT-RECORD-NUMBER.
           03 FILLER    PIC X(5)  VALUE SPACES.
           03 FILLER    PIC X(26) VALUE "CURRENT RECORD NUMBER   : ".
           03 PRT-ST-RECORD-NUMBER   PIC 999.
      *
       01 PRT-STUDENT-NUMBER.
           03 FILLER    PIC X(5)  VALUE SPACES.
           03 FILLER    PIC X(26) VALUE "STUDENT NUMBER          : ".
           03 PRT-ST-NUMBER       PIC ZZZZZ9.
       01 PRT-STUDENT-LAST-NAME.
           03 FILLER    PIC X(5)  VALUE SPACES.
           03 FILLER    PIC X(26) VALUE "STUDENT NAME      LAST  : ".
           03 PRT-ST-LAST-NAME    PIC X(16).
       01 PRT-STUDENT-FIRST-NAME.
           03 FILLER    PIC X(5)  VALUE SPACES.
           03 FILLER    PIC X(26) VALUE "                  FIRST : ".
           03 PRT-ST-FIRST-NAME   PIC X(12).
      *
       01 PRT-BIRTH-DAY.
           03 FILLER    PIC X(5)  VALUE SPACES.
           03 FILLER    PIC X(26) VALUE "DATE OF BIRTH           : ".
           03 PRT-ST-BIRTH-DAY    PIC 99.
           03 FILLER    PIC X     VALUE "/".
           03 PRT-ST-BIRTH-MONTH  PIC 99.
           03 FILLER    PIC X     VALUE "/".
           03 PRT-ST-BIRTH-YEAR   PIC 99.
       01 PRT-PHONE-NUMBER.
           03 FILLER    PIC X(5)  VALUE SPACES.
           03 FILLER    PIC X(26) VALUE "PHONE NUMBER            : ".
           03 PRT-ST-PHONE-NUMBER PIC 9(10).
      *
       01 PRT-CLASS-STANDING.
           03 FILLER    PIC X(5)  VALUE SPACES.
           03 FILLER    PIC X(26) VALUE "CLASS STANDING          : ".
           03 PRT-ST-CLASS-STAND  PIC XX.
       01 PRT-GRADE-POINT.
           03 FILLER    PIC X(5)  VALUE SPACES.
           03 FILLER    PIC X(26) VALUE "GRADE POINT AVERAGE     : ".
           03 PRT-ST-GRADE-PNT-AVG PIC 9.99.
       01 PRT-ACADEMIC-STATUS.
           03 FILLER    PIC X(5)  VALUE SPACES.
           03 FILLER    PIC X(26) VALUE "ACADEMIC STATUS         : ".
           03 PRT-ST-ACADEM-STATUS PIC X.
      *
       SCREEN SECTION.
       01 BLANK-SCREEN.
           03 BLANK SCREEN.
       01 PROG-DISCRIPTION.
           03 LINE 1 COLUMN 3                VALUE 
                      "PROGRAM TO DISPLAY AND/OR AMMEND STUDENT RECORDS 
      -               "ACCORDING TO SECURITY LEVEL".
       01 PROG-FINISH.
           03 LINE 25 COLUMN 5               VALUE "TASK COMPLETE".
       01 SCREEN-TITLE.
           03 LINE 2 COLUMN 3    PIC X(8)    FROM  WS-TEMP-DATE.
           03 LINE 2 COLUMN 26   HIGHLIGHT   VALUE
              "A DISPLAY OF STUDENT RECORDS".
           03 LINE 2 COLUMN 62               VALUE "SECURITY LEVEL ".
           03 LINE 2 COLUMN 78   PIC 9       FROM  WS-SECURITY-LEVEL.
       01 RECORD-NUMBER.
           03 LINE 19 COLUMN 5            VALUE "CURRENT RECORD NUMBER".
           03 LINE 19 COLUMN 29           VALUE ": ".
           03 LINE 19 COLUMN 30 PIC 999   USING WS-ST-RECORD-NUMBER.
       01 LEVEL-3.
           03 LINE 13 COLUMN 5            VALUE "CLASS STANDING".
           03 LINE 13 COLUMN 29           VALUE ": ".
           03 LINE 13 COLUMN 30 PIC XX    USING  WS-ST-CLASS-STAND.
           03 LINE 15 COLUMN 5            VALUE "GRADE POINT AVERAGE".
           03 LINE 15 COLUMN 29           VALUE ": ".
           03 LINE 15 COLUMN 30 PIC 9V99  USING  WS-ST-GRADE-PNT-AVG.
           03 LINE 17 COLUMN 5            VALUE "ACADEMIC STATUS".
           03 LINE 17 COLUMN 29           VALUE ": ".
           03 LINE 17 COLUMN 30 PIC X     USING  WS-ST-ACADEM-STATUS.
      *
           03 LEVEL-2.
               05 LINE 9  COLUMN 5            VALUE "DATE OF BIRTH".
               05 LINE 9  COLUMN 29           VALUE ": ".
               05 LINE 9  COLUMN 30 PIC 9(2)  USING  WS-ST-BIRTH-DAY.
               05 LINE 9  COLUMN 32           VALUE "/".
               05 LINE 9  COLUMN 33 PIC 9(2)  USING  WS-ST-BIRTH-MONTH.
               05 LINE 9  COLUMN 35           VALUE "/".
               05 LINE 9  COLUMN 36 PIC 9(2)  USING  WS-ST-BIRTH-YEAR.
               05 LINE 11 COLUMN 5            VALUE "PHONE NUMBER".
               05 LINE 11 COLUMN 29           VALUE ": ".
               05 LINE 11 COLUMN 30 PIC 9(10) USING  WS-ST-PHONE-NUMBER.
      *
               05 LEVEL-1.
                  07 LINE 4 COLUMN 5            VALUE "STUDENT NUMBER".
                  07 LINE 4 COLUMN 29           VALUE ": ".
                  07 LINE 4 COLUMN 30 PIC 9(6)  USING  WS-ST-NUMBER.
                  07 LINE 6 COLUMN 5            VALUE "STUDENT NAME".
                  07 LINE 6 COLUMN 23           VALUE "LAST  : ".
                  07 LINE 6 COLUMN 30 PIC X(16) USING  WS-ST-LAST-NAME.
                  07 LINE 7 COLUMN 23           VALUE "FIRST : ".
                  07 LINE 7 COLUMN 30 PIC X(12) USING  WS-ST-FIRST-NAME.
       01 COMMENTS.
           03 LINE 4  COLUMN 49  VALUE ": MAXIMUM NUMBERS  '123456'".
           03 LINE 6  COLUMN 49  VALUE ":   ''  CHARECTERS '16'".
           03 LINE 7  COLUMN 49  VALUE ":   ''  CHARECTERS '12'".
           03 LINE 9  COLUMN 49  VALUE ": FORMAT DD/MM/YY  ".
           03 LINE 11 COLUMN 49  VALUE ": MAXIMUM NUMBERS  1234567890".
           03 LINE 13 COLUMN 49  VALUE ": VALID CHARECTERS FR,SO,JU,SR".
           03 LINE 15 COLUMN 49  VALUE ": MAXIMUM VALUE    '3.99'".
           03 LINE 17 COLUMN 49  VALUE ": VALID CHARECTERS 'G, W or P'".
      *
       01 RESPONCE-LINE.
           03 LINE 23 COLUMN 57    PIC X(7)
              TO WS-RESPONCE-JOB-CODE AUTO.
       01 JOB-CODE.
           03 LINE 23 COLUMN 5   VALUE 
           "PLEASE ENTER YOUR JOB-CODE FOR SECURITY VALIDATION >".
       01 WRONG-CODE.
           03 LINE 24 COLUMN 5   HIGHLIGHT VALUE
            "INCORRECT JOB-CODE YOU HAVE BEEN REFUSED ACCESS TO THE SYST
      -     "EM".
       01 OK-TO-SAVE.
           03 LINE 23 COLUMN 1    BLANK LINE.
           03 LINE 23 COLUMN 5    VALUE 
           "IS IT OK TO WRITE THIS DISPLAY TO STUDENT-FILE? (Y or N) >".
       01 ARE-YOU-SURE.
           03 LINE 23 COLUMN 1    BLANK LINE.
           03 LINE 23 COLUMN 5    HIGHLIGHT  VALUE  "ARE YOU SURE ".
           03 LINE 23 COLUMN 18   VALUE
              "IT IS OK TO WRITE OVER OLD RECORD? (Y or N) >".
       01 RESPONCE-OK.
           03 LINE 23 COLUMN 63   PIC X
              TO WS-RESPONCE.
       01 NEW-PAGE.
           03 LINE 23 COLUMN 1    BLANK LINE.
           03 LINE 23 COLUMN 5    VALUE 
           "PRESS ANY KEY FOR NEXT PAGE  ('Q' TO QUIT :'P' TO PRINT) >".
       01 ANY-KEY.
           03 LINE 23 COLUMN 64   PIC X  TO WS-RESPONCE AUTO.
       01 BLANK-RESPONCE-LINE.
           03 LINE 23 COLUMN 1    BLANK LINE.
       01 ERROR-IN-FORMAT.
           03 LINE 23 COLUMN 5    VALUE 
              "ERRORS IN RECORD FORMAT, PLEASE TRY AGAIN.".
      *                                                  
       01 ERROR-MESSAGES.
           03 LINE 21 COLUMN 8    VALUE 
                            "FILE WOULD NOT OPEN : F :F2 :PRT:".
           03 LINE 22 COLUMN 8    VALUE
                            "STATUS ERROR CODE   :   :   :   :".
           03 LINE 22 COLUMN 29   HIGHLIGHT  PIC XX
              FROM WS-FILE-STATUS.
           03 LINE 22 COLUMN 33   HIGHLIGHT  PIC XX
              FROM WS-FILE-BAK-STATUS.
           03 LINE 22 COLUMN 37   HIGHLIGHT  PIC XX
              FROM WS-PRINT-STATUS.
      *
      *****************************************************
      *
      *  Paragraph to open SECURE-FILE for import and SECURE-PRINT
      * for export.Should any of the files status be in error, the
      * files are closed and annd an error message printed along
      * with status value, other wise 10000-DISPLAY is called.
      * NOTE SECURE-BAK-FILE is only opened if WS-SECURITY-LEVEL
      * is 4, and is opened and closed in 1100-MENU.
      *
       PROCEDURE DIVISION.

       0000-MAIN.
           OPEN INPUT  SECURE-FILE.
           OPEN OUTPUT SECURE-PRINT.
                IF WS-FILE-STATUS     = "00" AND
                   WS-PRINT-STATUS    = "00"
                   PERFORM 1000-DISPLAY
                ELSE
                   DISPLAY ERROR-MESSAGES.
           CLOSE SECURE-FILE.
           CLOSE SECURE-PRINT.
           STOP RUN.
      *
      *****************************************************
      *
      *  This paragraph displays the program's title and then 
      * calls 1100-MENU. When done the paragraph displays a
      * finished message.
      *
       1000-DISPLAY.
           ACCEPT  WS-REAL-DATE FROM DATE.
           MOVE WS-REAL-DAY   TO WS-TEMP-DAY.
           MOVE WS-REAL-MONTH TO WS-TEMP-MONTH.
           MOVE WS-REAL-YEAR  TO WS-TEMP-YEAR.
           PERFORM 1100-MENU
                      UNTIL WS-STOP-RUN-FLAG = "S".
           DISPLAY PROG-FINISH.
      *
      ****************************************************
      *
      *  This paragrph requests the user's JOB-CODE. If this is 
      * incorrect the user exit's the system, other wise 
      * WS-SECURITY-LEVEL is set with the appropriate number (1-4).
      * It then calls 1200-READ-FILE.
      *
       1100-MENU.
           MOVE SPACE TO WS-END-FILE-FLAG.
           MOVE ZEROS TO WS-ST-RECORD-NUMBER.
           MOVE SPACE TO WS-RESPONCE-JOB-CODE.
           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.
           DISPLAY SCREEN-TITLE.

           DISPLAY JOB-CODE.
           ACCEPT RESPONCE-LINE.
           IF WS-RESPONCE-A1 AND WS-RESPONCE-A2
                   MOVE 1 TO WS-SECURITY-LEVEL
              ELSE
              IF WS-RESPONCE-B1 AND WS-RESPONCE-B2
                      MOVE 2 TO WS-SECURITY-LEVEL
                 ELSE
                 IF WS-RESPONCE-C1 AND WS-RESPONCE-C2
                         MOVE 3 TO WS-SECURITY-LEVEL
                    ELSE
                    IF WS-RESPONCE-D1 AND WS-RESPONCE-D2
                            MOVE 4 TO WS-SECURITY-LEVEL

                            OPEN OUTPUT SECURE-BAK-FILE
                            IF WS-FILE-BAK-STATUS NOT EQUAL "00"
                                   DISPLAY ERROR-MESSAGES
                                   MOVE "S" TO WS-STOP-RUN-FLAG
                             ELSE
                                 NEXT SENTENCE
                        ELSE
                        DISPLAY WRONG-CODE
                        MOVE "S" TO WS-STOP-RUN-FLAG.
      *
           IF WS-STOP-RUN-FLAG NOT EQUAL "S"
                  DISPLAY SCREEN-TITLE
                  DISPLAY COMMENTS
                  PERFORM 1200-READ-FILE
                        UNTIL WS-END-FILE-FLAG = "S".

           IF WS-SECURITY-LEVEL = "4" 
                  CLOSE SECURE-BAK-FILE.
      *
      *****************************************************
      *
      *  This paragraph read's the student file then calls 
      * 1300-DISPLAY-REC to determine the amount of data to display.
      * The program can be terminated by entering 'Q' at the 
      * 'request to continue' prompt or the current record sent to
      * the printer by entering 'P'.
      *
       1200-READ-FILE.         
           READ SECURE-FILE AT END MOVE "S" TO WS-END-FILE-FLAG.
           IF WS-END-FILE-FLAG NOT EQUAL "S"
                 MOVE IN-STUDENT-REC TO WS-STUDENT-REC
                 ADD 1 TO WS-ST-RECORD-NUMBER
                 DISPLAY RECORD-NUMBER
                 PERFORM 1300-DISPLAY-REC
                 DISPLAY NEW-PAGE
                 ACCEPT ANY-KEY
                 DISPLAY BLANK-RESPONCE-LINE
                 IF WS-RESPONCE-P
                       PERFORM 1400-PRINT-RECORD
                    ELSE
                    IF WS-RESPONCE-Q
                           MOVE "S" TO WS-END-FILE-FLAG
                           MOVE "S" TO WS-STOP-RUN-FLAG
                       ELSE
                          NEXT SENTENCE
             ELSE 
             CLOSE      SECURE-FILE
             OPEN INPUT SECURE-FILE.
      *
      *****************************************************
      *
      *  This paragraph display's student data according to 
      * WS-SECURITY-LEVEL. If at level 4, 1310-VALIDATE-REC is
      * called to verify modified record.
      *
       1300-DISPLAY-REC.
           IF WS-SECURITY-LEVEL = "1"
                 DISPLAY LEVEL-1
              ELSE
              IF WS-SECURITY-LEVEL = "2"
                    DISPLAY LEVEL-2
                 ELSE
                 IF WS-SECURITY-LEVEL = "3"
                       DISPLAY LEVEL-3
                    ELSE
                    IF WS-SECURITY-LEVEL = "4"
                          DISPLAY LEVEL-3
                          ACCEPT  LEVEL-3
                          PERFORM 1310-VALIDATE-REC
                                       UNTIL WS-RESPONCE-YN
                          MOVE WS-STUDENT-REC TO OUT-STUDENT-REC
                          WRITE OUT-STUDENT-REC.
      *
      ********************************************************
      *
      *  This paragraph validates the modified record, if OK
      * it prompts the user on wheather to send the data to 
      * a backup file.
      *
       1310-VALIDATE-REC.
            MOVE SPACE TO WS-RESPONCE.
            DISPLAY BLANK-RESPONCE-LINE.
            MOVE "Y" TO WS-VALIDATE.
            MOVE WS-ST-CLASS-STAND TO WS-VALIDATE-CLASS-STAND.
            MOVE WS-ST-ACADEM-STATUS TO WS-VALIDATE-ACADEMIC.
            IF NOT WS-CLASS-STANDING             OR
               NOT WS-ACADEM-STANDING            OR
               WS-ST-GRADE-PNT-AVG  GREATER 4    OR
               WS-ST-BIRTH-DAY   IS GREATER 31   OR
               WS-ST-BIRTH-MONTH IS GREATER 12
                       DISPLAY ERROR-IN-FORMAT
                       MOVE "N" TO WS-VALIDATE.
      *
            IF WS-VALIDATE = "Y"
                  DISPLAY  OK-TO-SAVE
                  PERFORM 1320-READ-KEYBOARD UNTIL WS-RESPONCE-YN
                  IF WS-RESPONCE-Y 
                         MOVE SPACE TO WS-RESPONCE
                         DISPLAY  ARE-YOU-SURE
                         PERFORM 1320-READ-KEYBOARD UNTIL WS-RESPONCE-YN
                     ELSE
                         NEXT SENTENCE
              ELSE
              MOVE IN-STUDENT-REC TO WS-STUDENT-REC
              DISPLAY LEVEL-3
              ACCEPT  LEVEL-3.
      *
      ****************************************************************
      *
      *  This paragraph reads the keyboard and returns only when the 
      * responce is Y or N.
      *
       1320-READ-KEYBOARD.
           ACCEPT RESPONCE-OK.
      *
      ***************************************************************
      *
      *  This paragraph sends the current student record to the printer
      * according to the user's allowed security level.
      *
       1400-PRINT-RECORD.
           MOVE SPACES TO PRT-STUDENT-REC.
           MOVE WS-TEMP-DATE TO PRT-TEMP-DATE.
           MOVE WS-SECURITY-LEVEL TO PRT-SECURITY-LEVEL.
           MOVE PRT-SCREEN-TITLE TO PRT-STUDENT-REC.
           WRITE PRT-STUDENT-REC AFTER 3.

           MOVE SPACES TO PRT-STUDENT-REC.
           MOVE WS-ST-NUMBER TO PRT-ST-NUMBER.
           MOVE PRT-STUDENT-NUMBER TO PRT-STUDENT-REC.
           WRITE PRT-STUDENT-REC AFTER 3.

           MOVE SPACES TO PRT-STUDENT-REC.
           MOVE WS-ST-LAST-NAME TO PRT-ST-LAST-NAME.
           MOVE PRT-STUDENT-LAST-NAME TO PRT-STUDENT-REC.
           WRITE PRT-STUDENT-REC AFTER 1.

           MOVE SPACES TO PRT-STUDENT-REC.
           MOVE WS-ST-FIRST-NAME TO PRT-ST-FIRST-NAME.
           MOVE PRT-STUDENT-FIRST-NAME TO PRT-STUDENT-REC.
           WRITE PRT-STUDENT-REC AFTER 1.

           IF WS-SECURITY-LEVEL GREATER THAN 1
                 MOVE SPACES TO PRT-STUDENT-REC
                 MOVE WS-ST-BIRTH-DAY   TO PRT-ST-BIRTH-DAY
                 MOVE WS-ST-BIRTH-MONTH TO PRT-ST-BIRTH-MONTH
                 MOVE WS-ST-BIRTH-YEAR  TO PRT-ST-BIRTH-YEAR
                 MOVE PRT-BIRTH-DAY TO PRT-STUDENT-REC

                 WRITE PRT-STUDENT-REC AFTER 2

                 MOVE SPACES TO PRT-STUDENT-REC
                 MOVE WS-ST-PHONE-NUMBER TO PRT-ST-PHONE-NUMBER
                 MOVE PRT-PHONE-NUMBER TO PRT-STUDENT-REC
                 WRITE PRT-STUDENT-REC AFTER 1

                 IF WS-SECURITY-LEVEL GREATER THAN 2
                       MOVE SPACES TO PRT-STUDENT-REC
                       MOVE WS-ST-CLASS-STAND TO PRT-ST-CLASS-STAND
                       MOVE PRT-CLASS-STANDING TO PRT-STUDENT-REC
                       WRITE PRT-STUDENT-REC AFTER 2

                       MOVE SPACES TO PRT-STUDENT-REC
                       MOVE WS-ST-GRADE-PNT-AVG TO PRT-ST-GRADE-PNT-AVG
                       MOVE PRT-GRADE-POINT TO PRT-STUDENT-REC
                       WRITE PRT-STUDENT-REC AFTER 1

                       MOVE SPACES TO PRT-STUDENT-REC
                       MOVE WS-ST-ACADEM-STATUS TO PRT-ST-ACADEM-STATUS
                       MOVE PRT-ACADEMIC-STATUS TO PRT-STUDENT-REC
                       WRITE PRT-STUDENT-REC AFTER 1
                 ELSE
                    NEXT SENTENCE
           ELSE
           MOVE SPACES TO PRT-STUDENT-REC.
           MOVE WS-ST-RECORD-NUMBER TO PRT-ST-RECORD-NUMBER.
           MOVE PRT-RECORD-NUMBER TO PRT-STUDENT-REC.
           WRITE PRT-STUDENT-REC AFTER 2.
           MOVE SPACES TO PRT-STUDENT-REC.
           WRITE PRT-STUDENT-REC AFTER 1.
      *
      *************************************************************
