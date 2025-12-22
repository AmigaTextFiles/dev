
/* Author Anders Kjeldsen */

#ifndef GCHUNKHANDLER_CPP
#define GCHUNKHANDLER_CPP

GChunkHandler(GSTRPTR filename, GUWORD sizeid, GUWORD sizesize, BOOL backwards);		// String 
{
	memset((void *)this, 0, sizeof(this));
	if ( InitGBuffer(filename) )
	{
		Current = &Root;
		SizeOfID = sizeid;
		SizeOfSize = sizesize;
		Backwards = backwards;
		Root.Start = Buffer;
		Root.End = (APTR) ((GUBYTE *)Buffer + SizeOfID + SizeOfSize + GetSIZE() );
		return true;
	}
	return false;
}

GChunkHandler::~GChunkHandler()
{
	class GChunk *First = Root.Next;
	class GChunk *Next = First->Next;
	while (First)
	{
		delete First;
		First = Next;
		Next = First->Next;
	}
}

APTR GChunkHandler::Adjust(LONG Size)
{
//#ifdef GDEBUG
	printf("Adjusting current Chunk by %i\n", Size);
//#endif
	LONG New = (LONG) Current->Start;
	New+=Size;
	Current->Start = (APTR) New;
	return Current;
}

APTR GChunkHandler::EnterChunk()
{
//#ifdef GDEBUG
	char TempText[5];
	TempText[4] = 0;
	
	((ULONG *)TempText)[0] = GetID();
	printf("Entering Chunk '");
	printf(TempText);
	printf("'.\n");
//#endif
	class GChunk *Prev = Current;
	Current->Next = new GChunk;
	Current->Next->Prev = Current;
	Current = Current->Next;
	Current->Start = (APTR) ((UBYTE *)Prev->Start + SizeOfID + SizeOfSize);
	Current->End = (APTR) ((UBYTE *)Current->Start + SizeOfID + SizeOfSize + GetSIZE() );

//#ifdef GDEBUG
	((ULONG *)TempText)[0] = GetID();
	printf("First chunk found is '");
	printf(TempText);
	printf("'.\n");
//#endif

	return Current->Start;
}

APTR GChunkHandler::NextChunk()
{
	char TempText[5];
	TempText[4] = 0;

	if (Current->Start < Current->Prev->End)
	{
		Current->Start = (APTR) ( (UBYTE *)Current->Start + SizeOfID + SizeOfSize + GetSIZE() );
		Current->End = (APTR) ((UBYTE *)Current->Start + SizeOfID + SizeOfSize + GetSIZE() );
		if (Current->Start < Current->Prev->End)
		{

//#ifdef GDEBUG
			((ULONG *)TempText)[0] = GetID();
			printf("Jumped to Chunk '");
			printf(TempText);
			printf("'.\n");
//#endif
			return Current->Start;
		}
		else
		{
//#ifdef GDEBUG
			((ULONG *)TempText)[0] = GetID();
			printf("Could NOT jump to Chunk '");
			printf(TempText);
			printf("'!\n");
//#endif

			return NULL;
		}
	}
	else
	{
//#ifdef GDEBUG
		((ULONG *)TempText)[0] = GetID();
		printf("Could NOT jump to Chunk '");
		printf(TempText);
		printf("'!\n");
//#endif

		return NULL;
	}
}

APTR GChunkHandler::ParentChunk()
{
//#ifdef GDEBUG
	char TempText[5];
	TempText[4] = 0;
//#endif

	if (Current->Prev)
	{
		Current = Current->Prev;
		delete Current->Next;
		Current->Next = NULL;

//#ifdef GDEBUG
		((ULONG *)TempText)[0] = GetID();
		printf("Returned to Chunk '");
		printf(TempText);
		printf("'!\n");
//#endif


		return Current->Start;
	}
	else return NULL;
}

APTR GChunkHandler::FindChunk(ULONG FindID)
{
//#ifdef GDEBUG
	char TempText[5];
	TempText[4] = 0;
	
	((ULONG *)TempText)[0] = FindID;
	printf("Searching for Chunk '");
	printf(TempText);
	printf("'.\n");
//#endif

	ULONG IDtemp = GetID();

	while (IDtemp != FindID)
	{
		if (NextChunk())
		{
			IDtemp = GetID();
		}
		else
		{
#ifdef GDEBUG
			printf("Search for '");
			printf(TempText);
			printf("' was NOT succesfull!\n");
#endif
			return NULL;
		}
	}
//#ifdef GDEBUG
	printf("Search for '");
	printf(TempText);
	printf("' was succesfull.\n");
//#endif

	return Current->Start;
}

APTR GChunkHandler::FindChunk(char *FindTextID, ULONG SIZE)	// MAX 4 CHARS
{
//#ifdef GDEBUG
	printf("Searching for Chunk '");
	printf(FindTextID);
	printf("'.\n");
//#endif
	ULONG FindID = NULL;
	switch (SIZE)
	{
		case SIZELONG:
			FindID = (ULONG) ((ULONG *)FindTextID)[0];
		break;
		case SIZEWORD:
			FindID = (ULONG) ((UWORD *)FindTextID[0]);
		break;
	}

	ULONG IDtemp = GetID();

	while (IDtemp != FindID)
	{
		if (NextChunk())
		{
			IDtemp = GetID();
		}
		else 
		{
//#ifdef GDEBUG
			printf("Search for Chunk '");
			printf(FindTextID);
			printf("'. was NOT succesful!\n");
//#endif
			return NULL;
		}
	}
//#ifdef GDEBUG
	printf("Search for Chunk '");
	printf(FindTextID);
	printf("' was succesful.\n");
//#endif

	return Current->Start;
}


ULONG GChunkHandler::GetID()
{
	switch (SizeOfID)
	{
		case SIZELONG:
			return GetLong(Current->Start);
		break;
		case SIZEWORD:
			return (ULONG) GetWord(Current->Start);
		break;
	}
}

ULONG GChunkHandler::GetSIZE()
{
	switch (SizeOfSize)
	{
		case SIZELONG:
			return GetLong( (APTR) ((UBYTE*)Current->Start + SizeOfID) );
		break;
		case SIZEWORD:
			return (ULONG) GetWord( (APTR) ((UBYTE*)Current->Start + SizeOfID) );
		break;
	}
}

APTR GChunkHandler::GetEND()
{
	return Current->End;
}

ULONG GChunkHandler::GetLong(APTR DATA)
{
	UBYTE *data = (UBYTE *)DATA;

	if (Backwards)
	return	( ((ULONG)data[3])<<24 ) +
		( ((ULONG)data[2])<<16 ) +
		( ((ULONG)data[1])<<8 ) +
		(ULONG)data[0];
	else
	return	( (ULONG *) DATA)[0];
}

UWORD GChunkHandler::GetWord(APTR DATA)
{
	UBYTE *data = (UBYTE *)DATA;
	if (Backwards)
	return	( ((UWORD)data[1])<<8 ) +
		(WORD)data[0];
	else
	return	((WORD *) DATA)[0];
}

#endif /* GCHUNKHANDLER_CPP */