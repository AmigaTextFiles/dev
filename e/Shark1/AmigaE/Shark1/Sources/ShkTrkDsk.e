/* Module for TrackDisk.device */
/* version 1.3 */
/* By K. "SHARK" Cmok EMAIL: sharkk@friko2.onet.pl */

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'exec/types',
	'exec/nodes',
	'exec/ports',
	'exec/memory',
	'devices/trackdisk',
	'dos/dosextens',
	'amigalib/io',
	'exec/io',
	'amigalib/ports'

#define	TRACK_SIZE	(NUMSECS * TD_SECTOR)
DEF diskport:PTR TO mp     -> for mInitTrkDsk()

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

PROC mDoOpenDevice(diskreq0:PTR TO ioexttd,unit)
DEF str[512]:STRING
    StringF(str,'DF\d:',unit)
    IF (!OpenDevice(TD_NAME,unit,diskreq0,0)) THEN mDiskBusy(str,TRUE);
ENDPROC

PROC mInitTrkDsk(unit=0)
DEF diskreq0:PTR TO ioexttd
        IF diskport:=createPort(0,0)
            IF diskreq0:=createExtIO(diskport,SIZEOF ioexttd)
                    mDoOpenDevice(diskreq0,unit);
			RETURN diskreq0
            ELSE
	    deleteExtIO(diskreq0)
	    RETURN -1
	    ENDIF
	ELSE
	deletePort(diskport)
	RETURN -2
	ENDIF
ENDPROC diskreq0

PROC mCloseTrkDsk(diskreq0)
mDiskBusy('DF0:',FALSE)
CloseDevice(diskreq0)
ENDPROC
