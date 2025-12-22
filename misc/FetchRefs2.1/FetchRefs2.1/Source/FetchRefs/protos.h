/* FindRef.c */
void TellWeStopOutline (void);
void __regargs FindRef ( struct FindRefOptions *args , struct FindRefReturnStruct *ret );
void __regargs GiveHelp (struct Screen *scr );
long __regargs SortListFunc ( struct ListViewNode *a , struct ListViewNode *b , ULONG data );
LONG __regargs FileLength ( STRPTR name );
void * __regargs ListOffsetToPtr ( struct List *l , LONG o );

/* Main.c */
extern struct IntuitionBase * IntuitionBase;
extern struct Library * RexxSysBase, * GTLayoutBase;
extern struct LocaleBase * LocaleBase;

char * __regargs GetString (long indice);
void __regargs ReadWild ( STRPTR (*patharrayptr )[]);
void __regargs ReadRefs ( STRPTR filename , LONG filesize );
BOOL __regargs LoadData ( BPTR file , LONG filesize );
void FreeRefs ( void );
void CloseAll ( LONG error , ...);
void PostMessage ( STRPTR fmt , ...);
void SPrintf ( UBYTE *buf , UBYTE *fmt , ...);

/* MessageLoop.c */
void MessageLoop ( void );
void HandleCxMessage ( void );
void __regargs InstallCx ( STRPTR name );
void RemoveCx ( void );

/* ToolTypesToReadArgs.c */
int __regargs ToolTypesToReadArgs ( char **tt , char *tp , char *to , int options );
