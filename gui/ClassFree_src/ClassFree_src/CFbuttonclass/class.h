/* Class definitions */

//#define BUTTON_UP    0
//#define BUTTON_DOWN  1

#define F_HIGHLITE  (1L<<0)
#define F_BORDER    (1L<<1)

struct objectdata
{
  BOOL redo;
  ULONG layout,flags;
  struct Image *border,*texti;
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
ULONG setattrs(Class*,Object *,Msg);
ULONG goactive(Class *,Object *,Msg);
ULONG handleinput(Class *,Object *,Msg);
ULONG goinactive(Class *,Object *,Msg);
ULONG render(Class *,Object *,Msg);

ULONG hookEntry();
