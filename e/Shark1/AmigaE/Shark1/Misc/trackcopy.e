OPT PREPROCESS

MODULE 'exec/types','exec/nodes','exec/ports','exec/memory','devices/trackdisk','dos/dosextens','amigalib/io',
	'exec/io','amigalib/ports'

#define	TRACK_SIZE	(NUMSECS * TD_SECTOR)

PROC mDiskBusy(drive,onflag:PTR TO LONG)
DEF pk:PTR TO standardpacket,tsk:PTR TO process

    tsk:=FindTask(NIL);
    IF pk:=AllocMem(SIZEOF standardpacket,MEMF_PUBLIC+MEMF_CLEAR)
        pk.msg.ln.name:=pk.pkt

        pk.pkt.link:=pk.msg
        pk.pkt.port:=tsk.msgport
        pk.pkt.type:=ACTION_INHIBIT
	IF onflag THEN pk.pkt.arg1:=-1 ELSE pk.pkt.arg1:=0

        PutMsg(DeviceProc(drive),pk);
        WaitPort(tsk.msgport);
        GetMsg(tsk.msgport);
        FreeMem(pk,SIZEOF standardpacket);
    ENDIF
ENDPROC

PROC mMotorOff(disk:PTR TO ioexttd)
    disk.iostd.length:=0;
    disk.iostd.command:=TD_MOTOR;
    DoIO(disk);
ENDPROC

PROC mMotorOn(disk:PTR TO ioexttd)
    disk.iostd.length:=1;
    disk.iostd.command:=TD_MOTOR;
    DoIO(disk);
ENDPROC

PROC mReadTrack(disk:PTR TO ioexttd,buffer,track)
DEF errnr=0

    disk.iostd.length:=TRACK_SIZE;
    disk.iostd.data:=buffer;
    disk.iostd.command:=CMD_READ;
    disk.iostd.offset:=(TRACK_SIZE * track);
    DoIO(disk);
    IF disk.iostd.error THEN errnr:=disk.iostd.error
    RETURN errnr
ENDPROC

PROC mWriteTrack(disk:PTR TO ioexttd,buffer,track)
DEF errnr=0

    disk.iostd.length:=TRACK_SIZE;
    disk.iostd.data:=buffer;
    disk.iostd.command:=TD_FORMAT;
    disk.iostd.offset:=(TRACK_SIZE * track);
    DoIO(disk);
    IF disk.iostd.error THEN errnr:=disk.iostd.error
    RETURN errnr
ENDPROC

PROC mFindNumTracks(disk:PTR TO ioexttd)
    disk.iostd.command:=TD_GETNUMTRACKS;
    DoIO(disk);
    RETURN disk.iostd.actual
ENDPROC

/***********************888
VOID Do_Copy(struct IOExtTD *diskreq0,struct IOExtTD *diskreq1)
{
UBYTE *buffer;
SHORT track;
SHORT All_OK;
SHORT NumTracks;

    if (buffer=AllocMem(TRACK_SIZE,MEMF_CHIP|MEMF_PUBLIC))
    {
        printf(" Starting Motors\r");
        Motor_On(diskreq0);
        Motor_On(diskreq1);
        All_OK=TRUE;

        NumTracks=FindNumTracks(diskreq0);

        for (track=0;(track<NumTracks) && All_OK;track++)
        {
            printf(" Reading track %d\r",track);

            if (All_OK=Read_Track(diskreq0,buffer,track))
            {
                printf(" Writing track %d\r",track);

                All_OK=Write_Track(diskreq1,buffer,track);
            }
        }
        if (All_OK) printf(" * Copy complete *");
        printf("\n");
        Motor_Off(diskreq0);
        Motor_Off(diskreq1);
        FreeMem(buffer,TRACK_SIZE);
    }
    else printf("No memory for track buffer...\n");
}
****************************/
PROC mDoOpenDevice(diskreq0:PTR TO ioexttd,unit)
DEF str[512]:STRING
    StringF(str,'DF\d:',unit)
    IF (!OpenDevice(TD_NAME,unit,diskreq0,0)) THEN mDiskBusy(str,TRUE);
ENDPROC
PROC main()
DEF diskreq0:PTR TO ioexttd
DEF diskport:PTR TO mp
        IF diskport:=createPort(0,0)
            IF diskreq0:=createExtIO(diskport,SIZEOF ioexttd)
                    mDoOpenDevice(diskreq0,0);
			mMotorOn(diskreq0)
			Delay(50)		    
			mMotorOff(diskreq0)
		    mDiskBusy('DF0:',FALSE)
		    CloseDevice(diskreq0)
            ELSE
            WriteF('Out of memory\n')
            deleteExtIO(diskreq0);
            ENDIF
         ELSE
	 WriteF('Can''t create port\n');
            deletePort(diskport);
	ENDIF
ENDPROC
