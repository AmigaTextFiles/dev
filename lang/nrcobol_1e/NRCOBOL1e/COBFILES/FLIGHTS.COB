       IDENTIFICATION DIVISION.
       PROGRAM-ID.   FLIGHTS.
      *PROGRAM DISCRIPTION.
      *  A program to update and print data from an indexed file called
      * 'FLIGHT. FILE'.Used to translate value codes from the input file
      * to a more readable form are two lookup tables called 'AIRPLANES'
      * and 'AIRPORTS'.
      *  AIRPLANE, contains the airplanes' code and their corresponding
      * discription. AIRPORTS ,contains the airports' code and their
      * corresponding airport names.  PRT: version.
      *
      *AUTHOR.        cHArRiOTt.
      *INSTALLATION.
      *DATE-WRITTEN.  SEP 28th 89.
      *DATE-COMPILLED.
      *SECURITY.
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SOURCE-COMPUTER.   AMSTRAD 1512.
       OBJECT-COMPUTER.
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL.
            SELECT           AIRPORT
            ASSIGN TO        DISK
            ORGANIZATION IS  INDEXED
            ACCESS MODE  IS  DYNAMIC
            RECORD KEY   IS  ER-AIRPORT-CODE
            FILE STATUS  IS  WS-AIRPORT-STATUS. 

            SELECT           AIRPLANE
            ASSIGN TO        DISK
            ORGANIZATION IS  LINE SEQUENTIAL
            ACCESS MODE  IS  SEQUENTIAL
            FILE STATUS  IS  WS-AIRPLANE-STATUS.

            SELECT           FLIGHT
            ASSIGN TO        DISK 
            ORGANIZATION IS  INDEXED
            ACCESS MODE  IS  DYNAMIC
            RECORD KEY   IS  ER-FLIGHT-NUMBER
            FILE STATUS  IS  WS-FLIGHT-STATUS.
 
            SELECT           AIR-PRINT
            ASSIGN TO        PRINTER
            ORGANIZATION IS  SEQUENTIAL
            ACCESS MODE  IS  SEQUENTIAL
            FILE STATUS  IS  WS-PRINTER-STATUS.
      *
       DATA DIVISION.
       FILE SECTION.
       FD AIRPORT
            LABEL RECORD IS  STANDARD
            VALUE OF FILE-ID IS "AIRPORTS.OUT".
       01 ER-AIRPORT-REC.
           03 ER-AIRPORT-CODE      PIC 99.
           03 ER-AIRPORT-NAME      PIC X(15).

       FD AIRPLANE
            LABEL RECORD IS STANDARD
            VALUE OF FILE-ID IS "AIRPLANE".
       01 ER-AIRPLANE-REC.
           03 ER-AIRPLANE-CODE     PIC X(4).
           03 ER-MAKE-MODEL        PIC X(16).

       FD FLIGHT
           LABEL RECORD IS STANDARD
           VALUE OF FILE-ID IS "FLIGHTOUT.FIL".
       01 ER-FLIGHT-REC.
           03 ER-FLIGHT-NUMBER     PIC 9(5).
           03 ER-AIRPLANE-ID       PIC 9(5).
           03 ER-AIRPLANE-MK-CODE  PIC X(4).
           03 ER-FLIGHT-ORG-CODE   PIC 99.
           03 ER-FLIGHT-DES-CODE   PIC 99.
           03 ER-SEATS-FILLED      PIC 999.
           03 ER-SEATS-TABLE.                                 
              05 ER-SEAT-TABLE     OCCURS 10 TIMES.
                 08 ER-SEAT-LETTER OCCURS  6 TIMES.
                    10 ER-SEAT     PIC 9(4).

       FD AIR-PRINT
            LABEL RECORD IS OMITTED
            VALUE OF FILE-ID IS "PRT:".
       01 OUT-PRINT-REC.
           03 FILLER               PIC X(80).
      *
       WORKING-STORAGE SECTION.
       01 WS-AIRPORT-REC.
           03 WS-AIRPORT-CODE      PIC 99       VALUE 99.
           03 WS-AIRPORT-NAME      PIC X(15).
      *
       01 WS-AIRPLANE-REC.
           03 WS-AIRPLANE-ARRAY    OCCURS 10 TIMES.
             05 WS-AIRPLANE-CODE   PIC X(4)     VALUE "0000".
             05 WS-MAKE-MODEL      PIC X(16).
      *
       01 WS-FLIGHT-REC.
           03 WS-FLIGHT-NUMBER     PIC 9(5)     VALUE 99.
           03 WS-AIRPLANE-ID       PIC 9(5).
           03 WS-AIRPLANE-MK-CODE  PIC X(4).
           03 WS-FLIGHT-ORG-CODE   PIC 99.
           03 WS-FLIGHT-DES-CODE   PIC 99.
           03 WS-SEATS-FILLED      PIC 999.
           03 WS-SEATS-TABLE.
              05 WS-SEAT-TABLE     OCCURS 10 TIMES.
                 08 WS-SEAT-LETTER OCCURS  6 TIMES.
                    10 WS-SEAT     PIC 9(4).
      *
      *
       01 WS-AIRPLANE-END-FLAG      PIC X       VALUE " ".
           88 WS-AIRPLANE-END                    VALUE "S".
       01 WS-AIRPORT-END-FLAG      PIC X        VALUE " ".
           88 WS-AIRPORT-END                     VALUE "S".
       01 WS-FLIGHT-END-FLAG       PIC X        VALUE " ".
           88 WS-FLIGHT-END                      VALUE "S".
       01 WS-STOP-RUN-FLAG         PIC X        VALUE " ".
       01 WS-ABORT-FLAG            PIC X        VALUE " ".

       01 WS-FLIGHT-STATUS         PIC XX       VALUE "00".
       01 WS-AIRPLANE-STATUS       PIC XX       VALUE "00".
       01 WS-AIRPORT-STATUS        PIC XX       VALUE "00".
       01 WS-PRINTER-STATUS        PIC XX       VALUE "00".

       01 WS-RECORD-COUNTER        PIC 99       VALUE 00.
       01 WS-PAGE-COUNTER          PIC 99       VALUE 00.
       01 WS-LINE-COUNTER          PIC 99       VALUE 00.
       01 WS-SEAT-ROW              PIC 99       VALUE 00.
       01 WS-SEAT-COLUMN           PIC 99       VALUE 00.
       01 WS-SEAT-NUMBER           PIC 9999     VALUE 0000.
       01 WS-FLIGHT-DEPARTURES     PIC X(15)    VALUE SPACES.
       01 WS-FLIGHT-ARRIVALS       PIC X(15)    VALUE SPACES.
       01 WS-AIRPLANE-NAME         PIC X(16)    VALUE SPACES.
       01 WS-NUMBER-OF-FLIGHTS     PIC 999      VALUE 000.
       01 WS-TOTAL-SEATS-USED      PIC 9(5)     VALUE 000.
       01 WS-TOTAL-SEATS           PIC 9(5)     VALUE 000.
       01 WS-PERCENT-SEATS-FILLED  PIC 9(5)     VALUE 000.
       01 WS-AVERAGE-SEATS-USED    PIC 9(5)     VALUE 000.
       01 WS-AVG-PERCENT-SEATS-FILLED PIC 9(5)   VALUE 000.
       01 WS-REAL-DATE.
           03 WS-REAL-YEAR         PIC XX.
           03 WS-REAL-MONTH        PIC XX.
           03 WS-REAL-DAY          PIC XX.
       01 WS-TEMP-DATE.
           03 WS-TEMP-DAY          PIC XX.
           03 FILLER               PIC X        VALUE "/".
           03 WS-TEMP-MONTH        PIC XX.
           03 FILLER               PIC X        VALUE "/".
           03 WS-TEMP-YEAR         PIC XX.
       01 WS-RESPONCE              PIC X        VALUE " ".
           88 WS-RESPONCE-C        VALUE "C" "c".
           88 WS-RESPONCE-R        VALUE "R" "r".
           88 WS-RESPONCE-Q        VALUE "Q" "q".
           88 WS-RESPONCE-Y        VALUE "Y" "y".
           88 WS-RESPONCE-N        VALUE "N" "n".
           88 WS-RESPONCE-YN       VALUE "Y" "y"
                                         "N" "n".
       01 PRINT-PROG-TITLE.
           03 FILLER               PIC X(5)  VALUE "PAGE ".
           03 WS-PRT-PAGE-COUNTER  PIC 99.
           03 FILLER               PIC X(20) VALUE SPACES.
           03 FILLER               PIC X(25) VALUE
              "AIRLINE SEAT USAGE REPORT".
           03 FILLER               PIC X(20) VALUE SPACES.
           03 WS-PRT-TEMP-DATE     PIC X(8).
       01 PRINT-RECORD.
           03 PRT-AIRPLANE-ID.
              05 FILLER               PIC X(33) VALUE
               "     AIRPLANE-ID               : ".
              05 WS-PRT-AIRPLANE-ID   PIC 9(5).
           03 PRT-AIRPLANE-NAME.
              05 FILLER               PIC X(33) VALUE 
               "     AIRPLANE NAME             : ".
              05 WS-PRT-AIRPLANE-NAME PIC X(16).
           03 PRT-AIRPORT-ORG.
              05 FILLER               PIC X(33) VALUE
               "     AIRPORT - ORIGINATION     : ".
              05 WS-PRT-AIRPORT-ORG   PIC X(15).
           03 PRT-AIRPORT-DES.
              05 FILLER               PIC X(33) VALUE
               "     AIRPORT - DESTINATION     : ".
              05 WS-PRT-AIRPORT-DES   PIC X(15).
           03 PRT-SEATS-FILLED.
              05 FILLER               PIC X(33) VALUE
               "     SEATS FILLED              : ".
              05 WS-PRT-SEATS-FILLED  PIC ZZ9.
           03 PRT-PERCENT-SEATS-FILLED.
              05 FILLER               PIC X(34) VALUE
               "     PERCENTAGE OF SEATS FILLED: %".
              05 WS-PRT-PERCENT-SEATS-FILLED    PIC ZZ9.
       01 PRINT-TOTALS.
           03 PRT-NUMBER-OF-FLIGHTS.
              05 FILLER               PIC X(33) VALUE
               "     NUMBER OF FLIGHTS         : ".
              05 WS-PRT-NUMBER-OF-FLIGHTS       PIC ZZ9.
           03 PRT-TOTAL-SEATS-USAGE.
              05 FILLER               PIC X(33) VALUE
               "     TOTAL SEATS USAGE         : ".
              05 WS-PRT-TOTAL-SEATS-USAGE       PIC ZZ9.
           03 PRT-AVG-PERCENT-SEATS-FILLED.
              05 FILLER               PIC X(34) VALUE
               "     AVERAGE % OF TOTAL SEATS  : %".
              05 WS-PRT-AVG-PERC-SEATS-FILLED   PIC ZZ9.
      *
       SCREEN SECTION.
       01 MENU.
           03 LINE 10 COLUMN 30    HIGHLIGHT VALUE "MENU".
           03 LINE 13 COLUMN 30    VALUE "C)hange flight data".
           03 LINE 14 COLUMN 30    VALUE "R)eport listing".
           03 LINE 15 COLUMN 30    VALUE "Q)uit program".
       01 MENU-RESPONCE.
           03 LINE 17 COLUMN 28    VALUE ">> <<".
           03 LINE 17 COLUMN 30    PIC X USING WS-RESPONCE AUTO.
       01 SC-FLIGHT-NUMBER.
           03 LINE 6 COLUMN 5  VALUE "FLIGHT NUMBER          : ".
           03 LINE 6 COLUMN 30 PIC 9(5) USING WS-FLIGHT-NUMBER.
       01 SC-FLIGHT-REC.
           03 LINE 7 COLUMN 5   VALUE "AIRPLANE ID           : ".
           03 LINE 7 COLUMN 30  PIC 9(5) USING WS-AIRPLANE-ID.
           03 LINE 8 COLUMN 5   VALUE "AIRPLANE MAKE CODE    : ".
           03 LINE 8 COLUMN 30  PIC X(4) USING  WS-AIRPLANE-MK-CODE.
       01 SC-FLIGHT-PLAN.
           03 LINE 10 COLUMN 5   VALUE "FLIGHT ORIGIN CODE    : ".
           03 LINE 10 COLUMN 30  PIC 99 USING  WS-FLIGHT-ORG-CODE.
           03 LINE 11 COLUMN 5   VALUE "FLIGHT DESTIN CODE    : ".
           03 LINE 11 COLUMN 30  PIC 99 USING  WS-FLIGHT-DES-CODE.
       01 SC-SEATS-FILLED.
           03 LINE 14 COLUMN 5  VALUE "SEATS FILLED          : ".
           03 LINE 14 COLUMN 30 PIC 999 USING  WS-SEATS-FILLED.
       01 SC-SEAT-TABLE.
           03 LINE 16 COLUMN 5  VALUE "SEAT ROW              : ".
           03 LINE 16 COLUMN 30 PIC 99 USING WS-SEAT-ROW.
           03 LINE 17 COLUMN 5  VALUE "SEAT COLUMN           : ".
           03 LINE 17 COLUMN 30 PIC 9  USING WS-SEAT-COLUMN.
       01 SC-SEAT-ENTRY.
           03 LINE 18 COLUMN 5  VALUE "SEAT NUMBER           : ".
           03 LINE 18 COLUMN 30 PIC 9999 USING WS-SEAT-NUMBER.
      *
       01 RECORD-AMOUNT.
           03 LINE 20 COLUMN 5   VALUE "RECORD NUMBER         : ".
           03 LINE 20 COLUMN 30  PIC 99 USING WS-RECORD-COUNTER.
       01 SC-INVALID-KEY.
           03 LINE 21 COLUMN 5   
               VALUE "INVALID KEY  FLIGHT NUMBER  'ALREADY EXITS'".
       01 RESPONCE.
           03 LINE 23 COLUMN 5   
               VALUE "IS IT O.K TO WRITE RECORD TO FILE  >".
       01 RESPONCE-LINE.
           03 LINE 23 COLUMN 41  PIC X USING WS-RESPONCE AUTO.
       01 RESPONCE-BLANK.
           03 LINE 23 COLUMN 5   BLANK LINE.
           03 LINE 21 COLUMN 5   BLANK LINE.
      *
       01 BLANK-SCREEN.
           03 BLANK SCREEN.
       01 PROG-DISCRIPTION.
           03 LINE 1 COLUMN 5  VALUE 
                "THIS PROGRAM PRINTS AND/OR UPDATES THE CONTENTS 'FLIGHT
      -       " FILE' AS DIRECTED".
       01 INPUT-DISCRIPTION.
           03 LINE 3 COLUMN 5  HIGHLIGHT VALUE 
              "THIS SCREEN ALLOWS ENTRY OF 'FLIGHT' FILE DETAILS".
       01 PROG-FINISH.
           03 LINE 24  COLUMN 5 VALUE "TASK COMPLETE".
       01 ERROR-MESSG.
           03 LINE 20  COLUMN 5 VALUE 
              "FILE WOULD NOT OPEN  :FLIGHT :PLANE :PORT :PRINT:".
           03 LINE 21  COLUMN 5 VALUE
              "STATUS ERROR CODES   :       :      :     :     :".
           03 LINE 21  COLUMN 29  HIGHLIGHT PIC XX
              FROM WS-FLIGHT-STATUS.
           03 LINE 21  COLUMN 37  HIGHLIGHT PIC XX
              FROM WS-AIRPLANE-STATUS.
           03 LINE 21  COLUMN 43  HIGHLIGHT PIC XX
              FROM WS-AIRPORT-STATUS.
           03 LINE 21  COLUMN 50  HIGHLIGHT PIC XX
              FROM WS-PRINTER-STATUS.
      *******************************************
      *
       PROCEDURE DIVISION.
       0000-MAIN.
           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.
           OPEN OUTPUT  AIR-PRINT
                INPUT   AIRPORT
                INPUT   AIRPLANE
                I-O     FLIGHT.
                IF WS-FLIGHT-STATUS    = "00" AND
                   WS-AIRPLANE-STATUS  = "00" AND
                   WS-AIRPORT-STATUS   = "00" AND
                   WS-PRINTER-STATUS   = "00" 
                       PERFORM 1000-MENU UNTIL WS-STOP-RUN-FLAG = "S"
                   ELSE
                       DISPLAY ERROR-MESSG.
           DISPLAY PROG-FINISH.
           CLOSE       FLIGHT
                       AIRPLANE
                       AIRPORT
                       AIR-PRINT.
           STOP RUN.
      *
      *******************************************
      *
       1000-MENU.
           ACCEPT WS-REAL-DATE FROM DATE.
           MOVE WS-REAL-DAY   TO WS-TEMP-DAY.
           MOVE WS-REAL-MONTH TO WS-TEMP-MONTH.
           MOVE WS-REAL-YEAR  TO WS-TEMP-YEAR.

           MOVE " " TO WS-RESPONCE.
           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.
           DISPLAY MENU.
           ACCEPT  MENU-RESPONCE.
           IF WS-RESPONCE-C 
                  PERFORM 2000-CHANGE-FLIGHT
             ELSE 
             IF WS-RESPONCE-R
                    PERFORM 3000-REPORT-FLIGHT
               ELSE
               IF WS-RESPONCE-Q
                      MOVE "S" TO WS-STOP-RUN-FLAG.
      *
      *************************************************
      *
       2000-CHANGE-FLIGHT.
           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.
           DISPLAY INPUT-DISCRIPTION.
           MOVE ZERO TO WS-FLIGHT-NUMBER.
           DISPLAY SC-FLIGHT-NUMBER.
           ACCEPT  SC-FLIGHT-NUMBER.
           MOVE WS-FLIGHT-NUMBER TO ER-FLIGHT-NUMBER.
           READ FLIGHT INTO WS-FLIGHT-REC
                 INVALID KEY MOVE "F" TO WS-ABORT-FLAG.

           MOVE 1 TO WS-SEAT-ROW.
           MOVE 1 TO WS-SEAT-COLUMN.

           DISPLAY SC-FLIGHT-REC.
           DISPLAY SC-FLIGHT-PLAN.
           DISPLAY SC-SEATS-FILLED.
           DISPLAY SC-SEAT-TABLE.
           DISPLAY SC-SEAT-ENTRY.

           ACCEPT  SC-FLIGHT-REC.
           PERFORM 2100-FLIGHT-PLAN
                   UNTIL WS-FLIGHT-ORG-CODE NOT EQUAL WS-FLIGHT-DES-CODE.
           PERFORM 2200-SEATS-TABLE
                   UNTIL WS-SEAT-ROW IS GREATER THAN 10.
           MOVE " " TO WS-RESPONCE.
           PERFORM 2300-RESPONCE UNTIL WS-RESPONCE-YN.
           IF WS-RESPONCE-Y
                 MOVE WS-FLIGHT-REC TO ER-FLIGHT-REC
                 WRITE ER-FLIGHT-REC INVALID KEY
                    DISPLAY SC-INVALID-KEY.
      *
      ********************************************
      *
       2100-FLIGHT-PLAN.
           ACCEPT SC-FLIGHT-PLAN.
      *
       2200-SEATS-TABLE.
           MOVE 1 TO WS-SEAT-COLUMN.
           PERFORM 2210-SEATS-ENTRY 
                        UNTIL WS-SEAT-COLUMN IS GREATER THAN 6.
           ADD 1 TO WS-SEAT-ROW.
      *
       2210-SEATS-ENTRY.
           MOVE WS-SEAT (WS-SEAT-ROW WS-SEAT-COLUMN) TO WS-SEAT-NUMBER.
           DISPLAY SC-SEAT-TABLE.
           DISPLAY SC-SEAT-ENTRY.
           ACCEPT  SC-SEAT-ENTRY.
           IF WS-SEAT (WS-SEAT-ROW WS-SEAT-NUMBER)  EQUAL ZERO AND
                            WS-SEAT-NUMBER NOT      EQUAL ZERO
                            ADD 1 TO WS-SEATS-FILLED
                            DISPLAY  SC-SEATS-FILLED
             ELSE
             IF WS-SEAT (WS-SEAT-ROW WS-SEAT-NUMBER) NOT EQUAL ZERO AND
                               WS-SEAT-NUMBER            EQUAL ZERO
                               SUBTRACT 1 FROM WS-SEATS-FILLED
                               DISPLAY    SC-SEATS-FILLED.
           MOVE WS-SEAT-NUMBER TO WS-SEAT (WS-SEAT-ROW WS-SEAT-COLUMN).
           ADD 1 TO WS-SEAT-COLUMN.
      *
      ******************************************
      *
       2300-RESPONCE.
           DISPLAY RESPONCE.
           ACCEPT  RESPONCE-LINE.
      *
      *************************************************
      *
       3000-REPORT-FLIGHT.
           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.

           MOVE ZERO TO WS-RECORD-COUNTER.
           PERFORM 3100-READ-AIRPLANE UNTIL WS-AIRPLANE-END.
           MOVE ZERO TO WS-FLIGHT-NUMBER.
           START FLIGHT KEY IS GREATER THAN WS-FLIGHT-NUMBER 
                 INVALID KEY DISPLAY SC-INVALID-KEY.

           MOVE ZERO TO WS-PAGE-COUNTER.
           MOVE 56   TO WS-LINE-COUNTER.
           PERFORM 3200-READ-FLIGHT UNTIL WS-FLIGHT-END.

           MULTIPLY WS-NUMBER-OF-FLIGHTS BY 60
                                  GIVING WS-TOTAL-SEATS.
           MULTIPLY WS-TOTAL-SEATS-USED  BY 100
                                  GIVING WS-AVG-PERCENT-SEATS-FILLED.
           DIVIDE WS-AVG-PERCENT-SEATS-FILLED BY WS-TOTAL-SEATS
                                  GIVING WS-AVG-PERCENT-SEATS-FILLED.

           PERFORM 3300-FLIGHT-TOTALS.
      *
      ******************************************************
      *
       3100-READ-AIRPLANE.
           ADD 1 TO WS-RECORD-COUNTER.
           READ AIRPLANE AT END
              MOVE "S" TO WS-AIRPLANE-END-FLAG.
           IF NOT WS-AIRPLANE-END
              MOVE ER-AIRPLANE-REC TO 
                   WS-AIRPLANE-ARRAY (WS-RECORD-COUNTER).
      *
      ******************************************************
      *
       3200-READ-FLIGHT.
           MOVE SPACE TO WS-ABORT-FLAG.
           READ FLIGHT NEXT RECORD
                INTO WS-FLIGHT-REC
                AT END MOVE "S" TO WS-FLIGHT-END-FLAG.
           IF NOT WS-FLIGHT-END
                MOVE WS-FLIGHT-ORG-CODE TO ER-AIRPORT-CODE
                READ AIRPORT 
                     INVALID KEY MOVE "A" TO WS-ABORT-FLAG
                END-READ
                MOVE ER-AIRPORT-NAME TO WS-FLIGHT-DEPARTURES

                MOVE WS-FLIGHT-DES-CODE TO ER-AIRPORT-CODE
                READ AIRPORT
                     INVALID KEY MOVE "B" TO WS-ABORT-FLAG
                END-READ
                MOVE ER-AIRPORT-NAME TO WS-FLIGHT-ARRIVALS

                SET WS-RECORD-COUNTER TO 1
                SEARCH WS-AIRPLANE-ARRAY
                    WHEN WS-AIRPLANE-CODE (WS-RECORD-COUNTER) EQUAL
                    WS-AIRPLANE-MK-CODE
                    MOVE WS-MAKE-MODEL TO WS-AIRPLANE-NAME
                END-SEARCH
                ADD 1 TO WS-NUMBER-OF-FLIGHTS
                ADD WS-SEATS-FILLED TO WS-TOTAL-SEATS-USED
                MULTIPLY WS-SEATS-FILLED BY 10
                            GIVING WS-PERCENT-SEATS-FILLED
                DIVIDE WS-PERCENT-SEATS-FILLED BY 6
                            GIVING WS-PERCENT-SEATS-FILLED

                IF WS-LINE-COUNTER GREATER THAN 55
                        PERFORM 3210-PRINT-FLIGHT-TITLE
                        PERFORM 3220-PRINT-FLIGHT-REC
                  ELSE
                        PERFORM 3220-PRINT-FLIGHT-REC

           END-IF.
      *
      *************************************************************
      *
       3210-PRINT-FLIGHT-TITLE.
           ADD 1 TO WS-PAGE-COUNTER.
           MOVE 2 TO WS-LINE-COUNTER.

           MOVE SPACES TO OUT-PRINT-REC.
           MOVE WS-PAGE-COUNTER TO WS-PRT-PAGE-COUNTER.
           MOVE WS-TEMP-DATE TO WS-PRT-TEMP-DATE.
           MOVE PRINT-PROG-TITLE TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER PAGE.

           MOVE SPACES TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.
      *
      **************************************************************
      *
       3220-PRINT-FLIGHT-REC.
           MOVE WS-FLIGHT-NUMBER TO WS-PRT-AIRPLANE-ID.
           MOVE SPACES TO OUT-PRINT-REC.
           MOVE PRT-AIRPLANE-ID TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.

           MOVE WS-AIRPLANE-NAME TO WS-PRT-AIRPLANE-NAME.
           MOVE SPACES TO OUT-PRINT-REC.
           MOVE PRT-AIRPLANE-NAME TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.

           MOVE WS-FLIGHT-DEPARTURES TO WS-PRT-AIRPORT-ORG.
           MOVE SPACES TO OUT-PRINT-REC.
           MOVE PRT-AIRPORT-ORG TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.

           MOVE WS-FLIGHT-ARRIVALS TO WS-PRT-AIRPORT-DES.
           MOVE SPACES TO OUT-PRINT-REC.
           MOVE PRT-AIRPORT-DES TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.

           MOVE WS-SEATS-FILLED TO WS-PRT-SEATS-FILLED.
           MOVE SPACES TO OUT-PRINT-REC.
           MOVE PRT-SEATS-FILLED TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.

           MOVE WS-PERCENT-SEATS-FILLED TO WS-PRT-PERCENT-SEATS-FILLED.
           MOVE SPACES TO OUT-PRINT-REC.
           MOVE PRT-PERCENT-SEATS-FILLED TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 2.

           ADD 7 TO WS-LINE-COUNTER.
      *
      **************************************************************
      *
       3300-FLIGHT-TOTALS.
           MOVE SPACES TO OUT-PRINT-REC.
           MOVE WS-NUMBER-OF-FLIGHTS TO WS-PRT-NUMBER-OF-FLIGHTS.
           MOVE PRT-NUMBER-OF-FLIGHTS TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.

           MOVE SPACES TO OUT-PRINT-REC.
           MOVE WS-TOTAL-SEATS-USED TO WS-PRT-TOTAL-SEATS-USAGE.
           MOVE PRT-TOTAL-SEATS-USAGE TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.

           MOVE SPACES TO OUT-PRINT-REC.
           MOVE WS-AVG-PERCENT-SEATS-FILLED TO 
                WS-PRT-AVG-PERC-SEATS-FILLED.
           MOVE PRT-AVG-PERCENT-SEATS-FILLED TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.

           MOVE SPACES TO OUT-PRINT-REC.
           WRITE OUT-PRINT-REC AFTER 1.
      *
      **************************************************************
