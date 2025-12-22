REM Image-Demo1.bas
REM Demo 1 for using /Tools/ILBM2BAS
REM Author: steffen.leistner@styx.in-chemnitz.de
REM Freeware
REM Requires Kickstart 2.0+

REM $NOLIBRARY
REM $NOWINDOW

REM $INCLUDE exec.bh
REM $INCLUDE intuition.bh
REM $INCLUDE BLib/ImageSupport.bas

LIBRARY OPEN "exec.library", 37&
LIBRARY OPEN "intuition.library"

WINDOW 1,"Image-Demo 1:",(100%,50%)-(242%,137%),287%

SMILE_IMAGE:
	DATA &H0000, &H0000, &H01F0, &H0000, &H060C, &H0000, &H0802, &H0000
	DATA &H1001, &H0000, &H2000, &H8000, &H2208, &H8000, &H471C, &H4000
	DATA &H4208, &H4000, &H4000, &H4000, &H4000, &H4000, &H4802, &H4000
	DATA &H27FC, &H8000, &H23F8, &H8000, &H10E1, &H0000, &H0802, &H0000
	DATA &H060C, &H0000, &H01F0, &H0000, &H0000, &H0000

smile_img& = StructImage& (0%,0%,19%,19%,1%,76&,smiledata&,1%,0%,0&)
RESTORE SMILE_IMAGE
FOR zaehler& = 0& TO 75& STEP 2%
	READ wert%
	POKEW smiledata& + zaehler&, wert%
NEXT zaehler&

FOR x% = 1% TO 220% STEP 20%
	FOR y% = 1% TO 120% STEP 20%
		DrawImage WINDOW(8), smile_img&, x%, y%
	NEXT y%
NEXT x%

FreeVec smile_img&

SLEEP
WINDOW CLOSE 1
LIBRARY CLOSE
SYSTEM