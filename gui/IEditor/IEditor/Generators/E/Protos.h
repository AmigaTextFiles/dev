#ifndef PROTOS_H
#define PROTOS_H

/// Functions
extern void StrToUpper( STRPTR, STRPTR );
extern void StrToLower( STRPTR, STRPTR );

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

extern void WriteFontPtrs( struct GenFiles *, struct IE_Data * );
extern void WriteOpenFonts( struct GenFiles *, struct IE_Data * );

extern BOOL AskFile( UBYTE *, struct IE_Data * );
extern void WriteList( struct GenFiles *, struct MinList *, UBYTE *, UWORD, struct IE_Data *IE );
extern void WriteCD( struct GenFiles * );

extern UWORD CountArray( UBYTE ** );
extern BOOL CmpArrays( UBYTE **, struct MinList * );
extern struct StringNode *FindString( struct MinList *, UBYTE * );
extern struct ArrayNode *FindArray( struct MinList *, struct MinList * );
extern BOOL AddString( struct MinList *, UBYTE * );
extern BOOL AddArray( struct GenFiles *, struct MinList * );
extern void PutLabels( struct IE_Data *, struct GenFiles * );
extern BOOL ProcessStrings( struct IE_Data *, struct GenFiles * );
extern void FreeStrings( struct GenFiles * );
extern BOOL ProcessGadgets( struct GenFiles *, struct MinList * );

extern void WriteNewGads( struct GenFiles *, struct IE_Data *, struct MinList *, ULONG );
extern void WriteTags( struct GenFiles *, struct IE_Data *, struct MinList *, ULONG );
extern void WriteBooleans( struct GenFiles *, struct IE_Data *, struct MinList *, struct WindowInfo * );
extern void WriteGTypes( struct GenFiles *, struct IE_Data *, struct MinList * );
extern void WriteGLabels( struct GenFiles *, struct IE_Data *, struct MinList *, struct WindowInfo * );

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
///
/// Data
extern UBYTE    Header[], Null[];
extern ULONG    idcmps[], wflgs[];

#define IDCMPS_NUM ( sizeof( idcmps ) / sizeof( ULONG ))
#define WFLAGS_NUM ( sizeof( wflgs ) / sizeof( ULONG ))

extern ULONG    IDCMPVer[];

extern UBYTE   *IDCMPVerStr[], *IDCMPVerProto[];
extern UBYTE   *IDCMPVerTmp[], VanillaTmp[];
extern UBYTE    CaseRefresh[], CaseRefresh2[];
extern UBYTE   *IDCMPStr[], *IDCMPProto[];
extern UBYTE   *IDCMPTmp[];
///

#endif
