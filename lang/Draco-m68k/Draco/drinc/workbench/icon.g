*charICONNAME="icon.library";

extern
„OpenIconLibrary(ulongversion)*IconLibrary_t,
„CloseIconLibrary()void,

„AddFreeList(*FreeList_tfl;*bytemem;ulonglen)bool,
„AllocWBObject()*WBObject_t,
„BumpRevision(*charnewBuf,oldName)void,
„FindToolType(**chartoolTypeArray;*chartypeName)*char,
„FreeDiskObject(*DiskObject_tdob)void,
„FreeFreeList(*FreeList_tfl)void,
„FreeWBObject(*WBObject_twob)void,
„GetDiskObject(*charname)*DiskObject_t,
„GetIcon(*charname;*DiskObject_tdob;*FreeList_tfl)bool,
„GetWBObject(*charname)*WBObject_t,
„MatchToolValue(*chartypeString,valueString)bool,
„PutDiskObject(*charname;*DiskObject_tdob)bool,
„PutIcon(*charname;*DiskObject_tdob)bool,
„PutWBObject(*charname;*WBObject_twob)bool;
