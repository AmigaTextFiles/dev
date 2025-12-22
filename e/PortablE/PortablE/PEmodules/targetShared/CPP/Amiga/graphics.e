OPT POINTER
MODULE 'target/graphics', 'target/exec/types'

DEF stdrast=NIL:PTR TO rastport

PROC Plot(x, y, colour=1)
	IF stdrast
		SetAPen(stdrast, colour)
		WritePixel(stdrast, x, y)
	ENDIF
ENDPROC

PROC Line(x1, y1, x2, y2, colour=1)
	IF stdrast
		SetAPen(stdrast, colour)
		Move(stdrast, x1 !!INT, y1 !!INT)	->these casts are for AROS
		Draw(stdrast, x2, y2)
	ENDIF
ENDPROC

PROC Box(x1, y1, x2, y2, colour=1)
	DEF xmin, ymin, xmax, ymax
	IF stdrast
		SetAPen(stdrast, colour)
		xmin := Min(x1, x2)
		xmax := Max(x1, x2)
		ymin := Min(y1, y2)
		ymax := Max(y1, y2)
		RectFill(stdrast, xmin, ymin, xmax, ymax)
	ENDIF
ENDPROC

PROC Colour(foreground, background=0)
	IF stdrast
		SetAPen(stdrast, foreground)
		SetBPen(stdrast, background)
	ENDIF
ENDPROC

PROC TextF(x, y, fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0)
	DEF length
	DEF string:STRING
	
	IF stdrast
		NEW string[ StrLen(fmtString)*2 + 100 ]
		StringF(string, fmtString, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
		
		length := EstrLen(string)
		Move(stdrast, x !!INT, y !!INT)
		Text(stdrast, string, length)
		
		END string
	ENDIF
ENDPROC length

PROC SetStdRast(rast:PTR TO rastport)
	DEF oldstdrast:PTR TO rastport
	oldstdrast := stdrast
	stdrast := rast
ENDPROC oldstdrast

PROC SetTopaz(size=8:INT)
	DEF font:PTR TO textfont
	
	IF stdrast
		font := OpenFont(['topaz.font', size, FS_NORMAL, FPF_PROPORTIONAL OR FPF_DESIGNED]:textattr)
		SetFont(stdrast, font)
		->CloseFont(font)
	ENDIF
ENDPROC

->SetColour() is on-purposely missing (declared in intuition.e)

