/* Class definitions */

struct classbase	/* A similar struct is defined in some BOOPSI expansion */
{			/* files from Amiga Int. */
  struct Library library;
  UWORD pad;
  Class *cl;
  BPTR seglist;
};

struct objectdata
{
  struct Window *actwin;
  struct Image *sellist,*selected;
  char **labels;
  UWORD entries,active;
};


/* Prototypes */

Class *initclass(struct classbase *);
BOOL removeclass(struct classbase *);
ULONG dispatcher();
ULONG newobject(Class *,Object *,Msg);
ULONG dispose(Class *,Object *);
ULONG goactive(Class *,Object *,Msg);
ULONG handleinput(Class *,Object *,Msg);
ULONG goinactive(Class *,Object *,Msg);
ULONG render(Class *,Object *,Msg);


ULONG hookEntry();
