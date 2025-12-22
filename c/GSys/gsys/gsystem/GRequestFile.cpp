
#ifndef GREQUESTFILEMET
#define GREQUESTFILEMET

GRequestFile::GRequestFile(GTagItem *TagList);
{
	memset((void *)this, 0, sizeof (this) );
	if (Parent)
	{
		Parent->InsertGRequestFile(this);

		FileRequester = NULL;
		NextGRequestFile = NULL;
		Status FALSE;
		FileName[0] = 0;

		GScreen = NULL;
		TitleText = "Please select file(s)";
		InitPattern = NULL;
		InitPath = NULL;
		PatternShow = TRUE;
		RejectPattern = NULL;
		AcceptPattern = NULL;
		SaveMode = FALSE;
		MultiFiles FALSE;
		OnlyDrawers FALSE;

		while (TagList->TagItem)
		{
			switch (TagList->TagItem)
			{
				case RF_TITLETEXT:
					TitleText = TagList->TagData;
				break;
				case RF_GSCREEN:
					GScreen = TagList->TagData;
				break;
				case RF_PATTERNSHOW:
					PatternShow = TagList->TagData;
				break;	

				case RF_REJECTPATTERN:
					RejectPattern = TagList->TagData;
				break;
				case RF_ACCEPTPATTERN:
					AcceptPattern = TagList->TagData;
				break;
				case RF_INITPATTERN:
					InitPattern = TagList->TagData;
				break;

				case RF_INITPATH:
					InitPath = TagList->TagData;
				break;
				case RF_SAVEMODE:
					SaveMode = TagList->TagData;
				break;
				case RF_MULTIFILES:
					MultiFiles = TagList->TagData;
				break;
				case RF_ONLYDRAWERS:
					OnlyDrawers = TagList->TagData;
				break;
			}
			TagList++;
		}
#ifdef GAMIGA
		FileRequest = (struct FileRequester *)AllocAslRequest(ASL_FileRequest, NULL);
#endif
	}
}

		AslRequestTags(LoadFileReq,
		ASLFR_TitleText, "Select File to load",
		ASLFR_Screen, MainScreen,
		ASLFR_Flags1, FRF_DOPATTERNS,
		ASLFR_InitialDrawer, "asm:objects/lw",
		ASLFR_InitialPattern, NULL,
		TAG_DONE);


#ifdef GAMIGA
STRPTR GetFileName(struct FileRequester *FileReq)
{
	STRPTR Dest = CompleteFileName;
	Dest = CopyString(FileReq->fr_Drawer, Dest);
	if ( Dest[-2] != 0x2f )
	{
		if ( Dest[-2] != 0x3a )
		{
			if ( Dest[-2] ) Dest[-1] = 0x2f;
			else return NULL;
		}
		else Dest-=1;
	}
	else Dest-=1;
	CopyString(FileReq->fr_File, Dest);
	return CompleteFileName;
}
#endif

#endif /* GREQUESTFILEMET */