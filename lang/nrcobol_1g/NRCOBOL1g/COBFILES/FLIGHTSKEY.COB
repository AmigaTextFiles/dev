       IDENTIFICATION DIVISION.
       PROGRAM-ID.   FLIGHTSKEY.
      *PROGRAM DISCRIPTION.
      * AIRPORTS -> AIRPORTS.OUT  FLIGHT.FIL -> FLIGHT.FIL.OUT
      * Translate line sequential data to index.
      *
      *AUTHOR.        cHArRiOTt.
      *INSTALLATION.
      *DATE-WRITTEN.  SEP 28th 96.
      *DATE-COMPILLED.
      *SECURITY.
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SOURCE-COMPUTER.   AMSTRAD 1512.
       OBJECT-COMPUTER.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT           AIRPORT-OUT
            ASSIGN TO        DISK
            ORGANIZATION IS  INDEXED
            ACCESS MODE  IS  DYNAMIC
            RECORD KEY   IS  OUT-AIRPORT-CODE
            FILE STATUS  IS  WS-AIRPORT-STATUS.

            SELECT           AIRPORT-IN
            ASSIGN TO        DISK
            ORGANIZATION IS  LINE SEQUENTIAL
            ACCESS MODE  IS  SEQUENTIAL
            FILE STATUS  IS  WS-AIRPORT2-STATUS.

            SELECT           FLIGHT-OUT
            ASSIGN TO        DISK
            ORGANIZATION IS  INDEXED
            ACCESS MODE  IS  DYNAMIC
            RECORD KEY   IS  OUT-FLIGHT-NUMBER
            FILE STATUS  IS  WS-FLIGHT-STATUS.

            SELECT           FLIGHT-IN
            ASSIGN TO        DISK
            ORGANIZATION IS  LINE SEQUENTIAL
            ACCESS MODE  IS  SEQUENTIAL
            FILE STATUS  IS  WS-FLIGHT2-STATUS.
      *
       DATA DIVISION.
       FILE SECTION.
       FD AIRPORT-OUT
            LABEL RECORD IS  STANDARD
            VALUE OF FILE-ID IS "AIRPORTS.OUT".
       01 OUT-AIRPORT-REC.
           03 OUT-AIRPORT-CODE      PIC 99.
           03 OUT-AIRPORT-NAME      PIC X(15).

       FD AIRPORT-IN
            LABEL RECORD IS  STANDARD
            VALUE OF FILE-ID IS "AIRPORTS".
       01 IN-AIRPORT-REC.
           03 IN-AIRPORT-CODE      PIC 99.
           03 IN-AIRPORT-NAME      PIC X(15).

      * ----------------------------------------------
       FD FLIGHT-OUT
           LABEL RECORD IS STANDARD
           VALUE OF FILE-ID IS "FLIGHTOUT.FIL".
       01 OUT-FLIGHT-REC.
           03 OUT-FLIGHT-NUMBER     PIC 9(5).
           03 OUT-AIRPLANE-ID       PIC 9(5).
           03 OUT-AIRPLANE-MK-CODE  PIC X(4).
           03 OUT-FLIGHT-ORG-CODE   PIC 99.
           03 OUT-FLIGHT-DES-CODE   PIC 99.
           03 OUT-SEATS-FILLED      PIC 999.
           03 OUT-SEATS-TABLE.
              05 OUT-SEAT-TABLE     OCCURS 10 TIMES.
                 08 OUT-SEAT-LETTER OCCURS  6 TIMES.
                    10 OUT-SEAT     PIC 9(4).

       FD FLIGHT-IN
           LABEL RECORD IS STANDARD
           VALUE OF FILE-ID IS "FLIGHT.FIL".
       01 IN-FLIGHT-REC.
           03 IN-FLIGHT-NUMBER     PIC 9(5).
           03 IN-AIRPLANE-ID       PIC 9(5).
           03 IN-AIRPLANE-MK-CODE  PIC X(4).
           03 IN-FLIGHT-ORG-CODE   PIC 99.
           03 IN-FLIGHT-DES-CODE   PIC 99.
           03 IN-SEATS-FILLED      PIC 999.
           03 IN-SEATS-TABLE.
              05 IN-SEAT-TABLE     OCCURS 10 TIMES.
                 08 IN-SEAT-LETTER OCCURS  6 TIMES.
                    10 IN-SEAT     PIC 9(4).

      * ----------------------------------------------
       WORKING-STORAGE SECTION.
       01 WS-STOP-RUN-FLAG PIC X VALUE SPACE.
       01 WS-STATUS-CODES.
           03 WS-AIRPORT-STATUS  PIC XX VALUE "00".
           03 WS-AIRPORT2-STATUS PIC XX VALUE "00".
           03 WS-FLIGHT-STATUS   PIC XX VALUE "00".
           03 WS-FLIGHT2-STATUS  PIC XX VALUE "00".

       01 WS-AIRPORT-DONE PIC X VALUE " ".
           88 WS-AIRPORT-END VALUE "Y".
       01 WS-FLIGHTS-DONE PIC X VALUE " ".
           88 WS-FLIGHTS-END VALUE "Y".

       01 WS-AIRPORT-COUNTER PIC 999 VALUE 0.
       01 WS-FLIGHTS-COUNTER PIC 999 VALUE 0.
       01 WS-RESPONCE PIC X VALUE SPACE.
      *
       SCREEN SECTION.

       01 BLANK-SCREEN.
           03 BLANK SCREEN.
       01 PROG-DISCRIPTION.
           03 LINE 1 COLUMN 5  VALUE
              "QUICK PROGRAM TO CREATE INDEX KEY FOR A SEQUENTIAL FILE".
       01 AIRPORT-RECORD.


       01 FLIGHTS-RECORD.
           03 LINE 16 COLUMN 5 VALUE "FLIGHT NUMBER : ".
           03 LINE 16 COLUMN 21 PIC 9(5) FROM IN-FLIGHT-NUMBER.
           03 LINE 17 COLUMN 5 VALUE "AIRPORT-ID    : ".
           03 LINE 17 COLUMN 21 PIC 9(5) FROM IN-AIRPLANE-ID.
           03 LINE 18 COLUMN 5 VALUE "AIRPLANE MK   : ".
           03 LINE 18 COLUMN 21 PIC X(4) FROM IN-AIRPLANE-MK-CODE.
           03 LINE 19 COLUMN 5 VALUE "FLIGHT ORIGIN : ".
           03 LINE 19 COLUMN 21 PIC 99 FROM IN-FLIGHT-ORG-CODE.
           03 LINE 20 COLUMN 5 VALUE "FLIGHT DESTIN : ".
           03 LINE 20 COLUMN 21 PIC 99 FROM IN-FLIGHT-DES-CODE.
           03 LINE 21 COLUMN 5 VALUE "SEATS FILLED  :".
           03 LINE 21 COLUMN 21 PIC 999 FROM IN-SEATS-FILLED.
           03 LINE 23 COLUMN 5 VALUE "PRESS ANY KEY ".
           03 LINE 23 COLUMN 21 PIC X TO WS-RESPONCE AUTO.

       01 PROG-FINISH.
           03 LINE 24  COLUMN 5 VALUE "TASK COMPLETE".
       01 ERROR-MESSG.
           03 LINE 20  COLUMN 5 VALUE
              "FILE WOULD NOT OPEN  :FLIGHT :FLIGH2:PORT :PORT2:".
           03 LINE 21  COLUMN 5 VALUE
              "STATUS ERROR CODES   :       :      :     :     :".
           03 LINE 21  COLUMN 29  HIGHLIGHT PIC XX
              FROM WS-FLIGHT-STATUS.
           03 LINE 21  COLUMN 37  HIGHLIGHT PIC XX
              FROM WS-FLIGHT2-STATUS.
           03 LINE 21  COLUMN 43  HIGHLIGHT PIC XX
              FROM WS-AIRPORT-STATUS.
           03 LINE 21  COLUMN 50  HIGHLIGHT PIC XX
              FROM WS-AIRPORT2-STATUS.
      *******************************************
      *
       PROCEDURE DIVISION.
       0000-MAIN.
           DISPLAY BLANK-SCREEN.
           DISPLAY PROG-DISCRIPTION.
           OPEN OUTPUT  AIRPORT-OUT
                OUTPUT  FLIGHT-OUT
                INPUT   AIRPORT-IN
                INPUT   FLIGHT-IN.

                IF WS-FLIGHT-STATUS    = "00" AND
                   WS-FLIGHT2-STATUS   = "00" AND
                   WS-AIRPORT-STATUS   = "00" AND
                   WS-AIRPORT2-STATUS  = "00" AND
                    PERFORM 1000-NEWKEYS UNTIL WS-STOP-RUN-FLAG = "S"
                ELSE
                   DISPLAY ERROR-MESSG.
           DISPLAY PROG-FINISH.
           CLOSE       AIRPORT-OUT
                       AIRPORT-IN
                       FLIGHT-OUT
                       FLIGHT-IN.
           STOP RUN.
      *
      *******************************************
      *
       1000-NEWKEYS.
           PERFORM 2000-READ-AIRPORT UNTIL WS-AIRPORT-END.
           PERFORM 3000-READ-FLIGHTS UNTIL WS-FLIGHTS-END.
           MOVE "S" TO WS-STOP-RUN-FLAG.
      *
      *************************************************
      *
      *
       2000-READ-AIRPORT.
           ADD 1 TO WS-AIRPORT-COUNTER.
           READ AIRPORT-IN INTO OUT-AIRPORT-REC
           AT END
              MOVE "Y" TO WS-AIRPORT-DONE
              DISPLAY (11, 5) "AIRPORT RECORD DONE!".
           IF NOT WS-AIRPORT-END
              WRITE OUT-AIRPORT-REC
              DISPLAY (10, 5) "WRITING AIRPORT RECORD "
                      WS-AIRPORT-COUNTER.
      *
      *************************************************
      *
       3000-READ-FLIGHTS.
           ADD 1 TO WS-FLIGHTS-COUNTER.
           READ FLIGHT-IN INTO OUT-FLIGHT-REC
           AT END
              MOVE "Y" TO WS-FLIGHTS-DONE
              DISPLAY (14, 5) "FLIGHTS RECORD DONE!".
           IF NOT WS-FLIGHTS-END
              WRITE OUT-FLIGHT-REC
              DISPLAY (13, 5) "WRITING FLIGHTS RECORD "
                      WS-FLIGHTS-COUNTER
              DISPLAY FLIGHTS-RECORD
              ACCEPT  FLIGHTS-RECORD.
      *
      ************************************************

