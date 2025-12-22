/* A Basic example
** -------------------
** written by Krzysztof Cmok
** v1.0
*/

MODULE 'tools/rwdisk'

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
		error:=mReadDiskBuffer(td,mTrack(td,0),buffer)
		WriteF('Error: \d\n',error)
		mDeleteDisk(td)

		fh:=Open('.buffer',NEWFILE)
		Write(fh,buffer,trksize)
		Close(fh)
	Dispose(buffer)
ENDPROC
