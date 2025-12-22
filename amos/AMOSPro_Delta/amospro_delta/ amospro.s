ùúùúÿûªÿÿûªÿÿûªÿÿûªÿÿûªÿÿûªÿÿûªÿÿûªÿÿûªÿ
;---------------------------------------------------------------------
;    **   **   **  ***   ***   ****     **    ***  **  ****
;   ****  *** *** ** ** **     ** **   ****  **    ** **  **
;  **  ** ** * ** ** **  ***   *****  **  **  ***  ** **
;  ****** **   ** ** **    **  **  ** ******    ** ** **
;  **  ** **   ** ** ** *  **  **  ** **  ** *  ** ** **  **
;  **  ** **   **  ***   ***   *****  **  **  ***  **  ****
;---------------------------------------------------------------------
; AMOSPro Delta extension source code,
; By Luke (DELTA) Zelezny
; AMOS, AMOSPro and AMOS Compiler (c) Europress Software 1990-1992
; To be used with AMOSPro1.12 and over
;---------------------------------------------------------------------
; This file is only for Delta!
;---------------------------------------------------------------------
; Written with Trash'm-one by
;---------------------------------------------------------------------
;
; Delta/Opium^Hv^Fnz
; alias
;
; Lukasz Zelezny
; Ul.Wloska 4d/6
; 42-612 Tarnowskie Gory
; Poland
;---------------------------------------------------------------------


	incdir dh5:amos/amos/extensja/amos/

ExecBase=4
supervisor = -30
Version         MACRO
                dc.b    "1.6"
                ENDM
ExtNb           equ     15-1
                Include "|AMOS_Includes.s"

Dsave		MACRO
		movem.l	a3,-(sp)
		move.l	ExtAdr+ExtNb*16(a5),a3
		add.w	#\2-JD,a3
		move.l	\1,(a3)
		movem.l	(sp)+,a3
		ENDM


Dlea		MACRO
		move.l	ExtAdr+ExtNb*16(a5),\2
		add.w	#\1-JD,\2
		ENDM


DLoad           MACRO
                move.l  Extadr+Extnb*16(a5),\1
                ENDM
Start           dc.l    C_Tk-C_Off
                dc.l    C_Lib-C_Tk
                dc.l    C_Title-C_Lib
                dc.l    C_End-C_Title
                dc.w    0
*
C_Off           dc.w (L1-L0)/2,(L2-L1)/2,(L3-L2)/2,(L4-L3)/2
                dc.w (L5-L4)/2,(L6-L5)/2,(L7-L6)/2,(L8-L7)/2
                dc.w (L9-L8)/2,(L10-L9)/2,(L11-L10)/2,(L12-L11)/2
                dc.w (L13-L12)/2,(L14-L13)/2,(L15-L14)/2
                dc.w (L16-L15)/2,(L17-L16)/2,(L18-L17)/2,(L19-L18)/2
                dc.w (L20-L19)/2,(L21-L20)/2,(L22-L21)/2,(L23-L22)/2
		dc.w (L24-L23)/2,(L25-L24)/2,(L26-L25)/2,(L27-L26)/2
		dc.w (L28-L27)/2,(L29-L28)/2,(L30-L29)/2,(L31-L30)/2
		dc.w (L32-L31)/2,(L33-L32)/2,(L34-L33)/2,(L35-L34)/2
		dc.w (L36-L35)/2,(L37-L36)/2,(L38-L37)/2
		dc.w (L39-L38)/2,(L40-L39)/2,(L41-L40)/2,(L42-L41)/2
		dc.w (L43-L42)/2,(L44-L43)/2,(L45-L44)/2,(L46-L45)/2
		dc.w (L47-L46)/2,(L48-L47)/2,(L49-L48)/2,(L50-L49)/2
		dc.w (L51-L50)/2,(L52-L51)/2,(L53-L52)/2,(L54-L53)/2
		dc.w (L55-L54)/2,(L56-L55)/2,(L57-L56)/2,(L58-L57)/2
		dc.w (L59-L58)/2,(L60-L59)/2,(L61-L60)/2
		dc.w (L62-L61)/2,(L63-L62)/2,(L64-L63)/2,(L65-L64)/2
		dc.w (L66-L65)/2,(L67-L66)/2,(L68-L67)/2


*
C_Tk 		even
 		dc.w    1,0
                dc.b    $80,-1
		even
		dc.w	L_Delta_Track_Motor_On,-1
		dc.b	"delta drive motor o",$80+"n","I",-1
		even
                dc.w    L_Delta_Pal,-1
                dc.b    "delta pa",$80+"l","I",-1
		even
                dc.w    L_Delta_Ntsc,-1
                dc.b    "delta nts",$80+"c","I",-1
		even
                dc.w    L_Delta_No_Synchro,-1
                dc.b    "delta no synchr",$80+"o","I0",-1     
		even                
                dc.w    L_Delta_Decrunch,-1
                dc.b    "delta decrunc",$80+"h","I0",-1     
		even
                dc.w    L_double,-1
                dc.b    "delta wait double mous",$80+"e","I0",-1
		even                
                dc.w    L_inter_on,-1
                dc.b    "delta inter o",$80+"n","I",-1 
		even                
                dc.w    L_MouseOff,-1
                dc.b    "delta mouse of",$80+"f","I",-1       
		even                
                dc.w    L_Reset,-1
                dc.b    "delta rese",$80+"t","I",-1           
		even                
                dc.w    L_Inter_off,-1
                dc.b    "delta inter of",$80+"f","I",-1
		even                
                dc.w    L_DiskWait,-1
                dc.b    "delta change dis",$80+"k","I",-1
                even
                dc.w    L_wait_left_mouse,-1
                dc.b    "delta wait left mous",$80+"e","I",-1
		even
                dc.w    L_Delta_Track_Motor_Off,-1
                dc.b    "delta drive motor of",$80+"f","I",-1
		even
		dc.w	-1,L_Urodziny
		dc.b	"delta brithda",$80+"y","0",-1
		even
		dc.w	-1,L_Pii
		dc.b	"delta pi",$80+"#","0",-1
		even
		dc.w	-1,L_E
		dc.b	"delta e",$80+"#","0",-1
		even
		dc.w	-1,L_Greets
		dc.b	"delta about",$80+"$","2",-1
		even
		dc.w	-1,L_YARD
		dc.b	"delta yard",$80+"$","2",-1
		even
		dc.w	-1,L_Feet
		dc.b	"delta feet",$80+"$","2",-1
		even
		dc.w	-1,L_Inch
		dc.b	"delta inch",$80+"$","2",-1
 		even
		dc.w	-1,L_E_Mile
		dc.b	"delta english mile",$80+"$","2",-1
		even
		dc.w	-1,L_A_Mile
		dc.b	"delta american mile",$80+"$","2",-1
		even
		dc.w	-1,L_Radian
		dc.b	"delta radian",$80+"$","2",-1
		even
		dc.w	-1,L_Degree
 		dc.b	"delta degree",$80+"$","2",-1
		even
		dc.w	-1,L_Euler
 		dc.b	"delta euler",$80+"$","2",-1
		even
		dc.w	L_fire,-1
 		dc.b	"delta wait fir",$80+"e","I",-1
		even
		dc.w	L_DeltaHardReset,-1
		dc.b	"delta hard rese",$80+"t","I",-1
		even
		dc.w	L_DeltaBlitOff,-1
		dc.b	"delta blit of",$80+"f","I",-1
		even                
                dc.w    L_Delta_Crash,-1
                dc.b    "delta cras",$80+"h","I0",-1  
		even
		dc.w	L_DELTA_Intuition1,-1
		dc.b	"delta beep al",$80+"l","I",-1
		even
		dc.w	L_Delta_Bank,-1
		dc.b	"delta change ban",$80+"k","I0t0",-1
		even
		dc.w 	L_Delta_Intmsg,-1
		dc.b	"delta intuition messag",$80+"e","I0,2",-1
		even
		dc.w	L_ReqTools1,-1
		dc.b	"delta reqtools palett",$80+"e","I2",-1
		even
		dc.w	L_Wb_Front,-1
		dc.b	"delta wb to fron",$80+"t","I",-1
		even
		dc.w	L_Wb_Back,-1
		dc.b	"delta wb to bac",$80+"k","I",-1
		even
		dc.w	L_Lock_Pub,-1
		dc.b	"delta lock pub screen",$80+"s","I",-1
		even
		dc.w	L_Unlock_Pub,-1
		dc.b	"delta unlock pub screen",$80+"s","I",-1
		even
		dc.w	-1,L_Task
		dc.b	"delta find tas",$80+"k","02",-1
		even
		dc.w	L_Kill_Task,-1
		dc.b	"delta kill tas",$80+"k","I2",-1
		even
		dc.w	-1,L_Requester
		dc.b	"delta reqtools requeste",$80+"r","02,2",-1
		even
		dc.w	-1,L_Get_String
		dc.b	"delta reqtools get numbe",$80+"r","02,0",-1
		even
		dc.w	L_Pal2,-1
		dc.b	"delta req palett",$80+"e","I0",-1

		even	
		dc.w	L_Jsr,-1
		dc.b	"js",$80+"r","I0",-1
		even	
		dc.w	L_Moveb,-1
		dc.b	"move",$80+"b","I0,0",-1
		even	
		dc.w	L_Movew,-1
		dc.b	"move",$80+"w","I0,0",-1
		even	
		dc.w	L_Movel,-1
		dc.b	"move",$80+"l","I0,0",-1
		
		even
		dc.w    0
	


******************************************************************
*               Start of library
C_Lib

******************************************************************
*               COLD START
L0     cmp.l	#$41506578,d1
	bne.b	L0error
	movem.l	a3-a6,-(sp)
	move.l	4,a6
	move.l	#7760,d0
	move.l	#$30002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.b	startup_error
	lea	memory_buffers(pc),a3
	move.l	d0,(a3)
	lea	reg_a5(pc),a3
	move.l	a5,(a3)
	lea	JD(pc),a3
	move.l	a3,ExtAdr+ExtNb*16(a5)
	lea	JDend(pc),a3
	move.l	a3,ExtAdr+ExtNb*16+8(a5)
	movem.l	(sp)+,a3-a6
	moveq	#ExtNb,d0
	move.w	#$110,d1
	move.b	#$0,swit
	rts
startup_error:
	movem.l	(sp)+,a3-a6
L0error:
	moveq	#-1,d0
	rts
JDend:	movem.l	a3-a6,-(sp)
	lea	memory_buffers(pc),a3
	move.l	(a3),a1
	move.l	#7760,d0
	move.l	4,a6
	jsr	-210(a6)
	movem.l	(sp)+,a3-a6
	rts


JD:
reg_a5:	dc.l	0
memory_buffers:
	dc.l	0
rastport:
	dc.l	0
fontname:
	dc.b	'diskfont.library',0
	even
gfxbase:
	dc.l	0
fontbase:
	dc.l	0
font_textattr:
	dc.l	0
	dc.w	0
	dc.b	1,0
	dc.l	4
font_font:
	dc.l	0
fx:	dc.l	8
fy:	dc.l	8
_dy:	ds.l	8
jan:	dc.b	31,28
mar:	dc.b	31,30,31,30,31,31,30,31,30,31,0
	even
tmj2:	ds.b	27
	even
fl:	dc.l	0
stepper	dc.l	0
_step:	dc.l	0
_kx1:	dc.l	0
_ky1:	dc.l	0
_kx2:	dc.l	0
_ky2:	dc.l	0
_kx3:	dc.l	0
_ky3:	dc.l	0
kon1:	dc.l	0
kon2:	dc.l	0
kon3:	dc.l	0
kon4:	dc.l	0
_XS:	dc.l	0
_XS1:	dc.l	0
_XS2:	dc.l	0
_XO:	dc.l	0
_YS:	dc.l	0
_YS1:	dc.l	0
_YS2:	dc.l	0
_YO:	dc.l	0
decathlon:
	dc.l	1000000000
	dc.l	100000000
	dc.l	10000000
	dc.l	1000000
	dc.l	100000
	dc.l	10000
	dc.l	1000
	dc.l	100
	dc.l	10
	dc.l	0
timer:	dc.l	0
device:	dc.l	0
sector:	dc.l	0
wrlen:	dc.l	0
	cnop	0,4
dzw1:	dc.b	0,0,0,0,0,0,0,0,0
	even
dzw2:	dc.b	0,0,0,0,0,0,0,0,0
	even
dz1:	dc.l	0
dz2:	dc.l	0
tmj:	dc.w	0,0,0
date:	dc.w	0,0,0,0,0,0
hms:	dc.w	0,0,0
time:	dc.w	0,0,0,0,0
ttmmjj:	dc.w	0,0,0,0,0
tt:	dc.w	0,0,0,0,0
wl:	dc.l	0
wlm:	dc.l	0
wl1:	dc.l	0
wl2:	dc.l	0
w_ast:	dc.l	0
w_aend:	dc.l	0
kind:	dc.l	0
zahllen:
	dc.l	0
zahlstring:
	dc.l	0
zahlval:
	dc.l	0
realstring:
	dc.l	0
_soo:	dc.l	0
_delay:	dc.l	0
chiptable:
	dc.l	0
ri:	dc.l	0
men:	dc.l	0
rout:	dc.l	0
cstr:	dc.l	0
anz:	dc.l	0
xpos:	dc.l	0
ypos:	dc.l	0
pos:	dc.l	0
clen:	dc.l	0
instr:	dc.l	0
ber:	dc.l	0
bereich1:
	dc.l	0,0,0
bereich2:
	dc.l	0,0,0
str:	dc.l	0,0,0,0
zw:	dc.l	0
jpattern:
	dc.l	0
string:	dc.l	0
instring:
	dc.l	0
pastestring:
	dc.l	0
p_case:	dc.l	0
jbuffer:
	dc.l	0
p1jbuffer:
	dc.l	0
blanull:
	dc.l	0
len:	dc.l	0
gstring:
	dc.l	0
fstring:
	dc.l	0
ustring:
	dc.l	0
var_buffer:
	dc.l	0
var2_buffer:
	dc.l	0
search_len:
	dc.l	0
paste_len:
	dc.l	0
wkey:	dc.l	0
one_byte:
	dc.b	0,0
trackerr:
	dc.l	0
byte:	dc.b	0,0,0
	even
hexer:	dc.b	'$        : '
	even
_start:	dc.l	0
_ende:	dc.l	0
_breite:
	dc.l	0
table:	dc.b	-40,-70,-40,0,40,70,40,0
	even
table2:	dc.b	-40,-70,-90,-100,-90,-70,-40,0
	dc.b	40,70,90,100,90,70,40,0
	even
devicename:
	dc.b	'trackdisk.device',0
	even
diskname:
	dc.b	'disk.resource',0
	even
zahlen:	dc.w	13
	dc.b	'1234567890-',8,13,0
	even
blank:	dc.b	' ',0
	even
blank2:	dc.b	'  ',0
	even
culeft:	dc.b	29,0
	even
curight:
	dc.b	28,0
	even
crlf:	dc.b	10,13,0
	even
cuoff:	dc.b	27,"C0",0
	even
cuon:	dc.b	27,"C1",0
	even
leer:	dc.w	0
	dc.b	0,0
	even
taste:	dc.w	1
	dc.b	' ',0
	even
command	dc.b	1,' ',0
	even
all_buts:
	dc.b	9," 0123456789aAäÄbBcCdDeEfFgGhHiIjJkKlLmMnNoOöÖpPqQrRsSßtTuUüÜvVwWxXyYzZ&!@#$%*()+-='<>?,.:;/{}[]^_`~\|",0
	even
y:	dc.b	0,"|",9," 0123456789aAäÄbBcCdDeEfFgGhHiIjJkKlLmMnNoOöÖpPqQrRsSßtTuUüÜvVwWxXyYzZ&!@#$%*()+-='<>?,.:;/{}[]^_`~\",34
	dc.b	1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
	dc.b	127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147
	dc.b	148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168
	dc.b	169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189
	dc.b	190,191,192,193,194,195,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211
	dc.b	212,213,215,216,217,218,219,221,222,224,225,226,227,229,230,231,232,233,234,235,236
	dc.b	237,238,239,240,241,242,243,244,245,247,248,249,250,251,253,254,255
yend:	dc.b	0
	even
y2:	dc.b	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35
	dc.b	36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67
	dc.b	68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99
	dc.b	100,101,102,103,104,105
	dc.b	106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129
	dc.b	130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153
	dc.b	154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177
	dc.b	178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201
	dc.b	202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225
	dc.b	226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249
	dc.b	250,251,252,253,254,255
y2end:	dc.b	0
	even
tracknr:
	dc.l	0
d_name:	dc.l	0
	dc.w	0
roottrack:
	dc.l	$00000002,$00000000,$00000000,$00000048,$00000000,$86416369,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$FFFFFFFF,$00000371
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00001032,$000002B4,$000002D0,$05456D70,$74790000,$00000000,$00000000
	dc.l	$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$00001032,$000002B4,$000002D0,$00000000,$00000000,$00000000,$00000001
	dc.l	$C000C037,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFF3FFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$3FFFFFFF
	dc.l	0
_lock:	dc.l	0
filehandle:
	dc.l	0
buffer_adr:
	dc.l	0
long:	dc.l	0
efflen:	dc.l	0
f1name:	dc.l	0
f2name:	dc.l	0
	dc.w	2
diskio:	ds.l	20
msgport:
	ds.l	8
fib:	ds.l	66
_sin:	dc.l	0
_cos:	dc.l	0

dimlist:
	ds.l	30
dimendlist:
	dc.l	0
cosinus:
	dc.l	$80000041,$FFF60540,$FFD81440,$FFA63040,$FF605C40,$FF069E40
	dc.l	$FE98FD40,$FE178240,$FD823640,$FCD92540,$FC1C5D40,$FB4BEC40
	dc.l	$FA67E240,$F9705240,$F8654D40,$F746EB40,$F6154040,$F4D06440
	dc.l	$F3787140,$F20D8240,$F08FB340,$EEFF2140,$ED5BED40,$EBA63640
	dc.l	$E9DE1E40,$E803CA40,$E6175F40,$E4190140,$E208DB40,$DFE71540
	dc.l	$DDB3D940,$DB6F5240,$D919AE40,$D6B31D40,$D43BD040,$D1B3F440
	dc.l	$CF1BBE40,$CC736140,$C9BB1540,$C6F30B40,$C41B7F40,$C134A740
	dc.l	$BE3EBE40,$BB3A0040,$B826AA40,$B504F540,$B1D52340,$AE977540
	dc.l	$AB4C2440,$A7F37E40,$A48DBC40,$A11B2640,$9D9BFF40,$9A108D40
	dc.l	$96791840,$92D5EA40,$8F274640,$8B6D7840,$87A8CB40,$83D98C40
	dc.l	$80000240,$F838FB3F,$F05E963F,$E871793F,$E072353F,$D861733F
	dc.l	$D03FCF3F,$C80DEE3F,$BFCC723F,$B77C093F,$AF1D4A3F,$A6B0E43F
	dc.l	$9E377C3F,$95B1C63F,$8D205D3F,$8483F33F,$F7BA663E,$E659A43E
	dc.l	$D4E6DC3E,$C363823E,$B1D0E43E,$A030673E,$8E836D3E,$F996CC3D
	dc.l	$D613273D,$B27ED13D,$8EDC8E3D,$D65E983C,$8EF3153C,$8EF8DE3B
	dc.l	$00000000,$8EF7DCBB,$8EF296BC,$D65DD8BC,$8EDC4EBD,$B27E91BD
	dc.l	$D61307BD,$F9966DBD,$8E834DBE,$A03057BE,$B1D0D4BE,$C36353BE
	dc.l	$D4E6BCBE,$E65984BE,$F7BA56BE,$8483E3BF,$8D204EBF,$95B1B7BF
	dc.l	$9E3775BF,$A6B0D5BF,$AF1D3BBF,$B77BFABF,$BFCC6BBF,$C80DDFBF
	dc.l	$D03FC1BF,$D86164BF,$E07226BF,$E8716BBF,$F05E8FBF,$F838EDBF
	dc.l	$FFFFFEBF,$83D985C0,$87A8C4C0,$8B6D75C0,$8F2743C0,$92D5E1C0
	dc.l	$967915C0,$9A108AC0,$9D9BFCC0,$A11B20C0,$A48DB9C0,$A7F378C0
	dc.l	$AB4C24C0,$AE976FC0,$B1D51DC0,$B504F2C0,$B826A4C0,$BB39FDC0
	dc.l	$BE3EBCC0,$C134A2C0,$C41B7AC0,$C6F309C0,$C9BB0DC0,$CC735EC0
	dc.l	$CF1BBBC0,$D1B3F2C0,$D43BCCC0,$D6B31BC0,$D919ACC0,$DB6F50C0
	dc.l	$DDB3D5C0,$DFE712C0,$E208D9C0,$E41900C0,$E6175BC0,$E803C9C0
	dc.l	$E9DE1BC0,$EBA633C0,$ED5BEAC0,$EEFF1EC0,$F08FB1C0,$F20D81C0
	dc.l	$F3786EC0,$F4D062C0,$F6153FC0,$F746E9C0,$F8654CC0,$F97051C0
	dc.l	$FA67E1C0,$FB4BEBC0,$FC1C5CC0,$FCD924C0,$FD8235C0,$FE1781C0
	dc.l	$FE98FCC0,$FF069EC0,$FF605CC0,$FFA630C0,$FFD814C0,$FFF605C0
	dc.l	$800000C1,$FFF606C0,$FFD815C0,$FFA630C0,$FF605CC0,$FF069FC0
	dc.l	$FE98FEC0,$FE1782C0,$FD8237C0,$FCD927C0,$FC1C5EC0,$FB4BEDC0
	dc.l	$FA67E2C0,$F97053C0,$F86550C0,$F746EBC0,$F61542C0,$F4D067C0
	dc.l	$F37872C0,$F20D85C0,$F08FB4C0,$EEFF22C0,$ED5BF0C0,$EBA637C0
	dc.l	$E9DE20C0,$E803CFC0,$E61761C0,$E41905C0,$E208DCC0,$DFE717C0
	dc.l	$DDB3DDC0,$DB6F54C0,$D919B3C0,$D6B324C0,$D43BD2C0,$D1B3F9C0
	dc.l	$CF1BC0C0,$CC7366C0,$C9BB1AC0,$C6F30EC0,$C41B84C0,$C134ADC0
	dc.l	$BE3EC4C0,$BB3A05C0,$B826ACC0,$B504FBC0,$B1D528C0,$AE9778C0
	dc.l	$AB4C2DC0,$A7F37EC0,$A48DBFC0,$A11B29C0,$9D9C05C0,$9A1097C0
	dc.l	$967922C0,$92D5EEC0,$8F2749C0,$8B6D7EC0,$87A8D5C0,$83D993C0
	dc.l	$800006C0,$F83908BF,$F05EA4BF,$E87187BF,$E07243BF,$D8617ABF
	dc.l	$D03FD7BF,$C80DFDBF,$BFCC72BF,$B77C18BF,$AF1D60BF,$A6B0EBBF
	dc.l	$9E378CBF,$95B1C7BF,$8D2065BF,$84840ABF,$F7BA85BE,$E659B3BE
	dc.l	$D4E6FABE,$C36382BE,$B1D0F3BE,$A03076BE,$8E838CBE,$F9970CBD
	dc.l	$D61327BD,$B27EF1BD,$8EDCCFBD,$D65EDBBC,$8EF394BC,$8EF8D9BB
	dc.l	$00000000,$8EF7583B,$8EF2173C,$D65D5B3C,$8EDC4F3D,$B27E713D
	dc.l	$D612C83D,$F9964E3D,$8E832D3E,$A030273E,$B1D0B43E,$C363443E
	dc.l	$D4E6BC3E,$E659653E,$F7BA283E,$8483DC3F,$8D20463F,$95B1A83F
	dc.l	$9E376D3F,$A6B0C63F,$AF1D343F,$B77BEB3F,$BFCC5C3F,$C80DDF3F
	dc.l	$D03FBA3F,$D8614F3F,$E0721F3F,$E8715C3F,$F05E873F,$F838EC3F
	dc.l	$FFFFF03F,$83D97F40,$87A8C040,$8B6D6A40,$8F273F40,$92D5E040
	dc.l	$96790F40,$9A108440,$9D9BF240,$A11B1D40,$A48DB340,$A7F37540
	dc.l	$AB4C1B40,$AE976640,$B1D51D40,$B504EC40,$B8269F40,$BB39F740
	dc.l	$BE3EB440,$C134A040,$C41B7740,$C6F30440,$C9BB1040,$CC735740
	dc.l	$CF1BB440,$D1B3ED40,$D43BC740,$D6B31B40,$D919AA40,$DB6F4840
	dc.l	$DDB3D340,$DFE70E40,$E208D540,$E418FE40,$E6175A40,$E803C540
	dc.l	$E9DE1840,$EBA63040,$ED5BE940,$EEFF1D40,$F08FAF40,$F20D7D40
	dc.l	$F3786C40,$F4D06240,$F6153D40,$F746E840,$F8654A40,$F9704E40
	dc.l	$FA67DF40,$FB4BEA40,$FC1C5B40,$FCD92340,$FD823440,$FE178040
	dc.l	$FE98FC40,$FF069D40,$FF605B40,$FFA62F40,$FFD81440,$FFF60540
sinus:	dc.l	$00000000,$8EF85A3B,$8EF2D53C,$D65E573C,$8EDC6F3D,$B27EB13D
	dc.l	$D613073D,$F996AC3D,$8E835D3E,$A030573E,$B1D0D43E,$C363733E
	dc.l	$D4E6CC3E,$E659943E,$F7BA663E,$8483EB3F,$8D20553F,$95B1BF3F
	dc.l	$9E377C3F,$A6B0DC3F,$AF1D433F,$B77C023F,$BFCC6B3F,$C80DE63F
	dc.l	$D03FC83F,$D8616C3F,$E0722D3F,$E871723F,$F05E963F,$F838F43F
	dc.l	$FFFFFE3F,$83D98940,$87A8CB40,$8B6D7840,$8F274340,$92D5E740
	dc.l	$96791840,$9A108D40,$9D9BFC40,$A11B2340,$A48DB940,$A7F37B40
	dc.l	$AB4C2440,$AE977240,$B1D52040,$B504F240,$B826A740,$BB39FD40
	dc.l	$BE3EBE40,$C134A540,$C41B7D40,$C6F30940,$C9BB1240,$CC736140
	dc.l	$CF1BBE40,$D1B3F240,$D43BCE40,$D6B31D40,$D919AE40,$DB6F5040
	dc.l	$DDB3D740,$DFE71340,$E208DB40,$E4190040,$E6175D40,$E803C940
	dc.l	$E9DE1D40,$EBA63440,$ED5BEC40,$EEFF2040,$F08FB140,$F20D8140
	dc.l	$F3787140,$F4D06340,$F6153F40,$F746EA40,$F8654D40,$F9705140
	dc.l	$FA67E140,$FB4BEB40,$FC1C5C40,$FCD92540,$FD823540,$FE178140
	dc.l	$FE98FD40,$FF069E40,$FF605C40,$FFA63040,$FFD81440,$FFF60540
	dc.l	$80000041,$FFF60540,$FFD81540,$FFA63040,$FF605C40,$FF069F40
	dc.l	$FE98FD40,$FE178240,$FD823740,$FCD92540,$FC1C5D40,$FB4BED40
	dc.l	$FA67E340,$F9705240,$F8654E40,$F746EC40,$F6154140,$F4D06540
	dc.l	$F3787240,$F20D8440,$F08FB440,$EEFF2240,$ED5BED40,$EBA63740
	dc.l	$E9DE2040,$E803CC40,$E6176140,$E4190340,$E208DC40,$DFE71740
	dc.l	$DDB3D940,$DB6F5440,$D919B340,$D6B32040,$D43BD040,$D1B3F940
	dc.l	$CF1BC040,$CC736340,$C9BB1540,$C6F30E40,$C41B7F40,$C134AA40
	dc.l	$BE3EBE40,$BB3A0240,$B826AC40,$B504F640,$B1D52640,$AE977540
	dc.l	$AB4C2740,$A7F38140,$A48DBF40,$A11B2640,$9D9C0540,$9A109040
	dc.l	$96791C40,$92D5EA40,$8F274940,$8B6D7B40,$87A8CE40,$83D98C40
	dc.l	$80000640,$F839013F,$F05E9D3F,$E871793F,$E0723C3F,$D861733F
	dc.l	$D03FD73F,$C80DF53F,$BFCC7A3F,$B77C113F,$AF1D4A3F,$A6B0E43F
	dc.l	$9E378C3F,$95B1CF3F,$8D205D3F,$8483FB3F,$F7BA753E,$E659A43E
	dc.l	$D4E6EB3E,$C363823E,$B1D0E33E,$A030763E,$8E837C3E,$F996CC3D
	dc.l	$D613473D,$B27EF13D,$8EDCAF3D,$D65E9B3C,$8EF3573C,$8EF9583B
	dc.l	$00000000,$8EF759BB,$8EF256BC,$D65DDBBC,$8EDC4FBD,$B27E71BD
	dc.l	$D612C8BD,$F9966EBD,$8E834DBE,$A03037BE,$B1D0B4BE,$C36353BE
	dc.l	$D4E6CBBE,$E65975BE,$F7BA37BE,$8483ECBF,$8D2046BF,$95B1A8BF
	dc.l	$9E3775BF,$A6B0CDBF,$AF1D3BBF,$B77BFABF,$BFCC5CBF,$C80DDFBF
	dc.l	$D03FC1BF,$D86156BF,$E07226BF,$E87163BF,$F05E8FBF,$F838ECBF
	dc.l	$FFFFF0BF,$83D985C0,$87A8C4C0,$8B6D6DC0,$8F273FC0,$92D5E0C0
	dc.l	$967915C0,$9A1087C0,$9D9BF6C0,$A11B20C0,$A48DB3C0,$A7F375C0
	dc.l	$AB4C1EC0,$AE976CC0,$B1D51DC0,$B504ECC0,$B826A1C0,$BB39FAC0
	dc.l	$BE3EB6C0,$C134A5C0,$C41B7AC0,$C6F306C0,$C9BB0DC0,$CC7359C0
	dc.l	$CF1BB6C0,$D1B3EFC0,$D43BCCC0,$D6B319C0,$D919A8C0,$DB6F4CC0
	dc.l	$DDB3D5C0,$DFE710C0,$E208D7C0,$E418FCC0,$E6175AC0,$E803C7C0
	dc.l	$E9DE1BC0,$EBA631C0,$ED5BECC0,$EEFF1DC0,$F08FAEC0,$F20D80C0
	dc.l	$F3786EC0,$F4D063C0,$F6153EC0,$F746E7C0,$F8654BC0,$F97050C0
	dc.l	$FA67E0C0,$FB4BEBC0,$FC1C5CC0,$FCD924C0,$FD8235C0,$FE1780C0
	dc.l	$FE98FDC0,$FF069EC0,$FF605BC0,$FFA62FC0,$FFD814C0,$FFF605C0
	dc.l	$800000C1,$FFF605C0,$FFD815C0,$FFA631C0,$FF605DC0,$FF069FC0
	dc.l	$FE98FEC0,$FE1783C0,$FD8238C0,$FCD927C0,$FC1C5EC0,$FB4BEEC0
	dc.l	$FA67E3C0,$F97054C0,$F86551C0,$F746EDC0,$F61542C0,$F4D068C0
	dc.l	$F37873C0,$F20D86C0,$F08FB6C0,$EEFF25C0,$ED5BF0C0,$EBA638C0
	dc.l	$E9DE22C0,$E803D1C0,$E61762C0,$E41907C0,$E208DEC0,$DFE717C0
	dc.l	$DDB3DCC0,$DB6F58C0,$D919B5C0,$D6B326C0,$D43BD2C0,$D1B3F9C0
	dc.l	$CF1BC5C0,$CC7368C0,$C9BB1CC0,$C6F310C0,$C41B84C0,$C134ADC0
	dc.l	$BE3EC6C0,$BB3A0AC0,$B826ACC0,$B504FBC0,$B1D52BC0,$AE977BC0
	dc.l	$AB4C30C0,$A7F384C0,$A48DC2C0,$A11B2DC0,$9D9C02C0,$9A109AC0
	dc.l	$967925C0,$92D5F1C0,$8F2750C0,$8B6D7BC0,$87A8D1C0,$83D99AC0
	dc.l	$800009C0,$F83910BF,$F05EABBF,$E87180BF,$E07243BF,$D86181BF
	dc.l	$D03FE5BF,$C80E04BF,$BFCC81BF,$B77C18BF,$AF1D59BF,$A6B0FBBF
	dc.l	$9E379ABF,$95B1CEBF,$8D206DBF,$848402BF,$F7BA94BE,$E659D2BE
	dc.l	$D4E70ABE,$C36392BE,$B1D103BE,$A03096BE,$8E839CBE,$F9972BBD
	dc.l	$D61367BD,$B27F11BD,$8EDCEEBD,$D65F56BC,$8EF3D8BC,$8EF9DCBB
sonntag	dc.w	6
	dc.b	'Sunday',0
	even
montag	dc.w	6
	dc.b	'Monday',0
	even
dienstag
	dc.w	7
	dc.b	'Tuesday',0
	even
mittwoch
	dc.w	9
	dc.b	'Wednesday',0
	even
donnerstag
	dc.w	8
	dc.b	'Thursday',0
	even
freitag	dc.w	6
	dc.b	'Friday',0
	even
samstag	dc.w	8
	dc.b	'Saturday',0
	even
source	dc.l	0
yeartable
	dc.w	1600,2000,2400,2800,3200,3600,4000,4400,4800
	even
dzw	dc.l	0
	dc.w	0
tag	dc.l	0
monat	dc.l	0
jahr	dc.l	0
IntBase:	ds.l	1
Intmsg:		ds.b	256
Intmsg2:	ds.b	256
numba:		ds.l	1
nic:		dc.l	1234
Intmsg3:	ds.b	30
intname:	dc.b	"intuition.library",$0
Reqtoolsname:	dc.b	"reqtools.library",$0
Reqname:	dc.b	"req.library",$0
reqtoolsbase:	even	
		ds.l	1
paltitle:	ds.b	256
l:		ds.w	1
swit:		ds.b	1
wyrownaj:	dc.b	0
NULL:    dc.w  0,0,0,0,0
ZERO:    dc.w  0,0,0,0,0


******************************************************************
*
L1

******************************************************************
*
L2

*****************************************************************
L_Delta_Decrunch    equ     3
L3      

	move.l	(a3)+,d0 ;colour (first var.)
	tst	d0
	Rbeq	L_err1	
	cmp.w	#$fff+1,d0
	Rbge	L_err2
	move.l	d0,$dff180
        rts
	
******************************************************************
L_Delta_No_Synchro     equ     4
L4
	move.l	(a3)+,d0
	move.b  d0,$dff1dc
        rts
******************************************************************

L_double 		equ     5
L5		

			move.l	(a3)+,d1 (var.)
			mysz1:
			btst.b	#6,$bfe001
			bne.b mysz1
			move.l	d1,d0
			pikik:
			sub	#1,d0
			tst	d0
                        bne.b pikik
			mysz2:
			btst.b	#6,$bfe001
			bne.b mysz2
			rts
******************************************************************
L_Inter_on       equ     6
L6      
        
        move.w	#0,$dff09a
        rts
******************************************************************
L_Delta_Pal   equ     7
L7      move.b  #32,$dff1dc
        rts                             
******************************************************************
L_Delta_Ntsc       equ     8
L8      move.b  #0,$dff1dc
        rts
******************************************************************
L_MouseOff      equ     9
L9      move.w  #$20,$dff096            
        rts
******************************************************************
CuCuOff dc.b    27,"C0",0
        even
******************************************************************
L_Reset         equ     10
L10     MOVEA.L 4.W,A6
        JSR     -$0096(A6)
        JSR     -$0078(A6)              ; Reset
        CLR.L   4.W
        LEA     $00FC0000.L,A0
        RESET
        JMP     (A0)
        DC.B    'Nq'
        rts
******************************************************************      
L_Inter_off	equ      11
L11 		move.w	#$4000,$dff09a
		rts
******************************************************************
L_delta_track_motor_off  equ     12
L12:  
        
        move.b	#127,$bfd100
	move.b  #119,$bfd100
	move.b	#255,$bfd100+512
        rts
*****************************************************************
L_DiskWait      equ     13
L13
dc:     move.b  $bfe001,d0              ; Diskchange
        and.b   #16,d0
        bne.b     dc
        movem.l a6,-(sp)
        movea.l 4,a6
Wait    move.l  #500,d1
Wait2   bsr.b     tests
        sub.l   #1,d1
        bne.b     Wait2
        jsr     -120(a6)
        lea     $196(a6),a0
        lea     Validate,a1
        jsr     -276(a6)
        move.l  d0,d2
        bne.b     Check
        lea     $1a4(a6),a0
        lea     Validate,a1
        jsr     -276(a6)
        move.l  d0,d2
Check   jsr     -126(a6)
        tst.l   d2
        bne.b     Wait
        movem.l (sp)+,a6
        rts
tests   movem.l a0-a6/d0-d7,-(sp)
        movem.l (sp)+,a0-a6/d0-d7
        rts
Validate:
        dc.b    'Validator',0
        even
**********************************************************************
L_wait_left_mouse equ     14
L14		

			mysz:
			btst.b	#6,$bfe001
			bne.b mysz
			rts

*********************************************************************
L_Delta_Track_Motor_On	EQU     15
L15		move.b	#127,$bfd100
		move.b  #119,$bfd100
		move.b	#0,$bfd100+512
		rts


L_Urodziny	equ	16
L16

		moveq	#0,d2
		move.l	#23031981,d3
		rts

L_Pii		equ	17
L17
		move.l	#$c90fdb42,d3
		moveq	#1,d2
		rts

L_E		equ	18
L18
e:	move.l	#$adf85442,d3
	moveq	#1,d2
	rts

L_Greets	equ	19
L19
	Dlea 	ZERO,a0
	Dlea    ZERO,a0
	Dlea 	NULL,a1
	Dlea	NULL,a1

	move.w	#22,(a1)+

	move.b	#'D',(a1)+
	move.b	#'e',(a1)+
	move.b	#'l',(a1)+
	move.b	#'t',(a1)+
	move.b	#'a',(a1)+
	move.b	#' ',(a1)+
	move.b	#'o',(a1)+
	move.b	#'f',(a1)+
	move.b	#' ',(a1)+
	move.b	#'O',(a1)+
	move.b	#'p',(a1)+
	move.b	#'i',(a1)+
	move.b	#'u',(a1)+
	move.b	#'m',(a1)+
	move.b	#'^',(a1)+
	move.b	#'H',(a1)+
	move.b	#'v',(a1)+
	move.b	#'^',(a1)+
	move.b	#'F',(a1)+
	move.b	#'n',(a1)+
	move.b	#'z',(a1)+
	move.b	#'!',(a1)+

	moveq	#2,d2
	Dlea	NULL,a0
	move.l	a0,d3
        rts

L_YARD	equ	20
L20
	Dlea	ZERO,a0
	Dlea	ZERO,a0
	Dlea	NULL,a1
	move.w	#6,(a1)+

	move.b	#'0',(a1)+
        move.b	#'.',(a1)+
        move.b	#'9',(a1)+
        move.b	#'1',(a1)+
        move.b	#'4',(a1)+
        move.b	#'4',(a1)+


	moveq	#2,d2
	Dlea	NULL,a0
	move.l	a0,d3
	rts



L_Feet	equ	21
L21
	Dlea	ZERO,a0
	Dlea	ZERO,a0
	Dlea	NULL,a1
	move.w	#6,(a1)+

	move.b	#'0',(a1)+
        move.b	#'.',(a1)+
        move.b	#'3',(a1)+
        move.b	#'0',(a1)+
        move.b	#'4',(a1)+
        move.b	#'8',(a1)+


	moveq	#2,d2
	Dlea	NULL,a0
	move.l	a0,d3
   rts



L_Inch	equ	22
L22
	Dlea	ZERO,a0
	Dlea	ZERO,a0
	Dlea	NULL,a1
	move.w	#6,(a1)+

	move.b	#'0',(a1)+
        move.b	#'.',(a1)+
        move.b	#'0',(a1)+
        move.b	#'2',(a1)+
        move.b	#'5',(a1)+
        move.b	#'4',(a1)+


	moveq	#2,d2
	Dlea	NULL,a0
	move.l	a0,d3
   rts


L_E_Mile	equ	23
L23
	Dlea	ZERO,a0
	Dlea	ZERO,a0
	Dlea	NULL,a1
	move.w	#4,(a1)+

	move.b	#'1',(a1)+
        move.b	#'8',(a1)+
        move.b	#'5',(a1)+
        move.b	#'2',(a1)+

	moveq	#2,d2
	Dlea	NULL,a0
	move.l	a0,d3
   rts


L_A_Mile equ	24
L24
	Dlea	ZERO,a0
	Dlea	ZERO,a0
	Dlea	NULL,a1
	move.w	#7,(a1)+

	move.b	#'1',(a1)+
        move.b	#'8',(a1)+
        move.b	#'5',(a1)+
        move.b	#'3',(a1)+
        move.b	#'.',(a1)+
        move.b	#'2',(a1)+
        move.b	#'5',(a1)+


	moveq	#2,d2
	Dlea	NULL,a0
	move.l	a0,d3
   rts



L_Radian	equ	25
L25		

	Dlea	ZERO,a0
	Dlea	ZERO,a0
	Dlea	NULL,a1
	move.w	#9,(a1)+

	move.b	#'5',(a1)+
        move.b	#'7',(a1)+
        move.b	#'.',(a1)+
        move.b	#'2',(a1)+
        move.b	#'9',(a1)+
        move.b	#'5',(a1)+
        move.b	#'7',(a1)+
        move.b	#'8',(a1)+
        move.b	#'°',(a1)+


	moveq	#2,d2
	Dlea	NULL,a0
	move.l	a0,d3

	rts


L_Degree	equ	26
L26		

	Dlea	ZERO,a0
	Dlea	ZERO,a0
	Dlea	NULL,a1
	move.w	#9,(a1)+

	move.b	#'0',(a1)+
        move.b	#'.',(a1)+
        move.b	#'0',(a1)+
        move.b	#'1',(a1)+
        move.b	#'7',(a1)+
        move.b	#'4',(a1)+
        move.b	#'5',(a1)+
        move.b	#'r',(a1)+
        move.b	#'d',(a1)+


	moveq	#2,d2
	Dlea	NULL,a0
	move.l	a0,d3

	rts



L_Euler		equ	27
L27		

	Dlea	ZERO,a0
	Dlea	ZERO,a0
	Dlea	NULL,a1
	move.w	#7,(a1)+

	move.b	#'0',(a1)+
        move.b	#'.',(a1)+
        move.b	#'5',(a1)+
        move.b	#'7',(a1)+
        move.b	#'7',(a1)+
        move.b	#'2',(a1)+
        move.b	#'2',(a1)+


	moveq	#2,d2
	Dlea	NULL,a0
	move.l	a0,d3

	rts



L_Fire          equ     28
L28     btst    #07,$bfe001
        bne.b     L28
        rts

L_DeltaHardReset	equ	29
L29	MOVEA.L	(4).L,A6
	MOVE.L	#0,($2A)
	JMP	($FC0000).L
	rts

L_DeltaBlitOff	equ	30
L30		

	waitxx:
	btst #14,$dff002
	bne.b waitxx	
	rts
	
L_Delta_Crash    equ     31
L31      

	move.l	(a3)+,d0 ;mode
	move.l	d0,$dff108
	move.l	d0,$dff110
        rts

L_Int1			equ	32
L32	Dlea	intname,a1
	Move.l	4,a6
	jsr	-408(a6)
	Dsave 	d0,intbase
	Move.l	d0,a6
	Move.l	#0,a0
	Jsr	-96(a6)
	
	rts


L_Delta_Intuition1	equ	33
L33
	movem.l	a3-a6,-(sp)
	Rbsr	L_Int1
	movem.l (sp)+,a3-a6

	rts


L_err1	equ	34
L34	moveq	#0,d0
	Rbra	L_Custom

	
L_err2	equ	35
L35	moveq	#1,d0
	Rbra	L_Custom
	
L_Delta_Bank	equ	36
L36
	
	move.l	(a3)+,d1 	;second param (NEW NUMBER) e.g. =200
	move.l	(a3)+,a0 	;NUMBER OF OLD BANK        e.g. =Start(100)
	tst	d1		;NEW BANK NUMBER=0
	Rbeq	L_err1	
	tst	d1		;NEW BANK <0
	Rbmi	L_err1
	cmp.w	#$fff+1,d1 	;NEW BANK NUMBER>65535
	Rbge	L_err2
	sub.l	#16,a0		;SEARCH OLD BANK NUMBER ALLOCATION
	move.l	d1,(a0)		;PUT NEW NUMBER INTO BANK STRUCTURE
	
	rts

L_err3	equ	37
L37	moveq	#2,d0
	Rbra	L_Custom
	rts

L_err4	equ	38
L38
	moveq	#3,d0
	Rbra	L_Custom

	rts

L_Delta_Intmsg	equ	39
L39

	move.l	(a3)+,Intmsg	;Start of string
	move.l	(a3)+,d5	;Y pos

	movem.l	a3-a6,-(sp)
	Rbsr	L_Int2
	movem.l (sp)+,a3-a6
	
	rts

L_Int2		equ	40
L40	
	Dlea	intname,a1

	
	Move.l	4,a6
	jsr	-408(a6)
	Dsave 	d0,intbase
	Move.l	d0,a6
	Move.l	#0,a0
	
	moveq	#0,d0
	move.l	d5,d1
	move.l	Intmsg,a0
	Jsr	-90(a6)
		
	rts

L_ReqTools1 	equ	41
L41

	
	Move.l	(a3)+,a0	;store address of string
	Moveq	#0,d2		;clear d2
	Move.w	(a0)+,d2	;length of string in d2
	add.w	d2,a0		;a0=a0+length(in d2)
	Move.b	#0,(a0)		;insert Chr$(0)
	sub.w	d2,a0
	Move.l	a0,Intmsg	;string itself in INTMSG



	movem.l	a3-a6,-(sp)
	Rbsr	L_Req1
	movem.l	(sp)+,a3-a6

	rts

L_err5		equ	42
L42
	moveq	#4,d0
	Rbra	L_Custom

	rts

L_Req1		equ	43
L43	
	Dlea	reqtoolsname,a1

	Move.l	4,a6
	jsr	-408(a6)
	Move.l	d0,a6
	
	Move.l	#0,a2


	Move.l	#0,a0
	Move.l	Intmsg,a2
	Move.l	#0,a3
	Jsr	-102(a6)

	rts

L_Wb_Front 	equ	44
L44



	movem.l	a3-a6,-(sp)

	Dlea	intname,a1
	Move.l	4,a6
	jsr	-408(a6)
	Dsave 	d0,intbase
	Move.l	d0,a6
	Jsr	-342(a6)
	

	movem.l (sp)+,a3-a6


	rts

L_Wb_Back	equ	45
L45

	movem.l	a3-a6,-(sp)

	Dlea	intname,a1
	Move.l	4,a6
	jsr	-408(a6)
	Dsave 	d0,intbase
	Move.l	d0,a6
	Jsr	-336(a6)
	

	movem.l (sp)+,a3-a6


	rts

L_Lock_Pub	equ	46
L46

	cmp.b	#0,swit		;SWIT must be =0
	beq.b .skip
	Rbra	L_err7		;Error, cos SWIT will >0
.skip
	movem.l	a3-a6,-(sp)

	Dlea	intname,a1
	Move.l	4,a6
	jsr	-408(a6)
	Dsave 	d0,intbase
	Move.l	d0,a6
	Jsr	-522(a6)
	
	move.b	#1,swit

	movem.l (sp)+,a3-a6

	rts

L_Unlock_Pub	equ	47
L47

	cmp.b	#1,swit		;SWIT must be =1
	beq.b	.skip2
	Rbra	L_err6		;Error, cos SWIT =0
.skip2
	movem.l	a3-a6,-(sp)

	Dlea	intname,a1
	Move.l	4,a6
	jsr	-408(a6)
	Dsave 	d0,intbase
	Move.l	d0,a6
	Jsr	-528(a6)
	
	move.b	#0,swit

	movem.l (sp)+,a3-a6

	rts

L_err6	equ	48
L48

	move.b	#0,swit
	moveq	#6,d0
	Rbra	L_Custom
	rts

L_err7	equ	49
L49

	movem.l	a3-a6,-(sp)
	Dlea	intname,a1
	Move.l	4,a6
	jsr	-408(a6)
	Dsave 	d0,intbase
	Move.l	d0,a6
	Jsr	-528(a6)
	
	move.b	#0,swit

	movem.l (sp)+,a3-a6

	moveq	#5,d0
	Rbra	L_Custom
	rts

L_Task	equ	50
L50

	Move.l	(a3)+,a0	;store address of string
	Moveq	#0,d2		;clear d2
	Move.w	(a0)+,d2	;length of string in d2
	Move.l	a0,a1		;string itself in a1


	movem.l	a3-a6,-(sp)
	move.l	4,a6
	jsr	-294(a6)

	moveq	#0,d2
	move.l	d0,d3


	movem.l (sp)+,a3-a6
	
	
	rts

L_Kill_Task      	equ	51
L51

	;************ Find task ***************************
	Move.l	(a3)+,a0	;store address of string
	Moveq	#0,d2		;clear d2
	Move.w	(a0)+,d2	;length of string in d2
	Move.l	a0,a1		;string itself in a1


	movem.l	a3-a6,-(sp)
	move.l	4,a6
	jsr	-294(a6)

	tst	d0		;Task exist or not ?
	Rbeq	L_err8		;ERROR! Not exist	

	move.l	d0,a1		;Task address in A1
	jsr	-288(a6)

	movem.l (sp)+,a3-a6
	



	rts

L_err8		equ	52
L52
	moveq	#7,d0
	Rbra	L_Custom

	rts



L_Requester	equ	53
L53

	Move.l	(a3)+,a0	;store address of first string
	Moveq	#0,d2		;clear d2
	Move.w	(a0)+,d2	;length of string in d2
	add.w	d2,a0		;a0=a0+length(in d2)
	Move.b	#0,(a0)		;insert Chr$(0)
	sub.w	d2,a0
	Move.l	a0,Intmsg	;first string itself in INTMSG


	Move.l	(a3)+,a0	;store address of second string
	Moveq	#0,d2		;clear d2
	Move.w	(a0)+,d2	;length of string in d2
	add.w	d2,a0		;a0=a0+length(in d2)
	Move.b	#0,(a0)		;insert Chr$(0)
	sub.w	d2,a0
	Move.l	a0,Intmsg2	;second string itself in INTMSG2



	movem.l	a3-a6,-(sp)
	Rbsr	L_Req2
	movem.l	(sp)+,a3-a6

	rts

L_req2	equ	54
L54

	Dlea	reqtoolsname,a1

	Move.l	4,a6
	jsr	-408(a6)
	Move.l	d0,a6
	
	Move.l	#0,a2


	Move.l	#0,a0
	move.l	#0,a3
	move.l	#0,a4
	Move.l	Intmsg2,a1
	Move.l	Intmsg,a2
	Move.l	#0,a3
	Jsr	-66(a6)


	moveq	#0,d2
	move.l	d0,d3

	
	rts


L_Get_String	equ	55
L55


	Move.l	(a3)+,numba	;default number in a2


	Move.l	(a3)+,a0	;store address of first string
	Moveq	#0,d2
	Move.w	(a0)+,d2	;length of string in d2
	add.w	d2,a0		;a0=a0+length(in d2)
	Move.b	#0,(a0)		;insert Chr$(0)
	sub.w	d2,a0
	Move.l	a0,Intmsg	;!!!first string itself in INTMSG

	movem.l	a3-a6,-(sp)


	Dlea	reqtoolsname,a1	;Open reqtools

	Move.l	4,a6		;Exec function
	jsr	-408(a6)	;Open OldLibrary
	Move.l	d0,a6		;Reqtoolsbase to a6
	
	
	lea	numba,a1
	Move.l	Intmsg,a2	;Title$ in a2

	Move.l	#100,d0
	move.l	#0,a3
	move.l	#0,a0
	Jsr	-78(a6)
	

	movem.l	(sp)+,a3-a6


	moveq	#0,d2
	move.l	numba,d3


	rts



L_Pal2	equ	56
L56

	Move.l	(a3)+,numba	;default number in NUMBA

	movem.l	a3-a6,-(sp)

	Dlea	reqname,a1	;Open req
	Move.l	4,a6		;Exec function
	jsr	-408(a6)	;Open OldLibrary
	Move.l	d0,a6		;Reqtoolsbase to a6
	Move.l	numba,d0	;NUMBA is number of first edit colour
	Jsr	-90(a6)		;Call function

	movem.l	(sp)+,a3-a6

	rts

L_Jsr	equ	57
L57

	move.l	(a3)+,a0
	jsr 	(a0)
	rts

L_Moveb	equ	58
L58

	move.l	(a3)+,a0
	move.l	(a3)+,d0
	move.b 	d0,(a0)
	rts

L_Movew	equ	59
L59

	move.l	(a3)+,a0
	move.l	(a3)+,d0
	move.w 	d0,(a0)
	rts

L_Movel	equ	60
L60

	move.l	(a3)+,a0
	move.l	(a3)+,d0
	move.l 	d0,(a0)
	rts





L61
L62
L63
L64
L65


L_Custom	equ	66
L66	lea	ErrMess(pc),a0
	moveq	#0,d1			* Can be trapped
	moveq	#ExtNb,d2		* Number of extension
	moveq	#0,d3			* IMPORTANT!!!
	RJmp	L_ErrorExt		* Jump to routine...
* Messages...
ErrMess	dc.b	"Variable is too small",0		*0
	dc.b 	"Variable is too large",0			*1
	dc.b 	"Bank is not defined",0		*2
	dc.b	"Cannot create intuition alert",0		*3
	dc.b	"Cannot open reqtools.library",0		*4
	dc.b	"Public screen already locked",0		*5
	dc.b 	"Public screens already unlocked",0			*6
	dc.b	"Task not found",0			*7
	dc.b	"Not a tracker module",0		*8
* IMPORTANT! Always EVEN!
	even

******* "No errors" routine
; If you compile with -E0, the compiler will replace the previous
; routine by this one. This one just sets D3 to -1, and does not
; load messages in A0. Anyway, values in D1 and D2 must be valid.
;	
; THIS ROUTINE MUST BE THE LAST ONE IN THE LIBRARY!
;

L67	moveq	#0,d1
	moveq	#ExtNb,d2
	moveq	#-1,d3
	RJmp	L_ErrorExt

; Do not forget the last label to delimit the last library routine!

L68








************************************************



*               Welcome message                     ;"  
C_Title:        
        dc.b    "AMOSPro Delta Extension V"
        Version
        dc.b    " by DELTA/Opium^Hv (1997)"
        dc.b    0,"$VER: "
        Version
        dc.b    0
        Even

***********************************************************
C_End:  dc.w    0
        even
