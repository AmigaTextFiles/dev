
	.include 'taort'
	.include 'ave/toolkit/toolkit.inc'
	.include 'lib/tek/kn/elate/visual.inc'

;=============================================================================
;-----------------------------------------------------------------------------
; 
;	TEKlib
;	(C) 1999-2001 TEK neoscientists
;	all rights reserved.
;
;	newev = getevent(visual, &ev, &x, &y, &keycooked,&resize,&buttonstate)
;
;-----------------------------------------------------------------------------
;=============================================================================

	tool 'lib/tek/kn/visual/getevent',VP,0

;-----------------------------------------------------------------------------

	ent p0 p1 p2 p3 p4 p5 p6 : i0

	defbegin
	defp visual,evtp,xp,yp,keycooked,resize,buttonstate
	defp app,avo,ave,msg,pixmap,win,tempp
	defi evt,temp,x,y
	defi cont,neww,newh


		cpy	0,[resize]
		cpy	0,[buttonstate]

		cpy.p	[visual+vis_app],app
		cpy.p	[visual+vis_ave],ave
		cpy.p	[visual+vis_window],win
		cpy.p	[visual+vis_pixmap],pixmap


_getloop:
		cpy	0,cont

		ncall	app,getevent,(app,1.l:avo,msg,evt)
		bcp	avo eq 0,_evokay
		

	
	;	if	evt = EV_GAINEDTOKEN
	;		if	[msg + EVD_TOKEN] = BFAVO_KEYTOKEN
	;			tracef "gained key token: %d\n",evt
	;		else
	;		;	tracef "gained other token\n"
	;		endif
	;	elseif	evt = EV_LOSTTOKEN
	;		if	[msg + EVD_TOKEN] = BFAVO_KEYTOKEN
	;			tracef "lost key token event: %d\n",evt
	;		;	qcall	ave/input/checkfocus,(NULL,app:-)
	;		;	qcall	ave/input/checkfocus,(NULL,pixmap:-)
	;			ncall	app,settoken,(app,pixmap,BFAVO_KEYTOKEN:-)
	;		else
	;			tracef "lost other token\n"
	;		endif

		if evt = EV_BUTTONUP
			if	avo eq [visual+vis_pixmap]
				cpy.i	[msg+EVD_RX],x
				cpy.i	[msg+EVD_RY],y
				cpy.i	x,[xp]
				cpy.i	y,[yp]

				cpy.i	2,temp			
				ncall	ave,settoken,(ave,win,temp:-)			; activate window!

				cpy.i	[visual+vis_currentbuttonstate],[buttonstate]
				cpy.i	0,[visual+vis_currentbuttonstate]
				;tracef	"buttonup event: %d %d %d %d\n", evt,x,y,temp
			endif
		
		elseif evt = EV_BUTTONDOWN
			if	avo eq [visual+vis_pixmap]
				cpy.i	[msg+EVD_RX],x
				cpy.i	[msg+EVD_RY],y
				cpy.i	x,[xp]
				cpy.i	y,[yp]

				cpy.i	[msg+EVD_BUTTONS],temp
				cpy.i	temp,[buttonstate]
				cpy.i	temp,[visual+vis_currentbuttonstate]
				;tracef	"buttondown event: %d %d %d %d\n", evt,x,y,temp
			endif

		elseif evt = EV_TRACKING
			if	avo eq [visual+vis_pixmap]
				cpy.i	[msg+EVD_RX],x
				cpy.i	[msg+EVD_RY],y
				cpy.i	x,[xp]
				cpy.i	y,[yp]
				;tracef	"tracking event: %d %d %d\n", evt,x,y
			endif

		elseif evt = EV_KEYDOWN
			;tracef	"keydown. cooked: %x\n", [msg+EVD_KEYCOOKED]
			cpy.i	[msg+EVD_KEYCOOKED],[keycooked]
		
		elseif evt = EV_DIALOG_RESIZE
		
			;tracef	"*** TEKLIB kn_getevent - resize event\n"
			cpy	1,[resize]
			cpy	1,cont

		endif


		ncall	avo,event,(avo,msg,evt:-)
		ncall	ave,freeevent,(ave,msg:-)

		bcn	cont eq 1,_getloop

		
		bcp	[resize] eq 0,_oki

		cpy.p	[visual+vis_scrollpane],tempp
		ncall	tempp,getsize,(tempp:neww,newh)
		gos	_resize,(visual,neww,newh:i~)

_oki:		cpy.i	evt,[evtp]
		cpy.i	1,i0
		ret

_evokay:	cpy.i	evt,[evtp]
		cpy.i	0,i0
		ret

	defend



_resize:

	ent	p0 i0 i1 : i0

	defbegin
	defp	visual
	defi	neww,newh
	defi	success
	defp	temp,ave,cnt

		cpy.i	0,success

		cpy.p	[visual+vis_buffer],temp
		qcall	lib/realloc,(temp,neww*newh*4:temp)
		bcn	temp eq 0,_resize_fail
		qcall	lib/memseti,(temp,[visual+vis_backcolor],neww*newh*4:p~)
		cpy.p	temp,[visual+vis_buffer]
		
		cpy.p	[visual+vis_buffer2],temp
		qcall	lib/realloc,(temp,neww*newh*4:temp)
		bcn	temp eq 0,_resize_fail
		qcall	lib/memseti,(temp,[visual+vis_backcolor],neww*newh*4:p~)
		cpy.p	temp,[visual+vis_buffer2]

		cpy.i	neww,[visual+vis_width]
		cpy.i	newh,[visual+vis_height]

		cpy.p	[visual+vis_ave],ave
		cpy.p	[visual+vis_content],cnt


		;	unlink old pixmap.

		cpy.p	[visual+vis_pixmap],temp
		ncall	cnt,sub,(cnt,temp:-)


		;	delete old pixmaps.

		ncall	temp,_deinit,(temp:-)
		qcall	ave/avo/_delete,(temp:-)
		cpy.p	0,[visual+vis_pixmap]
		cpy.p	[visual+vis_pixmap2],temp
		ncall	temp,_deinit,(temp:-)
		qcall	ave/avo/_delete,(temp:-)
		cpy.p	0,[visual+vis_pixmap2]


		;	create new pixmaps.

		cpy.p	[visual+vis_buffer],temp
		qcall	ave/avo/pix/32bit/open,(temp,neww,newh,neww*4:temp)
		bcn	temp eq 0,_resize_fail
		cpy.p	temp,[visual+vis_pixmap]
		ncall	cnt,add,(cnt,temp,0:-)

		cpy.p	[visual+vis_buffer2],temp
		qcall	ave/avo/pix/32bit/open,(temp,neww,newh,neww*4:temp)
		bcn	temp eq 0,_resize_fail
		cpy.p	temp,[visual+vis_pixmap2]


		cpy.i	1,success

_resize_fail:
		cpy.i	success,i0
		ret

	defend

	toolend

;-----------------------------------------------------------------------------
;=============================================================================
