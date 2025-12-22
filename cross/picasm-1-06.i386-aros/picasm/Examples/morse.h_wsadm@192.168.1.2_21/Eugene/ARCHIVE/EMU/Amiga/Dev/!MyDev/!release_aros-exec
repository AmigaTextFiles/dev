;
; morse.h
;

;
; Macro to convert ascii strings and numbers to encoded morse code data.
; Uses macro recursion.
;
morsedata macro ; opcode,arg1,arg2,...
	if isstr(\2)
	  morse_string \1,\2,0
	else
	  if streq("\2","")
	    exitm
	  endif
	  morsechar \1,\2
	endif
	morsedata \1,\3,\4,\5,\6,\7,\8,\9
	endm

;
; This macro converts strings to morse code.
; Called from the morsedata macro.
; Also recursive.
;
morse_string macro ;string, startpos
	if chrval(\2,\3) >= 0
	  morsechar \1,chrval(\2,\3)
	  morse_string \1,\2,\3+1
	endif
	endm

;
; a big macro to convert one character of
; ASCII to morse code at assembly time
;
; zero bit represents a dot, and one bit represents a dash.
; the code is right-justified inside a byte, and is preceeded
; by a start bit of one (and padded with zero bits).
;
morsechar macro  ; opcode,asciicode
	if	(\2 == 32)
	  \1	0xff		;special code for space
	  exitm
	endif
	if	(\2 == '"')
	  \1	1010010b	; .-..-.
	  exitm
	endif
	if	(\2 == '(')
	  \1	1101101b	; -.--.-
	  exitm
	endif
	if	(\2 == ')')
	  \1	1101101b	; -.--.-
	  exitm
	endif
	if	(\2 == ',')
	  \1	1110011b	; --..--
	  exitm
	endif
	if	(\2 == '-')
	  \1	1100001b	; -....-
	  exitm
	endif
	if	(\2 == '.')
	  \1	1101010b	; -.-.-.
	  exitm
	endif
	if	(\2 == '/')
	  \1	110010b		; -..-.
	  exitm
	endif
	if	(\2 == '0')
	  \1	111111b		; -----
	  exitm
	endif
	if	(\2 == '1')
	  \1	101111b		; .----
	  exitm
	endif
	if	(\2 == '2')
	  \1	100111b		; ..---
	  exitm
	endif
	if	(\2 == '3')
	  \1	100011b		; ...--
	  exitm
	endif
	if	(\2 == '4')
	  \1	100001b		; ....-
	  exitm
	endif
	if	(\2 == '5')
	  \1	100000b		; .....
	  exitm
	endif
	if	(\2 == '6')
	  \1	110000b		; -....
	  exitm
	endif
	if	(\2 == '7')
	  \1	111000b		; --...
	  exitm
	endif
	if	(\2 == '8')
	  \1	111100b		; ---..
	  exitm
	endif
	if	(\2 == '9')
	  \1	111110b		; ----.
	  exitm
	endif
	if	(\2 == ':')
	  \1	1111000b	; ---...
	  exitm
	endif
	if	(\2 == '=')
	  \1	110001b		; -...-
	  exitm
	endif
	if	(\2 == '?')
	  \1	1001100b	; ..--..
	  exitm
	endif
	if	(\2 == 'A') | (\2 == 'a')
	  \1	101b		; .-
	  exitm
	endif
	if	(\2 == 'B') | (\2 == 'b')
	  \1	11000b		; -...
	  exitm
	endif
	if	(\2 == 'C') | (\2 == 'c')
	  \1	11010b		; -.-.
	  exitm
	endif
	if	(\2 == 'D') | (\2 == 'd')
	  \1	1100b		; -..
	  exitm
	endif
	if	(\2 == 'E') | (\2 == 'e')
	  \1	10b		; .
	  exitm
	endif
	if	(\2 == 'F') | (\2 == 'f')
	  \1	10010b		; ..-.
	  exitm
	endif
	if	(\2 == 'G') | (\2 == 'g')
	  \1	1110b		; --.
	  exitm
	endif
	if	(\2 == 'H') | (\2 == 'h')
	  \1	10000b		; ....
	  exitm
	endif
	if	(\2 == 'I') | (\2 == 'i')
	  \1	100b		; ..
	  exitm
	endif
	if	(\2 == 'J') | (\2 == 'j')
	  \1	10111b		; .---
	  exitm
	endif
	if	(\2 == 'K') | (\2 == 'k')
	  \1	1101b		; -.-
	  exitm
	endif
	if	(\2 == 'L') | (\2 == 'l')
	  \1	10100b		; .-..
	  exitm
	endif
	if	(\2 == 'M') | (\2 == 'm')
	  \1	111b		; --
	  exitm
	endif
	if	(\2 == 'N') | (\2 == 'n')
	  \1	110b		; -.
	  exitm
	endif
	if	(\2 == 'O') | (\2 == 'o')
	  \1	1111b		; ---
	  exitm
	endif
	if	(\2 == 'P') | (\2 == 'p')
	  \1	10110b		; .--.
	  exitm
	endif
	if	(\2 == 'Q') | (\2 == 'q')
	  \1	11101b		; --.-
	  exitm
	endif
	if	(\2 == 'R') | (\2 == 'r')
	  \1	1010b		; .-.
	  exitm
	endif
	if	(\2 == 'S') | (\2 == 's')
	  \1	1000b		; ...
	  exitm
	endif
	if	(\2 == 'T') | (\2 == 't')
	  \1	11b		; -
	  exitm
	endif
	if	(\2 == 'U') | (\2 == 'u')
	  \1	1001b		; ..-
	  exitm
	endif
	if	(\2 == 'V') | (\2 == 'v')
	  \1	10001b		; ...-
	  exitm
	endif
	if	(\2 == 'W') | (\2 == 'w')
	  \1	1011b		; .--
	  exitm
	endif
	if	(\2 == 'X') | (\2 == 'x')
	  \1	11001b		; -..-
	  exitm
	endif
	if	(\2 == 'Y') | (\2 == 'y')
	  \1	11011b		; -.--
	  exitm
	endif
	if	(\2 == 'Z') | (\2 == 'z')
	  \1	11100b		; --..
	  exitm
	endif

        ~ ;Error: Character not in morse code table!
        endm    ; end of morsechar macro

