       IDENTIFICATION DIVISION.
       PROGRAM-ID.  DATA.
      *
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.
       OBJECT-COMPUTER.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT STUDENT-FILE ASSIGN TO DISK
           ORGANIZATION IS SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-FILE-STATUS.
      *
       DATA DIVISION.
       FILE SECTION.
       FD STUDENT-FILE
           LABEL RECORDS STANDARD
           VALUE OF FILE-ID IS "STUDENT.FIL".
       01  OUT-STUDENT-REC.
           03  ER-STUDENT-NUMBER        PIC 9(4).
           03  ER-STUDENT-NAME          PIC X(20).
           03  ER-ENROLLED-CREDITS      PIC 9(2).
      *
      *
       WORKING-STORAGE SECTION.
     
       01 WS-STUDENT-REC.
           03 WS-STUDENT-NUMBER      PIC 9(4).
           03 WS-STUDENT-NAME        PIC X(20).
           03 WS-ENROLLED-CREDITS    PIC 9(2).
       01 WS-STOP-FLAG               PIC X   VALUE " ".
       01 WS-RESPONCE                PIC X.
           88 WS-RESPONCE-Q                  VALUE "Q" "q".
       01 WS-FILE-STATUS             PIC XX  VALUE "00".    
      *
       SCREEN SECTION.
       01 ENTRY-SCREEN.
           03 BLANK SCREEN.
           03 LINE 1 COLUMN 15 VALUE 
                              "ENTER STUDENT DETAILS AS DIRECTED".
       01 BLANK-LINE.
           03 BLANK LINE.
       01 ERROR-MESSG.
           03 LINE 24 COLUMN 8   
              VALUE "FILE WOULD NOT OPEN CODE RETURNED : ".
           03 LINE 24 COLUMN 44   HIGHLIGHT PIC XX
              FROM  WS-FILE-STATUS.
       PROCEDURE DIVISION.
      *
       000-MAIN.
           OPEN OUTPUT STUDENT-FILE.
           IF WS-FILE-STATUS  EQUAL "00"
                     PERFORM 100-MAIN UNTIL WS-STOP-FLAG = "S"
              ELSE
                     DISPLAY ERROR-MESSG.
           CLOSE STUDENT-FILE.
           STOP RUN.
      *********************************************************
      *
       100-MAIN.
           DISPLAY ENTRY-SCREEN.
           DISPLAY (23, 8) "PRESS Q TO QUIT."
           ACCEPT (23, 25)  WS-RESPONCE.
           IF NOT WS-RESPONCE-Q
              PERFORM 200-DATA-ENTRY
           ELSE
              MOVE "S" TO WS-STOP-FLAG.
      *
      ************************************************************
       200-DATA-ENTRY.
           DISPLAY ENTRY-SCREEN.
           DISPLAY (6, 8) 
                   "ENTER STUDENT NUMBER,MAXIMUM NUMBER 4     : ".
           MOVE ZERO TO WS-STUDENT-NUMBER.
           ACCEPT  (6, 52) WS-STUDENT-NUMBER.

           DISPLAY (8, 8) 
                   "ENTER STUDENT NAME ,MAXIMUM 20 CHARECTERS : ".
           MOVE SPACES TO WS-STUDENT-NAME.
           ACCEPT  (8, 52) WS-STUDENT-NAME.

           DISPLAY (10, 8) 
                   "ENTER STUDENT ENROLLED CREDITS , MAX 2   : ".
           MOVE ZEROS TO WS-ENROLLED-CREDITS.
           ACCEPT  (10, 52) WS-ENROLLED-CREDITS.

           MOVE WS-STUDENT-REC TO OUT-STUDENT-REC.
           WRITE OUT-STUDENT-REC.
      *
      *
      ***************************************************
