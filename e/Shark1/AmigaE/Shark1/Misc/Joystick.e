PROC main()
WHILE CtrlC()=FALSE
WriteF('\d\t',mJoy())
ENDWHILE
ENDPROC

PROC mJoy(port=0)
DEF joypos, joyx, joyy, firebutton, bit=0
	IF port=0 THEN port:=$dff00a
	IF port=1 THEN port:=$dff00c
	joypos:=Long(port) AND $FFFF
        firebutton:=Char($bfe001)
        joyx:=joypos AND %11
        joyy:=Shr(joypos,8) AND %11
        IF ((joyx AND %10) = %10) THEN bit:=bit+2
        IF ((joyy AND %10) = %10) THEN bit:=bit+1
        IF (joyx = %01) OR (joyx = %10) THEN bit:=bit+8
        IF (joyy = %01) OR (joyy = %10) THEN bit:=bit+4

        IF port=$dff00a THEN IF (firebutton AND 128) = 0 THEN bit:=bit+16
	IF port=$dff00c THEN IF (firebutton AND 64) = 0 THEN bit:=bit+16

ENDPROC bit
