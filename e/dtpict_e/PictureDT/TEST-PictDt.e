/* Mini viewer, using datatypes.library and picture.datatype */

MODULE 'intuition/intuition',
	'shark/pictdt',
	'reqtools',
	'libraries/reqtools',
	'intuition/screens',

	'datatypes/pictureclass'    -> bmhd

PROC main()
DEF file,pic:PTR TO picturedt,s:PTR TO screen

file:=filereq('Please choose file JPG/IFF/BMP/GIF');

NEW pic

IF pic.loadpicture(file)=0 ; END pic ; CleanUp(0) ; ENDIF

s:=OpenScreenTagList(0,[
			SA_WIDTH,	pic.bmhd.width,
			SA_HEIGHT,	pic.bmhd.height,
			SA_DEPTH,	pic.bmhd.depth,
			SA_DISPLAYID,	pic.modeid,
			SA_OVERSCAN,	OSCAN_TEXT,
		NIL])

pic.scr:=s;
pic.palette()

BltBitMapRastPort(pic.bmap,0,0,s.rastport,0,0,pic.bmhd.width,pic.bmhd.height,$C0);

REPEAT ; Delay(10) ; UNTIL Mouse()=1

pic.dispose()
CloseS(s)

ENDPROC



/********** File Requester (REQTOOLS) ********/
PROC filereq(title)
DEF dir[4096]:STRING,buf[512]:STRING,req:PTR TO rtfilerequester
IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
	IF req:=RtAllocRequestA(0,0)
			RtFileRequestA(req,buf,title,0)
			RtFreeRequest(req)
	ENDIF
CloseLibrary(reqtoolsbase)
IF StrCmp(req.dir,'')=0 THEN StringF(dir,'\s/\s',req.dir,buf) ELSE StrCopy(dir,buf);
RETURN dir
ELSE
WriteF('Cannot open reqtools.library V37\n')
ENDIF
ENDPROC
