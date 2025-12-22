MODULE 'exec/nodes','exec/ports','exec/types','exec/memory',
       'intuition/intuition','intuition/screens','intuition/gadgetclass',
       'intuition/screens','dos/dos','dos/dosextens','gadtools',
       'libraries/gadtools','graphics/rastport','graphics/gfx','graphics/text',
       'graphics/view','graphics/gfxbase','workbench/workbench',
       'workbench/startup','wb','icon','graphics/clip','diskfont',
       'libraries/diskfont','libraries/iffparse','iffparse','Asl','libraries/Asl',
       'datatypes/datatypes','datatypes/datatypesclass','datatypes/pictureclass',
       'utility/hooks','intuition/classes','intuition/classusr',
       'libraries/locale',
       'datatypes','layers','keymap','devices/inputevent','mathtrans','locale'

/* options:

  MAXIWIDTH=x       ;buffer size width
  MAXIHEIGHT=x      ;buffer size height
  APPICON=$         ;name of App-icon image
  TEMPLATE_ICON=$   ;name of icon to modify (tooltypes, positions)
  BACKGROUND_ICON=$ ;Name of background icon.
  CHUNKYMODE=B      ;save icon with ReadPixels, not bitmap->image.
  FORCE_EIGHT=B     ;If YES then eight planes are saved.
  PIC_X_POS=x       ;Offset for image.
  PIC_Y_POS=x       ;Offset for image.
  PIC_X_SIZE=x      ;Real size of image (not always, but at least < than)
  PIC_Y_SIZE=x      ;Real size of image.
  CENTER=B          ;Center icon? Only valid with PIC_X_SIZE/PIC_Y_SIZE
  SHOWSIZE_X=x      ;X pos for size coords
  SHOWSIZE_Y=x      ;Y pos for size coords
  LOWPRI=B          ;If= "yes" then run at priority -1
  FREE_ICON_POS=B   ;Set icon to "unsnapshot"
  HIGHPEN=x         ;topmost pen to use
  SHOWSIZE_OUTLINE=B;If yes, then outline the size, otherwise, shadow it
  SHOWSIZE_NORMAL=B ;If yes, then no shadow, no outline.
  SHOWSIZE_TALL=B   ;If yes, then font is 8 high, not 6.
  QUIET=B           ;If yes then surpress ALL output.
  APP_X_POS=x       ;x pos of appicon
  APP_Y_POS=y       ;y pos of appicon
	DITHER=B					;if YES then do dithering

                         ;      The following are EXPERT tooltypes, only...
	TWOPASS=B					;if YES and dithering on, then do left to right, right to left passes.
	D_THRESHOLD=x			;a pos value for the minimum addition value (dithering)  (EXPERT)
	D_IGNORE=x				;a pos value.  If error<x then igrnore error in dithering.  (EXPERT)
	D_LIMIT=x					;a pos value for the maximum addition value (dithering)  (EXPERT)
	D_TYPE=x					;0 is default    3/8 , 0/0 , 3/8 , 1/4            x  1st value  (x=from here)
										;1 is FS?        7/16, 3/16, 5/16, 1/16      2nd 3rd 4th values
										;2 is alternate  1/2 , 0/0,  1/2,  0/0
										;3 is crosshatch 0/0 , 1/2,  0/0,  1/2             (all EXPERT tooltypes!)
                    ;4 is linear     1/1 , 0/0,  0/0,  0/0
										;5 is equal      1/4 , 1/4,  1/4,  1/4
*/

ENUM E_NONE,L_OK,
  L_E_GENERAL,L_E_FILE,L_E_NOFILE,L_E_BADICON,L_E_NOWRITEICON,L_E_CLIP,
  L_E_DATATYPE,L_E_NOPICTURE,L_E_GADGET,
  L_EF_LIBRARY,L_EF_FATAL,L_EF_PUBSCREEN,L_EF_CHIPBUFFER,L_EF_VISUAL,L_EF_MENUS,
  L_EF_MSGPORT,L_EF_WINDOW,L_EF_MEMORY,L_TEXTTITLE,
  L_PICTURE,L_FILEOF,L_LOADING,L_SCALING,L_REMAPPING,L_SAVING,L_PERCENT,
  L_TITLE,L_BODY,L_BUTTONS,L_RENDERING,L_ENDS

ENUM MODE_CLI,MODE_WB,MODE_QUIET,MODE_APP
ENUM TEXT_NORMAL,TEXT_SHADOW,TEXT_OUTLINE
  OBJECT mybitmapstruct
    bytesperrow:INT;rows:INT;flags:CHAR;depth:CHAR;pad:INT
    plane1:LONG;plane2:LONG;plane3:LONG;plane4:LONG
    plane5:LONG;plane6:LONG;plane7:LONG;plane8:LONG
  ENDOBJECT

DEF texttype=TEXT_SHADOW,tallfont=FALSE
DEF iff:PTR TO iffhandle,ierror
DEF sp=NIL:PTR TO storedproperty
DEF freeme=FALSE
DEF curfile=1,totfile=1
DEF screenfont=NIL:PTR TO textfont
DEF window=NIL:PTR TO window,rast,drawinfo,fgx,fgy,fgw,fgh
DEF showflag=FALSE,showx=0,showy=0,bitsizex,bitsizey,sizestr[50]:STRING
DEF black,white
DEF posx=0,posy=0,sizex=0,sizey=0,centerflag=FALSE,posflag=FALSE
DEF minimumx,minimumy
DEF quietflag=FALSE,goodload
DEF requestsizex,requestsizey,highestcolor
DEF k[15]:LIST
DEF redt[256]:LIST,grnt[256]:LIST,blut[256]:LIST
DEF ditz,dang,dumb,body
DEF newiconbase,newiconmode,osversion,quitter
DEF radian,pointfive
DEF catalog,sl[500]:LIST
DEF iconianheader[80]:STRING
DEF scratch,ret,dummy
DEF appimagedata,diskobj=NIL:PTR TO diskobject
DEF progname[500]:STRING,sleepername[500]:STRING,templatename[500]:STRING
DEF backname[500]:STRING
DEF toolobject=NIL:PTR TO diskobject
DEF chunkyflag=FALSE,force8=FALSE,first4=FALSE
DEF maxiwidth=128,maxiheight=100,maxiw=127,maxih=99
DEF filename[500]:STRING
DEF mode=MODE_CLI
DEF scr=NIL:PTR TO screen,viewport:PTR TO viewport
DEF bitmap:PTR TO bitmap,depth,colormap
DEF currast=NIL:PTR TO rastport,curbitmap=NIL:PTR TO bitmap
DEF appname[500]:STRING
DEF visual=NIL,winx=-1,winy=-1
DEF oldpx=-1
DEF appx=-1,appy=-1
DEF dither=TRUE
DEF twopass=FALSE
DEF rawdata=0
DEF div1=3,div2=0,div3=3,div4=1,rem1=8,rem2=1,rem3=8,rem4=4
DEF thres=2,ignore=16,lim=255,typ=0
PROC main()
  openlibs()
  radian:=sp_div_tf_tf_f(10000,572958)
  pointfive:=sp_div_tf_tf_f(10,5)
  StrCopy(iconianheader,'Picticon 0.1',ALL)
  loadwinpos()
  handwb()
  savewinpos()
  leave(0)
ENDPROC

versionstring:
CHAR '\0$VER: picticon 0.6 (22.7.94)\0'
CHAR 0,0,0,0

PROC setraw(x,y,r,g,b)
  IF rawdata
    PutLong(rawdata+(limit(x,0,maxiwidth)*12)+(limit(y,0,1)*12*maxiwidth),r)
    PutLong(rawdata+(limit(x,0,maxiwidth)*12)+4+(limit(y,0,1)*12*maxiwidth),g)
    PutLong(rawdata+(limit(x,0,maxiwidth)*12)+8+(limit(y,0,1)*12*maxiwidth),b)
  ENDIF
ENDPROC

PROC rawred(x,y)
  RETURN Long(rawdata+(x*12)+(y*12*maxiwidth))
ENDPROC

PROC rawgrn(x,y)
  RETURN Long(rawdata+4+(x*12)+(y*12*maxiwidth))
ENDPROC

PROC rawblu(x,y)
  RETURN Long(rawdata+8+(x*12)+(y*12*maxiwidth))
ENDPROC

PROC processicon() HANDLE
  DEF gadget:PTR TO gadget
  DEF backobj=NIL:PTR TO diskobject
  DEF screenattr:PTR TO textattr,sfonth=8
  DEF heystring[500]:STRING
  DEF iiii,tttt,oldshowx
	DEF inw,inh
  oldshowx:=showx
  window:=NIL
  IF StrLen(filename)<1 THEN Raise(E_NONE)
  IF ((scr:=LockPubScreen('Workbench'))=0) THEN Raise(L_EF_PUBSCREEN)
  visual:=GetVisualInfoA(scr,NIL)
  viewport:=scr.viewport
  colormap:=viewport.colormap
  bitmap:=scr.bitmap
  depth:=bitmap.depth
  IF (curbitmap:=myallocbitmap(maxiwidth,maxiheight,8,BMF_CLEAR OR BMF_STANDARD,NIL))=NIL THEN Raise(L_EF_CHIPBUFFER)

  IF (currast:=New(SIZEOF rastport))=NIL THEN Raise(L_EF_FATAL)
  InitRastPort(currast);currast.bitmap:=curbitmap

  screenattr:=scr.font
  sfonth:=screenattr.ysize

  IF mode<>MODE_QUIET
		inw:=bigger(300,12*StrLen(FilePart(filename)))
		inh:=sfonth*3+20-((totfile>1)*(sfonth+4))
    IF winx=-1 THEN winx:=(((scr.width-300)/2))
    IF winy=-1 THEN winy:=(((scr.height-(sfonth*2+16))/2))
    window:=OpenWindowTagList(0,[WA_LEFT,winx,
      WA_TOP,winy,
      WA_INNERWIDTH,inw,
      WA_INNERHEIGHT,inh,
      WA_FLAGS,WFLG_DRAGBAR OR WFLG_DEPTHGADGET,
      WA_TITLE,sl[L_TEXTTITLE],
      WA_CUSTOMSCREEN,scr,
      WA_AUTOADJUST,TRUE,
      NIL,NIL])
    rast:=window.rport
    screenfont:=OpenFont(scr.font)
    IF screenfont THEN SetFont(rast,screenfont)
    fgx:=4+window.borderleft
    fgw:=window.width-(8+window.borderleft+window.borderright)
    fgh:=window.height-(window.bordertop+4+window.borderbottom)-(sfonth*2)-8+((totfile>1)*(sfonth+4))
    fgy:=window.height-(sfonth*2)-18


		SetAPen(rast,2)
		shadowtext(rast,fgx,fgy+6+fgh+screenfont.baseline,'0%',2)
		shadowtext(rast,fgx+fgw-TextLength(rast,'100%',4),fgy+fgh+6+screenfont.baseline,'100%',4)
		shadowtext(rast,fgx+(fgw/2)-(TextLength(rast,'50%',3)/2),fgy+fgh+6+screenfont.baseline,'50%',3)
		shadowtext(rast,fgx+(fgw/4)-(TextLength(rast,'25%',3)/2),fgy+fgh+6+screenfont.baseline,'25%',3)
		shadowtext(rast,fgx+(fgw*3/4)-(TextLength(rast,'75%',3)/2),fgy+fgh+6+screenfont.baseline,'75%',3)

    StringF(heystring,sl[L_PICTURE],FilePart(filename))
    SetAPen(rast,1)
    Move(rast,fgx+(fgw/2)-(TextLength(rast,heystring,StrLen(heystring))/2),window.bordertop+3+screenfont.baseline)
    Text(rast,heystring,StrLen(heystring))

		shadowline(rast,fgx,fgy+1+fgh,fgx,fgy+4+fgh)
		shadowline(rast,fgx+fgw-2,fgy+1+fgh,fgx+fgw-2,fgy+4+fgh)
		shadowline(rast,fgx+(fgw/2),fgy+1+fgh,fgx+(fgw/2),fgy+4+fgh)
		shadowline(rast,fgx+(fgw/4),fgy+1+fgh,fgx+(fgw/4),fgy+4+fgh)
		shadowline(rast,fgx+(fgw*3/4),fgy+1+fgh,fgx+(fgw*3/4),fgy+4+fgh)

    IF totfile>1
      StringF(heystring,sl[L_FILEOF],curfile,totfile)
      Move(rast,fgx+(fgw/2)-(TextLength(rast,heystring,StrLen(heystring))/2),window.bordertop+5+screenfont.baseline+screenfont.ysize)
      Text(rast,heystring,StrLen(heystring))
    ENDIF
  ENDIF

  IF (diskobj:=GetDiskObject(templatename))=NIL
    IF (diskobj:=GetDiskObject('ENV:sys/def_picture'))=NIL
      diskobj:=GetDefDiskObject(WBPROJECT)
    ENDIF
  ENDIF
  SetAPen(currast,0)
  SetBPen(currast,0)
  RectFill(currast,0,0,maxiw,maxih)
  IF (backobj:=GetDiskObject(backname))
    gadget:=backobj.gadget
    copyimagerast(currast,gadget.gadgetrender)
  ENDIF
  doloaddt(currast,filename)

  IF showflag
    StringF(sizestr,'\dx\d',bitsizex,bitsizey)
    IF showx=-1 THEN showx:=posx+(sizex/2)-((StrLen(sizestr)*6)/2)
    IF showy=-1 THEN showy:=1

    IF texttype=TEXT_OUTLINE
      FOR tttt:=-1 TO 1
        FOR iiii:=-1 TO 1
          showpicsize(showx+iiii,showy+tttt,black,sizestr)
        ENDFOR
      ENDFOR
    ENDIF
    IF texttype=TEXT_SHADOW THEN showpicsize(showx+1,showy+1,black,sizestr)
    showpicsize(showx,showy,white,sizestr)
  ENDIF
  showx:=oldshowx
  IF goodload
    saveicon()
  ENDIF
  Raise(E_NONE)
EXCEPT
  IF visual THEN FreeVisualInfo(visual);visual:=NIL
  IF scr THEN UnlockPubScreen(0,scr);scr:=NIL
  IF curbitmap THEN myfreebitmap(curbitmap);curbitmap:=NIL
  IF currast THEN Dispose(currast);currast:=NIL
  IF diskobj THEN FreeDiskObject(diskobj);diskobj:=NIL
  IF backobj THEN FreeDiskObject(backobj);backobj:=NIL
  IF window
    winx:=window.leftedge;winy:=window.topedge
    CloseWindow(window);window:=NIL
  ENDIF
  IF screenfont THEN CloseFont(screenfont);screenfont:=NIL
  handleexception(exception)
ENDPROC

PROC shadowline(rast,x1,y1,x2,y2)
	DEF drawinfo=NIL:PTR TO drawinfo
	IF (drawinfo:=GetScreenDrawInfo(scr))
		SetAPen(rast,Int(drawinfo.pens+(SHINEPEN*2)))
		Move(rast,x1+1,y1+1)
		Draw(rast,x2+1,y2+1)
		SetAPen(rast,Int(drawinfo.pens+(SHADOWPEN*2)))
		Move(rast,x1,y1)
		Draw(rast,x2,y2)
		FreeScreenDrawInfo(scr,drawinfo)
	ENDIF
ENDPROC

PROC shadowtext(rast,x1,y1,x2,y2)
	DEF drawinfo=NIL:PTR TO drawinfo
	IF (drawinfo:=GetScreenDrawInfo(scr))
		SetDrMd(rast,RP_JAM1)
/*		SetAPen(rast,Int(drawinfo.pens+(SHINEPEN*2)))
		Move(rast,x1+1,y1+1)
		Text(rast,x2,y2)*/
		SetAPen(rast,Int(drawinfo.pens+(SHADOWPEN*2)))
		Move(rast,x1,y1)
		Text(rast,x2,y2)
		FreeScreenDrawInfo(scr,drawinfo)
		SetDrMd(rast,RP_JAM2)
	ENDIF
ENDPROC

PROC saveicon() HANDLE

  DEF ire
  DEF mydiskobj=NIL:PTR TO diskobject

  mydiskobj:=diskobj

  IF mode=MODE_CLI THEN WriteF('\n')
  displaymessage(sl[L_SAVING],TRUE)
  creatediskobj(mydiskobj,currast)

  IF (ire:=PutDiskObject(filename,mydiskobj))=NIL THEN Raise(L_E_NOWRITEICON)

  Raise(E_NONE)
EXCEPT
  restorediskobj(mydiskobj)
  handleexception(exception)
ENDPROC

PROC displaypercent(done,max)
  DEF perc,newpx
  perc:=done*100/max
  IF mode=MODE_CLI
    WriteF(sl[L_PERCENT],{controlstring},perc)
  ELSE
    IF (((mode=MODE_WB) OR (mode=MODE_APP)) AND (window) AND (rast))
      IF oldpx<0 THEN oldpx:=fgx+3
      SetAPen(rast,3)
      newpx:=fgx+(((fgw-5)*100)/(10000/(bigger(perc,1))))
      RectFill(rast,oldpx,fgy+2,fgx+(((fgw-5)*100)/(10000/(bigger(perc,1)))),fgy+fgh-4)
      oldpx:=newpx
      IF visual
        DrawBevelBoxA(rast,fgx,fgy,fgw,fgh,[GT_VISUALINFO,visual,
          GTBB_RECESSED,TRUE,GTBB_FRAMETYPE,BBFT_BUTTON,NIL,NIL])
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC displaymessage(msg,flag)
  IF mode=MODE_CLI
    WriteF('\s\n',msg)
  ELSE
    IF (((mode=MODE_WB) OR (mode=MODE_APP)) AND (window) AND (rast))
      IF flag<>0
        SetAPen(rast,0)
        RectFill(rast,fgx+2,fgy+1,fgx+fgw-4,fgy+fgh-2)
      ELSE
        SetDrMd(rast,RP_JAM1)
      ENDIF
      Move(rast,fgx+(fgw/2)-(TextLength(rast,msg,StrLen(msg))/2),fgy+fgh-(screenfont.ysize-screenfont.baseline)-3)
      SetAPen(rast,1)
      Text(rast,msg,StrLen(msg))
      SetDrMd(rast,RP_JAM2)
      IF visual
        DrawBevelBoxA(rast,fgx,fgy,fgw,fgh,[GT_VISUALINFO,visual,
          GTBB_RECESSED,TRUE,GTBB_FRAMETYPE,BBFT_BUTTON,NIL,NIL])
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC doloaddt(destination,unitnumber) HANDLE
  DEF dtf=NIL:PTR TO dtframebox,fri=NIL:PTR TO frameinfo
  DEF obj=NIL,gpl=NIL:PTR TO gplayout
  DEF destrgb1[260]:LIST
  DEF cregs=NIL,numcolors,bmhd=NIL:PTR TO bitmapheader,bm=NIL:PTR TO bitmap
  DEF dtrast=NIL:PTR TO rastport
  DEF destbm
  DEF cmap,asshole
  DEF scale
  DEF red[260]:LIST,grn[260]:LIST,blu[260]:LIST
  DEF cx,cy,cred,cgrn,cblu,resu,nco,collate
  DEF oposx,oposy,a1,a2,a3
  DEF scratchscale,dummyscale
  DEF rdiff,gdiff,bdiff,radd,gadd,badd,rreal,greal,breal

  goodload:=FALSE;destbm:=curbitmap;cmap:=colormap
  displaymessage(sl[L_LOADING],TRUE)
  obj:=NewDTObjectA(unitnumber,[DTA_SOURCETYPE,DTST_FILE,
                DTA_GROUPID,GID_PICTURE,
                PDTA_REMAP,FALSE,
                NIL,NIL])
  IF obj
    dtf:=New(60)
    fri:=New(60)
    PutLong(dtf,DTM_FRAMEBOX)
    dtf.frameinfo:=fri
    dtf.contentsinfo:=fri
    dtf.sizeframeinfo:=SIZEOF frameinfo
    IF (domethod(obj,dtf))
      gpl:=New(60)
      PutLong(gpl,DTM_PROCLAYOUT)
      gpl.ginfo:=NIL
      gpl.initial:=1
      IF (domethod(obj,gpl))
        GetDTAttrsA(obj,
            [PDTA_CREGS,{cregs},
            PDTA_BITMAP,{bm},
            PDTA_NUMCOLORS,{numcolors},
            PDTA_BITMAPHEADER,{bmhd},
            NIL,NIL])
        body:=cregs
        dtrast:=New(SIZEOF rastport)
        dtrast.bitmap:=bm
        IF dtrast.bitmap<>NIL

          displaymessage(sl[L_SCALING],TRUE);oldpx:=-1

          white:=findcolor(cmap,255,255,255)
          black:=findcolor(cmap,0,0,0)
          asshole:=1
          bitsizey:=bmhd.height;bitsizex:=bmhd.width
          IF ((sizey<bitsizey) OR (sizex<bitsizex)) THEN asshole:=0
          FOR scratch:=0 TO (Shl(1,(bmhd.depth))-1)
            ditz:=Char(body)  /* RED 0-255 */
            body:=body+4
            dang:=Char(body)  /* GREEN 0-255 */
            body:=body+4
            dumb:=Char(body)  /* BLUE 0-255 */
            body:=body+4
            IF asshole<>0
              destrgb1[scratch]:=findcolor(cmap,ditz,dang,dumb)
            ENDIF
            red[scratch]:=ditz
            grn[scratch]:=dang
            blu[scratch]:=dumb
          ENDFOR

/*          IF (asshole=1)
            minimumx:=smaller((sizex-posx),bitsizex)-1
            minimumy:=smaller((sizey-posy),bitsizey)-1
            oposx:=posx;oposy:=posy
            IF centerflag
              oposx:=posx+( (sizex-minimumx)/2 )
              oposy:=posy+( (sizey-minimumy)/2 )
            ENDIF
            FOR scratch:=0 TO minimumy
              FOR dummy:=0 TO minimumx
                SetAPen(destination,destrgb1[ReadPixel(dtrast,dummy,scratch)])
                WritePixel(destination,oposx+dummy,oposy+scratch)
              ENDFOR
              displaypercent(scratch,minimumy)
              IF mode<>MODE_CLI THEN displaymessage(sl[L_REMAPPING],0)
            ENDFOR
            goodload:=TRUE
          ELSE */

            grabrgbtables()
            IF dither
              rawdata:=New(Mul(maxiwidth,32))
              IF rawdata=0 THEN Raise(L_EF_MEMORY)
            ENDIF
            IF asshole
              minimumx:=smaller((sizex-posx),bitsizex)-1
              minimumy:=smaller((sizey-posy),bitsizey)-1
              oposx:=posx;oposy:=posy
              IF centerflag
                oposx:=posx+( (sizex-minimumx)/2 )
                oposy:=posy+( (sizey-minimumy)/2 )
              ENDIF
              scale:=1
            ELSE
              scale:=bigger(((bitsizex/sizex)),((bitsizey/sizey)))+1
              minimumx:=(bitsizex/scale)-1
              minimumy:=(bitsizey/scale)-1
              oposx:=posx;oposy:=posy
              IF centerflag
                oposx:=posx+( (sizex-(bitsizex/scale))/2 )
                oposy:=posy+( (sizey-(bitsizey/scale))/2 )
              ENDIF
            ENDIF
						a1:=0;a2:=minimumx;a3:=1
            FOR scratch:=0 TO minimumy
							dummy:=a1
							WHILE (dummy<>(a2+a3))
                nco:=NIL;cred:=NIL;cgrn:=NIL;cblu:=NIL
                dummyscale:=dummy*scale
                scratchscale:=scratch*scale
                FOR cy:=0 TO scale-1
                  FOR cx:=0 TO scale-1
                    collate:=ReadPixel(dtrast,dummyscale+cx,scratchscale+cy)
                    cred:=cred+red[collate]
                    cgrn:=cgrn+grn[collate]
                    cblu:=cblu+blu[collate]
                    nco:=nco+1
                  ENDFOR
                ENDFOR
                IF dither=FALSE
                  resu:=findcolor(cmap,(cred/nco),(cgrn/nco),(cblu/nco))
                  SetAPen(destination,resu)
                  WritePixel(destination,dummy+oposx,scratch+oposy)
                ELSE

                  resu:=findcolor(cmap,limit(((cred/nco)+rawred(dummy,0)),0,255),limit(((cgrn/nco)+rawgrn(dummy,0)),0,255),limit(((cblu/nco)+rawblu(dummy,0)),0,255))


                  rdiff:=(cred/nco)-redt[resu]
                  gdiff:=(cgrn/nco)-grnt[resu]
                  bdiff:=(cblu/nco)-blut[resu]

                  SetAPen(destination,resu)
                  WritePixel(destination,dummy+oposx,scratch+oposy)

									IF ((Abs(rdiff)+Abs(gdiff)+Abs(bdiff))>ignore)

	                  rreal:=threshold(limit((rdiff*div1)/rem1,0-lim,lim),thres)
  	                greal:=threshold(limit((gdiff*div1)/rem1,0-lim,lim),thres)
    	              breal:=threshold(limit((bdiff*div1)/rem1,0-lim,lim),thres)
      	            radd:=rawred(dummy+a3,0)+rreal
        	          gadd:=rawgrn(dummy+a3,0)+greal
          	        badd:=rawblu(dummy+a3,0)+breal
            	      setraw(dummy+a3,0,radd,gadd,badd)
	
  	                rreal:=threshold(limit((rdiff*div2)/rem2,-lim,lim),thres)
    	              greal:=threshold(limit((gdiff*div2)/rem2,-lim,lim),thres)
      	            breal:=threshold(limit((bdiff*div2)/rem2,-lim,lim),thres)
        	          radd:=rawred(dummy-a3,1)+rreal
          	        gadd:=rawgrn(dummy-a3,1)+greal
  	                badd:=rawblu(dummy-a3,1)+breal
            	      setraw(dummy-a3,1,radd,gadd,badd)
	
	                  rreal:=threshold(limit((rdiff*div3)/rem3,-lim,lim),thres)
  	                greal:=threshold(limit((gdiff*div3)/rem3,-lim,lim),thres)
    	              breal:=threshold(limit((bdiff*div3)/rem3,-lim,lim),thres)
      	            radd:=rawred(dummy,1)+rreal
        	          gadd:=rawgrn(dummy,1)+greal
          	        badd:=rawblu(dummy,1)+breal
            	      setraw(dummy,1,radd,gadd,badd)

	                  rreal:=threshold(limit((rdiff*div4)/rem4,-lim,lim),thres)
  	                greal:=threshold(limit((gdiff*div4)/rem4,-lim,lim),thres)
    	              breal:=threshold(limit((bdiff*div4)/rem4,-lim,lim),thres)
      	            radd:=rawred(dummy+a3,1)+rreal
        	          gadd:=rawgrn(dummy+a3,1)+greal
          	        badd:=rawblu(dummy+a3,1)+breal
            	      setraw(dummy+a3,1,radd,gadd,badd)
									ENDIF
                ENDIF
								dummy:=dummy+a3
              ENDWHILE
							IF twopass=TRUE;dummy:=a1;a1:=a2;a2:=dummy;a3:=0-a3;ENDIF
              displaypercent(scratch,minimumy)
              IF mode<>MODE_CLI THEN displaymessage(sl[L_SCALING],0)
              IF ((dither) AND (rawdata))
                FOR dummy:=0 TO maxiw
                  setraw(dummy,0,rawred(dummy,1),rawgrn(dummy,1),rawblu(dummy,1))
                  setraw(dummy,1,0,0,0)
                ENDFOR
              ENDIF
            ENDFOR
            goodload:=TRUE
/*          ENDIF*/
        ELSE
          Raise(L_E_DATATYPE)
        ENDIF
      ELSE
        Raise(L_E_DATATYPE)
      ENDIF
    ELSE
      Raise(L_E_DATATYPE)
    ENDIF
  ELSE
    Raise(L_E_NOPICTURE)
  ENDIF
  Raise(E_NONE)
EXCEPT
  IF rawdata THEN Dispose(rawdata);rawdata:=NIL
  IF dtrast THEN Dispose(dtrast);dtrast:=NIL
  IF obj THEN DisposeDTObject(obj);obj:=NIL
  IF gpl THEN Dispose(gpl);gpl:=NIL
  IF dtf THEN Dispose(dtf);dtf:=NIL
  IF fri THEN Dispose(fri);fri:=NIL
  IF exception<>E_NONE
    errormessage(exception)
  ENDIF
  IF quitter THEN leave(quitter)
ENDPROC

PROC showpicsize(x,y,p,s)
  DEF ii,tt,uu,mm,charptr,xptr,ysize=6
  charptr:={chardata}
  xptr:={xdata}
  IF tallfont
    ysize:=8
    charptr:={chardatal}
    xptr:={xdatal}
  ENDIF
  SetAPen(currast,p)
  FOR ii:=0 TO (StrLen(s)-1)
    mm:=Char(s+ii)
    FOR tt:=0 TO (ysize-1)
      FOR uu:=0 TO 5
        IF mm<>"x"
          IF Char(charptr+uu+(tt*8)+((mm-48)*(8*ysize)))="x"
            WritePixel(currast,smaller(bigger(x+uu+(ii*6),0),maxiw),smaller(bigger(y+tt,0),maxih))
          ENDIF
        ELSE
          IF Char(xptr+uu+(tt*8))="x"
            WritePixel(currast,smaller(bigger(x+uu+(ii*6),0),maxiw),smaller(bigger(y+tt,0),maxih))
          ELSE
          ENDIF
        ENDIF
      ENDFOR
    ENDFOR
  ENDFOR

ENDPROC
PROC dosleep()
  DEF sleepobject=NIL:PTR TO diskobject
  DEF appobject=NIL:PTR TO diskobject
  DEF appport=NIL:PTR TO mp
  DEF appflag=NIL
  DEF appicon,appitem,newproj[250]:STRING
  DEF lockname[250]:STRING,newlock=NIL
  DEF amsg:PTR TO appmessage
  DEF argptr:PTR TO wbarg
  DEF lofal
  DEF agadget:PTR TO gadget

  StrCopy(appname,sleepername,ALL)
  IF (sleepobject:=GetDiskObject(appname))=NIL
    IF (sleepobject:=GetDiskObject('ENV:SYS/def_appicon'))=NIL
      StrCopy(appname,progname,ALL)
      IF (sleepobject:=GetDiskObject(appname))=NIL
        sleepobject:=GetDefDiskObject(WBTOOL)
      ENDIF
    ENDIF
  ENDIF
  IF sleepobject
    sleepobject.type:=NIL
    appobject:=sleepobject
    agadget:=appobject.gadget
    IF appx<0
      agadget.leftedge:=NO_ICON_POSITION
      appobject.currentx:=NO_ICON_POSITION
    ELSE
      agadget.leftedge:=appx
      appobject.currentx:=appx
    ENDIF
    IF appy<0
      agadget.topedge:=NO_ICON_POSITION
      appobject.currenty:=NO_ICON_POSITION
    ELSE
      agadget.topedge:=appy
      appobject.currenty:=appy
    ENDIF

    IF (appport:=CreateMsgPort())
      IF (appicon:=AddAppIconA(0,0,'Picticon',appport,0,appobject,NIL))<>NIL
				IF (appitem:=AddAppMenuItemA(0,0,'Picticon',appport,0))<>NIL
	        WHILE appflag=NIL
  	        WaitPort(appport)
    	      WHILE (amsg:=GetMsg(appport))<>NIL
      	      IF amsg.numargs=0
        	      IF EasyRequestArgs(0, [20, 0, sl[L_TITLE], sl[L_BODY],sl[L_BUTTONS]], 0, 0)
          	      appflag:=TRUE
            	  ENDIF
	            ELSE
  	            argptr:=amsg.arglist
    	          curfile:=0;totfile:=amsg.numargs
      	        FOR lofal:=1 TO amsg.numargs
        	        StrCopy(newproj,argptr.name,ALL)
          	      newlock:=argptr.lock
            	    IF newlock
              	    NameFromLock(newlock,lockname,250)
                	  processname(filename,lockname,newproj)
                  	curfile:=curfile+1
	                  processicon()
  	              ENDIF
    	            argptr:=argptr+(SIZEOF wbarg)
      	        ENDFOR
        	    ENDIF
          	  ReplyMsg(amsg)
         	 ENDWHILE
	        ENDWHILE
  	      RemoveAppMenuItem(appitem)
				ENDIF
 	      RemoveAppIcon(appicon)
      ENDIF
 	    WHILE (amsg:=GetMsg(appport))<>NIL
   	    ReplyMsg(amsg)
     	ENDWHILE
      DeleteMsgPort(appport)
    ENDIF
    IF sleepobject THEN FreeDiskObject(sleepobject);sleepobject:=NIL
  ENDIF
ENDPROC
PROC handwb()
  DEF wb:PTR TO wbstartup,args:PTR TO wbarg
  DEF argarray[30]:LIST,olddir,rdarg,s,wstr[500]:STRING
  DEF locs

  IF wbmessage<>NIL /* E provides us with WB's startup message in this variable */
    wb:=wbmessage;args:=wb.arglist
    olddir:=CurrentDir(args.lock)

    IF args.name>0
      GetCurrentDirName(progname,500)
      StrAdd(progname,args.name,ALL)
      toolobject:=GetDiskObjectNew(progname)
    ENDIF

    IF toolobject<>NIL  /* If we succeded in opening our program icon. */
      IF s:=FindToolType(toolobject.tooltypes,'MAXIWIDTH')
        StrToLong(s,{maxiwidth})
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'MAXIHEIGHT')
        StrToLong(s,{maxiheight})
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'APPICON')
        StrCopy(sleepername,s,ALL)
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'TEMPLATE_ICON')
        StrCopy(templatename,s,ALL)
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'BACKGROUND_ICON')
        StrCopy(backname,s,ALL)
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'CHUNKYMODE')
        IF MatchToolValue(s,'yes')
          chunkyflag:=TRUE
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'FORCE_EIGHT')
        IF MatchToolValue(s,'yes')
          force8:=TRUE
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'CENTER')
        IF MatchToolValue(s,'yes')
          centerflag:=TRUE
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'HIGHPEN')
        StrToLong(s,{first4})
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'FIRSTFOUR')
        IF MatchToolValue(s,'yes')
          first4:=3
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'FREE_ICON_POS')
        IF MatchToolValue(s,'yes')
          freeme:=TRUE
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'PIC_X_POS')
        StrToLong(s,{posx})
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'PIC_Y_POS')
        StrToLong(s,{posy})
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'APP_X_POS')
        StrToLong(s,{appx})
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'APP_Y_POS')
        StrToLong(s,{appy})
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'PIC_X_SIZE')
        StrToLong(s,{sizex})
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'PIC_Y_SIZE')
        StrToLong(s,{sizey})
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'SHOWSIZE_X')
        StrToLong(s,{showx})
        showflag:=TRUE
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'SHOWSIZE_Y')
        StrToLong(s,{showy})
        showflag:=TRUE
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'LOWPRI')
        IF MatchToolValue(s,'yes')
          SetTaskPri(FindTask(0),-1)
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'SHOWSIZE_OUTLINE')
        IF MatchToolValue(s,'yes')
          texttype:=TEXT_OUTLINE
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'SHOWSIZE_NORMAL')
        IF MatchToolValue(s,'yes')
          texttype:=TEXT_NORMAL
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'SHOWSIZE_TALL')
        IF MatchToolValue(s,'yes')
          tallfont:=TRUE
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'QUIET')
        IF MatchToolValue(s,'yes')
          quietflag:=TRUE
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'DITHER')
        IF MatchToolValue(s,'no')
          dither:=FALSE
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'TWOPASS')
        IF MatchToolValue(s,'yes')
          twopass:=TRUE
				ELSE
          twopass:=FALSE
        ENDIF
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'D_THRESHOLD')
        StrToLong(s,{thres})
				thres:=limit(thres,0,128)
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'D_IGNORE')
        StrToLong(s,{ignore})
				ignore:=limit(ignore,0,750)
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'D_LIMIT')
        StrToLong(s,{lim})
				lim:=limit(lim,thres,1024)
      ENDIF
      IF s:=FindToolType(toolobject.tooltypes,'D_TYPE')
        StrToLong(s,{typ})
				typ:=limit(typ,0,5)
				SELECT typ
				CASE 1
					div1:=7;rem1:=16;div2:=3;rem2:=16;div3:=5;rem3:=16;div4:=1;rem4:=16
				CASE 2
					div1:=1;rem1:=2;div2:=0;rem2:=1;div3:=1;rem3:=2;div4:=0;rem4:=1
				CASE 3
					div1:=0;rem1:=1;div2:=1;rem2:=2;div3:=0;rem3:=1;div4:=1;rem4:=2
				CASE 4
					div1:=1;rem1:=1;div2:=0;rem2:=1;div3:=0;rem3:=1;div4:=0;rem4:=1
				CASE 5
					div1:=1;rem1:=4;div2:=1;rem2:=4;div3:=1;rem3:=4;div4:=1;rem4:=4
				ENDSELECT
      ENDIF

    ENDIF
    IF wb.numargs>1
      totfile:=wb.numargs-1
      curfile:=1
      FOR locs:=2 TO wb.numargs
        olddir:=args[].lock++
        IF args.lock
          olddir:=CurrentDir(args.lock)
          GetCurrentDirName(filename,250)
          NameFromLock(args.lock,wstr,240)
          CurrentDir(olddir)
          processname(filename,wstr,args.name)
          mode:=MODE_WB
          enforcemax()
          processicon()
        ENDIF
        curfile:=curfile+1
      ENDFOR
    ELSE
      mode:=MODE_APP
      enforcemax()
      dosleep()
    ENDIF
  ELSE
    FOR scratch:=0 TO 30
      argarray[scratch]:=NIL
    ENDFOR
    rdarg:=ReadArgs('FILE,TEMPLATE=T/K,MAXIWIDTH=MW/N,MAXIHEIGHT=MH/N,CHUNKY=CM/S,FORCEEIGHT=F8/S,HIGHPEN=HP/N,BACKICON=BI/K',argarray,0)
    IF rdarg
      IF argarray[0]
        StrCopy(filename,argarray[0],ALL)
      ENDIF
      IF argarray[1]
        StrCopy(templatename,argarray[1],ALL)
        stripinfo(templatename)
      ENDIF
      IF argarray[2]
        maxiwidth:=argarray[2]
        maxiwidth:=^maxiwidth
      ENDIF
      IF argarray[3]
        maxiheight:=argarray[3]
        maxiheight:=^maxiheight
      ENDIF
      IF argarray[4]
        chunkyflag:=TRUE
      ENDIF
      IF argarray[5]
        force8:=TRUE
      ENDIF
      IF argarray[6]
        first4:=argarray[6]
        first4:=^first4
      ENDIF
      IF argarray[7]
        StrCopy(backname,argarray[7],ALL)
        stripinfo(backname)
      ENDIF
      FreeArgs(rdarg);rdarg:=NIL
    ENDIF
    mode:=MODE_CLI
    enforcemax()
    processicon()
  ENDIF
ENDPROC
PROC enforcemax()
    IF maxiwidth<32 THEN maxiwidth:=32
    IF maxiwidth>1024 THEN maxiwidth:=1024
    IF maxiheight<32 THEN maxiheight:=32
    IF maxiheight>1024 THEN maxiheight:=1024
    maxiw:=maxiwidth-1
    maxih:=maxiheight-1
    IF quietflag
      mode:=MODE_QUIET
    ENDIF
    IF sizex>maxiw THEN sizex:=maxiw
    IF sizey>maxih THEN sizey:=maxih
    IF posx>=maxiw THEN posx:=maxiw-1
    IF posy>=maxih THEN posy:=maxih-1
    IF posx+sizex>maxiw THEN sizex:=maxiw-posx
    IF posy+sizey>maxih THEN sizey:=maxih-posy
    IF ((posx) OR (posy) OR (sizex) OR (sizey)) THEN posflag:=TRUE
    IF sizex=0 THEN sizex:=maxiw-posx
    IF sizey=0 THEN sizey:=maxih-posy
ENDPROC
PROC loadcatalog()
  IF localebase
    catalog:=OpenCatalogA(NIL,'picticon.catalog',[OC_BUILTINLANGUAGE,'english',NIL,NIL])
  ENDIF
  readstrings()
  FOR scratch:=0 TO L_ENDS
    sl[scratch]:=locale(scratch)
  ENDFOR
ENDPROC
PROC locale(strnum)
  DEF stpoint,defstr
  defstr:=sl[strnum]
  IF ((localebase) AND (catalog))
    stpoint:=GetCatalogStr(catalog,strnum,defstr)
  ELSE
    stpoint:=defstr
  ENDIF
ENDPROC stpoint
PROC readstrings()
  DEF buf,res=0
  buf:={catstrs}
  WHILE(Int(buf))<>0
    res:=res+1
    IF res>0 AND res<300
      sl[res]:=buf
    ENDIF
    WHILE Char(buf)<>"¶"
      buf:=buf+1
    ENDWHILE
    PutChar(buf,0)
    buf:=buf+2
    buf:=(Mul(Div((buf+1),2),2))
  ENDWHILE
ENDPROC
PROC savewinpos() HANDLE
  DEF buffer=NIL

  iff:=AllocIFF()
  iff.stream:=Open('ENV:Picticon.prefs',MODE_NEWFILE)
  IF (iff.stream)=NIL THEN Raise(E_NONE)
  InitIFFasDOS(iff)
  buffer:=New(100)
  ierror:=OpenIFF(iff,IFFF_WRITE)
  IF ierror THEN Raise(E_NONE)
  PushChunk(iff,"PREF","FORM",IFFSIZE_UNKNOWN)

   PushChunk(iff,"PREF","PRHD",IFFSIZE_UNKNOWN)
    PutLong(buffer,0);PutLong(buffer+2,0)
    WriteChunkBytes(iff,buffer,6)
   PopChunk(iff)

   PushChunk(iff,"PREF","WIND",IFFSIZE_UNKNOWN)
    dumb:=buffer
    PutLong(dumb,winx);PutLong(dumb+4,winy)
    WriteChunkBytes(iff,buffer,8)
   PopChunk(iff)

  PopChunk(iff)
  Raise(E_NONE)
EXCEPT
  IF buffer THEN Dispose(buffer);buffer:=NIL
  freeiff(666)
  handleexception(exception)
ENDPROC
PROC loadwinpos() HANDLE
  DEF buffer=NIL

  iff:=AllocIFF()
  iff.stream:=Open('ENV:Picticon.prefs',MODE_OLDFILE)
  IF (iff.stream)=NIL THEN Raise(E_NONE)
  InitIFFasDOS(iff)
  buffer:=New(100)
  ierror:=OpenIFF(iff,IFFF_READ)
  IF ierror THEN Raise(E_NONE)
  ierror:=PropChunk(iff,"PREF","WIND")
  ierror:=StopOnExit(iff,"PREF","FORM")
  ierror:=ParseIFF(iff,IFFPARSE_SCAN)

  IF (sp:=FindProp(iff,"PREF","WIND"))
    dumb:=sp.data
    winx:=Long(dumb);winy:=Long(dumb+4)
  ENDIF

  Raise(E_NONE)
EXCEPT
  IF buffer THEN Dispose(buffer)
  freeiff(666)
  handleexception(exception)
ENDPROC
PROC freeiff(unit)
  IF iff
    CloseIFF(iff)
    IF (iff.stream) THEN Close(iff.stream)
    FreeIFF(iff)
    iff:=NIL
  ENDIF
ENDPROC
PROC openlibs()
  IF (aslbase:=OpenLibrary('asl.library', 36))=NIL THEN CleanUp(25)
  localebase:=OpenLibrary('locale.library',37)
  loadcatalog()
  datatypesbase:=safeopenlibrary('datatypes.library',39)
  mathtransbase:=safeopenlibrary('mathtrans.library',36)
  gadtoolsbase:=safeopenlibrary('gadtools.library',36)
  workbenchbase:=safeopenlibrary('workbench.library',36)
  iconbase:=safeopenlibrary('icon.library', 36)
  iffparsebase:=safeopenlibrary('iffparse.library',36)
  diskfontbase:=safeopenlibrary('diskfont.library', 36)
/*  newiconbase:=OpenLibrary('newicon.library', 36)
  IF newiconbase THEN newiconmode:=TRUE */
  IF KickVersion(39);osversion:=TRUE;ELSE;osversion:=FALSE;ENDIF
ENDPROC
PROC safeopenlibrary(name,vers) HANDLE
  DEF lret
  IF ((lret:=OpenLibrary(name,vers))=NIL) THEN Raise(L_EF_LIBRARY)
  Raise(E_NONE)
EXCEPT
  handleexception(exception)
ENDPROC lret
PROC handleexception(except)
  IF except<>E_NONE THEN errormessage(except)
  IF quitter THEN leave(quitter)
ENDPROC
PROC closelibs()
  IF newiconbase THEN CloseLibrary(newiconbase)
  IF diskfontbase THEN CloseLibrary(diskfontbase)
  IF aslbase THEN CloseLibrary(aslbase)
  IF iffparsebase THEN CloseLibrary(iffparsebase)
  IF iconbase THEN CloseLibrary(iconbase)
  IF workbenchbase THEN CloseLibrary(workbenchbase)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF datatypesbase THEN CloseLibrary(datatypesbase)
  IF layersbase THEN CloseLibrary(layersbase)
  IF keymapbase THEN CloseLibrary(keymapbase)
  IF mathtransbase THEN CloseLibrary(mathtransbase)
  IF localebase THEN CloseLibrary(localebase)
ENDPROC
PROC errormessage(errnum)
  IF errnum>=L_EF_FATAL
    errmsg(sl[errnum])
    quitter:=TRUE
  ELSE
    IF errnum>=L_E_GENERAL
      errmsg(sl[errnum])
    ELSE
      errmsg(sl[L_E_GENERAL])
    ENDIF
  ENDIF
ENDPROC
PROC errmsg(msgptr)
  IF mode=MODE_CLI
    WriteF('\s\n\n',msgptr)
  ELSE
    IF ((mode=MODE_WB) OR (mode=MODE_APP))
      displaymessage(msgptr,TRUE)
      Delay(80)
    ENDIF
  ENDIF
ENDPROC
PROC sp_div_tf_tf_f(int1,int2)
  RETURN SpDiv(SpFlt(int1),SpFlt(int2))
ENDPROC
PROC leave(flag)
  IF catalog THEN CloseCatalog(catalog)
  IF appimagedata THEN FreeMem(appimagedata,3200);appimagedata:=NIL
  IF curbitmap THEN myfreebitmap(curbitmap);curbitmap:=NIL
  IF diskobj THEN FreeDiskObject(diskobj);diskobj:=NIL
  IF visual THEN FreeVisualInfo(visual);visual:=NIL
  IF toolobject THEN FreeDiskObject(toolobject);toolobject:=NIL

  closelibs()
  IF flag
    IF flag=TRUE
      CleanUp(0)
    ELSE
      CleanUp(flag)
    ENDIF
  ENDIF
ENDPROC

PROC myallocbitmap(w,h,d,type,tags)
  IF osversion=TRUE
    RETURN AllocBitMap(w,h,d,type,tags)
  ENDIF
ENDPROC

PROC myfreebitmap(bm)
  IF osversion=TRUE
    RETURN FreeBitMap(bm)
  ELSE
  ENDIF
ENDPROC

PROC findcolor(colap,ared,agrn,ablu)
  DEF pointred,pointgrn,pointblu,mpen
  mpen:=-1
  IF (first4>0) THEN mpen:=first4
  pointred:=Shl(Shl(Shl(ared,8),8),8)
  pointgrn:=Shl(Shl(Shl(agrn,8),8),8)
  pointblu:=Shl(Shl(Shl(ablu,8),8),8)
  RETURN FindColor(colap,pointred,pointgrn,pointblu,mpen)
ENDPROC

PROC mygetrgb32(colmap,first,ncolors,table)
  DEF rre,eee
  IF osversion=TRUE
    GetRGB32(colmap,first,ncolors,table)
  ELSE
    rre:=GetRGB4(colmap,first)
    eee:=(rre AND $F)
    PutChar(table,eee)
    PutChar(table+1,eee)
    PutChar(table+2,eee)
    PutChar(table+3,eee)
    eee:=Shr((rre AND $F0),4)
    PutChar(table+4,eee)
    PutChar(table+5,eee)
    PutChar(table+6,eee)
    PutChar(table+7,eee)
    eee:=Shr((rre AND $F00),8)
    PutChar(table+8,eee)
    PutChar(table+9,eee)
    PutChar(table+10,eee)
    PutChar(table+11,eee)
  ENDIF
ENDPROC
PROC processname(name,dir,file)

  DEF wish[20]:STRING

  StrCopy(name,dir,ALL)
  IF StrLen(file)            /* IF a file (NOT DISK/DRAWER) */
    RightStr(wish,name,1)
    IF StrCmp(wish,':',1)=NIL       /*  DISK:DIR/NAME */
      StrAdd(name,'/',ALL)
    ENDIF
    StrAdd(name,file,ALL)
  ELSE
    RightStr(wish,name,1)
    IF StrCmp(wish,':',1)        /* DISK:  (so add disk) */
      StrAdd(name,'disk',ALL)
    ENDIF
    IF StrCmp(wish,'/',1)        /* DISK:DIR/DIR/  (delete '/' */
      MidStr(name,name,0,StrLen(name)-1)
    ENDIF
  ENDIF
  MidStr(wish,name,0,1)
  IF StrCmp(wish,'/',1)
    MidStr(name,name,1,ALL)
  ENDIF
  stripinfo(name)
ENDPROC
PROC stripinfo(name)
  DEF comp1[6]:STRING,comp2[6]:STRING

  StrCopy(comp1,'.INFO',ALL)
  MidStr(comp2,name,StrLen(name)-5,5)
  UpperStr(comp2)
  IF StrCmp(comp1,comp2,5)
    MidStr(name,name,0,(StrLen(name)-5))
  ENDIF
ENDPROC
PROC grabrgbtables()
  DEF cmtable
  cmtable:=[0,0,0,0,0,0]:LONG
  FOR scratch:=0 TO Shl(1,depth)-1
    mygetrgb32(colormap,scratch,1,cmtable)
    redt[scratch]:=Char(cmtable)
    grnt[scratch]:=Char(cmtable+4)
    blut[scratch]:=Char(cmtable+8)
  ENDFOR
ENDPROC

PROC stripselect(flags)
  IF (flags AND GFLG_GADGHIMAGE) THEN flags:=flags-GFLG_GADGHIMAGE
  IF (flags AND GFLG_GADGHCOMP) THEN flags:=flags-GFLG_GADGHCOMP
  IF (flags AND GADGBACKFILL) THEN flags:=flags-GADGBACKFILL
ENDPROC flags


PROC copybitmap2image(sb,di,nb,ys,dp,savedepth)

  DEF plane,cp,cr,cb,byte,sbs=NIL:PTR TO mybitmapstruct

  sbs:=sb;byte:=di
  FOR plane:=1 TO savedepth
    IF plane>dp         /* If save plane is not edited, use highest that was */
      SELECT dp
        CASE 1;cp:=sbs.plane1
        CASE 2;cp:=sbs.plane2
        CASE 3;cp:=sbs.plane3
        CASE 4;cp:=sbs.plane4
        CASE 5;cp:=sbs.plane5
        CASE 6;cp:=sbs.plane6
        CASE 7;cp:=sbs.plane7
        CASE 8;cp:=sbs.plane8
      ENDSELECT
    ELSE
      SELECT plane
        CASE 1;cp:=sbs.plane1
        CASE 2;cp:=sbs.plane2
        CASE 3;cp:=sbs.plane3
        CASE 4;cp:=sbs.plane4
        CASE 5;cp:=sbs.plane5
        CASE 6;cp:=sbs.plane6
        CASE 7;cp:=sbs.plane7
        CASE 8;cp:=sbs.plane8
      ENDSELECT
    ENDIF
    FOR cr:=0 TO ys-1
      FOR cb:=0 TO nb-1
        MOVE.L byte,A0
        MOVE.L cp,A1
        MOVE.B (A1),(A0)
        byte:=byte+1;cp:=cp+1
      ENDFOR
      cp:=cp+(sbs.bytesperrow-nb)
    ENDFOR
  ENDFOR
ENDPROC

PROC copyrast2image(sb,di,nb,ys,dp,savedepth)

  DEF plane,cp,cr,cb,byte,sbs=NIL:PTR TO mybitmapstruct

  byte:=di
  FOR plane:=0 TO savedepth-1
    ditz:=Shl(1,smaller(plane,dp))
    FOR cr:=0 TO ys-1
      FOR cb:=0 TO nb-1
        body:=0
        FOR dang:=7 TO 0 STEP -1
          dumb:=ReadPixel(sb,(cb*8)+(7-dang),cr)
          IF (dumb AND ditz) THEN body:=(body OR Shl(1,dang))
        ENDFOR
        PutChar(byte,body)
        byte:=byte+1
      ENDFOR
    ENDFOR
  ENDFOR
ENDPROC

PROC findsize(rast1)
  DEF li,lt,a
  requestsizex:=NIL;requestsizey:=NIL
  FOR li:=0 TO maxih;FOR lt:=0 TO maxiw
      a:=ReadPixel(rast1,lt,li)
      IF (a)
        IF lt>requestsizex;requestsizex:=lt;ENDIF
        IF li>requestsizey;requestsizey:=li;ENDIF
      ENDIF
      IF a>highestcolor;highestcolor:=a;ENDIF
    ENDFOR;ENDFOR
  requestsizex:=requestsizex+1;requestsizey:=requestsizey+2
ENDPROC

PROC restorediskobj(diskobj:PTR TO diskobject)
  DEF gadget:PTR TO gadget
  gadget:=diskobj.gadget
  gadget.gadgetrender:=k[0]
  gadget.selectrender:=k[1]
  gadget.flags:=k[2]
  diskobj.drawerdata:=k[3]
  Dispose(k[4]);k[4]:=NIL
  Dispose(k[5]);k[5]:=NIL
  Dispose(k[6]);k[6]:=NIL
  diskobj.type:=k[7]
  IF k[9]  THEN FreeMem(k[9], k[8])
  IF k[10] THEN FreeMem(k[10],k[8])
  k[9]:=NIL
  k[10]:=NIL
ENDPROC

PROC creatediskobj(diskobj:PTR TO diskobject,rast1:PTR TO rastport) HANDLE
  DEF gadget:PTR TO gadget
  DEF iconsizex,iconsizey,highplane
  DEF numbyteswide,savedepthhow,sizetmp
  DEF i1:PTR TO image,i2:PTR TO image
  DEF bitm1

  gadget:=diskobj.gadget
  k[0]:=gadget.gadgetrender
  k[1]:=gadget.selectrender
  k[2]:=gadget.flags
  k[3]:=diskobj.drawerdata
  k[4]:=New(SIZEOF image)
  k[5]:=New(SIZEOF image)
  k[6]:=New(SIZEOF drawerdata)
  k[7]:=diskobj.type
  k[8]:=0
  k[9]:=0
  highestcolor:=0
  bitm1:=curbitmap

  findsize(rast1)
  iconsizex:=bigger(bigger(requestsizex,10),minimumx)
  iconsizey:=bigger(bigger(requestsizey,10),minimumy)

  numbyteswide:=((iconsizex+15)/16)*2
  savedepthhow:=depth
  IF (force8) THEN savedepthhow:=8
  sizetmp:=(numbyteswide*iconsizey*savedepthhow)+1000

  k[8]:=sizetmp
  k[9]:=AllocMem(sizetmp,(MEMF_CHIP OR MEMF_CLEAR))
  k[10]:=AllocMem(sizetmp,(MEMF_CHIP OR MEMF_CLEAR))
  IF ((k[9]=NIL) OR (k[10]=NIL)) THEN Raise(L_EF_CHIPBUFFER)

  IF chunkyflag=NIL
    copybitmap2image(bitm1,k[9],numbyteswide,iconsizey-1,depth,savedepthhow)
  ELSE
    copyrast2image(rast1,k[9],numbyteswide,iconsizey-1,depth,savedepthhow)
  ENDIF
  i1:=k[4];i2:=k[5]
  i1.leftedge:=0;i1.topedge:=0;i1.width:=iconsizex
  i1.height:=iconsizey-1;i1.depth:=8;i1.imagedata:=k[9]
  i1.planepick:=0;i1.planeonoff:=0;i1.nextimage:=NIL
  i2.leftedge:=0;i2.topedge:=0;i2.width:=iconsizex
  i2.height:=iconsizey-1;i2.depth:=8;i2.imagedata:=k[10]
  i2.planepick:=0;i2.planeonoff:=0;i2.nextimage:=NIL

  highplane:=1
  IF highestcolor>1;highplane:=2;ENDIF
  IF highestcolor>3;highplane:=3;ENDIF
  IF highestcolor>7;highplane:=4;ENDIF
  IF highestcolor>15;highplane:=5;ENDIF
  IF highestcolor>31;highplane:=6;ENDIF
  IF highestcolor>63;highplane:=7;ENDIF
  IF highestcolor>127;highplane:=8;ENDIF
  IF (force8)
    i1.depth:=8
    i2.depth:=8
  ELSE
    i1.depth:=highplane
    i2.depth:=highplane
  ENDIF
  gadget.width:=iconsizex;gadget.height:=iconsizey;gadget.gadgetrender:=i1
  gadget.selectrender:=NIL
  IF freeme=TRUE
    diskobj.currentx:=NO_ICON_POSITION
    diskobj.currenty:=NO_ICON_POSITION
  ENDIF
  gadget.flags:=stripselect(gadget.flags)
  gadget.flags:=(gadget.flags OR GFLG_GADGHCOMP)
  diskobj.type:=WBPROJECT

  Raise(E_NONE)
EXCEPT
  IF exception<>E_NONE
    errormessage(exception)
  ENDIF
  IF quitter THEN leave(quitter)
ENDPROC

PROC smaller(val1,val2);IF val1<val2;RETURN val1;ELSE;RETURN val2;ENDIF;ENDPROC
PROC bigger(val1,val2);IF val1>val2;RETURN val1;ELSE;RETURN val2;ENDIF;ENDPROC
PROC limit(val1,val2,val3);IF val1<val2 THEN RETURN val2
          IF val1>val3 THEN RETURN val3;ENDPROC val1
PROC threshold(val,th);IF Abs(val)<=th THEN RETURN 0;ENDPROC val

PROC domethod( obj:PTR TO object, msg:PTR TO msg )
  DEF h:PTR TO hook, o:PTR TO object, dispatcher
  IF obj
    o := obj-SIZEOF object     /* instance data is to negative offset */
    h := o.class
    dispatcher := h.entry      /* get dispatcher from hook in iclass */
    MOVEA.L h,A0
    MOVEA.L msg,A1
    MOVEA.L obj,A2           /* probably should use CallHookPkt, but the */
    MOVEA.L dispatcher,A3    /*   original code (DoMethodA()) doesn't. */
    JSR (A3)                 /* call classDispatcher() */
    MOVE.L D0,o
    RETURN o
  ENDIF
ENDPROC NIL

PROC copyimagerast(rastp:PTR TO rastport,image)
  DrawImage(rastp,image,0,0)
ENDPROC

catstrs:
  CHAR 'Ok¶'
  CHAR 'Error: A general error has occured.¶'
  CHAR 'Error: File not found.¶'
  CHAR 'Error: Could not open file.¶'
  CHAR 'Error: Problems with icon.¶'
  CHAR 'Error: Unable to write icon file.¶'
  CHAR 'Error: Problems opening clipboard.¶'
  CHAR 'Error: Problems with datatype.¶'
  CHAR 'Error: Datatype is not a picture.¶'
  CHAR 'Error: Problems creating gadgets.¶'
  CHAR 'Error: Could not open a required library.¶'
  CHAR 'Error: An undefined FATAL error has occured.¶'
  CHAR 'Fatal Error: Could not lock a public screen.¶'
  CHAR 'Fatal Error: Not enough CHIP memory\n        for a required buffer.¶'
  CHAR 'Fatal Error: Could not obtain a visual lock.¶'
  CHAR 'Fatal Error: Unable to create menus.¶'
  CHAR 'Fatal Error: Could not open a port.¶'
  CHAR 'Fatal Error: Unable to open window.¶'
  CHAR 'Error: Unable to allocate some memory.¶'
  CHAR 'Picticon Status¶'
  CHAR 'Picture "\s"¶'
  CHAR '(\d of \d)¶'
  CHAR 'Loading...¶'
  CHAR 'Scaling...¶'
  CHAR 'Remapping...¶'
  CHAR 'Saving icon.¶'
  CHAR '\n\s(\d%% done.)¶'
  CHAR 'Picticon¶'
  CHAR 'Copyright ©1993,94\n by Chad Randall\n\nThis software is freely re-distributable.\n\nDo you wish to quit?¶'
  CHAR 'Quit|Cancel¶'
  CHAR 'Rendering...¶'
  LONG 0,0,0

chardata:

  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR '.xxx..'

  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'

  CHAR 'xxxxx.'
  CHAR '....x.'
  CHAR '..xxx.'
  CHAR '.x....'
  CHAR 'x.....'
  CHAR 'xxxxx.'

  CHAR 'xxxx..'
  CHAR '....x.'
  CHAR '..xx..'
  CHAR '....x.'
  CHAR '....x.'
  CHAR 'xxxx..'

  CHAR '...x..'
  CHAR '..xx..'
  CHAR '.x.x..'
  CHAR 'xxxxx.'
  CHAR '...x..'
  CHAR '...x..'

  CHAR 'xxxxx.'
  CHAR 'x.....'
  CHAR 'xxxx..'
  CHAR '....x.'
  CHAR '....x.'
  CHAR 'xxxx..'

  CHAR '.xxx..'
  CHAR 'x.....'
  CHAR 'xxxx..'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR '.xxx..'

  CHAR 'xxxxx.'
  CHAR '....x.'
  CHAR '...x..'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'

  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR '.xxx..'

  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR '.xxxx.'
  CHAR '....x.'
  CHAR '....x.'
  CHAR '.xxx..'

xdata:
  CHAR '......'
  CHAR '......'
  CHAR '.x.x..'
  CHAR '..x...'
  CHAR '.x.x..'
  CHAR '......'

chardatal:

  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR '.xxx..'

  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'

  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR '....x.'
  CHAR '...x..'
  CHAR '..x...'
  CHAR '.x....'
  CHAR 'x.....'
  CHAR 'xxxxx.'

  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR '....x.'
  CHAR '..xx..'
  CHAR '....x.'
  CHAR '....x.'
  CHAR 'x...x.'
  CHAR '.xxx..'

  CHAR '...x..'
  CHAR '..xx..'
  CHAR '.x.x..'
  CHAR 'x..x..'
  CHAR 'xxxxx.'
  CHAR '...x..'
  CHAR '...x..'
  CHAR '...x..'

  CHAR 'xxxxx.'
  CHAR 'x.....'
  CHAR 'x.....'
  CHAR 'xxxx..'
  CHAR '....x.'
  CHAR '....x.'
  CHAR '....x.'
  CHAR 'xxxx..'

  CHAR '.xxx..'
  CHAR 'x.....'
  CHAR 'x.....'
  CHAR 'xxxx..'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR '.xxx..'

  CHAR 'xxxxx.'
  CHAR '....x.'
  CHAR '....x.'
  CHAR '...x..'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'
  CHAR '..x...'

  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR '.xxx..'

  CHAR '.xxx..'
  CHAR 'x...x.'
  CHAR 'x...x.'
  CHAR '.xxxx.'
  CHAR '....x.'
  CHAR '....x.'
  CHAR 'x...x.'
  CHAR '.xxx..'

xdatal:
  CHAR '......'
  CHAR '......'
  CHAR 'x...x.'
  CHAR '.x.x..'
  CHAR '..x...'
  CHAR '.x.x..'
  CHAR 'x...x.'
  CHAR '......'

controlstring:
  CHAR $B,0,0,0,0
  CHAR $9B,"1",$53,$0,$0,$0,$0

