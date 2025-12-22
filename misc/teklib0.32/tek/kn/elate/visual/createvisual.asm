
	.include 'taort'
	.include 'ave/toolkit/toolkit.inc'
	.include 'lib/tek/kn/elate/visual.inc'

	.include 'ave/font/style.inc'
	.include 'ave/font/enumerate.inc'

;=============================================================================
;-----------------------------------------------------------------------------
; 
;	TEKlib
;	(C) 1999-2001 TEK neoscientists
;	all rights reserved.
;
;	TAPTR kn_createvisual(TAPTR mmu)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/createvisual',VP,0

;-----------------------------------------------------------------------------

FONTHEIGHT	= 15

;-----------------------------------------------------------------------------

	ent p0 : p0

	defbegin
	defp mmu
	defp fontman,fontdes,font,title
	defi width,height,backcol,tok
	defi index,temp

	defp visual,buffer,buffer2,ave,app,tkit,prp,win,cnt,layout,scrollpane,pixmap

		cpy.i	0,backcol
		cpy.i	500,width
		cpy.i	500,height

		cpy.p	appname,title


		;	alloc buffers.
		
		qcall	lib/malloc,(vis_size:visual)
		bcn	visual eq 0,_cw_exit
		
		qcall	lib/memset,(visual,0,vis_size:p~)

		qcall	lib/malloc,(width*height*4:buffer)
		bcn	buffer eq 0,_cw_fail
		qcall	lib/memseti,(buffer,backcol,width*height*4:p~)
		cpy.p	buffer,[visual+vis_buffer]

		qcall	lib/malloc,(width*height*4:buffer2)
		bcn	buffer2 eq 0,_cw_fail
		qcall	lib/memseti,(buffer2,backcol,width*height*4:p~)
		cpy.p	buffer2,[visual+vis_buffer2]
		


		;	get font.

		qcall	ave/font/getfm, (-:fontman)
		bcn	fontman eq 0, _cw_fail
	

		als	FNTMAN_FONTLIST_SIZE
		cpy.p	sp,fontdes
		qcall	ave/font/setfer,(fontdes:-)
	;	cpy.p	defaultfontname,[fontdes+FONT_DISPLAYNAME]
		cpy.i	FDF_MONOSPACE|FDF_BOLD|FDF_NO_ANTIALIAS,[fontdes+FONT_DESCRIPTORFLAGS]
		als	8
		reftool	ave/font/cmp_displayname,[sp]
		reftool	ave/font/cmp_flags,[sp+4]
		qcall	ave/font/matchfont,(fontman,fontdes,sp,2.i:index)		
		als	-8
		als	-FNTMAN_FONTLIST_SIZE

		qcall	ave/font/openindex,(fontman,index,FONTHEIGHT:font)

		qcall	ave/font/losefm,(fontman:-)

		bcn	font eq 0, _cw_fail
		cpy.p	font,[visual+vis_font]
		
		
		cpy.i	FONTHEIGHT,[visual+vis_fontheight]

		cpy.i	-1,temp
		ncall	font,getwidth,(font,temp:temp)
		cpy.i	temp,[visual+vis_fontwidth]
		cpy.i	FONTHEIGHT,[visual+vis_fontheight]
	


		;	open ave.

		qcall	sys/kn/dev/lookup,(avename.p:ave,app)
		bcn	ave eq 0,_cw_fail
		
		ncall	ave,open,(ave,app,0,0:app)
		bcn	app eq 0,_cw_fail	

		cpy.p	app,[visual+vis_app]
		cpy.p	ave,[visual+vis_ave]


		;	open toolkit.
		
		ncall	ave,opentoolkit,(ave:tkit)
		bcn	tkit eq 0,_cw_fail
		cpy.p	tkit,[visual+vis_toolkit]


		;	get application props, open window.

		ncall	app,getprop,(app:prp)
		ncall	tkit,createdialog,(tkit,prp,title,0.p,width,height,FDI_BORDER|FDI_TITLE|FDI_DRAG|FDI_CLOSE|FDI_CONTENT|FDI_INNER|FDI_RESIZE:win)
		bcn	win eq 0,_cw_fail
		cpy.p	win,[visual+vis_window]


		;	cpy.i	4,tok
		;	ncall	win,settokenmask,(win,tok,tok:-)		; ?



		;	set layout/scrollpane.
		
		ncall	win,getgadgets,(win:p~,p~,cnt)
		
		qcall	ave/layout/scrollpane/open,(100,100:layout)
		bcn	layout eq 0,_cw_fail
		ncall	tkit,createscrollpane,(tkit,prp,0,0,0,FSP_CONTENT:scrollpane)
		bcn	scrollpane eq 0,_cw_fail

		ncall	cnt,addlayout,(cnt,layout:-)
		ncall	cnt,add,(cnt,scrollpane,0:-)
		ncall	scrollpane,getgadgets,(scrollpane:p~,p~,cnt)

		ncall	cnt,setsize,(cnt,1000,1000:-)
		ncall	cnt,change,(scrollpane,0,0,width,height,CM_NONE:-)
		cpy.p	cnt,[visual+vis_content]
		cpy.p	scrollpane,[visual+vis_scrollpane]


		;	get pixmaps.
		
		qcall	ave/avo/pix/32bit/open,(buffer2,width,height,width*4:pixmap)
		bcn	pixmap eq 0,_cw_fail
		cpy.p	pixmap,[visual+vis_pixmap2]

		qcall	ave/avo/pix/32bit/open,(buffer,width,height,width*4:pixmap)
		bcn	pixmap eq 0,_cw_fail
		cpy.p	pixmap,[visual+vis_pixmap]
		ncall	cnt,add,(cnt,pixmap,0:-)



		;	link window and application.
	
		ncall	win,addlink,(win,app,CH_DIALOG_ACTION,EV_QUIT:i~)
		ncall	app,add,(app,win,0:-)
		ncall	win,update,(win:-)



		;	activate window.

		cpy.i	2,tok			
		ncall	ave,settoken,(ave,win,tok:-)



		;	misc initializitations.

		cpy.i	width,[visual+vis_width]	
		cpy.i	height,[visual+vis_height]
		cpy.i	backcol,[visual+vis_backcolor]

		cpy.p	visual,p0
		ret

_cw_fail:
		qcall	lib/tek/kn/visual/destroyvisual,(visual:-)
_cw_exit:
		cpy.p	0,p0
		ret
		
	defend


;-----------------------------------------------------------------------------

		data
	
;-----------------------------------------------------------------------------

inputmethodname:
		dc.b 'demo/ave/inputmethod',0
		.align

avename:	dc.b '/device/ave/',0
		.align

appname:	dc.b 'visual',0
		.align

defaultfontname:	dc.b 'Mono',0
		.align


	toolend

;-----------------------------------------------------------------------------
;=============================================================================
