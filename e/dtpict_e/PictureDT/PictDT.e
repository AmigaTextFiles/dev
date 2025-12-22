OPT MODULE
OPT EXPORT

/*
 * This module is for display pictures
 * by means of PictureDT.datatype
 * Module displaying ex.: JPG,GIF,BMP,IFF
 *
 * PictDT v1.0 - written by Krzysztof Cmok
 * module is written in day 10-Apr-99
 *
 */

MODULE	'datatypes/datatypesclass'	-> definicje...
MODULE	'datatypes/pictureclass'	-> object 'bitmapheader'
MODULE	'intuition/classes'		-> object struct ;)
MODULE  'intuition/gadgetclass'		-> gplayout
MODULE	'amigalib/boopsi'		-> dla domethod
MODULE	'intuition/screens'		-> screen
MODULE	'graphics/gfx'			-> bitmap
MODULE	'datatypes'			-> wiadomo co
MODULE	'graphics/view'			-> OBP_PRECISION

OBJECT picturedt
	bmhd:PTR TO bitmapheader	->- format and informations
	bmap:PTR TO bitmap		->- bitmap
	obj:PTR TO object		->- objekt
	scr:PTR TO screen
	remap:PTR TO LONG
	->-infosy
	nrcolors:PTR TO LONG		->- ilosc kolorow w palecie obrazka.
	modeid:PTR TO LONG		->- rozdzielczosc.
	palette:PTR TO LONG		->- paleta kolorow.
ENDOBJECT

->- procedure for open file...
PROC loadpicture(filename) OF picturedt
DEF bm:PTR TO bitmap,bh:PTR TO bitmapheader
DEF nrcols,modeid,regs

	IF (datatypesbase:=OpenLibrary('datatypes.library',0))=0 THEN RETURN 0
	
	self.obj:=NewDTObjectA(filename,
				[DTA_SOURCETYPE, DTST_FILE,
				 DTA_GROUPID,	 $70696374,		-> ID: pict
				 PDTA_FREESOURCEBITMAP,	TRUE,
				 PDTA_REMAP,	 self.remap,
				 PDTA_SCREEN,	 self.scr,
				 OBP_PRECISION,	 PRECISION_IMAGE,0])

	doMethodA(self.obj,[DTM_PROCLAYOUT,NIL,1]:gplayout);
	GetDTAttrsA(self.obj,[PDTA_BITMAPHEADER,{bh},PDTA_DESTBITMAP,{bm},
				PDTA_NUMCOLORS,{nrcols},PDTA_MODEID,{modeid},
					PDTA_CREGS,{regs},0]);
	IF bm=0 THEN GetDTAttrsA(self.obj,[PDTA_BITMAP,{bm},0]);
	IF bm=0 THEN RETURN 0
	self.bmhd:=bh;
	self.bmap:=bm;
	self.nrcolors:=nrcols;
	self.modeid:=modeid;
	self.palette:=regs;
ENDPROC -1

->- loadpalette
PROC palette() OF picturedt
DEF i,r,g,b

IF (self.scr)=0
	RETURN 0
ELSE
	self.nrcolors:=Shl(2,self.scr.bitmap.depth-1);
	FOR i:=0 TO self.nrcolors
		r:=self.palette[i * 3 + 0];
		g:=self.palette[i * 3 + 1];
		b:=self.palette[i * 3 + 2];
		SetRGB32(self.scr.viewport,i,r,g,b);
	ENDFOR
ENDIF
ENDPROC -1

->- dispose
PROC dispose() OF picturedt
	WaitBlit()
	DisposeDTObject(self.obj)
	Dispose(self.obj)
	CloseLibrary(datatypesbase);
	self.obj:=0;
ENDPROC -1

/* SIMPLE PROGRAM FOR TEST!!!
 ****************************

PROC main()
DEF w,pdt:PTR TO picturedt,s:PTR TO screen

s:=OpenS(640,200,8,V_HIRES,0,[SA_PENS,[$FFFF]:INT,NIL])
w:=OpenW(0,0,640,200,0,0,NIL,s,$f,0);
datatypesbase:=OpenLibrary('datatypes.library',0)

NEW pdt

pdt.scr:=s;
pdt.loadpicture('dev:lc/charts/aframev02/examples/picturedt/pictures/toystry1.gif')
pdt.palette()

BltBitMapRastPort(pdt.bmap,0,0,stdrast,0,0,pdt.bmhd.width,pdt.bmhd.height,$c0);

WaitLeftMouse(w)
pdt.dispose()
CloseLibrary(datatypesbase)
CloseW(w)
CloseS(s)
ENDPROC

*/
