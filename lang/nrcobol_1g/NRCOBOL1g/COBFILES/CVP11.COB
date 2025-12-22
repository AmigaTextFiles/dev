
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  CVP11.
      *PROGRAM DISCRIPTION.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.
       OBJECT-COMPUTER.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MATDAT ASSIGN TO DISK
           ORGANIZATION IS SEQUENTIAL
           FILE STATUS IS WS-FILE-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD MATDAT
            LABEL RECORD IS  STANDARD
            VALUE OF FILE-ID IS "FAJL.OUT".
       01 SLOG.
          05 STA  PIC 9.
          05 ODS  PIC X.
          05 CEN  PIC 9.
          05 BIN  PIC 9(4).
          05 GOD  PIC 9(2).
          05 IME  PIC X(12).
          05 PREZ PIC X(18).
          05 ADR PIC X(20).
      *
       WORKING-STORAGE SECTION.
       01 WS-FILE-STATUS  PIC XX VALUE "00".
       SCREEN SECTION.
       01 COLOR-SCREEN.
           02 BLANK-SCREEN.
       01 EKRAN.
           05 LINE 1 COLUMN 1  VALUE "VISA POSLOVNA SKOLA".
           05 LINE 2 COLUMN 1  VALUE "BEOGRAD".
           05 LINE 4 COLUMN 1  VALUE "Unos maticnih podataka studenata".
           05 LINE 6 COLUMN 1  VALUE "Broj indexa (9=kraj):".
           05 LINE 6 COLUMN 29 VALUE "/".
           05 LINE 6 COLUMN 34 VALUE "/".
           05 LINE 8 COLUMN 1  VALUE "Ime..... :".
           05 LINE 9 COLUMN 1  VALUE "Prezime. :".
           05 LINE 10 COLUMN 1 VALUE "Adresa.. :".

           05 LINE 6  COLUMN 26 PIC 9 USING STA.
           05 LINE 6  COLUMN 27 PIC X USING ODS.
           05 LINE 6  COLUMN 28 PIC 9 USING CEN.
           05 LINE 6  COLUMN 30 PIC 9(4) USING BIN.
           05 LINE 6  COLUMN 35 PIC 99 USING GOD.
           05 LINE 8  COLUMN 15 PIC X(12) USING IME.
           05 LINE 9  COLUMN 15 PIC X(18) USING PREZ.
           05 LINE 10 COLUMN 15 PIC X(24) USING ADR.
      *
       PROCEDURE DIVISION.
       POC.
           MOVE 0 TO STA CEN GOD BIN.
           MOVE SPACES TO ODS IME PREZ ADR.
           DISPLAY COLOR-SCREEN.
           OPEN EXTEND MATDAT.
       POST1.
           move 9   to STA.
           move "B" to ODS.
           move 8   to CEN.
           move 7654 to  BIN.
           move 32 to GOD.


           DISPLAY EKRAN.
           ACCEPT EKRAN.
           IF STA = 9 GO TO KRAJ.
           WRITE SLOG.
           GO TO POST1.
       KRAJ.
           CLOSE MATDAT.
           STOP RUN.
      *****END*******************************************
