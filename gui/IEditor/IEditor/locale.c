/// Include
#define INTUI_V36_NAMES_ONLY
#define ASL_V38_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/types.h>                 // exec
#include <exec/memory.h>
#include <dos/dos.h>                    // dos
#include <intuition/intuition.h>        // intuition
#include <libraries/gadtools.h>         // libraries
#include <libraries/iffparse.h>
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/reqtools_protos.h>
#include <clib/iffparse_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/reqtools_pragmas.h>
#include <pragmas/iffparse_pragmas.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
///
/// Prototypes
static void     HandleLocale( void );
static void     DetacheLangList( void );
static void     AttachLangList( void );
static void     DetacheStrList( void );
static void     AttachStrList( void );
static void     DetacheNSList( void );
static void     AttachNSList( void );
static BOOL     GetLine( STRPTR, UBYTE **, UBYTE * );
static BOOL     EditLang( struct LocaleLanguage * );
static BOOL     EditString( struct LocaleStr * );
static BOOL     EditTranslation( struct LocaleTranslation * );
static BOOL     AddString( UBYTE * );
static UWORD    CountArray( UBYTE ** );
static BOOL     CmpArrays( UBYTE **, struct MinList * );
static BOOL     ProcessGadgets( struct MinList * );
static void     FreeLangStr( UBYTE );
static struct LocaleTranslation *GetTranslation( STRPTR );
static void     FreeUnusedTranslations( void );
static void     ImportStrings( STRPTR, BOOL );
static BOOL     WriteCD( STRPTR );
static void     WriteCT( STRPTR, UBYTE );
static void     Import( STRPTR, struct MinList * );
static void     DetacheImpLists( void );
static void     AttachImpLists( void );
///
/// Data
static TEXT CatName[60];
static TEXT LocJoin[256];
static TEXT LocBuiltIn[30];

struct LocaleData LocInfo = {
	CatName,
	LocJoin,
	LocBuiltIn,
	0,
	{ &LocInfo.ExtraStrings.mlh_Tail, 0, &LocInfo.ExtraStrings.mlh_Head },
	{ &LocInfo.Languages.mlh_Tail,    0, &LocInfo.Languages.mlh_Head    },
	{ &LocInfo.Translations.mlh_Tail, 0, &LocInfo.Translations.mlh_Head },
	{ &LocInfo.Arrays.mlh_Tail,       0, &LocInfo.Arrays.mlh_Head },
};

static UBYTE                     SelectedLang, T_Language;
static struct LocaleStr         *SelectedString, *EditingStr, *StrInsert;
static struct LocaleTranslation *SelectedTran;

static UBYTE                    ScrFlagsBack;
static BOOL                     EL_RetCode, ET_RetCode, StrList = FALSE;

static struct MinList           *ImportList;
///


/// LocaleMenued
BOOL LocaleMenued( void )
{
    int     ret;

    if( LocaleWnd ) {
	ActivateWindow( LocaleWnd );
	WindowToFront( LocaleWnd );
	return( TRUE );
    }

    LayoutWindow( LocaleWTags );
    ret = OpenLocaleWindow();
    PostOpenWindow( LocaleWTags );

    if( ret ) {
	DisplayBeep( Scr );
	CloseLocaleWindow();
    } else {
	APTR    lock;

	lock = rtLockWindow( LocaleWnd );

	StringTag[1] = IE.Locale->Catalog;
	GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_CatName ], LocaleWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = IE.Locale->JoinFile;
	GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Join ], LocaleWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = IE.Locale->BuiltIn;
	GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_BuiltIn ], LocaleWnd,
			    NULL, (struct TagItem *)StringTag );

	IntegerTag[1] = IE.Locale->Version;
	GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Vers ], LocaleWnd,
			    NULL, (struct TagItem *)IntegerTag );

	CheckedTag[1] = ( IE.SrcFlags & LOCALIZE ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_On ], LocaleWnd,
			    NULL, (struct TagItem *)CheckedTag );

	AttachLangList();

	if(!( GetStrings() ))
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

	for( StrInsert = IE.Locale->ExtraStrings.mlh_Head; StrInsert->Node.ln_Succ; StrInsert = StrInsert->Node.ln_Succ )
	    if( StrInsert->Node.ln_Pri & LOC_GUI ) {
		StrInsert = StrInsert->Node.ln_Pred;
		break;
	    }

	AttachStrList();

	ScrFlagsBack = IE.SrcFlags;

	LocaleWnd->ExtData = HandleLocale;

	rtUnlockWindow( LocaleWnd, lock );
    }

    return( TRUE );
}

void HandleLocale( void )
{
    if(!( HandleLocaleIDCMP() )) {
       CloseLocaleWindow();

       PutStrings();
    }
}

BOOL LOC_OnKeyPressed( void )
{
    CheckedTag[1] = ( IE.SrcFlags & LOCALIZE ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_On ], LocaleWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( LOC_OnClicked() );
}

BOOL LOC_OnClicked( void )
{
    IE.SrcFlags ^= LOCALIZE;
    return( TRUE );
}

BOOL LOC_OkKeyPressed( void )
{
    return( LOC_OkClicked() );
}

BOOL LOC_OkClicked( void )
{
    strcpy( IE.Locale->Catalog, GetString( LocaleGadgets[ GD_LOC_CatName ]) );
    strcpy( IE.Locale->JoinFile, GetString( LocaleGadgets[ GD_LOC_Join ]) );
    strcpy( IE.Locale->BuiltIn, GetString( LocaleGadgets[ GD_LOC_BuiltIn ]) );

    IE.Locale->Version = GetNumber( LocaleGadgets[ GD_LOC_Vers ]);

    return( FALSE );
}

BOOL LOC_AnnullaKeyPressed( void )
{
    return( LOC_AnnullaClicked() );
}

BOOL LOC_AnnullaClicked( void )
{
    IE.SrcFlags = ScrFlagsBack;

    return( FALSE );
}

BOOL LOC_CatNameClicked( void )
{
    ActivateGadget( LocaleGadgets[ GD_LOC_Join ], LocaleWnd, NULL );
    return( TRUE );
}

BOOL LOC_JoinClicked( void )
{
    ActivateGadget( LocaleGadgets[ GD_LOC_BuiltIn ], LocaleWnd, NULL );
    return( TRUE );
}

BOOL LOC_BuiltInClicked( void )
{
    ActivateGadget( LocaleGadgets[ GD_LOC_Vers ], LocaleWnd, NULL );
    return( TRUE );
}

BOOL LOC_VersClicked( void )
{
    return( TRUE );
}

BOOL LocaleVanillaKey( void )
{
    switch( IDCMPMsg.Code ) {
	case 13:
	    return( LOC_OkClicked() );

	case 27:
	    return( LOC_AnnullaClicked() );
    }

    return( TRUE );
}

BOOL LOC_GetJoinClicked( void )
{
    if( GetFile2( FALSE, CatCompArray[ ASL_GET_CATALOG ].cca_Str, "#?.cd",
		  ASL_GET_CATALOG, "cd" )) {

	StringTag[1] = allpath2;
	GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Join ], LocaleWnd,
			    NULL, (struct TagItem *)StringTag );
    }

    return( TRUE );
}

BOOL LOC_NewLangKeyPressed( void )
{
    return( LOC_NewLangClicked() );
}

BOOL LOC_DelLangKeyPressed( void )
{
    return( LOC_DelLangClicked() );
}

BOOL LOC_LangClicked( void )
{
    static ULONG  Secs = 0, Micros = 0;

    if( DoubleClick( Secs, Micros, IDCMPMsg.Seconds, IDCMPMsg.Micros )) {
	if( SelectedLang == IDCMPMsg.Code ) {
	    ULONG                   cnt;
	    struct LocaleLanguage  *lang;

	    lang = IE.Locale->Languages.mlh_Head;

	    for( cnt = 0; cnt < IDCMPMsg.Code; cnt++ )
		lang = lang->Node.ln_Succ;

	    EditLang( lang );
	}
    }

    SelectedLang = IDCMPMsg.Code;
    Secs         = IDCMPMsg.Seconds;
    Micros       = IDCMPMsg.Micros;

    List2Tag[1] = List2Tag[3] = (ULONG)IDCMPMsg.Code;
    GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Lang ], LocaleWnd,
			NULL, (struct TagItem *)List2Tag );

    return( TRUE );
}

BOOL LOC_NewLangClicked( void )
{
    struct LocaleLanguage  *lang;

    if( lang = AllocObject( IE_LOCALE_LANGUAGE )) {

	if( EditLang( lang )) {

	    DetacheLangList();
	    AddTail(( struct List * )&IE.Locale->Languages, ( struct Node * )lang );
	    AttachLangList();

	} else
	    FreeObject( lang, IE_LOCALE_LANGUAGE );

    } else
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

    return( TRUE );
}

BOOL LOC_DelLangClicked( void )
{
    if( SelectedLang != (UBYTE)-1 ) {
	struct LocaleLanguage  *lang;
	ULONG                   cnt;

	lang = IE.Locale->Languages.mlh_Head;

	for( cnt = 0; cnt < SelectedLang; cnt++ )
	    lang = lang->Node.ln_Succ;

	FreeLangStr( SelectedLang );

	DetacheLangList();
	Remove(( struct Node * )lang );
	FreeObject( lang, IE_LOCALE_LANGUAGE );
	AttachLangList();
    }

    return( TRUE );
}

BOOL LOC_DelStrClicked( void )
{
    if( SelectedString ) {

	if( StrInsert == SelectedString )
	    StrInsert = SelectedString->Node.ln_Pred;

	DetacheStrList();
	Remove(( struct Node * )SelectedString );
	FreeObject( SelectedString, IE_LOCALE_STRING );
	AttachStrList();
    }

    return( TRUE );
}

BOOL LOC_StringsClicked( void )
{
    static ULONG        Secs = 0, Micros = 0;
    ULONG               cnt;
    struct LocaleStr   *str;

    str = IE.Locale->ExtraStrings.mlh_Head;

    for( cnt = 0; cnt < IDCMPMsg.Code; cnt++ )
	str = str->Node.ln_Succ;

    if( DoubleClick( Secs, Micros, IDCMPMsg.Seconds, IDCMPMsg.Micros )) {
	if( SelectedString == str )
	    EditString( SelectedString );
    }

    SelectedString = str;
    Secs           = IDCMPMsg.Seconds;
    Micros         = IDCMPMsg.Micros;

    DisableTag[1] = ( str->Node.ln_Pri & LOC_GUI ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_DelStr ], LocaleWnd,
			NULL, ( struct TagItem * )DisableTag );

    return( TRUE );
}

BOOL LOC_NewStrClicked( void )
{
    struct LocaleStr   *string;

    if( string = AllocObject( IE_LOCALE_STRING )) {

	if( EditString( string )) {

	    DetacheStrList();
	    Insert(( struct List * )&IE.Locale->ExtraStrings, ( struct Node * )string, ( struct Node * )StrInsert );
	    StrInsert = string;
	    AttachStrList();

	} else
	    FreeObject( string, IE_LOCALE_STRING );

    } else
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

    return( TRUE );
}
///
/// List handling
void DetacheLangList( void )
{
    ListTag[1] = (ULONG)~0;
    GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Lang ], LocaleWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttachLangList( void )
{
    ListTag[1] = (ULONG)&IE.Locale->Languages;
    GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Lang ], LocaleWnd,
			NULL, (struct TagItem *)ListTag );

    List2Tag[3] = (ULONG)~0;
    GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Lang ], LocaleWnd,
			NULL, (struct TagItem *)&List2Tag[2] );

    SelectedLang = (UBYTE)-1;
}

void DetacheStrList( void )
{
    ListTag[1] = (ULONG)~0;
    GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Strings ], LocaleWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttachStrList( void )
{
    ListTag[1] = (ULONG)&IE.Locale->ExtraStrings;
    GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Strings ], LocaleWnd,
			NULL, (struct TagItem *)ListTag );

    List2Tag[3] = (ULONG)~0;
    GT_SetGadgetAttrsA( LocaleGadgets[ GD_LOC_Strings ], LocaleWnd,
			NULL, (struct TagItem *)&List2Tag[2] );

    SelectedString = NULL;
}
///

/// EditLang
BOOL EditLang( struct LocaleLanguage *Lang )
{
    APTR    lock;
    BOOL    ret = FALSE, w;

    LockAllWindows();
    lock = rtLockWindow( LocaleWnd );

    DetacheLangList();

    LayoutWindow( LanguageWTags );
    w = OpenLanguageWindow();
    PostOpenWindow( LanguageWTags );

    if( w )
	DisplayBeep( Scr );
    else {

	StringTag[1] = (ULONG)Lang->Language;
	GT_SetGadgetAttrsA( LanguageGadgets[ GD_LANG_Lang ], LanguageWnd,
			    NULL, ( struct TagItem * )StringTag );

	StringTag[1] = (ULONG)Lang->File;
	GT_SetGadgetAttrsA( LanguageGadgets[ GD_LANG_File ], LanguageWnd,
			    NULL, ( struct TagItem * )StringTag );

	do {
	    WaitPort( LanguageWnd->UserPort );
	} while( HandleLanguageIDCMP() );

	if( EL_RetCode ) {
	    strcpy( Lang->Language, GetString( LanguageGadgets[ GD_LANG_Lang ] ));
	    strcpy( Lang->File, GetString( LanguageGadgets[ GD_LANG_File ] ));

	    ret = TRUE;
	}
    }

    CloseLanguageWindow();

    AttachLangList();

    rtUnlockWindow( LocaleWnd, lock );
    UnlockAllWindows();

    return( ret );
}

BOOL LanguageVanillaKey( void )
{
    switch( LanguageMsg.Code ) {
	case 13:
	    return( LANG_OkClicked() );

	case 27:
	    return( LANG_CancelClicked() );
    }

    return( TRUE );
}

BOOL LANG_OkKeyPressed( void )
{
    return( LANG_OkClicked() );
}

BOOL LANG_CancelKeyPressed( void )
{
    return( LANG_CancelClicked() );
}

BOOL LANG_OkClicked( void )
{
    EL_RetCode = TRUE;

    IE.flags &= ~SALVATO;

    return( FALSE );
}

BOOL LANG_CancelClicked( void )
{
    EL_RetCode = FALSE;

    return( FALSE );
}

BOOL LANG_LangClicked( void )
{
    return( TRUE );
}

BOOL LANG_FileClicked( void )
{
    return( TRUE );
}

BOOL LANG_GetFileClicked( void )
{
    if( GetFile2( FALSE, CatCompArray[ ASL_SELECT_CT ].cca_Str, NULL,
		  ASL_SELECT_CT, NULL )) {

	StringTag[1] = allpath2;
	GT_SetGadgetAttrsA( LanguageGadgets[ GD_LANG_File ], LanguageWnd,
			    NULL, (struct TagItem *)StringTag );
    }

    return( TRUE );
}
///
/// EditString
BOOL EditString( struct LocaleStr *String )
{
    APTR    lock;
    BOOL    ret = FALSE, w;

    LockAllWindows();
    lock = rtLockWindow( LocaleWnd );

    DetacheStrList();

    LayoutWindow( NewStrWTags );
    w = OpenNewStrWindow();
    PostOpenWindow( NewStrWTags );

    if( w )
	DisplayBeep( Scr );
    else {

	EditingStr = String;

	StringTag[1] = String->Node.ln_Name;
	GT_SetGadgetAttrsA( NewStrGadgets[ GD_NS_Str ], NewStrWnd,
			    NULL, ( struct TagItem * )StringTag );

	if( String->Node.ln_Pri & LOC_GUI ) {

	    DisableTag[1] = TRUE;
	    GT_SetGadgetAttrsA( NewStrGadgets[ GD_NS_ID ], NewStrWnd,
				NULL, ( struct TagItem * )DisableTag );

	} else {

	    StringTag[1] = String->ID;
	    GT_SetGadgetAttrsA( NewStrGadgets[ GD_NS_ID ], NewStrWnd,
				NULL, ( struct TagItem * )StringTag );
	}

	AttachNSList();

	ActivateGadget( NewStrGadgets[ GD_NS_Str ], NewStrWnd, NULL );

	do {
	    WaitPort( NewStrWnd->UserPort );
	} while( HandleNewStrIDCMP() );

	if( EL_RetCode ) {

	    ret = TRUE;

	    if(!( String->Node.ln_Pri & LOC_GUI ))
		strcpy( String->String, GetString( NewStrGadgets[ GD_NS_Str ] ));

	    strcpy( String->ID, GetString( NewStrGadgets[ GD_NS_ID ] ));
	}
    }

    AttachStrList();

    CloseNewStrWindow();

    rtUnlockWindow( LocaleWnd, lock );
    UnlockAllWindows();

    return( ret );
}

void DetacheNSList( void )
{
    ListTag[1] = (ULONG)~0;
    GT_SetGadgetAttrsA( NewStrGadgets[ GD_NS_Tran ], NewStrWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttachNSList( void )
{
    ListTag[1] = (ULONG)&EditingStr->Translations;
    GT_SetGadgetAttrsA( NewStrGadgets[ GD_NS_Tran ], NewStrWnd,
			NULL, (struct TagItem *)ListTag );

    List2Tag[3] = (ULONG)~0;
    GT_SetGadgetAttrsA( NewStrGadgets[ GD_NS_Tran ], NewStrWnd,
			NULL, (struct TagItem *)&List2Tag[2] );

    SelectedTran = NULL;
}

BOOL NewStrVanillaKey( void )
{

    switch( NewStrMsg.Code ) {
	case 13:
	    return( NS_OkClicked() );

	case 27:
	    return( NS_CancelClicked() );
    }

    return( TRUE );
}

BOOL NS_OkKeyPressed( void )
{
    return( NS_OkClicked() );
}

BOOL NS_CancelKeyPressed( void )
{
    return( NS_CancelClicked() );
}

BOOL NS_NewKeyPressed( void )
{
    return( NS_NewClicked() );
}

BOOL NS_DelKeyPressed( void )
{
    return( NS_DelClicked() );
}

BOOL NS_StrClicked( void )
{
    return( TRUE );
}

BOOL NS_IDClicked( void )
{
    return( TRUE );
}

BOOL NS_OkClicked( void )
{
    EL_RetCode = TRUE;

    IE.flags &= ~SALVATO;

    return( FALSE );
}

BOOL NS_CancelClicked( void )
{
    EL_RetCode = FALSE;

    return( FALSE );
}

BOOL NS_NewClicked( void )
{
    struct LocaleTranslation   *tran;

    if( tran = AllocObject( IE_LOCALE_TRANSLATION )) {

	if( EditTranslation( tran )) {

	    DetacheNSList();
	    AddTail(( struct List * )&EditingStr->Translations, ( struct Node * )tran );
	    AttachNSList();

	} else
	    FreeObject( tran, IE_LOCALE_TRANSLATION );

    } else
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

    return( TRUE );
}

BOOL NS_DelClicked( void )
{
    if( SelectedTran ) {

	DetacheNSList();
	Remove(( struct Node * )SelectedTran );
	FreeObject( SelectedTran, IE_LOCALE_TRANSLATION );
	AttachNSList();
    }

    return( TRUE );
}

BOOL NS_TranClicked( void )
{
    static ULONG                Secs = 0, Micros = 0;
    ULONG                       cnt;
    struct LocaleTranslation   *tran;

    tran = EditingStr->Translations.mlh_Head;

    for( cnt = 0; cnt < NewStrMsg.Code; cnt++ )
	tran = tran->Node.ln_Succ;

    if( DoubleClick( Secs, Micros, NewStrMsg.Seconds, NewStrMsg.Micros )) {
	if( SelectedTran == tran ) {
	    DetacheNSList();
	    EditTranslation( SelectedTran );
	    AttachNSList();
	}
    }

    SelectedTran = tran;
    Secs         = NewStrMsg.Seconds;
    Micros       = NewStrMsg.Micros;

    List2Tag[1] = List2Tag[3] = (ULONG)NewStrMsg.Code;
    GT_SetGadgetAttrsA( NewStrGadgets[ GD_NS_Tran ], NewStrWnd,
			NULL, (struct TagItem *)List2Tag );

    return( TRUE );
}
///
/// EditTranslation
BOOL EditTranslation( struct LocaleTranslation *tran )
{
    APTR    lock;
    BOOL    ret = FALSE, w;

    lock = rtLockWindow( NewStrWnd );

    LayoutWindow( TranslationWTags );
    w = OpenTranslationWindow();
    PostOpenWindow( TranslationWTags );

    if( w )
	DisplayBeep( Scr );
    else {

	if( tran->String ) {
	    StringTag[1] = (ULONG)tran->String;
	    GT_SetGadgetAttrsA( TranslationGadgets[ GD_T_Str ], TranslationWnd,
				NULL, ( struct TagItem * )StringTag );
	}

	ListTag[1] = (ULONG)&IE.Locale->Languages;
	GT_SetGadgetAttrsA( TranslationGadgets[ GD_T_Lang ], TranslationWnd,
			    NULL, ( struct TagItem * )ListTag );

	List2Tag[1] = List2Tag[3] = tran->Node.ln_Type;
	GT_SetGadgetAttrsA( TranslationGadgets[ GD_T_Lang ], TranslationWnd,
			    NULL, ( struct TagItem * )List2Tag );

	ActivateGadget( TranslationGadgets[ GD_T_Str ], TranslationWnd, NULL );

	T_Language = tran->Node.ln_Type;

	do {
	    WaitPort( TranslationWnd->UserPort );
	} while( HandleTranslationIDCMP() );

	if( ET_RetCode ) {
	    STRPTR  str;

	    ret = TRUE;

	    FreeVec( tran->String );

	    str = GetString( TranslationGadgets[ GD_T_Str ]);

	    if( tran->String = AllocVec( strlen( str ) + 1, MEMF_ANY ))
		strcpy( tran->String, str );
	    else
		DisplayBeep( Scr );

	    tran->Node.ln_Name = tran->String;
	    tran->Node.ln_Type = T_Language;
	}
    }

    CloseTranslationWindow();

    rtUnlockWindow( NewStrWnd, lock );

    return( ret );
}

BOOL TranslationVanillaKey( void )
{
    switch( TranslationMsg.Code ) {
	case 13:
	    return( T_OkClicked() );

	case 27:
	    return( T_CancelClicked() );
    }

    return( TRUE );
}

BOOL T_OkKeyPressed( void )
{
    return( T_OkClicked() );
}

BOOL T_CancelKeyPressed( void )
{
    return( T_CancelClicked() );
}

BOOL T_StrClicked( void )
{
    return( TRUE );
}

BOOL T_OkClicked( void )
{
    ET_RetCode = TRUE;

    IE.flags &= ~SALVATO;

    return( FALSE );
}

BOOL T_CancelClicked( void )
{
    ET_RetCode = FALSE;

    return( FALSE );
}

BOOL T_LangClicked( void )
{
    T_Language = TranslationMsg.Code;

    return( TRUE );
}
///

/// ImpStrClicked
BOOL LOC_ImpStrClicked( void )
{
    APTR    lock;

    LockAllWindows();
    lock = rtLockWindow( LocaleWnd );

    DetacheStrList();

    if( GetFile2( FALSE, CatCompArray[ ASL_IMPORT_STRINGS ].cca_Str, "#?.cd",
		  ASL_IMPORT_STRINGS, "cd" )) {

	ImportStrings( allpath2, FALSE );
    }

    AttachStrList();

    rtUnlockWindow( LocaleWnd, lock );
    UnlockAllWindows();

    return( TRUE );
}
///
/// ImportStrings
void ImportStrings( STRPTR FileName, BOOL Free )
{
    BPTR    file;

    if( file = Open( FileName, MODE_OLDFILE )) {
	LONG    size;
	UBYTE  *buffer;

	Seek( file, 0, OFFSET_END );
	size = Seek( file, 0, OFFSET_BEGINNING );

	if( buffer = AllocMem( size, MEMF_CLEAR )) {
	    TEXT    str[512];
	    UBYTE  *strings, *end;

	    Read( file, buffer, size );

	    strings  = buffer;
	    end      = buffer + size;

	    while( GetLine( str, &strings, end )) {
		TEXT    str2[512];
		STRPTR  par;

		if( par = strchr( str, '(' ))
		    *par = '\0';

		if( GetLine( str2, &strings, end )) {
		    struct LocaleStr   *s;

		    if( s = AllocObject( IE_LOCALE_STRING )) {

			Insert(( struct List * )&IE.Locale->ExtraStrings, ( struct Node * )s, ( struct Node * )StrInsert );

			StrInsert = s;

			strcpy( s->ID,     str  );
			strcpy( s->String, str2 );

			if( Free )
			    s->Node.ln_Pri |= LOC_FREE;

		    } else {
			Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
			break;
		    }

		} else
		    break;
	    }

	    FreeMem( buffer, size );

	} else
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

	Close( file );

    } else
	Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
}
///
/// GetLine
BOOL GetLine( STRPTR string, UBYTE **buffer, UBYTE *end )
{
    BOOL    ret = FALSE, first = TRUE, ok = TRUE;
    UBYTE  *ptr;

    ptr = *buffer;

    while(( ptr < end ) && ( ok )) {
	UBYTE   c;

	switch( c = *ptr++ ) {

	    case ';':
		if( first ) {
		    /*  skip to EOL */
		    while( ptr < end ) {
			if( *ptr++ == '\n' )
			    break;
		    }
		} else {
		    *string++ = ';';
		}
		break;

	    case '\\':
		if( ptr < end ) {
		    UBYTE   b;

		    b = *ptr++;

		    if( b != '\n' ) {
			*string++ = '\\';
			*string++ = b;
		    }
		}
		break;

	    case '\n':
		if(!( first ))
		    ok = FALSE;
		break;

	    default:
		*string++ = c;
		ret       = TRUE;
		first     = FALSE;
		break;
	}
    }

    *string = '\0';
    *buffer = ptr;

    return( ret );
}
///

/// Import from Catalog
BOOL LOC_CatMenued( void )
{
    APTR    lock;

    LockAllWindows();
    lock = rtLockWindow( LocaleWnd );

    DetacheStrList();

    if( GetFile2( FALSE, CatCompArray[ ASL_IMPORT_STRINGS ].cca_Str, "#?.catalog",
		  ASL_IMPORT_STRINGS, "catalog" )) {
	struct IFFHandle   *iff;

	if( iff = AllocIFF() ) {

	    if( iff->iff_Stream = Open( allpath2, MODE_OLDFILE )) {

		InitIFFasDOS( iff );

		if(!( OpenIFF( iff, IFFF_READ ))) {
		    ULONG   ret;

		    PropChunk( iff, MAKE_ID( 'C', 'T', 'L', 'G' ), MAKE_ID( 'L', 'A', 'N', 'G' ));
		    StopChunk( iff, MAKE_ID( 'C', 'T', 'L', 'G' ), MAKE_ID( 'S', 'T', 'R', 'S' ));

		    ret = ParseIFF( iff, IFFPARSE_SCAN );

		    if(( ret == 0 ) || ( ret == IFFERR_EOF )) {
			struct StoredProperty  *lang;

			if( lang = FindProp( iff, MAKE_ID( 'C', 'T', 'L', 'G' ), MAKE_ID( 'L', 'A', 'N', 'G' ))) {
			    struct ContextNode *strs;

			    strs = CurrentChunk( iff );

			    if( strs->cn_ID == MAKE_ID( 'S', 'T', 'R', 'S' )) {
				LONG            size;
				UBYTE          *ptr, *ptr2;
				struct MinList  list;
				TEXT            language[ 80 ];

				strncpy( language, lang->sp_Data, lang->sp_Size );

				NewList( &list );

				size = strs->cn_Size;

				if( ptr = ptr2 = AllocVec( size, MEMF_ANY )) {

				    ReadChunkBytes( iff, ptr, size );

				    do {
					ULONG                       len = 0;
					TEXT                        buffer[1024];
					UBYTE                      *dest;
					struct LocaleTranslation   *tran;

					ptr  += 8;   // skip ID + len
					size -= 8;

					dest = buffer;

					while( *ptr && ( size > 0 )) {

					    *dest = *ptr++;

					    if( *dest == '\n' ) {
						*dest++ = '\\';
						*dest   = 'n';
					    }

					    ++dest;
					    --size;
					}

					*dest = '\0';

					++ptr;
					--size;

					if( tran = AllocObject( IE_LOCALE_TRANSLATION )) {

					    AddTail(( struct List * )&list, ( struct Node * )tran );

					    if( tran->String = AllocVec( strlen( buffer ) + 1, MEMF_ANY ))
						strcpy( tran->String, buffer );
					    else
						DisplayBeep( Scr );

					    tran->Node.ln_Name = tran->String;

					} else
					    DisplayBeep( Scr );

					(ULONG)dest  = ((ULONG)ptr + 3 ) & ~3;
					size -= dest - ptr;
					ptr   = dest;

				    } while( size > 0 );

				    Import( language, &list );

				    FreeVec( ptr2 );

				} else
				    DisplayBeep( Scr );
			    }

			} else
			    DisplayBeep( Scr );

		    } else
			DisplayBeep( Scr );

		    CloseIFF( iff );

		} else
		    DisplayBeep( Scr );

		Close( iff->iff_Stream );

	    } else
		DisplayBeep( Scr );

	    FreeIFF( iff );

	} else
	    DisplayBeep( Scr );
    }

    AttachStrList();

    rtUnlockWindow( LocaleWnd, lock );
    UnlockAllWindows();

    return( TRUE );
}
///
/// Import from .ct         N/A
BOOL LOC_CtMenued( void )
{
    return( TRUE );
}
///
/// Import
void Import( STRPTR Language, struct MinList *From )
{
    struct LocaleTranslation   *tran;
    struct LocaleLanguage      *lang;
    BOOL                        w;
    ULONG                       n;

    w = FALSE;

    for( n = 0, lang = (struct LocaleLanguage *)IE.Locale->Languages.mlh_Head; lang->Node.ln_Succ; lang = (struct LocaleLanguage *)lang->Node.ln_Succ, n++ ) {
	if( strcmp( Language, lang->Language ) == 0 ) {
	    w = TRUE;
	    break;
	}
    }

    if(!( w )) {

	lang = AllocObject( IE_LOCALE_LANGUAGE );

	strcpy( lang->Language, Language );

	AddTail(( struct List * )&IE.Locale->Languages, ( struct Node * )lang );

	n++;
    }

    for( tran = (struct LocaleTranslation *)From->mlh_Head; tran->Node.ln_Succ; tran = (struct LocaleTranslation *)tran->Node.ln_Succ )
	tran->Node.ln_Type = n;

    LayoutWindow( ImportWTags );
    w = OpenImportWindow();
    PostOpenWindow( ImportWTags );

    if( w )
	DisplayBeep( Scr );
    else {

	ImportList   = From;
	SelectedTran = NULL;
	EditingStr   = NULL;

	AttachImpLists();

	do {
	    WaitPort( ImportWnd->UserPort );
	} while( HandleImportIDCMP() );
    }

    CloseImportWindow();

    while( tran = RemTail(( struct List * )From ))
	FreeObject( tran, IE_LOCALE_TRANSLATION );
}

void DetacheImpLists( void )
{
    ListTag[1] = (ULONG)~0;

    GT_SetGadgetAttrsA( ImportGadgets[ GD_IMP_From ], ImportWnd,
			NULL, (struct TagItem *)ListTag );

    GT_SetGadgetAttrsA( ImportGadgets[ GD_IMP_To ], ImportWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttachImpLists( void )
{
    ListTag[1] = (ULONG)&IE.Locale->ExtraStrings;
    GT_SetGadgetAttrsA( ImportGadgets[ GD_IMP_To ], ImportWnd,
			NULL, (struct TagItem *)ListTag );

    List2Tag[3] = (ULONG)~0;
    GT_SetGadgetAttrsA( ImportGadgets[ GD_IMP_To ], ImportWnd,
			NULL, (struct TagItem *)&List2Tag[2] );

    ListTag[1] = (ULONG)ImportList;
    GT_SetGadgetAttrsA( ImportGadgets[ GD_IMP_From ], ImportWnd,
			NULL, (struct TagItem *)ListTag );

    List2Tag[3] = (ULONG)~0;
    GT_SetGadgetAttrsA( ImportGadgets[ GD_IMP_From ], ImportWnd,
			NULL, (struct TagItem *)&List2Tag[2] );

    EditingStr   = NULL;
    SelectedTran = NULL;
}

BOOL ImportCloseWindow( void )
{
    return( FALSE );
}

BOOL ImportVanillaKey( void )
{
    if( ImportMsg.Code == 27 )
	return( FALSE );
    else
	return( TRUE );
}

BOOL IMP_FromClicked( void )
{
    struct LocaleTranslation   *tran;
    ULONG                       i;

    tran = (struct LocaleTranslation *)ImportList->mlh_Head;

    for( i = 0; i < ImportMsg.Code; i++ )
	tran = (struct LocaleTranslation *)tran->Node.ln_Succ;

    SelectedTran = tran;

    return( TRUE );
}

BOOL IMP_ToClicked( void )
{
    struct LocaleStr   *str;
    ULONG               i;

    str = (struct LocaleTranslation *)IE.Locale->ExtraStrings.mlh_Head;

    for( i = 0; i < ImportMsg.Code; i++ )
	str = (struct LocaleStr *)str->Node.ln_Succ;

    EditingStr = str;

    return( TRUE );
}

BOOL IMP_LinkClicked( void )
{
    if( SelectedTran && EditingStr ) {

	DetacheImpLists();

	Remove(( struct Node * )SelectedTran );

	SelectedTran->Original = EditingStr->String;

	AddTail(( struct List * )&EditingStr->Translations, ( struct Node * )SelectedTran );

	AttachImpLists();
    }

    return( TRUE );
}
///

/// GetStrings
BOOL GetStrings( void )
{
    struct WindowInfo  *wnd;
    BOOL                loc;

    if( StrList )
	return( TRUE );

    StrList = TRUE;

    if(( IE.ScreenData->Title[0] ) && ( IE.flags_2 & GENERASCR ))
	if(!( AddString( IE.ScreenData->Title )))
	    return( FALSE );

    loc = ( IE.SrcFlags & LOCALIZE ) ? TRUE : FALSE;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	LONG                add;
	struct ITextNode   *txt;

	add = loc ? ( wnd->wi_Tags & W_LOC_TITLE ) : TRUE;

	if(( wnd->wi_Titolo[0] ) && ( add ))
	    if(!( AddString( wnd->wi_Titolo )))
		return( FALSE );

	if( loc )
	    add = wnd->wi_Tags & W_LOC_SCRTITLE;
	else
	    add = TRUE;

	if(( wnd->wi_TitoloSchermo[0] ) && ( add ))
	    if(!( AddString( wnd->wi_TitoloSchermo )))
		return( FALSE );



	if( loc )
	    add = wnd->wi_Tags & W_LOC_GADGETS;
	else
	    add = TRUE;

	if( add ) {
	    struct GadgetBank  *bank;

	    ProcessGadgets( &wnd->wi_Gadgets );

	    for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ )
		ProcessGadgets( &bank->Storage );
	}


	if( loc )
	    add = wnd->wi_Tags & W_LOC_TEXTS;
	else
	    add = TRUE;

	if( add )
	    for( txt = wnd->wi_ITexts.mlh_Head; txt->itn_Node.ln_Succ; txt = txt->itn_Node.ln_Succ )
		if( txt->itn_Text[0] )
		    if(!( AddString( txt->itn_Text )))
			return( FALSE );

	if( loc )
	    add = wnd->wi_Tags & W_LOC_MENUS;
	else
	    add = TRUE;

	if( add ) {
	    struct MenuTitle   *menu;
	    for( menu = wnd->wi_Menus.mlh_Head; menu->mt_Node.ln_Succ; menu = menu->mt_Node.ln_Succ ) {
		struct _MenuItem *item;

		if( menu->mt_Text[0] )
		    if(!( AddString( menu->mt_Text )))
			return( FALSE );

		for( item = menu->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {
		    struct MenuSub *sub;

		    if(( item->min_Text[0] ) && (!( item->min_Flags & M_BARLABEL )))
			if(!( AddString( item->min_Text )))
			    return( FALSE );

		    if( item->min_CommKey[0] )
			if(!( AddString( item->min_CommKey )))
			    return( FALSE );

		    for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ ) {

			if(( sub->msn_Text[0] ) && (!( sub->msn_Flags & M_BARLABEL )))
			    if(!( AddString( sub->msn_Text )))
				return( FALSE );

			if( sub->msn_CommKey[0] )
			    if(!( AddString( sub->msn_CommKey )))
				return( FALSE );
		    }
		}
	    }
	}

    }

    FreeUnusedTranslations();

    return( TRUE );
}
///
/// FreeUnusedTranslations
void FreeUnusedTranslations( void )
{
    struct LocaleTranslation   *tran;

    while( tran = (struct LocaleTranslation * ) RemTail(( struct List * )&IE.Locale->Translations ))
	FreeObject( tran, IE_LOCALE_TRANSLATION );
}
///
/// PutStrings
void PutStrings( void )
{
    struct LocaleStr   *str;
    struct ArrayNode   *array;

    StrList = FALSE;

    for( str = IE.Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ ) {

	if( str->Node.ln_Pri & LOC_GUI ) {
	    struct LocaleStr           *pred;
	    struct LocaleTranslation   *tran;

	    pred = str->Node.ln_Pred;

	    Remove(( struct Node * )str );

	    while( tran = (struct LocaleTranslation *) RemHead(( struct List * )&str->Translations )) {

		tran->Original = str->Node.ln_Name;

		AddTail(( struct List * )&IE.Locale->Translations, ( struct Node * )tran );
	    }

	    FreeObject( str, IE_LOCALE_STRING );

	    str = pred;
	}
    }

    while( array = (struct ArrayNode *) RemTail(( struct List * )&IE.Locale->Arrays ))
	FreeObject( array, IE_ARRAY_NODE );
}
///

/// FreeLangStr
void FreeLangStr( UBYTE Lang )
{
    struct LocaleStr   *str;

    for( str = IE.Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ ) {

	if( str->Node.ln_Type == Lang ) {
	    struct LocaleStr   *pred;

	    pred = str->Node.ln_Pred;

	    Remove(( struct Node * )str );
	    FreeObject( str, IE_LOCALE_STRING );

	    str = pred;

	} else if( str->Node.ln_Type > Lang )
	    str->Node.ln_Type -= 1;
    }
}
///
/// FreeLocaleData
void FreeLocaleData( void )
{
    struct LocaleStr           *str;
    struct LocaleLanguage      *lang;
    struct LocaleTranslation   *tran;
    struct ArrayNode           *array;

    while( str = (struct LocaleStr *) RemTail(( struct List * )&IE.Locale->ExtraStrings ))
	FreeObject( str, IE_LOCALE_STRING );

    while( lang = (struct LocaleLanguage *) RemTail(( struct List * )&IE.Locale->Languages ))
	FreeObject( lang, IE_LOCALE_LANGUAGE );

    while( tran = (struct LocaleTranslation *) RemTail(( struct List * )&IE.Locale->Translations ))
	FreeObject( tran, IE_LOCALE_TRANSLATION );

    while( array = (struct ArrayNode *) RemTail(( struct List * )&IE.Locale->Arrays ))
	FreeObject( array, IE_ARRAY_NODE );
}
///

/// CountArray
UWORD CountArray( UBYTE **Array )
{
    UWORD   cnt = 0;

    while( *Array++ )
	cnt += 1;

    return( cnt );
}
///
/// CmpArrays
BOOL CmpArrays( UBYTE **First, struct MinList *Second )
{
    UWORD                   num, cnt;
    struct GadgetScelta    *gs;

    num = CountArray( First );

    gs = Second->mlh_Head;
    cnt = 0;
    while( gs->gs_Node.ln_Succ ) {
	cnt += 1;
	gs = gs->gs_Node.ln_Succ;
    }

    if( num != cnt )
	return( FALSE );

    gs = Second->mlh_Head;

    for( cnt = 0; cnt < num; cnt++ ) {
	if( strcmp( *First++, gs->gs_Testo ))
	    return( FALSE );
	gs = gs->gs_Node.ln_Succ;
    }

    return( TRUE );
}
///
/// FindString
struct LocaleStr *FindString( __A0 struct MinList *List, __A1 STRPTR String )
{
    struct LocaleStr   *str;

    for( str = List->mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ )
	if( strcmp( str->Node.ln_Name, String ) == 0 )
	    return( str );

    return( NULL );
}
///
/// FindArray
struct ArrayNode *FindArray( __A0 struct MinList *List, __A1 struct MinList *Array )
{
    struct ArrayNode   *ar;

    for( ar = List->mlh_Head; ar->Next; ar = ar->Next )
	if( CmpArrays( ar->Array, Array ))
	    return( ar );

    return( NULL );
}
///
/// AddString
BOOL AddString( UBYTE *String )
{
    struct LocaleStr   *str;

    if(!( FindString( &IE.Locale->ExtraStrings, String ))) {
	struct LocaleTranslation   *tran;

	if(!( str = AllocObject( IE_LOCALE_STRING )))
	    return( FALSE );

	AddTail(( struct List * )&IE.Locale->ExtraStrings, ( struct Node * )str );

	str->Node.ln_Pri  = LOC_GUI;
	str->Node.ln_Name = String;

	while( tran = GetTranslation( String ))
	    AddTail(( struct List * )&str->Translations, ( struct Node * )tran );
    }

    return( TRUE );
}
///
/// AddArray
BOOL AddArray( struct MinList *Items )
{
    struct ArrayNode       *ar;
    struct GadgetScelta    *gs;
    UBYTE                 **Array;
    UBYTE                   size = 4;

    if(!( FindArray( &IE.Locale->Arrays, Items ))) {
	if(!( ar = AllocObject( IE_ARRAY_NODE )))
	    return( FALSE );

	AddTail(( struct List * )&IE.Locale->Arrays, ( struct Node * )ar );

	gs = Items->mlh_Head;
	while( gs = gs->gs_Node.ln_Succ )
	    size += 4;

	if(!( Array = AllocVec( size, 0L )))
	    return( FALSE );

	ar->Array = Array;

	for( gs = Items->mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ ) {

	    *Array++ = gs->gs_Testo;

	    if(!( AddString( gs->gs_Testo ))) {
		FreeVec( ar->Array );
		ar->Array = NULL;
		return( FALSE );
	    }
	}

	*Array = NULL;
    }

    return( TRUE );
}
///
/// ProcessGadgets
BOOL ProcessGadgets( struct MinList *Gadgets )
{
    struct GadgetInfo  *gad;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

	if(( gad->g_Kind < MIN_IEX_ID ) && ( gad->g_Titolo[0] ))
	    if(!( AddString( gad->g_Titolo )))
		return( FALSE );

	switch( gad->g_Kind ) {

	    case MX_KIND:
	    case CYCLE_KIND:
		if(!( AddArray( &gad->g_Scelte )))
		    return( FALSE );
		break;

	    case LISTVIEW_KIND:
		{
		    struct GadgetScelta *gs;
		    for( gs = gad->g_Scelte.mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ )
			if(!( AddString( gs->gs_Testo )))
			    return( FALSE );
		}
		break;

	    case TEXT_KIND:
	    case STRING_KIND:
		if( *((UBYTE *)(gad->g_ExtraMem)) )
		    if(!( AddString( gad->g_ExtraMem )))
			return( FALSE );
		break;

	    case NUMBER_KIND:
		if(( ((struct NK)(gad->g_Data)).Format[0] ) && ( strcmp( ((struct NK)(gad->g_Data)).Format, "%ld" )))
		    if(!( AddString( ((struct NK)(gad->g_Data)).Format )))
			return( FALSE );
		break;

	    case SLIDER_KIND:
		if( ((struct SlK)(gad->g_Data)).Format[0] )
		    if(!( AddString( ((struct SlK)(gad->g_Data)).Format )))
			return( FALSE );
		break;
	}
    }
}
///
/// GetTranslation
struct LocaleTranslation *GetTranslation( STRPTR String )
{
    struct LocaleTranslation   *tran;

    for( tran = IE.Locale->Translations.mlh_Head; tran->Node.ln_Succ; tran = tran->Node.ln_Succ )
	if( strcmp( String, tran->Original ) == 0 ) {
	    Remove(( struct Node * )tran );
	    return( tran );
	}

    return( NULL );
}
///

/// WriteCatalogs
void WriteCatalogs( STRPTR BaseName )
{
    if( IE.SrcFlags & LOCALIZE ) {
	struct LocaleStr   *str;
	ULONG               cnt;
	TEXT                Directory[256];

	strcpy( Directory, BaseName );

	*( FilePart( Directory )) = '\0';

	for( cnt = 0, str = IE.Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ )
	    if( str->Node.ln_Pri & LOC_GUI ) {
		sprintf( str->ID, "MSG_STRING_%ld", cnt++ );
	    }

	if( IE.Locale->JoinFile[0] ) {
	    str = StrInsert;
	    ImportStrings( IE.Locale->JoinFile, TRUE );
	    StrInsert = str;
	}


	if( WriteCD( Directory )) {
	    ULONG   num;

	    WriteCT( Directory, (UBYTE)-1 );

	    num = CountNodes( &IE.Locale->Languages );

	    for( cnt = 0; cnt < num; cnt++ )
		WriteCT( Directory, cnt );
	}


	for( str = IE.Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ )
	    if( str->Node.ln_Pri & LOC_FREE ) {
		struct LocaleStr   *pred;

		pred = str->Node.ln_Pred;

		Remove(( struct Node * )str );

		FreeObject( str, IE_LOCALE_STRING );

		str = pred;
	    }
    }
}
///
/// WriteCD
BOOL WriteCD( STRPTR Directory )
{
    TEXT    name[256];
    BOOL    ret;

    strcpy( name, Directory );
    strcat( name, IE.Locale->Catalog );
    strcat( name, ".cd" );

    if( ret = AskFile( name )) {
	BPTR    file;

	if( file = Open( name, MODE_NEWFILE )) {
	    struct LocaleStr   *str;

	    FPuts( file, ";\n"
			 ";  CD File created by InterfaceEditor ©1994-1996 Simone Tellini\n"
			 ";\n" );

	    for( str = IE.Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ )
		FPrintf( file, "%s (//)\n%s\n;\n", str->ID, str->Node.ln_Name );

	    Close( file );

	} else
	    Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
    }

    return( ret );
}
///
/// WriteCT
void WriteCT( STRPTR Path, UBYTE LangIndex )
{
    BPTR                    file;
    TEXT                    name[256];
    struct LocaleLanguage  *Lang = NULL;

    if( LangIndex != (UBYTE)-1 ) {
	ULONG   cnt;

	Lang = IE.Locale->Languages.mlh_Head;

	for( cnt = 0; cnt < LangIndex; cnt++ )
	    Lang = Lang->Node.ln_Succ;
    }

    strcpy( name, Path );

    if( Lang )
	AddPart( name, Lang->File, 256 );
    else
	AddPart( name, IE.Locale->Catalog, 256 );

    strcat( name, ".ct" );

    if( file = Open( name, MODE_NEWFILE )) {
	struct LocaleStr   *str;
	struct DateTime     dt;
	TEXT                date[ LEN_DATSTRING ];
	UWORD               day, month, year;

	DateStamp( &dt.dat_Stamp );

	dt.dat_Format  = FORMAT_CDN;
	dt.dat_Flags   = 0;
	dt.dat_StrDate = date;
	dt.dat_StrTime = NULL;
	dt.dat_StrDay  = NULL;

	DateToStr( &dt );

	sscanf( date, "%hd-%hd-%hd", &day, &month, &year );

	FPuts( file, "## version $" );

	/*  I had to split the line because otherwise the c:Version
	    command would get confused and the Installer script didn't
	    work correctly.
	*/

	FPrintf( file, "VER: %s.catalog %ld.0 (%ld.%ld.%ld)\n"
		       "## codeset 0\n"
		       "## language %s\n"
		       ";\n",
		 IE.Locale->Catalog,
		 IE.Locale->Version,
		 day, month, year,
		 Lang ? (APTR)Lang->Language : "X" );

	for( str = IE.Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ ) {
	    STRPTR  tran = "";
	    ULONG   max;

	    max = CountNodes( &IE.Locale->Languages ) - 1;

	    if( LangIndex != (UBYTE)-1 ) {
		struct LocaleTranslation   *t;

		for( t = str->Translations.mlh_Head; t->Node.ln_Succ; t = t->Node.ln_Succ ) {

		    if( t->Node.ln_Type > max )
			t->Node.ln_Type = max;

		    if( t->Node.ln_Type == LangIndex ) {
			tran = t->String;
			break;
		    }
		}
	    }

	    FPrintf( file, "%s\n%s\n; %s\n;\n", str->ID, tran, str->Node.ln_Name );
	}

	Close( file );
    }
}
///
