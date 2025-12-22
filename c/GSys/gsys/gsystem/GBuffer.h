
/* Author Anders K */

#ifndef GBUFFER_H
#define GBUFFER_H

#include "gsystem/GObject.h"

#ifndef GFILE_H
#define GSEEK_START 0x0001
#define GSEEK_END 0x0002
#define GSEEK_CURRENT 0x0004
#endif

class GBuffer : public GObject
{
public:
	GBuffer() { memset((GAPTR)this, 0, sizeof(GBuffer)); };
	GBuffer(GSTRPTR filename, GUWORD start, GUWORD len);		// String 
	GBuffer(GUWORD size);
	~GBuffer();

	BOOL InitGBuffer(GSTRPTR filename, GUWORD start, GUWORD len, GSTRPTR objtype);
	BOOL InitGBuffer(GUWORD size, GSTRPTR objtype);

	GUWORD GetSize() { return Size; };

	GAPTR LockBuf();				// Might get more advanced in the future
	void UnLockBuf() { Locked = TRUE; } ;	// Not available yet

	BOOL Load(GSTRPTR filename, GUWORD start, GUWORD len);

/*
	BOOL Seek(GWORD offset, GUWORD seekmode);
	GUWORD Peek(GUWORD len);
	GUWORD Poke(GUWORD len);
*/
	BOOL Seek(GWORD offset, GUWORD seekmode) { return FALSE; };
	GUWORD Peek(GUWORD len) { return NULL; };
	GUWORD Poke(GUWORD len) { return NULL; };
private:

protected:
	BOOL Locked;		// Default TRUE
	GAPTR Buffer;		// Not always NON-ZERO
	GUWORD Size;		// Total Size
	GUWORD FileSize;
	GUWORD FilePtr;		// Chunk Size
	char FileName[256];	// FileName

#ifdef GWINDOWS

#endif

};

#endif /* GBUFFER_H */
