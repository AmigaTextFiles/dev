
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    PHONE.
       DATE-WRITTEN.  05/12/97.
      *
      *    Convert alpha code to phone number.
      *
      *        *******************************
      *        *                             *
      *        *     Judson D. McClendon     *
      *        *     Sun Valley Systems      *
      *        *     329 37th Court N.E.     *
      *        *     Birmingham, AL 35215    *
      *        *        205-853-8440         *
      *        *                             *
      *        *******************************
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       77  WS-PHONE-NBR   PIC  X(40) VALUE SPACES.
       77  WS-LOWER-CASE  PIC  X(26) VALUE "abcdefghijklmnopqrstuvwxyz".
       77  WS-UPPER-CASE  PIC  X(26) VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
       77  WS-ALPHA       PIC  X(26) VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
       77  WS-NUMER       PIC  X(26) VALUE "22233344455566677778889999".
      *
       PROCEDURE DIVISION.
      *
       000000-PROCESS.
      *
           DISPLAY "Enter Phone Code".
           ACCEPT WS-PHONE-NBR.
      *
           INSPECT WS-PHONE-NBR
               CONVERTING WS-LOWER-CASE
                       TO WS-UPPER-CASE.
      *
           INSPECT WS-PHONE-NBR
               CONVERTING WS-ALPHA
                       TO WS-NUMER.
      *
           DISPLAY WS-PHONE-NBR.