
OPT MODULE
->OPT EXPORT

MODULE 'tools/020_Procedures'


EXPORT PROC mul(a,b)
	MOVE.L a,D0
	MOVE.L b,D1
ENDPROC mulu()

EXPORT PROC div(a,b)
	MOVE.L a,D0
	MOVE.L b,D1
ENDPROC divu()


