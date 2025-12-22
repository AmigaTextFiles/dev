/* tag.a                */

extern ALibExpunge(), ALibClose(), ALibOpen(), ALibReserved();

/* lib.c                */

extern struct Library  *LibInit   ( __A0 BPTR );
extern struct Library  *LibOpen   ( __D0 long,  __A0 struct Library * );
extern long             LibClose  ( __A0 struct Library * );
extern long             LibExpunge( __A0 struct Library * );

/* funcs.c              */

extern ULONG            LoadGUI( __A0 struct IE_Data *, __A1 UBYTE * );
extern ULONG            LoadWindows( __A0 struct IE_Data *, __A1 UBYTE * );
extern ULONG            LoadGadgets( __A0 struct IE_Data *, __A1 UBYTE * );
extern ULONG            LoadScreen( __A0 struct IE_Data *, __A1 UBYTE * );
