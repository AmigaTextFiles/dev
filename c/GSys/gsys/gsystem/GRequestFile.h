
#ifndef GREQUESTFILE
#define GREQUESTFILE

#ifdef GAMIGA

#include <exec/types.h>

#ifdef GAMIGA_PPC
#include <powerup/ppcproto/exec.h>
#include <powerup/ppcproto/dos.h>
#include <powerup/ppcproto/asl.h>
#else
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/asl.h>
#endif

#endif

#define RF_TITLETEXT		0x00000010
#define RF_GSCREEN		0x00000020
#define RF_PATTERNSHOW		0x00000030
#define RF_REJECTPATTERN	0x00000031
#define RF_ACCEPTPATTERN	0x00000032
#define RF_INITPATTERN		0x00000033
#define RF_INITPATH		0x00000040
#define RF_SAVEMODE		0x00000050
#define RF_MULTIFILES		0x00000060
#define RF_ONLYDRAWERS		0x00000070

/*

TO DO:

Få pattern-opplegget til å funke like bra på amiga/pc

*/


class GRequestFile
{
public:
	GRequestFile(GTagItem *TagList);	//GTagItem *TagList[]);
	~GRequestFile();
	
	BOOL RequestNewFile(GTagItem *TagList);

	class GRequestFile *NextGRequestFile;

	char FileName[256];	// Full path of selected file
	BOOL Status;	// Was it cancelled(FALSE) or accepted(TRUE) on the last pop-up?

private:
	class GScreen *GScreen;
	STRPTR	TitleText;
	STRPTR	InitPattern;
	STRPTR	InitPath;
	BOOL	PatternShow;
	BOOL	RejectPattern;	
	BOOL	AcceptPattern;
	BOOL	SaveMode;
	BOOL	MultiFiles;
	BOOL	OnlyDrawers;

#ifdef GAMIGA
	STRPTR GetFileName(struct FileRequester *FileReq)

	struct FileRequester *FileRequester;

#endif
#ifdef GDIRECTX
#endif

};

#endif /* GFILEREQUEST */