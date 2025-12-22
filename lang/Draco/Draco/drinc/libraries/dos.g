*charÅDOSNAMEÅ=Å"dos.library";

ulong
ÑMODE_READWRITEÜ=Å1004,
ÑMODE_READONLYá=Å1005,
ÑMODE_OLDFILEà=Å1005,
ÑMODE_NEWFILEà=Å1006;

long
ÑOFFSET_BEGINNINGÑ=Å-1,
ÑOFFSET_BEGININGÖ=ÅOFFSET_BEGINNING,
ÑOFFSET_CURRENTÜ=Å0,
ÑOFFSET_ENDä=Å1,

ÑSHARED_LOCKâ=Å-2,
ÑACCESS_READâ=Å-2,
ÑEXCLUSIVE_LOCKÜ=Å-1,
ÑACCESS_WRITEà=Å-1;

type
ÑBPTRÅ=Åulong,
ÑHandle_tÅ=ÅBPTR,
ÑLock_tÅ=ÅBPTR,
ÑSegment_tÅ=ÅBPTR,

ÑDateStamp_tÅ=ÅstructÅ{
àulongÅds_Days;
àulongÅds_Minute;
àulongÅds_Tick;
Ñ};

ulong
ÑTICKS_PER_SECONDÑ=Å50;

type
ÑFileInfoBlock_tÅ=ÅstructÅ{
àulongÅfib_DiskKey;
àulongÅfib_DirEntryType;
à[108]charÅfib_FileName;
àulongÅfib_Protection;
àulongÅfib_EntryType;
àulongÅfib_Size;
àulongÅfib_NumBlocks;
àDateStamp_tÅfib_Date;
à[116]charÅfib_Comment;
Ñ};

ulong
ÑFIBB_SCRIPTâ=Å6,
ÑFIBB_PUREã=Å5,
ÑFIBB_ARCHIVEà=Å4,
ÑFIBB_READã=Å3,
ÑFIBB_WRITEä=Å2,
ÑFIBB_EXECUTEà=Å1,
ÑFIBB_DELETEâ=Å0,
ÑFIBF_SCRIPTâ=Å1Å<<ÅFIBB_SCRIPT,
ÑFIBF_PUREã=Å1Å<<ÅFIBB_PURE,
ÑFIBF_ARCHIVEà=Å1Å<<ÅFIBB_ARCHIVE,
ÑFIBF_READã=Å1Å<<ÅFIBB_READ,
ÑFIBF_WRITEä=Å1Å<<ÅFIBB_WRITE,
ÑFIBF_EXECUTEà=Å1Å<<ÅFIBB_EXECUTE,
ÑFIBF_DELETEâ=Å1Å<<ÅFIBB_DELETE;

type
ÑInfoData_tÅ=ÅstructÅ{
àulongÅid_NumSoftErrors;
àulongÅid_UnitNumber;
àulongÅid_DiskState;
àulongÅid_NumBlocks;
àulongÅid_NumBlocksUsed;
àulongÅid_BytesPerBlock;
àulongÅid_DiskType;
àBPTRÅid_VolumeNode;
àulongÅid_InUse;
Ñ};

ulong
ÑID_WRITE_PROTECTEDÇ=Å80,
ÑID_VALIDATINGá=Å81,
ÑID_VALIDATEDà=Å82,

ÑID_NO_DISK_PRESENTÇ=Å0xffffffff,
ÑID_UNREADABLE_DISKÇ=Å('B'Å-Å'\e')Å<<Å24Å|Å('A'Å-Å'\e')Å<<Å16Å|
ö('D'Å-Å'\e')Å<<Ç8,
ÑID_DOS_DISKâ=Å('D'Å-Å'\e')Å<<Å24Å|Å('O'Å-Å'\e')Å<<Å16Å|
ö('S'Å-Å'\e')Å<<Ç8,
ÑID_NOT_REALLY_DOSÉ=Å('N'Å-Å'\e')Å<<Å24Å|Å('D'Å-Å'\e')Å<<Å16Å|
ö('O'Å-Å'\e')Å<<Ç8Å|Å('S'Å-Å'\e'),
ÑID_KICKSTART_DISKÉ=Å('K'Å-Å'\e')Å<<Å24Å|Å('I'Å-Å'\e')Å<<Å16Å|
ö('C'Å-Å'\e')Å<<Ç8Å|Å('K'Å-Å'\e'),

ÑERROR_NO_FREE_STOREë=Å103,
ÑERROR_TASK_TABLE_FULLè=Å105,
ÑERROR_LINE_TOO_LONGë=Å120,
ÑERROR_FILE_NOT_OBJECTè=Å121,
ÑERROR_INVALID_RESIDENT_LIBRARYÜ=Å122,
ÑERROR_NO_DEFAULT_DIRê=Å201,
ÑERROR_OBJECT_IN_USEë=Å202,
ÑERROR_OBJECT_EXISTSë=Å203,
ÑERROR_DIR_NOT_FOUNDë=Å204,
ÑERROR_OBJECT_NOT_FOUNDé=Å205,
ÑERROR_BAD_STREAM_NAMEè=Å206,
ÑERROR_OBJECT_TOO_LARGEé=Å207,
ÑERROR_ACTION_NOT_KNOWNé=Å209,
ÑERROR_INVALID_COMPONENT_NAMEà=Å210,
ÑERROR_INVALID_LOCKí=Å211,
ÑERROR_OBJECT_WRONG_TYPEç=Å212,
ÑERROR_DISK_NOT_VALIDATEDå=Å213,
ÑERROR_DISK_WRITE_PROTECTEDä=Å214,
ÑERROR_RENAME_ACROSS_DEVICESâ=Å215,
ÑERROR_DIRECTORY_NOT_EMPTYã=Å216,
ÑERROR_TOO_MANY_LEVELSè=Å217,
ÑERROR_DEVICE_NOT_MOUNTEDå=Å218,
ÑERROR_SEEK_ERRORî=Å219,
ÑERROR_COMMENT_TOO_BIGè=Å220,
ÑERROR_DISK_FULLï=Å221,
ÑERROR_DELETE_PROTECTEDé=Å222,
ÑERROR_WRITE_PROTECTEDè=Å223,
ÑERROR_READ_PROTECTEDê=Å224,
ÑERROR_NOT_A_DOS_DISKê=Å225,
ÑERROR_NO_DISKó=Å226,
ÑERROR_NO_MORE_ENTRIESè=Å232,

ÑRETURN_OKõ=Å0,
ÑRETURN_WARNô=Å5,
ÑRETURN_ERRORò=Å10,
ÑRETURN_FAILô=Å20,

ÑSIGBREAKB_CTRL_CÑ=Å12,
ÑSIGBREAKB_CTRL_DÑ=Å13,
ÑSIGBREAKB_CTRL_EÑ=Å14,
ÑSIGBREAKB_CTRL_FÑ=Å15,

ÑSIGBREAKF_CTRL_CÑ=Å1Å<<ÅSIGBREAKB_CTRL_C,
ÑSIGBREAKF_CTRL_DÑ=Å1Å<<ÅSIGBREAKB_CTRL_D,
ÑSIGBREAKF_CTRL_EÑ=Å1Å<<ÅSIGBREAKB_CTRL_E,
ÑSIGBREAKF_CTRL_FÑ=Å1Å<<ÅSIGBREAKB_CTRL_F;

extern
ÑOpenDosLibrary(ulongÅversion)*DosLibrary_t,
ÑCloseDosLibrary()void,

ÑClose(Handle_tÅfd)void,
ÑCreateDir(*charÅname)Lock_t,
ÑCurrentDir(Lock_tÅlock)Lock_t,
ÑDeleteFile(*charÅname)boid,
ÑDupLock(Lock_tÅlock)Lock_t,
ÑExamine(Lock_tÅlock;Å*FileInfoBlock_tÅfib)bool,
ÑExNext(Lock_tÅlock;Å*FileInfoBlock_tÅfib)bool,
ÑInfo(Lock_tÅlock;Å*InfoData_tÅid)bool,
ÑInput()Handle_t,
ÑIoErr()ulong,
ÑIsInteractive(Handle_tÅfd)bool,
ÑLock(*charÅname;ÅlongÅaccessMode)Lock_t,
ÑOpen(*charÅname;ÅulongÅaccessMode)Handle_t,
ÑOutput()Handle_t,
ÑParentDir(Lock_tÅlock)Lock_t,
ÑRead(Handle_tÅfd;ÅarbptrÅbuffer;ÅulongÅlength)ulong,
ÑRename(*charÅoldName,ÅnewName)bool,
ÑSeek(Handle_tÅfd;ÅlongÅposition,ÅseekMode)long,
ÑSetComment(*charÅname,Åcomment)bool,
ÑSetProtection(*charÅname;ÅulongÅmask)bool,
ÑUnLock(Lock_tÅlock)void,
ÑWaitForChar(Handle_tÅfd;ÅulongÅtimeout)bool,
ÑWrite(Handle_tÅfd;ÅarbptrÅbuffer;ÅulongÅlength)ulong,

ÑCreateProc(*charÅname;ÅlongÅpri;ÅSegment_tÅseg;ÅulongÅstackSize)*MsgPort_t,
ÑDateStamp(*DateStamp_tÅds)void,
ÑDelay(ulongÅtimeout)void,
ÑDeviceProc(*charÅname)*MsgPort_t,
ÑExit(ulongÅreturnCode)void,

ÑExecute(*charÅcommandString;ÅHandle_tÅinputFd,ÅoutputFd)bool,
ÑLoadSeg(*charÅname)Segment_t,
ÑUnLoadSeg(Segment_tÅsegment)bool,

ÑDosError(intÅerrorCode)*char;
