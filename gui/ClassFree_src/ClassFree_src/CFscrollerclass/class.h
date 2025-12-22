/* Class definitions */

#define DECBTN    1
#define INCBTN    2


struct objectdata
{
  Object *act;
  struct Gadget *prop,*decbtn,*incbtn;
  struct Image *pframe;
  WORD rep;

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
ULONG update(Class *,Object *,Msg);
ULONG hittest(Class *,Object *,Msg);
ULONG goactive(Class *,Object *o,Msg);
ULONG handleinput(Class *,Object *,Msg);
ULONG goinactive(Class *,Object *,Msg);
ULONG render(Class *,Object *,Msg);

ULONG hookEntry();
