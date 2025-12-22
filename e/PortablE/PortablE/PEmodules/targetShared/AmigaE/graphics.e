OPT NATIVE, FORCENATIVE
MODULE 'target/graphics', 'target/exec/types'

NATIVE {stdrast} DEF stdrast:PTR TO rastport

PROC Plot(x, y, colour=1) IS NATIVE {Plot(} x {,} y {,} colour {)} ENDNATIVE

PROC Line(x1, y1, x2, y2, colour=1) IS NATIVE {Line(} x1 {,} y1 {,} x2 {,} y2 {,} colour {)} ENDNATIVE

PROC Box(x1, y1, x2, y2, colour=1) IS NATIVE {Box(} x1 {,} y1 {,} x2 {,} y2 {,} colour {)} ENDNATIVE

PROC Colour(foreground, background=0) IS NATIVE {Colour(} foreground {,} background {)} ENDNATIVE

PROC TextF(x, y, fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) IS NATIVE {TextF(} x {,} y {,} fmtString {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {,} arg6 {,} arg7 {,} arg8 {)} ENDNATIVE !!VALUE

PROC SetStdRast(rast:PTR TO rastport) IS NATIVE {SetStdRast(} rast {)} ENDNATIVE !!PTR TO rastport

PROC SetTopaz(size=8:INT) IS NATIVE {SetTopaz(} size {)} ENDNATIVE

->SetColour() is on-purposely missing (declared in intuition.e)

