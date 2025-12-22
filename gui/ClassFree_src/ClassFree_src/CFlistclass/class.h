/* Class definitions */

#define LIST_READONLY    (1L<<0)
#define LIST_CHANGED     (1L<<1)

struct objectdata
{
  struct Image *border,*labimg;
  struct List *labels;
  ULONG top,sel,nsel,vis,lcnt,flags;
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
ULONG getattrs(Class *,Object *,Msg);
ULONG setattrs(Class *,Object *,Msg);
ULONG handleinput(Class *,Object *,Msg);
ULONG inactivate(Class *,Object *,Msg);
ULONG render(Class *,Object *,Msg);



ULONG hookEntry();
