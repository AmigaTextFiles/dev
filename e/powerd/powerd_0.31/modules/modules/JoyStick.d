SET	LEFT,RIGHT,UP,DOWN,FIRE

PROC GetJoy(port=0)
	DEF	joypos,joyx,joyy,firebutton,result=0
	IF port=0
		joypos:=Long($dff00a) AND $FFFF
		firebutton:=Char($bfe001)
	ELSE
		joypos:=Long($dff00c) AND $FFFF
		firebutton:=Char($bfe001)				// this is a mouse button
	ENDIF
	joyx:=joypos AND %11
	joyy:=Shr(joypos,8) AND %11
	IF joyx&%10=%10           THEN result:=result OR RIGHT
	IF joyy&%10=%10           THEN result:=result OR LEFT
	IF joyx=%01 OR joyx=%10   THEN result:=result OR DOWN
	IF joyy=%01 OR joyy=%10   THEN result:=result OR UP
	IF firebutton&%10000000=0 THEN result:=result OR FIRE
ENDPROC result
