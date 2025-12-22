
#ifndef GCHUNKHANDLER_H
#define GCHUNKHANDLER_H

/*

TODO: Rewrite a lot of it.

*/

#define SIZELONG 4
#define SIZEWORD 2
#define SIZEBYTE 1

#include "gsystem/GBuffer.h"
#include "gsystem/GBufferMet.h"

class GChunk
{
public:
	GChunk();
	~GChunk() {};

	class GChunk *Prev; 
	class GChunk *Next;
	GAPTR Start;
	GAPTR End;
private:
};

GChunk::GChunk()
{
	Prev = NULL;
	Next = NULL;
	Start = NULL;
	End = NULL;
}

class	GChunkHandler
{
public:
//	GChunkHandler(class GBuffer *GBUF, WORD SIZEID, WORD SIZESIZE, BOOL BACKWARDS);
//	GChunkHandler(APTR DATA, WORD SIZEID, WORD SIZESIZE, BOOL BACKWARDS);
	GChunkHandler(GSTRPTR filename);		// String 
	GChunkHandler(GUWORD size);
	GChunkHandler(GUWORD size, GSTRPTR name);	// The string will NOT be stored (not true:D)
	~GChunkHandler();

	
	GAPTR Adjust(GWORD Size);
	GAPTR EnterChunk();		/* NULL = No chunk, Size = 0 */
	GAPTR NextChunk();	/* NULL = Not possible, out of range */
	GAPTR ParentChunk();		/* Goes up a level */
	GAPTR FindChunk(GUWORD FindID);	/* Finds chunk with the requested ID (use Enter() to enter) */
	GAPTR FindChunk(GSTRPTR FindTextID, GUWORD SIZE);

	GAPTR GetEND();		/* Gets the end of the chunk */
	GUWORD GetID();		/* Gets ID of current chunk */
	GUWORD GetSIZE();	/* Gets SIZE of the current chunk */

	GUWORD GetLong(GAPTR DATA);
	GUSHORT GetWord(GAPTR DATA);

private:
	class	GChunk Root;
	class	GChunk *Current;

	GSHORT	SizeOfID;
	GSHORT	SizeOfSize;
	BOOL	Backwards;
};


#endif /* GCHUNKHANDLER_H */