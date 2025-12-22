/* Class definitions */


struct objectdata
{
  struct List ml;
  struct Gadget *act;
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
ULONG addmember(Class *,Object *,Msg);
ULONG remmember(Class *,Object *,Msg);
ULONG hittest(Class *,Object *,Msg);
ULONG handleinput(Class *,Object *,Msg);
ULONG goinactive(Class *,Object *,Msg);
ULONG render(Class *,Object *,Msg);

ULONG hookEntry();
