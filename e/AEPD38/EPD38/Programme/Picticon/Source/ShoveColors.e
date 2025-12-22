MODULE 'exec/memory',
			 'intuition/intuition','intuition/screens','intuition/gadgetclass',
			 'intuition/screens',
			 'graphics/rastport','graphics/gfx','graphics/text',
			 'graphics/view',
			 'libraries/iffparse','iffparse',
			 'dos/dos','dos/dosextens','dos/dosasl','exec/tasks'

	OBJECT bitmapheader
		w:INT;h:INT;x:INT;y:INT
		depth:CHAR;masking:CHAR
		compression:CHAR;pad1:CHAR;transparentcolor:INT
		xaspect:CHAR;yaspect:CHAR;pagewidth:INT;pageheight:INT
	ENDOBJECT
	DEF source[250]:STRING
	DEF argarray[11]:LIST
	DEF	iff=NIL:PTR TO iffhandle
	DEF cn=NIL:PTR TO contextnode
	DEF	ierror,rlen
	DEF	des=NIL:PTR TO rastport
	DEF bmhd=NIL:PTR TO bitmapheader
	DEF sp=NIL:PTR TO storedproperty
	DEF planedata[10]:LIST
	DEF widthbytes,pokeplane,body,origbody,numbytes
	DEF ditz,dang,dumb,dope
	DEF destrgb[260]:LIST
	DEF vp=NIL:PTR TO viewport
	DEF cm,clipx,clipy
	DEF depth,iffdepth,nc,nci,scratch
	DEF rdarg
	DEF viewport=NIL:PTR TO viewport
	DEF scr=NIL:PTR TO screen
	DEF bitmap=NIL:PTR TO bitmap
	DEF quiet=FALSE
	DEF lock[260]:LIST
	DEF lockmode=0 /* 0 means don't lock unless in palette*/
	DEF force=0	/* 0 means don't override already locked pens! */
PROC main() HANDLE
	IF KickVersion(39)=NIL
		WriteF('\nGet OS3.x (maybe a nice A1200?)\n')
		CleanUp(21)
	ENDIF

	iffparsebase:=OpenLibrary('iffparse.library',39)

	rdarg:=ReadArgs('FILE/A,QUIET=Q/S,FORCE=F/S,LOCKALL=LA/S',argarray,0)
	IF rdarg>0
		IF argarray[0]<>NIL
			StrCopy(source,argarray[0],ALL)
		ENDIF
		IF argarray[1]<>NIL
			quiet:=TRUE
		ENDIF
		IF argarray[2]<>NIL
			force:=TRUE
		ENDIF
		IF argarray[3]<>NIL
			lockmode:=TRUE
		ENDIF
		FreeArgs(rdarg)
	ELSE
		Raise(1)
	ENDIF
	IF (scr := LockPubScreen(NIL)) = NIL
		Raise(1)
	ELSE
		bitmap:=scr.bitmap
		viewport:=scr.viewport
		depth:=bitmap.depth
		cm:=viewport.colormap
	ENDIF

	iff:=AllocIFF()
	
	iff.stream:=Open(source,MODE_OLDFILE)
	IF (iff.stream)
		InitIFFasDOS(iff)
	ELSE
		Raise(1)
	ENDIF

	ierror:=OpenIFF(iff,IFFF_READ)
	ierror:=PropChunk(iff,"ILBM","LOCK")
	ierror:=PropChunk(iff,"ILBM","CMAP")
	ierror:=StopOnExit(iff,"ILBM","FORM")
	ierror:=ParseIFF(iff,IFFPARSE_SCAN)

	IF(sp:=FindProp(iff,"ILBM","LOCK"))
		body:=sp.data
		FOR scratch:=0 TO (sp.size-1)
			ditz:=Char(body++)
			IF lockmode=0
				lockpen(scratch,ditz)
			ELSE
				lockpen(scratch,1)
			ENDIF
		ENDFOR
	ENDIF
	IF(sp:=FindProp(iff,"ILBM","CMAP"))
		body:=sp.data
		FOR scratch:=0 TO (sp.size/3)-1
			ditz:=Char(body++)
			dang:=Char(body++)
			dumb:=Char(body++)
			IF (scratch<(Shl(1,depth)))
				IF lock[scratch]=FALSE
					setrgb32(viewport,scratch,ditz,dang,dumb)
				ENDIF
				IF force
					setrgb32(viewport,scratch,ditz,dang,dumb)
				ENDIF
			ENDIF
		ENDFOR
	ELSE
		Raise(1)
	ENDIF
	Raise(0)
EXCEPT
	IF scr THEN UnlockPubScreen(0,scr)
	IF (iff)
		CloseIFF(iff)
		IF (iff.stream) THEN Close(iff.stream)
		FreeIFF(iff)
	ENDIF
	IF iffparsebase THEN CloseLibrary(iffparsebase)
	IF ((exception) AND (quiet=FALSE)) THEN WriteF('ShoveColors Failed.\n')
ENDPROC

PROC getrgb32(cm,fc,nc,tab)
	DEF ret
	MOVE.L cm,A0
	MOVE.L fc,D0
	MOVE.L nc,D1
	MOVE.L tab,A1
	MOVE.L gfxbase,A6
	JSR    -$384(A6)
	MOVE.L D0,ret
ENDPROC ret

PROC setrgb32(vp,pen,red,green,blue)
	MOVE.L vp,A0
  MOVE.L pen,D0
  MOVE.L red,D1
  SWAP   D1
  LSL.L  #8,D1
  MOVE.L green,D2
  SWAP   D2
  LSL.L  #8,D2
  MOVE.L blue,D3
  SWAP   D3
  LSL.L  #8,D3
  MOVE.L gfxbase,A6
  JSR    -$354(A6)
ENDPROC

PROC obtainpen(cm,n,r,g,b,f)
	DEF ret
	MOVE.L gfxbase,A6
	MOVE.L n,D0
  MOVE.L r,D1
  SWAP   D1
  LSL.L  #8,D1
  MOVE.L g,D2
  SWAP   D2
  LSL.L  #8,D2
  MOVE.L b,D3
  SWAP   D3
  LSL.L  #8,D3
	MOVE.L cm,A0
	MOVE.L f,D4
	JSR    -$3BA(A6)
	MOVE.L D0,ret
ENDPROC ret

PROC releasepen(cm,n)
	MOVE.L cm,A0
	MOVE.L n,D0
	MOVE.L gfxbase,A6
	JSR    -$3B4(A6)
ENDPROC

PROC lockpen(pn,mode)

	DEF cmtable,red,green,blue,dummy

	cmtable:=[0,0,0,0,0,0]:LONG
	getrgb32(cm,pn,1,cmtable)
	red:=Char(cmtable)
	green:=Char(cmtable+4)
	blue:=Char(cmtable+8)

	dummy:=obtainpen(cm,pn,red,green,blue,0)

	IF dummy<0
		lock[pn]:=TRUE /* Pen was unavailable, so DON'T release/change! */
	ELSE
		IF (mode=0) /* Was able to lock, but it needs to be *free* */
			releasepen(cm,pn)
		ENDIF
		lock[pn]:=FALSE
	ENDIF
ENDPROC

versionstring:
CHAR '\0$VER: shovecolors 0.3 (4.7.94)\0'
