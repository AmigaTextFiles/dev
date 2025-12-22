;---------------------------------------------------------------------
;    **    **   **   ***    ***     ****      **     ***   **   ****
;   ****   *** ***  ** **  **       ** **    ****   **     **  **  **
;  **  **  ** * **  ** **   ***     *****   **  **   ***   **  **
;  ******  **   **  ** **     **    **  **  ******     **  **  **
;  **  **  **   **  ** **  *  **    ** **   **  **  *  **  **  **  **
;  **  **  **   **   ***    ***     *****   **  **   ***   **   ****
;---------------------------------------------------------------------
; JD prt_extension source code, V1.1  Last change 20.05.1993
; By Joerg Dommermuth
; AMOS and AMOS Compiler (c) Europress Software 1991
; To be used with AMOSPro V1.12 and over
;--------------------------------------------------------------------- 
; This file is public domain
;---------------------------------------------------------------------


ExtNb	equ	21-1

Version	MACRO
	dc.b	"1.1"
	ENDM

	Incdir	"dh0:AMOS_Pro/Tutorial/Extensions/"
 	Include	"|AMOS_Includes.s"

Start:	dc.l	C_Tk-C_Off
	dc.l	C_Lib-C_Tk
	dc.l	C_Title-C_Lib
	dc.l	C_End-C_Title
	dc.w	0	

C_Off:	dc.w	(L1-L0)/2,(L2-L1)/2,(L3-L2)/2,(L4-L3)/2
	dc.w	(L5-L4)/2,(L6-L5)/2,(L7-L6)/2,(L8-L7)/2
	dc.w	(L9-L8)/2,(L10-L9)/2,(L11-L10)/2,(L12-L11)/2
	dc.w	(L13-L12)/2,(L14-L13)/2,(L15-L14)/2,(L16-L15)/2
	dc.w	(L17-L16)/2,(L18-L17)/2,(L19-L18)/2,(L20-L19)/2
	dc.w	(L21-L20)/2,(L22-L21)/2,(L23-L22)/2,(L24-L23)/2
	dc.w	(L25-L24)/2,(L26-L25)/2,(L27-L26)/2,(L28-L27)/2
	dc.w	(L29-L28)/2,(L30-L29)/2,(L31-L30)/2,(L32-L31)/2
	dc.w	(L33-L32)/2,(L34-L33)/2,(L35-L34)/2,(L36-L35)/2
	dc.w	(L37-L36)/2,(L38-L37)/2,(L39-L38)/2,(L40-L39)/2
	dc.w	(L41-L40)/2,(L42-L41)/2,(L43-L42)/2,(L44-L43)/2
	dc.w	(L45-L44)/2,(L46-L45)/2,(L47-L46)/2,(L48-L47)/2
	dc.w	(L49-L48)/2,(L50-L49)/2,(L51-L50)/2,(L52-L51)/2
	dc.w	(L53-L52)/2,(L54-L53)/2,(L55-L54)/2,(L56-L55)/2
	dc.w	(L57-L56)/2,(L58-L57)/2,(L59-L58)/2,(L60-L59)/2
	dc.w	(L61-L60)/2,(L62-L61)/2,(L63-L62)/2,(L64-L63)/2

C_Tk:	dc.w 	1,0
	dc.b 	$80,-1

	dc.w	-1,L_reset
	dc.b	"prt rese","t"+$80,"V2",-1
	dc.w	-1,L_initialize
	dc.b	"prt ini","t"+$80,"V2",-1
	dc.w	-1,L_italicson
	dc.b	"prt italic","s"+$80,"V2",-1
	dc.w	-1,L_italicsoff
	dc.b	"prt italics of","f"+$80,"V2",-1
	dc.w	-1,L_underlineon
	dc.b	"prt unde","r"+$80,"V2",-1
	dc.w	-1,L_underlineoff
	dc.b	"prt under of","f"+$80,"V2",-1
	dc.w	-1,L_boldon
	dc.b	"prt bol","d"+$80,"V2",-1
	dc.w	-1,L_boldoff
	dc.b	"prt bold of","f"+$80,"V2",-1
	dc.w	-1,L_eliteon
	dc.b	"prt elit","e"+$80,"V2",-1
	dc.w	-1,L_eliteoff
	dc.b	"prt elite of","f"+$80,"V2",-1
	dc.w	-1,L_fineon
	dc.b	"prt fin","e"+$80,"V2",-1
	dc.w	-1,L_fineoff
	dc.b	"prt fine of","f"+$80,"V2",-1
	dc.w	-1,L_enlargedon
	dc.b	"prt enlarge","d"+$80,"V2",-1
	dc.w	-1,L_enlargedoff
	dc.b	"prt enlarged of","f"+$80,"V2",-1
	dc.w	-1,L_shadowon
	dc.b	"prt shado","w"+$80,"V2",-1
	dc.w	-1,L_shadowoff
	dc.b	"prt shadow of","f"+$80,"V2",-1
	dc.w	-1,L_doublestrikeon
	dc.b	"prt doubl","e"+$80,"V2",-1
	dc.w	-1,L_doublestrikeoff
	dc.b	"prt double of","f"+$80,"V2",-1
	dc.w	-1,L_NLQon
	dc.b	"prt nl","q"+$80,"V2",-1
	dc.w	-1,L_NLQoff
	dc.b	"prt nlq of","f"+$80,"V2",-1
	dc.w	-1,L_superscripton
	dc.b	"prt supe","r"+$80,"V2",-1
	dc.w	-1,L_superscriptoff
	dc.b	"prt super of","f"+$80,"V2",-1
	dc.w	-1,L_subscripton
	dc.b	"prt su","b"+$80,"V2",-1
	dc.w	-1,L_subscriptoff
	dc.b	"prt sub of","f"+$80,"V2",-1
	dc.w	-1,L_setUS
	dc.b	"prt set u","s"+$80,"V2",-1
	dc.w	-1,L_setFrench
	dc.b	"prt set frenc","h"+$80,"V2",-1
	dc.w	-1,L_setGerman
	dc.b	"prt set germa","n"+$80,"V2",-1
	dc.w	-1,L_setUK
	dc.b	"prt set u","k"+$80,"V2",-1
	dc.w	-1,L_setDanishI
	dc.b	"prt set danish","i"+$80,"V2",-1
	dc.w	-1,L_setSweden
	dc.b	"prt set swede","n"+$80,"V2",-1
	dc.w	-1,L_setItalian
	dc.b	"prt set italia","n"+$80,"V2",-1
	dc.w	-1,L_setSpanish
	dc.b	"prt set spanis","h"+$80,"V2",-1
	dc.w	-1,L_setJapanese
	dc.b	"prt set japanes","e"+$80,"V2",-1
	dc.w	-1,L_setNorweign
	dc.b	"prt set norg","e"+$80,"V2",-1
	dc.w	-1,L_setDanishII
	dc.b	"prt set danishi","i"+$80,"V2",-1
	dc.w	-1,L_propon
	dc.b	"prt pro","p"+$80,"V2",-1
	dc.w	-1,L_propoff
	dc.b	"prt prop of","f"+$80,"V2",-1
	dc.w	-1,L_leftjustify
	dc.b	"prt ljustif","y"+$80,"V2",-1
	dc.w	-1,L_rightjustiy
	dc.b	"prt rjusti","y"+$80,"V2",-1
	dc.w	-1,L_fulljustify
	dc.b	"prt fjustif","y"+$80,"V2",-1
	dc.w	-1,L_center
	dc.b	"prt cente","r"+$80,"V2",-1
	dc.w	-1,L_linespace8
	dc.b	"prt lspace eigh","t"+$80,"V2",-1
	dc.w	-1,L_linespace6
	dc.b	"prt lspace si","x"+$80,"V2",-1
	dc.w	-1,L_justifyoff
	dc.b	"prt justify of","f"+$80,"V2",-1
	dc.w	-1,L_plineup
	dc.b	"prt pline u","p"+$80,"V2",-1
	dc.w	-1,L_plinedown
	dc.b	"prt pline dow","n"+$80,"V2",-1
	dc.w	-1,L_lmargin
	dc.b	"prt set lmargi","n"+$80,"V2",-1
	dc.w	-1,L_rmargin
	dc.b	"prt set rmargi","n"+$80,"V2",-1
	dc.w	-1,L_tmargin
	dc.b	"prt set tmargi","n"+$80,"V2",-1
	dc.w	-1,L_bmargin
	dc.b	"prt set bmargi","n"+$80,"V2",-1
	dc.w	-1,L_cmargins
	dc.b	"prt clr margin","s"+$80,"V2",-1
	dc.w	-1,L_htab
	dc.b	"prt set hta","b"+$80,"V2",-1
	dc.w	-1,L_vtab
	dc.b	"prt set vta","b"+$80,"V2",-1
	dc.w	-1,L_chtab
	dc.b	"prt clr hta","b"+$80,"V2",-1
	dc.w	-1,L_chtabs
	dc.b	"prt clr htab","s"+$80,"V2",-1
	dc.w	-1,L_cvtab
	dc.b	"prt clr vta","b"+$80,"V2",-1
	dc.w	-1,L_cvtabs
	dc.b	"prt clr vtab","s"+$80,"V2",-1
	dc.w	-1,L_deftabs
	dc.b	"prt set def tab","s"+$80,"V2",-1
	dc.w	0

C_Lib:

******************************************************************
*		COLD START
*

L0	cmp.l	#$41506578,d1
	bne	L0error
	movem.l	a3-a6,-(sp)
	lea	JD(pc),a3
	move.l	a3,ExtAdr+ExtNb*16(a5)
	movem.l	(sp)+,a3-a6
	moveq	#ExtNb,d0
	move.w	#$110,d1
	rts
L0error:
	moveq	#-1,d0
	rts

; data_area
;
JD:
prt_reset
	dc.w	2
	dc.b	27,'c',0
	even
prt_initialize
	dc.w	2
	dc.b	27,'1',0
	even
prt_italicson
	dc.w	4
	dc.b	27,'[3m',0
	even
prt_italicsoff
	dc.w	5
	dc.b	27,'[23m',0
	even
prt_underlineon
	dc.w	4
	dc.b	27,'[4m',0
	even
prt_underlineoff
	dc.w	5
	dc.b	27,'[24m',0
	even
prt_boldon
	dc.w	4
	dc.b	27,'[1m',0
	even
prt_boldoff
	dc.w	5
	dc.b	27,'[22m',0
	even
prt_eliteon
	dc.w	4
	dc.b	27,'[2w',0
	even
prt_eliteoff
	dc.w	4
	dc.b	27,'[1w',0
	even
prt_fineon
	dc.w	4
	dc.b	27,'[4w',0
	even
prt_fineoff
	dc.w	4
	dc.b	27,'[3w',0
	even
prt_enlargedon
	dc.w	4
	dc.b	27,'[6w',0
	even
prt_enlargedoff
	dc.w	4
	dc.b	27,'[5w',0
	even
prt_shadowon
	dc.w	5
	dc.b	27,'[6"z',0
	even
prt_shadowoff
	dc.w	5
	dc.b	27,'[5"z',0
	even
prt_doublestrikeon
	dc.w	5
	dc.b	27,'[4"z',0
	even
prt_doublestrikeoff
	dc.w	5
	dc.b	27,'[3"z',0
	even
prt_NLQon
	dc.w	5
	dc.b	27,'[2"z',0
	even
prt_NLQoff
	dc.w	5
	dc.b	27,'[1"z',0
	even
prt_superscripton
	dc.w	4
	dc.b	27,'[2v',0
	even
prt_superscriptoff
	dc.w	4
	dc.b	27,'[1v',0
	even
prt_subscripton
	dc.w	4
	dc.b	27,'[4v',0
	even
prt_subscriptoff
	dc.w	4
	dc.b	27,'[3v',0
	even
prt_setUS
	dc.w	3
	dc.b	27,'(B',0
	even
prt_setFrench
	dc.w	3
	dc.b	27,'(R',0
	even
prt_setGerman
	dc.w	3
	dc.b	27,'(K',0
	even
prt_setUK
	dc.w	3
	dc.b	27,'(A',0
	even
prt_setDanishI
	dc.w	3
	dc.b	27,'(E',0
	even
prt_setSweden
	dc.w	3
	dc.b	27,'(H',0
	even
prt_setItalian
	dc.w	3
	dc.b	27,'(Y',0
	even
prt_setSpanish
	dc.w	3
	dc.b	27,'(Z',0
	even
prt_setJapanese
	dc.w	3
	dc.b	27,'(J',0
	even
prt_setNorweign
	dc.w	3
	dc.b	27,'(6',0
	even
prt_setDanishII
	dc.w	3
	dc.b	27,'(C',0
	even
prt_propon
	dc.w	4
	dc.b	27,'[2p',0
	even
prt_propoff
	dc.w	4
	dc.b	27,'[1p',0
	even
prt_leftjustify
	dc.w	5
	dc.b	27,'[5 F',0
	even
prt_rightjustiy
	dc.w	5
	dc.b	27,'[7 F',0
	even
prt_fulljustify
	dc.w	5
	dc.b	27,'[6 F',0
	even
prt_center
	dc.w	5
	dc.b	27,'[2 F',0
	even
prt_linespace8
	dc.w	4
	dc.b	27,'[0z',0
	even
prt_linespace6
	dc.w	4
	dc.b	27,'[1z',0
	even
prt_justifyoff
	dc.w	5
	dc.b	27,'[0 F',0
	even
prt_plineup
	dc.w	2
	dc.b	27,'L',0
	even
prt_plinedown
	dc.w	2
	dc.b	27,'K',0
	even
prt_Lmargin
	dc.w	3
	dc.b	27,'#9',0
	even
prt_Rmargin
	dc.w	3
	dc.b	27,'#0',0
	even
prt_Tmargin
	dc.w	3
	dc.b	27,'#8',0
	even
prt_Bmargin
	dc.w	3
	dc.b	27,'#2',0
	even
prt_Cmargins
	dc.w	3
	dc.b	27,'#3',0
	even
prt_htab
	dc.w	2
	dc.b	27,'H',0
	even
prt_vtab
	dc.w	2
	dc.b	27,'J',0
	even
prt_Chtab
	dc.w	4
	dc.b	27,'[0g',0
	even
prt_Chtabs
	dc.w	4
	dc.b	27,'[3g',0
	even
prt_Cvtab
	dc.w	4
	dc.b	27,'[1g',0
	even
prt_Cvtabs
	dc.w	4
	dc.b	27,'[4g',0
	even
prt_deftabs
	dc.w	3
	dc.b	27,'#5',0
	even

**********************************************************************

L1
L2

get_str	equ	3
L3
	moveq	#2,d2
	rts

L_reset	equ	4
L4
	Dlea	prt_reset,d3
	Rbra	get_str
L_initialize	equ	5
L5
	Dlea	prt_initialize,d3
	Rbra	get_str
L_italicson	equ	6
L6
	Dlea	prt_italicson,d3
	Rbra	get_str
L_italicsoff	equ	7
L7
	Dlea	prt_italicsoff,d3
	Rbra	get_str
L_underlineon	equ	8
L8
	Dlea	prt_underlineon,d3
	Rbra	get_str
L_underlineoff	equ	9
L9
	Dlea	prt_underlineoff,d3
	Rbra	get_str
L_boldon	equ	10
L10
	Dlea	prt_boldon,d3
	Rbra	get_str
L_boldoff	equ	11
L11
	Dlea	prt_boldoff,d3
	Rbra	get_str
L_eliteon	equ	12
L12
	Dlea	prt_eliteon,d3
	Rbra	get_str
L_eliteoff	equ	13
L13
	Dlea	prt_eliteoff,d3
	Rbra	get_str
L_fineon	equ	14
L14
	Dlea	prt_fineon,d3
	Rbra	get_str
L_fineoff	equ	15
L15
	Dlea	prt_fineoff,d3
	Rbra	get_str
L_enlargedon	equ	16
L16
	Dlea	prt_enlargedon,d3
	Rbra	get_str
L_enlargedoff	equ	17
L17
	Dlea	prt_enlargedoff,d3
	Rbra	get_str
L_shadowon	equ	18
L18
	Dlea	prt_shadowon,d3
	Rbra	get_str
L_shadowoff	equ	19
L19
	Dlea	prt_shadowoff,d3
	Rbra	get_str
L_doublestrikeon	equ	20
L20
	Dlea	prt_doublestrikeon,d3
	Rbra	get_str
L_doublestrikeoff	equ	21
L21
	Dlea	prt_doublestrikeoff,d3
	Rbra	get_str
L_NLQon	equ	22
L22
	Dlea	prt_NLQon,d3
	Rbra	get_str
L_NLQoff	equ	23
L23
	Dlea	prt_NLQoff,d3
	Rbra	get_str
L_superscripton	equ	24
L24
	Dlea	prt_superscripton,d3
	Rbra	get_str
L_superscriptoff	equ	25
L25
	Dlea	prt_superscriptoff,d3
	Rbra	get_str
L_subscripton	equ	26
L26
	Dlea	prt_subscripton,d3
	Rbra	get_str
L_subscriptoff	equ	27
L27
	Dlea	prt_subscriptoff,d3
	Rbra	get_str
L_setUS	equ	28
L28
	Dlea	prt_setUS,d3
	Rbra	get_str
L_setFrench	equ	29
L29
	Dlea	prt_setFrench,d3
	Rbra	get_str
L_setGerman	equ	30
L30
	Dlea	prt_setGerman,d3
	Rbra	get_str
L_setUK	equ	31
L31
	Dlea	prt_setUK,d3
	Rbra	get_str
L_setDanishI	equ	32
L32
	Dlea	prt_setDanishI,d3
	Rbra	get_str
L_setSweden	equ	33
L33
	Dlea	prt_setSweden,d3
	Rbra	get_str
L_setItalian	equ	34
L34
	Dlea	prt_setItalian,d3
	Rbra	get_str
L_setSpanish	equ	35
L35
	Dlea	prt_setSpanish,d3
	Rbra	get_str
L_setJapanese	equ	36
L36
	Dlea	prt_setJapanese,d3
	Rbra	get_str
L_setNorweign	equ	37
L37
	Dlea	prt_setNorweign,d3
	Rbra	get_str
L_setDanishII	equ	38
L38
	Dlea	prt_setDanishII,d3
	Rbra	get_str
L_propon	equ	39
L39
	Dlea	prt_propon,d3
	Rbra	get_str
L_propoff	equ	40
L40
	Dlea	prt_propoff,d3
	Rbra	get_str
L_leftjustify	equ	41
L41
	Dlea	prt_leftjustify,d3
	Rbra	get_str
L_rightjustiy	equ	42
L42
	Dlea	prt_rightjustiy,d3
	Rbra	get_str
L_fulljustify	equ	43
L43
	Dlea	prt_fulljustify,d3
	Rbra	get_str
L_center	equ	44
L44
	Dlea	prt_center,d3
	Rbra	get_str
L_linespace8	equ	45
L45
	Dlea	prt_linespace8,d3
	Rbra	get_str
L_linespace6	equ	46
L46
	Dlea	prt_linespace6,d3
	Rbra	get_str
L_justifyoff	equ	47
L47
	Dlea	prt_justifyoff,d3
	Rbra	get_str
L_plineup	equ	48
L48
	Dlea	prt_plineup,d3
	Rbra	get_str
L_plinedown	equ	49
L49
	Dlea	prt_plinedown,d3
	Rbra	get_str
L_Lmargin	equ	50
L50
	Dlea	prt_Lmargin,d3
	Rbra	get_str
L_Rmargin	equ	51
L51
	Dlea	prt_Rmargin,d3
	Rbra	get_str
L_Tmargin	equ	52
L52
	Dlea	prt_Tmargin,d3
	Rbra	get_str
L_Bmargin	equ	53
L53
	Dlea	prt_Bmargin,d3
	Rbra	get_str
L_Cmargins	equ	54
L54
	Dlea	prt_Cmargins,d3
	Rbra	get_str
L_htab	equ	55
L55
	Dlea	prt_htab,d3
	Rbra	get_str
L_vtab	equ	56
L56
	Dlea	prt_vtab,d3
	Rbra	get_str
L_Chtab	equ	57
L57
	Dlea	prt_Chtab,d3
	Rbra	get_str
L_Chtabs	equ	58
L58
	Dlea	prt_Chtabs,d3
	Rbra	get_str
L_Cvtab	equ	59
L59
	Dlea	prt_Cvtab,d3
	Rbra	get_str
L_Cvtabs	equ	60
L60
	Dlea	prt_Cvtabs,d3
	Rbra	get_str
L_deftabs	equ	61
L61
	Dlea	prt_deftabs,d3
	Rbra	get_str

*******	error routines
L62
L63

L64

******* TITLE MESSAGE
C_Title:
	dc.b	"AMOSPro Prt_Extension V "
	Version
	dc.b	0,"$VER: "
	Version
	dc.b	0
	even

******* END OF THE EXTENSION
C_End:	dc.w	0
	even
	
