
/*	MACHINE GENERATED		*/


/*	OpenPort.c		*/

extern  struct ArexxPort *OpenArexxPortA(STRPTR, struct TagItem *);
extern  struct ArexxPort *OpenArexxPort(STRPTR, Tag, ...);

/*	ClosePort.c		*/

extern  struct ArexxPort *CloseArexxPort(struct ArexxPort *);

/*	CheckPort.c		*/

extern  struct ArexxMsg *CheckArexxPort(struct ArexxPort *port);
extern  void ReplyArexxPort(struct ArexxMsg *);

/*	Launch.c		*/

extern  struct ArexxInvocation *LaunchArexx( struct ArexxPort *port, STRPTR macro, BOOL console, ULONG user);

/*	Misc.c		*/

extern  void SetArexxReturns( struct ArexxMsg *Amsg, UWORD rc, STRPTR r2);
extern  void SetArexxError( struct ArexxMsg *Amsg, STRPTR error, UWORD level);
extern  LONG SetArexxStem(STRPTR, STRPTR, STRPTR, struct RexxMsg *);

/*	Returns.c		*/


/*	ToArexx.c		*/

extern  BOOL PutToArexxPort(STRPTR, STRPTR);
extern  void ArexxMacroAbort(struct ArexxPort *, BOOL );
extern  BOOL ArexxMacroPending( struct ArexxPort * );

/*	thirtyseven.c		*/

extern  UWORD ReturnArexxError( struct ArexxMsg *amsg );
extern  UWORD SetArexxReturnVar( struct ArexxMsg * amsg, UWORD rc, STRPTR r2, STRPTR var );
