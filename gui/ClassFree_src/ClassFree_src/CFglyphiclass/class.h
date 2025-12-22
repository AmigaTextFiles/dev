/* Class definitions */

#include <graphics/rastport.h>

#define MAXVECTORS  10

struct objectdata
{
  ULONG gtype;
  struct AreaInfo ai;
  struct TmpRas tr;
  PLANEPTR rasbuf;
  WORD vecbuf[MAXVECTORS*5];
};

struct classbase	/* A similar struct is defined in some BOOPSI expansion */
{			/* files from Amiga Int. */
  struct Library library;
  UWORD pad;
  Class *cl;
  BPTR seglist;
};

/* Prototypes */

Class *initclass(struct classbase *);
BOOL removeclass(struct classbase *);
ULONG dispatcher();
ULONG newobject(Class *,Object *,Msg);
ULONG dispose(Class *,Object *);
ULONG setattrs(Class *,Object *,Msg);
ULONG draw(Class *,Object *,Msg);

ULONG hookEntry();
