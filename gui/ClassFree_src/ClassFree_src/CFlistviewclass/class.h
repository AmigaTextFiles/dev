/* Class definitions */

#define GID_LIST   1
#define GID_SCRL   2

struct objectdata
{
  struct Gadget *list,*scrl;
  WORD lcnt;
  struct TagItem tagmap[2];
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
ULONG render(Class *,Object *,Msg);


ULONG hookEntry();
