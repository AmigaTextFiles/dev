/* Class definitions */

#define TXIF_EDGES   (1L<<8)
#define TXIF_LAYOUT  (1L<<15)
#define TXIF_REDRAW  (1L<<16)

struct objectdata
{
  WORD txtx,txty,xmin,ymin,xmax,ymax;
  ULONG len,flags;
  UWORD *pens;
};

struct classbase
{
  struct Library library;
  UWORD pad;
  Class *cl;
  BPTR seglist;
};

/* Prototypes */

Class *initclass(struct classbase *);
BOOL removeclass(struct classbase *);
ULONG dispatcher();
ULONG hookEntry();
