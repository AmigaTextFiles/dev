-> usage: cha_keyboard out.0
-> keyboard noteons, fkeys changeoctave, space notesoff, close quit

OPT PREPROCESS

MODULE 'dos/dos', 'intuition/intuition', 'exec/ports', 'camd', 'midi/camd'

DEF notes[$80] : ARRAY OF LONG

PROC main() HANDLE
	DEF midi = NIL, link = NIL, window = NIL : PTR TO window, done = FALSE,
	    imsg : PTR TO intuimessage, class, code, prevrawkey = -1,
	    note, octave = 3, channel = $F, velocity = $40
	FOR note := $00 TO $7F DO notes[note] := 0
	camdbase := OpenLibrary('camd.library', 37)
	IF camdbase = NIL THEN Throw("CAMD", "OPEN")
	midi := CreateMidiA([
	    MIDI_NAME,       'cha_keyboard',
	    MIDI_BUFFERSIZE, 256,
	    NIL ])
	IF midi = NIL THEN Throw("CAMD", "MIDI")
	link := AddMidiLinkA(midi, MLTYPE_SENDER, [
	    MLINK_NAME,     'cha_keyboard.out',
	    MLINK_LOCATION, arg,
	    NIL ])
	IF link = NIL THEN Throw("CAMD", "LINK")
	window := OpenWindowTagList(NIL, [
	    WA_TITLE,       'cha_keyboard',
	    WA_DRAGBAR,     TRUE,
	    WA_DEPTHGADGET, TRUE,
	    WA_CLOSEGADGET, TRUE,
	    WA_ACTIVATE,    TRUE,
	    WA_RMBTRAP,     TRUE,
	    WA_INNERHEIGHT, 10,
	    WA_INNERWIDTH,  160,
	    WA_IDCMP,       IDCMP_CLOSEWINDOW OR
	                    IDCMP_RAWKEY,
	    NIL ])
	IF window = NIL THEN Throw("WIN", 0)
	REPEAT
		Wait(Shl(1, window.userport.sigbit))
		WHILE imsg := GetMsg(window.userport)
			class := imsg.class
			code  := imsg.code
			ReplyMsg(imsg)
			SELECT class
			CASE IDCMP_CLOSEWINDOW
				done := TRUE
			CASE IDCMP_RAWKEY
				IF code <> prevrawkey
				SELECT code
				-> function keys
				CASE $50; octave := 0
				CASE $51; octave := 1
				CASE $52; octave := 2
				CASE $53; octave := 3
				CASE $54; octave := 4
				CASE $55; octave := 5
				CASE $56; octave := 6
				CASE $57; octave := 7
				CASE $58; octave := 8
				CASE $59; octave := 9
				-> space bar
				CASE $40; allnotesoff(link, channel)
				-> notes
#define noteon(x) playnote(link, channel, x + (octave * 12), velocity)
				CASE $31; noteon( 0)
				CASE $21; noteon( 1)
				CASE $32; noteon( 2)
				CASE $22; noteon( 3)
				CASE $33; noteon( 4)
				CASE $34; noteon( 5)
				CASE $24; noteon( 6)
				CASE $35; noteon( 7)
				CASE $25; noteon( 8)
				CASE $36; noteon( 9)
				CASE $26; noteon(10)
				CASE $37; noteon(11)
				CASE $38; noteon(12)
				CASE $28; noteon(13)
				CASE $39; noteon(14)
				CASE $29; noteon(15)
				CASE $3A; noteon(16)
				CASE $10; noteon(12)
				CASE $02; noteon(13)
				CASE $11; noteon(14)
				CASE $03; noteon(15)
				CASE $12; noteon(16)
				CASE $13; noteon(17)
				CASE $05; noteon(18)
				CASE $14; noteon(19)
				CASE $06; noteon(20)
				CASE $15; noteon(21)
				CASE $07; noteon(22)
				CASE $16; noteon(23)
				CASE $17; noteon(24)
				CASE $09; noteon(25)
				CASE $18; noteon(26)
				CASE $0A; noteon(27)
				CASE $19; noteon(28)
				CASE $1A; noteon(29)
				CASE $0C; noteon(30)
				CASE $1B; noteon(31)
				CASE $0D; noteon(32)
#define noteoff(x) stopnote(link, channel, x + (octave * 12), velocity)
				CASE $B1; noteoff( 0)
				CASE $A1; noteoff( 1)
				CASE $B2; noteoff( 2)
				CASE $A2; noteoff( 3)
				CASE $B3; noteoff( 4)
				CASE $B4; noteoff( 5)
				CASE $A4; noteoff( 6)
				CASE $B5; noteoff( 7)
				CASE $A5; noteoff( 8)
				CASE $B6; noteoff( 9)
				CASE $A6; noteoff(10)
				CASE $B7; noteoff(11)
				CASE $B8; noteoff(12)
				CASE $A8; noteoff(13)
				CASE $B9; noteoff(14)
				CASE $A9; noteoff(15)
				CASE $BA; noteoff(16)
				CASE $90; noteoff(12)
				CASE $82; noteoff(13)
				CASE $91; noteoff(14)
				CASE $83; noteoff(15)
				CASE $92; noteoff(16)
				CASE $93; noteoff(17)
				CASE $85; noteoff(18)
				CASE $94; noteoff(19)
				CASE $86; noteoff(20)
				CASE $95; noteoff(21)
				CASE $87; noteoff(22)
				CASE $96; noteoff(23)
				CASE $97; noteoff(24)
				CASE $89; noteoff(25)
				CASE $98; noteoff(26)
				CASE $8A; noteoff(27)
				CASE $99; noteoff(28)
				CASE $9A; noteoff(29)
				CASE $8C; noteoff(30)
				CASE $9B; noteoff(31)
				CASE $8D; noteoff(32)
				ENDSELECT
				prevrawkey := code
				ENDIF
			ENDSELECT
		ENDWHILE
	UNTIL done
EXCEPT DO
	IF window
		CloseWindow(window)
		window := NIL
	ENDIF
	IF midi
		DeleteMidi(midi)
		midi := NIL
	ENDIF
	IF camdbase
		CloseLibrary(camdbase)
		camdbase := NIL
	ENDIF
ENDPROC IF exception THEN 5 ELSE 0

PROC playnote(link, channel, note, velocity)
	IF (0 <= note) AND (note <= $7F)
		notes[note] := notes[note] + 1
		PutMidi(link, Shl(Shl(Shl($90 OR channel, 8) OR note, 8) OR velocity, 8))
	ENDIF
ENDPROC

PROC stopnote(link, channel, note, velocity)
	IF (0 <= note) AND (note <= $7F)
		IF notes[note] > 0
			notes[note] := notes[note] - 1
			PutMidi(link, Shl(Shl(Shl($80 OR channel, 8) OR note, 8) OR velocity, 8))
		ENDIF
	ENDIF
ENDPROC

PROC allnotesoff(link, channel)
	DEF note
	FOR note := $00 TO $7F
		WHILE notes[note] > 0
			notes[note] := notes[note] - 1
			PutMidi(link, Shl(Shl(Shl($80 OR channel, 8) OR note, 8) OR $40, 8))
		ENDWHILE
	ENDFOR
ENDPROC
