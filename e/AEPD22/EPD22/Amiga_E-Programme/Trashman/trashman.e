/*

Trashman -- a Mac-alike trashcan icon updater

COPYRIGHT 1994 by C.Randall, of mbissaymssiK Software, Broken Spork technologies division.

Contact me through Internet:  crandall@garnet.msen.com

*/



MODULE 'dos/dos','dos/dosextens','dos/notify','dos/dosextens','dos/dosasl'
MODULE 'workbench/startup','wb','icon','workbench/workbench'
MODULE 'utility/tagitem','utility'
MODULE 'exec/nodes','exec/ports','exec/types','exec/memory'
MODULE 'newicon','libraries/newicon'
MODULE 'intuition/intuition'

ENUM STAT_UNKNOWN,STAT_FULL,STAT_EMPTY

DEF trash1[500]:STRING
DEF trash2[500]:STRING
DEF dir[500]:STRING
DEF ffile[500]:STRING
DEF diskobj1:PTR TO diskobject
DEF diskobj2:PTR TO diskobject
DEF notify:PTR TO notifyrequest
DEF nmsg:PTR TO notifymessage
DEF port:PTR TO mp
DEF wb:PTR TO wbstartup
DEF args:PTR TO wbarg
DEF status=STAT_UNKNOWN
DEF lock

DEF olddir,s,abort

PROC main()
	NEW notify

	IF KickVersion(37)
	IF (wbmessage)
		SetTaskPri(FindTask(0),2)
		IF (workbenchbase:=OpenLibrary('workbench.library',36))
			IF (iconbase:=OpenLibrary('icon.library',36))
				IF (utilitybase:=OpenLibrary('utility.library',37))
					newiconbase:=OpenLibrary('newicon.library',37)
					
					wb:=wbmessage;args:=wb.arglist;olddir:=CurrentDir(args.lock)
					IF args.name>0
						GetCurrentDirName(ffile,490)
						AddPart(ffile,args.name,490)
						diskobj1:=GetDiskObjectNew(ffile)
					ENDIF
					CurrentDir(olddir)
					StrCopy(dir,'sys:trashcan',ALL)
					StrCopy(trash1,'env:sys/def_trashcan',ALL)
					StrCopy(trash2,'env:sys/def_fulltrashcan',ALL)
					IF diskobj1
						IF (s:=FindToolType(diskobj1.tooltypes,'WATCHDIR'))
							StrCopy(dir,s,ALL)
						ENDIF
						IF (s:=FindToolType(diskobj1.tooltypes,'TRASHCAN_EMPTY'))
							StrCopy(trash1,s,ALL)
						ENDIF
						IF (s:=FindToolType(diskobj1.tooltypes,'TRASHCAN_FULL'))
							StrCopy(trash2,s,ALL)
						ENDIF
						FreeDiskObject(diskobj1)
						diskobj1:=0
					ENDIF

					IF (lock:=Lock(dir,ACCESS_READ))
						IF (port:=CreateMsgPort())
							notify.name:=dir
							notify.flags:=NRF_SEND_MESSAGE
							notify.port:=port
							abort:=FALSE
							IF (StartNotify(notify))
								WHILE (abort=FALSE)
									changestate()
									Wait(SIGBREAKF_CTRL_C OR Shl(1,port.sigbit))
									s:=FALSE
									WHILE (nmsg:=GetMsg(port))
										ReplyMsg(nmsg)
										s:=TRUE
									ENDWHILE
									IF (s=FALSE) THEN abort:=TRUE
								ENDWHILE
								EndNotify(notify)
							ENDIF
							DeleteMsgPort(port)
						ENDIF
						UnLock(lock)
					ENDIF

					IF (newiconbase) THEN CloseLibrary(newiconbase)
					CloseLibrary(utilitybase)
				ENDIF
				CloseLibrary(iconbase)
			ENDIF
			CloseLibrary(workbenchbase)
		ENDIF
	ENDIF
	ENDIF

	END notify
ENDPROC

PROC changestate()
	DEF fh,fileinfo=0:PTR TO fileinfoblock
	DEF apath=NIL:PTR TO anchorpath
	DEF	achain=NIL:PTR TO achain
	DEF dir2[500]:STRING
	DEF flag=FALSE
	DEF err,mode
	NEW apath

	StrCopy(dir2,dir,ALL)
	AddPart(dir2,'#?',490)

	IF (fh:=Lock(dir,ACCESS_READ))
		err:=0;mode:=0
		WHILE (err<2)
			IF (mode=0)
				err:=MatchFirst(dir2,apath);mode:=1
			ELSE
				err:=MatchNext(apath)
			ENDIF
			IF (err=0)
				achain:=apath.last
				IF (achain)
					fileinfo:=achain.info
					IF (fileinfo)
						IF (fileinfo.direntrytype<>0)
							StrCopy(ffile,dir,ALL)
							AddPart(ffile,fileinfo.filename,490)
							flag:=TRUE
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDWHILE
		MatchEnd(apath)
		IF (flag=FALSE)
			EndNotify(notify)
			notify.name:=dir
			StartNotify(notify)
			IF (status<>STAT_EMPTY) THEN copyimage(trash1,dir)
			status:=STAT_EMPTY
		ELSE
			EndNotify(notify)
			notify.name:=ffile
			StartNotify(notify)
			IF (status<>STAT_FULL) THEN copyimage(trash2,dir)
			status:=STAT_FULL
		ENDIF
		UnLock(fh)
	ENDIF

	END apath
ENDPROC

PROC copyimage(source,dest)
	DEF ndo1:PTR TO newdiskobject
	DEF ndo2:PTR TO newdiskobject

	DEF newi1,newi2,newdi1,newdi2

	IF (newiconbase)
		IF (ndo1:=GetNewDiskObject(source))
			IF (ndo2:=GetNewDiskObject(dest))
				newi1:=ndo2.ndo_normalimage
				newi2:=ndo2.ndo_selectedimage
				diskobj1:=ndo2.ndo_stdobject
				diskobj2:=ndo1.ndo_stdobject	->backwards!
				newdi1:=diskobj1.gadget::gadget.gadgetrender
				newdi2:=diskobj1.gadget::gadget.selectrender

				diskobj1.gadget::gadget.gadgetrender:=diskobj2.gadget::gadget.gadgetrender
				diskobj1.gadget::gadget.selectrender:=diskobj2.gadget::gadget.selectrender
				ndo2.ndo_normalimage:=ndo1.ndo_normalimage
				ndo2.ndo_selectedimage:=ndo1.ndo_selectedimage

				PutNewDiskObject(dest,ndo2)
				
				diskobj1.gadget::gadget.gadgetrender:=newdi1
				diskobj1.gadget::gadget.selectrender:=newdi2
				ndo2.ndo_normalimage:=newi1
				ndo2.ndo_selectedimage:=newi2
				FreeNewDiskObject(ndo2)
			ENDIF
			FreeNewDiskObject(ndo1)
		ENDIF
	ELSE
		IF (diskobj1:=GetDiskObject(source))
			IF (diskobj2:=GetDiskObject(dest))
				newdi1:=diskobj2.gadget::gadget.gadgetrender
				newdi2:=diskobj2.gadget::gadget.selectrender

				diskobj2.gadget::gadget.gadgetrender:=diskobj1.gadget::gadget.gadgetrender
				diskobj2.gadget::gadget.selectrender:=diskobj1.gadget::gadget.selectrender

				PutDiskObject(dest,diskobj2)
				
				diskobj2.gadget::gadget.gadgetrender:=newdi1
				diskobj2.gadget::gadget.selectrender:=newdi2
				FreeDiskObject(diskobj2)
			ENDIF
			FreeDiskObject(diskobj1)
		ENDIF
	ENDIF

ENDPROC
versionstring:
CHAR '\0$VER: trashman 1 (14.12.94) \t FREELY REDISTRIBUTABLE, COPYRIGHTED MATERIAL -- NOT FOR RESALE\0\0'

