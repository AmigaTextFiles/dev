/* Class definitions */

#define FGF_NEW (1L<<0)

struct objectdata
{
  ULONG max,flags;
  struct Image *label;
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
ULONG draw(Class *,Object *,Msg);

ULONG hookEntry();
