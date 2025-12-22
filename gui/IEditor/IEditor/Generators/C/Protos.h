#ifndef PROTOS_H
#define PROTOS_H

struct CPrefs {
	UBYTE   Flags;
	UBYTE   MoreFlags;          /* not used yet */
	TEXT    ChipString[24];
	TEXT    HeadersFile[256];
	TEXT    HookDef[32];
	TEXT    RegisterDef[32];
};

/*  MoreFlags   */

#define USE_CATCOMP     (1 << 0)
#define NO_BUTTON_KP    (1 << 1)


/// Functions
extern void GrabOldPrefs( struct IE_Data * );

extern void WriteMain( struct GenFiles *, struct IE_Data * );
extern void WriteSetupScr( struct GenFiles *, struct IE_Data * );
extern void WriteOpenWnd( struct GenFiles *, struct IE_Data * );
extern void WriteOpenWndShd( struct GenFiles *, struct IE_Data * );
extern void WriteRender( struct GenFiles *, struct IE_Data * );
extern void WriteIDCMPHandler( struct GenFiles *, struct IE_Data * );
extern void WriteKeyHandler( struct GenFiles *, struct IE_Data * );
extern void WriteClickedPtrs( struct GenFiles *, struct IE_Data * );
extern void WriteClicked( struct GenFiles *, struct IE_Data *, struct MinList * );
extern void WriteLocale( struct GenFiles *, struct IE_Data * );
extern void WriteGBanksHandling( struct GenFiles *, struct IE_Data * );
extern void WriteListHook( struct GenFiles *, struct IE_Data * );
extern void WriteBackFillHook( struct GenFiles *, struct IE_Data * );

extern void WriteFontPtrs( struct GenFiles *, struct IE_Data * );
extern void WriteOpenFonts( struct GenFiles *, struct IE_Data * );

extern BOOL AskFile( UBYTE *, struct IE_Data * );
extern void WriteList( struct GenFiles *, struct MinList *, UBYTE *, UWORD, struct IE_Data *IE );
extern void WriteLocaleH( struct GenFiles *, struct IE_Data *, STRPTR );

extern void WriteNewGads( struct GenFiles *, struct IE_Data *, struct MinList *, ULONG );
extern void WriteTags( struct GenFiles *, struct IE_Data *, struct MinList *, ULONG );
extern void WriteBooleans( struct GenFiles *, struct IE_Data *, struct MinList *, struct WindowInfo * );
extern void WriteGTypes( struct GenFiles *, struct IE_Data *, struct MinList * );
extern void WriteGLabels( struct GenFiles *, struct IE_Data *, struct MinList *, struct WindowInfo * );

extern BOOL CheckMultiSelect( struct IE_Data * );
extern void WriteGadgetExtData( struct GenFiles *, struct IE_Data * );
extern void WriteNewGadgets( struct GenFiles *, struct IE_Data * );
extern void WriteGadgetTags( struct GenFiles *, struct IE_Data * );
extern void WriteBoolStruct( struct GenFiles *, struct IE_Data * );

extern void WriteMenuStruct( struct GenFiles *, struct IE_Data * );
extern void WriteITexts( struct GenFiles *, struct IE_Data * );
extern void WriteImgStruct( struct GenFiles *, struct IE_Data * );
extern void WriteImageStruct( struct GenFiles *, struct IE_Data * );
extern void WriteRexxCmds( struct GenFiles *, struct IE_Data * );
extern void WriteWindowTags( struct GenFiles *, struct IE_Data * );
extern void WriteScreenTags( struct GenFiles *, struct IE_Data * );
extern void WriteGadgetBanks( struct GenFiles *, struct IE_Data * );

extern void LoadPrefs( void );
///
/// Data
extern BOOL             PrefsOK;
extern struct CPrefs    Prefs;

extern UBYTE    Header[], Null[];
extern ULONG    idcmps[], wflgs[];

#define IDCMPS_NUM  27
#define WFLAGS_NUM  18

extern ULONG    IDCMPVer[];

extern UBYTE   *IDCMPVerStr[], *IDCMPVerProto[];
extern UBYTE   *IDCMPVerTmp[], VanillaTmp[];
extern UBYTE    CaseRefresh[], CaseRefresh2[];
extern UBYTE   *IDCMPStr[], *IDCMPProto[];
extern UBYTE   *IDCMPTmp[];
///

#endif
