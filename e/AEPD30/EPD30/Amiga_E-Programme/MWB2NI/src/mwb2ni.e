/*

mwb2ni -- Converts an old icon (8-color magicwb) to the "newicon" format

Written by Chad Randall -- Broken Spork Technologies, mbissaymssiK Software

  INTERNET:crandall@garnet.msen.com
    USNAIL:229 S.Washington St
           Manchester, Michigan  48158-9680

Check out Iconian, Picticon, PlayKiSS, and randomcopy for other of my works.
Iconian III is still being worked on...all is not forgotten


We are the damned of all the world
With sadness in our hearts
The wounded of the wars
We've been hung out to dry
You didn't want us anyway
And now we're making up our minds
You tell us how to run our lives
We run for Youthanasia        -- Mustaine
*/

MODULE 'dos/dos','dos/dosextens','dos/dosasl','exec/tasks'
MODULE 'newicon','libraries/newicon'
MODULE 'exec/nodes','exec/ports','exec/types','exec/memory',
       'intuition/intuition','intuition/screens','intuition/gadgetclass',
       'intuition/screens',
			 'graphics/rastport','graphics/gfx','graphics/text',
       'graphics/view','graphics/gfxbase','workbench/workbench',
       'wb','icon','graphics/clip'

DEF ctrlc=FALSE
DEF rdarg
DEF argarray[11]:LIST
DEF source[500]:STRING
DEF array[25]:LIST
DEF	filename[750]:STRING,filestart,pathlen
DEF fh1,fh2,fh3,res,t,names:PTR TO LONG
DEF re[18]:LIST,gr[18]:LIST,bl[18]:LIST,lc=0,toomany=0
DEF red,grn,blu
DEF buffer
DEF scr=NIL:PTR TO screen
DEF x,y,w,h,nw
DEF long
DEF offset=4
DEF r1,g1,b1,r2,g2,b2
DEF res1,res2
DEF apath=NIL:PTR TO anchorpath
DEF backup=FALSE
DEF bitmap=NIL:PTR TO bitmap,rast=NIL:PTR TO rastport
DEF makedot=FALSE
DEF force=FALSE

PROC dosearch(str)
	DEF fileinfo=NIL:PTR TO fileinfoblock
	DEF	achain=NIL:PTR TO achain
	DEF err=0,pathlen,filestart,first=0,chance=1
	DEF	newdate=NIL:PTR TO datestamp
	DEF dirlist[1000]:LIST,ctr=0
	DEF ii

	FOR ii:=0 TO 999
		dirlist[ii]:=0
	ENDFOR
	apath:=New(SIZEOF anchorpath)

	WHILE err=NIL
		IF first=FALSE
			err:=MatchFirst(str,apath)
			first:=TRUE
		ELSE
			err:=MatchNext(apath)
		ENDIF
		IF err=NIL
			achain:=apath.last
			IF (achain)
				fileinfo:=achain.info
				IF (fileinfo)
					IF (fileinfo.direntrytype)<0
						filestart:=FilePart(str)
						pathlen:=filestart-str
						IF (pathlen)
							StrCopy(filename,str,pathlen)
						ELSE
							StrCopy(filename,'',ALL)
						ENDIF
						AddPart(filename,fileinfo.filename,740)
						IF ctr<950
							dirlist[ctr]:=String(StrLen(filename)+4)
							StrCopy(dirlist[ctr],filename,ALL)
							ctr:=ctr+1
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDWHILE
	IF apath THEN MatchEnd(apath)
	IF apath THEN Dispose(apath);apath:=NIL

	FOR ii:=0 TO 999
		IF (dirlist[ii]>0)
			doconvert(dirlist[ii])
			IF CtrlC();ii:=505;ctrlc:=TRUE;ENDIF
		ENDIF
	ENDFOR
	FOR ii:=0 TO 999
		IF (dirlist[ii])
			DisposeLink(dirlist[ii])
			dirlist[ii]:=0
		ENDIF
	ENDFOR
ENDPROC

PROC doconvert(file)
	DEF string[500]:STRING
	DEF diskobj=NIL:PTR TO diskobject
	DEF newdiskobj=NIL:PTR TO newdiskobject
	DEF ci1=NIL:PTR TO chunkyimage
	DEF ci2=NIL:PTR TO chunkyimage
	DEF cd1=NIL
	DEF cd2=NIL
	DEF col=NIL
	DEF vp=0:PTR TO viewport,colormap=0,depth=2
	DEF red0,grn0,blu0
	DEF red1,grn1,blu1
	DEF red2,grn2,blu2
	DEF red3,grn3,blu3
	DEF red4,grn4,blu4
	DEF red5,grn5,blu5
	DEF red6,grn6,blu6
	DEF red7,grn7,blu7
	DEF oldi1=0,oldi2=0,oldni1=0,oldni2=0,oldw=1,oldh=1
	DEF offs,w,h,i,t,rpix
	DEF gad:PTR TO gadget
	NEW ci1,ci2,rast
	col:=New(1024)

	StrCopy(string,file,ALL)
	UpperStr(string)
	IF InStr(string,'.INFO')>0
		PutChar(file+InStr(string,'.INFO'),0)
		WriteF('\nConverting "\s"...',file)
		newdiskobj:=GetNewDiskObject(file)
		IF (newdiskobj)
			diskobj:=newdiskobj.ndo_stdobject
			oldni1:=newdiskobj.ndo_normalimage
			oldni2:=newdiskobj.ndo_selectedimage
			IF (((newdiskobj.ndo_normalimage) OR (newdiskobj.ndo_selectedimage)) AND (force=0))
				WriteF('already a newicon!')
			ELSE
		  	gad:=diskobj.gadget::gadget
				oldi1:=gad.gadgetrender
				oldi2:=gad.selectrender
		  	w:=gad.gadgetrender::image.width
		  	h:=gad.gadgetrender::image.height
		  	oldw:=w;oldh:=h
		  	w:=limit(w,1,92)
		  	h:=limit(h,1,92)
				bitmap:=AllocBitMap(w+64,h+32,8,BMF_STANDARD OR BMF_CLEAR,NIL)
				InitRastPort(rast);rast.bitmap:=bitmap
				IF (bitmap)
				  	vp:=scr.viewport;colormap:=vp.colormap
				  	depth:=scr.bitmap::bitmap.depth
				  	red0,grn0,blu0:=getrgb(colormap,0)
				  	red1,grn1,blu1:=getrgb(colormap,1)
				  	red2,grn2,blu2:=getrgb(colormap,2)
				  	red3,grn3,blu3:=getrgb(colormap,3)
				  	red4,grn4,blu4:=getrgb(colormap,offset+0)
				  	red5,grn5,blu5:=getrgb(colormap,offset+1)
				  	red6,grn6,blu6:=getrgb(colormap,offset+2)
				  	red7,grn7,blu7:=getrgb(colormap,offset+3)
				  	PutChar(col+0,red0)
				 		PutChar(col+1,grn0)
				  	PutChar(col+2,blu0)
				  	PutChar(col+3,red1)
				  	PutChar(col+4,grn1)
				  	PutChar(col+5,blu1)
				  	PutChar(col+6,red2)
				  	PutChar(col+7,grn2)
				  	PutChar(col+8,blu2)
				  	PutChar(col+9,red3)
				  	PutChar(col+10,grn3)
				  	PutChar(col+11,blu3)
				  	PutChar(col+12,red4)
				  	PutChar(col+13,grn4)
				  	PutChar(col+14,blu4)
				  	PutChar(col+15,red5)
				  	PutChar(col+16,grn5)
				  	PutChar(col+17,blu5)
				  	PutChar(col+18,red6)
				  	PutChar(col+19,grn6)
				  	PutChar(col+20,blu6)
				  	PutChar(col+21,red7)
				  	PutChar(col+22,grn7)
				  	PutChar(col+23,blu7)

				  	newdiskobj.ndo_normalimage:=ci1
				  	DrawImage(rast,diskobj.gadget::gadget.gadgetrender,0,0)
				  	cd1:=New(w*h)
				  	FOR t:=0 TO h-1
				  		FOR i:=0 TO w-1
					  		rpix:=ReadPixel(rast,i,t)
					  		IF rpix>3
					  			rpix:=limit(rpix-offset+4,4,7)
					  		ENDIF
				  			PutChar(cd1+i+(t*w),rpix)
				  		ENDFOR
				  	ENDFOR
				  	IF (diskobj.gadget::gadget.selectrender)
					  	newdiskobj.ndo_selectedimage:=ci2
				  		DrawImage(rast,diskobj.gadget::gadget.selectrender,0,0)
					  	cd2:=New(w*h)
					  	FOR t:=0 TO h-1
				  			FOR i:=0 TO w-1
					  			rpix:=ReadPixel(rast,i,t)
						  		IF rpix>3
						  			rpix:=limit(rpix-offset+4,4,7)
						  		ENDIF
					  			PutChar(cd2+i+(t*w),rpix)
					  		ENDFOR
					  	ENDFOR
				  	ENDIF
				  	ci1.width:=w
				  	ci1.height:=h
				  	ci1.numcolors:=8
				  	ci1.flags:=0
				  	ci1.palette:=col
				  	ci1.chunkydata:=cd1
				  	ci2.width:=w
				  	ci2.height:=h
				  	ci2.numcolors:=8
				  	ci2.flags:=0
				  	ci2.palette:=col
				  	ci2.chunkydata:=cd2
						IF (makedot)
							PutLong({fillim},{image})
							gad.gadgetrender:={oldimage}
							gad.selectrender:=0
							gad.width:=1
							gad.height:=1
						ENDIF
				  	IF (PutNewDiskObject(file,newdiskobj))=0;WriteF('Failed!');ELSE;WriteF('Saved.');ENDIF
						Delay(5)
				  	IF cd1 THEN Dispose(cd1)
				  	IF cd2 THEN Dispose(cd2)
				  FreeBitMap(bitmap)
				ELSE
					WriteF('couldn\at allocate bitmap!')
				ENDIF
				gad.gadgetrender:=oldi1
				gad.selectrender:=oldi2
				gad.width:=oldw
				gad.height:=oldh
			ENDIF
			newdiskobj.ndo_normalimage:=oldni1
			newdiskobj.ndo_selectedimage:=oldni2
			FreeNewDiskObject(newdiskobj)
		ELSE
			WriteF('couldn\at open diskobj!')
		ENDIF
	ENDIF
	END ci1,ci2,rast
	Dispose(col)
ENDPROC

PROC getrgb(cm,pn)
	DEF buf
	buf:=[0,0,0,0,0,0,0,0]
	GetRGB32(cm,pn,1,buf)
	RETURN Long(buf),Long(buf+4),Long(buf+8)
ENDPROC

PROC main() HANDLE
	newiconbase:=OpenLibrary('newicon.library',37)
	IF (newiconbase)
	  IF ((scr:=LockPubScreen('Workbench')))
			argarray[0]:=0
			argarray[1]:=0
			argarray[2]:=0
			argarray[3]:=0
			argarray[4]:=0
			rdarg:=ReadArgs('FROM/A/M,O=OFFSET/N/K,BAK=BACKUP/S,DOT=CLEAROLD/S,REDO/S',argarray,0)
			IF argarray[0]=NIL THEN Raise("HELP")
			IF argarray[2] THEN backup:=TRUE
			IF argarray[3] THEN makedot:=TRUE
			IF argarray[4] THEN force:=TRUE
			IF argarray[1];offset:=argarray[1];offset:=limit(^offset,0,252);ENDIF
			IF (rdarg<>0)
				names:=argarray[0]
				WHILE ((names[0]))
					WriteF('\nScanning "\s"',names[0])
					dosearch(names[]++)
					IF CtrlC();ctrlc:=TRUE;ENDIF
				EXIT (ctrlc<>0)
				ENDWHILE
			ENDIF
			UnlockPubScreen(0,scr)
	  ELSE
	  	WriteF('couldn\at lock Workbench!')
		ENDIF
	ENDIF
EXCEPT DO
	WriteF('\n')
	IF apath THEN MatchEnd(apath)
	IF apath THEN Dispose(apath);apath:=NIL
	IF buffer THEN Dispose(buffer)
	IF exception="HELP" THEN WriteF('Usage: mwb2ni FROM/A/M,O=OFFSET/N/K,BAK=BACKUP/S,DOT=CLEAROLD/S,REDO/S\n')
	IF exception="DOS" THEN WriteF('An error occured.\n\n')
ENDPROC

PROC bigger(a,max) IS IF (a<max) THEN max ELSE a
PROC smaller(a,min) IS IF (a>min) THEN min ELSE a
PROC limit(a,min,max) IS smaller(bigger(a,min),max)

oldimage:
	INT 0,0,1,1,1
fillim:
	LONG 0	->FILL ME
	CHAR 1,0
	LONG 0

image:
	LONG $FFFF

version:
	CHAR	'\0$VER: mwb2ni 0.001 (22.11.94) \tWritten by Chad Randall INTERNET:(crandall@garnet.msen.com)\0'
