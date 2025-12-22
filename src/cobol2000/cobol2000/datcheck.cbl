      * ------------------------------------------------------
      * DATCHECK.CBL           Datechecking
      *                        Andreas Kleinert
      * Last Change:           02.01.99
      * ------------------------------------------------------
      *    Compile directive:    
      *       RUNCOBOL DATCHECK B=2000
      *-------------------------------------------------------

      * ----------------- IDENTIFICATION ---------------------
       ID DIVISION.
       PROGRAM-ID. DatCheck.

      * ----------------- ENVIRONMENT ------------------------
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

      * ----------------- DATA -------------------------------
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 Daytable VALUE "312831303130313130313031".
           05 Days PIC 9(2) OCCURS 12.
       01 Res       PIC 9(4).
       01 Remain    PIC 9(4).
       01 Remain100 PIC 9(2).

       LINKAGE SECTION.
       01 Par.
           05   DD PIC 9(2).
           05   MM PIC 9(2).
           05 YYYY PIC 9(4).
           05   FC PIC 9.

      * ----------------- PROCEDURE --------------------------
       PROCEDURE DIVISION USING Par.
      * ++++++++++++++++
      * +++ DatCheck +++
      * ++++++++++++++++
       DatCheck SECTION.
        Dat010.
           move 1 to FC IN Par.

           DIVIDE YYYY IN Par BY 4 GIVING Res REMAINDER Remain
           DIVIDE YYYY IN Par BY 100 GIVING Res REMAINDER Remain100

           IF Remain100 = 0 THEN
             DIVIDE YYYY IN Par BY 400 GIVING Res REMAINDER Remain
           END-IF

           IF MM IN Par < 1 OR MM IN Par > 12
             MOVE 1 TO FC
           ELSE
             IF DD IN Par < 1
               MOVE 1 TO FC
             ELSE
               IF MM IN Par = 2 AND Remain = 0
                 IF DD in Par > 29
                   MOVE 1 TO FC
                 ELSE
                    MOVE 0 TO FC
                 END-IF
               ELSE
                 IF DD IN Par > Days(MM IN Par)
                   MOVE 1 TO FC
                 ELSE
                   MOVE 0 TO FC
                 END-IF
               END-IF
             END-IF
           END-IF.
       Dat999.
           GOBACK.
