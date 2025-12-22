'
'  CodeWandler by J. F. from SATANIC
'  f¸r Xplodercodes (Sony PSX) (Playstationbesitzer wissen Bescheid)
'  english
'  only codes with coding 5 or 6 are available
'  coding 6 codes are distributed by FCD (Future Console Design) itself
'  no warranty for any mistakes; using this of your own risk
'  These was written for AMOS and AMOSPro (AMIGA)
'  for use with PC (QBasic) little changes needed
'  sorry for my bad english
'  this code is mailware; if you use it, send me a mail:
'  shuddemel(at)aol.com
'
'  deutsch
'  nur Codes mit der Codierung 5 oder 6 sind mˆglich umzuwandeln
'  Codes mit der Codierung 6 werden nur von FCD selbst herausgebracht
'  Ich gebe keine Garantie f¸r irgendwelche Fehler;
'  Benutzung auf eigenes Risiko
'  Geschrieben habe ich das Programm in AMOS und AMOSPro (AMIGA)
'  Um es mit dem PC (QBasic) zu nutzen sind kleine ƒnderungen nˆtig
'  Dieses Programm ist Mailware; falls jemand es benutzt, mailt mir:
'  shuddemel(at)aol.com
'
DIM CD(16)
NOCHMAL:
CLS
LOCATE 1, 4
code$ = ""
INPUT "VerschlÅsselter Code : $"; code$
A$ = "0123456789ABCDEF"
IF code$ <> "" THEN
   L = LEN(code$)
   IF L = 12 THEN
      FOR X = 1 TO 12
         R$ = MID$(code$, X, 1)
         V = 0
         R$ = UCASE$(R$)
         FOR Y = 1 TO 16
            IF R$ = MID$(A$, Y, 1) THEN
               EXIT FOR
            ELSE
               V = V + 1
            END IF
            IF V = 16 THEN
               LOCATE 2, 4
               PRINT "UngÅltiger Wert an Position "; X; "."
               GOTO N
            END IF
         NEXT Y
         R$ = UCASE$(R$)
         GOSUB VL
         CD(X) = R
         IF X = 1 THEN
            CD(X) = R
         END IF
         IF X = 2 THEN
            IF CD(X) = 5 THEN
               COD = 1
            ELSE
               IF CD(X) = 7 THEN
                  COD = 2
               ELSE
                  COD = 0
               END IF
            END IF
            CD(X) = 0
         END IF
         IF X = 3 THEN
            IF COD = 1 THEN
               RESTORE C3
               FOR CC = 1 TO 16
                  READ E3
                  IF R = CC - 1 THEN
                     CD(X) = E3
                     EXIT FOR
                  END IF
               NEXT CC
            ELSE
               IF COD = 2 THEN
                  RESTORE S3
               ELSE
                  E3 = 5
                  IF CD(X) = 6 THEN
                     E3 = 6
                  END IF
                  CD(X) = 0
               END IF
            END IF
         END IF
         IF X = 4 THEN
            IF COD = 0 THEN
               RESTORE V4
            ELSE
               IF COD = 2 THEN
                  RESTORE S4
               ELSE
                  RESTORE C4
               END IF
            END IF
            FOR CC = 1 TO 16
               READ E4
               IF R = CC - 1 THEN
                  CD(X) = E4
                  IF COD = 1 THEN
                     IF CC > 9 THEN
                        CD(X - 1) = CD(X - 1) + 1
                        IF CD(X - 1) = 16 THEN
                           CD(X - 1) = 0
                        END IF
                     END IF
                  ELSE
                     IF COD = 2 THEN
                     ELSE
                        IF CC > 5 AND E3 = 6 THEN
                           CD(X - 1) = 1
                        END IF
                     END IF
                  END IF
                  EXIT FOR
               END IF
            NEXT CC
         END IF
         IF X = 5 THEN
            IF COD = 0 THEN
               RESTORE V5
            ELSE
               IF COD = 2 THEN
                  RESTORE S5
               ELSE
                  RESTORE C5
               END IF
            END IF
            FOR CC = 1 TO 16
               READ E5
               IF R = CC - 1 THEN
                  CD(X) = E5
                  EXIT FOR
               END IF
            NEXT CC
         END IF
         IF X = 6 THEN
            IF COD = 0 THEN
               RESTORE V6
               EH = 6
            ELSE
               IF COD = 2 THEN
                  RESTORE S6
               ELSE
                  RESTORE C6
                  EH = 14
               END IF
            END IF
            FOR CC = 1 TO 16
               READ E6
               IF R = CC - 1 THEN
                  CD(X) = E6
                  IF COD = 0 THEN
                     IF CC < EH THEN
                        CD(X - 1) = CD(X - 1) - 1
                        IF CD(X - 1) = -1 THEN
                           CD(X - 1) = 15
                        END IF
                     END IF
                  ELSE
                     IF COD = 2 THEN
                     ELSE
                        IF CC > EH THEN
                           CD(X - 1) = CD(X - 1) + 1
                           IF CD(X - 1) = 16 THEN
                              CD(X - 1) = 0
                           END IF
                        END IF
                     END IF
                  END IF
                  EXIT FOR
               END IF
            NEXT CC
         END IF
         IF X = 7 THEN
            IF COD = 0 THEN
               RESTORE V7
            ELSE
               IF COD = 2 THEN
                  RESTORE S7
               ELSE
                  RESTORE C7
               END IF
            END IF
            FOR CC = 1 TO 16
               READ E7
               IF R = CC - 1 THEN
                  CD(X) = E7
                  EXIT FOR
               END IF
            NEXT CC
         END IF
         IF X = 8 THEN
            IF COD = 0 THEN
               RESTORE V8
               EH = 6
            ELSE
               IF COD = 2 THEN
                  RESTORE S8
               ELSE
                  RESTORE C8
                  EH = 15
               END IF
            END IF
            FOR CC = 1 TO 16
               READ E8
               IF R = CC - 1 THEN
                  CD(X) = E8
                  IF COD = 0 THEN
                     IF CC < EH THEN
                        CD(X - 1) = CD(X - 1) - 1
                        IF CD(X - 1) = -1 THEN
                           CD(X - 1) = 15
                        END IF
                     END IF
                  ELSE
                     IF COD = 2 THEN
                     ELSE
                        IF CC > EH THEN
                           CD(X - 1) = CD(X - 1) + 1
                           IF CD(X - 1) = 16 THEN
                              CD(X - 1) = 0
                           END IF
                        END IF
                     END IF
                  END IF
                  EXIT FOR
               END IF
            NEXT CC
         END IF
         IF X = 9 THEN
            IF COD = 0 THEN
               RESTORE V9
            ELSE
               IF COD = 2 THEN
                  RESTORE S9
               ELSE
                  RESTORE C9
               END IF
            END IF
            FOR CC = 1 TO 16
               READ E9
               IF R = CC - 1 THEN
                  CD(X) = E9
                  EXIT FOR
               END IF
            NEXT CC
         END IF
         IF X = 10 THEN
            IF COD = 0 THEN
               RESTORE V10
               EH = 6
            ELSE
               IF COD = 2 THEN
                  RESTORE S10
               ELSE
                  RESTORE C10
                  EH = 14
               END IF
            END IF
            FOR CC = 1 TO 16
               READ E10
               IF R = CC - 1 THEN
                  CD(X) = E10
                  IF COD = 0 THEN
                     IF CC < EH THEN
                        CD(X - 1) = CD(X - 1) - 1
                        IF CD(X - 1) = -1 THEN
                           CD(X - 1) = 15
                        END IF
                     END IF
                  ELSE
                     IF COD = 2 THEN
                     ELSE
                        IF CC > EH THEN
                           CD(X - 1) = CD(X - 1) + 1
                           IF CD(X - 1) = 16 THEN
                              CD(X - 1) = 0
                           END IF
                        END IF
                     END IF
                  END IF
                  EXIT FOR
               END IF
            NEXT CC
         END IF
         IF X = 11 THEN
            IF COD = 0 THEN
               RESTORE V11
            ELSE
               IF COD = 2 THEN
                  RESTORE S11
               ELSE
                  RESTORE C11
               END IF
            END IF
            FOR CC = 1 TO 16
               READ E11
               IF R = CC - 1 THEN
                  CD(X) = E11
                  EXIT FOR
               END IF
            NEXT CC
         END IF
         IF X = 12 THEN
            IF COD = 0 THEN
               RESTORE V12
               EH = 6
            ELSE
               IF COD = 2 THEN
                  RESTORE S12
               ELSE
                  RESTORE C12
                  EH = 13
               END IF
            END IF
            FOR CC = 1 TO 16
               READ E12
               IF R = CC - 1 THEN
                  CD(X) = E12
                  IF COD = 0 THEN
                     IF CC < EH THEN
                        CD(X - 1) = CD(X - 1) - 1
                        IF CD(X - 1) = -1 THEN
                           CD(X - 1) = 15
                        END IF
                     END IF
                  ELSE
                     IF COD = 2 THEN
                     ELSE
                        IF CC > EH THEN
                           CD(X - 1) = CD(X - 1) + 1
                           IF CD(X - 1) = 16 THEN
                              CD(X - 1) = 0
                           END IF
                        END IF
                     END IF
                  END IF
                  EXIT FOR
               END IF
            NEXT CC
         END IF
      NEXT X
      UCODE$ = ""
      FOR X = 1 TO 12
         R = CD(X)
         GOSUB VR
         UCODE$ = UCODE$ + RC$
      NEXT X
      D = CD(9) * 16 ^ 3 + CD(10) * 16 ^ 2 + CD(11) * 16 + CD(12) MOD 16
      LOCATE 2, 4
      PRINT "EntschlÅsselter Code : $"; UCODE$; " Hex :"; HEX$(D); " = Dezimal : "; D
      GOTO N
   ELSE
      LOCATE 2, 4: PRINT "UngÅltige Anzahl."
      GOTO N
   END IF
ELSE
N:
   LOCATE 3, 4
   PRINT "Nochmal? j/n: "
   DO
      i$ = INKEY$
      IF i$ <> "" THEN
         EXIT DO
      END IF
   LOOP
   IF i$ <> "" THEN
      IF UCASE$(i$) = "J" THEN
         GOTO NOCHMAL
      ELSE
         END
      END IF
   ELSE
      END
   END IF
END IF
VL:
IF R$ = "0" THEN
   R = 0
END IF
IF R$ = "1" THEN
   R = 1
END IF
IF R$ = "2" THEN
   R = 2
END IF
IF R$ = "3" THEN
   R = 3
END IF
IF R$ = "4" THEN
   R = 4
END IF
IF R$ = "5" THEN
   R = 5
END IF
IF R$ = "6" THEN
   R = 6
END IF
IF R$ = "7" THEN
   R = 7
END IF
IF R$ = "8" THEN
   R = 8
END IF
IF R$ = "9" THEN
   R = 9
END IF
IF R$ = "A" THEN
   R = 10
END IF
IF R$ = "B" THEN
   R = 11
END IF
IF R$ = "C" THEN
   R = 12
END IF
IF R$ = "D" THEN
   R = 13
END IF
IF R$ = "E" THEN
   R = 14
END IF
IF R$ = "F" THEN
   R = 15
END IF
RETURN
VR:
IF R = 0 THEN
   RC$ = "0"
END IF
IF R = 1 THEN
   RC$ = "1"
END IF
IF R = 2 THEN
   RC$ = "2"
END IF
IF R = 3 THEN
   RC$ = "3"
END IF
IF R = 4 THEN
   RC$ = "4"
END IF
IF R = 5 THEN
   RC$ = "5"
END IF
IF R = 6 THEN
   RC$ = "6"
END IF
IF R = 7 THEN
   RC$ = "7"
END IF
IF R = 8 THEN
   RC$ = "8"
END IF
IF R = 9 THEN
   RC$ = "9"
END IF
IF R = 10 THEN
   RC$ = "A"
END IF
IF R = 11 THEN
   RC$ = "B"
END IF
IF R = 12 THEN
   RC$ = "C"
END IF
IF R = 13 THEN
   RC$ = "D"
END IF
IF R = 14 THEN
   RC$ = "E"
END IF
IF R = 15 THEN
   RC$ = "F"
END IF
RETURN
V3:
DATA 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1
V4:
DATA 10,13,12,15,14,1,0,3,2,5,4,7,6,9,8,11
V5:
DATA 11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10
V6:
DATA 9,14,15,12,13,2,3,0,1,6,7,4,5,10,11,8
V7:
DATA 11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10
V8:
DATA 8,15,14,13,12,3,2,1,0,7,6,5,4,11,10,9
V9:
DATA 11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10
V10:
DATA 15,8,9,10,11,4,5,6,7,0,1,2,3,12,13,14
V11:
DATA 11,12,13,14,15,0,1,2,3,4,5,6,7,8,9,10
V12:
DATA 14,9,8,11,10,5,4,7,6,1,0,3,2,13,12,15
C3:
DATA 5,6,7,8,9,10,11,12,13,14,15,0,1,2,3,4
C4:
DATA 7,8,9,10,11,12,13,14,15,0,1,2,3,4,5,6
C5:
DATA 4,5,6,7,8,9,10,11,12,13,14,15,0,1,2,3
C6:
DATA 2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,1
C7:
DATA 3,4,5,6,7,8,9,10,11,12,13,14,15,0,1,2
C8:
DATA 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0
C9:
DATA 3,4,5,6,7,8,9,10,11,12,13,14,15,0,1,2
C10:
DATA 2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,1
C11:
DATA 3,4,5,6,7,8,9,10,11,12,13,14,15,0,1,2
C12:
DATA 3,4,5,6,7,8,9,10,11,12,13,14,15,0,1,2
S3:
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
S4:
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0
S5:
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0
S6:
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0
S7:
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0
S8:
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0
S9:
DATA 0,0,0,$0,0,0,0,0,0,0,0,0,$F,0,0,0
DATA 0
S10:
DATA 0,$F,0,0,0,$0,0,0,0,0,0,0,0,0,0,0
DATA 0
S11:
DATA 0,0,$F,$0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0
S12:
DATA 0,0,0,$F,0,$0,0,0,0,0,0,0,0,0,0,0
DATA 0

