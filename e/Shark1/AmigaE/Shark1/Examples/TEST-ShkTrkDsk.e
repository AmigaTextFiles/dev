OPT PREPROCESS
MODULE 'shark/shktrkdsk','devices/trackdisk','exec/memory','shark/shkfiles'

PROC main()
DEF disk:PTR TO ioexttd,buffer,num
DEF fh

buffer:=AllocMem(TRACK_SIZE,MEMF_CHIP+MEMF_PUBLIC)

/* TRACK DISK EXAMPLE .MAIN.*/
disk:=mInitTrkDsk(0)
mMotorOn(disk)
WriteF('Numer of tracks: \d\n',num:=mFindNumTracks(disk))
num:=mReadTrack(disk,buffer,0) ; WriteF('Errorn nr.\d\n',num,buffer)

       /* Read as file */
           fh:=mSaveF('ram:track')
		Write(fh,buffer,TRACK_SIZE)
           Close(fh)
       /* End */

Delay(50)
mMotorOff(disk)
mCloseTrkDsk(disk)
/* TRACK DISK EXAMPLE END OF .MAIN. */

FreeMem(buffer,TRACK_SIZE)

ENDPROC
