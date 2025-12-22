
#ifndef GOBJECT_H
#define GOBJECT_H

#ifdef GAMIGA

#include <exec/types.h>
#include <dos/dos.h>

#ifdef GAMIGA_PPC
#include <powerup/ppcproto/exec.h>
#include <powerup/ppcproto/dos.h>
#include <powerup/ppcproto/graphics.h>
#include <powerup/ppcproto/intuition.h>
#include <powerup/ppcproto/gadtools.h>
#include <powerup/ppcproto/asl.h>
#include <powerup/ppcproto/cybergraphics.h>
#else
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/asl.h>
#include <proto/cybergraphics.h>
#endif

#endif

typedef unsigned char GUBYTE;
typedef signed char GBYTE;
typedef unsigned short GUSHORT;
typedef signed short GSHORT;
typedef unsigned int GUWORD;
typedef signed int GWORD;
typedef void * GAPTR;
typedef char * GSTRPTR;

#include "gsystem/GError.h"

typedef struct 
{
	ULONG TagItem;
	ULONG TagData;
} GTagItem;


class GObject
{
public:
	GObject();
	~GObject();

	BOOL InitGObject(GSTRPTR type);
	void PrintObjectType();

	GWORD GetErrors();
	BOOL IsErrorFree();
	BOOL AddError( GSTRPTR id, GSTRPTR errormsg );
	GError *GetFirstError();
	void PrintErrors();

	GSTRPTR GetType() { return ObjectType; };
	GWORD GetSize() { return ObjectSize; };
private:
	GError *ErrorList;
	GWORD ObjectSize;
	char ObjectType[32];
};

#endif /* OBJECT_H */

