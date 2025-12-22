/*
  open drop-app-icon image (Either default, or filename)
  place app icon image onto workbench
  enter loop
    double click, ask to quit.
    dropped image
      loadimage
      if 8 planes
        save 3 planes
      if 3 planes
        save 8 planes
  endloop
*/

OPT OSVERSION=39

MODULE	'exec/nodes','exec/ports','exec/types','exec/memory',
				'intuition/intuition',
				'dos/dos','dos/dosextens','workbench/workbench',
				'workbench/startup','wb','icon','Asl','libraries/Asl'

	DEF appport=NIL:PTR TO mp
	DEF appflag=NIL
	DEF appicon,newproj[250]:STRING
	DEF lockname[250]:STRING,newlock=NIL
	DEF fname[250]:STRING
	DEF appobj:PTR TO diskobject
	DEF oldchoice
	DEF sleepobject=NIL:PTR TO diskobject
	DEF appobject:PTR TO diskobject
	DEF filename[250]:STRING
	DEF amsg:PTR TO appmessage
	DEF argptr:PTR TO wbarg
	DEF args:PTR TO wbarg
	DEF scratch
	DEF appname[250]:STRING
	DEF wb:PTR TO wbstartup
	DEF olddir
	DEF toolobject:PTR TO diskobject

PROC main()
	IF (workbenchbase:=OpenLibrary('workbench.library',0))
		IF (iconbase:=OpenLibrary('icon.library',0))
			IF (aslbase:=OpenLibrary('asl.library',0))

				IF wbmessage<>NIL
					wb:=wbmessage;args:=wb.arglist
					olddir:=CurrentDir(args.lock)
					IF args.name>0
						GetCurrentDirName(appname,250)
					ENDIF
				ENDIF
				StrAdd(appname,'328_DropImage',ALL)

				IF (sleepobject:=GetDiskObjectNew(appname))=NIL
					sleepobject:=GetDefDiskObject(WBTOOL)
				ENDIF
				IF sleepobject
					sleepobject.type:=NIL
					appobject:=sleepobject
					IF (appport:=CreateMsgPort())
						IF (appicon:=AddAppIconA(0,0,'3-2-8',appport,0,appobject,NIL))<>NIL
							WHILE appflag=NIL
								WaitPort(appport)
								WHILE (amsg:=GetMsg(appport))<>NIL
									IF amsg.numargs=0
										IF EasyRequestArgs(0, [20, 0, '3-2-8', 'COPYRIGHT ®1994 by Chad Randall\n\nDo you wish to quit?','Ok|Cancel'], 0, 0)
											appflag:=TRUE
										ENDIF
									ELSE
										argptr:=amsg.arglist
										FOR scratch:=1 TO amsg.numargs
											StrCopy(newproj,argptr.name,ALL)
											newlock:=argptr.lock
											IF newlock
												NameFromLock(newlock,lockname,250)
												processname(filename,lockname,newproj)
												toggleiconplanes(filename)
											ENDIF
											argptr:=argptr+(SIZEOF wbarg)
										ENDFOR
									ENDIF
									ReplyMsg(amsg)
								ENDWHILE
							ENDWHILE
							RemoveAppIcon(appicon)
							WHILE (amsg:=GetMsg(appport))<>NIL
								ReplyMsg(amsg)
							ENDWHILE
						ENDIF
						DeleteMsgPort(appport)
					ENDIF
					FreeDiskObject(sleepobject);sleepobject:=NIL
				ENDIF
				CloseLibrary(aslbase)
			ENDIF
			CloseLibrary(iconbase)
		ENDIF
		CloseLibrary(workbenchbase)
	ENDIF
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

PROC toggleiconplanes(name)
	DEF diskobj:PTR TO diskobject
	DEF icongad:PTR TO gadget
	DEF regimage:PTR TO image,selimage:PTR TO image
	DEF sizetmp,sizetmp2,tmpbuf,tmpbuf2,oldtmp,oldtmp2
	DEF bufptr,bufptr2,dummy,scratch

	IF (diskobj:=GetDiskObject(name))
		IF ((icongad:=diskobj.gadget))
			regimage:=icongad.gadgetrender
			selimage:=icongad.selectrender

			IF regimage.depth=3
				regimage.depth:=8
				IF selimage THEN selimage.depth:=8

				sizetmp:=((((regimage.width+15)/16)*2)*regimage.height*8)+1000
				sizetmp2:=((((selimage.width+15)/16)*2)*selimage.height*8)+1000
				tmpbuf:=AllocMem(sizetmp,MEMF_CHIP OR MEMF_CLEAR)
				tmpbuf2:=AllocMem(sizetmp,MEMF_CHIP OR MEMF_CLEAR)

				bufptr:=regimage.imagedata
				bufptr2:=tmpbuf
				FOR scratch:=1 TO ((((regimage.width+15)/16)*2)*regimage.height*3)
					PutChar(bufptr2,Char(bufptr))
					bufptr:=bufptr+1
					bufptr2:=bufptr2+1
				ENDFOR

				FOR dummy:=3 TO 7
					bufptr:=regimage.imagedata+((((regimage.width+15)/16)*2)*2*regimage.height)
					FOR scratch:=1 TO ((((regimage.width+15)/16)*2)*regimage.height)
						PutChar(bufptr2,Char(bufptr))
						bufptr:=bufptr+1
						bufptr2:=bufptr2+1
					ENDFOR
				ENDFOR

				IF selimage
					bufptr:=selimage.imagedata
					bufptr2:=tmpbuf2
					FOR scratch:=1 TO ((((selimage.width+15)/16)*2)*selimage.height*3)
						PutChar(bufptr2,Char(bufptr))
						bufptr:=bufptr+1
						bufptr2:=bufptr2+1
					ENDFOR

					FOR dummy:=3 TO 7
						bufptr:=selimage.imagedata+((((selimage.width+15)/16)*2)*2*selimage.height)
						FOR scratch:=1 TO ((((selimage.width+15)/16)*2)*selimage.height)
							PutChar(bufptr2,Char(bufptr))
							bufptr:=bufptr+1
							bufptr2:=bufptr2+1
						ENDFOR
					ENDFOR
				ENDIF

				oldtmp:=regimage.imagedata
				IF selimage THEN oldtmp2:=selimage.imagedata
				regimage.imagedata:=tmpbuf
				IF selimage THEN selimage.imagedata:=tmpbuf2

				PutDiskObject(name,diskobj)

				regimage.depth:=3
				IF selimage THEN selimage.depth:=3
				regimage.imagedata:=oldtmp
				IF selimage THEN selimage.imagedata:=oldtmp2
			ENDIF
			IF regimage.depth=8
				regimage.depth:=3
				IF selimage THEN selimage.depth:=3
				PutDiskObject(name,diskobj)
				regimage.depth:=8
				IF selimage THEN selimage.depth:=8
			ENDIF
		ENDIF
	ENDIF
	IF diskobj THEN FreeDiskObject(diskobj)
ENDPROC
