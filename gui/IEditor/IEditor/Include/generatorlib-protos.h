/* tag.a                */

extern ALibExpunge(), ALibClose(), ALibOpen(), ALibReserved();

/* lib.c                */

extern struct Library  *LibInit   ( __A0 BPTR );
extern struct Library  *LibOpen   ( __D0 long,  __A0 struct Library * );
extern long             LibClose  ( __A0 struct Library * );
extern long             LibExpunge( __A0 struct Library * );

/* funcs.c              */

extern struct GenFiles *OpenFiles( __A0 struct IE_Data *, __A1 UBYTE * );
extern void             CloseFiles( __A0 struct GenFiles * );
extern BOOL             WriteHeaders( __A0 struct GenFiles *, __A1 struct IE_Data *);
extern BOOL             WriteVars( __A0 struct GenFiles *, __A1 struct IE_Data * );
extern BOOL             WriteData( __A0 struct GenFiles *, __A1 struct IE_Data * );
extern BOOL             WriteStrings( __A0 struct GenFiles *, __A1 struct IE_Data * );
extern BOOL             WriteChipData( __A0 struct GenFiles *, __A1 struct IE_Data * );
extern BOOL             WriteCode( __A0 struct GenFiles *, __A1 struct IE_Data * );
extern void             Config( __A0 struct IE_Data * );
