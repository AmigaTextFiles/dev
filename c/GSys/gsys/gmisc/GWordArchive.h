
/* Author Anders K */

#ifndef GWORDARCHIVE_H
#define GWORDARCHIVE_H

#include "gsystem/GFile.h"
//#include "gsystem/GFileMet.h"

typedef struct FileChunk_	// size 64
{
	GWORD Head;	// invalid == 0xffffffff
	GWORD Higher;
	GWORD Lower;
	GWORD Valid;
	char Data[64+20];
} FileChunk;

class GWordArchive : public GFile
{
public:
	GWordArchive() { memset((GAPTR)this, 0, sizeof(GWordArchive)); };
	GWordArchive(GSTRPTR filename);
	~GWordArchive();

	BOOL DumpWord(GSTRPTR word);
	BOOL FindWord(GSTRPTR word);
	BOOL HardFindWord(GSTRPTR word);

	BOOL CacheOn(GWORD size);
	BOOL CacheOff();
	BOOL ReloadCache();
	BOOL UpdateCache();
	BOOL CacheRead(GAPTR buffer, GWORD len, BOOL force);
	BOOL CacheWrite(GAPTR buffer, GWORD len, BOOL force);

private:
	BOOL UseCache;
	char *Cache;
	GWORD CPos;
	GWORD CSize;
protected:

#ifdef GWINDOWS
#endif

};

#endif /* GWORDARCHIVE_H */
