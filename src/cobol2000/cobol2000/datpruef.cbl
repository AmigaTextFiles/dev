      * ------------------------------------------------------
      * DATPRUEF.CBL           DatumsprÅfung
      *                        Andreas Kleinert
      * Letzte énderung:       02.01.99
      * ------------------------------------------------------
      *    Compiliervorschriften:
      *       RUNCOBOL DATPRUEF B=2000
      *-------------------------------------------------------

      * ----------------- IDENTIFICATION ---------------------
       ID DIVISION.
       PROGRAM-ID. DatPruef.

      * ----------------- ENVIRONMENT ------------------------
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

      * ----------------- DATA -------------------------------
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 Tagetabelle VALUE "312831303130313130313031".
           05 Tage PIC 9(2) OCCURS 12.
       01 Erg     PIC 9(4).
       01 Rest    PIC 9(4).
       01 Rest100 PIC 9(2).

       LINKAGE SECTION.
       01 Par.
           05   TT PIC 9(2).
           05   MM PIC 9(2).
           05 JJJJ PIC 9(4).
           05   FC PIC 9.

      * ----------------- PROCEDURE --------------------------
       PROCEDURE DIVISION USING Par.
      * ++++++++++++++++
      * +++ DatPruef +++
      * ++++++++++++++++
       DatPruef SECTION.
        Dat010.
           move 1 to FC IN Par.

           DIVIDE JJJJ IN Par BY 4 GIVING Erg REMAINDER Rest
           DIVIDE JJJJ IN Par BY 100 GIVING Erg REMAINDER Rest100

           IF Rest100 = 0 THEN
             DIVIDE JJJJ IN Par BY 400 GIVING Erg REMAINDER Rest
           END-IF

           IF MM IN Par < 1 OR MM IN Par > 12
             MOVE 1 TO FC
           ELSE
             IF TT IN Par < 1
               MOVE 1 TO FC
             ELSE
               IF MM IN Par = 2 AND Rest = 0
                 IF TT in Par > 29
                   MOVE 1 TO FC
                 ELSE
                    MOVE 0 TO FC
                 END-IF
               ELSE
                 IF TT IN Par > Tage(MM IN Par)
                   MOVE 1 TO FC
                 ELSE
                   MOVE 0 TO FC
                 END-IF
               END-IF
             END-IF
           END-IF.
       Dat999.
           GOBACK.
