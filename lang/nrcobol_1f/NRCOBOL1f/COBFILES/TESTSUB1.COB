       IDENTIFICATION DIVISION.
       PROGRAM-ID.   TESTSUB1.
      *AUTHOR.       cHArRiOTt.
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SOURCE-COMPUTER.   AMSTRAD 1512.
       OBJECT-COMPUTER.
      *
       DATA DIVISION.
       FILE SECTION.
      *
       WORKING-STORAGE SECTION.
       01 WS-TEST PIC X(10) VALUE SPACES.
      *
       PROCEDURE DIVISION.
      *
       0000-MAIN.
           DISPLAY "now in test1 program , test ok!".
           EXIT PROGRAM.
      *