      *********************************
      **    Yet another cobol program**
      ** this one is for sorts       **
      **    and ctrl-breaks          **
      *********************************

      *****   **************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.     CB02DJC.
       AUTHOR.         DAVID-C.
       DATE-WRITTEN.   5/26/99.
      *****  ***************************


      **********************************
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SOURCE-COMPUTER.   SLAP-HAPPY-WIN-BOX.
      *OBJECT-COMPUTER.   THE-SAME-MICROSLOP-BOX-IT-WAS-WRITTEN-ON.
      *************

      * I LIKE TO TEASE MY COBOL INSTRUCTOR ABOUT WIN95
      * ANYWAY, THE ONLY CHANGES I MADE WERE TO THE FILE ASSIGNS
      * ALSO, C. , I APOLOGISE FOR THE CARRAGE RETURNS, MICROFOCUS
      *  PUT THEM IN THERE, AND NRCOBOL SEEMS TO IGNORE THEM TOO! 8)

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SORTWORK-FILE ASSIGN 'RAM:DJC.DAT'
           FILE STATUS IS SORTWORK-FILE-STATUS.

           SELECT SOURCE-FILE ASSIGN TO 'RAM:SET2.DAT'
           FILE STATUS IS SOURCE-FILE-FILE-STATUS.

           SELECT SORTED-FILE ASSIGN TO 'RAM:SORTED.SRT'
           FILE STATUS IS SORTED-FILE-STATUS.

           SELECT PRINTER-FILE ASSIGN TO 'RAM:CB02DJC.RPT'
           FILE STATUS IS PRINTER-FILE-STATUS.

      **********************************

       DATA DIVISION.
       FILE SECTION.

       FD  SOURCE-FILE.
       01  JOB-RECORD         PIC X(67).

       FD  PRINTER-FILE.
       01  PRINTER-RECORD     PIC X(73).

       SD  SORTWORK-FILE.
       01  SWK-RECORD.
           05 FILLER          PIC X(8).
           05 SWR-JOB-NUM     PIC X(2).
           05 FILLER          PIC X(57).

       FD  SORTED-FILE.
       01  SORTED-RECORD.
           05  FILLER         PIC X(8).
           05  SF-JOB-NUMBER     PIC X(2).
           05  SF-SUB-ASM-NUM    PIC X(2).
           05  FILLER         PIC X(40).
           05  SF-SUB-ASM-CODE   PIC 9(1).
           05  FILLER         PIC X(4).
           05  SF-NEEDED      PIC 9(2).
           05  FILLER         PIC X(4).
           05  SF-SUB-ASM-COST   PIC 99V99.

       WORKING-STORAGE SECTION.

       01  WS-STATUS.
           05 SORTWORK-FILE-STATUS    PIC 99.
           05 SOURCE-FILE-FILE-STATUS PIC 99.
           05 SORTED-FILE-STATUS      PIC 99.
           05 PRINTER-FILE-STATUS     PIC 99.

       01  HEADING-1.
           05  CC             PIC X(1).
           05  H1-DATE        PIC X(8) value "18/04/99".
           05  FILLER         PIC X(17) VALUE SPACES.
           05  FILLER         PIC X(19) VALUE
                        'JOB ASSEMBLY REPORT'.
           05  FILLER         PIC X(18) VALUE SPACES.
           05  FILLER         PIC X(5)  VALUE 'PAGE '.
           05  H1-PAGE-NUM    PIC ZZ9.

       01  HEADING-2          PIC X(73)  VALUE
           '  JOB   SUB-ASSEMBLY   SUB-ASSEMBLY    QUANTITY  SUB-ASSEMB
      -'LY  TOTAL    '.

       01  HEADING-3          PIC X(73)  VALUE
           'NUMBER     NUMBER         STATUS        NEEDED       COST
      -'     COST'.

       01  DETAIL-LINE.

           05  CC             PIC X(1).
           05  FILLER         PIC X(2) VALUE SPACES.
           05  DL-JOB-NUM     PIC X(2).
           05  FILLER         PIC X(9) VALUE SPACES.
           05  DL-ASM-NUM     PIC X(2).
           05  FILLER         PIC X(7) VALUE SPACES.
           05  DL-ASM-STAT    PIC X(13).
           05  FILLER         PIC X(7) VALUE SPACES.
           05  DL-NEEDED      PIC Z9.
           05  FILLER         PIC X(8) VALUE SPACES.
           05  DL-SUB-COST    PIC ZZ.99.
           05  FILLER         PIC X(5)    VALUE SPACES.
           05  DL-TOTAL-COST  PIC Z,ZZZ.99.

       01  TOTAL-ONE.

           05  CC             PIC X(1).
           05  FILLER         PIC X(28)    VALUE SPACES.
           05  FILLER         PIC X(11)    VALUE
               'JOB NUMBER '.
           05  T1-JOB-NUM     PIC XX.
           05  FILLER         PIC X(3)     VALUE ' - '.
           05  FILLER         PIC X(10)    VALUE 'TOTAL COST'.
           05  FILLER         PIC X(7)     VALUE SPACES.
           05  T1-JOB-TOTAL   PIC ZZ,ZZZ.99.
           05  FILLER         PIC X(2)     VALUE '* '.

       01  TOTAL-TWO.
           05  CC             PIC X(1).
           05  FILLER         PIC X(28)    VALUE SPACES.
           05  FILLER         PIC X(32)    VALUE
             'FINAL TOTAL - ALL JOBS         '.
           05  T2-FINAL-TOTAL PIC ZZZ,ZZZ.99.
           05  FILLER         PIC X(2)     VALUE '**'.


       01  FINAL-LINE.
           05  CC             PIC X(1).
           05  F1-DASHES      PIC X(43)    VALUE
             '-------------------------------------------'.
       01  END-MSG.
           05  CC             PIC X(1).
           05  F1-THE-END     PIC X(43)    VALUE
             'JOB ASSEMBLY REPORT - NO RECORDS TO PROCESS'.


       01  EOF                PIC X(1)     VALUE 'N'.
           88  NO-MORE-RECORDS             VALUE 'Y'.


       01  COUNTERS-AND-STUFF.
           05  LINE-CTR       PIC 9(2)     VALUE 99 USAGE IS COMP.
             88  FULL-PAGE                 VALUE 35 THRU 99.
           05  PAGE-NUMBER    PIC 9(3)     VALUE 0  USAGE IS COMP.
           05  AD-ASM-TOTAL   PIC 9(4)V99  VALUE 0  USAGE IS COMP.
           05  AD-JOB-TOTAL   PIC 9(5)V99  VALUE 0  USAGE IS COMP.
           05  AD-FINAL-TOTAL PIC 9(6)V99  VALUE 0  USAGE IS COMP.


       01  PREVIOUS-FIELDS.
           05  PREV-JOB-NUM   PIC X(2).


       01  PROGRAM-TABLES.
           05  JOB-TABLE PIC X(13) OCCURS 4 TIMES.
           05  JOB-CONSTANTS REDEFINES JOB-TABLE.
              07  FILLER      PIC X(13)    VALUE 'IN WAREHOUSE '.
              07  FILLER      PIC X(13)    VALUE 'NOT AVAILABLE'.
              07  FILLER      PIC X(13)    VALUE 'ON ORDER     '.
              07  FILLER      PIC X(13)    VALUE 'ON BACKORDER '.


      ***********************************
      * NOW FOR THE PROCEEEEDURE DIV.   *
      ***********************************

       PROCEDURE DIVISION.
       DRIVER-ROUTINE.
           SORT    SORTWORK-FILE
                   ASCENDING KEY SWR-JOB-NUM
                   USING  SOURCE-FILE
                   GIVING SORTED-FILE.
           PERFORM OPEN-ROUTINE.
           PERFORM READ-ROUTINE.
           MOVE SF-JOB-NUMBER TO PREV-JOB-NUM.
           PERFORM PROCESS-ROUTINE UNTIL NO-MORE-RECORDS.
           PERFORM JOB-TOTAL-ROUTINE.
           PERFORM TOTAL-ROUTINE.
           PERFORM CLOSE-ROUTINE.
           STOP RUN.

       OPEN-ROUTINE.
           OPEN INPUT  SORTED-FILE.
           OPEN OUTPUT PRINTER-FILE.
           MOVE CURRENT-DATE TO H1-DATE.


       READ-ROUTINE.
           READ SORTED-FILE
                AT END
                MOVE 'Y' TO EOF.

       PROCESS-ROUTINE.
           IF  FULL-PAGE
               PERFORM HEADING-ROUTINE.

           MOVE SPACES TO DETAIL-LINE.

           IF  SF-JOB-NUMBER NOT = PREV-JOB-NUM
               PERFORM JOB-TOTAL-ROUTINE.

           MOVE SF-JOB-NUMBER TO DL-JOB-NUM.
           MOVE SF-SUB-ASM-NUM TO DL-ASM-NUM.

           MOVE JOB-TABLE (SF-SUB-ASM-CODE) TO
                DL-ASM-STAT.
           MOVE SF-NEEDED TO DL-NEEDED.

           MULTIPLY SF-NEEDED BY SF-SUB-ASM-COST GIVING AD-ASM-TOTAL.
           MOVE AD-ASM-TOTAL TO DL-TOTAL-COST.
           ADD AD-ASM-TOTAL TO AD-JOB-TOTAL.

           ADD 1 TO LINE-CTR.
           PERFORM READ-ROUTINE.

       HEADING-ROUTINE.
           ADD 1 TO PAGE-NUMBER.
           MOVE PAGE-NUMBER TO H1-PAGE-NUM.
           WRITE PRINTER-RECORD FROM HEADING-1 AFTER PAGE.
           WRITE PRINTER-RECORD FROM HEADING-2 AFTER 2.
           WRITE PRINTER-RECORD FROM HEADING-3 AFTER 1.
           MOVE SPACES TO PRINTER-RECORD.
           WRITE PRINTER-RECORD AFTER 1.
           MOVE 0 TO LINE-CTR.

       JOB-TOTAL-ROUTINE.
           MOVE PREV-JOB-NUM TO T1-JOB-NUM.
           MOVE AD-JOB-TOTAL TO T1-JOB-TOTAL.
           WRITE PRINTER-RECORD FROM TOTAL-ONE AFTER 2.
           MOVE SPACES TO PRINTER-RECORD.
           WRITE PRINTER-RECORD AFTER 1.
           ADD 3 TO LINE-CTR.
           ADD AD-JOB-TOTAL TO AD-FINAL-TOTAL.
           MOVE 0 TO AD-JOB-TOTAL.
           MOVE SF-JOB-NUMBER TO PREV-JOB-NUM.

       TOTAL-ROUTINE.
           MOVE AD-FINAL-TOTAL TO T2-FINAL-TOTAL.
           WRITE PRINTER-RECORD FROM TOTAL-TWO AFTER 1.
           WRITE PRINTER-RECORD FROM FINAL-LINE AFTER 2.
           WRITE PRINTER-RECORD FROM END-MSG AFTER 1.

       CLOSE-ROUTINE.
           CLOSE SORTED-FILE.
           CLOSE PRINTER-FILE.


