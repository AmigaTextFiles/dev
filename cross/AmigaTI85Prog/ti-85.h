ROM_CALL	EQU	$8C09

PROGRAM_ADDR	EQU	$8C3C	; program address
ROM_VERS	EQU	$8C3E	; ROM version byte
ZSHELL_VER	EQU	$8C3F	; ZShell version number
ZS_BITS		EQU	$8C40	; bit 0 set : checksum again
LD_HL_MHL       EQU	$0033  ; HLEQU	(HL), AEQU	L
CP_HL_DE        EQU	$008E  ; CP HL,DE (modifies flags only)
UNPACK_HL       EQU	$009A  ; unpacks one digit of HL into %A
STORE_KEY       EQU	$01B1  ; store immediate keystroke from %A
GET_KEY         EQU	$01BE  ; get immediate keystroke into %A
TX_CHARPUT       EQU	$00   ; xlated display of %A on screen, normal text style
D_LT_STR         EQU	$01   ; display length-byte normal text string
M_CHARPUT        EQU	$02   ; display %A on screen, menu style
D_ZM_STR         EQU	$03   ; display zero-terminated string,  menu style
D_LM_STR         EQU	$04   ; display length-byte string, menu style
GET_T_CUR        EQU	$05   ; HL EQU	 absolute address of text cursor
SCROLL_UP        EQU	$06   ; scroll text screen up
TR_CHARPUT       EQU	$07   ; raw display of %A on screen, normal text style
CLEARLCD         EQU	$08   ; clear LCD, but not text or graphics memory
D_HL_DECI        EQU	$09   ; disp. HL as 5-byte, right just., blank-pad. decimal
CLEARTEXT        EQU	$0A   ; clear LCD and text memory (affected by 1,(IY+13))
D_ZT_STR         EQU	$0B   ; display zero-terminated normal text string
BUSY_OFF         EQU	$0C   ; turn off "busy" indicataor
BUSY_ON          EQU	$0D   ; turn on "busy" indicator
FIND_PIXEL       EQU	$80   ; Find location in RAM for a pixel on the GFX screen
KEY_0		EQU	$8000	; translated scancode of last key, but 0 if gotten
KEY_1		EQU	$8001	; translated scancode of key down now
KEY_2		EQU	$8002	; same as 8001, but $FF if more than one key is down
KEY_STAT	EQU	$8004	; bit 2 set EQU	 key down now
LAST_KEY	EQU	$8006	; last key pressed
CONTRAST	EQU	$8007	; contrast
CURSOR_ROW	EQU	$800C	; text cursor row
CURSOR_COL	EQU	$800D	; text cursor column
CURSOR_LET	EQU	$800E	; letter under text cursor
BUSY_COUNTER	EQU	$8080	; counter for busy indicator
BUSY_BITMAP	EQU	$8081	; bitmap for busy indicator
CURR_INPUT	EQU	$80C6	; -> current home-screen input
BYTES_USED	EQU	$80CC	; # of used user memory (Add to 80C8 to find first 
			; byte of free memory)
TEXT_MEM	EQU	$80DF	; text memory
CURSOR_ROW2	EQU	$800C	; text cursor row
CURSOR_COL2	EQU	$800D	; text cursor column
CHECKSUM	EQU	$81BE	; memory checksum from 8BF7 to FA6F
CURSOR_X	EQU	$8333	; x value of cursor
CURSOR_Y	EQU	$8334	; y value of cursor
_IY_TABLE	EQU	$8346	; where IY usually points
GRAPH_MEM	EQU	$8641	; graphics memory
TEXT_MEM2	EQU	$8A6B	; secondary text memory
USER_MEM	EQU	$8B1B	; -> start of user memory
FIXED_POINT	EQU	$8B3A	; fixed-point decimal place (FFh for floating point)
VAT_END		EQU	$8BEB	; -> one byte before end of VAT (backwards)
VAT_START	EQU	$FA6F	; start of VAT
VIDEO_MEM	EQU	$FC00	; video memory



