
/* Author Anders K */

#ifndef GFILE_H
#define GFILE_H

#include "gsystem/GObject.h"

#ifndef GBUFFER_H
#define GSEEK_START 0x0001
#define GSEEK_END 0x0002
#define GSEEK_CURRENT 0x0004
#endif

//#define GFILE_DIR

class GFile : public GObject
{
public:
	GFile() { memset((GAPTR)this, 0, sizeof(GFile)); };
	GFile(GSTRPTR filename);
	~GFile();

	void PrintFileName() { printf("%s\n", FileName); };

	BOOL FileOpen(GSTRPTR filename);
	BOOL FileClose();
	BOOL FileLock();
	BOOL FileUnLock();
	BOOL FileSeek(GWORD offset, GUWORD seekmode);
	BOOL FileRead(GAPTR buffer, GUWORD len);
	BOOL FileWrite(GAPTR buffer, GUWORD len);

	GUWORD GetSize() { return FileSize; };
private:

protected:
	BOOL Locked;		// Default TRUE
	GWORD FilePtr;
	GWORD FileSize;
	char FileName[256];	// FileName

#ifdef GAMIGA
	BPTR FH;
#endif

#ifdef GWINDOWS
	HANDLE FH;
#endif

};

#endif /* GFILE_H */
