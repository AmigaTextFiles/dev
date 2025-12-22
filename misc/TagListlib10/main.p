extern TEXT __far LibName[] ;
extern TEXT __far LibID[] ;
extern APTR LibFunc[] ;
extern LONG __far LibSegList					;
extern struct Library *  __asm LibInit(
	REGISTER __a0 LONG seglist
);
extern struct Library * __asm LibOpen(
	REGISTER __a6 struct Library *libbase
);
extern LONG __asm LibClose(
	REGISTER __a6 struct Library *libbase
);
extern LONG __asm LibExpunge(
	REGISTER __a6 struct Library *libbase
);
extern LONG __asm LibExtFunc(
	VOID
);
extern LONG __asm main(
	VOID
);
