;---------------------------------------------------------------------
;    **    **   **   ***    ***     ****      **     ***   **   ****
;   ****   *** ***  ** **  **       ** **    ****   **     **  **  **
;  **  **  ** * **  ** **   ***     *****   **  **   ***   **  **
;  ******  **   **  ** **     **    **  **  ******     **  **  **
;  **  **  **   **  ** **  *  **    ** **   **  **  *  **  **  **  **
;  **  **  **   **   ***    ***     *****   **  **   ***   **   ****
;---------------------------------------------------------------------
; JD extension source code, V4.6  Last change 12.07.1993
; By Joerg Dommermuth
; AMOS and AMOS Compiler (c) Europress Software 1991
; To be used with AMOSPro V1.12 and over
;--------------------------------------------------------------------- 
; This file is public domain
;---------------------------------------------------------------------


ExtNb	equ	22-1

Version	MACRO
	dc.b	"4.6"
	ENDM

	Incdir	"dh0:AMOS_Pro/Tutorial/Extensions/"
 	Include	"|AMOS_Includes.s"

p1_jbuffer	equ	0
p2_jbuffer	equ	520
paste_jbuffer	equ	1040
bb		equ	1560
tracks		equ	2072


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
	dc.w	(L65-L64)/2,(L66-L65)/2,(L67-L66)/2,(L68-L67)/2
	dc.w	(L69-L68)/2,(L70-L69)/2,(L71-L70)/2,(L72-L71)/2
	dc.w	(L73-L72)/2,(L74-L73)/2,(L75-L74)/2,(L76-L75)/2
	dc.w	(L77-L76)/2,(L78-L77)/2,(L79-L78)/2,(L80-L79)/2
	dc.w	(L81-L80)/2,(L82-L81)/2,(L83-L82)/2,(L84-L83)/2
	dc.w	(L85-L84)/2,(L86-L85)/2,(L87-L86)/2,(L88-L87)/2
	dc.w	(L89-L88)/2,(L90-L89)/2,(L91-L90)/2,(L92-L91)/2
	dc.w	(L93-L92)/2,(L94-L93)/2,(L95-L94)/2,(L96-L95)/2
	dc.w	(L97-L96)/2,(L98-L97)/2,(L99-L98)/2,(L100-L99)/2
	dc.w	(L101-L100)/2,(L102-L101)/2,(L103-L102)/2
	dc.w	(L104-L103)/2,(L105-L104)/2,(L106-L105)/2
	dc.w	(L107-L106)/2,(L108-L107)/2,(L109-L108)/2
	dc.w	(L110-L109)/2,(L111-L110)/2,(L112-L111)/2
	dc.w	(L113-L112)/2,(L114-L113)/2,(L115-L114)/2
	dc.w	(L116-L115)/2,(L117-L116)/2,(L118-L117)/2
	dc.w	(L119-L118)/2,(L120-L119)/2,(L121-L120)/2
	dc.w	(L122-L121)/2,(L123-L122)/2,(L124-L123)/2
	dc.w	(L125-L124)/2,(L126-L125)/2,(L127-L126)/2
	dc.w	(L128-L127)/2,(L129-L128)/2,(L130-L129)/2
	dc.w	(L131-L130)/2,(L132-L131)/2,(L133-L132)/2
	dc.w	(L134-L133)/2,(L135-L134)/2,(L136-L135)/2
	dc.w	(L137-L136)/2,(L138-L137)/2,(L139-L138)/2
	dc.w	(L140-L139)/2,(L141-L140)/2,(L142-L141)/2
	dc.w	(L143-L142)/2,(L144-L143)/2,(L145-L144)/2
	dc.w	(L146-L145)/2,(L147-L146)/2,(L148-L147)/2
	dc.w	(L149-L148)/2,(L150-L149)/2,(L151-L150)/2
	dc.w	(L152-L151)/2,(L153-L152)/2,(L154-L153)/2
	dc.w	(L155-L154)/2,(L156-L155)/2,(L157-L156)/2

C_Tk:	dc.w 	1,0
	dc.b 	$80,-1

	dc.w	-1,L_Pm
	dc.b	"jd compar","e"+$80,"02,2",-1
	dc.w	L_sc,-1
	dc.b	"jd setcloc","k"+$80,"I2",-1
	dc.w	L_sd,-1
	dc.b	"jd setdat","e"+$80,"I2",-1
	dc.w	-1,L_Zeit
	dc.b	"jd time","$"+$80,"2",-1
	dc.w	-1,L_Datum
	dc.b	"jd date","$"+$80,"2",-1
	dc.w	-1,L_cou
	dc.b	"jd coun","t"+$80,"02,2",-1
	dc.w	-1,L_pa
	dc.b	"jd paste","$"+$80,"22,2,2",-1
	dc.w	-1,L_lim
	dc.b	"jd limi","t"+$80,"00,0,0",-1
	dc.w	-1,L_bp
	dc.b	"jd screen plane","s"+$80,"0",-1
	dc.w	-1,L_rez
	dc.b	"jd screen resolutio","n"+$80,"0",-1
	dc.w	-1,L_chc
	dc.b	"jd change","$"+$80,"22",-1
	dc.w	-1,L_fup
	dc.b	"jd firstup","$"+$80,"22",-1
	dc.w	-1,L_ubl
	dc.b	"jd skip","$"+$80,"22",-1
	dc.w	-1,L_cd
	dc.b	"jd crypt","$"+$80,"22",-1
	dc.w	-1,L_dcd
	dc.b	"jd encrypt","$"+$80,"22",-1
	dc.w	-1,L_ext
	dc.b	"jd extend","$"+$80,"22,0,0",-1
	dc.w	-1,L_exv1
	dc.b	"!jd exval","$"+$80,"20,0,2",-2
	dc.w	-1,L_exv
	dc.b	$80,"20,0",-1
	dc.w	L_geta,-1
	dc.b	"jd get are",$80+"a","I2",-1
	dc.w	L_resa,-1
	dc.b	"jd reset are",$80+"a","I",-1
	dc.w	L_drang,-1
	dc.b	"jd draw angl",$80+"e","I0,0,0,0",-1
	dc.w	-1,L_afirst
	dc.b	"jd area firs","t"+$80,"0",-1
	dc.w	-1,L_alast
	dc.b	"jd area las","t"+$80,"0",-1
	dc.w	-1,L_mwait
	dc.b	"jd mwai","t"+$80,"0",-1
	dc.w	-1,L_twait
	dc.b	"jd keywai","t"+$80,"02",-1
	dc.w	-1,L_zahl
	dc.b	"jd get numbe","r"+$80,"00,0",-1
	dc.w	-1,L_rp
	dc.b	"jd rastpor","t"+$80,"0",-1
	dc.w	-1,L_cut
	dc.b	"jd cut","$"+$80,"22,0,0",-1
	dc.w	-1,L_ins
	dc.b	"jd insert","$"+$80,"22,0,2",-1
	dc.w	L_dc,-1
	dc.b	"jd diskchang","e"+$80,"I",-1
	dc.w	-1,L_tam
	dc.b	"jd wait amig","a"+$80,"0",-1
	dc.w	-1,L_gets
	dc.b	"jd get string","$"+$80,"22,0",-1
	dc.w	L_we,-1
	dc.b	"jd wait even","t"+$80,"I",-1
	dc.w	L_spr,-1
	dc.b	"jd sprea","d"+$80,"I2,0,0",-1
	dc.w	L_ts,-1
	dc.b	"jd tscrol","l"+$80,"I2,0,0",-1
	dc.w	-1,L_rors
	dc.b	"jd ror","$"+$80,"22",-1
	dc.w	-1,L_rols
	dc.b	"jd rol","$"+$80,"22",-1
	dc.w	-1,L_rsec
	dc.b	"jd read secto","r"+$80,"20,0",-1
	dc.w	-1,L_wsec
	dc.b	"jd write secto","r"+$80,"02,0,0",-1
	dc.w	-1,L_dcon
	dc.b	"jd dump","$"+$80,"22",-1
	dc.w	-1,L_chksum
	dc.b	"jd checksu","m"+$80,"02",-1
	dc.w	-1,L_bchksum
	dc.b	"jd bootchecksu","m"+$80,"02",-1
	dc.w	-1,L_odd
	dc.b	"jd od","d"+$80,"00",-1
	dc.w	-1,L_oct
	dc.b	"!jd oct","$"+$80,"20",-2
	dc.w	-1,L_oct2
	dc.b	$80,"20,0",-1
	dc.w	-1,L_per
	dc.b	"jd percen","t"+$80,"00,0",-1
	dc.w	-1,L_deoc
	dc.b	"jd deoc","t"+$80,"02",-1
	dc.w	L_hd,-1
	dc.b	"jd hexdum","p"+$80,"I0,0,0,0",-1
	dc.w	L_type,-1
	dc.b	"jd typ","e"+$80,"I2,0,0",-1
	dc.w	-1,L_cdate
	dc.b	"jd actual date","$"+$80,"22,2",-1
	dc.w	-1,L_ctime
	dc.b	"jd actual time","$"+$80,"22,2",-1
	dc.w	L_reset,-1
	dc.b	"jd rese","t"+$80,"I",-1
	dc.w	-1,L_getk
	dc.b	"jd keypres","s"+$80,"0",-1
	dc.w	-1,L_rol
	dc.b	"jd ro","l"+$80,"00,0",-1
	dc.w	-1,L_ror
	dc.b	"jd ro","r"+$80,"00,0",-1
	dc.w	-1,L_roxl
	dc.b	"jd rox","l"+$80,"00,0",-1
	dc.w	-1,L_roxr
	dc.b	"jd rox","r"+$80,"00,0",-1
	dc.w	-1,L_lsl
	dc.b	"jd ls","l"+$80,"00,0",-1
	dc.w	-1,L_lsr
	dc.b	"jd ls","r"+$80,"00,0",-1
	dc.w	-1,L_asl
	dc.b	"jd as","l"+$80,"00,0",-1
	dc.w	-1,L_asr
	dc.b	"jd as","r"+$80,"00,0",-1
	dc.w	-1,L_hw
	dc.b	"jd hardware","$"+$80,"2",-1
	dc.w	-1,L_vol
	dc.b	"jd volume","$"+$80,"2",-1
	dc.w	-1,L_logic
	dc.b	"jd logical","$"+$80,"2",-1
	dc.w	-1,L_charx
	dc.b	"jd char ","x"+$80,"0",-1
	dc.w	-1,L_chary
	dc.b	"jd char ","y"+$80,"0",-1
	dc.w	L_slidx,-1
	dc.b	"jd slide ","x"+$80,"I0t0",-1
	dc.w	L_slidy,-1
	dc.b	"jd slide ","y"+$80,"I0t0",-1
	dc.w	L_slidl,-1
	dc.b	"jd slide lef","t"+$80,"I0t0",-1
	dc.w	L_slidr,-1
	dc.b	"jd slide righ","t"+$80,"I0t0",-1
	dc.w	L_slidu,-1
	dc.b	"jd slide u","p"+$80,"I0t0",-1
	dc.w	L_slidd,-1
	dc.b	"jd slide dow","n"+$80,"I0t0",-1
	dc.w	-1,L_install
	dc.b	"jd instal","l"+$80,"00",-1
	dc.w	-1,L_format
	dc.b	"jd forma","t"+$80,"00,2",-1
	dc.w	-1,L_fcopy
	dc.b	"jd cop","y"+$80,"02,2",-1
	dc.w	L_relab,-1
	dc.b	"jd relabe","l"+$80,"I0,2",-1
	dc.w	-1,L_sformat
	dc.b	"jd shortforma","t"+$80,"00,2",-1
	dc.w	L_squa,-1
	dc.b	"jd squas","h"+$80,"I2,0,0",-1
	dc.w	L_scon,-1
	dc.b	"jd video o","n"+$80,"I",-1
	dc.w	L_scoff,-1
	dc.b	"jd video of","f"+$80,"I",-1
	dc.w	-1,L_lcf
	dc.b	"jd largest chip fre","e"+$80,"0",-1
	dc.w	-1,L_lff
	dc.b	"jd largest fast fre","e"+$80,"0",-1
	dc.w	-1,L_fsize
	dc.b	"jd file siz","e"+$80,"02",-1
	dc.w	-1,L_ftype
	dc.b	"jd file typ","e"+$80,"02",-1
	dc.w	-1,L_ppmem
	dc.b	"jd ppfind me","m"+$80,"00",-1
	dc.w	L_ppdecrunch,-1
	dc.b	"jd ppdecrunc","h"+$80,"I0,0,0",-1
	dc.w	-1,L_stream
	dc.b	"jd stream","$"+$80,"20,0,0",-1
	dc.w	-1,L_fprot
	dc.b	"jd file protectio","n"+$80,"02",-1
	dc.w	-1,L_fcomm
	dc.b	"jd file comment","$"+$80,"22",-1
	dc.w	-1,L_sprot
	dc.b	"jd set protectio","n"+$80,"02,0",-1
	dc.w	-1,L_scomm
	dc.b	"jd set commen","t"+$80,"02,2",-1
	dc.w	L_drawseg,-1
	dc.b	"jd draw segmen","t"+$80,"I0,0,0,0,0,0",-1
	dc.w	-1,L_cp
	dc.b	"jd checkpr","t"+$80,"0",-1
	dc.w	L_spline,-1
	dc.b	"jd splin","e"+$80,"I0,0,0,0,0,0,0",-1
	dc.w	-1,L_linstr
	dc.b	"jd linst","r"+$80,"02,2",-1
	dc.w	-1,L_e
	dc.b	"jd e","#"+$80,"V0",-1
	dc.w	-1,L_imp
	dc.b	"jd im","p"+$80,"00,0",-1
	dc.w	-1,L_eqv
	dc.b	"jd eq","v"+$80,"00,0",-1
	dc.w	-1,L_getsb
	dc.b	"jd intscreen bas","e"+$80,"0",-1
	dc.w	-1,L_getwb
	dc.b	"jd intwindow bas","e"+$80,"0",-1
	dc.w	L_font,-1
	dc.b	"jd textfon","t"+$80,"I2,0",-1
	dc.w	L_print,-1
	dc.b	"jd prin","t"+$80,"I2",-1
	dc.w	-1,L_dist
	dc.b	"jd distanc","e"+$80,"00,0t0,0",-1
	dc.w	-1,L_p
	dc.b	"jd pi","#"+$80,"V0",-1
	dc.w	-1,L_arcus
	dc.b	"jd arcu","s"+$80,"00,0t0,0",-1
	dc.w	-1,L_tts
	dc.b	"jd timesec","s"+$80,"02",-1
	dc.w	-1,L_stt
	dc.b	"jd secstime","$"+$80,"20",-1
	dc.w	-1,L_xpo
	dc.b	"jd x po","s"+$80,"00,0,0,0",-1
	dc.w	-1,L_ypo
	dc.b	"jd y po","s"+$80,"00,0,0,0",-1
	dc.w	L_flush,-1
	dc.b	"jd flus","h"+$80,"I",-1
	dc.w	-1,L_countdirs
	dc.b	"jd count dir","s"+$80,"02",-1
	dc.w	-1,L_countfiles
	dc.b	"jd count file","s"+$80,"02",-1
	dc.w	-1,L_detab
	dc.b	"jd deta","b"+$80,"22,0",-1
	dc.w	-1,L_gtab
	dc.b	"jd get ta","b"+$80,"0",-1
	dc.w	L_private,-1
	dc.b	"jd privat","e"+$80,"I",-1
	dc.w	-1,L_mclick
	dc.b	"jd moff clic","k"+$80,"0",-1
	dc.w	-1,L_mkey
	dc.b	"jd moff ke","y"+$80,"0",-1
	dc.w	L_moff,-1
	dc.b	"jd multi of","f"+$80,"I",-1
	dc.w	L_mon,-1
	dc.b	"jd multi o","n"+$80,"I",-1
	dc.w	-1,L_dclick
	dc.b	"jd double clic","k"+$80,"0",-1
	dc.w	L_dledoff,-1
	dc.b	"jd dled of","f"+$80,"I",-1
	dc.w	L_dledon,-1
	dc.b	"jd dled o","n"+$80,"I",-1
	dc.w	L_reddim,-1
	dc.b	"jd reduce di","m"+$80,"I0,0",-1
	dc.w	L_resdim,-1
	dc.b	"jd reset di","m"+$80,"I0",-1
	dc.w	L_aswap,-1
	dc.b	"jd array swa","p"+$80,"I0,0,0",-1
	dc.w	L_aclear,-1
	dc.b	"jd array$ clea","r"+$80,"I0",-1
	dc.w	L_aclear2,-1
	dc.b	"jd array clea","r"+$80,"I0",-1
	dc.w 	0


C_Lib:

******************************************************************
*		COLD START
*

L0	cmp.l	#$41506578,d1
	bne	L0error
	movem.l	a3-a6,-(sp)
	move.l	4,a6
	move.l	#7760,d0
	move.l	#$30004,d1
	jsr	-198(a6)
	tst.l	d0
	beq	startup_error
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

; data_area
;
	cnop	0,4
JD:
reg_a5:	dc.l	0
memory_buffers:
	dc.l	0
rastport:
	dc.l	0
fontname:
	dc.b	'diskfont.library',0
	even
gfxname:
	dc.b	'graphics.library',0
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
jan:	dc.l	31,28
mar:	dc.l	31,30,31,30,31,31,30,31,30,31,0
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
msgport:
	dc.l	0,0,0,0,0,0,0,0
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
Validate:
	dc.b	'Validator',0
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
diskio:	ds.l	21
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
fib:	ds.l	66
_sin:	dc.l	0
_cos:	dc.l	0
dimlist:
	ds.l	30
dimendlist:
	dc.l	0
cosinus:
	dc.l	$80000041,$FFF60540,$FFD81440,$FFA63040,$FF605C40,$FF069E40
	dc.l	$aFE98FD40,$FE178240,$FD823640,$FCD92540,$FC1C5D40,$FB4BEC40
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

**********************************************************************

L1

L_private	equ	2
L2
	bug
	rts

******* PATMAT (string,pattern)
L_Pm		equ	3
L3
Pm:	movem.l	a4-a6,-(sp)
	movem.l	(a3)+,a0-a1
	move.w	(a0)+,d0
	Dsave	a0,jpattern
	move.w	(a1)+,d0
	Dsave	a1,string
	bsr	fpattype
	bsr	search
	Rbsr	uninit
	movem.l	(sp)+,a4-a6
	moveq	#0,d2
	rts
fpattype:
	Dmove	jpattern,a0
	cmp.l	#0,a0
	beq	all
	cmp.b	#0,(a0)
	beq	all
	cmp.b	#'*',(a0)
	beq	JOKER
_ooo_:
	add.l	#1,a0
	cmp.b	#0,(a0)
	beq	one
	cmp.b	#'*',(a0)
	beq	_ooo_JOKER
	bra	_ooo_
_ooo_JOKER:
	add.l	#1,a0
	cmp.b	#0,(a0)
	beq	prefix
	bra	pre_suffix
JOKER:
	add.l	#1,a0
	cmp.b	#0,(a0)
	beq	all
JOKER_ooo_:
	add.l	#1,a0
	cmp.b	#0,(a0)
	beq	suffix
	cmp.b	#'*',(a0)
	beq	midfix
	bra	JOKER_ooo_
all:
	Dsave	#$00000000,p_case
	rts
one:
	Dsave	#$11111111,p_case
	rts
suffix:
	Dsave	#$00001111,p_case
	Mlea	p2_jbuffer,a1
	Dmove	jpattern,a0
	add.l	#1,a0
suffix_loop:
	cmp.b	#0,(a0)
	beq	p_end
	move.b	(a0)+,(a1)+
	bra	suffix_loop
prefix:
	Dsave	#$11110000,p_case
	Mlea	p1_jbuffer,a1
	Dmove	jpattern,a0
prefix_loop:
	cmp.b	#'*',(a0)
	beq	p_end
	move.b	(a0)+,(a1)+
	bra	prefix_loop
pre_suffix:
	Dsave	#$11100111,p_case
	Mlea	p1_jbuffer,a1
	Dmove	jpattern,a0
pre_suffix_loop1:
	cmp.b	#'*',(a0)
	beq	p_s_end
	move.b	(a0)+,(a1)+
	bra	pre_suffix_loop1
p_s_end:
	Mlea	p2_jbuffer,a1
	add.l	#1,a0
pre_suffix_loop2:
	cmp.b	#0,(a0)
	beq	p_end
	move.b	(a0)+,(a1)+
	bra	pre_suffix_loop2
midfix:
	Dsave	#$00011000,p_case
	Mlea	p1_jbuffer,a1
	Dmove	jpattern,a0
	add.l	#1,a0
midfix_loop:
	cmp.b	#'*',(a0)
	beq	p_end
	move.b	(a0)+,(a1)+
	bra	midfix_loop
p_end:
	rts
search:
	Dmove2	string,p_case,a0,d0
	cmp.l	#$00000000,d0
	beq	jpattern_ok
	cmp.l	#$11111111,d0
	beq	compare_one
	cmp.l	#$11110000,d0
	beq	compare_prefix
	cmp.l	#$00001111,d0
	beq	compare_suffix
	cmp.l	#$11100111,d0
	beq	compare_pre_suffix
	cmp.l	#$00011000,d0
	beq	compare_midfix
	move.l	#-1,d3
	rts
compare_one:
	Dmove	jpattern,a1
cmp_one:
	cmp.b	#0,(a0)
	beq	really_one
	cmp.b	#'?',(a1)
	bne	cmp1
	add.l	#1,a0
	add.l	#1,a1
	bra	cmp_one
cmp1:
	cmp.b	(a0)+,(a1)+
	bne	jpattern_not_ok
	bra	cmp_one
really_one:
	cmp.b	#0,(a1)
	bne	jpattern_not_ok
	bra	jpattern_ok
compare_prefix:
	Mlea	p1_jbuffer,a1
cmp_prefix:
	cmp.b	#0,(a1)
	beq	jpattern_ok
	cmp.b	#'?',(a1)
	bne	cmp2
	add.l	#1,a0
	add.l	#1,a1
	bra	cmp_prefix
cmp2:
	cmp.b	(a0)+,(a1)+
	bne	jpattern_not_ok
	bra	cmp_prefix
compare_suffix:
	Mlea	p2_jbuffer,a1
	move.b	#0,d7
cmp01:
	add.b	#1,d7
	cmp.b	#0,(a1)
	beq	cmp02
	add.l	#1,a1
	bra	cmp01
cmp02:
	cmp.b	#0,(a0)
	beq	cmp_suffix
	add.l	#1,a0
	bra	cmp02
cmp_suffix:
	cmp.b	#0,d7
	beq	jpattern_ok
	cmp.b	#'?',(a1)
	bne	cmp3
	sub.l	#1,a0
	sub.l	#1,a1
	sub.b	#1,d7
	bra	cmp_suffix
cmp3:
	cmp.b	(a0)+,(a1)+
	bne	jpattern_not_ok
	sub.l	#2,a0
	sub.l	#2,a1
	sub.b	#1,d7
	bra	cmp_suffix
compare_pre_suffix:
	Mlea	p1_jbuffer,a1
cmp_pre_suffix:
	cmp.b	#0,(a1)
	beq	compare_suffix
	cmp.b	#'?',(a1)
	bne	cmp4
	add.l	#1,a0
	add.l	#1,a1
	bra	cmp_pre_suffix
cmp4:
	cmp.b	(a0)+,(a1)+
	bne	jpattern_not_ok
	bra	cmp_pre_suffix
compare_midfix:
	Dsave	a0,jbuffer
cmp_mid_fix:
	Dmove	jbuffer,a0
	cmp.b	#0,(a0)
	beq	jpattern_not_ok
	Mlea	p1_jbuffer,a1
cmp_midfix:
	cmp.b	#0,(a1)
	beq	jpattern_ok
	cmp.b	#'?',(a1)
	bne	cmp5
	add.l	#1,a0
	add.l	#1,a1
	bra	cmp_midfix
cmp5:
	cmp.b	(a0)+,(a1)+
	bne	not_yet
	bra	cmp_midfix
not_yet:
	Dlea	jbuffer,a6
	add.l	#1,(a6)
	bra	cmp_mid_fix
jpattern_ok:
	move.l	#1,d3
	rts
jpattern_not_ok:
	move.l	#0,d3
	rts

******* SETCLOCK "hh:mm:ss"
L_sc	equ	4
L4
sc:	Dlea	ttmmjj,a1
	move.l	(a3)+,a0
	move.w	(a0)+,d0
	tst.w	d0
	beq	no_param
	Dlea	tt,a2
	bsr	copy
	add.l	#2,a1
	bsr	copy
	add.l	#2,a1
	bsr	copy2
	bsr	test
	bsr	test_t
	Dlea	ttmmjj,a0
	lea	$dc0000,a1
	move.l	#5,d1
ttl:	move.b	(a0)+,d0
	sub.b	#48,d0
	ext.w	d0
	move.w	d0,(a1)+
	add.l	#2,a1
	dbra	d1,ttl
	rts
test_t:	Dlea	ttmmjj,a0
	move.w	(a0)+,d2
	move.w	(a0)+,d1
	move.w	(a0)+,d0
	Dlea	ttmmjj,a0
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	rts
copy:	move.b	(a0)+,d0
	cmp.b	#':',(a0)
	beq	one_b
	move.b	(a0)+,d1
	cmp.b	#':',(a0)+
	bne	error
	move.b	d1,(a1)
	move.b	d0,1(a1)
	move.b	d0,(a2)+
	move.b	d1,(a2)+
	rts
one_b:	move.b	#'0',1(a1)
	move.b	d0,(a1)
	add.l	#1,a0
	move.b	#'0',(a2)+
	move.b	d0,(a2)+
	rts
error:	move.l	(sp)+,d0
	rts
copy2:	move.b	(a0)+,d0
	move.b	(a0)+,d1
	cmp.b	#0,(a0)+
	bne	error
	cmp.b	#0,d1
	bne	cc2
	move.b	#'0',d1
cc2:	move.b	d1,1(a1)
	move.b	d0,(a1)
	move.b	d1,(a2)+
	move.b	d0,(a2)+
	rts
test:	Dlea	tt,a0
	cmp.w	#'23',(a0)+
	bgt	error
	cmp.w	#'59',(a0)+
	bgt	error
	cmp.w	#'59',(a0)+
	bgt	error
no_param:
	rts

******* SETDATE "tt.mm.jj"
L_sd	equ	5
L5
sd:	Dlea	ttmmjj,a1
	move.l	(a3)+,a0
	move.w	(a0)+,d0
	tst.w	d0
	beq	no_param2
	Dlea	tt,a2
	bsr	copy3
	add.l	#2,a1
	bsr	copy3
	add.l	#2,a1
	bsr	copy4
	bsr	test3
	Dlea	ttmmjj,a0
	lea	$dc0018,a1
	move.l	#5,d1
ddl:	move.b	(a0)+,d0
	sub.b	#48,d0
	ext.w	d0
	move.w	d0,(a1)+
	add.l	#2,a1
	dbra	d1,ddl
	rts
error2:	movem.l	(sp)+,d0
no_param2:
	rts
test3:	Dlea	tt,a0
	cmp.w	#'31',(a0)+
	bgt	error2
	cmp.w	#'12',(a0)+
	bgt	error2
	rts
copy3:	move.b	(a0)+,d0
	cmp.b	#'.',(a0)
	beq	one_b3
	move.b	(a0)+,d1
	cmp.b	#'.',(a0)+
	bne	error2
	move.b	d1,(a1)
	move.b	d0,1(a1)
	move.b	d0,(a2)+
	move.b	d1,(a2)+
	rts
one_b3:	move.b	#'0',1(a1)
	move.b	d0,(a1)
	add.l	#1,a0
	move.b	#'0',(a2)+
	move.b	d0,(a2)+
	rts
copy4:	move.b	(a0)+,d0
	move.b	(a0)+,d1
	cmp.b	#0,(a0)+
	bne	error2
	move.b	d1,(a1)
	move.b	d0,1(a1)
	rts

******* TIME$
L_Zeit	equ	6
L6
Zeit:
	lea	$dc0000,a2
	Dlea	hms,a0
	Rbsr	dz
	Dlea	hms,a0
	Dlea	time,a1
	move.w	#8,(a1)+
	move.b	5(a0),(a1)+
	move.b	4(a0),(a1)+
	move.b	#':',(a1)+
	move.b	3(a0),(a1)+
	move.b	2(a0),(a1)+
	move.b	#':',(a1)+
	move.b	1(a0),(a1)+
	move.b	(a0),(a1)+
	moveq	#2,d2
	Dlea	time,a0
	move.l	a0,d3
	rts

******* DATE$
L_Datum	equ	7
L7
Datum:	movem.l	a3-a6,-(sp)
	move.l	DosBase(a5),a6
	Dlea	date,a0
	move.l	a0,d1
	jsr	-192(a6)
	move.l	d0,a0
	move.l	(a0),d0
	move.l	#1978,d1
	move.l	#7,d2
do:	move.l	d0,d5
	move.l	#0,d3
	move.l	d1,d4
	and	#3,d4
	cmp	#0,d4
	bne	d30
	move.l	#1,d3
d30:	sub.l	d3,d0
	sub.l	#365,d0
	cmp.l	#0,d0
	blt	exit
	move.l	d5,d0
	add.l	d3,d2
	add.l	#1,d2
	cmp.l	#7,d2
	ble	d2l7
	sub.l	#7,d2
d2l7:	move.l	d5,d0
	sub.l	d3,d0
	sub.l	#365,d0
	add.l	#1,d1
	bra	do
exit:	move.l	d5,d0
	move.l	#1,d6
	Dlea	jan,a1
	Dlea	mar,a2
do2:	move.l	(a1)+,d4
	cmp.l	a2,a1
	bne	nofeb
	add.l	d3,d4
nofeb:	move.l	d0,d5
	sub.l	d4,d5
	cmp.l	#0,d5
	blt	exit2
	sub.l	d4,d0
	add.l	#1,d6
	bra	do2
exit2:	add.l	#1,d0
	move.l	d1,d2
	move.l	d6,d1
	Dlea	tmj2,a0
	move.w	#10,(a0)+
	movem.l	d1-d2,-(sp)
	cmp.l	#10,d0
	bge	no1
	move.b	#'0',(a0)+
no1:	bsr	dbinto_dec
	move.b	#'.',(a0)+
	movem.l	(sp)+,d1-d2
	move.l	d1,d0
	movem.l	d2,-(sp)
	cmp.l	#10,d0
	bge	no3
	move.b	#'0',(a0)+
no3:	bsr	dbinto_dec
	move.b	#'.',(a0)+
	movem.l	(sp)+,d2
	move.l	d2,d0
	bsr	dbindec1
	move.b	#0,(a0)+
	movem.l	(sp)+,a3-a6
	Dlea	tmj2,a0
	move.l	a0,d3
	moveq	#2,d2
	rts
dbinto_dec:
	ext.l	d0
dbindec1:
	tst.l	d0
	beq	dbindec6
	neg.l	d0
	bra	dbindec2
dbindec2:
	Dlea	decathlon,a1
	clr.w	d1
dbindec3:
	move.l	(a1)+,d2
	beq	dbindec6
	moveq	#-1,d4
dbindec4:
	add.l	d2,d0
	dbgt	d4,dbindec4
	sub.l	d2,d0
	addq.w	#1,d4
	bne	dbindec5
	tst.w	d1
	beq	dbindec3
dbindec5:
	moveq	#-1,d1
	neg.b	d4
	addi.b	#$30,d4
	move.b	d4,(a0)+
	bra	dbindec3
dbindec6:
	neg.b	d0
	addi.b	#$30,d0
	move.b	d0,(a0)+
	add.l	#2,a2
	rts
******* COUNT(string,instring)
L_cou	equ	8
L8
cou:	movem.l	a4-a6,-(sp)
	move.l	#0,d3
	move.l	(a3)+,a1
	cmp.w	#0,(a1)+
	beq	vpno
	Dsave	a1,p1jbuffer
	move.l	(a3)+,a0
	movem.l	a3,-(sp)
	cmp.w	#0,(a0)+
	beq	pno
	Dsave	a0,jbuffer
cmf:
	Dmove2	jbuffer,p1jbuffer,a0,a1
	cmp.b	#0,(a0)
	beq	pno
cmfix:
	cmp.b	#0,(a1)
	beq	pok
	cmp.b	(a0)+,(a1)+
	bne	ny
	bra	cmfix
ny:
	Dlea	jbuffer,a6
	add.l	#1,(a6)
	bra	cmf
vpno:
	move.l	(a3)+,d2
	movem.l	a3,-(sp)
pno:
	moveq	#0,d2
	Dsave2	#0,#0,jbuffer,p1jbuffer
	movem.l	(sp)+,a3
	movem.l	(sp)+,a4-a6
	rts
pok:
	add.l	#1,d3
	bra	ny

******* PASTE$(string,instring,pastestring)
L_pa	equ	9
L9
_paste:	movem.l	a3-a6,-(sp)
	Rbsr	uninit
	movem.l	(sp)+,a3-a6
	move.l	(a3)+,a2
	move.l	(a3)+,a1
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	Dsave3	a0,a1,a2,string,instring,pastestring
	move.w	(a1),d0
	ext.l	d0
	Dsave	d0,paste_len
	cmp.w	#0,(a0)
	beq	_error
	cmp.w	#0,(a1)
	beq	_error
	add.l	#2,a0
	add.l	#2,a1
	add.l	#2,a2
	Mlea	paste_jbuffer,a4
	add.l	#2,a4
palo:	cmp.b	#0,(a0)
	beq	paste_ready
	bsr	_instr
	bra	palo
paste_ready:
	move.b	#0,(a4)+
	Mlea	paste_jbuffer,a0
	move.l	a0,a1
	add.l	#2,a0
	move.w	#0,d0
g_plen:	cmp.b	#0,(a0)+
	beq	is_len
	add.w	#1,d0
	bra	g_plen
is_len:	move.w	d0,(a1)
	Rbsr	getmem
	Dmove	var_buffer,a1
	cmp.l	#0,a1
	beq	nomemory
	Mlea	paste_jbuffer,a0
	move.w	(a0)+,(a1)+
compl:	cmp.b	#0,(a0)
	beq	complete
	move.b	(a0)+,(a1)+
	bra	compl
complete:
	move.b	#0,(a1)+
	Dmove	var_buffer,d3
	moveq	#2,d2
	movem.l	(sp)+,a3-a6
	rts
nomemory:
	movem.l	(sp)+,a3-a6
	moveq	#24,d0
	Rjmp	L_Error
_instr:	movem.l	a0/a1,-(sp)
instl:	cmp.b	#0,(a1)
	beq	is_in
	cmp.b	(a0)+,(a1)+
	bne	not_in
	bra	instl
not_in:	movem.l	(sp)+,a0/a1
	move.b	(a0)+,(a4)+
	rts
is_in:	movem.l	(sp)+,a0/a1
	movem.l	a2,-(sp)
isinl:	cmp.b	#0,(a2)
	beq	is_pasted
	move.b	(a2)+,(a4)+
	bra	isinl
is_pasted:
	Dmove	paste_len,d0
	add.l	d0,a0
	movem.l	(sp)+,a2
	rts
_error:	Dmove	string,d3
	Rbsr	err_get
	moveq	#2,d2
	rts

******* LIMIT(zahl,min,max)
L_lim	equ	10
L10
lim:	movem.l	(a3)+,d0-d2
	cmp.l	d2,d0
	blt	limerr
	cmp.l	d2,d1
	bgt	limerr
	moveq	#0,d2
	move.l	#1,d3
	rts
limerr:	moveq	#0,d2
	move.l	#0,d3
	rts

******* SCREEN PLANES
L_bp	equ	11
L11
bp:	move.l	ScOnAd(a5),a0
	add.l	#80,a0
	move.w	(a0),d3
	ext.l	d3
	moveq	#0,d2
	rts

******* SCREEN RESOLUTION
L_rez	equ	12
L12
rez:	move.l	ScOnAd(a5),a0
	add.l	#72,a0
	moveq	#0,d3
	move.w	(a0),d3
	and.w	#$8804,d3
	cmp.w	#$8000,d3
	bne	no_neg
	neg.w	d3
no_neg:	ext.l	d3
	swap.w	d3
	move.w	#$0000,d3
	swap.w	d3
	moveq	#0,d2
	rts
******* CHCASE(string)
L_chc	equ	13
L13
chc:	movem.l	a4-a6,-(sp)
	move.l	(a3)+,a0
	movem.l	a0,-(sp)
	move.w	(a0),d0
	Rbeq	g_err
	Rbsr	getmem
	cmp.l	#0,d0
	Rbeq	g_err
	Dmove	var_buffer,a1
	movem.l	(sp)+,a0
	move.w	(a0)+,(a1)+
	bsr	changecase
	movem.l	(sp)+,a4-a6
	moveq	#2,d2
	Dmove	var_buffer,d3
	rts
changecase:
	cmp.b	#0,(a0)
	beq	changeend
	move.b	(a0)+,d2
	cmp.b	#'A',d2
	blt	no2
	cmp.b	#'Z',d2
	ble	ch
	cmp.b	#'a',d2
	blt	no2
	cmp.b	#'z',d2
	bgt	no2
ch:	eori.b	#%00100000,d2
no2:
	move.b	d2,(a1)+
	bra	changecase
changeend:
	move.b	#0,(a1)
	rts

*******	FIRSTUP$(string)
L_fup	equ	14
L14
fup:	movem.l	a4-a6,-(sp)
	move.l	(a3)+,a0
	movem.l	a0,-(sp)
	move.w	(a0),d0
	Rbeq	g_err
	Rbsr	getmem
	cmp.l	#0,d0
	Rbeq	g_err
	Dmove	var_buffer,a1
	movem.l	(sp)+,a0
	move.w	(a0)+,(a1)+
	bsr	fiup
	movem.l	(sp)+,a4-a6
	moveq	#2,d2
	Dmove	var_buffer,d3
	rts
fiup:	move.b	(a0)+,d2
	beq	fiupend
	cmp.b	#'a',d2
	blt	noflip
	cmp.b	#'z',d2
	bgt	noflip
flip:	eori.b	#%00100000,d2
noflip:	move.b	d2,(a1)+
	cmp.b	#' ',d2
	beq	fiup
nf2:	move.b	(a0)+,d2
	beq	fiupend
	move.b	d2,(a1)+
	cmp.b	#'0',d2
	blt	fiup
	cmp.b	#'z',d2
	bgt	fiup
	bra	nf2
fiupend:
	move.b	#0,(a1)+
	rts

******* SKIP$("string")
L_ubl	equ	15
L15
ubl:	movem.l	a4-a6,-(sp)
	move.l	(a3)+,a0
	move.l	a0,-(sp)
	move.w	(a0),d0
	Rbeq	g_err
	Rbsr	getmem
	cmp.l	#0,d0
	Rbeq	g_err
	Dmove	var_buffer,a1
	movem.l	(sp)+,a0
	move.w	(a0),d3
	move.w	(a0)+,(a1)+
	beq	enubl1
ubl2:	move.b	(a0)+,d0
	cmp.b	#' ',d0
	bne	ubl3
	sub.w	#1,d3
	bra	ubl2
ubl3:	move.b	d0,(a1)+
ubl4:	move.b	(a0)+,(a1)+
	bne	ubl4
	sub.l	#1,a1
ubl5:	cmp.b	#' ',-(a1)
	bne	enubl
	move.b	#0,(a1)
	sub.w	#1,d3
	bra	ubl5
enubl:	Dmove	var_buffer,a0
	move.w	d3,(a0)
enubl1:	movem.l	(sp)+,a4-a6
	moveq	#2,d2
	Dmove	var_buffer,d3
	rts
******* CRYPT$(string)
L_cd	equ	16
L16
cd:	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	movem.l	a0,-(sp)
	move.w	(a0),d0
	Rbeq	cr_err
	Rbsr	getmem
	cmp.l	#0,d0
	Rbeq	cr_err
	Dmove	var_buffer,a1
	movem.l	(sp)+,a0
	move.w	(a0)+,(a1)+
	bsr	code
	movem.l	(sp)+,a3-a6
	moveq	#2,d2
	Dmove	var_buffer,d3
	rts
code:	moveq	#0,d0
cl2:	Dlea	y,a2
	move.b	#0,d0
	cmp.b	#0,(a0)
	bne	cl
	move.b	#0,(a1)+
	rts
cl3:	add.l	#1,a2
cl:	move.b	(a0),d2
	move.b	(a2),d3
	cmp.b	d2,d3
	beq	conv
	add.b	#1,d0
	cmp.w	#yend-y,d0
	beq	cop
	bra	cl3
cop:	move.b	(a0)+,(a1)+
	bra	cl2
conv:	move.b	d0,(a1)+
	add.l	#1,a0
	bra	cl2

******* ENCRYPT$(string)
L_dcd	equ	17
L17
dcd:	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	movem.l	a0,-(sp)
	move.w	(a0),d0
	Rbeq	cr_err
	Rbsr	getmem
	cmp.l	#0,d0
	Rbeq	cr_err
	Dmove	var_buffer,a4
	movem.l	(sp)+,a0
	move.w	(a0)+,(a4)+
	bsr	decode
	movem.l	(sp)+,a3-a6
	moveq	#2,d2
	Dmove	var_buffer,d3
	rts
decode:	moveq	#0,d0
dcl2:	Dlea	y,a1
	Dlea	y2,a2
	move.b	#0,d0
	cmp.b	#0,(a0)
	bne	dcl
	move.b	#0,(a4)+
	rts
dcl3:	add.l	#1,a2
	add.l	#1,a1
dcl:	move.b	(a0),d2
	move.b	(a2),d3
	move.b	(a1),d4
	cmp.b	d2,d3
	beq	dconv
	add.b	#1,d0
	cmp.w	#y2end-y2,d0
	beq	dcop
	bra	dcl3
dcop:	move.b	d2,(a4)+
	add.l	#1,a0
	bra	dcl2
dconv:	move.b	d4,(a4)+
	add.l	#1,a0
	bra	dcl2

******* EXTEND$(string,len,kind)
L_ext	equ	18
L18
ext:	movem.l	a4-a6,-(sp)
	move.l	(a3)+,d0
	Dsave	d0,kind
	Dlea	wlm,a6
	move.l	(a3)+,(a6)
	move.l	(a3)+,a0
	Dsave	a0,zw
	move.w	(a0)+,d0
	beq	eerr
	ext.l	d0
	Dsave	d0,wl
	Dmove2	wl,wlm,d0,d1
	sub.l	d0,d1
	ble	eerr
	Dmove	wlm,d0
	beq	eerr
	Rbsr	get_mem
	cmp.l	#0,d0
	beq	eerr
	Dmove2	var_buffer,kind,a1,d0
	cmp.l	#0,d0
	beq	extend
	bpl	rit_ext
	bra	lef_ext
leave_ext:
	movem.l	(sp)+,a4-a6
	moveq	#2,d2
	Dmove	var_buffer,d3
	rts
eerr:	movem.l	(sp)+,a4-a6
	Dmove	zw,d3
	Rbsr	err_get
	moveq	#2,d2
	rts
extend:	Dmove2	wlm,wl,d1,d0
	sub.l	d0,d1
	lsr.l	#1,d1
	Dsave	d1,wl1
	Dmove	wlm,d0
	sub.l	d1,d0
	Dmove	wl,d1
	sub.l	d1,d0
	Dsave	d0,wl2
	Dmove2	var_buffer,zw,a1,a0
	add.l	#2,a0
	Dmove	wlm,d0
	move.w	d0,(a1)+
	Dmove	wl1,d0
	beq	elne
	sub.l	#1,d0
elo:	move.b	#' ',(a1)+
	dbra	d0,elo
elne:	Dmove.l	wl,d0
	sub.l	#1,d0
elo2:	move.b	(a0)+,(a1)+
	dbra	d0,elo2
	Dmove	wl2,d0
	beq	elne2
	sub.l	#1,d0
elo3:	move.b	#' ',(a1)+
	dbra	d0,elo3
elne2:	move.b	#0,(a1)+
	bra	leave_ext
lef_ext:
	Dmove2	wlm,wl,d1,d0
	sub.l	d0,d1
	sub.l	#1,d1
	Dmove2	var_buffer,wlm,a1,d3
	move.w	d3,(a1)+
lel:	move.b	#' ',(a1)+
	dbra	d1,lel
	Dmove	zw,a0
	move.w	(a0)+,d0
	ext.l	d0
lel2:	move.b	(a0)+,(a1)+
	dbra	d0,lel2
	bra	leave_ext
rit_ext:
	Dmove3	wlm,wl,var_buffer,d1,d0,a1
	move.l	d1,d3
	sub.l	d0,d1
	sub.l	#1,d1
	move.w	d3,(a1)+
	Dmove	zw,a0
	move.w	(a0)+,d0
	ext.l	d0
	sub.l	#1,d0
rel:	move.b	(a0)+,(a1)+
	dbra	d0,rel
rel2:	move.b	#' ',(a1)+
	dbra	d1,rel2
	move.b	#0,(a1)+
	bra	leave_ext
******* EXVAL$(val,len,blank/null$)
L_exv1	equ	19
L19
exv1:	movem.l	a4-a6,-(sp)
	Dsave	#0,blanull
	move.l	(a3)+,a0
	add.l	#2,a0
	cmp.b	#'0',(a0)
	beq	go_exv
	Dsave	#1,blanull
go_exv:	movem.l	(sp)+,a4-a6
	Rbra	L_exv
******* EXVAL$(val,len)
L_exv	equ	20
L20
exv:	movem.l	a4-a6,-(sp)
	Dlea	wlm,a6
	move.l	(a3)+,(a6)
	add.l	#1,(a6)
	bsr	mstr
	Dsave	a0,zw
	move.w	(a0)+,d0
	ext.l	d0
	Dsave	d0,wl
	Dmove2	wl,wlm,d0,d1
	sub.l	d0,d1
	ble	xerr
	Dmove	wlm,d0
	beq	xerr
	Rbsr	get_mem
	cmp.l	#0,d0
	beq	xerr
	Dmove	var_buffer,a1
	bsr	exvend
	bsr	vorz
	Dlea	str,a0
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)
	movem.l	(sp)+,a4-a6
	moveq	#2,d2
	Dmove	var_buffer,d3
	rts
xerr:	movem.l	(sp)+,a4-a6
	Dmove	zw,d3
	moveq	#2,d2
	rts
vorz:	Dmove	var_buffer,a0
	add.l	#2,a0
vorzl:	cmp.b	#' ',(a0)
	beq	vorzplus
	cmp.b	#'-',(a0)
	beq	vorzminus
	add.l	#1,a0
	bra	vorzl
vorzplus:
	move.b	#'0',(a0)
	Dmove	var_buffer,a0
	add.l	#2,a0
	move.b	#' ',(a0)
	rts
vorzminus:
	move.b	#'0',(a0)
	Dmove	var_buffer,a0
	add.l	#2,a0
	move.b	#'-',(a0)
	rts
exvend:	Dmove	blanull,d0
	lea	velo+3(pc),a1
	cmp.l	#0,d0
	beq	no_ch
	move.b	#' ',(a1)
	bra	ych
no_ch:	move.b	#'0',(a1)
ych:	Dmove2	wlm,wl,d1,d0
	sub.l	d0,d1
	Dsave	d1,wl1
	Dmove2	var_buffer,zw,a1,a0
	add.l	#2,a0
	Dmove	wlm,d0
	move.w	d0,(a1)+
	Dmove	wl1,d0
	beq	velne
	sub.l	#1,d0
velo:	move.b	#'0',(a1)+
	dbra	d0,velo
velne:	Dmove	wl,d0
	sub.l	#1,d0
velo2:	move.b	(a0)+,(a1)+
	dbra	d0,velo2
	move.b	#0,(a1)+
	rts
mstr:	move.l	(a3)+,d0
	Dlea	str+2,a0
	bsr	_bin_to_dec
	Dlea	str+2,a0
	move.w	#0,d3
mstrl:	cmp.b	#0,(a0)+
	beq	mstrend
	add.w	#1,d3
	bra	mstrl
mstrend	Dlea	str,a0
	move.w	d3,(a0)
	rts
_bin_to_dec:
	tst.l	d0
	beq	_bin_dec6
	bmi	_bin_dec1
	neg.l	d0
	move.b	#' ',(a0)+
	bra	_bin_dec2
_bin_dec1:
	move.b	#'-',(a0)+
_bin_dec2:
	Rbsr	bin_dec2
	sub.l	#2,a2
	rts
_bin_dec6:
	neg.b	d0
	addi.b	#$30,d0
	move.b	d0,(a0)+
	rts
******* GET AREA(string)
L_geta	equ	21
L21
geta:	movem.l	a4-a6,-(sp)
	move.l	(a3)+,a0
	move.w	(a0)+,d0
	cmp.w	#0,d0
	beq	nulnul
	Dsave	a0,ber
	cmp.b	#"-",(a0)
	beq	berbis
	cmp.b	#"-",(a0,d0.w)
	beq	bisber
berlop:	cmp.b	#0,(a0)
	beq	berfl
	cmp.b	#"-",(a0)+
	bne	berlop
	Dlea	bereich1,a1
	Dmove	ber,a0
cop1:	move.b	(a0)+,(a1)+
	cmp.b	#"-",(a0)
	bne	cop1
	move.b	#0,(a1)+
	add.l	#1,a0
	Dlea	bereich2,a1
cop2:	move.b	(a0)+,(a1)+
	cmp.b	#0,(a0)
	bne	cop2
	move.b	#0,(a1)+
	bra	makeval
berfl:	Dlea	bereich1,a1
	Dmove	ber,a0
cop3:	move.b	(a0)+,(a1)+
	cmp.b	#0,(a0)
	bne	cop3
	move.b	#0,(a1)+
	Dlea	bereich2,a1
	Dmove	ber,a0
cop4:	move.b	(a0)+,(a1)+
	cmp.b	#0,(a0)
	bne	cop4
	move.b	#0,(a1)+
	bra	makeval
nulnul:	Dlea	bereich1,a0
	Dlea	bereich2,a1
	move.b	#0,(a0)+
	move.b	#0,(a1)+
	bra	makeval
berbis:	Dlea	bereich1,a1
	move.b	#0,(a1)+
	Dlea	bereich2,a1
	Dmove	ber,a0
	add.l	#1,a0
cop5:	move.b	(a0)+,(a1)+
	cmp.b	#0,(a0)
	bne	cop5
	move.b	#0,(a1)+
	bra	makeval
bisber:	Dlea	bereich2,a1
	move.b	#0,(a1)+
	Dlea	bereich1,a1
	Dmove	ber,a0
	add.l	#1,a0
cop6:	move.b	(a0)+,(a1)+
	cmp.b	#0,(a0)
	bne	cop6
	move.b	#0,(a1)+
makeval:
	Dsave2	#0,#0,w_ast,w_aend
	Dlea	bereich1,a0
	cmp.b	#0,(a0)
	beq	mv2
	Rbsr	dec_to_bin
	Dsave	d0,w_ast
mv2:	Dlea	bereich2,a0
	cmp.b	#0,(a0)
	beq	mvret
	Rbsr	dec_to_bin
	Dsave	d0,w_aend
mvret:	movem.l	(sp)+,a4-a6
	rts
******* RESET AREA
L_resa	equ	22
L22
resa:	Dsave2	#0,#0,w_ast,w_aend
	rts
******* AREA START
L_afirst	equ	23
L23
afirst:	moveq	#0,d2
	Dmove	w_ast,d3
	rts
******* AREA END
L_alast	equ	24
L24
alast:	moveq	#0,d2
	Dmove	w_aend,d3
	rts
******* MWAIT
L_mwait	equ	25
L25
mw:	movem.l	a3-a6,-(sp)
mwl1:	Rbsr	tests
	SyCall	MouseKey
	tst.w	d1
	bne	mwl1
mwl2:	Rbsr	tests
	SyCall	MouseKey
	tst.w	d1
	beq	mwl2
	move.w	d1,d0
mwl3:	Rbsr	tests
	SyCall	MouseKey
	cmp.w	d0,d1
	beq	mwl3
	move.w	d1,d3
	ext.l	d3
	moveq	#0,d2
	movem.l	(sp)+,a3-a6
	rts
******* KEYWAIT(string)
L_twait	equ	26
L26
twait:	moveq	#0,d4
	moveq	#0,d1
	SyCall	ClearKey
	move.l	(a3)+,a0
	cmp.w	#0,(a0)+
	bne	tast
	move.l	#1,d4
	bra	nokey
tast:	Dsave	a0,wkey
nokey:	Rbsr	tests
	SyCall	Inkey
	cmp.w	#0,d1
	beq	nokey
	cmp.l	#1,d4
	beq	twex
	Dmove	wkey,a0
tnext:	move.b	(a0)+,d2
	ext.w	d2
	cmp.w	d1,d2
	beq	twex
	cmp.b	#0,(a0)
	beq	nokey
	bra	tnext
twex:	moveq	#0,d3
	move.b	d1,d3
	ext.w	d3
	ext.l	d3
	moveq	#0,d2
	rts

; global subroutines
;
getmem	equ	27
L27
	ext.l	d0
	Rbra	get_mem
get_mem	equ	28
L28
	add.l	#3,d0
	move.l	d0,d3
	movem.l	d1-d7/a0-a6,-(sp)
	Dmove	rout,d7
	cmp.l	#1,d7
	bne	no_r
	add.l	#2,d3
no_r:	and.w	#$fffe,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	Dmove	reg_a5,a5
	move.l	a1,HiChaine(a5)
	Dsave	a0,var_buffer
	movem.l	(sp)+,d1-d7/a0-a6
	rts

dz	equ	29
L29
	move.w	(a2)+,d0
	Rbsr	bin_to_dec
	move.w	(a2)+,d0
	Rbsr	bin_to_dec
	move.w	(a2)+,d0
	Rbsr	bin_to_dec
	move.w	(a2)+,d0
	Rbsr	bin_to_dec
	move.w	(a2)+,d0
	Rbsr	bin_to_dec
	move.w	(a2)+,d0
	Rbsr	bin_to_dec
	rts

bin_to_dec	equ	30
L30
	and	#15,d0
	ext.l	d0
	tst.l	d0
	Rbeq	bin_dec6
	neg.l	d0
	Rbra	bin_dec2
bin_dec2	equ	31
L31
	Dlea	decathlon,a1
	clr.w	d1
bin_dec3:
	move.l	(a1)+,d2
	Rbeq	bin_dec6
	moveq	#-1,d4
bin_dec4:
	add.l	d2,d0
	dbgt	d4,bin_dec4
	sub.l	d2,d0
	addq.w	#1,d4
	bne	bin_dec5
	tst.w	d1
	beq	bin_dec3
bin_dec5:
	moveq	#-1,d1
	neg.b	d4
	addi.b	#$30,d4
	move.b	d4,(a0)+
	bra	bin_dec3
bin_dec6	equ	32
L32
	neg.b	d0
	addi.b	#$30,d0
	move.b	d0,(a0)+
	add.l	#2,a2
	rts
uninit	equ	33
L33
	Dsave4	#0,#0,#0,#0,jpattern,jbuffer,string,p_case
	move.l	#389,d4
	Mlea	p1_jbuffer,a4
init_loop:
	move.l	#0,(a4)+
	dbra	d4,init_loop
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d4
	rts

g_err	equ	34
L34
	movem.l	(sp)+,a0
	movem.l	(sp)+,a4-a6
	move.l	a0,d3
	Rbsr	err_get
	moveq	#2,d2
	rts

cr_err	equ	35
L35
	movem.l	(sp)+,a0
	movem.l	(sp)+,a3-a6
	move.l	a0,d3
	Rbsr	err_get
	moveq	#2,d2
	rts

dec_to_bin	equ	36
L36
	moveq	#0,d0
	moveq	#0,d2
dec_loop:
	move.b  (a0)+,d2
	tst.b	d2
	beq	dec_end
	cmpi.b	#'0',d2
	blo	dec_end
	cmpi.b	#'9',d2
	bhi	dec_end
	add.l	d0,d0
	move.l	d0,d1
	add.l	d0,d0
	add.l	d0,d0
	add.l	d1,d0
	subi.b	#$30,d2
	add.l	d2,d0
	bra	dec_loop
dec_end:
	subq.l	#1,a0
	rts

*******	GET NUMBER(zahl,len)
L_zahl	equ	37
L37
get_nr:	movem.l	a3-a6,-(sp)
	Rbsr	uninit
	movem.l	(sp)+,a3-a6
	move.l	(a3)+,d1
	cmp.l	#0,d1
	bne	no_lim
	move.l	#254,d1
no_lim:	move.l	(a3)+,d0
	Dsave3	d1,d0,#1,zahllen,zahlval,rout
	movem.l	a3-a6,-(sp)
	Dmove	zahllen,d3
blprt:	Dlea	blank,a1
	WiCall	Print
	dbra	d3,blprt
	Dmove	zahlval,d0
	move.l	d0,-(a3)
cont:	Dmove	zahllen,d0
	move.l	d0,-(a3)
	Dlea	blank,a0
	move.l	a0,-(a3)
	movem.l	a0,-(sp)
	Dlea	str,a0
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	movem.l	(sp)+,a0
	Rbsr	L_exv1
	Dsave	d3,zahlstring
	movem.l	d3,-(sp)
	Dmove	zahllen,d3
cuprt:	Dlea	culeft,a1
	WiCall	Print
	dbra	d3,cuprt
	movem.l	(sp)+,d3
	move.l	d3,a1
	add.l	#2,a1
	WiCall	Print
	Dmove	zahlstring,a0
	move.l	a0,-(a3)
	Rbsr	L_ubl
	Dsave	d3,realstring
getkey:	moveq	#0,d1
	Dlea	zahlen,a0
	move.l	a0,-(a3)
	Rbsr	L_twait
	cmp.w	#8,d1
	beq	backspace
	cmp.w	#13,d1
	beq	ready
	Dmove2	realstring,zahllen,a0,d2
	move.w	(a0),d0
	move.w	d0,d7
	ext.l	d7
	cmp.l	d2,d7
	bge	getkey
	add.w	#1,d0
	move.w	d0,(a0)+
	sub.l	#1,a0
	move.b	d1,(a0,d0.w)
	add.l	#1,a0
	move.b	#0,(a0,d0.w)
	bra	prep
ready:	Dmove	realstring,a0
	add.l	#2,a0
	bsr	dec_to_vbin
	move.l	d0,d3
	moveq	#0,d2
	movem.l	d2/d3,-(sp)
	Dsave	#0,rout
	Dlea	crlf,a1
	WiCall	Print
	movem.l	(sp)+,d2/d3
	movem.l	(sp)+,a3-a6
	rts
backspace:
	Dmove	realstring,a0
	move.w	(a0),d0
	cmp.w	#0,d0
	beq	getkey
	sub.w	#1,d0
	move.w	d0,(a0)+
	move.b	#0,(a0,d0.w)
prep:	Dmove	realstring,a0
	add.l	#2,a0
	bsr	dec_to_vbin
	Dsave	d0,zahlval
	movem.l	d0,-(a3)
	bra	cont
dec_to_vbin:
	moveq	#0,d0
	moveq	#0,d2
	moveq	#0,d7
dec_vloop:
	move.b  (a0)+,d2
	tst.b	d2
	beq	dec_vend
	cmpi.b	#'-',d2
	bne	no_below
	move.l	#-1,d7
	bra	dec_vloop
no_below:
	cmpi.b	#'0',d2
	blo	dec_vend
	cmpi.b	#'9',d2
	bhi	dec_vend
	add.l	d0,d0
	move.l	d0,d1
	add.l	d0,d0
	add.l	d0,d0
	add.l	d1,d0
	subi.b	#$30,d2
	add.l	d2,d0
	bra	dec_vloop
dec_vend:
	cmp.l	#0,d7
	beq	zplus
	not.l	d0
	add.l	#1,d0
zplus:	subq.l	#1,a0
	rts

*******	RASTPORT
L_rp	equ	38
L38
rp:	move.l	T_RastPort(a5),d3
	moveq	#0,d2
	rts
*******	CUT(string,pos,anz)
L_cut	equ	39
L39
cut:	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	(a3)+,a0
	Dsave	a0,cstr
	move.w	(a0),d2
	ext.l	d2
	cmp.l	#0,d2
	beq	cuterr
	cmp.l	#0,d1
	beq	cuterr
	cmp.l	#0,d0
	beq	cuterr
cutter:	move.l	d1,d7
	add.l	d0,d7
	sub.l	#1,d7
	cmp.l	d2,d7
	ble	cutok
	sub.l	#1,d1
	bra	cutter
cutok:	Dsave3	d1,d0,d2,anz,pos,clen
	sub.l	d1,d2
	move.l	d2,d0
	movem.l	d2,-(sp)
	Rbsr	get_mem
	move.l	(sp)+,d2
	Dmove2	var_buffer,cstr,a0,a1
	move.w	d2,(a0)+
	add.l	#2,a1
	move.l	#1,d0
cutl1:	Dmove	pos,d1
	cmp.l	d1,d0
	bge	cutl2
	move.b	(a1)+,(a0)+
	add.l	#1,d0
	bra	cutl1
cutl2:	Dmove2	anz,clen,d2,d3
	add.l	d2,d0
	add.l	d2,a1
cutl3:	cmp.l	d3,d0
	bgt	cutl4
	move.b	(a1)+,d7
	move.b	d7,(a0)+
	cmp.b	#0,d7
	beq	cutl4
	add.l	#1,d0
	bra	cutl3
cutl4:	Dmove	var_buffer,d3
cutex:	moveq	#2,d2
	rts
cuterr:	Dmove	cstr,d3
	bra	cutex
*******	INSERT(string,pos,string)
L_ins	equ	40
L40
insert:	move.l	(a3)+,a1
	move.l	(a3)+,d0
	move.l	(a3)+,a0
	Dsave2	a0,a1,cstr,instr
	move.w	(a0),d1
	ext.l	d1
	cmp.l	#0,d1
	beq	inerr2
	move.w	(a1),d2
	ext.l	d2
	cmp.l	#0,d2
	beq	inerr
	cmp.l	#0,d0
	beq	inerr
inl0:	sub.l	#1,d0
	cmp.l	d1,d0
	bgt	inl0
	add.l	#1,d0
	Dsave	d0,pos
	add.l	d1,d2
	move.l	d2,d0
	movem.l	d2,-(sp)
	Rbsr	get_mem
	movem.l	(sp)+,d2
	Dmove4	var_buffer,cstr,instr,pos,a0,a1,a2,d1
	add.l	#2,a1
	add.l	#2,a2
	move.w	d2,(a0)+
	move.l	#0,d0
inl:	add.l	#1,d0
	cmp.l	d0,d1
	beq	inl2
	move.b	(a1)+,(a0)+
	bra	inl
inl2:	move.b	(a2)+,d7
	cmp.b	#0,d7
	beq	inl3
	move.b	d7,(a0)+
	bra	inl2
inl3:	move.b	(a1)+,d7
	move.b	d7,(a0)+
	cmp.b	#0,d7
	bne	inl3
	Dmove	var_buffer,d3
inex:	moveq	#2,d2
	rts
inerr:	Dmove	cstr,d3
	bra	inex
inerr2:	Dmove	instr,a1
	move.w	(a1),d0
	cmp.w	#0,d0
	beq	inerr
	Rbsr	getmem
	Dmove	var_buffer,a0
	move.w	(a1)+,(a0)+
	bra	inl3

err_get	equ	41
L41
	move.l	d3,a0
	movem.l	a0,-(sp)
	move.w	(a0),d0
	Rbsr	getmem
	cmp.l	#0,d0
	beq	oomem
	Dmove	var_buffer,a1
	movem.l	(sp)+,a0
	move.w	(a0)+,(a1)+
err_l:	move.b	(a0)+,d7
	move.b	d7,(a1)+
	cmp.b	#0,d7
	bne	err_l
	Dmove	var_buffer,d3
	rts
oomem:	movem.l	(sp)+,a0
	movem.l	(sp)+,d0
	moveq	#24,d0
	Rjmp	L_Error
*******	DISKCHANGE
L_dc	equ	42
L42
dc:	move.b	$bfe001,d0
	and.b	#16,d0
	bne	dc
	movem.l	a6,-(sp)
	movea.l	4,a6
Wait	move.l	#500,d1
Wait2	Rbsr	tests
	sub.l	#1,d1
	bne	Wait2
	jsr	-120(a6)
	lea	$196(a6),a0
	Dlea	Validate,a1
	jsr	-276(a6)
	move.l	d0,d2
	bne	Check
	lea	$1a4(a6),a0
	Dlea	Validate,a1
	jsr	-276(a6)
	move.l	d0,d2
Check	jsr	-126(a6)
	tst.l	d2
	bne	Wait
	movem.l	(sp)+,a6
	rts
*******	WAIT AMIGA
L_tam	equ	43
L43
_test:	Rbsr	tests
	SyCall	Inkey
	cmp.w	#0,d1
	beq	_test
	swap	d1
	move.w	d1,d0
	and.w	#%1100000000000000,d0
	beq	_test
	move.b	d1,d3
	ext.w	d3
	ext.l	d3
	moveq	#0,d2
	rts
*******	GET STRING$(string,len)
L_gets	equ	44
L44
_gets:	Rbsr	L_getxypos
	move.l	(a3)+,d2
	move.l	(a3)+,a0
	Dsave3	a0,a0,a0,gstring,fstring,ustring
	move.w	(a0),d3
	ext.l	d3
	Dsave4	d3,d1,d0,d2,pos,xpos,ypos,len
	cmp.l	d2,d3
	bgt	inp_err
	Dlea	leer,a0
	move.l	#0,(a0)
	SyCall	ClearKey
	Dsave	#1,rout
	bra	print_and_pos
s_input:
	Rbsr	tests
	SyCall	Inkey
	cmp.b	#115,$bfec01
	beq	s_del
	cmp.w	#0,d1
	beq	s_input
	moveq	#0,d7
	move.w	d1,d7
	swap	d7
	and.w	#%1100000000000000,d7
	bne	isolate
	cmp.w	#28,d1
	beq	curite
	cmp.w	#29,d1
	beq	c_left
	cmp.w	#13,d1
	beq	return
	cmp.w	#8,d1
	beq	bspace
isolate:
	Dlea	taste,a1
	add.l	#2,a1
	move.b	d1,(a1)
	swap	d1
	move.w	d1,d0		* Isolate AMIGA keys
	and.w	#%1100000000000000,d0
	beq	addtaste
	cmp.b	#19,d1		* R
	beq	recall		  hole uebergabe-string
	cmp.b	#33,d1		* S
	beq	push		  sichere string
	cmp.b	#22,d1		* U
	beq	pull		  hole gesicherten string
	cmp.b	#50,d1		* X
	beq	s_clear		  loesche string
	cmp.b	#35,d1		* F
	beq	one_pos		  pos 1
	cmp.b	#40,d1		* L
	beq	last_pos	  pos x
	bra	s_input
one_pos:
	Dsave	#0,pos
	bra	posit
last_pos:
	Dmove2	gstring,len,a0,d1
	move.w	(a0),d0
	ext.l	d0
	cmp.l	d0,d1
	beq	over
slp:	Dsave	d0,pos
	bra	posit
over:	Dmove	len,d0
	bra	slp
s_del:	Dmove2	gstring,pos,a0,d0
	move.l	a0,-(a3)
	add.l	#1,d0
	move.l	d0,-(a3)
	move.l	#1,-(a3)
	Rbsr	L_cut
	Dsave	d3,gstring
	move.b	#0,$bfec01
	Dmove	pos,d0
	sub.l	#1,d0
	Dsave	d0,pos
	bra	print_and_pos
curite:
	Dmove2	pos,gstring,d0,a0
	move.w	(a0),d1
	ext.l	d1
	cmp.l	d1,d0
	bge	s_input
	add.l	#1,d0
	Dsave	d0,pos
	bra	posit
c_left:	Dmove	pos,d0
	cmp.l	#0,d0
	beq	s_input
	sub.l	#1,d0
	Dsave	d0,pos
	bra	posit
bspace:	Dmove2	gstring,pos,a0,d0
	move.l	a0,-(a3)
	cmp.l	#0,d0
	beq	s_input
	move.l	d0,-(a3)
	move.l	#1,-(a3)
	Rbsr	L_cut
	Dsave	d3,gstring
	Dmove	pos,d0
	sub.l	#1,d0
	Dsave	d0,pos
	bra	print_and_pos
recall:	Dmove	fstring,a0
	move.w	(a0),d0
	ext.l	d0
	Dsave2	d0,a0,pos,gstring
	bra	print_and_pos
push:	Dmove	gstring,a0
	Dsave	a0,ustring
	bra	s_input
pull:	Dmove	ustring,a0
	move.w	(a0),d0
	ext.l	d0
	Dsave2	d0,a0,pos,gstring
	bra	print_and_pos
s_clear:
	Dsave	#0,pos
	Dlea	leer,a0
	Dsave	a0,gstring
	bra	print_and_pos
print_and_pos:
	Dmove2	xpos,ypos,d1,d2
	WiCall	Locate
	Dmove	len,d7
	sub.l	#1,d7
	bmi	p_loc
clprint:
	movem.l	d7,-(sp)
	Dlea	blank,a1
	WiCall	Print
	movem.l	(sp)+,d7
	dbra	d7,clprint
	moveq	#0,d7
p_loc:	Dmove2	xpos,ypos,d1,d2
	WiCall	Locate

	Mlea	p2_jbuffer,a1
	move.l	#129,d7
clrlop:	move.l	#0,(a1)+
	dbra	d7,clrlop
	Dmove	gstring,a1
	Mlea	p2_jbuffer,a2
	move.w	(a1)+,d7
	sub.w	#1,d7
	bmi	posit
pcl:	move.b	(a1)+,(a2)+
	dbra	d7,pcl
	Mlea	p2_jbuffer,a1
	moveq	#0,d7

	WiCall	Print
posit:	Dmove2	xpos,ypos,d1,d2
	WiCall	Locate
	Dmove	pos,d7
	cmp.l	#0,d7
	ble	_s_input
	sub.l	#1,d7
pos_loop:
	movem.l	d7,-(sp)
	Dlea	curight,a1
	WiCall	Print
	movem.l	(sp)+,d7
	dbra	d7,pos_loop
	bra	s_input
_s_input:
	Dsave	#0,pos
	bra	s_input
ap:	Dsave	#0,pos
addtaste:
	Dmove	pos,d0
	cmp.l	#0,d0
	blt	ap
ap2:	Dmove	gstring,a0
	move.w	(a0),d7
	ext.l	d7
	cmp.l	#0,d7
	bne	ap3
	Dsave	#1,pos
ap3:	Dmove	len,d6
	cmp.l	d6,d7
	bge	s_input
	Dmove	pos,d0
	add.l	#1,d0
	Dlea	taste,a1
	add.l	#2,a1
	Dlea	all_buts,a0
_erl:	cmp.b	#0,(a0)
	beq	s_input
	cmp.b	(a0)+,(a1)+
	beq	_er
	sub.l	#1,a1
	bra	_erl
_er:	Dmove	gstring,a0
	Dlea	taste,a1
	move.l	a0,-(a3)
	move.l	d0,-(a3)
	move.l	a1,-(a3)
	Rbsr	L_ins
	Dsave	d3,gstring
	bra	print_and_pos
return:	Dsave	#0,rout
	Dmove	gstring,d3
	moveq	#2,d2
crret:	movem.l	d2-d3,-(sp)
	Dlea	crlf,a1
	WiCall	Print
	movem.l	(sp)+,d2-d3
	rts
inp_err:
	Dsave	#0,rout
	Dlea	leer,a0
	move.l	a0,d3
	move.l	#2,d2
	bra	crret
*******	WAIT EVENT
L_we	equ	45
L45
we:	SyCall	ClearKey
waiter:	Rbsr	tests
	SyCall	Inkey
	tst.w	d1
	bne	wexit
	SyCall	MouseKey
	tst.w	d1
	beq	waiter
wexit:	rts
*******	SPREAD "string",richtung,delay
L_spr	equ	46
L46
spr:	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,a0
	move.w	(a0),d0
	beq	sprend
	cmp.l	#0,d2
	bpl	d1ok
	move.l	#10,d2
d1ok:	Dsave	d2,timer
	cmp.l	#0,d1
	bpl	spr2
	movem.l	a3-a6,-(sp)
	move.l	DosBase(a5),a6
	Dsave	a0,string
	Rbsr	get_mem
	Dmove	string,a0
	move.w	(a0)+,d0
	ext.l	d0
	move.l	#2,d3
	move.l	d0,d1
	lsr.l	#1,d0
	move.l	d0,d2
	sub.l	#1,d2
	move.l	d2,d4
	lsl.l	#1,d0
	cmp.l	d0,d1
	beq	evn
	add.l	#1,d2
	move.l	d2,d4
	move.l	#1,d3
evn:	Dmove	var_buffer,a1
	sub.l	#1,d3
sclop:	add.l	d2,a0
	movem.l	d3,-(sp)
scl:	move.b	(a0)+,(a1)+
	dbra	d3,scl
	Dmove	var_buffer,a1
	movem.l	d2-d4,-(sp)
	WiCall	Centre
	movem.l	(sp)+,d2-d4
	Rbsr	tests
	movem.l	d0-d1,-(sp)
	Dmove	timer,d1
	jsr	-198(a6)
	movem.l	(sp)+,d0-d1
	sub.l	#1,d2
	movem.l	(sp)+,d3
	add.l	#2,d3
	Dmove2	var_buffer,string,a1,a0
	add.l	#2,a0
	cmp.l	#-1,d2
	bne	sclop
sp2end:	Rbsr	uninit
	movem.l	(sp)+,a3-a6
sprend:	rts
spr2:	movem.l	a3-a6,-(sp)
	move.l	DosBase(a5),a6
	Dsave	a0,string
	move.w	(a0)+,d0
	ext.l	d0
	move.l	d0,d3
	add.l	#1,d3
	lsr	#1,d0
	sub.l	#1,d0
	move.l	#1,d2
slpp:	move.l	d3,d1
	add.l	#1,d2
	sub.l	d2,d1
	movem.l	d0-d3,-(sp)
	Dmove	string,a0
	move.l	a0,-(a3)
	move.l	d2,-(a3)
	move.l	d1,-(a3)
	Rbsr	L_cut
	Dmove	var_buffer,a0
	Dsave	a0,var2_buffer
	movem.l	(sp)+,d0-d3
	movem.l	d0-d3,-(sp)
	Dmove	string,a0
	move.l	a0,-(a3)
	move.l	#1,-(a3)
	move.l	d1,-(a3)
	Rbsr	L_cut
	Dmove2	var_buffer,var2_buffer,a1,a0
	move.l	a0,-(a3)
	move.w	(a0),d0
	add.w	#1,d0
	ext.l	d0
	move.l	d0,-(a3)
	move.l	a1,-(a3)
	Rbsr	L_ins
	Dmove	var_buffer,a1
	add.l	#2,a1
	WiCall	Centre
	movem.l	(sp)+,d0-d3
	Rbsr	tests
	movem.l	d0-d1,-(sp)
	Dmove	timer,d1
	jsr	-198(a6)
	movem.l	(sp)+,d0-d1
	dbra	d0,slpp
	Dmove	string,a1
	add.l	#2,a1
	WiCall	Centre
	bra	sp2end
*******	TSCROLL "string",richtung,delay
L_ts	equ	47
L47
ts:	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	move.l	DosBase(a5),a6
	cmp.l	#0,d2
	bpl	d2ok
	move.l	#10,d2
d2ok:	Dsave3	d2,d1,a0,timer,kind,var_buffer
tslop:	Dmove	var_buffer,a1
	add.l	#2,a1
	WiCall	Centre
	Rbsr	tests
	movem.l	d0-d1,-(sp)
	Dmove	timer,d1
	jsr	-198(a6)
	movem.l	(sp)+,d0-d1
	btst	#6,$bfe001
	beq	ts_end
	movem.l	d7/a3-a6,-(sp)
	SyCall	Inkey
	movem.l	(sp)+,d7/a3-a6
	tst.w	d1
	bne	ts_end
	Dmove	kind,d0
	cmp.l	#0,d0
	bmi	srol
sror:	Dmove	var_buffer,a0
	move.l	a0,-(a3)
	Rbsr	L_rors
	bra	tslop
srol:	Dmove	var_buffer,a0
	move.l	a0,-(a3)
	Rbsr	L_rols
	bra	tslop
ts_end:	movem.l	(sp)+,a3-a6
	rts
*******	ROR$(string)
L_rors	equ	48
L48
ro_r:	move.l	(a3)+,a0
	move.w	(a0),d0
	movem.l	a0,-(sp)
	Rbsr	getmem
	Dmove	var_buffer,a1
	move.l	(sp)+,a0
	moveq	#0,d0
	move.w	(a0)+,d0
	move.w	d0,(a1)+
	sub.w	#1,d0
	move.b	(a0,d0.w),d1
	move.b	d1,(a1)+
	ext.l	d0
	sub.l	#1,d0
rotr:	move.b	(a0)+,(a1)+
	dbra	d0,rotr
	move.b	#0,(a1)+
	Dmove	var_buffer,d3
	moveq	#2,d2
	rts
*******	ROL$(string)
L_rols	equ	49
L49
ro_l:	move.l	(a3)+,a0
	move.w	(a0),d0
	movem.l	a0,-(sp)
	Rbsr	getmem
	Dmove	var_buffer,a1
	movem.l	(sp)+,a0
	moveq	#0,d0
	move.w	(a0)+,d0
	move.w	d0,(a1)+
	ext.l	d0
	sub.l	#2,d0
	move.b	(a0)+,d1
rotl:	move.b	(a0)+,(a1)+
	dbra	d0,rotl
	move.b	d1,(a1)+
	move.b	#0,(a1)+
	Dmove	var_buffer,d3
	moveq	#2,d2
	rts
*******	READ SECTOR(device,sector)
L_rsec	equ	50
L50
rsec:	movem.l	(a3)+,d0-d1
	movem.l	a3-a6,-(sp)
	Dsave2	d0,d1,sector,device
	cmp.l	#1759,d1
	bgt	rserr
	cmp.l	#0,d1
	blt	rserr
	move.l	#512,d0
	Rbsr	get_mem
	Dmove	var_buffer,d0
	cmp.l	#0,d0
	beq	rserr
	Rbsr	L_opend
	bsr	read_bb
	Rbsr	L_closd
	cmp.l	#-1,d7
	beq	rserr
	Dmove	var_buffer,a0
	move.w	#512,(a0)
	movem.l	(sp)+,a3-a6
	Dmove	var_buffer,d3
	moveq	#2,d2
	rts
rserr:	movem.l	(sp)+,a3-a6
	Dlea	trackerr,a0
	move.l	a0,d3
	Rbsr	err_get
	moveq	#2,d2
	rts
read_bb:
	Dlea	diskio,a1
	Dlea	msgport,a0
	move.l	a0,14(a1)
	move.w	#2,28(a1)
	Dmove	var_buffer,a0
	add.l	#2,a0
	move.l	a0,40(a1)
	move.l	#512,36(a1)
	Dmove	sector,d0
	mulu	#512,d0
	move.l	d0,44(a1)
	move.l	4,a6
	jsr	-456(a6)
	cmp.l	#0,d0
	beq	rok
	move.l	#-1,d7
rok:	Rbsr	L_motor
	rts
*******	WRITE SECTOR(string,device,sector)
L_wsec	equ	51
L51
wsec:	movem.l	(a3)+,d0-d1/a0
	movem.l	a3-a6,-(sp)
	move.w	(a0)+,d2
	ext.l	d2
	cmp.l	#512,d2
	bne	rwerr
	Dsave4	a0,d0,d1,d2,var_buffer,sector,device,wrlen
	cmp.l	#1759,d0
	bgt	rwerr
	cmp.l	#0,d0
	blt	rwerr
	move.l	#512,d0
	Rbsr	L_opend
	bsr	write_bb
	Rbsr	L_closd
	cmp.l	#-1,d7
	beq	rwerr
	movem.l	(sp)+,a3-a6
	move.l	#0,d3
	bra	trex
rwerr:	movem.l	(sp)+,a3-a6
	move.l	#-1,d3
trex:	moveq	#0,d2
	rts
write_bb:
	Dlea	diskio,a1
	Dlea	msgport,a0
	move.l	a0,14(a1)
	move.w	#3,28(a1)
	Dmove2	var_buffer,wrlen,a0,d0
	move.l	a0,40(a1)
	move.l	d0,36(a1)
	Dmove	sector,d0
	mulu	#512,d0
	move.l	d0,44(a1)
	move.l	4,a6
	jsr	-456(a6)
	cmp.l	#0,d0
	bne	nok
	Dlea	diskio,a1
	Dlea	msgport,a0
	move.l	a0,14(a1)
	move.w	#4,28(a1)
	Dmove2	var_buffer,sector,a0,d0
	move.l	a0,40(a1)
	move.l	#512,36(a1)
	mulu	#512,d0
	move.l	d0,44(a1)
	move.l	4,a6
	jsr	-456(a6)
	cmp.l	#0,d0
	beq	wok
nok:	move.l	#-1,d7
wok:	Rbsr	L_motor
	rts

L_opend	equ	52
L52
	move.l	4,a6
	move.l	#0,a1
	jsr	-294(a6)
	movem.l	d0,-(sp)
	Dlea	msgport,a1
	movem.l	(sp)+,d0
	add.l	#16,a1
	move.l	d0,(a1)
	Dlea	msgport,a1
	move.l	4,a6
	jsr	-354(a6)
	Dlea	diskio,a1
	Dmove	device,d0
	move.l	#0,d1
	Dlea	devicename,a0
	jsr	-444(a6)
	rts
L_closd	equ	53
L53
	Dlea	msgport,a1
	move.l	4,a6
	jsr	-360(a6)
	Dlea	diskio,a1
	jsr	-450(a6)
	rts
L_motor	equ	54
L54
	Dlea	diskio,a1
	move.w	#9,28(a1)
	clr.l	36(a1)
	move.l	4,a6
	jsr	-456(a6)
	rts
*******	DUMP$(string)
L_dcon	equ	55
L55
dcon:	movem.l	(a3)+,a0
	Dsave	a0,string
	move.w	(a0)+,d0
	cmp.l	#0,d0
	beq	dconerr
	movem.l	d0,-(sp)
	Rbsr	getmem
	cmp.l	#0,d0
	beq	dconerr
	Dmove2	var_buffer,string,a1,a0
	movem.l	(sp)+,d1
	move.w	(a0)+,(a1)+
convloop:
	cmp.b	#0,(a0)
	blt	high
	cmp.b	#' ',(a0)
	bmi	paste
high:
	cmp.b	#$9f,(a0)
	bpl	nextchar
	cmp.b	#$80,(a0)
	bmi	nextchar
	cmp.b	#$a0,(a0)
	bmi	paste
	bra	nextchar
paste:
	move.b	#'.',(a1)
	bra	pchar
nextchar:
	move.b	(a0),(a1)
pchar:	adda.l	#1,a0
	adda.l	#1,a1
	subi.w	#1,d1
	bne	convloop
	move.b	#0,(a1)
	Dmove	var_buffer,d3
	moveq	#2,d2
	rts
dconerr:
	Dlea	trackerr,a0
	move.l	a0,d3
	Rbsr	err_get
	moveq	#2,d2
	rts
*******	CHECKSUM(string)
L_chksum	equ	56
L56
checksum:
	move.l	(a3)+,a0
	cmp.w	#512,(a0)+
	bne	sumend
	move.l	#0,d0
	move.l	#127,d7
checkloop:
	add.l	(a0)+,d0
	dbra	d7,checkloop
	sub.l	-492(a0),d0
	neg.l	d0
	move.l	d0,d3
csend:	moveq	#0,d2
	rts
sumend:	move.l	#0,d3
	bra	csend
*******	BOOTCHECKSUM(string)
L_bchksum	equ	57
L57
bchecksum:
	move.l	(a3)+,a0
	cmp.w	#1024,(a0)+
	bne	bsumend
	move.l	#0,d0
	move.l	(a0),d0
	add.l	#8,a0
	move.l	#253,d7
bcheckloop:
	add.l	(a0)+,d0
	bcs	overflow
dochecksum:
	dbra	d7,bcheckloop
	add.l	#1,d0
	neg.l	d0
	move.l	d0,d3
bcsend:	moveq	#0,d2
	rts
overflow:
	add.l	#1,d0
	bra	dochecksum
bsumend:
	move.l	#0,d3
	bra	bcsend
*******	ODD(zahl)
L_odd	equ	58
L58
odd:	move.l	(a3)+,d0
	move.l	#1,d3
	move.l	d0,d1
	and.w	#$fffe,d0
	cmp.l	d0,d1
	beq	is_odd
	move.l	#0,d3
is_odd:	moveq	#0,d2
	rts
*******	OCT$(zahl)
L_oct	equ	59
L59
oct:	movem.l	a3-a6,-(sp)
	Rbsr	uninit
	movem.l	(sp)+,a3-a6
	move.w	#'& ',d7
	move.l	(a3)+,d0
	cmp.l	#0,d0
	bpl	octcon
	neg.l	d0
	move.w	#'&-',d7
octcon:	movem.l	a3-a6,-(sp)
	move.l	d0,d1
	move.l	d0,d2
	move.l	d0,d3
	move.l	d0,d4
	lsr.l	#3,d1
	sub.l	d1,d2
	sub.l	d2,d3
	Mlea	p1_jbuffer,a0
	move.l	d1,d0
	bsr	o_bin_to_dec
	move.l	d4,d0
	lsl.l	#3,d3
	sub.l	d3,d0
	Mlea	p2_jbuffer,a0
	bsr	o_bin_to_dec
	Mlea	p1_jbuffer,a0
	Mlea	p2_jbuffer,a1
	Mlea	paste_jbuffer,a2
	add.l	#2,a2
	move.w	d7,(a2)+
	add.l	#1,a0
fnready:
	move.b	(a0)+,d0
	cmp.b	#0,d0
	beq	fready
	move.b	d0,(a2)+
	bra	fnready
fready:	add.l	#1,a1
snready:
	move.b	(a1)+,d0
	cmp.b	#0,d0
	beq	sready
	move.b	d0,(a2)+
	bra	snready
sready:	move.b	#0,(a2)
	Mlea	paste_jbuffer,a0
	add.l	#2,a0
	move.w	#0,d0
golen:	cmp.b	#0,(a0)+
	beq	olen
	add.w	#1,d0
	bra	golen
olen:	Mlea	paste_jbuffer,a0
	move.w	d0,(a0)
	Rbsr	getmem
	Dmove	var_buffer,a1
	Mlea	paste_jbuffer,a0
	move.w	(a0)+,(a1)+
oco:	move.b	(a0)+,(a1)+
	bne	oco
	Dmove	var_buffer,a0
	move.b	2(a0),d0
	move.b	3(a0),d1
	move.b	d1,2(a0)
	move.b	d0,3(a0)
	Dmove	var_buffer,d3
	moveq	#2,d2
	movem.l	(sp)+,a3-a6
	rts
o_bin_to_dec:
	movem.l	d1-d4,-(sp)
	neg.l	d0
	move.b	#' ',(a0)+
	Rbsr	bin_dec2
	sub.l	#2,a2
	movem.l	(sp)+,d1-d4
	rts
*******	OCT$(zahl,len)
L_oct2	equ	60
L60
oct2:	move.l	(a3)+,d0
	move.l	d0,-(sp)
	Rbsr	L_oct
	movem.l	(sp)+,d0
	move.l	d3,a0
	move.w	(a0),d1
	ext.l	d1
	sub.l	#2,d1
	cmp.l	d1,d0
	ble	o2end
	sub.l	d1,d0
	Mlea	paste_jbuffer,a1
	move.w	d0,(a1)+
	sub.l	#1,d0
ocl:	move.b	#'0',(a1)+
	dbra	d0,ocl
	move.b	#0,(a1)+
	Mlea	paste_jbuffer,a1
	move.l	a0,-(a3)
	move.l	#3,-(a3)
	move.l	a1,-(a3)
	Rbsr	L_ins
o2end:	rts
*******	PERCENT(%,zahl)
L_per	equ	61
L61
per:	movem.l	(a3)+,d0-d1
	cmp.l	#65535,d0
	bgt	phigh
	cmp.l	#0,d0
	blt	phigh
	cmp.l	#100,d1
	bgt	phigh
	cmp.l	#1,d1
	blt	phigh
	mulu	d0,d1
	movem.l	a3-a6,-(sp)
	move.l	FloatBase(a5),a6
	move.l	d1,d0
	jsr	-36(a6)
	move.l	d0,d5
	move.l	#100,d0
	jsr	-36(a6)
	move.l	d0,d1
	move.l	d5,d0
	jsr	-84(a6)
perex:	move.l	d0,d3
	moveq	#1,d2
	movem.l	(sp)+,a3-a6
	rts
phigh:	move.l	#23,d0
	Rjmp	L_Error
*******	DEOCT(oktalstring)
L_deoc	equ	62
L62
deoc:	move.l	(a3)+,a0
	Mlea	p1_jbuffer,a1
	move.w	(a0)+,d0
	move.w	d0,(a1)+
	sub.w	#1,d0
deol:	move.b	(a0)+,(a1)+
	dbra	d0,deol
	Mlea	p1_jbuffer,a0
	move.b	2(a0),d0
	move.b	3(a0),d1
	move.b	d1,2(a0)
	move.b	d0,3(a0)
	move.b	#0,d6
	move.w	(a0)+,d0
	cmp.b	#'&',(a0)+
	beq	deoct
	sub.l	#1,a0
deoct:	cmp.b	#'-',(a0)
	bne	posi
	move.b	#1,d6
posi:	moveq	#0,d7
	move.b	-2(a0,d0.w),d7
	sub.b	#48,d7
	move.b	#0,-2(a0,d0.w)
	move.b	#0,(a0)+
	movem.l	d6-d7,-(sp)
	Rbsr	dec_to_bin
	lsl.l	#3,d0
	movem.l	(sp)+,d6-d7
	add.l	d7,d0
	cmp.b	#1,d6
	bne	opo
	neg.l	d0
opo:	move.l	d0,d3
	moveq	#0,d2
	rts
*******	HEXDUMP(long,adress,len,breite)
L_hd	equ	63
L63
hxdump:	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	(a3)+,d5
	cmp.l	#1,d2
	bpl	brok
	move.l	#8,d2
brok:	move.l	d2,d6
	cmp.l	#1,d5
	beq	lok
	cmp.l	#2,d5
	bne	is4
	and.w	#$fffe,d6
	cmp.l	d2,d6
	beq	lok
	add.l	#1,d2
	bra	lok
is4:	and.w	#$fffc,d6
	cmp.l	d2,d6
	beq	lok
	add.l	#1,d2
	move.l	d2,d6
	bra	is4
lok:	move.l	d5,d6
	add.l	d0,d1
	Dsave3	d0,d1,d2,_start,_ende,_breite
	cmp.l	#1,d5
	beq	main_loop
	cmp.l	#2,d5
	beq	main_loop
	move.l	#4,d5
	move.l	d5,d6
main_loop:
	move.l	#0,d5
	Dmove	_start,d0
	Dlea	hexer,a1
	add.l	#1,a1
	move	#7,d2
	bsr	bin_hex1
	Dlea	hexer,a1
	WiCall	Print
	Dmove2	_breite,_start,d7,a0
	sub.l	#1,d7
schl:	moveq	#0,d0
	move.l	a0,d4
	move.b	(a0)+,d0
	Dlea	byte,a1
	bsr	bin_to_hex
	Dlea	byte,a1
	movem.l	a0/d4-d7,-(sp)
	WiCall	Print
	movem.l	(sp)+,a0/d4-d7
	add.l	#1,d5
	movem.l	a0/d4-d7,-(sp)
	cmp.l	d5,d6
	bne	no_abs
	Dlea	blank,a1
	WiCall	Print
	movem.l	(sp)+,a0/d4-d7
	move.l	#0,d5
	movem.l	a0/d4-d7,-(sp)
	Dmove	_ende,d5
	sub.l	#1,d5
	cmp.l	d4,d5
	bne	no_abs
	movem.l	(sp)+,a0/d4-d7
	move	#0,d7
	movem.l	a0/d4-d7,-(sp)
no_abs:	movem.l	(sp)+,a0/d4-d7
	dbra	d7,schl
	Dlea	crlf,a1
	WiCall	Print
	Dmove2	_breite,_start,d0,d1
	add.l	d0,d1
	Dsave	d1,_start
	Dmove	_ende,d0
	sub.l	d1,d0
	bgt	main_loop
	rts
bin_to_hex:
	move	#1,d2
	bra	_bh1
bin_hex1:
	rol.l	#4,d0
	move	d0,d1
	bsr	bin_hex2
	move.b	d1,(a1)+
	dbra	d2,bin_hex1
	rts
bin_hex2:
	and	#$0f,d1
	add	#$30,d1
	cmp	#$3a,d1
	bcs	bin_hex3
	add	#7,d1
bin_hex3:
	rts
_bh1:	move	d0,d1
	lsr	#4,d1
	bsr	bin_hex2
	move.b	d1,(a1)+
	move	d0,d1
	bsr	bin_hex2
	move.b	d1,(a1)+
	rts
*******	TYPE string,delay,sound
L_type	equ	64
L64
type:	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	(a3)+,a0
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#8,d0
	SyCall	SyChip
	Dsave	d0,chiptable
	move.l	d0,a1
	Dlea	table,a0
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	movem.l	(sp)+,d0-d7/a0-a6
	add.l	#2,a0
	cmp.l	#0,d0
	bpl	d3ok
	move.l	#10,d0
d3ok:	Dsave2	d0,d1,_delay,_soo
typer:	Dlea	one_byte,a1
	move.b	(a0)+,(a1)
	cmp.b	#0,(a1)
	beq	typeex
	movem.l	a0,-(sp)
	WiCall	Print
	Dmove	_soo,d1
	cmp.l	#0,d1
	beq	no_sound
	Dmove	chiptable,$dff0a0
	move	#4,$dff0a4
	move	#300,$dff0a6
	move	#63,$dff0a8
	move	#$8201,$dff096
	move.l	#30000,d0
beeploop:
	Rbsr	tests
	dbra	d0,beeploop
	move	#1,$dff096
no_sound:
	movem.l	(sp)+,a0
	Dmove	_delay,d0
dloop2:	move.l	#5000,d1
dloop:	dbra	d1,dloop
	dbra	d0,dloop2
	bra	typer
typeex:	Dmove	chiptable,a1
	move.l	#8,d0
	SyCall	SyFree
	rts
*******	ACTUAL DATE(date1$,date2$)
L_cdate	equ	65
L65
cdate:	movem.l	(a3)+,a0-a1
	movem.l	a3-a6,-(sp)
	movem.l	a0-a1,-(sp)
	cmp.w	#10,(a0)+
	bne	wf
	cmp.w	#10,(a1)+
	bne	wf
	Dlea	dzw1,a2
	move.b	6(a0),(a2)+
	move.b	7(a0),(a2)+
	move.b	8(a0),(a2)+
	move.b	9(a0),(a2)+
	move.b	3(a0),(a2)+
	move.b	4(a0),(a2)+
	move.b	0(a0),(a2)+
	move.b	1(a0),(a2)+
	Dlea	dzw1,a0
	Rbsr	dec_to_bin
	Dsave	d0,dz1
	Dlea	dzw2,a3
	move.b	6(a1),(a3)+
	move.b	7(a1),(a3)+
	move.b	8(a1),(a3)+
	move.b	9(a1),(a3)+
	move.b	3(a1),(a3)+
	move.b	4(a1),(a3)+
	move.b	0(a1),(a3)+
	move.b	1(a1),(a3)+
	Dlea	dzw2,a0
	Rbsr	dec_to_bin
	Dsave	d0,dz2
	movem.l	(sp)+,a0-a1
	move.l	a0,d3
	Dmove2	dz1,dz2,d1,d2
	sub.l	d1,d2
	bmi	gr2
	move.l	a1,d3
gr2:	Rbsr	err_get
	moveq	#2,d2
	movem.l	(sp)+,a3-a6
	rts
wf:	movem.l	(sp)+,a0-a1
	movem.l	(sp)+,a3-a6
	move.l	#23,d0
	Rjmp	L_Error
*******	ACTUAL TIME(time1$,time2$)
L_ctime	equ	66
L66
ctime:	movem.l	(a3)+,a0-a1
	movem.l	a3-a6,-(sp)
	movem.l	a0-a1,-(sp)
	cmp.w	#8,(a0)+
	bne	wf2
	cmp.w	#8,(a1)+
	bne	wf2
	Dlea	dzw1,a2
	move.w	#'00',(a2)+
	move.b	0(a0),(a2)+
	move.b	1(a0),(a2)+
	move.b	3(a0),(a2)+
	move.b	4(a0),(a2)+
	move.b	6(a0),(a2)+
	move.b	7(a0),(a2)+
	Dlea	dzw1,a0
	Rbsr	dec_to_bin
	Dsave	d0,dz1
	Dlea	dzw2,a3
	move.w	#'00',(a3)+
	move.b	0(a1),(a3)+
	move.b	1(a1),(a3)+
	move.b	3(a1),(a3)+
	move.b	4(a1),(a3)+
	move.b	6(a1),(a3)+
	move.b	7(a1),(a3)+
	Dlea	dzw2,a0
	Rbsr	dec_to_bin
	Dsave	d0,dz2
	movem.l	(sp)+,a0-a1
	move.l	a0,d3
	Dmove2	dz1,dz2,d1,d2
	sub.l	d1,d2
	bmi	gr22
	move.l	a1,d3
gr22:	Rbsr	err_get
	moveq	#2,d2
	movem.l	(sp)+,a3-a6
	rts
wf2:	movem.l	(sp)+,a0-a1
	movem.l	(sp)+,a3-a6
	move.l	#23,d0
	Rjmp	L_Error
*******	RESET
L_reset	equ	67
L67
reset:	jmp	$fc00d2

*******	DRAW ANGLE x,y,len,angle
L_drang	equ	68
L68
drang:	movem.l	a3-a6,-(sp)
	bsr	getsincos
	movem.l	(sp)+,a3-a6
	move.l	(a3)+,d3	;angle
	move.l	(a3)+,d2	;len
	move.l	(a3)+,d1	;y
	move.l	(a3)+,d0	;x
	movem.l	a3-a6,-(sp)
	move.l	T_GfxBase(a5),a4
	move.l	FloatBase(a5),a6
	move.l	T_RastPort(a5),d4
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#rastport-JD,a3
	move.l	d4,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#_kx1-JD,a3
	move.l	d0,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#_ky1-JD,a3
	move.l	d1,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#kon2-JD,a3
	move.l	d2,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#kon1-JD,a3
	move.l	d3,(a3)
	movem.l	(sp)+,a3
	Dmove	kon2,d0
	jsr	-36(a6)
	Dsave	d0,kon2		;len>float
	Dmove	kon1,d0
	jsr	-36(a6)
	Dsave	d0,kon1		;angle>float
	Dmove2	kon2,_cos,d0,d1	;len
	jsr	-78(a6)		;len*cos
	jsr	-30(a6)		;>int
	move.l	d0,d7		;>d7
	Dmove2	kon2,_sin,d0,d1	;len
	jsr	-78(a6)		;len*sin
	jsr	-30(a6)		;>int
	move.l	d0,d6		;>d6
	Dmove3	_kx1,_ky1,rastport,d0,d1,a1
	add.l	d0,d7		;x+xoff>d7
	add.l	d1,d6		;y+yoff>d6
	move.l	a4,a6
	jsr	-240(a6)
	move.l	d7,d0
	move.l	d6,d1
	Dmove	rastport,a1
	jsr	-246(a6)
	movem.l	(sp)+,a3-a6
	rts
getsincos:
	move.l	(a3)+,d3
	bsr	testwinkel2
	move.l	d3,-(a3)
	mulu	#4,d3
	Dlea	cosinus,a0
	move.l	0(a0,d3.l),d7
	Dlea	sinus,a0	
	move.l	0(a0,d3.l),d6
	Dsave2	d7,d6,_cos,_sin
	rts
testwinkel2:
	cmp.l	#0,d3
	bmi	add360a
	cmp.l	#360,d3
	bgt	sub360a
	rts
add360a	add.l	#360,d3
	bra	testwinkel2
sub360a	sub.l	#360,d3
	bra	testwinkel2
*******	KEYPRESS
L_getk	equ	69
L69
getk:	moveq	#0,d3
	move.b	$bfec01,d3
	move.l	d3,d2
	and.b	#$fe,d2
	cmp.l	d3,d2
	bne	pressed
	moveq	#0,d3
pressed:
	moveq	#0,d2
	rts
*******	ROL(anz,zahl)
L_rol	equ	70
L70
rol:	move.l	(a3)+,d3
	move.l	(a3)+,d2
	sub.l	#1,d2
rllanz:	rol.l	#1,d3
	dbra	d2,rllanz
	moveq	#0,d2
	rts
*******	ROR(anz,zahl)
L_ror	equ	71
L71
ror:	move.l	(a3)+,d3
	move.l	(a3)+,d2
	sub.l	#1,d2
rrlanz:	ror.l	#1,d3
	dbra	d2,rrlanz
	moveq	#0,d2
	rts
*******	ROXL(anz,zahl)
L_roxl	equ	72
L72
roxl:	move.l	(a3)+,d3
	move.l	(a3)+,d2
	sub.l	#1,d2
rlxlanz:
	roxl.l	#1,d3
	dbra	d2,rlxlanz
	moveq	#0,d2
	rts
*******	ROXR(anz,zahl)
L_roxr	equ	73
L73
roxr:	move.l	(a3)+,d3
	move.l	(a3)+,d2
	sub.l	#1,d2
rrxlanz:
	roxr.l	#1,d3
	dbra	d2,rrxlanz
	moveq	#0,d2
	rts
*******	LSL(anz,zahl)
L_lsl	equ	74
L74
lsl:	move.l	(a3)+,d3
	move.l	(a3)+,d2
	sub.l	#1,d2
lslanz:	lsl.l	#1,d3
	dbra	d2,lslanz
	moveq	#0,d2
	rts
*******	LSR(anz,zahl)
L_lsr	equ	75
L75
lsr:	move.l	(a3)+,d3
	move.l	(a3)+,d2
	sub.l	#1,d2
lsrlanz:
	lsr.l	#1,d3
	dbra	d2,lsrlanz
	moveq	#0,d2
	rts
*******	ASL(anz,zahl)
L_asl	equ	76
L76
asl:	move.l	(a3)+,d3
	move.l	(a3)+,d2
	sub.l	#1,d2
asllanz:
	asl.l	#1,d3
	dbra	d2,asllanz
	moveq	#0,d2
	rts
*******	ASR(anz,zahl)
L_asr	equ	77
L77
asr:	move.l	(a3)+,d3
	move.l	(a3)+,d2
	sub.l	#1,d2
asrlanz:
	asr.l	#1,d3
	dbra	d2,asrlanz
	moveq	#0,d2
	rts
*******	IMP(zahl,zahl)
L_imp	equ	78
L78
imp:	move.l	(a3)+,d1
	move.l	(a3)+,d0
	moveq	#0,d3
it1:	btst	#31,d0
	bne	iset
	bra	iunset
impl:	lea	it1+3(pc),a0
	move.b	(a0),d5
	sub.l	#1,d5
	cmp.b	#-1,d5
	beq	imp_ready
	move.b	d5,(a0)
	lea	iset+3(pc),a0
	move.b	d5,(a0)
	lea	iunset+3(pc),a0
	move.b	d5,(a0)
	bra	it1
iset:	btst	#31,d1
	bne	iunset
	bra	impl
iunset:	bset	#31,d3
	bra	impl
imp_ready:
	move.b	#31,d5
	lea	it1+3(pc),a0
	move.b	d5,(a0)
	lea	iset+3(pc),a0
	move.b	d5,(a0)
	lea	iunset+3(pc),a0
	move.b	d5,(a0)
	moveq	#0,d2
	rts
*******	EQV(zahl,zahl)
L_eqv	equ	79
L79
eqv:	move.l	(a3)+,d1
	move.l	(a3)+,d0
	moveq	#0,d3
t1:	btst	#31,d0
	bne	set
t2:	btst	#31,d1
	beq	unset
eqvl:	lea	t1+3(pc),a0
	move.b	(a0),d5
	sub.l	#1,d5
	cmp.b	#-1,d5
	beq	eqv_ready
	move.b	d5,(a0)
	lea	t2+3(pc),a0
	move.b	d5,(a0)
	lea	set+3(pc),a0
	move.b	d5,(a0)
	lea	unset+3(pc),a0
	move.b	d5,(a0)
	bra	t1
set:	btst	#31,d1
	bne	unset
	bra	eqvl
unset:	bset	#31,d3
	bra	eqvl
eqv_ready:
	move.b	#31,d5
	lea	t1+3(pc),a0
	move.b	d5,(a0)
	lea	t2+3(pc),a0
	move.b	d5,(a0)
	lea	set+3(pc),a0
	move.b	d5,(a0)
	lea	unset+3(pc),a0
	move.b	d5,(a0)
	moveq	#0,d2
	rts
*******	INTSCREEN BASE
L_getsb	equ	80
L80
getsb:	move.l	T_ScreenAdr(a5),d3
	moveq	#0,d2
	rts
*******	INTWINDOW BASE
L_getwb	equ	81
L81
getwb:	move.l	T_WindowAdr(a5),d3
	moveq	#0,d2
	rts
*******	LINSTR(string,instring)
L_linstr	equ	82
L82
linstr:	movem.l	a3-a6,-(sp)
	Rbsr	uninit
	movem.l	(sp)+,a3-a6
	move.l	(a3)+,a1
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	Mlea	p1_jbuffer,a2
	Mlea	p2_jbuffer,a4
	moveq	#0,d0
	moveq	#0,d1
	move.w	(a0)+,d0
	beq	lin_err
	move.w	d0,(a2)+
	ext.l	d0
	move.l	d0,d6
	sub.l	#1,d0
flip1:	move.b	(a0,d1),(a2,d0)
	add.l	#1,d1
	dbra	d0,flip1
	moveq	#0,d1
	move.w	(a1)+,d0
	beq	lin_err
	move.w	d0,(a4)+
	ext.l	d0
	move.l	d0,d7
	sub.l	#1,d0
flip2:	move.b	(a1,d1),(a4,d0)
	add.l	#1,d1
	dbra	d0,flip2
	movem.l	(sp)+,a3-a6
	movem.l	a3-a6,-(sp)
	Mlea	p1_jbuffer,a0
	Mlea	p2_jbuffer,a1
	movem.l	(sp)+,a3-a6
	move.l	a0,-(a3)
	move.l	a1,-(a3)
	bsr	ninstr
	moveq	#0,d2
	cmp.l	#0,d3
	beq	nnin
	add.l	d7,d3
	sub.l	#1,d3
	add.l	#1,d6
	sub.l	d3,d6
	move.l	d6,d3
nnin:	rts
lin_err:
	movem.l	(sp)+,a3-a6
	move.l	#0,d3
	moveq	#0,d2
	rts
ninstr:	moveq	#0,d2
	move.l	(a3)+,a2
	move.w	(a2)+,d2
	moveq	#0,d1
	move.l	(a3)+,a1
	move.w	(a1)+,d1
	moveq	#0,d4
	bsr	lbC16
	rts
lbC16	movem.l	a3,-(sp)
	tst.l	d2
	beq	lbC4E
	tst.l	d4
	beq	lbC22
	subq.l	#1,d4
lbC22	add.l	d4,a1
lbC24	clr.w	d3
lbC26	move.l	a2,a3
	addq.w	#1,d4
	cmp.w	d1,d4
	bhi	lbC4E
	cmpm.b	(a1)+,(a3)+
	bne	lbC26
	move.l	a1,a0
	move.w	d4,d0
lbC36	addq.w	#1,d3
	cmp.w	d2,d3
	bcc	lbC48
	addq.w	#1,d0
	cmp.w	d1,d0
	bhi	lbC4E
	cmpm.b	(a0)+,(a3)+
	beq	lbC36
	bra	lbC24
lbC48	move.l	d4,d3
	movem.l	(sp)+,a3
	rts
lbC4E	moveq	#0,d3
	movem.l	(sp)+,a3
	rts
******* CHECKPRT
L_cp	equ	83
L83
cp:	lea	$bfd0c8,a0
	clr.l	d3
	move.b	(a0)+,d3
	eor	#%11111000,d3
	cmp.b	#4,d3
	bne	cp1
	move.l	#0,d3		;ok
	bra	cpex
cp1:	cmp.b	#0,d3
	bne	cp2
	move.l	#2,d3		;offline
	bra	cpex
cp2:	cmp.b	#7,d3
	bne	cp3
	move.l	#1,d3		;aus
	bra	cpex
cp3:	cmp.b	#2,d3
	bne	cp4
	move.l	#3,d3		;papier
	bra	cpex
cp4:	ext.w	d3
	ext.l	d3
cpex:	moveq	#0,d2
	rts
*******	SPLINE x1,y1,x2,y2,x3,y3,step
L_spline	equ	84
L84
	movem.l	(a3)+,d0-d6
	movem.l	a3,-(sp)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#stepper-JD,a3
	move.l	#0,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#fl-JD,a3
	move.l	#0,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#_kx1-JD,a3
	move.l	d6,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#_ky1-JD,a3
	move.l	d5,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#_kx2-JD,a3
	move.l	d4,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#_ky2-JD,a3
	move.l	d3,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#_kx3-JD,a3
	move.l	d2,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#_ky3-JD,a3
	move.l	d1,(a3)
	move.l	ExtAdr+ExtNb*16(a5),a3
	add.w	#_step-JD,a3
	move.l	d0,(a3)
	movem.l	(sp)+,a3
	move.l	d6,d7
	sub.l	d2,d7
	Dsave	d7,kon1
	move.l	d5,d7
	sub.l	d1,d7
	Dsave	d7,kon2
	move.l	d2,d7
	sub.l	d4,d7
	Dsave	d7,kon3
	move.l	d1,d7
	sub.l	d3,d7
	Dsave	d7,kon4
splil:	Dmove2	stepper,_step,d7,d6
	cmp.l	d6,d7
	ble	XS1
	rts
XS1:	Dmove4	kon1,stepper,_step,_kx1,d1,d7,d6,d0
	muls	d7,d1
	divs	d6,d1
	sub.l	d1,d0
	ext.l	d0
	Dsave	d0,_XS1
XS2:	Dmove4	kon3,stepper,_step,_kx3,d1,d7,d6,d0
	muls	d7,d1
	divs	d6,d1
	sub.l	d1,d0
	ext.l	d0
	Dsave	d0,_XS2
YS1:	Dmove4	kon2,stepper,_step,_ky1,d1,d7,d6,d0
	muls	d7,d1
	divs	d6,d1
	sub.l	d1,d0
	ext.l	d0
	Dsave	d0,_YS1
YS2:	Dmove4	kon4,stepper,_step,_ky3,d1,d7,d6,d0
	muls	d7,d1
	divs	d6,d1
	sub.l	d1,d0
	ext.l	d0
	Dsave	d0,_YS2
XS:	Dmove4	_XS1,_XS2,stepper,_step,d0,d1,d7,d6
	sub.l	d1,d0
	muls	d7,d0
	divs	d6,d0
	Dmove	_XS1,d1
	sub.l	d0,d1
	ext.l	d1
	Dsave	d1,_XS
YS:	Dmove4	_YS1,_YS2,stepper,_step,d0,d1,d7,d6
	sub.l	d1,d0
	muls	d7,d0
	divs	d6,d0
	Dmove	_YS1,d1
	sub.l	d0,d1
	ext.l	d1
	Dsave	d1,_YS
if:	Dmove	fl,d0
	cmp.l	#0,d0
	beq	setfl
	bsr	_draw
	bra	asfl
setfl:	Dsave	#1,fl
	bsr	locit
asfl:	Dmove	stepper,d0
	add.l	#1,d0
	Dsave	d0,stepper
	bra	splil
_draw:	movem.l	a3-a6,-(sp)
	move.l	T_RastPort(a5),a1
	move.l	T_GfxBase(a5),a6
	Dmove2	_XO,_YO,d0,d1
	jsr	-240(a6)
	move.l	T_RastPort(a5),a1
	Dmove2	_XS,_YS,d0,d1
	Dsave2	d0,d1,_XO,_YO
	jsr	-246(a6)
	movem.l	(sp)+,a3-a6
	rts
locit:	movem.l	a3-a6,-(sp)
	move.l	T_RastPort(a5),a1
	move.l	T_GfxBase(a5),a6
	Dmove2	_kx1,_ky1,d0,d1
	Dsave2	d0,d1,_XO,_YO
	jsr	-240(a6)
	movem.l	(sp)+,a3-a6
	rts

L_openmt	equ	85
L85
	movem.l	d0-d3,-(sp)
	move.l	FloatBase(a5),a5
	lea	mtname(pc),a1
	move.l	4,a6
	jsr	-408(a6)
	move.l	d0,a6
	movem.l	(sp)+,d0-d3
	rts
mtname:
	dc.b	'mathtrans.library',0
	even

*******	E#
L_e	equ	86
L86
e:	move.l	#$adf85442,d3
	moveq	#1,d2
	rts
L_getxypos	equ 87
L87
getxypos:
	movem.l	a3-a6,-(sp)
	WiCall	XYCuWi
	movem.l	(sp)+,a3-a6
	move.l	d2,d0
	rts
*******	TEXTFONT name,big
L_font	equ	88
L88
set_font:
	movem.l	a3-a6,-(sp)
	move.l	4,a6
	Dlea	gfxname,a1
	jsr	-408(a6)
	Dsave	d0,gfxbase
	Dlea	fontname,a1
	jsr	-408(a6)
	Dsave	d0,fontbase
	Dmove2	font_font,gfxbase,a1,a6
	beq	no_rem
	jsr	-78(a6)
no_rem:	movem.l	(sp)+,a3-a6	
	movem.l	(a3)+,d0/a0
	move.l	T_RastPort(a5),d1
	movem.l	a3-a6,-(sp)
	Dsave	d1,rastport
	add.l	#2,a0
	Dlea	font_textattr,a1
	move.l	a0,(a1)+	
	move.w	d0,(a1)
	Dmove	fontbase,a6
	Dlea	font_textattr,a0
	jsr	-30(a6)
	Dsave	d0,font_font
set_druid_font:
	Dmove3	gfxbase,font_font,rastport,a6,a0,a1
	jsr	-66(a6)
	movem.l	(sp)+,a3-a6
	Dmove	font_font,a0
	move.w	20(a0),d0
	move.w	24(a0),d1
	ext.l	d0
	ext.l	d1
	Dsave2	d1,d0,fx,fy
	rts
*******	PRINT "text"
L_print	equ	89
L89
pri:	movem.l	a3-a6,-(sp)
	Dmove	font_font,a0
	cmp.l	#0,a0
	beq	nojdf
	Dlea	cuoff,a1
	WiCall	Print
	move.l	4,a6
	Dlea	gfxname,a1
	jsr	-408(a6)
	Dsave	d0,gfxbase
	movem.l	(sp)+,a3-a6
	movem.l	a3-a6,-(sp)
	move.l	T_RastPort(a5),a1
	Dsave	a1,rastport
	Rbsr	L_getxypos
	movem.l	d0-d1,-(sp)
	Dmove3	gfxbase,fx,fy,a6,d3,d4
	add.l	#1,d0
	mulu	d4,d0
	mulu	d3,d1
	sub.l	#2,d0
	move.l	d1,d2
	move.l	d0,d1
	move.l	d2,d0
	jsr	-240(a6)
	Dmove	rastport,a1
	move.l	(a3)+,a0
	move.w	(a0)+,d0
	ext.l	d0
	movem.l	d0,-(sp)
	jsr	-60(a6)
	movem.l	(sp)+,d2
	movem.l	(sp)+,d0-d1
	add.l	d2,d1
	move.l	d0,d2
	WiCall	Locate
jdpe:	movem.l	(sp)+,a3-a6
	move.l	(a3)+,d0
	rts
nojdf:	movem.l	(sp)+,a3-a6
	move.l	(a3)+,a1
	move.w	(a1)+,d0
	movem.l	a3-a6,-(sp)
	WiCall	Print
	movem.l	(sp)+,a3-a6
	rts
*******	HARDWARE$
L_hw	equ	90
L90
hw:	move.l	#0,d6
	Rbra	L_getvoldev
*******	VOLUME$
L_vol	equ	91
L91
vol:	move.l	#2,d6
	Rbra	L_getvoldev
*******	LOGICAL$
L_logic	equ	92
L92
log:	move.l	#1,d6
	Rbra	L_getvoldev

L_getvoldev	equ	93
L93
	movem.l	a3-a6,-(sp)
	move.l	DosBase(a5),a6
	move.l	a6,a0
	move.l	$22(a0),a1
	move.l	$18(a1),d0
	asl.l	#2,d0
	move.l	d0,a0
	move.l	4(a0),d0
	asl.l	#2,d0
	move.l	d0,a4
	Mlea	p1_jbuffer,a1
devDLT_DEVICE:
	move.l	4(a4),d5
	cmp.l	d6,d5
	bne	devdevcont	
	move.l	$28(a4),d0
	asl.l	#2,d0
	move.l	d0,a0
	bsr	devdevtxt
devdevcont:
	move.l	0(a4),d7
	tst.l	d7
	beq	devquit
	asl.l	#2,d7
	move.l	d7,a4
	bra	devDLT_DEVICE
devquit:
	move.l	#-1,d0
	Mlea	p1_jbuffer,a0
gethdlen:
	add.l	#1,d0
	cmp.b	#0,(a0)+
	bne	gethdlen
	movem.l	d0,-(sp)
	Rbsr	get_mem
	Dmove	var_buffer,a1
	Mlea	p1_jbuffer,a0
	movem.l	(sp)+,d0
	move.w	d0,(a1)+
	sub.l	#1,d0
chwl:	move.b	(a0)+,(a1)+
	dbra	d0,chwl
	Rbsr	uninit
	movem.l	(sp)+,a3-a6
	Dmove	var_buffer,d3
	moveq	#2,d2
	rts
devdevtxt:
	add.l	#1,a0
hwcl:	move.b	(a0)+,(a1)+
	bne	hwcl
	move.b	#':',-(a1)
	add.l	#1,a1
	rts
*******	CHAR X
L_charx	equ	94
L94
charx:	Dmove	fx,d3
	moveq	#0,d2
	rts
*******	CHAR Y
L_chary	equ	95
L95
chary:	Dmove	fy,d3
	moveq	#0,d2
	rts

L_sccopy	equ	96
L96
	move.l	#$CC,d6
	move.l	8(a3),d1
	Rbsr	get_screen
	move.l	d0,$348(a5)
	movea.l	a0,a1
	move.l	$1C(a3),d1
	Rbsr	get_screen
	move.l	d0,$344(a5)
	move.l	(a3)+,d3
	move.l	(a3)+,d2
	addq.l	#4,a3
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	addq.l	#4,a3
	movem.l	a3/a6,-(sp)
	tst.w	d0
	bpl	lbcC00000C
	sub.w	d0,d2
	clr.w	d0
lbcC00000C	tst.w	d1
	bpl	lbcC000014
	sub.w	d1,d3
	clr.w	d1
lbcC000014	tst.w	d2
	bpl	lbcC00001C
	sub.w	d2,d0
	clr.w	d2
lbcC00001C	tst.w	d3
	bpl	lbcC000024
	sub.w	d3,d1
	clr.w	d3
lbcC000024	cmp.w	$4C(a0),d0
	bcc	lbcC0000F0
	cmp.w	$4E(a0),d1
	bcc	lbcC0000F0
	cmp.w	$4C(a1),d2
	bcc	lbcC0000F0
	cmp.w	$4E(a1),d3
	bcc	lbcC0000F0
	tst.w	d4
	bmi	lbcC0000F0
	cmp.w	$4C(a0),d4
	bls	lbcC000054
	move.w	$4C(a0),d4
lbcC000054	tst.w	d5
	bmi	lbcC0000F0
	cmp.w	$4E(a0),d5
	bls	lbcC000064
	move.w	$4E(a0),d5
lbcC000064	sub.w	d0,d4
	bls	lbcC0000F0
	sub.w	d1,d5
	bls	lbcC0000F0
	move.w	d2,d7
	add.w	d4,d7
	sub.w	$4C(a1),d7
	bls	lbcC000080
	sub.w	d7,d4
	bls	lbcC0000F0
lbcC000080	move.w	d3,d7
	add.w	d5,d7
	sub.w	$4E(a1),d7
	bls	lbcC00008E
	sub.w	d7,d5
	bls	lbcC0000F0
lbcC00008E	ext.l	d0
	ext.l	d1
	ext.l	d2
	ext.l	d3
	ext.l	d4
	ext.l	d5
	movea.l	T_ChipBuf(a5),a2
	lea	$28(a2),a3
	move.w	$B2(a0),(a2)+
	move.w	$B2(a1),(a3)+
	move.w	$4E(a0),(a2)+
	move.w	$4E(a1),(a3)+
	move.w	$50(a0),(a2)+
	move.w	$50(a1),(a3)+
	clr.w	(a2)+
	clr.w	(a3)+
	movea.l	$344(a5),a0
	movea.l	$348(a5),a1
	moveq	#5,d7
lbcC0000C8	move.l	(a0)+,(a2)+
	move.l	(a1)+,(a3)+
	dbra	d7,lbcC0000C8
	movea.l	T_ChipBuf(a5),a0
	lea	$28(a0),a1
	lea	$28(a1),a2
	movea.l	T_EcVect(a5),a6
	jsr	ScCpyW*4(a6)
	beq	lbcC0000F0
	moveq	#-1,d7
	movea.l	T_GfxBase(a5),a6
	jsr	-30(a6)			;BltBitMap
lbcC0000F0	movem.l	(sp)+,a3/a6
	rts
get_screen	equ	97
L97
	EcCall	AdrEc
	move.l	d0,a0
	rts
*******	SLIDE X source to dest
L_slidx	equ	98
L98
x_slide:
	move.l	(a3)+,d5
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	movem.l	d0/d5,-(sp)
	Rbsr	L_clear
	move.l	d0,d1
	Rbsr	get_screen
	movem.l	(sp)+,d0/d5
	move.w	$4c(a0),d3
	move.w	$4e(a0),d4
	ext.l	d3
	ext.l	d4
	Dlea	_dy,a0
	move.l	#0,0(a0)
	move.l	#0,4(a0)
	move.l	#0,20(a0)
	move.l	d0,28(a0)	;source
	move.l	d5,8(a0)	;dest
	move.l	d4,12(a0)	;y2
	move.l	d3,16(a0)	;x2
	move.l	16(a0),d0
	sub.l	#1,d0
	move.l	d0,24(a0)	;x1
scc2:	move.l	#0,4(a0)	;x3
scc:	Dlea	_dy,a3
	Rbsr	L_sccopy
	Rbsr	tests
	Rbsr	L_getk
	cmp.l	#117,d3
	beq	sto
	Dlea	_dy,a0
	move.l	4(a0),d0	;x3
	add.l	#1,d0
	move.l	d0,4(a0)	;x3
	move.l	16(a0),d1	;x2
	cmp.l	d0,d1
	bne	scc
	sub.l	#1,d1
	move.l	d1,16(a0)	;x2
	move.l	16(a0),d1
	sub.l	#1,d1
	move.l	d1,24(a0)	;x1
	cmp.l	#0,d1
	bpl	scc2
sto:	movem.l	(sp)+,a3-a6
	rts
*******	SLIDE Y source to dest
L_slidy	equ	99
L99
y_slide:
	move.l	(a3)+,d5
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	movem.l	d0/d5,-(sp)
	Rbsr	L_clear
	move.l	d0,d1
	Rbsr	get_screen
	movem.l	(sp)+,d0/d5
	move.w	$4c(a0),d3
	move.w	$4e(a0),d4
	ext.l	d3
	ext.l	d4
	Dlea	_dy,a0
	move.l	#0,0(a0)	;y3
	move.l	#0,4(a0)	;x3
	move.l	#0,24(a0)	;y1
	move.l	d0,28(a0)	;source
	move.l	d5,8(a0)	;dest
	move.l	d4,12(a0)	;y2
	move.l	d3,16(a0)	;x2
	move.l	12(a0),d0
	sub.l	#1,d0
	move.l	d0,20(a0)	;y1
scc4:	move.l	#0,0(a0)	;y3
scc3:	Dlea	_dy,a3
	Rbsr	L_sccopy
	Rbsr	tests
	Rbsr	L_getk
	cmp.l	#117,d3
	beq	sto2
	Dlea	_dy,a0
	move.l	0(a0),d0	;y3
	add.l	#1,d0
	move.l	d0,0(a0)	;y3
	move.l	12(a0),d1	;y2
	cmp.l	d0,d1
	bne	scc3
	sub.l	#1,d1
	move.l	d1,12(a0)	;y2
	move.l	12(a0),d1
	sub.l	#1,d1
	move.l	d1,20(a0)	;y1
	cmp.l	#0,d1
	bpl	scc4
sto2:	movem.l	(sp)+,a3-a6
	rts
*******	SLIDE LEFT source to dest
L_slidl	equ	100
L100
	move.l	(a3)+,d5
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	movem.l	d0/d5,-(sp)
	Rbsr	L_clear
	move.l	d0,d1
	Rbsr	get_screen
	movem.l	(sp)+,d0/d5
	move.w	$4c(a0),d3
	move.w	$4e(a0),d4
	ext.l	d3
	ext.l	d4
	Dlea	_dy,a0
	move.l	#0,0(a0)
	move.l	d3,4(a0)
	sub.l	#1,4(a0)
	move.l	#0,20(a0)
	move.l	d0,28(a0)	;source
	move.l	d5,8(a0)	;dest
	move.l	d4,12(a0)	;y2
	move.l	d3,16(a0)	;x2
	move.l	4(a0),24(a0)	;x1
scca:	Dlea	_dy,a3
	Rbsr	L_sccopy
	Rbsr	tests
	Dlea	_dy,a0
	move.l	4(a0),d1	;x3
	sub.l	#1,d1
	move.l	d1,4(a0)	;x3
	move.l	d1,24(a0)	;x1
	add.l	#1,d1
	move.l	d1,16(a0)	;x2
	cmp.l	#0,d1
	bne	scca
	movem.l	(sp)+,a3-a6
	rts
*******	SLIDE RIGHT source to dest
L_slidr	equ	101
L101
	move.l	(a3)+,d5
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	movem.l	d0/d5,-(sp)
	Rbsr	L_clear
	move.l	d0,d1
	Rbsr	get_screen
	movem.l	(sp)+,d0/d5
	move.w	$4c(a0),d3
	move.w	$4e(a0),d4
	ext.l	d3
	ext.l	d4
	movem.l	d3,-(sp)
	Dlea	_dy,a0
	move.l	#0,0(a0)
	move.l	#0,4(a0)
	move.l	#0,20(a0)
	move.l	d0,28(a0)	;source
	move.l	d5,8(a0)	;dest
	move.l	d4,12(a0)	;y2
	move.l	#1,16(a0)	;x2
	move.l	4(a0),24(a0)	;x1
sccb:	Dlea	_dy,a3
	Rbsr	L_sccopy
	Rbsr	tests
	Dlea	_dy,a0
	add.l	#1,4(a0)	;x3
	add.l	#1,24(a0)	;x1
	add.l	#1,16(a0)	;x2
	movem.l	(sp)+,d7
	movem.l	d7,-(sp)
	move.l	4(a0),d6
	cmp.l	d7,d6
	bne	sccb
	movem.l	(sp)+,d7
	movem.l	(sp)+,a3-a6
	rts

L_clear	equ	102
L102
	Dlea	_dy,a0
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	rts
*******	SLIDE UP source to dest
L_slidu	equ	103
L103
	move.l	(a3)+,d5
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	movem.l	d0/d5,-(sp)
	Rbsr	L_clear
	move.l	d0,d1
	Rbsr	get_screen
	movem.l	(sp)+,d0/d5
	move.w	$4c(a0),d3
	move.w	$4e(a0),d4
	ext.l	d3
	ext.l	d4
	Dlea	_dy,a0
	move.l	#0,4(a0)	;x3
	move.l	d3,16(a0)	;x2
	move.l	#0,24(a0)	;x1
	move.l	d0,28(a0)	;source
	move.l	d5,8(a0)	;dest
	move.l	d4,12(a0)	;y2
	sub.l	#1,d4
	move.l	d4,0(a0)	;y3
	move.l	d4,20(a0)	;y1
sccc:	Dlea	_dy,a3
	Rbsr	L_sccopy
	Rbsr	tests
	Dlea	_dy,a0
	sub.l	#1,0(a0)	;y3
	sub.l	#1,20(a0)	;y1
	sub.l	#1,12(a0)	;y2
	move.l	#-1,d1
scw:	dbra	d1,scw
	move.l	12(a0),d1
	cmp.l	#0,d1
	bne	sccc
	movem.l	(sp)+,a3-a6
	rts
*******	SLIDE DOWN source to dest
L_slidd	equ	104
L104
	move.l	(a3)+,d5
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	movem.l	d0/d5,-(sp)
	Rbsr	L_clear
	move.l	d0,d1
	Rbsr	get_screen
	movem.l	(sp)+,d0/d5
	move.w	$4c(a0),d3
	move.w	$4e(a0),d4
	ext.l	d3
	ext.l	d4
	Dlea	_dy,a0
	move.l	#0,4(a0)	;x3
	move.l	d3,16(a0)	;x2
	move.l	#0,24(a0)	;x1
	move.l	d0,28(a0)	;source
	move.l	d5,8(a0)	;dest
	move.l	#1,12(a0)	;y2
	move.l	#0,0(a0)	;y3
	move.l	#0,20(a0)	;y1
	movem.l	d4,-(sp)
scce:	Dlea	_dy,a3
	Rbsr	L_sccopy
	Rbsr	tests
	Dlea	_dy,a0
	add.l	#1,0(a0)	;y3
	add.l	#1,20(a0)	;y1
	add.l	#1,12(a0)	;y2
	move.l	#-1,d7
scw2:	dbra	d7,scw2
	move.l	20(a0),d6
	movem.l	(sp)+,d7
	movem.l	d7,-(sp)
	cmp.l	d6,d7
	bne	scce
	movem.l	(sp)+,d7
	movem.l	(sp)+,a3-a6
	rts
*******	INSTALL device
L_install	equ	105
L105	
	movem.l	a3-a6,-(sp)
	Rbsr	uninit
	Mlea	bb,a0
	move.l	a0,a3
	lea	bbd(pc),a1
	move.l	#12,d0
l0l:	move.l	(a1)+,(a3)+
	dbra	d0,l0l
	movem.l	(sp)+,a3-a6
	move.l	(a3)+,d0
	move.l	a0,-(a3)
	move.l	d0,-(a3)
	move.l	#0,-(a3)
	Rbra	L_wsec
bbd:	dc.w	512
	dc.l	$444f5300,$c0200f19,$00000370,$43fa0018
	dc.l	$4eaeffa0,$4a80670a,$20402068,$00167000
	dc.l	$4e7570ff,$60fa646f,$732e6c69,$62726172
	dc.l	$7900
*******	FORMAT(device,name)
L_format	equ	106
L106
	move.l	(a3)+,a0
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	Dsave3	#0,d0,a0,tracknr,device,d_name
	Rbsr	nulltracks
	Rbsr	L_opend
folop:	Dmove	tracknr,d1	***0to159
	cmp.l	#160,d1
	beq	foend
	cmp.l	#0,d1
	bne	no_dos
	Mlea	tracks,a0
	move.l	#$444f5300,(a0)+
	move.l	#$bbb0a98f,(a0)+
	move.l	#$370,(a0)+
	bra	wrroot
no_dos:	cmp.l	#1,d1
	bne	no_boot
	Mlea	tracks,a0
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	bra	wrroot
no_boot:
	cmp.l	#81,d1
	bne	n_rest
	move.l	#240,d0
	Mlea	tracks,a0
crest:	move.l	#0,(a0)+
	dbra	d0,crest
	bra	wrroot
n_rest:	cmp.l	#80,d1
	bne	wrroot
	Mlea	tracks,a0
	Dlea	roottrack,a1
	move.l	#183,d0
bc:	move.l	(a1)+,(a0)+
	dbra	d0,bc
	move.l	#71,d0
bc2:	move.l	#0,(a0)+
	dbra	d0,bc2
	Mlea	tracks,a1
	add.l	#432,a1
	Dmove	d_name,a0
	add.l	#1,a0
stname:	move.b	(a0)+,(a1)+
stnam:	move.b	(a0)+,(a1)+
	bne	stnam
	Mlea	tracks,a1
	bsr	t_checksum
wrroot:	bsr	twr
	cmp.l	#0,d7
	bne	foend
	Dmove	tracknr,d1
	add.l	#1,d1
	Dsave	d1,tracknr
	bra	folop
foend:	Rbsr	L_motor
	Rbsr	L_closd
	bra	foend3
foend2:	move.l	#-1,d7
foend3:	movem.l	(sp)+,a3-a6
	move.l	d7,d3
	moveq	#0,d2
	rts
t_checksum
	moveq	#$7F,d1
	moveq	#0,d0
	movea.l	a1,a0
	clr.l	$14(a1)
t_chksum
	sub.l	(a0)+,d0
	dbra	d1,t_chksum
	move.l	d0,$14(a1)
	rts
twr:	Dlea	diskio,a1
	Dlea	msgport,a0
	move.l	a0,14(a1)
	move.w	#11,28(a1)
	Mlea	tracks,a0
	move.l	a0,40(a1)
	Dmove	tracknr,d2
 	mulu.w	#$1600,d2
	move.l	d2,44(a1)
	move.l	#$1600,36(a1)
	move.l	4,a6
	jsr	-456(a6)
	cmp.l	#0,d0
	beq	twok
	move.l	#-1,d7
twok:	rts
*******	COPY(file to file)
L_fcopy	equ	107
L107
fcopy:	move.l	(a3)+,a1
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	add.l	#2,a0
	add.l	#2,a1
	Dsave2	a0,a1,f1name,f2name
	move.l	DosBase(a5),a6
	Dmove	f1name,a0
	move.l	a0,d1
	move.l	#-2,d2
	jsr	-84(a6)
	cmp.l	#0,d0
	beq	ende3
	Dsave	d0,_lock
	move.l	d0,d1
	Dlea	fib,a0
	move.l	a0,d2
	jsr	-102(a6)
	Dlea	fib,a0
	move.l	124(a0),d0
	Dsave	d0,efflen
	Dmove	_lock,d1
	jsr	-90(a6)
	move.l	4,a6
	Dmove	efflen,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	Dsave	d0,buffer_adr
	beq	no_buffermem
	movem.l	(sp)+,a3-a6
	movem.l	a3-a6,-(sp)
	move.l	DosBase(a5),a6
	moveq	#0,d0
	Dmove	f1name,d1
	move.l	#1005,d2
	jsr	-30(a6)
	Dsave	d0,filehandle
	Dmove3	filehandle,buffer_adr,efflen,d1,d2,d3
	jsr	-42(a6)
	Dmove	filehandle,d1
	jsr	-36(a6)
	Dmove	f2name,d1
	move.l	#1006,d2
	jsr	-30(a6)
	Dsave	d0,filehandle
	cmp.l	#0,d0
	beq	coperror
	Dmove3	filehandle,buffer_adr,efflen,d1,d2,d3
	jsr	-48(a6)
	Dmove	filehandle,d1
	jsr	-36(a6)
	move.l	4,a6
	Dmove2	buffer_adr,efflen,a1,d0
	jsr	-210(a6)
	moveq	#0,d3
	bra	ende4
coperror:
	move.l	4,a6
	Dmove2	buffer_adr,efflen,a1,d0
	jsr	-210(a6)
ende3:	move.l	#-1,d3
ende4:	moveq	#0,d2
	movem.l	(sp)+,a3-a6
	rts
no_buffermem:
	movem.l	(sp)+,a3-a6
	moveq	#24,d0
	Rjmp	L_Error

nulltracks	equ	108
L108
	movem.l	d0-d7/a0-a6,-(sp)
	Mlea	tracks,a0
	move.l	#$15ff,d0
ntl:	move.b	#0,(a0)+
	dbra	d0,ntl
	movem.l	(sp)+,d0-d7/a0-a6
	rts
*******	RELABEL device,"name"
L_relab	equ	109
L109
relab:	move.l	(a3)+,a0
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	Dsave3	a0,d0,#512,d_name,device,wrlen
	move.l	d0,-(a3)
	move.l	#880,-(a3)
	Rbsr	L_rsec
	cmp.l	#0,d3
	beq	relerr
	move.l	d3,a1
	Dsave	d3,var_buffer
	add.l	#2,a1
	add.l	#432,a1
	Dmove	d_name,a0
	add.l	#1,a0
	move.b	(a0)+,(a1)+
stnam2:	move.b	(a0)+,(a1)+
	bne	stnam2
	Dmove	var_buffer,a1
	add.l	#2,a1
	bsr	t_checksum2
	Dmove2	var_buffer,device,a0,d0
	move.l	a0,-(a3)
	move.l	d0,-(a3)
	move.l	#880,-(a3)
	Rbsr	L_wsec
relerr:	movem.l	(sp)+,a3-a6
	rts
t_checksum2:
	moveq	#$7F,d1
	moveq	#0,d0
	movea.l	a1,a0
	clr.l	$14(a1)
t_chksum2:
	sub.l	(a0)+,d0
	dbra	d1,t_chksum2
	move.l	d0,$14(a1)
	rts
*******	SHORTFORMAT(device,name)
L_sformat	equ	110
L110
	move.l	(a3)+,a0
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	Dsave3	#80,d0,a0,tracknr,device,d_name
	Rbsr	nulltracks
	Rbsr	L_opend
sfolop:	Dmove	tracknr,d1
	cmp.l	#82,d1
	beq	sfoend
	cmp.l	#81,d1
	bne	sn_rest
	move.l	#240,d0
	Mlea	tracks,a0
screst:	move.l	#0,(a0)+
	dbra	d0,screst
	bra	swrroot
sn_rest:
	cmp.l	#80,d1
	bne	swrroot
	Mlea	tracks,a0
	Dlea	roottrack,a1
	move.l	#183,d0
sbc:	move.l	(a1)+,(a0)+
	dbra	d0,sbc
	move.l	#71,d0
bc_2:	move.l	#0,(a0)+
	dbra	d0,bc_2
	Mlea	tracks,a1
	add.l	#432,a1
	Dmove	d_name,a0
	add.l	#1,a0
sstname:
	move.b	(a0)+,(a1)+
sstnam:	move.b	(a0)+,(a1)+
	bne	sstnam
	Mlea	tracks,a1
	bsr	st_checksum
swrroot:
	bsr	stwr
	cmp.l	#0,d7
	bne	sfoend
	Dmove	tracknr,d1
	add.l	#1,d1
	Dsave	d1,tracknr
	bra	sfolop
sfoend:	Rbsr	L_motor
	Rbsr	L_closd
	bra	sfoend3
sfoend2:
	move.l	#-1,d7
sfoend3:
	movem.l	(sp)+,a3-a6
	move.l	d7,d3
	moveq	#0,d2
	rts
st_checksum
	moveq	#$7F,d1
	moveq	#0,d0
	movea.l	a1,a0
	clr.l	$14(a1)
st_chksum
	sub.l	(a0)+,d0
	dbra	d1,st_chksum
	move.l	d0,$14(a1)
	rts
stwr:	Dlea	diskio,a1
	Dlea	msgport,a0
	move.l	a0,14(a1)
	move.w	#11,28(a1)
	Mlea	tracks,a0
	move.l	a0,40(a1)
	Dmove	tracknr,d2
 	mulu.w	#$1600,d2
	move.l	d2,44(a1)
	move.l	#$1600,36(a1)
	move.l	4,a6
	jsr	-456(a6)
	cmp.l	#0,d0
	beq	stwok
	move.l	#-1,d7
stwok:	rts
*******	SQUASH string,richtung,delay
L_squa	equ	111
L111
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,a0
	moveq	#0,d0
	move.w	(a0),d0
	beq	sqend
	cmp.l	#0,d2
	bpl	d4ok
	move.l	#10,d2
d4ok:	Dsave4	d2,d0,d1,a0,timer,len,ri,string
	movem.l	a3-a6,-(sp)
	move.l	DosBase(a5),a6
	Dmove	len,d1
	Rbsr	getmem
	Dmove3	string,var_buffer,len,a0,a1,d0
	move.w	(a0)+,(a1)+
	sub.w	#1,d0
flop:	move.b	(a0)+,(a1)+
	dbra	d0,flop
	Dmove	var_buffer,a1
	add.l	#2,a1
	WiCall	Centre
	movem.l	d0-d7,-(sp)
	Rbsr	tests
	Dmove	timer,d1
	jsr	-198(a6)
	movem.l	(sp)+,d0-d7
	Dmove	ri,d0
	bmi	sq2
	Dmove	len,d0
	move.l	d0,d1
	lsr.l	d0
	lsl.l	d0
	cmp.l	d0,d1
	beq	sqeven
	Dmove2	var_buffer,len,a0,d0
	lsr.l	d0
	add.l	#1,d0
	move.l	a0,-(a3)
	move.l	d0,-(a3)
	move.l	#1,-(a3)
	Rbsr	L_cut
	Dsave	d3,var_buffer
	Dmove	var_buffer,a1
	moveq	#0,d0
	move.w	(a1),d0
	add.l	#2,d0
	move.l	a1,-(a3)
	move.l	d0,-(a3)
	move.l	#0,-(a3)
	Rbsr	L_ext
	Dmove	var_buffer,a1
	add.l	#2,a1
	WiCall	Centre
	Rbsr	tests
	Dmove	timer,d1
	jsr	-198(a6)
sqeven:	Dmove	var_buffer,a0
	move.w	(a0)+,d0
	ext.l	d0
	Dsave	d0,efflen
	lsr.l	d0
	Dsave	d0,pos
sqs:	sub.l	#1,d0
	cmp.l	#0,d0
	beq	vsqready
	Dsave	d0,schl
	Dmove2	pos,var_buffer,d0,a0
	move.l	a0,-(a3)
	move.l	d0,-(a3)
	move.l	#2,-(a3)
	Rbsr	L_cut
	Dmove	efflen,d0
	move.l	d3,-(a3)
	move.l	d0,-(a3)
	move.l	#0,-(a3)
	Rbsr	L_ext
	move.l	d3,a1
	add.l	#2,a1
	WiCall	Centre
	Rbsr	tests
	Dmove	timer,d1
	jsr	-198(a6)
	Dmove	schl,d0
	bra	sqs	
vsqready:
	Dlea	blank2,a1
	WiCall	Centre
sqready:
	movem.l	(sp)+,a3-a6
sqend:	rts
sq2:	Dmove	var_buffer,a0
	add.l	#2,a0
	Dsave	a0,var_buffer
	Dmove	len,d7
	move.l	d7,d1
	lsr.l	d7
	sub.l	#1,d7
	move.l	#0,d0
sq2l:	Dsave	d7,men
	move.b	#' ',(a0,d0)
	add.l	#1,d0
	sub.l	d0,d1
	move.b	#' ',(a0,d1)
	Dmove	var_buffer,a1
	movem.l	a0/d0-d7,-(sp)
	WiCall	Centre
	Rbsr	tests
	Dmove	timer,d1
	jsr	-198(a6)
	movem.l	(sp)+,a0/d0-d7
	Dmove2	len,men,d1,d7
	dbra	d7,sq2l
	Dmove	len,d0
	move.l	d0,d1
	lsr.l	d0
	lsl.l	d0
	cmp.l	d0,d1
	beq	sqready
	lsr.l	d0
	Dmove	var_buffer,a1
	move.b	#' ',(a1,d0)
	WiCall	Centre
	bra	sqready
*******	VIDEO ON
L_scon	equ	112
L112
	move.w	#$81a0,$dff096
	rts
*******	VIDEO OFF
L_scoff	equ	113
L113
scoff:	move.w	#$01a0,$dff096
	move.w	#0,$dff180
	rts
*******	LARGEST CHIP FREE
L_lcf	equ	114
L114
	move.l	#$20002,d1
	Rbra	fcfree
*******	LARGEST FAST FREE
L_lff	equ	115
L115
	move.l	#$20004,d1
	Rbra	fcfree

fcfree	equ	116
L116
	movem.l	a3-a6,-(sp)
	move.l	4,a6
	jsr	-216(a6)
	move.l	d0,d3
	moveq	#0,d2
	movem.l	(sp)+,a3-a6
	rts

*******	FILE SIZE("filename")
L_fsize	equ	117
L117
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	Rbsr	L_examine
	tst.l	d0
	beq	size_err
	Dlea	fib,a0
	move.l	124(a0),d3
size_x	moveq	#0,d2
	movem.l	(sp)+,a3-a6
	rts
size_err
	move.l	#-1,d3
	bra	size_x

*******	FILE TYPE("filename")
L_ftype	equ	118
L118
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	Rbsr	L_examine
	tst.l	d0
	beq	io_err
	Dlea	fib,a0
	move.l	4(a0),d3
io_err	moveq	#0,d2
	movem.l	(sp)+,a3-a6
	rts

*******	PP MEM(end)
L_ppmem	equ	119
L119
	move.l	(a3)+,d0
	subq.l	#4,d0
	movea.l	d0,a0
	move.l	(a0),d0
	andi.l	#$FFFFFF00,d0
	asr.l	#8,d0
	move.l	d0,d3
	moveq	#0,d2
	rts

*******	PP DECRUNCH start,end,destination
L_ppdecrunch	equ	120
L120
	movea.l	(a3)+,a1
	movea.l	(a3)+,a0
	movea.l	(a3)+,a2
	move.l	4(a2),d0
	movem.l	d1-d7/a2-a6,-(sp)
	bsr	decrunch
	movem.l	(sp)+,d1-d7/a2-a6
	rts
decrunch
	lea	lb002E94(pc),a5
	move.l	d0,(a5)
	move.l	a1,a2
	move.l	-(a0),d5
	moveq	#0,d1
	move.b	d5,d1
	lsr.l	#8,d5
	add.l	d5,a1
	move.l	-(a0),d5
	lsr.l	d1,d5
	move.b	#$20,d7
	sub.b	d1,d7
lb002E0E
	bsr	lb002E7A
	tst.b	d1
	bne	lb002E34
	moveq	#0,d2
lb002E16
	moveq	#2,d0
	bsr	lb002E7C
	add.w	d1,d2
	cmp.w	#3,d1
	beq	lb002E16
lb002E22
	move.w	#8,d0
	bsr	lb002E7C
	move.b	d1,-(a1)
	dbra	d2,lb002E22
	cmp.l	a1,a2
	bcs	lb002E34
	rts
lb002E34
	moveq	#2,d0
	bsr	lb002E7C
	moveq	#0,d0
	move.b	0(a5,d1.w),d0
	move.l	d0,d4
	move.w	d1,d2
	addq.w	#1,d2
	cmp.w	#4,d2
	bne	lb002E66
	bsr	lb002E7A
	move.l	d4,d0
	tst.b	d1
	bne	lb002E54
	moveq	#7,d0
lb002E54
	bsr	lb002E7C
	move.w	d1,d3
lb002E58
	moveq	#3,d0
	bsr	lb002E7C
	add.w	d1,d2
	cmp.w	#7,d1
	beq	lb002E58
	bra	lb002E6A
lb002E66
	bsr	lb002E7C
	move.w	d1,d3
lb002E6A
	move.b	0(a1,d3.w),d0
	move.b	d0,-(a1)
	dbra	d2,lb002E6A
	cmp.l	a1,a2
	bcs	lb002E0E
	rts
lb002E7A
	moveq	#1,d0
lb002E7C
	moveq	#0,d1
	subq.w	#1,d0
lb002E80
	lsr.l	#1,d5
	roxl.l	#1,d1
	subq.b	#1,d7
	bne	lb002E8E
	move.b	#$20,d7
	move.l	-(a0),d5
lb002E8E
	dbra	d0,lb002E80
	rts
lb002E94
	movep.w	$B0B(a2),d4
	movem.l	a4-a6,-(sp)
	movea.l	(a3)+,a1
	movea.l	(a3)+,a0
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	a1,a2
	suba.l	a0,a2
	move.b	-(a0),d5
lb002F50
	cmp.l	a1,a0
	beq	lb002F64
	move.b	(a0)+,d5
	cmp.b	(a0),d0
	bne	lb002F50
	move.b	d1,(a0)
	bra	lb002F50
lb002F64
	movem.l	(sp)+,a4-a6
	rts
*******	STREAM$(start,end,LF)
L_stream	equ	121
L121
stream	move.l	(a3)+,d6
	move.l	(a3)+,a1
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	moveq	#0,d7
	cmp.l	a0,a1
	beq	terminate
	move.l	a0,a2
cmplf	move.b	(a2)+,d5
	cmp.b	d6,d5
	beq	foundlf
	add.w	#1,d7
	bra	cmplf
foundlf	move.l	d7,d0
	Rbsr	getmem
	Dmove	var_buffer,a2
	cmp.l	#0,a2
	beq	nolstrmem
	move.w	d7,(a2)+
	sub.w	#1,d7
clstr	move.b	(a0)+,(a2)+
	cmp.l	a0,a1
	beq	endx
	dbra.w	d7,clstr
endx	move.b	#0,(a2)
	Dmove	var_buffer,d3
	moveq	#2,d2
	movem.l	(sp)+,a3-a6
	rts
nolstrmem
	movem.l	(sp)+,a3-a6
	moveq	#24,d0
	Rjmp	L_Error
terminate
	move.w	#4,d0
	Rbsr	getmem
	Dmove	var_buffer,d3
	cmp.l	#0,d3
	beq	nolstrmem
	moveq	#2,d2
	movem.l	(sp)+,a3-a6
	rts
*******	FILE PROCTECTION("filename")
L_fprot	equ	122
L122
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	Rbsr	L_examine
	tst.l	d0
	beq	prot_err
	Dlea	fib,a0
	move.l	116(a0),d3
prot_x	moveq	#0,d2
	movem.l	(sp)+,a3-a6
	rts
prot_err
	move.l	#-1,d3
	bra	prot_x
*******	FILE COMMENT$("filename")
L_fcomm	equ	123
L123
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	Rbsr	L_examine
	tst.l	d0
	beq	comm_err
	Dlea	fib,a0
	add.l	#143,a0
	movem.l	a0,-(sp)
	moveq	#0,d0
comm_x	move.l	#116,d0
	Rbsr	get_mem
	Dmove	var_buffer,a1
	movem.l	(sp)+,a0
	cmp.l	#0,a1
	beq	nocommem
	add.l	#1,a1
	moveq	#0,d0
	move.l	#$ffff,d1
	move.b	#116,d0
	sub.l	#1,d0
comml	move.b	(a0)+,d2
	cmp.b	#0,d2
	beq	commlx
	add.w	#1,d1
	move.b	d2,(a1)+
	dbra	d0,comml
commlx	moveq	#2,d2
	Dmove	var_buffer,a0
	move.w	d1,(a0)
	move.l	a0,d3
	movem.l	(sp)+,a3-a6
	rts
nocommem
	movem.l	(sp)+,a3-a6
	moveq	#24,d0
	Rjmp	L_Error
comm_err
	Dlea	command,a0
	bra	comm_x

L_examine	equ	124
L124
	move.l	dosbase(a5),a6
	move.w	(a0)+,d0
	cmp.w	#0,d0
	bne	no_missing
	moveq	#0,d0
	moveq	#0,d3
	rts
no_missing
	move.l	a0,d1
	move.l	#-2,d2
	jsr	-84(a6)
	tst.l	d0
	bne	lock_found
	moveq	#0,d3
	rts
lock_found
	move.l	d0,d5
	move.l	d0,d1
	Dlea	fib,a0
	move.l	a0,d2
	jsr	-102(a6)
	tst.l	d0
	bne	no_ioerr
	moveq	#0,d3
	rts
no_ioerr
	move.l	d5,d1
	jsr	-90(a6)
	moveq	#1,d0
	rts

*******	SET PROTECTION("filename",bits)
L_sprot	equ	125
L125
	movem.l	(a3)+,d2/a0
	movem.l	a3-a6,-(sp)
	moveq	#0,d3
	move.l	DosBase(a5),a6
	move.w	(a0)+,d1
	beq	sprot_err
	move.l	a0,d1
	jsr	-186(a6)
	move.l	d0,d3
sprot_err
	moveq	#0,d2
	movem.l	(sp)+,a3-a6
	rts
*******	SET COMMENT("filename","comment")
L_scomm	equ	126
L126
	move.l	(a3)+,a1
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	moveq	#0,d3
	move.l	DosBase(a5),a6
	move.w	(a0)+,d1
	beq	scomm_err
	move.w	(a1)+,d1
	beq	scomm_err
	move.l	a0,d1
	move.l	a1,d2
	jsr	-180(a6)
	move.l	d0,d3
scomm_err
	moveq	#0,d2
	movem.l	(sp)+,a3-a6
	rts
*******	DISTANCE(x1,y1 to x2,y2)
L_dist	equ	127
L127
dist:	move.l	(a3)+,d3
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	movem.l	a3-a6,-(sp)
	Rbsr	L_openmt
	cmp.l	#0,a6
	beq	no_math
	sub.l	d1,d3
	sub.l	d0,d2
	move.l	d2,d6
	move.l	d3,d0
	jsr	-36(a5)
	move.l	#$80000042,d1
	jsr	-90(a6)
	move.l	d0,d7
	move.l	d6,d0
	jsr	-36(a5)
	move.l	#$80000042,d1
	jsr	-90(a6)
	move.l	d7,d1
	jsr	-66(a5)
	jsr	-96(a6)
	jsr	-30(a5)
no_math:
	movem.l	(sp)+,a3-a6
	move.l	d0,d3
	moveq	#0,d2
	rts
*******	PI#
L_p	equ	128
L128
	move.l	#$c90fdb42,d3
	moveq	#1,d2
	rts
*******	ARCUS(x1,y1 to x2,y2)
L_arcus	equ	129
L129
	movem.l	(a3)+,d0-d3
	movem.l	a3-a6,-(sp)
	Rbsr	L_openmt
	cmp.l	#0,a6
	beq	no_math2
	sub.l	d1,d3
	sub.l	d0,d2
	cmp.l	#0,d3
	bne	no90
	cmp.l	#0,d2
	bmi	is270
	move.l	#90,d3
	bra	arcexit
is270:	move.l	#270,d3
	bra	arcexit
no90:	move.l	#180,d7
	cmp.l	#0,d3
	bpl	lower
	move.l	#0,d7
lower:	move.l	d2,d0
	jsr	-36(a5)
	move.l	d0,d6
	move.l	d3,d0
	jsr	-36(a5)
	move.l	d0,d1
	move.l	d6,d0
	jsr	-84(a5)
	jsr	-30(a6)
	move.l	#$e52f1a46,d1
	jsr	-78(a5)
	jsr	-30(a5)
	move.l	d0,d3
	cmp.l	#0,d3
	bpl	noarcadd
	add.l	#360,d3
noarcadd:
	add.l	d7,d3
	cmp.l	#360,d3
	bmi	arcexit
	sub.l	#360,d3
arcexit	movem.l	(sp)+,a3-a6
	moveq	#0,d2
	rts
no_math2:
	movem.l	(sp)+,a3-a6
	move.l	d0,d3
	moveq	#0,d2
	rts
*******	TIMESECS("hh:mm:ss")
L_tts	equ	130
L130
tts:	move.l	(a3)+,a0
	moveq	#0,d0
	moveq	#0,d1
	move.w	(a0)+,d0
	cmp.w	#8,d0
	bne	ttserr
	move.b	(a0)+,d0
	sub.b	#'0',d0
	mulu	#10,d0
	move.b	(a0)+,d1
	sub.b	#'0',d1
	add.b	d1,d0
	mulu	#3600,d0
	move.l	d0,d3
	add.l	#1,a0
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a0)+,d0
	sub.b	#'0',d0
	mulu	#10,d0
	move.b	(a0)+,d1
	sub.b	#'0',d1
	add.b	d1,d0
	mulu	#60,d0
	add.l	d0,d3
	add.l	#1,a0
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a0)+,d0
	sub.b	#'0',d0
	mulu	#10,d0
	move.b	(a0)+,d1
	sub.b	#'0',d1
	add.b	d1,d0
	add.l	d0,d3
ttsex:	moveq	#0,d2
	rts
ttserr:	move.l	#0,d3
	bra	ttsex
*******	SECSTIME$(seconds)
L_stt	equ	131
L131
stt:	move.l	(a3)+,d0
	move.l	d0,d7
	divu	#3600,d0
	move.l	d0,d6
	move.l	d7,d0
	move.l	d6,d1
	mulu	#3600,d1
	sub.l	d1,d0
	move.l	d0,d7
	divu	#60,d0
	move.l	d0,d5
	mulu	#60,d0
	sub.l	d0,d7
	move.l	#8,d0
	Rbsr	get_mem
	Dmove	var_buffer,a0
	move.l	#0,(a0)
	move.w	#8,(a0)+
	move.l	d6,d0
	ext.l	d0
	bsr	s_bin_to_dec
	Dmove	var_buffer,a0
	add.l	#3,a0
	cmp.b	#0,(a0)
	bne	len2
	move.b	-(a0),d0
	move.b	#'0',(a0)+
	move.b	d0,(a0)
len2:	add.l	#1,a0
	move.b	#':',(a0)+
	move.l	d5,d0
	ext.l	d0
	bsr	s_bin_to_dec
	Dmove	var_buffer,a0
	add.l	#6,a0
	cmp.b	#0,(a0)
	bne	len2b
	move.b	-(a0),d0
	move.b	#'0',(a0)+
	move.b	d0,(a0)
len2b:	add.l	#1,a0
	move.b	#':',(a0)+
	move.l	d7,d0
	ext.l	d0
	bsr	s_bin_to_dec
	Dmove	var_buffer,a0
	add.l	#9,a0
	cmp.b	#0,(a0)
	bne	len2c
	move.b	-(a0),d0
	move.b	#'0',(a0)+
	move.b	d0,(a0)
len2c:	add.l	#1,a0
	Dmove	var_buffer,d3
	moveq	#2,d2
	rts
s_bin_to_dec:
	ext.l	d0
	tst.l	d0
	beq	s_bin_dec6
	neg.l	d0
	Dlea	decathlon,a1
	clr.w	d1
s_bin_dec3:
	move.l	(a1)+,d2
	beq	s_bin_dec6
	moveq	#-1,d4
s_bin_dec4:
	add.l	d2,d0
	dbgt	d4,s_bin_dec4
	sub.l	d2,d0
	addq.w	#1,d4
	bne	s_bin_dec5
	tst.w	d1
	beq	s_bin_dec3
s_bin_dec5:
	moveq	#-1,d1
	neg.b	d4
	addi.b	#$30,d4
	move.b	d4,(a0)+
	bra	s_bin_dec3
s_bin_dec6:
	neg.b	d0
	addi.b	#$30,d0
	move.b	d0,(a0)+
	add.l	#2,a2
	rts
*******	X Pos(x,y,r,w)
L_xpo	equ	132
L132
xpo:	movem.l	(a3)+,d0-d3
	move.l	d1,d7
	movem.l	a3-a6,-(sp)
	Rbsr	L_openmt
	cmp.l	#0,a6
	beq	xno_math
	jsr	-36(a5)		;w->float
	move.l	#$8efa343b,d1	;degree -> radian
	jsr	-78(a5)
	jsr	-42(a6)		;cos(w)
	move.l	d0,d4
	move.l	d7,d0
	jsr	-36(a5)		;r->float
	move.l	d4,d1
	jsr	-78(a5)		;r*cos(w)
	jsr	-30(a5)		;->int
	add.l	d3,d0		;+x
xno_math:
	movem.l	(sp)+,a3-a6
	move.l	d0,d3
	moveq	#0,d2
	rts
*******	Y Pos(x,y,r,w)
L_ypo	equ	133
L133
ypo:	movem.l	(a3)+,d0-d3
	move.l	d1,d7
	movem.l	a3-a6,-(sp)
	Rbsr	L_openmt
	cmp.l	#0,a6
	beq	yno_math
	jsr	-36(a5)		;w->float
	move.l	#$8efa343b,d1
	jsr	-78(a5)
	jsr	-36(a6)		;sin(w)
	move.l	d0,d4
	move.l	d7,d0
	jsr	-36(a5)		;r->float
	move.l	d4,d1
	jsr	-78(a5)		;r*sin(w)
	jsr	-30(a5)		;->int
	add.l	d2,d0		;+y
yno_math:
	movem.l	(sp)+,a3-a6
	move.l	d0,d3
	moveq	#0,d2
	rts
*******	FLUSH
L_flush	equ	134
L134
	movem.l		a6,-(sp)
	move.l		4,a6
	moveq		#0,d1
	move.l		#99999999,d0
	jsr		-198(a6)
	move.l		d0,a0
	beq.s		.134
	jsr		-210(a6)
.134
	movem.l		(sp)+,a6
	rts
tests	equ	135
L135
	movem.l	a0-a6/d0-d7,-(sp)
	Rjsr	L_tests
	movem.l	(sp)+,a0-a6/d0-d7
	rts
*******	COUNT DIRS(pfad$)
L_countdirs	equ	136
L136
	moveq	#0,d7
	Rbsr	fdcount
	move.l	d7,d3
	sub.l	#1,d3
	rts
*******	COUNT FILES(pfad$)
L_countfiles	equ	137
L137
	moveq	#0,d6
	Rbsr	fdcount
	move.l	d6,d3
	rts
fdcount	equ	138
L138
	movem.l	a3-a6,-(sp)
	move.l	DosBase(a5),a6
	move.l	(a3)+,a0
	add.l	#2,a0
	move.l	a0,d1
	move.l	#-2,d2
	jsr	-84(a6)		;lock
	tst.l	d0
	beq	fertig
	move.l	d0,d5
	move.l	d5,d1
	Dlea	fib,d2
	jsr	-102(a6)	;examine
	tst.l	d0
	beq	fertig
	bsr	zaehl
loop	move.l	d5,d1
	Dlea	fib,d2
	jsr	-108(a6)	;exnext
	tst.l	d0
	beq	fertig
	bsr	zaehl
	bra	loop
fertig	jsr	-132(a6)	;ioerr
	moveq	#0,d2
	movem.l	(sp)+,a3-a6
	rts
zaehl	Dlea	fib,a0
	move.l	4(a0),d0
	cmp.l	#0,d0
	bmi	nocount
	add.l	#1,d7
	rts
nocount	add.l	#1,d6
	rts
*******	DETAB(string,tabsize)
L_detab	equ	139
L139
detab:	movem.l	a3-a6,-(sp)
	Rbsr	uninit
	movem.l	(sp)+,a3-a6
	move.l	(a3)+,d7
	cmp.l	#1,d7
	bge	det
	move.l	#3,d7
det:	move.l	(a3)+,a0
	move.w	(a0)+,d0
	cmp.w	#0,d0
	beq	no_para
	Mlea	p1_jbuffer,a1
	add.l	#2,a1
	moveq	#0,d1
detabl:	move.b	(a0)+,d2
	cmp.b	#9,d2
	beq	is_tab
	cmp.b	#0,d2
	beq	detend
	add.w	#1,d1
	move.b	d2,(a1)+
	dbra	d0,detabl
is_tab:	move.w	d1,d3
	add.w	#1,d3
	move.l	d3,d4
	divu	d7,d4
	mulu	d7,d4
	sub.w	d4,d3
	move.w	d7,d6
	sub.w	d3,d6
	move.w	d6,d3

	cmp.w	d3,d7
	bgt	contab
	sub.w	d7,d3

contab:	move.b	#' ',(a1)+
	add.w	#1,d1
	dbra	d3,contab
	dbra	d0,detabl
no_para	Dlea	leer,d3
np2:	Rbsr	err_get
	moveq	#2,d2
	rts
detend:
	move.b	#0,(a1)+
	Mlea	p1_jbuffer,a0
	move.w	d1,(a0)
	move.w	d1,d0
	Rbsr	getmem
	cmp.l	#0,d0
	bne	detabok
	Mlea	p1_jbuffer,a0
	move.l	a0,d3
	bra	np2
detabok	Dmove	var_buffer,a1
	Mlea	p1_jbuffer,a0
	move.w	(a0)+,d0
	move.w	d0,(a1)+
	sub.w	#1,d0
detcop:	move.b	(a0)+,(a1)+
	dbra	d0,detcop
	move.b	#0,(a1)+
	Dmove	var_buffer,d3
	moveq	#2,d2
	rts
*******	GET TAB
L_gtab	equ	140
L140
gtab:	moveq	#0,d3
	moveq	#0,d2
	move.w	$400(a5),d3
	rts
*******	MOFF CLICK
L_mclick	equ	141
L141
	moveq	#0,d2
	btst	#6,$bfe001
	beq	lclick
	btst	#2,$dff016
	beq	rclick
	move.l	#0,d3
	rts
lclick:	move.l	#1,d3
	btst	#2,$dff016
	bne	lclick2
	move.l	#3,d3
lclick2:
	rts
rclick:	move.l	#2,d3
	rts
*******	MOFF KEY
L_mkey	equ	142
L142
	moveq	#0,d2
	move.l	#0,d3
	move.b	$bfec01,d3
mkeyl	move.b	$bfec01,d0
	cmp.b	d3,d0
	beq	mkeyl
	move.b	#0,$bfec01
	lsr.b	#1,d3
	rts
*******	MULTI OFF
L_moff	equ	143
L143
	movem.l	a3-a6,-(sp)
	move.l	4,a6
	jsr	-132(a6)
	movem.l	(sp)+,a3-a6
	rts
*******	MULTI ON
L_mon	equ	144
L144
	movem.l	a3-a6,-(sp)
	move.l	4,a6
	jsr	-138(a6)
	movem.l	(sp)+,a3-a6
	rts
*******	DOUBLE CLICK
L_dclick	equ	145
L145
	moveq	#0,d2
	move.l	#0,d3
	btst	#6,$bfe001
	bne	other_mouse
dmouse	btst	#6,$bfe001
	beq	dmouse
	move.l	#3,d1
here1	move.l	#-1,d0
dmouse2	btst	#6,$bfe001
	beq	hok1
	dbra	d0,dmouse2
	dbra	d1,here1
	bra	hok2
hok1	move.l	#1,d3
hok2	rts
other_mouse:
	btst	#2,$dff016
	bne	exit_mouse
dmouse3	btst	#2,$dff016
	beq	dmouse3
	move.l	#3,d1
here2	move.l	#-1,d0
dmouse4	btst	#2,$dff016
	beq	hok3
	dbra	d0,dmouse4
	dbra	d1,here2
	bra	exit_mouse
hok3	move.l	#2,d3
exit_mouse:
	rts
*******	DLED OFF
L_dledoff	equ	146
L146
	move.b	#127,$bfd100
	move.b	#119,$bfd100
	move.b	#255,$bfd100+512
	rts
*******	DLED OFF
L_dledon	equ	147
L147
	move.b	#127,$bfd100
	move.b	#119,$bfd100
	move.b	#0,$bfd100+512
	rts
*******	REDUCE DIM array,newdim
L_reddim	equ	148
L148
	move.l	(a3)+,d0
	move.l	(a3)+,a0
	add.l	#2,a0
	move.w	(a0),d1
	cmp.w	d1,d0
	bge	red_err
	move.w	d0,(a0)
	sub.l	#2,a0
	Dlea	dimlist,a1
	Dlea	dimendlist,a2
dll:	cmp.l	#0,(a1)
	bne	notlast
	move.l	a0,(a1)+
	move.w	d1,(a1)
red_err	rts
notlast	add.l	#6,a1
	cmp.l	a1,a2
	Rbeq	L_outdim
	bra	dll
*******	RESET DIM array
L_resdim	equ	149
L149
	move.l	(a3)+,a0
	movem.l	a3-a6,-(sp)
	Dlea	dimlist,a1
	Dlea	dimendlist,a2
dll2:	move.l	(a1)+,a3
	cmp.l	a0,a3
	bne	notlast2
	move.w	(a1)+,d0
	add.l	#2,a0
	move.w	d0,(a0)
	movem.l	(sp)+,a3-a6
	rts
notlast2:
	add.l	#2,a1
	cmp.l	a2,a1
	Rbeq	L_outdim
	bra	dll2
L_outdim	equ	150
L150
	moveq	#23,d0
	Rjmp	L_Error
*******	ARRAY SWAP array,nr.1,nr2
L_aswap	equ	151
L151
	move.l	(a3)+,d0
	move.l	(a3)+,d1
	move.l	(a3)+,a0
	move.w	2(a0),d2
	cmp.w	d2,d0
	Rbge	L_outdim
	cmp.w	d2,d1
	Rbge	L_outdim
	add.l	#6,a0
	lsl.l	#2,d0
	lsl.l	#2,d1
	lea	(a0,d0.l),a1
	lea	(a0,d1.l),a2
	move.l	(a1),d1
	move.l	(a2),d2
	move.l	d1,(a2)
	move.l	d2,(a1)
	rts	
*******	ARRAY$ CLEAR array
L_aclear	equ	152
L152
	move.l	(a3)+,a0
	move.w	2(a0),d0
	add.l	#6,a0
	movem.l	d0/a0,-(sp)
	move.w	#4,d0
	Rbsr	getmem
	movem.l	(sp)+,d0/a0
	Dmove	var_buffer,a1
acl:	move.l	a1,(a0)+
	dbra	d0,acl
	rts
*******	ARRAY CLEAR array
L_aclear2	equ	153
L153
	move.l	(a3)+,a0
	move.w	2(a0),d0
	add.l	#6,a0
acl2:	move.l	#0,(a0)+
	dbra	d0,acl2
	rts
*******	DRAW SEGMENT x,y,xradius,yradius,startwinkel,endwinkel
L_drawseg	equ	154
L154
segm:	move.l	T_RastPort(a5),d0
	lea	_rastport(pc),a0
	move.l	d0,(a0)
	move.l	ScOnAd(a5),a0
	lea	_sx(pc),a1
	move.w	$4c(a0),(a1)+
	move.w	$4e(a0),(a1)
	lea	EcCurrent(a0),a0
	move.l	4(a0),a0
	move.l	FloatBase(a5),a1
	movem.l	(a3)+,d1-d6
	bsr	testwinkel
	movem.l	a3-a6,-(sp)
	movem.l	a0-a1,-(sp)
	lea	sprungtab(pc),a1
	lea	s1e1(pc),a0
	move.l	a0,(a1)+
	lea	s1e2(pc),a0
	move.l	a0,(a1)+
	lea	s1e3(pc),a0
	move.l	a0,(a1)+
	lea	s1e4(pc),a0
	move.l	a0,(a1)+
	lea	s2e1(pc),a0
	move.l	a0,(a1)+
	lea	s2e2(pc),a0
	move.l	a0,(a1)+
	lea	s2e3(pc),a0
	move.l	a0,(a1)+
	lea	s2e4(pc),a0
	move.l	a0,(a1)+
	lea	s3e1(pc),a0
	move.l	a0,(a1)+
	lea	s3e2(pc),a0
	move.l	a0,(a1)+
	lea	s3e3(pc),a0
	move.l	a0,(a1)+
	lea	s3e4(pc),a0
	move.l	a0,(a1)+
	lea	s4e1(pc),a0
	move.l	a0,(a1)+
	lea	s4e2(pc),a0
	move.l	a0,(a1)+
	lea	s4e3(pc),a0
	move.l	a0,(a1)+
	lea	s4e4(pc),a0
	move.l	a0,(a1)+
	movem.l	(sp)+,a0-a1
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	_sx(pc),d0
	move.w	_sy(pc),d1
	sub.w	#1,d0
	sub.w	#1,d1
	lea	_x1+2(pc),a0
	move.w	d0,(a0)
	lea	_x2+2(pc),a0
	move.w	d0,(a0)
	lea	_x3+2(pc),a0
	move.w	d0,(a0)
	lea	_x4+2(pc),a0
	move.w	d0,(a0)
	lea	_y1+2(pc),a0
	move.w	d1,(a0)
	lea	_y2+2(pc),a0
	move.w	d1,(a0)
	lea	_y3+2(pc),a0
	move.w	d1,(a0)
	lea	_y4+2(pc),a0
	move.w	d1,(a0)
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	a0,a4
	lea	_mathbase(pc),a0
	move.l	a1,(a0)+
	move.l	d2,(a0)+
	move.l	d1,(a0)+
	move.l	d4,(a0)+
	move.l	d3,(a0)+
	move.l	d6,(a0)+
	move.l	d5,(a0)+
segdo:	movem.l	d0-d7/a0-a6,-(sp)
	lea	ffpname(pc),a1
	move.l	4,a6
	jsr	-408(a6)
	lea	_mathbase(pc),a0
	move.l	d0,(a0)
	lea	_gfxname(pc),a1
	move.l	4,a6
	jsr	-408(a6)
	lea	_gfxbase(pc),a0
	move.l	d0,(a0)
	movem.l	(sp)+,d0-d7/a0-a6
	movem.l	a0,-(sp)
	move.l	_mathbase(pc),a6
	move.l	startwinkel(pc),d0
	jsr	-36(a6)
	move.l	#$8EFA343B,d1
	jsr	-78(a6)
	lea	startwinkel(pc),a0
	move.l	d0,(a0)
	move.l	endwinkel(pc),d0
	jsr	-36(a6)
	move.l	#$8EFA343B,d1
	jsr	-78(a6)
	lea	endwinkel(pc),a0
	move.l	d0,(a0)
	movem.l	(sp)+,a0
	move.l	xradius(pc),d7
	move.l	yradius(pc),d6
	move.l	xkoord(pc),d5
	move.l	ykoord(pc),d4
	move.l	startwinkel(pc),d2
	move.l	endwinkel(pc),d3
	bsr	ellipse
	movem.l	(sp)+,a3-a6
	lea	_mathbase(pc),a0
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	move.l	#0,(a0)+
	lea	austab1(pc),a0
	move.l	#391,d0
lbunlop	move.l	#0,(a0)+
	dbra	d0,lbunlop
	rts
ellipse	move.l	startwinkel(pc),d2
	move.l	endwinkel(pc),d3
	move.l	ykoord(pc),d4
	move.l	xkoord(pc),d5
	move.l	yradius(pc),d6
	move.l	xradius(pc),d7
	move.l	d2,d0
	bsr	winkel
	Bsave	d2,startqua
	Wsave	d0,startpunkt
	move.l	d3,d0
	bsr	winkel
	Bsave	d2,endqua
	Wsave	d0,endpunkt
	move.b	startqua(pc),d0
	cmpi.b	#1,d0
	bne	ausschnitt
	move.w	startpunkt(pc),d0
	bne	ausschnitt
	move.b	endqua(pc),d0
	cmpi.b	#4,d0
	bne	ausschnitt
	move.w	endpunkt(pc),d0
	cmpi.w	#390,d0
	bne	ausschnitt

	move.w	#391,d3
	move.w	#1,d2
	lea	cos-1(pc),a5
	lea	bittab(pc),a2
elloop	moveq	#0,d0
	moveq	#0,d1
	move.b	0(a5,d3.w),d0
	mulu	d7,d0
	divu	#255,d0
	Wsave	d0,xoff
	move.b	0(a5,d2.w),d1
	mulu	d6,d1
	divu	#255,d1
	Wsave	d1,yoff
	add.w	d5,d0
	Wsave	d0,xkoord
_x1	cmpi.w	#639,d0
	bge	notpunkt1
	add.w	d4,d1
	Wsave	d1,ykoord
_y1	cmpi.w	#255,d1
	bge	notpunkt1
	bsr	plot
notpunkt1	move.w	xkoord(pc),d0
_x2	cmpi.w	#639,d0
	bge	notpunkt2
	move.w	d4,d1
	sub.w	yoff(pc),d1
	Wsave	d1,ykoord1
	cmp.w	#0,d1
	blt	notpunkt2
	bsr	plot
notpunkt2	move.w	d5,d0
	sub.w	xoff(pc),d0
	Wsave	d0,xkoord1
	cmp.w	#0,d0
	blt	notpunkt3
	move.w	ykoord(pc),d1
_y2	cmpi.w	#255,d1
	bge	notpunkt3
	bsr	plot
notpunkt3	move.w	xkoord1(pc),d0
	blt	notpunkt4
	move.w	ykoord1(pc),d1
	blt	notpunkt4
	bsr	plot
notpunkt4	addq.w	#1,d2
	subq.w	#1,d3
	bne	elloop
	rts
ausschnitt	move.l	#391,d0
	moveq.l	#1,d1
	moveq	#0,d2
	lea	cos-1(pc),a2
	lea	austab1(pc),a5
	lea	austab2(pc),a6
ausloop1	moveq	#0,d3
	move.b	0(a2,d0.w),d3
	mulu	d7,d3
	divu	#255,d3
	move.w	d3,0(a5,d2.w)
	moveq	#0,d3
	move.b	0(a2,d1.w),d3
	mulu	d6,d3
	divu	#255,d3
	move.w	d3,0(a6,d2.w)
	addq.w	#1,d1
	addq.w	#2,d2
	subq.w	#1,d0
	bne	ausloop1
	lea	bittab(pc),a2
	move.w	endpunkt(pc),d0
	cmpi.w	#1,d0
	bhi	weiter1
	Wsave	#2,endpunkt
weiter1	moveq	#0,d0
	moveq	#0,d1
	move.b	startqua(pc),d0
	subi.b	#1,d0
	mulu	#16,d0
	move.b	endqua(pc),d1
	subi.b	#1,d1
	mulu	#4,d1
	add.b	d1,d0
	lea	sprungtab(pc),a0
	add.l	a0,d0
	move.l	d0,a0
	move.l	(a0),a0
	jmp	(a0)
	nop
s1e1	move.w	startpunkt(pc),d0
	cmp.w	endpunkt(pc),d0
	blt	s1e11
	move.w	#391,d1
	bsr	erster
	move.w	#1,d0
	bra	s2e11
s1e11	move.w	endpunkt(pc),d1
	bra	erster
s1e2	move.w	startpunkt(pc),d0
s1e22	move.w	#391,d1
	bsr	erster
	move.w	#1,d0
	move.w	endpunkt(pc),d1
	bra	zweiter
s1e3	move.w	startpunkt(pc),d0
s1e333	move.w	#391,d1
	bsr	erster
	move.w	#1,d0
s1e33	move.w	#391,d1
	bsr	zweiter
	move.w	#1,d0
	move.w	endpunkt(pc),d1
	bra	dritter
s1e4	move.w	startpunkt(pc),d0
s1e4444	move.w	#391,d1
	bsr	erster
	move.w	#1,d0
s1e44	move.w	#391,d1
	bsr	zweiter
	move.w	#1,d0
s1e444	move.w	#391,d1
	bsr	dritter
	move.w	#1,d0
	move.w	endpunkt(pc),d1
	bra	vierter
s2e1	move.w	startpunkt(pc),d0
s2e11	move.w	#391,d1
	bsr	zweiter
	move.w	#1,d0
s2e111	move.w	#391,d1
	bsr	dritter
	move.w	#1,d0
s2e1111	move.w	#391,d1
	bsr	vierter
	move.w	#1,d0
	move.w	endpunkt(pc),d1
	bra	erster
s2e2	move.w	startpunkt(pc),d0
	cmp.w	endpunkt(pc),d0
	blt	s2e22
	move.w	#391,d1
	bsr	zweiter
	move.w	#1,d0
	bra	s3e22
s2e22	move.w	endpunkt(pc),d1
	bra	zweiter
s2e3	move.w	startpunkt(pc),d0
	bra	s1e33
s2e4	move.w	startpunkt(pc),d0
	bra	s1e44
s3e1	move.w	startpunkt(pc),d0
	bra	s2e111
s3e2	move.w	startpunkt(pc),d0
s3e22	move.w	#391,d1
	bsr	dritter
	move.w	#1,d0
s3e222	move.w	#391,d1
	bsr	vierter
	move.w	#1,d0
	bra	s1e22
s3e3	move.w	startpunkt(pc),d0
	cmp.w	endpunkt(pc),d0
	blt	s3e33
	move.w	#391,d1
	bsr	dritter
	move.w	#1,d0
	bra	s4e33
s3e33	move.w	endpunkt(pc),d1
	bra	dritter
s3e4	move.w	startpunkt(pc),d0
	bra	s1e444
s4e1	move.w	startpunkt(pc),d0
	bra	s2e1111
s4e2	move.w	startpunkt(pc),d0
	bra	s3e222
s4e3	move.w	startpunkt(pc),d0
s4e33	move.w	#391,d1
	bsr	vierter
	move.w	#1,d0
	bra	s1e333
s4e4	move.w	startpunkt(pc),d0
	cmp.w	endpunkt(pc),d0
	blt	s4e44
	move.w	#391,d1
	bsr	vierter
	move.w	#1,d0
	bra	s1e4444
s4e44	move.w	endpunkt(pc),d1
	bra	vierter
erster	move.w	#391,d2
	sub.w	d0,d2
	Wsave	d2,zaehl1
	move.w	#391,d2
	sub.w	d1,d2
	Wsave	d2,zaehl2
loopq1	move.w	zaehl2(pc),d2
	lsl	#1,d2
	move.w	0(a5,d2.w),d0
	add.w	d5,d0
_x3	cmpi.w	#639,d0
	bge	noeins
	move.w	0(a6,d2.w),d3
	move.w	d4,d1
	sub.w	d3,d1
	blt	noeins
	bsr	plot
noeins	movem.l	a0,-(sp)
	lea	zaehl2(pc),a0
	add.w	#1,(a0)
	movem.l	(sp)+,a0
	move.w	zaehl1(pc),d0
	cmp.w	zaehl2(pc),d0
	bne	loopq1
	rts
zweiter	Wsave2	d1,d0,zaehl1,zaehl2
loopq2	move.w	zaehl2(pc),d2
	lsl	#1,d2
	move.w	0(a5,d2.w),d0
	add.w	d5,d0
_x4	cmpi.w	#639,d0
	bge	nozwei
	move.w	0(a6,d2.w),d1
	add.w	d4,d1
_y3	cmpi.w	#255,d1
	bge	nozwei
	bsr	plot
nozwei	movem.l	a0,-(sp)
	lea	zaehl2(pc),a0
	addq.w	#1,(a0)
	movem.l	(sp)+,a0
	move.w	zaehl1(pc),d0
	cmp.w	zaehl2(pc),d0
	bne	loopq2
	rts
dritter	move.w	#391,d2
	sub.w	d0,d2
	Wsave	d2,zaehl1
	move.w	#391,d2
	sub.w	d1,d2
	Wsave	d2,zaehl2
loopq3	move.w	zaehl2(pc),d2
	lsl	#1,d2
	move.w	0(a5,d2.w),d3
	move.w	d5,d0
	sub.w	d3,d0
	blt	nodrei
	move.w	0(a6,d2.w),d1
	add.w	d4,d1
_y4	cmpi.w	#255,d1
	bge	nodrei
	bsr	plot
nodrei	movem.l	a0,-(sp)
	lea	zaehl2(pc),a0
	addq.w	#1,(a0)
	movem.l	(sp)+,a0
	move.w	zaehl1(pc),d0
	cmp.w	zaehl2(pc),d0
	bne	loopq3
	rts
vierter	Wsave2	d1,d0,zaehl1,zaehl2
loopq4	move.w	zaehl2(pc),d2
	lsl	#1,d2
	move.w	0(a5,d2.w),d3
	move.w	d5,d0
	sub.w	d3,d0
	blt	novier
	move.w	0(a6,d2.w),d3
	move.w	d4,d1
	sub.w	d3,d1
	blt	novier
	bsr	plot
novier	movem.l	a0,-(sp)
	lea	zaehl2(pc),a0
	addq.w	#1,(a0)
	movem.l	(sp)+,a0
	move.w	zaehl1(pc),d0
	cmp.w	zaehl2(pc),d0
	bne	loopq4
	rts
winkel	move.l	d0,a5
	move.l	#$80000043,d1
	move.l	_mathbase(pc),a6
	jsr	-78(a6)
	move.l	#$C90FDA43,d1
	jsr	-84(a6)
	jsr	-30(a6)
	move.l	d0,a3
	addi.b	#1,d0
	move.b	d0,d2
	move.l	a3,d0
	jsr	-36(a6)
	move.l	#$C90FDA41,d1
	jsr	-78(a6)
	move.l	d0,d1
	move.l	a5,d0
	jsr	-72(a6)
	move.l	#$C3800049,d1
	jsr	-78(a6)
	move.l	#$C90FDA41,d1
	jsr	-84(a6)
	jsr	-30(a6)
	rts
plot	movem.l	d0-d7/a0-a6,-(sp)
	ext.l	d0
	ext.l	d1
	move.l	_rastport(pc),a1
	movem.l	d0-d1/a1,-(sp)
	move.l	_gfxbase(pc),a6
	jsr	-324(a6)
	movem.l	(sp)+,d0-d1/a1
	jsr	-240(a6)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
testwinkel:
	cmp.l	#0,d1
	bmi	add360
	cmp.l	#360,d1
	bgt	sub360
	cmp.l	#0,d2
	bmi	add3602
	cmp.l	#360,d2
	bgt	sub3602
	rts
add360	add.l	#360,d1
	bra	testwinkel
add3602	add.l	#360,d2
	bra	testwinkel
sub360	sub.l	#360,d1
	bra	testwinkel
sub3602	sub.l	#360,d2
	bra	testwinkel
_rastport
	dc.l	0
_gfxbase
	dc.l	0
_gfxname
	dc.b	'graphics.library',0
	even
sprungtab
	dc.l	0,0,0,0
	dc.l	0,0,0,0
	dc.l	0,0,0,0
	dc.l	0,0,0,0
ffpname:
	dc.b	'mathffp.library',0
	even
_sx	dc.w	0
_sy	dc.w	0
_mathbase
	dc.l	0
startwinkel
	dc.l	0
endwinkel
	dc.l	0
xradius	dc.l	0
yradius	dc.l	0
xkoord	dc.l	0
ykoord	dc.l	0
xkoord1	dc.l	0
ykoord1	dc.l	0
xoff	dc.l	0
yoff	dc.l	0
startqua
	dc.l	0
endqua	dc.l	0
startpunkt
	dc.l	0
endpunkt
	dc.l	0
zaehl1	dc.l	0
zaehl2	dc.l	0
	cnop	0,4
cos	dc.b	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,$10,$11,$12,$13
	dc.b	$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$20,$21,$22,$23,$24,$25,$26,$27
	dc.b	$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B
	dc.b	$3C,$3D,$3E,$3F,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F
	dc.b	$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$5B,$5C,$5D,$5E,$5E,$5F,$60,$61,$62
	dc.b	$63,$64,$65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6D,$6E,$6F,$70,$71,$72,$73,$74,$75
	dc.b	$76,$77,$78,$78,$79,$7A,$7B,$7C,$7D,$7E,$7F,$80,$80,$81,$82,$83,$84,$85,$86,$87
	dc.b	$87,$88,$89,$8A,$8B,$8C,$8D,$8D,$8E,$8F,$90,$91,$92,$93,$93,$94,$95,$96,$97,$98
	dc.b	$98,$99,$9A,$9B,$9C,$9C,$9D,$9E,$9F,$A0,$A0,$A1,$A2,$A3,$A4,$A4,$A5,$A6,$A7,$A7
	dc.b	$A8,$A9,$AA,$AB,$AB,$AC,$AD,$AE,$AE,$AF,$B0,$B1,$B1,$B2,$B3,$B3,$B4,$B5,$B6,$B6
	dc.b	$B7,$B8,$B8,$B9,$BA,$BB,$BB,$BC,$BD,$BD,$BE,$BF,$BF,$C0,$C1,$C1,$C2,$C3,$C3,$C4
	dc.b	$C5,$C5,$C6,$C7,$C7,$C8,$C8,$C9,$CA,$CA,$CB,$CC,$CC,$CD,$CD,$CE,$CF,$CF,$D0,$D0
	dc.b	$D1,$D2,$D2,$D3,$D3,$D4,$D4,$D5,$D6,$D6,$D7,$D7,$D8,$D8,$D9,$D9,$DA,$DA,$DB,$DB
	dc.b	$DC,$DD,$DD,$DE,$DE,$DF,$DF,$E0,$E0,$E0,$E1,$E1,$E2,$E2,$E3,$E3,$E4,$E4,$E5,$E5
	dc.b	$E6,$E6,$E6,$E7,$E7,$E8,$E8,$E9,$E9,$E9,$EA,$EA,$EB,$EB,$EB,$EC,$EC,$ED,$ED,$ED
	dc.b	$EE,$EE,$EE,$EF,$EF,$EF,$F0,$F0,$F0,$F1,$F1,$F1,$F2,$F2,$F2,$F3,$F3,$F3,$F4,$F4
	dc.b	$F4,$F4,$F5,$F5,$F5,$F6,$F6,$F6,$F6,$F7,$F7,$F7,$F7,$F8,$F8,$F8,$F8,$F9,$F9,$F9
	dc.b	$F9,$F9,$FA,$FA,$FA,$FA,$FA,$FB,$FB,$FB,$FB,$FB,$FB,$FC,$FC,$FC,$FC,$FC,$FC,$FC
	dc.b	$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
	dc.b	$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
	cnop	0,4
bittab	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	dc.b	$80,$40,$20,$10,8,4,2,1,$80,$40,$20,$10,8,4,2,1
	cnop	0,4
austab1	ds.w	392
austab2	ds.w	392
	dc.l	0
*******	error routines
L155
L156

L157

******* TITLE MESSAGE
C_Title:
	dc.b	"AMOSPro JD_Extension V "
	Version
	dc.b	0,"$VER: "
	Version
	dc.b	0
	even

******* END OF THE EXTENSION
C_End:	dc.w	0
	even
	
