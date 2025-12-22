-> usage: cha_monitor in.0
-> ctrl-c quits

MODULE 'dos/dos', 'camd', 'midi/camd'

CONST SYSEXSIZE = 16384

PROC main() HANDLE
	DEF msg : midimsg, signals, midi = NIL, link = NIL
	camdbase := OpenLibrary('camd.library', 37)
	IF camdbase = NIL THEN Throw("CAMD", "OPEN")
	midi := CreateMidiA([
	    MIDI_NAME,       'cha_monitor',
	    MIDI_RECVSIGNAL, SIGBREAKB_CTRL_F,
	    MIDI_BUFFERSIZE, 256,
	    MIDI_SYSEXSIZE,  SYSEXSIZE,
	    NIL ])
	IF midi = NIL THEN Throw("CAMD", "MIDI")
	link := AddMidiLinkA(midi, MLTYPE_RECEIVER, [
	    MLINK_NAME,     'cha_monitor.in',
	    MLINK_LOCATION, arg,
	    NIL ])
	IF link = NIL THEN Throw("CAMD", "LINK")
	LOOP
		signals := Wait(SIGBREAKF_CTRL_C OR SIGBREAKF_CTRL_F)
		IF signals AND SIGBREAKF_CTRL_F
			WHILE GetMidi(midi, msg)
				printmessage(midi, msg)
			ENDWHILE
		ENDIF
		IF signals AND SIGBREAKF_CTRL_C
			Raise("^C")
		ENDIF
	ENDLOOP
EXCEPT DO
	IF midi
		DeleteMidi(midi)
		midi := NIL
	ENDIF
	IF camdbase
		CloseLibrary(camdbase)
		camdbase := NIL
	ENDIF
ENDPROC IF exception THEN 5 ELSE 0

PROC printmessage(midi, msg : PTR TO midimsg)
	DEF status, channel, len, length, sysexbuffer = NIL : PTR TO CHAR
	channel := msg.status AND $0F
	status  := msg.status AND $F0
	IF status = $F0 THEN status := msg.status
	SELECT status
	CASE $80; WriteF('\z\h[1] \z\h[1] \z\h[2] \z\h[2]\t note off\n', status, channel, msg.data1, msg.data2)
	CASE $90; WriteF('\z\h[1] \z\h[1] \z\h[2] \z\h[2]\t note on\n',  status, channel, msg.data1, msg.data2)
	CASE $A0; WriteF('\z\h[1] \z\h[1] \z\h[2] \z\h[2]\t aftertouch\n', status, channel, msg.data1, msg.data2)
	CASE $B0; WriteF('\z\h[1] \z\h[1] \z\h[2] \z\h[2]\t control change\n', status, channel, msg.data1, msg.data2)
	CASE $C0; WriteF('\z\h[1] \z\h[1] \z\h[2]   \t program change\n', status, channel, msg.data1)
	CASE $D0; WriteF('\z\h[1] \z\h[1] \z\h[2]   \t channel pressure\n', status, channel, msg.data1)
	CASE $E0; WriteF('\z\h[1] \z\h[1] \z\h[4] \t pitch bend\n', status, channel, msg.data1 OR Shl(msg.data2,7))
	CASE $F0
		IF sysexbuffer := New(SYSEXSIZE)
			length := 0
			WHILE len := GetSysEx(midi, sysexbuffer, SYSEXSIZE)
				length := length + len
			ENDWHILE
			WriteF('\z\h[2] [\z\h[8]] \z\h[2] system exclusive\n', status, length, $F7)
			Dispose(sysexbuffer)
			sysexbuffer := NIL
		ELSE
			WriteF('\z\h[2] [........] \z\h[2] system exclusive, OUT OF MEMORY\n', status, $F7)
		ENDIF
	CASE $F1; WriteF('\z\h[2] \z\h[1] \z\h[1]   \t time code quarter frame\n', status, Shr(msg.data1, 4), msg.data1 AND $0F)
	CASE $F2; WriteF('\z\h[2] \z\h[4]  \t song position pointer\n', status, msg.data1 OR Shl(msg.data2,7))
	CASE $F3; WriteF('\z\h[2] \z\h[2]    \t song select\n', status, msg.data1)
	CASE $F4; WriteF('\z\h[2]       \t << undefined F4 >>\n', status)
	CASE $F5; WriteF('\z\h[2]       \t << undefined F5 >>\n', status)
	CASE $F6; WriteF('\z\h[2]       \t tune request\n', status)
	CASE $F7; WriteF('\z\h[2]       \t end of system exclusive\n', status)
	CASE $F8; WriteF('\z\h[2]       \t timing clock\n', status)
	CASE $F9; WriteF('\z\h[2]       \t << undefined F9 >>\n', status)
	CASE $FA; WriteF('\z\h[2]       \t start\n', status)
	CASE $FB; WriteF('\z\h[2]       \t continue\n', status)
	CASE $FC; WriteF('\z\h[2]       \t stop\n', status)
	CASE $FD; WriteF('\z\h[2]       \t << undefined FD >>\n', status)
	CASE $FE; WriteF('\z\h[2]       \t active sensing\n', status)
	CASE $FF; WriteF('\z\h[2]       \t system reset\n', status)
	DEFAULT;  WriteF('\z\h[2] \z\h[2] \z\h[2] \t UNKNOWN\n', msg.status, msg.data1, msg.data2)
	ENDSELECT
ENDPROC
