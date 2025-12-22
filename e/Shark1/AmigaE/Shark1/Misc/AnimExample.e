/**
 ** IFFAnim Example
 ** By Krzysztof "SHARK" Cmok
 ** (C) 29-01-98
 **/

 MODULE 'other/split',
	'libraries/iff',
	'iff',
	'intuition/intuition',
	'intuition/screens',
	'graphics/gfxbase',
	'graphics/view'

DEF argv:PTR TO LONG,delay,filename[512]:STRING


-> ******** SET OVERSCAN *********** <-

PROC setOverscan(screen:PTR TO screen)
DEF cols,rows,x,y,vp:PTR TO viewport,gfxbase:PTR TO gfxbase

gfxbase:=gfxbase
x:=screen.width
y:=screen.height
vp:=screen.viewport
cols:=Shl(1,gfxbase.normaldisplaycolumns)
rows:=gfxbase.normaldisplayrows
IF rows>300 THEN Shl(1,rows)
x:=-cols; IF (vp.modes AND V_HIRES) THEN x:=-cols;
y:=-rows; IF (vp.modes AND V_LACE) THEN y:=-rows;
Shl(1,x)
IF x<0 THEN x:=0
Shl(1,y)
IF y<0 THEN y:=0
IF y>32 THEN y:=32
IF (vp.modes AND V_HAM)
	IF gfxbase.actiview.dxoffset-x<96
		x:=gfxbase.actiview.dxoffset-96
	ENDIF
ENDIF
vp.dxoffset:= -x; vp.dyoffset:= -y;
MakeScreen(screen);
RethinkDisplay();
ENDPROC

-> *********** Display Anim ************** <-

PROC displayANIM(filename)
DEF iff=NIL,bmhd:PTR TO bmhd,screen1:PTR TO screen,screen2:PTR TO screen,dummy:PTR TO screen,ns:PTR TO ns
DEF count,d,colortable:PTR TO LONG,form
 IF (iff:=IfFL_OpenIFF(filename, IFFL_MODE_READ))=0 ; WriteF('error bad filename!\n') ; RETURN 0 ;ENDIF
 form:=iff+12
 IF (bmhd:=IfFL_GetBMHD(form))=0 THEN JUMP end
 ns:=New(SIZEOF ns)

 ns.type	:=	CUSTOMSCREEN+SCREENQUIET+SCREENBEHIND;
 ns.width	:=	bmhd.w;
 ns.height	:=	bmhd.h;
 ns.depth	:=	bmhd.nplanes;
 ns.viewmodes	:=	IfFL_GetViewModes(form);

 	IF (screen1:=OpenScreen(ns))=0 THEN JUMP error
	IF (screen2:=OpenScreen(ns))=0 THEN JUMP error
		setOverscan(screen1)
		setOverscan(screen2)

		count:=IfFL_GetColorTab(form,colortable);
		IF count>32 THEN count:=32;

		LoadRGB4(screen1.viewport,colortable,count);
		LoadRGB4(screen2.viewport,colortable,count);

		IF IfFL_DecodePic(form,screen1.bitmap)=0 THEN JUMP error
		IfFL_DecodePic(form,screen2.bitmap)
		ScreenToFront(screen2)

		FOR d:=0 TO delay DO WaitTOF();

		form:=IfFL_FindChunk(form,0);
		IF (IfFL_ModifyFrame(form,screen1.bitmap))=0 THEN JUMP error
		ScreenToFront(screen1)

		FOR d:=0 TO delay DO WaitTOF();
		form:=IfFL_FindChunk(form,0)

		LOOP
			IF IfFL_ModifyFrame(form, screen2.bitmap)
				dummy:=screen1
				screen1:=screen2
				screen2:=dummy
				ScreenToFront(screen1)
				FOR d:=0 TO delay DO WaitTOF()
			ELSE
				JUMP error
			ENDIF
				form:=IfFL_FindChunk(form,0)
		ENDLOOP
error:
  WriteF('Error!\n')
end:
  IF screen1 THEN CloseScreen(screen1)
  IF screen2 THEN CloseScreen(screen2)
  IF iff THEN IfFL_CloseIFF(iff);

ENDPROC

-> *********** Main program ************** <-

PROC main()
IF iffbase:=OpenLibrary('iff.library',22)

	argv:=argSplit()
	WriteF('AnimExample for AmigaE v3.0 or better!\nUSAGE: AnimExample <filename.anim> <delay>\n')
	StrCopy(filename,argv[0])
	delay:=Val(argv[1])
	displayANIM(filename)
	WriteF('IFF Error nr: \d\n',IfFL_IFFError() );

ELSE

	WriteF('Can\at open iff.library\n')
	CleanUp(0)

ENDIF
	CloseLibrary(iffbase)

ENDPROC 0
