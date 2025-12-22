       IDENTIFICATION DIVISION.
       PROGRAM-ID. ERRANT.
       AUTHOR. MALCOLM FLEET.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SORTED-VALID-FILE ASSIGN TO 'A:ZENSD.DAT'
                ORGANIZATION LINE SEQUENTIAL.
           SELECT CUST-MAST-FILE ASSIGN TO  'A:CUSTMAST.MF'
                ORGANIZATION LINE SEQUENTIAL.
           SELECT STOCK-MAST-FILE ASSIGN TO 'A:STCKMAST.DAT'
                ORGANIZATION INDEXED
                ACCESS MODE RANDOM
                RECORD KEY ST-PART-NUMBER.
           SELECT NEW-CUST-MAST-FILE ASSIGN TO 'A:ZENNF.DAT'
                ORGANIZATION LINE SEQUENTIAL.
           SELECT ERROR-FILE ASSIGN TO PRINTER.
      *
      *******************************************
      *

       DATA DIVISION.
       FILE SECTION.
       FD  SORTED-VALID-FILE.
       01  S-I-REC.
           03 S-REC-TYPE        PIC X.
           03 S-CUST-CODE       PIC X(5).
              88 END-OF-S-VALID-FILE VALUE HIGH-VALUES.
           03 S-PART-NUMBER     PIC X(6).
           03 S-ISS-RECEIPT-QUANT PIC 9(4).

       01  S-DELETION-REC.
           03                    PIC X(6).

       01  S-CREATION-REC.
           03                    PIC X(6).
           03 S-CUSTOMER-NAME    PIC X(20).
           03 S-CUSTOMER-ADDRESS PIC X(60).
           03 S-CUSTOMER-BALANCE PIC S9(7)V99.
           03 S-CREDIT-LIMIT     PIC X(7).

       FD CUST-MAST-FILE.
       01 CUST-MAST-REC.
           03 MAST-CUST-CODE     PIC X(5).
              88 END-OF-C-MAST-FILE VALUE HIGH-VALUES.
           03 MAST-CUST-NAME     PIC X(20).
           03 MAST-CUST-ADDRESS  PIC X(60).
           03 MAST-CUST-BALANCE  PIC S9(7)V99.
           03 MAST-CREDIT-LIMIT  PIC X(7).
           03 MAST-LAST-MOVE-DATE.
              05 M-L-DAY         PIC 9(2).
              05 M-L-MONTH       PIC 9(2).
              05 M-L-YEAR        PIC 9(2).

       FD STOCK-MAST-FILE.
       01 STOCK-MAST-REC.
           03 ST-PART-NUMBER     PIC X(6).
           03 ST-PART-DESC       PIC X(19).
           03 ST-SUPP-CODE       PIC 9(2).
           03 ST-FREE-STOCK      PIC 9(6).
           03 ST-MIN-STOCK-LEV   PIC 9(4).
           03 ST-LAST-MOVE-DATE  PIC 9(6).
           03 ST-SELLING-PRICE   PIC 9(4)V99.

       FD NEW-CUST-MAST-FILE.
       01 NEW-CUST-REC.
          03 N-MAST-CUST-CODE    PIC X(5).
          03 N-MAST-CUST-NAME    PIC X(20).
          03 N-MAST-CUST-ADDRESS PIC X(60).
          03 N-MAST-CUST-BALANCE PIC S9(7)V99.
          03 N-M-L-MOVE-DAY      PIC 99.
          03 N-M-L-MOVE-MONTH    PIC 99.
          03 N-M-L-MOVE-YEAR     PIC 99.

       FD ERROR-FILE
           LINAGE IS 60 LINES
           WITH FOOTING AT 56
           LINES AT TOP 2
           LINES AT BOTTOM 4.
       01 ERROR-REC            PIC X(130).
      *
      *******************************************
      *
       WORKING-STORAGE SECTION.
       78 original value 1.                 *> flag code change

       01 W-LINE-COUNT     PIC 99 VALUE ZERO.
       01 W-PAGE-COUNT     PIC 99 VALUE 0.
       01 W-REC-COUNT      PIC 9(4) VALUE ZERO.
       01 STOCK-VALUE      PIC 9(7)V99.
       01 W-DOS-DATE.
          03 W-DOS-YEAR    PIC 99.
          03 W-DOS-MONTH   PIC 99.
          03 W-DOS-DAY     PIC 99.
       01 W-IN-DATE.
          03 W-IN-YEAR     PIC 99.
          03 W-IN-MONTH    PIC 99.
          03 W-IN-DAY      PIC 99.

       01 W-HEADING-1.
          03               PIC X(77) VALUE
            "                                   **** ZENITH PAINTS -ERR0
      -"R REPORT ****".
          03 W-HDG-DAY     PIC 99.
          03               PIC X VALUE "/".
          03 W-HDG-MONTH   PIC 99.
          03               PIC X VALUE "/".
          03 W-HDG-YEAR    PIC 99.
          03               PIC X(8) VALUE
            "  PAGE: ".
          03 PRINT-PAGE-COUNT   PIC Z(4)9.

       01 W-HEADING-2.
          03               PIC X(80) VALUE
            "                                TRANSACTIONS NOT UPDATED TO
      -" CUSTOMER MASTER FILE".

       01 W-HEADING-3.
          03               PIC X(70) VALUE
            "  RECORD     CUSTOMER     CUSTOMER                 PART
      -"  ERROR    ".

       01 W-HEADING-4.
          03               PIC X(70) VALUE
            "  TYPE       CODE         NAME                     NUMBER
      -"  MESSAGE  ".

       01 DETAIL-LINE.
          03                 PIC X(4) VALUE SPACES.
          03 PRINT-REC-TYPE  PIC X.
          03                 PIC X VALUE SPACES.
          03 PRINT-CUST-CODE PIC 9(5).
          03                 PIC X(8) VALUE SPACES.
          03 PRINT-CUST-NAME PIC X(20).
          03                 PIC X(5) VALUE SPACES.
          03 PRINT-PART-NUM  PIC X(6).
          03                 PIC X(4) VALUE SPACES.
          03 ERROR-MESSAGE   PIC X(45).

       01 TOTAL-LINE.
          03                 PIC X(66) VALUE
            "                                TOTAL NUMBER OF INVALID REC
      -"ORDS = ".
          03 PRINT-TOTAL-RECORD-COUNT PIC Z(5)9.
      *
      *******************************************
      *

       PROCEDURE DIVISION.
       MAIN-CONTROL.
           PERFORM INITIAL-PROCESS
           PERFORM UPDATE-PROCESS UNTIL END-OF-S-VALID-FILE AND
                                        END-OF-C-MAST-FILE
           PERFORM FINAL-PROCESS
           STOP RUN.

       INITIAL-PROCESS.
           OPEN INPUT  SORTED-VALID-FILE
                       CUST-MAST-FILE
                       STOCK-MAST-FILE
                OUTPUT NEW-CUST-MAST-FILE
                       ERROR-FILE
            ACCEPT W-DOS-DATE FROM DATE
            MOVE W-DOS-YEAR TO W-HDG-YEAR
            MOVE W-DOS-MONTH TO W-HDG-MONTH
            MOVE W-DOS-DAY TO W-HDG-DAY
            PERFORM NEW-HEADINGS
            PERFORM READ-SORTED-VALID-FILE
            PERFORM READ-CUST-MAST-FILE.

       UPDATE-PROCESS.
            EVALUATE TRUE
                WHEN S-CUST-CODE > MAST-CUST-CODE
                     PERFORM UPDATE-MASTER
                WHEN S-CUST-CODE < MAST-CUST-CODE
                     PERFORM PROCESS-NEW-CUST
                WHEN S-CUST-CODE = MAST-CUST-CODE
                     PERFORM UPDATE-TRANS-TO-MAST
            END-EVALUATE.

       NEW-HEADINGS.
            MOVE 0 TO W-LINE-COUNT
            ADD 1 TO W-PAGE-COUNT
            MOVE W-PAGE-COUNT TO PRINT-PAGE-COUNT
            WRITE ERROR-REC FROM W-HEADING-1 AFTER PAGE
            WRITE ERROR-REC FROM W-HEADING-2 AFTER 2
            WRITE ERROR-REC FROM W-HEADING-3 AFTER 2
            WRITE ERROR-REC FROM W-HEADING-4 AFTER 1.

       READ-SORTED-VALID-FILE.
            READ SORTED-VALID-FILE AT END
                   MOVE HIGH-VALUES TO S-CUST-CODE
            END-READ.

       READ-CUST-MAST-FILE.
            READ CUST-MAST-FILE AT END
                   MOVE HIGH-VALUES TO MAST-CUST-CODE
            END-READ.

       UPDATE-MASTER.
            WRITE NEW-CUST-REC FROM CUST-MAST-REC
                  PERFORM READ-CUST-MAST-FILE.

       PROCESS-NEW-CUST.
            IF S-REC-TYPE = 'C' THEN
               MOVE S-CUST-CODE TO N-MAST-CUST-CODE
               MOVE S-CUSTOMER-NAME TO N-MAST-CUST-NAME
               MOVE S-CUSTOMER-ADDRESS TO N-MAST-CUST-ADDRESS
               MOVE S-CUSTOMER-BALANCE TO N-MAST-CUST-BALANCE
               MOVE W-DOS-YEAR TO N-M-L-MOVE-YEAR
               MOVE W-DOS-MONTH TO N-M-L-MOVE-MONTH
               MOVE W-DOS-DAY TO N-M-L-MOVE-DAY
               WRITE NEW-CUST-REC
               PERFORM READ-SORTED-VALID-FILE
            ELSE
               MOVE 'INVALID RECORD TYPE- SHOULD BE TYPE C'
                     TO ERROR-MESSAGE
               PERFORM READ-SORTED-VALID-FILE
            END-IF.

       UPDATE-TRANS-TO-MAST.

      $if original defined
            EVALUATE TRUE
               WHEN S-REC-TYPE = 'I' OR 'R' PERFORM ISSUE-REC-UPDATE
               WHEN S-REC-TYPE = 'C' PERFORM CREATION-UPDATE
               WHEN S-REC-TYPE = 'D' PERFORM DELETE-RECORD
            END-EVALUATE.
      $else
            EVALUATE S-REC-TYPE
               WHEN 'I' PERFORM ISSUE-REC-UPDATE
               WHEN 'R' PERFORM ISSUE-REC-UPDATE
               WHEN 'C' PERFORM CREATION-UPDATE
               WHEN 'D' PERFORM DELETE-RECORD
               WHEN OTHER PERFORM PRINT-INVALID-TRANSACTION
            END-EVALUATE.
      $end

       ISSUE-REC-UPDATE.
            MOVE S-PART-NUMBER TO ST-PART-NUMBER
            READ STOCK-MAST-FILE
              INVALID KEY
                  MOVE 'PART NUMBER NOT FOUND- INVALID PART NUMBER'
                        TO ERROR-MESSAGE
                  PERFORM PRINT-ERROR
                  PERFORM READ-SORTED-VALID-FILE
              NOT INVALID KEY
                  MULTIPLY ST-SELLING-PRICE BY S-ISS-RECEIPT-QUANT
                        GIVING STOCK-VALUE
                  END-MULTIPLY
                          IF S-REC-TYPE = 'I' THEN
                    ADD STOCK-VALUE TO MAST-CUST-BALANCE
                ELSE
                     SUBTRACT STOCK-VALUE FROM MAST-CUST-BALANCE
                END-IF
                MOVE W-DOS-YEAR TO M-L-YEAR
                MOVE W-DOS-MONTH TO M-L-MONTH
                MOVE W-DOS-DAY TO M-L-DAY
                WRITE NEW-CUST-REC FROM CUST-MAST-REC
                PERFORM READ-SORTED-VALID-FILE.

       CREATION-UPDATE.
            MOVE 'INVALID RECORD TYPE- CANNOT BE C TYPE'
                  TO ERROR-MESSAGE
            PERFORM PRINT-ERROR
            PERFORM READ-SORTED-VALID-FILE.

       DELETE-RECORD.
            IF MAST-CUST-BALANCE NOT = 0 THEN
                MOVE 'CUSTOMER BALANCE NOT ZERO- DO NOT DELETE'
                      TO ERROR-MESSAGE
                PERFORM PRINT-ERROR
                PERFORM READ-SORTED-VALID-FILE
            ELSE
                PERFORM READ-SORTED-VALID-FILE
                PERFORM READ-CUST-MAST-FILE
            END-IF.

       PRINT-ERROR.
            MOVE S-REC-TYPE TO PRINT-REC-TYPE
            MOVE S-CUST-CODE TO PRINT-CUST-CODE
            MOVE S-PART-NUMBER TO PRINT-PART-NUM
            WRITE ERROR-REC FROM DETAIL-LINE AFTER 1
            MOVE SPACES TO ERROR-MESSAGE
            ADD 1 TO W-LINE-COUNT
              IF W-LINE-COUNT > 49 THEN
                 PERFORM NEW-HEADINGS
              ELSE
                  ADD 1 TO W-REC-COUNT
                  MOVE W-REC-COUNT TO PRINT-TOTAL-RECORD-COUNT
                  WRITE ERROR-REC FROM TOTAL-LINE AFTER 2
              END-IF.

       FINAL-PROCESS.
            CLOSE SORTED-VALID-FILE
            CLOSE CUST-MAST-FILE
            CLOSE STOCK-MAST-FILE
            CLOSE NEW-CUST-MAST-FILE
            CLOSE ERROR-FILE
            STOP RUN.

