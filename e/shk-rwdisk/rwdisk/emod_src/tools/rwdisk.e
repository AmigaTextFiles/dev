OPT PREPROCESS
OPT MODULE
OPT EXPORT

MODULE	'dos/dosextens',
	'dos/dos',
	'dos/filehandler',
	'exec/io'

OBJECT tdisk
	drive,device,unit
	begincyl,size,sides
	ioreq:PTR TO iostd,port,devopen
ENDOBJECT

ENUM	DINFO_DEVICENAME,
	DINFO_DRIVENAME,
	DINFO_UNIT,
	DINFO_LOWCYL,
	DINFO_HIGHCYL,
	DINFO_SURFACES,
	DINFO_TRACKSIZE,
	DINFO_SIZEBLOCK,
	DINFO_BLOCKSPERTRACK,
	DINFO_SECTORPERBLOCK,
	DINFO_DOSTYPE,
	DINFO_RESERVED,
	DINFO_NUMBUFFERS,

	VINFO_VOLUMENAME,
	VINFO_INUSE,
	VINFO_DISKTYPE,
	VINFO_BYTESPERBLOCK,
	VINFO_NUMBLOCKSUSED,
	VINFO_NUMBLOCKS,
	VINFO_DISKSTATE,
	VINFO_UNITNUMBER,
	VINFO_NUMSOFTERRORS

/**
PROC main()
DEF buffer,trksize,dl,td,fh,error

	IF arg[]=0
		WriteF('Usage: example <drivename>\nex. example DF0:\n')
		CleanUp()
	ENDIF

	dl:=mBeginDiskInfo(arg)
	WriteF('Track Size:\d\n',trksize:=mDiskInfo(dl,DINFO_TRACKSIZE));
	WriteF('Size Block:\d\n',mDiskInfo(dl,DINFO_SIZEBLOCK));
	WriteF('Blocks per Track:\d\n',mDiskInfo(dl,DINFO_BLOCKSPERTRACK));
	WriteF('Sector per Block:\d\n',mDiskInfo(dl,DINFO_SECTORPERBLOCK));
	WriteF('Surfaces:\d\n',mDiskInfo(dl,DINFO_SURFACES));
	WriteF('Low cyl:\d\n',mDiskInfo(dl,DINFO_LOWCYL));
	WriteF('Hi cyl:\d\n',mDiskInfo(dl,DINFO_HIGHCYL));
	WriteF('Num Buffers:\d\n',mDiskInfo(dl,DINFO_NUMBUFFERS));
	mFinishDiskInfo()
	buffer:=New(trksize)
		td:=mCreateDisk(arg)
		error:=mReadDiskBuffer(td,mTrack(td,1),buffer)
		WriteF('Error: \d\n',error)
		mDeleteDisk(td)

		fh:=Open('.buffer',NEWFILE)
		Write(fh,buffer,trksize)
		Close(fh)
	Dispose(buffer)
ENDPROC
**/

/* mBeginDiskInfo(devicename)
*******************************
** Informations about 'devicename'
** 'DF0:' or 'DF1:'...
** RESULT: dl - pointer doslist
*/
PROC mBeginDiskInfo(devicename:PTR TO CHAR)
DEF dl:PTR TO doslist,pos
IF (pos:=InStr(devicename,':'))<>-1 THEN devicename[pos]:=0
	dl:=LockDosList(LDF_DEVICES+LDF_READ)
	IF (dl:=FindDosEntry(dl,devicename,LDF_DEVICES))
		IF dl.type=DLT_DEVICE
			RETURN dl
		ENDIF
	ENDIF
ENDPROC 0

/* mDiskInfo(doslist,flag)
*******************************
** Informations about disk
** doslist - pointer doslist.
** flag - what info?
*/
PROC mDiskInfo(dl:PTR TO doslist,flag)
DEF fssm:PTR TO filesysstartupmsg,de:PTR TO dosenvec
	fssm:=BADDR(dl::devicenode.startup)
	de:=BADDR(fssm.environ)
SELECT flag
	CASE DINFO_DEVICENAME;
		RETURN BADDR(fssm.device)+1
	CASE DINFO_DRIVENAME;
		RETURN BADDR(dl.name)+1
	CASE DINFO_UNIT;
		RETURN fssm.unit
	CASE DINFO_LOWCYL;
		RETURN de.lowcyl
	CASE DINFO_HIGHCYL;
		RETURN de.highcyl
	CASE DINFO_SURFACES;
		RETURN de.surfaces
	CASE DINFO_TRACKSIZE;
		RETURN Mul(BADDR(de.sizeblock),de.blockspertrack)
	CASE DINFO_SIZEBLOCK;
		RETURN BADDR(de.sizeblock)
	CASE DINFO_BLOCKSPERTRACK;
		RETURN de.blockspertrack
	CASE DINFO_SECTORPERBLOCK;
		RETURN de.sectorperblock
	CASE DINFO_DOSTYPE;
		RETURN de.dostype
	CASE DINFO_RESERVED
		RETURN de.reserved
	CASE DINFO_NUMBUFFERS
		RETURN de.numbuffers
	DEFAULT;
	ENDSELECT
ENDPROC -1

/* mVolumeInfo(devicename,flag)
*********************************
** Another disk info
** devicename - example. 'DF0:' or 'DF1:'
** flag - what info?
** RESULT: disk-infos
*/
PROC mVolumeInfo(devicename:PTR TO CHAR,flag)
DEF lock,infodata:PTR TO infodata,volnode:PTR TO devicenode,w=0
IF (lock:=Lock(devicename,ACCESS_READ))
infodata:=New(SIZEOF infodata)
Info(lock,infodata)
SELECT flag
	CASE VINFO_VOLUMENAME
		volnode:=BADDR(infodata.volumenode)
		w:=BADDR(volnode.name)+1
	CASE VINFO_INUSE
		w:=infodata.inuse
	CASE VINFO_DISKTYPE
		w:=infodata.disktype
	CASE VINFO_BYTESPERBLOCK
		w:=infodata.bytesperblock
	CASE VINFO_NUMBLOCKSUSED
		w:=infodata.numblocksused
	CASE VINFO_NUMBLOCKS
		w:=infodata.numblocks
	CASE VINFO_DISKSTATE
		w:=infodata.diskstate
	CASE VINFO_UNITNUMBER
		w:=infodata.unitnumber
	CASE VINFO_NUMSOFTERRORS
		w:=infodata.numsofterrors
	DEFAULT;
ENDSELECT
UnLock(lock)
Dispose(infodata)
ENDIF
ENDPROC w

/* mFinishDiskInfo()
*********************
** Unlock diskinfo pointer.
*/
PROC mFinishDiskInfo()
UnLockDosList(LDF_DEVICES+LDF_READ)
ENDPROC

/* mCreateDisk(devicename)
************************************
** devicename - example: 'DF0:'
** RESULT: tdisk pointer (or 0 if error).
*/
PROC mCreateDisk(devicename:PTR TO CHAR)
DEF dl,td:PTR TO tdisk
	IF (dl:=mBeginDiskInfo(devicename))
		NEW td
		td.drive:=mDiskInfo(dl,DINFO_DRIVENAME)
		td.device:=mDiskInfo(dl,DINFO_DEVICENAME)
		td.unit:=mDiskInfo(dl,DINFO_UNIT)
		td.begincyl:=mDiskInfo(dl,DINFO_LOWCYL)
		td.size:=mDiskInfo(dl,DINFO_TRACKSIZE)
		td.sides:=mDiskInfo(dl,DINFO_SURFACES)
		mFinishDiskInfo()
		inhi(td.drive,DOSTRUE)
		td.ioreq:=CreateIORequest( td.port:=CreateMsgPort(), SIZEOF iostd)
		td.devopen:=OpenDevice(td.device,td.unit,td.ioreq,0)
		RETURN td
	ENDIF
ENDPROC 0

PROC inhi(a:PTR TO CHAR,b)
DEF s[512]:STRING

IF InStr(a,':')=-1
	StringF(s,'\s:',a)
ELSE
	StringF(s,'\s',a)
ENDIF
ENDPROC	Inhibit(s,b)

/* mDeleteDisk(td)
****************************************
** td - pointer tdisk
*/
PROC mDeleteDisk(td:PTR TO tdisk)
IF td.devopen=0 THEN CloseDevice(td.ioreq)
	DeleteIORequest(td.ioreq)
	DeleteMsgPort(td.port)
	inhi(td.drive,DOSFALSE)
	END td
ENDPROC

/* mReadDiskBuffer(td,offset,buffer[,bufsize])
****************************************
** td - pointer tdisk
** offset - offset in disk to read
** buffer - buffer to read.
** bufsize - how much read buffers.
** RESULT: if is error.
*/
PROC mReadDiskBuffer(td:PTR TO tdisk,offtrack,buf,bufsize=0)
DEF offset=0
offset:=Mul(Mul(td.size,td.sides),td.begincyl)
IF bufsize=0 THEN bufsize:=td.size
offset:=offset+offtrack
	td.ioreq.command:=CMD_READ
	td.ioreq.offset:=offset
	td.ioreq.length:=bufsize
	td.ioreq.data:=buf	
	DoIO(td.ioreq)
ENDPROC td.ioreq.error

PROC mTrack(td:PTR TO tdisk,track) IS Mul(Mul(td.size,td.sides),track)

/* mWriteDiskBuffer(td,offset,buffer[,bufsize])
****************************************
** td - pointer tdisk
** offset - offset in disk to read
** buffer - buffer to write.
** bufsize - how much write buffers.
** RESULT: if is error.
*/
PROC mWriteDiskBuffer(td:PTR TO tdisk,offtrack,buf:PTR TO CHAR,bufsize=0)
DEF offset=0
offset:=Mul(Mul(td.size,td.sides),td.begincyl)
IF bufsize=0 THEN bufsize:=td.size
offset:=offset+offtrack
	td.ioreq.command:=CMD_WRITE
	td.ioreq.offset:=offset
	td.ioreq.length:=bufsize
	td.ioreq.data:=buf
	DoIO(td.ioreq)
ENDPROC td.ioreq.error
