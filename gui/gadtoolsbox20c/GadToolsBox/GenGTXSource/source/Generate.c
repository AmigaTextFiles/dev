/*
**      $Filename: Generate.c $
**      $Release: 1.0 $
**      $Revision: 38.1 $
**
**      The source generator.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard
**/

#include "GenGTXSource.h"

Prototype VOID Generate( void );

/*
 *      Some localy used data.
 */
BYTE    Done[ NUM_KINDS ];

/*
 *      Set the source name extension.
 */
Local VOID SetSuffix( UBYTE *buffer, UBYTE *suffix )
{
    UBYTE       *ptr;

    if ( ptr = strrchr( buffer, '.' ))
        *ptr = 0;

    strcat( buffer, suffix );
}

/*
 *      Open a file.
 */
Local BPTR OpenFile( UBYTE *suffix )
{
    UBYTE       NameBuffer[ 512 ];
    BPTR        file;

    strcpy( &NameBuffer[ 0 ], Arguments.SourceName );
    SetSuffix( &NameBuffer[ 0 ], suffix );

    return( Open( &NameBuffer[ 0 ], MODE_NEWFILE ));
}

/*
 *      Open the files for the source generation.
 */
Local BOOL OpenFiles( void )
{
    if ( ! ( MainSource = OpenFile( ".c" )))
        return( FALSE );

    if ( ! ( Header = OpenFile( ".h" )))
        return( FALSE );

    if ( ! ( Protos = OpenFile( "_protos.h" )))
        return( FALSE );

    if ( ! ( Locale = OpenFile( ".cd" )))
        return( FALSE );
}

/*
 *      Close the source files.
 */
Local VOID CloseFiles( void )
{
    if ( Locale )           Close( Locale );
    if ( Protos )           Close( Protos );
    if ( Header )           Close( Header );
    if ( MainSource )       Close( MainSource );
}

/*
 *      Write the #ifndef, #define conditionals for the headers.
 */
Local VOID DoConditionals( void )
{
    UBYTE           Name[ 50 ], *ptr, i = 0;

    if ( ptr = PathPart( Arguments.SourceName )) {
        if ( *ptr == '/' )
            ptr++;

        strcpy( &Name[ 0 ], ptr );

        while( Name[ i ] && Name[ i ] != '.' )
            Name[ i ] = toupper( Name[ i++ ] );

        Name[ i ] = 0;

        MyFPrintf( Locale,     "#header %s_LOCALE\n", &Name[ 0 ] );
        MyFPrintf( MainSource, "#include \"%s.H\"\n\n", &Name[ 0 ] );
        MyFPrintf( Header,     "#ifndef %s_H\n#define %s_H\n\n", &Name[ 0 ], &Name[ 0 ], &Name[ 0 ] );
        MyFPrintf( Protos,     "#ifndef %s_PROTOS_H\n#define %s_PROTOS_H\n\n", &Name[ 0 ], &Name[ 0 ] );

        FPuts( Header, Includes );

        if ( SET( SourceConfig.gc_GenCFlags0, CS0_PRAGMAS )) {
            if ( SET( SourceConfig.gc_GenCFlags0, CS0_AZTEC ))
                FPuts( Header, AztecPragmas );
            else
                FPuts( Header, Pragmas );
        }

        MyFPrintf( Header,     "#include \"%s_PROTOS.H\"\n\n", &Name[ 0 ] );
        FPuts( Header,         "#define GetString(g) ((( struct StringInfo * )g->SpecialInfo )->Buffer )\n" );
        FPuts( Header,         "#define GetNumber(g) ((( struct StringInfo * )g->SpecialInfo )->LongInt )\n\n" );
        FPuts( Header,         "#ifndef GTMN_NewLookMenus\n#define GTMN_NewLookMenus GT_TagBase+67\n#endif\n\n" );
        FPuts( Header,         "#ifndef WA_NewLookMenus\n#define WA_NewLookMenus WA_Dummy+0x30\n#endif\n\n" );
        FPuts( Header,         "#ifndef GTCB_Scaled\n#define GTCB_Scaled GT_TagBase+68\n#endif\n\n" );
        FPuts( Header,         "#ifndef GTMX_Scaled\n#define GTMX_Scaled GT_TagBase+69\n#endif\n\n" );
        FPuts( Header,         "struct AppString {\n\tLONG\tas_ID;\n\tSTRPTR\tas_Str;\n};\n\n" );
        FPuts( Header,         "extern struct AppString AppStrings[];\n\n" );
        FPuts( Header,         "extern struct Library *LocaleBase;\n\n" );
        FPuts( MainSource,     "#define STRINGARRAY\n\n" );
        MyFPrintf( MainSource, "#include \"%s_LOCALE.H\"\n\n", &Name[ 0 ] );

    }
}

/*
 *      Write the GadTools placement flags.
 */
Local VOID WritePlacementFlags( ULONG flags )
{
    if ( ! flags ) FPuts( MainSource, "0" );
    else {
        if ( SET( flags, PLACETEXT_LEFT ))       FPuts( MainSource, "PLACETEXT_LEFT|" );
        else if ( SET( flags, PLACETEXT_RIGHT )) FPuts( MainSource, "PLACETEXT_RIGHT|" );
        else if ( SET( flags, PLACETEXT_ABOVE )) FPuts( MainSource, "PLACETEXT_ABOVE|" );
        else if ( SET( flags, PLACETEXT_BELOW )) FPuts( MainSource, "PLACETEXT_BELOW|" );
        else                                     FPuts( MainSource, "PLACETEXT_IN|" );

        if ( SET( flags, NG_HIGHLABEL ))         FPuts( MainSource, "NG_HIGHLABEL!" );

        Seek( MainSource, -1, OFFSET_CURRENT );
    }
}

/*
 *      Write the DrawMode flags.
 */
Local VOID WriteDrMd( ULONG drmd )
{
    if ( SET( drmd, JAM2 ))         FPuts( MainSource, "JAM2|" );
    else                            FPuts( MainSource, "JAM1|" );

    if ( SET( drmd, COMPLEMENT ))   FPuts( MainSource, "COMPLEMENT|" );
    if ( SET( drmd, INVERSVID ))    FPuts( MainSource, "INVERSVID|" );

    Seek( MainSource, -1, OFFSET_CURRENT );
}

/*
 *      Write the window flags.
 */
Local VOID WriteWindowFlags( ULONG flags )
{
    if ( SET( flags, WFLG_SIZEGADGET ))     FPuts( MainSource, "WFLG_SIZEGADGET|" );
    if ( SET( flags, WFLG_DRAGBAR ))        FPuts( MainSource, "WFLG_DRAGBAR|" );
    if ( SET( flags, WFLG_DEPTHGADGET ))    FPuts( MainSource, "WFLG_DEPTHGADGET|" );
    if ( SET( flags, WFLG_CLOSEGADGET ))    FPuts( MainSource, "WFLG_CLOSEGADGET|" );
    if ( SET( flags, WFLG_SIZEBRIGHT ))     FPuts( MainSource, "WFLG_SIZEBRIGHT|" );
    if ( SET( flags, WFLG_SIZEBBOTTOM ))    FPuts( MainSource, "WFLG_SIZEBBOTTOM|" );
    if ( SET( flags, WFLG_SMART_REFRESH ))  FPuts( MainSource, "WFLG_SMART_REFRESH|" );
    if ( SET( flags, WFLG_SIMPLE_REFRESH )) FPuts( MainSource, "WFLG_SIMPLE_REFRESH|" );
    if ( SET( flags, WFLG_SUPER_BITMAP ))   FPuts( MainSource, "WFLG_SUPERBITMAP|" );
    if ( SET( flags, WFLG_OTHER_REFRESH ))  FPuts( MainSource, "WFLG_OTHER_REFRESH|" );
    if ( SET( flags, WFLG_BACKDROP ))       FPuts( MainSource, "WFLG_BACKDROP|" );
    if ( SET( flags, WFLG_REPORTMOUSE ))    FPuts( MainSource, "WFLG_REPORTMOUSE|" );
    if ( SET( flags, WFLG_GIMMEZEROZERO ))  FPuts( MainSource, "WFLG_GIMMEZEROZERO|" );
    if ( SET( flags, WFLG_BORDERLESS ))     FPuts( MainSource, "WFLG_BORDERLESS|" );
    if ( SET( flags, WFLG_ACTIVATE ))       FPuts( MainSource, "WFLG_ACTIVATE|" );
    if ( SET( flags, WFLG_RMBTRAP ))        FPuts( MainSource, "WFLG_RMBTRAP|" );

    Seek( MainSource, -1, OFFSET_CURRENT );
};

/*
 *      Write the GadTools specific IDCMP flags.
 */
Local VOID WriteGadToolsIDCMP( struct ExtGadgetList *gadgets )
{
    struct ExtNewGadget             *eng;

    setmem(( void * )&Done[ 0 ], NUM_KINDS, 0 );

    for ( eng = gadgets->gl_First; eng->en_Next; eng = eng->en_Next ) {
        if ( ! Done[ eng->en_Kind ] ) {
            MyFPrintf( MainSource, "%s|", GadToolsIDCMP[ eng->en_Kind ] );
            Done[ eng->en_Kind ] = TRUE;
            if ( eng->en_Kind == SCROLLER_KIND ) {
                if ( GetTagData( GTSC_Arrows, 0, eng->en_Tags ))
                    FPuts( MainSource, "ARROWIDCMP|" );
            }
        }
    }
}

/*
 *      Write the IDCMP flags.
 */
Local VOID WriteIDCMPFlags( ULONG flags, struct ExtGadgetList *gadgets )
{
    UBYTE                      *tabs = "\n\t\t\t\t\t\t";

    if ( ! flags )  FPuts( MainSource, "0,\n" );
    else {
        WriteGadToolsIDCMP( gadgets );

        FPuts( MainSource, tabs );

        if ( SET( flags, IDCMP_GADGETUP )) {
            if ( ! Done[ 0  ] && ! Done[ 1  ] && ! Done[ 2  ] && ! Done[ 3  ] &&
                 ! Done[ 4  ] && ! Done[ 7  ] && ! Done[ 8  ] && ! Done[ 9  ] &&
                 ! Done[ 11 ] && ! Done[ 12 ] )
                FPuts( MainSource, "IDCMP_GADGETUP|" );
        }

        if ( SET( flags, IDCMP_GADGETDOWN )) {
            if ( ! Done[ 4 ] && ! Done[ 5 ] && ! Done[ 9 ] && ! Done[ 11 ] )
                FPuts( MainSource, "IDCMP_GADGETDOWN|" );
        }

        if ( SET( flags, IDCMP_INTUITICKS )) {
            if ( ! Done[ 4 ] && ! Done[ 9 ] )
                FPuts( MainSource, "IDCMP_INTUITICKS|" );
        }

        if ( SET( flags, IDCMP_MOUSEMOVE )) {
            if ( ! Done[ 4 ] && ! Done[ 9 ] && ! Done[ 11 ] )
                FPuts( MainSource, "IDCMP_MOUSEMOVE|" );
        }

        if ( SET( flags, IDCMP_MOUSEBUTTONS )) {
            if ( ! Done[ 4 ] && ! Done[ 9 ] )
                FPuts( MainSource, "IDCMP_MOUSEBUTTONS|" );
        }

        if ( SET( flags, IDCMP_SIZEVERIFY ))        FPuts( MainSource, "IDCMP_SIZEVERIFY|" );
        if ( SET( flags, IDCMP_NEWSIZE ))           FPuts( MainSource, "IDCMP_NEWSIZE|" );
        if ( SET( flags, IDCMP_REQSET ))            FPuts( MainSource, "IDCMP_REQSET|" );
        if ( SET( flags, IDCMP_MENUPICK ))          FPuts( MainSource, "IDCMP_MENUPICK|" );
        if ( SET( flags, IDCMP_CLOSEWINDOW ))       FPuts( MainSource, "IDCMP_CLOSEWINDOW|" );
        if ( SET( flags, IDCMP_RAWKEY ))            FPuts( MainSource, "IDCMP_RAWKEY|" );
        if ( SET( flags, IDCMP_REQVERIFY ))         FPuts( MainSource, "IDCMP_REQVERIFY|" );
        if ( SET( flags, IDCMP_REQCLEAR ))          FPuts( MainSource, "IDCMP_REQCLEAR|" );
        if ( SET( flags, IDCMP_MENUVERIFY ))        FPuts( MainSource, "IDCMP_MENUVERIFY|" );
        if ( SET( flags, IDCMP_NEWPREFS ))          FPuts( MainSource, "IDCMP_NEWPREFS|" );
        if ( SET( flags, IDCMP_DISKINSERTED ))      FPuts( MainSource, "IDCMP_DISKINSERTED|" );

        FPuts( MainSource, tabs );

        if ( SET( flags, IDCMP_DISKREMOVED ))       FPuts( MainSource, "IDCMP_DISKREMOVED|" );
        if ( SET( flags, IDCMP_ACTIVEWINDOW ))      FPuts( MainSource, "IDCMP_ACTIVEWINDOW|" );
        if ( SET( flags, IDCMP_INACTIVEWINDOW ))    FPuts( MainSource, "IDCMP_INACTIVEWINDOW|" );
        if ( SET( flags, IDCMP_DELTAMOVE ))         FPuts( MainSource, "IDCMP_DELTAMOVE|" );
        if ( SET( flags, IDCMP_VANILLAKEY ))        FPuts( MainSource, "IDCMP_VANILLAKEY|" );
        if ( SET( flags, IDCMP_IDCMPUPDATE ))       FPuts( MainSource, "IDCMP_IDCMPUPDATE|" );
        if ( SET( flags, IDCMP_MENUHELP ))          FPuts( MainSource, "IDCMP_MENUHELP|" );
        if ( SET( flags, IDCMP_CHANGEWINDOW ))      FPuts( MainSource, "IDCMP_CHANGEWINDOW|" );
        if ( SET( flags, IDCMP_REFRESHWINDOW ))     FPuts( MainSource, "IDCMP_SIZEVERIFY|" );

        Seek( MainSource, -1, OFFSET_CURRENT );
    }
}

/*
 *      Generate the GadgetID and array indexes.
 */
Local VOID GenID( void )
{
    struct ProjectWindow    *pw;
    struct ExtNewGadget     *eng;
    UWORD                    idx;

    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        for ( eng = pw->pw_Gadgets.gl_First; eng->en_Next; eng = eng->en_Next )
            MyFPrintf( Header, "#define GD_%-32s    %ld\n", &eng->en_GadgetLabel[ 0 ], eng->en_NewGadget.ng_GadgetID );
        FPuts( Header, "\n" );


        for ( eng = pw->pw_Gadgets.gl_First, idx = 0; eng->en_Next; eng = eng->en_Next )
            MyFPrintf( Header, "#define GDX_%-32s   %ld\n", &eng->en_GadgetLabel[ 0 ], idx++ );
        FPuts( Header, "\n" );
    }
}

/*
 *      Generate the strings and arrays.
 */
Local VOID WriteStrings( void )
{
    struct ArrayNode        *an;

    for ( an = Arrays.al_First; an->an_Next; an = an->an_Next ) {
        if ( STAT ) FPuts( MainSource, Static );
        else        MyFPrintf( Header, "extern UBYTE *GUIArray%ld[];\n", an->an_Number );

        MyFPrintf( MainSource, "UBYTE *GUIArray%ld[ %ld ];\n", an->an_Number, CountArray( an->an_Array ) + 2 );
    }
    FPuts( MainSource, "\n" );
}

/*
 *      Generate a reference to a string.
 */
Local VOID GenStrRef( UBYTE *string )
{
    MyFPrintf( MainSource, "MSG_STRING_%ld, ", GetStringNumber( &Strings, string ));
}

/*
 *      Generate a reference to an array.
 */
Local VOID GenArrRef( UBYTE **array )
{
    MyFPrintf( MainSource, "&GUIArray%ld[ 0 ], ", GetArrayNumber( &Arrays, array ));
}

/*
 *      Generate a NewMenu structure.
 */
Local VOID GenNewMenu( struct ExtNewMenu *menu )
{
    ULONG           flags = menu->em_NewMenu.nm_Flags;

    MyFPrintf( MainSource, "\t%s, ", GadToolsMenus[ menu->em_NewMenu.nm_Type ] );

    if ( menu->em_NewMenu.nm_Label != NM_BARLABEL ) {
        FPuts( MainSource, "(STRPTR)" );
        GenStrRef( &menu->em_MenuTitle[ 0 ] );
    } else {
        FPuts( MainSource, "(STRPTR)NM_BARLABEL, NULL, 0, 0, NULL,\n" );
        return;
    }

    if ( menu->em_NewMenu.nm_CommKey ) {
        FPuts( MainSource, "(STRPTR)" );
        GenStrRef( &menu->em_CommKey[ 0 ] );
    } else
        FPuts( MainSource, "NULL, " );

    if ( flags ) {
        if ( menu->em_NewMenu.nm_Type == NM_TITLE ) {
            if ( SET( flags, NM_MENUDISABLED )) FPuts( MainSource, "NM_MENUDISABLED|" );
        } else {
            if ( SET( flags, NM_ITEMDISABLED )) FPuts( MainSource, "NM_ITEMDISABLED|" );
        }

        if ( SET( flags, CHECKIT ))     FPuts( MainSource, "CHECKIT|" );
        if ( SET( flags, CHECKED ))     FPuts( MainSource, "CHECKED|" );
        if ( SET( flags, MENUTOGGLE ))  FPuts( MainSource, "MENUTOGGLE|" );

        Seek( MainSource, -1, OFFSET_CURRENT );
        FPuts( MainSource, ", " );
    } else
        FPuts( MainSource, "0, " );

    MyFPrintf( MainSource, "%ld, NULL,\n", menu->em_NewMenu.nm_MutualExclude );
}

/*
 *      Generate all NewMenus.
 */
Local VOID GenMenus( void )
{
    struct ProjectWindow        *pw;
    struct ExtNewMenu           *menu, *item, *sub;

    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( pw->pw_Menus.ml_First->em_Next ) {
            if ( STAT ) FPuts( MainSource, Static );
            else        MyFPrintf( Header, "extern struct NewMenu %sNewMenu[];\n", &pw->pw_Name[ 0 ] );
            MyFPrintf( MainSource, "struct NewMenu %sNewMenu[] = {\n", &pw->pw_Name[ 0 ] );

            for ( menu = pw->pw_Menus.ml_First; menu->em_Next; menu = menu->em_Next ) {
                GenNewMenu( menu );
                for ( item = menu->em_Items->ml_First;  item->em_Next; item = item->em_Next ) {
                    GenNewMenu( item );
                    for ( sub = item->em_Items->ml_First;  sub->em_Next; sub = sub->em_Next ) {
                        GenNewMenu( sub );
                    }
                }
            }
            FPuts( MainSource, "\tNM_END, NULL, NULL, 0, 0L, NULL\n};\n\n" );
        }
    }
}

/*
 *      Generate the NewGadget arrays.
 */
Local VOID GenGArrays( void )
{
    struct ProjectWindow    *pw;
    struct ExtNewGadget     *g;
    struct NewGadget        *ng;
    WORD                     bleft, btop;

    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {

        bleft = pw->pw_LeftBorder;
        btop  = pw->pw_TopBorder;

        if ( pw->pw_Gadgets.gl_First->en_Next ) {

            if ( STAT ) FPuts( MainSource, Static );
            else        MyFPrintf( Header, "extern struct NewGadget %sNGad[];\n", &pw->pw_Name[ 0 ] );

            MyFPrintf( MainSource, "struct NewGadget %sNGad[] = {\n", &pw->pw_Name[ 0 ] );

            for ( g = pw->pw_Gadgets.gl_First; g->en_Next; g = g->en_Next ) {

                ng = &g->en_NewGadget;

                MyFPrintf( MainSource, "\t%ld, %ld, %ld, %ld, ( UBYTE * )", ng->ng_LeftEdge - bleft, ng->ng_TopEdge - btop, ng->ng_Width, ng->ng_Height  );

                if ( ng->ng_GadgetText ) {
                    if ( strlen( ng->ng_GadgetText ))
                        GenStrRef( ng->ng_GadgetText );
                    else
                        goto noTxt;
                } else {
                    noTxt:
                    FPuts( MainSource, "NULL, " );
                }

                MyFPrintf( MainSource, "NULL, GD_%s, ", &g->en_GadgetLabel[ 0 ] );

                WritePlacementFlags( ng->ng_Flags );

                MyFPrintf( MainSource, ", NULL, (APTR)%s,\n", GadgetKinds[ g->en_Kind ] );
            }
            Seek( MainSource, -2L, OFFSET_CURRENT );
            FPuts( MainSource, "\n};\n\n" );
        }
    }
}
/*
 *      Generate the gadget tagitem arrays.
 */
Local VOID GenGTags( void )
{
    struct ProjectWindow    *pw;
    struct ExtNewGadget     *g;
    UBYTE                   *str, *ptr;
    UWORD                    num;
    ULONG                    sj;

    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( pw->pw_Gadgets.gl_First->en_Next ) {

            if ( NSET( SourceConfig.gc_GenCFlags0,CS0_AZTEC )) {
                if ( STAT ) FPuts( MainSource, Static );
                else        MyFPrintf( Header, "extern ULONG %sGTags[];\n", &pw->pw_Name[ 0 ] );
                MyFPrintf( MainSource, "ULONG %sGTags[] = {\n", &pw->pw_Name[ 0 ] );
                str = "";
            } else {
                if ( STAT ) FPuts( MainSource, Static );
                else        MyFPrintf( Header, "extern ULONG *%sGTags[];\n", &pw->pw_Name[ 0 ] );
                MyFPrintf( MainSource, "ULONG *%sGTags[] = {\n", &pw->pw_Name[ 0 ] );
                str = "(ULONG *)";
            }

            for ( g = pw->pw_Gadgets.gl_First; g->en_Next; g = g->en_Next ) {
                FPuts( MainSource, "\t" );

                switch ( g->en_Kind ) {

                    case    CHECKBOX_KIND:
                        if ( GTX_TagInArray( GTCB_Checked, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTCB_Checked), %sTRUE, ", str, str );
                        if ( SET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT ))
                            MyFPrintf( MainSource, "%s(GTCB_Scaled), %sTRUE, ", str, str );
                        break;

                    case    CYCLE_KIND:
                        if ( NSET( SourceConfig.gc_GenCFlags0, CS0_AZTEC ))
                            FPuts( MainSource, "(GTCY_Labels), (ULONG)" );
                        else
                            FPuts( MainSource, "(ULONG *)(GTCY_Labels), (ULONG *)" );

                        GenArrRef( ( UBYTE ** )GetTagData( GTCY_Labels, NULL, g->en_Tags ));

                        if ( GTX_TagInArray( GTCY_Active, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTCY_Active), %s%ld, ", str, str, GetTagData( GTCY_Active, 0, g->en_Tags ));
                        break;

                    case    INTEGER_KIND:
                        if ( GTX_TagInArray( GA_TabCycle, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GA_TabCycle), %sFALSE, ", str, str );
                        if ( GTX_TagInArray( STRINGA_ExitHelp, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(STRINGA_ExitHelp), %sTRUE, ", str, str );
                        if ( num = GetTagData( GTIN_Number, 0, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTIN_Number), %s%ld, ", str, str, num);
                        if (( num = GetTagData( GTIN_Number, 10, g->en_Tags )) != 10 )
                            MyFPrintf( MainSource, "%s(GTIN_MaxChars), %s%ld, ", str, str, 10 );
                        if ( sj = GetTagData( STRINGA_Justification, 0l, g->en_Tags )) {
                            MyFPrintf( MainSource, "%s(STRINGA_Justification), ", str );
                            if ( sj == GACT_STRINGCENTER ) MyFPrintf( MainSource, "%s(GACT_STRINGCENTER), ", str );
                            else                           MyFPrintf( MainSource, "%s(GACT_STRINGRIGHT), ", str );
                        }
                        break;

                    case    LISTVIEW_KIND:
                        if (( g->en_Flags & GDF_NEEDLOCK ) == GDF_NEEDLOCK )
                            MyFPrintf( MainSource, "%s(GTLV_ShowSelected), %s1L, ", str, str );
                        else if (GTX_TagInArray( GTLV_ShowSelected, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTLV_ShowSelected), %sNULL, ", str, str );
                        if ( GTX_TagInArray( GTLV_ScrollWidth, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTLV_ScrollWidth), %s%ld, ", str, str, GetTagData( GTLV_ScrollWidth, 0, g->en_Tags ));
                        if ( GTX_TagInArray( GTLV_ReadOnly, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTLV_ReadOnly), %sTRUE, ", str, str );
                        if ( GTX_TagInArray( LAYOUTA_Spacing, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(LAYOUTA_Spacing), %s%ld, ", str, str, GetTagData( LAYOUTA_Spacing, 0, g->en_Tags ));
                        break;

                    case    MX_KIND:
                        if ( NSET( SourceConfig.gc_GenCFlags0, CS0_AZTEC ))
                            FPuts( MainSource, "(GTMX_Labels), (ULONG)" );
                        else
                            FPuts( MainSource, "(ULONG *)(GTMX_Labels), (ULONG *)" );

                        GenArrRef( ( UBYTE ** )GetTagData( GTMX_Labels, NULL, g->en_Tags ));

                        if ( GTX_TagInArray( GTMX_Spacing, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTMX_Spacing), %s%ld, ", str, str, GetTagData( GTMX_Spacing, 0, g->en_Tags ));
                        if ( GTX_TagInArray( GTMX_Active, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTMC_Active), %s%ld, ", str, str, GetTagData( GTMX_Active, 0, g->en_Tags ));
                        if ( SET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT ))
                            MyFPrintf( MainSource, "%s(GTMX_Scaled), %sTRUE, ", str, str );
                        break;

                    case    PALETTE_KIND:
                        MyFPrintf( MainSource, "%s(GTPA_Depth), %s%ld, ", str, str, GetTagData( GTPA_Depth, 1, g->en_Tags ));
                        if ( GTX_TagInArray( GTPA_IndicatorWidth, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTPA_IndicatorWidth), %s%ld, ", str, str, GetTagData( GTPA_IndicatorWidth, NULL, g->en_Tags ));
                        if ( GTX_TagInArray( GTPA_IndicatorHeight, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTPA_IndicatorHeight), %s%ld, ", str, str, GetTagData( GTPA_IndicatorHeight, NULL, g->en_Tags ));
                        if ( GTX_TagInArray( GTPA_Color, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTPA_Color), %s%ld, ", str, str, GetTagData( GTPA_Color, 1, g->en_Tags ));
                        if ( GTX_TagInArray( GTPA_ColorOffset, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTPA_ColorOffset), %s%ld, ", str, str, GetTagData( GTPA_ColorOffset, 0, g->en_Tags ));
                        break;

                    case    SCROLLER_KIND:
                        if ( GTX_TagInArray( GTSC_Top, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTSC_Top), %s%ld, ", str, str, GetTagData( GTSC_Top, NULL, g->en_Tags ));
                        if ( GTX_TagInArray( GTSC_Total, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTSC_Total), %s%ld, ", str, str, GetTagData( GTSC_Total, NULL, g->en_Tags ));
                        if ( GTX_TagInArray( GTSC_Visible, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTSC_Visible), %s%ld, ", str, str, GetTagData( GTSC_Visible, NULL, g->en_Tags ));
                        if ( GTX_TagInArray( GTSC_Arrows, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTSC_Arrows), %s%ld, ", str, str, GetTagData( GTSC_Arrows, 0, g->en_Tags ));
                        if ( GTX_TagInArray( PGA_Freedom, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(PGA_Freedom), %sLORIENT_VERT, ", str, str );
                        else
                            MyFPrintf( MainSource, "%s(PGA_Freedom), %sLORIENT_HORIZ, ", str, str );
                        if ( GTX_TagInArray( GA_Immediate, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GA_Immediate), %sTRUE, ", str, str );
                        if ( GTX_TagInArray( GA_RelVerify, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GA_RelVerify), %sTRUE, ", str, str );
                        break;

                    case    SLIDER_KIND:
                        if ( GTX_TagInArray( GTSL_Min, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTSL_Min), %s%ld, ", str, str, GetTagData( GTSL_Min, NULL, g->en_Tags ));
                        if ( GTX_TagInArray( GTSL_Max, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTSL_Max), %s%ld, ", str, str, GetTagData( GTSL_Max, NULL, g->en_Tags ));
                        if ( GTX_TagInArray( GTSL_Level, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTSL_Level), %s%ld, ", str, str, GetTagData( GTSL_Level, NULL, g->en_Tags ));
                        if ( GTX_TagInArray( GTSL_MaxLevelLen, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTSL_MaxLevelLen), %s%ld, ", str, str, GetTagData( GTSL_MaxLevelLen, NULL, g->en_Tags ));

                        if ( GTX_TagInArray( GTSL_LevelFormat, g->en_Tags )) {
                            if ( NSET( SourceConfig.gc_GenCFlags0, CS0_AZTEC ))
                                FPuts( MainSource, "(GTSL_LevelFormat), (ULONG)" );
                            else
                                FPuts( MainSource, "(ULONG *)(GTSL_LevelFormat), (ULONG *)" );

                            GenStrRef( ( UBYTE * )GetTagData( GTSL_LevelFormat, 0, g->en_Tags ));
                        }

                        if ( GTX_TagInArray( GTSL_LevelPlace, g->en_Tags )) {
                            MyFPrintf( MainSource, "%s(GTSL_LevelPlace), %s(", str, str );
                            WritePlacementFlags( GetTagData( GTSL_LevelPlace, NULL, g->en_Tags ));
                            FPuts( MainSource, "), " );
                        }
                        if ( GTX_TagInArray( PGA_Freedom, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(PGA_Freedom), %sLORIENT_VERT, ", str, str );
                        else
                            MyFPrintf( MainSource, "%s(PGA_Freedom), %sLORIENT_HORIZ, ", str, str );
                        if ( GTX_TagInArray( GA_Immediate, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GA_Immediate), %sTRUE, ", str, str );
                        if ( GTX_TagInArray( GA_RelVerify, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GA_RelVerify), %sTRUE, ", str, str );
                        break;

                    case    STRING_KIND:
                        if ( GTX_TagInArray( GA_TabCycle, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GA_TabCycle), %sFALSE, ", str, str );
                        if ( GTX_TagInArray( STRINGA_ExitHelp, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(STRINGA_ExitHelp), %sTRUE, ", str, str );
                        if ( ptr = ( UBYTE * )GetTagData( GTST_String, NULL, g->en_Tags )) {
                            if ( strlen( ptr )) {
                                if ( NSET( SourceConfig.gc_GenCFlags0, CS0_AZTEC ))
                                    FPuts( MainSource, "(GTST_String), (ULONG)" );
                                else
                                    FPuts( MainSource, "(ULONG *)(GTST_String), (ULONG *)" );
                            }
                            GenStrRef( ptr );
                        }
                        if (( num = GetTagData( GTST_MaxChars, 64, g->en_Tags )) != 64 )
                            MyFPrintf( MainSource, "%s(GTST_MaxChars), %s%ld, ", str, str, num );
                        if ( sj = GetTagData( STRINGA_Justification, 0l, g->en_Tags )) {
                            MyFPrintf( MainSource, "%s(STRINGA_Justification), ", str );
                            if ( sj == GACT_STRINGCENTER ) MyFPrintf( MainSource, "%s(GACT_STRINGCENTER), ", str );
                            else                           MyFPrintf( MainSource, "%s(GACT_STRINGRIGHT), ", str );
                        }
                        break;

                    case    NUMBER_KIND:
                        if ( GTX_TagInArray( GTNM_Number, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTNM_Number), %s%ld, ", str, str, GetTagData( GTNM_Number, 0, g->en_Tags ));
                        if ( GTX_TagInArray( GTNM_Border, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTNM_Border), %sTRUE, ", str, str );
                        break;

                    case    TEXT_KIND:
                        if ( ptr = ( UBYTE * )GetTagData( GTTX_Text, NULL, g->en_Tags )) {
                            if ( strlen( ptr )) {
                                if ( NSET( SourceConfig.gc_GenCFlags0, CS0_AZTEC ))
                                    FPuts( MainSource, "(GTTX_Text), (ULONG)" );
                                else
                                    FPuts( MainSource, "(ULONG *)(GTTX_Text), (ULONG *)" );
                            }
                            GenStrRef( ptr );
                        }
                        if ( GTX_TagInArray( GTTX_Border, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTTX_Border), %sTRUE, ", str, str );
                        if ( GTX_TagInArray( GTTX_CopyText, g->en_Tags ))
                            MyFPrintf( MainSource, "%s(GTTX_CopyText), %sTRUE, ", str, str );
                        break;
                }

                if ( g->en_Kind != GENERIC_KIND ) {
                    if ( GTX_TagInArray( GT_Underscore,  g->en_Tags ))
                        MyFPrintf( MainSource, "%s(GT_Underscore), %s'_', ", str, str );
                }

                if ( GTX_TagInArray( GA_Disabled, g->en_Tags ))
                    MyFPrintf( MainSource, "%s(GA_Disabled), TRUE, ", str, str );

                MyFPrintf( MainSource, "%s(TAG_DONE),\n", str );
            }
            Seek( MainSource, -2L, OFFSET_CURRENT );
            FPuts( MainSource, "\n};\n\n" );
        }
    }
}

/*
 *      Check for menus in the file.
 */
Local BOOL CheckMenus( void )
{
    struct ProjectWindow        *pw;

    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( pw->pw_Menus.ml_First->em_Next )
            return( TRUE );
    }
    return( FALSE );
}

/*
 *      Check for gadgets in the file.
 */
Local BOOL CheckGadgets( void )
{
    struct ProjectWindow        *pw;

    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( pw->pw_Gadgets.gl_First->en_Next )
            return( TRUE );
    }
    return( FALSE );
}

/*
 *      Check for GENERIC_KIND (=GETFILE) gadgets.
 */
Local BOOL CheckGeneric( void )
{
    struct ProjectWindow        *pw;
    struct ExtNewGadget         *eng;

    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        for ( eng = pw->pw_Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
            if ( eng->en_Kind == GENERIC_KIND )
                return( TRUE );
        }
    }
}

/*
 *      Check for joined LISTVIEW gadgets.
 */
Local BOOL CheckJoined( void )
{
    struct ProjectWindow        *pw;
    struct ExtNewGadget         *eng;

    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        for ( eng = pw->pw_Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
            if ( eng->en_Kind == LISTVIEW_KIND ) {
                if ( eng->en_Flags & GDF_NEEDLOCK )
                    return( TRUE );
            }
        }
    }
}

/*
 *      Generate the necessary globals.
 */
Local VOID GenGlobals( VOID )
{
    struct ProjectWindow        *pw;

   /*
    *       Generate gadget counters.
    */
    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( pw->pw_Gadgets.gl_First->en_Next )
            MyFPrintf( Header, "#define %s_CNT %ld\n", &pw->pw_Name[ 0 ], GTX_CountNodes(( struct List * )&pw->pw_Gadgets ));
    }
    FPuts( Header, "\n" );

   /*
    *       Generate screen stuff.
    */
    if ( STAT ) FPuts( MainSource, Static );
    else        FPuts( Header, "extern struct Screen *Scr;\n" );
    FPuts( MainSource, "struct Screen *Scr = NULL;\n" );

    if ( SET( GuiInfo.gui_Flags0, GU0_PUBLIC ) || SET( GuiInfo.gui_Flags0, GU0_WORKBENCH )) {
        if ( STAT ) FPuts( MainSource, Static );
        else        FPuts( Header, "extern UBYTE *PubScreenName;\n" );
        FPuts( MainSource, "UBYTE *PubScreenName = " );

        if ( SET( GuiInfo.gui_Flags0, GU0_PUBLIC )) FPuts( MainSource, "NULL;\n" );
        else                                        FPuts( MainSource, "( UBYTE * )\"Workbench\";\n" );
    }

   /*
    *       Generate visual info.
    */
    if ( STAT ) FPuts( MainSource, Static );
    else        FPuts( Header, "extern APTR VisualInfo;\n" );
    FPuts( MainSource, "APTR VisualInfo = NULL;\n" );

   /*
    *       Generate window pointers.
    */
    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( STAT ) FPuts( MainSource, Static );
        else        MyFPrintf( Header, "extern struct Window *%sWnd;\n", &pw->pw_Name[ 0 ] );
        MyFPrintf( MainSource, "struct Window *%sWnd;\n", &pw->pw_Name[ 0 ] );
    }

   /*
    *       Generate title window pointers.
    */
    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( STAT ) FPuts( MainSource, Static );
        else        MyFPrintf( Header, "extern UBYTE *%sWdt;\n", &pw->pw_Name[ 0 ] );
        MyFPrintf( MainSource, "UBYTE *%sWdt;\n", &pw->pw_Name[ 0 ] );
    }

   /*
    *       Generate locale data.
    */
    if ( STAT ) FPuts( MainSource, Static );
    else        MyFPrintf( Header, "extern UBYTE LocDone[ %ld ];\n", GTX_CountNodes(( struct List * )&Windows ));
    MyFPrintf( MainSource, "UBYTE LocDone[ %ld ];\n", GTX_CountNodes(( struct List * )&Windows ));

   /*
    *       Generate gadget list pointers.
    */
    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( pw->pw_Gadgets.gl_First->en_Next ) {
            if ( STAT ) FPuts( MainSource, Static );
            else        MyFPrintf( Header, "extern struct Gadget *%sGList;\n", &pw->pw_Name[ 0 ] );
            MyFPrintf( MainSource, "struct Gadget *%sGList = NULL;\n", &pw->pw_Name[ 0 ] );
        }
    }

   /*
    *       Generate menu pointers.
    */
    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( pw->pw_Menus.ml_First->em_Next ) {
            if ( STAT ) FPuts( MainSource, Static );
            else        MyFPrintf( Header, "extern struct Menu *%sMenus;\n", &pw->pw_Name[ 0 ] );
            MyFPrintf( MainSource, "struct Menu *%sMenus = NULL;\n", &pw->pw_Name[ 0 ] );
        }
    }

   /*
    *       Generate zoom arrays.
    */
    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( SET( pw->pw_TagFlags, WDF_ZOOM ) || SET( pw->pw_TagFlags, WDF_DEFAULTZOOM )) {
            if ( NSET( pw->pw_WindowFlags, WFLG_SIZEGADGET )) {
                if ( STAT ) FPuts( MainSource, Static );
                else        MyFPrintf( Header, "extern UWORD %sZoom[ 4 ];\n", &pw->pw_Name[ 0 ] );
                MyFPrintf( MainSource, "UWORD %sZoom[ 4 ];\n", &pw->pw_Name[ 0 ] );
            }
        }
    }

   /*
    *       Generate gadget arrays.
    */
    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( pw->pw_Gadgets.gl_First->en_Next ) {
            if ( STAT ) FPuts( MainSource, Static );
            else        MyFPrintf( Header, "extern struct Gadget *%sGadgets[ %ld ];\n", &pw->pw_Name[ 0 ], GTX_CountNodes(( struct List * )&pw->pw_Gadgets ));
            MyFPrintf( MainSource, "struct Gadget *%sGadgets[ %ld ];\n", &pw->pw_Name[ 0 ], GTX_CountNodes(( struct List * )&pw->pw_Gadgets ));
        }
    }

   /*
    *       Generate the BOOPSI stuff.
    */
    if ( CheckGeneric()) {
        FPuts( Protos, "extern struct IClass *initGet( void );\n" );
        if ( STAT ) FPuts( MainSource, Static );
        else        FPuts( Header, "extern struct IClass *getClass;\n" );
        FPuts( MainSource, "//struct IClass *getClass;\n" );
        if ( STAT ) FPuts( MainSource, Static );
        else        FPuts( Header, "extern struct _Object *getImage;\n" );
        FPuts( MainSource, "//struct _Object *getImage;\n" );
    }

   /*
    *       Generate window location & dimensions.
    */
    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( STAT ) FPuts( MainSource, Static );
        MyFPrintf( MainSource, "UWORD %sLeft = %ld, %sTop = %ld;\n", &pw->pw_Name[ 0 ], GetTagData( WA_Left, 0, pw->pw_Tags ), &pw->pw_Name[ 0 ], GetTagData( WA_Top, 0, pw->pw_Tags ));
        if ( NSET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) {
            if ( STAT ) FPuts( MainSource, Static );
            MyFPrintf( MainSource, "UWORD %sWidth = ", &pw->pw_Name[ 0 ] );

            if ( SET( pw->pw_TagFlags, WDF_INNERWIDTH ))    MyFPrintf( MainSource, "%ld, ", pw->pw_InnerWidth );
            else                                            MyFPrintf( MainSource, "%ld, ", GetTagData( WA_Width, 0, pw->pw_Tags ));

            if ( STAT ) FPuts( MainSource, Static );
            MyFPrintf( MainSource, "%sHeight = ", &pw->pw_Name[ 0 ] );

            if ( SET( pw->pw_TagFlags, WDF_INNERHEIGHT ))    MyFPrintf( MainSource, "%ld;\n", pw->pw_InnerHeight );
            else                                             MyFPrintf( MainSource, "%ld;\n", GetTagData( WA_Height, 0, pw->pw_Tags ) - pw->pw_TopBorder );
        } else {
            if ( STAT ) FPuts( MainSource, Static );
            MyFPrintf( MainSource, "UWORD %sWidth = %ld, %sHeight = %ld;\n", &pw->pw_Name[ 0 ], pw->pw_InnerWidth, &pw->pw_Name[ 0 ], pw->pw_InnerHeight );
        }
        if ( NSTAT )
            MyFPrintf( Header, "extern UWORD %sLeft, %sTop, %sWidth, %sHeight;\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
    }

   /*
    *       Generate the font adaptivity stuff.
    */
    if ( SET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) {
        if ( STAT ) FPuts( MainSource, Static );
        else        FPuts( Header, "extern struct TextAttr *Font, Attr;\n" );
        FPuts( MainSource, "struct TextAttr *Font = NULL, Attr;\n" );
        if ( STAT ) FPuts( MainSource, Static );
        else        FPuts( Header, "extern UWORD FontX, FontY, OffX, OffY;\n" );
        FPuts( MainSource, "UWORD FontX, FontY, OffX, OffY;\n" );
        if ( SET( SourceConfig.gc_GenCFlags0, CS0_SYSFONT )) {
            for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
                if ( STAT ) FPuts( MainSource, Static );
                else        MyFPrintf( Header, "extern struct TextFont *%sFont;\n", &pw->pw_Name[ 0 ] );
                MyFPrintf( MainSource, "struct TextFont *%sFont = NULL;\n", &pw->pw_Name[ 0 ] );
            }
            FPuts( Header, "extern struct GfxBase *GfxBase;\n" );
        }
    }

   /*
    *       Generate gadtoolsbox.library stuff.
    */
    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
        if ( STAT ) FPuts( MainSource, Static );
        else        MyFPrintf( Header, "extern HOTKEYHANDLE %sHandle;\n", &pw->pw_Name[ 0 ] );
        MyFPrintf( MainSource, "HOTKEYHANDLE %sHandle = NULL;\n", &pw->pw_Name[ 0 ] );
    }

    FPuts( MainSource, "struct TagItem HandleTags[] = {\n\tHKH_UseNewButton,\tTRUE,\n\tHKH_NewText,\tTRUE,\n\tHKH_SetRepeat,\tSRF_CYCLE|SRF_SLIDER|SRF_LISTVIEW|SRF_PALETTE,\n\tTAG_END\n};\n" );

    FPuts( MainSource, "UWORD Pattern[ 2 ] = { 0xAAAA, 0x5555 };\n" );

   /*
    *       Generate locale stuff.
    */
    if ( STAT ) FPuts( MainSource, Static );
    else        FPuts( Header, "extern struct Catalog *Catalog;\n" );
    FPuts( MainSource, "struct Catalog *Catalog = NULL;\n" );

    FPuts( MainSource, "\n" );
}

/*
 *      Generate the .CD file.
 */
Local VOID GenCD( void )
{
    BPTR                     fh;
    ULONG                    len;
    UBYTE                   *Buffer;
    struct StringNode       *sn;
    UWORD                    mn;

    if ( Arguments.Prepend ) {
        Print( STRING( MSG_PREPENDING_CD ));
        if ( fh = Open( Arguments.Prepend, MODE_OLDFILE )) {
                  Seek( fh, 0, OFFSET_END );
            len = Seek( fh, 0, OFFSET_BEGINNING );
            if ( Buffer = ( UBYTE * )AllocMem( len, MEMF_PUBLIC )) {
                if ( Read( fh, Buffer, len ) == len ) {
                    if ( FWrite( Locale, Buffer, len, 1 ) != 1 )
                        Print( STRING( MSG_WRITE_ERROR ));
                } else
                    Print( STRING( MSG_READ_ERROR ));
                FreeMem( Buffer, len );
            } else
                Print( STRING( MSG_OUT_OF_MEMORY ));
            Close( fh );
        } else
            Print( STRING( MSG_PREPEND_FILE_ERROR ));
    }

    for ( sn = Strings.sl_First, mn = 0; sn->sn_Next; sn = sn->sn_Next, mn++ )
        MyFPrintf( Locale, ";\nMSG_STRING_%ld (/0/)\n%s\n", mn, sn->sn_String );
}

/*
 *      Generate fixed routines.
 */
Local VOID GenLocal( void )
{
    struct ArrayNode        *an;
    UBYTE                  **array, *bi;
    LONG                    *version = Arguments.CatVersion;
    UWORD                    nn, in;

    if ( ! ( bi = Arguments.BuiltIn )) bi = "english";

    FPuts( Header, "extern struct LocalBase *LocalBase;\n" );
    FPuts( Protos, "extern BOOL SetupLocale( void );\n" );

    FPuts( MainSource, "BOOL SetupLocale( void )\n{\n"
                       "\tUWORD\t\tnum;\n\n" );

    MyFPrintf( MainSource, "\tif ( LocaleBase && ( Catalog = OpenCatalog( NULL, \"%s\", OC_BuiltInLanguage, \"%s\", OC_Version, %ld, TAG_END ))) {\n", Arguments.Catalog, bi, *version );
    FPuts( MainSource,     "\t\tfor ( num = 0; num < ( sizeof( AppStrings ) / sizeof( struct AppString )); num++ )\n"
                           "\t\t\tAppStrings[ num ].as_Str = GetCatalogStr( Catalog, num, AppStrings[ num ].as_Str );\n"
                           "\t}\n\n" );

    for ( an = Arrays.al_First, nn = 0, in = 0; an->an_Next; an = an->an_Next, nn++ ) {
        array = an->an_Array;
        while ( *array ) {
            MyFPrintf( MainSource, "\tGUIArray%ld[ %ld ] = ( UBYTE * )AppStrings[ MSG_STRING_%ld ].as_Str;\n", nn, in, GetStringNumber( &Strings, *array ));
            in++;
            array++;
        }
        MyFPrintf( MainSource, "\tGUIArray%ld[ %ld ] = ( UBYTE * )NULL;\n\n", nn, in );
        in = 0;
    }

    FPuts( MainSource, "}\n\n" );

    if ( CheckGadgets()) {
        FPuts( Protos, "extern VOID FixTags( struct TagItem *, UWORD );\n" );

        FPuts( MainSource, "VOID FixTags( struct TagItem *tags, UWORD kind )\n{\n"
                           "\tstruct TagItem *tag;\n\n"
                           "\tswitch ( kind ) {\n"
                           "\t\tcase\tSTRING_KIND:\n"
                           "\t\t\tif ( tag = FindTagItem( GTST_String, tags ))\n"
                           "\t\t\t\ttag->ti_Data = ( ULONG )AppStrings[ tag->ti_Data ].as_Str;\n\t\t\tbreak;\n"
                           "\t\tcase\tTEXT_KIND:\n"
                           "\t\t\tif ( tag = FindTagItem( GTTX_Text, tags ))\n"
                           "\t\t\t\ttag->ti_Data = ( ULONG )AppStrings[ tag->ti_Data ].as_Str;\n\t\t\tbreak;\n"
                           "\t\tcase\tSLIDER_KIND:\n"
                           "\t\t\tif ( tag = FindTagItem( GTSL_LevelFormat, tags ))\n"
                           "\t\t\t\ttag->ti_Data = ( ULONG )AppStrings[ tag->ti_Data ].as_Str;\n\t\t\tbreak;\n"
                           "\t}\n}\n\n" );

        FPuts( Protos, "extern VOID FixGadgets( struct NewGadget *, UWORD );\n" );

        FPuts( MainSource, "VOID FixGadgets( struct NewGadget *ng, UWORD numgads )\n{\n"
                           "\twhile ( numgads ) {\n"
                           "\t\tif ( ng->ng_GadgetText )\n"
                           "\t\t\tng->ng_GadgetText = AppStrings[ (ULONG)ng->ng_GadgetText ].as_Str;\n"
                           "\t\tnumgads--;\n\t\tng++;\n"
                           "\t}\n}\n\n" );
    }

    if ( CheckMenus()) {
        FPuts( Protos, "extern VOID FixMenus( struct NewMenu * );\n" );

        FPuts( MainSource, "VOID FixMenus( struct NewMenu *menu )\n{\n"
                           "\twhile ( menu->nm_Type != NM_END ) {\n"
                           "\t\tif ( menu->nm_Label && menu->nm_Label != NM_BARLABEL )\n"
                           "\t\t\tmenu->nm_Label = AppStrings[ (ULONG)menu->nm_Label ].as_Str;\n"
                           "\t\tmenu++;\n"
                           "\t}\n}\n\n" );
    }

    if ( SET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) {
        FPuts( Protos, "extern UWORD ComputeX( UWORD );\nextern UWORD ComputeY( UWORD );\nextern VOID ComputeFont( UWORD, UWORD );\n" );

        FPuts( MainSource, "UWORD ComputeX( UWORD value )\n{\n\treturn(( UWORD )((( FontX * value ) + 4 ) / 8 ));\n}\n\n" );
        FPuts( MainSource, "UWORD ComputeY( UWORD value )\n{\n\treturn(( UWORD )((( FontY * value ) + 4 ) / 8 ));\n}\n\n" );

        FPuts( MainSource, "VOID ComputeFont( UWORD width, UWORD height )\n{\n" );
        if ( NSET( SourceConfig.gc_GenCFlags0, CS0_SYSFONT ))
            FPuts( MainSource, "\tFont = &Attr;\n\tFont->ta_Name = (STRPTR)Scr->RastPort.Font->tf_Message.mn_Node.ln_Name;\n\tFont->ta_YSize = FontY = Scr->RastPort.Font->tf_YSize;\n\tFontX = Scr->RastPort.Font->tf_XSize;\n\n" );
        else
            FPuts( MainSource, "\tForbid();\n\tFont = &Attr;\n\t"\
                         "Font->ta_Name = (STRPTR)GfxBase->DefaultFont->tf_Message.mn_Node.ln_Name;\n\tFont->ta_YSize = FontY = GfxBase->DefaultFont->tf_YSize;\n\tFontX = GfxBase->DefaultFont->tf_XSize;\n\tPermit();\n\n" );

        FPuts( MainSource, "\tOffX = Scr->WBorLeft;\n" );
        FPuts( MainSource, "\tOffY = Scr->RastPort.TxHeight + Scr->WBorTop + 1;\n\n" );
        FPuts( MainSource, "\tif ( width && height ) {\n\t\tif (( ComputeX( width ) + OffX + Scr->WBorRight ) > Scr->Width )\n\t\t\tgoto UseTopaz;\n"\
                     "\t\tif (( ComputeY( height ) + OffY + Scr->WBorBottom ) > Scr->Height )\n\t\t\tgoto UseTopaz;\n"\
                     "\t}\n\treturn;\n\n" );
        FPuts( MainSource, "UseTopaz:\n\tFont->ta_Name = (STRPTR)\"topaz.font\";\n\tFontX = FontY = Font->ta_YSize = 8;\n}\n\n" );
    }

    FPuts( Protos, "extern VOID myDrawBevelBox( struct RastPort *, UWORD, UWORD, UWORD, UWORD, Tag tag1, ... );\n" );

    FPuts( MainSource, "VOID myDrawBevelBox( struct RastPort *rp, UWORD l, UWORD t, UWORD w, UWORD h, Tag tag1, ... )\n{\n"
                       "\tstruct DrawInfo\t*dri;\n\n"
                       "\tif ( dri = GetScreenDrawInfo( Scr )) {\n"
                       "\t\tSetAPen( rp, dri->dri_Pens[ BACKGROUNDPEN ] );\n"
                       "\t\tRectFill( rp, l, t, l + w - 1, t + h - 1 );\n"
                       "\t\tFreeScreenDrawInfo( Scr, dri );\n\t}\n"
                       "\tDrawBevelBoxA( rp, l, t, w, h, ( struct TagItem * )&tag1 );\n}\n\n" );

    FPuts( Protos, "extern VOID BackFill( struct Window * );\n" );

    FPuts( MainSource, "VOID BackFill( struct Window *wnd )\n{\n"
                       "\tstruct DrawInfo\t*dri;\n\n"
                       "\tif ( dri = GetScreenDrawInfo( Scr )) {\n"
                       "\t\tSetAPen( wnd->RPort, dri->dri_Pens[ SHINEPEN ] );\n"
                       "\t\tSetAfPt( wnd->RPort, &Pattern[ 0 ], 1 );\n"
                       "\t\tRectFill( wnd->RPort, wnd->BorderLeft, wnd->BorderTop, wnd->Width - wnd->BorderRight - 1, wnd->Height - wnd->BorderBottom - 1 );\n"
                       "\t\tSetAfPt( wnd->RPort, NULL, 0 );\n"
                       "\t\tFreeScreenDrawInfo( Scr, dri );\n\t}\n}\n\n" );
}

/*
 *      Run CatComp.
 */
Local VOID RunCatComp( void )
{
    UBYTE               RunStr[ 256 ], *ptr;
    UWORD               i = 0;

    strcpy( &RunStr[ 0 ], "CatComp " );
    strcat( &RunStr[ 0 ], Arguments.SourceName );

    if ( ptr = strrchr( &RunStr[ 0 ], '.' ))
        *ptr = 0;

    strcat( &RunStr[ 0 ], ".cd CFILE=" );
    strcat( &RunStr[ 0 ], Arguments.SourceName );

    if ( ptr ) {
        if ( ptr = strrchr( &RunStr[ 0 ], '.' ))
            *ptr = 0;
    }

    strcat( &RunStr[ 0 ], "_locale.h" );

    Print( "%s\n", &RunStr[ 0 ] );

    SystemTags( &RunStr[ 0 ], TAG_END );
}

/*
 *      Generate the TextAttr structure.
 */
Local VOID GenTextAttr( VOID )
{
    UBYTE                   fname[ 32 ], *ptr;

    strcpy( &fname[ 0 ], &GuiInfo.gui_FontName[ 0 ] );

    if ( ptr= strrchr( &fname[ 0 ], '.' ))
        *ptr = 0;

    if ( STAT ) FPuts( MainSource, Static );
    else        MyFPrintf( Header, "extern struct TextAttr %s%ld;\n", &fname[ 0 ], GuiInfo.gui_Font.ta_YSize );

    MyFPrintf( MainSource, "struct TextAttr %s%ld = {\n", &fname[ 0 ], GuiInfo.gui_Font.ta_YSize );
    MyFPrintf( MainSource, "\t(STRPTR)\"%s\", %ld, 0x%02lx, 0x%02lx };\n\n", &GuiInfo.gui_FontName[ 0 ],
                                                                              GuiInfo.gui_Font.ta_YSize,
                                                                              GuiInfo.gui_Font.ta_Style,
                                                                              GuiInfo.gui_Font.ta_Flags );
}

/*
 *      Generate gadget initialization.
 */
Local VOID GenGadgetInit( struct ProjectWindow *pw )
{
    struct ExtNewGadget     *g, *pred, *tmp;
    struct NewGadget        *ng;
    UBYTE                    fname[ 32 ], *ptr;
    UWORD                    num, btop, bleft;

    btop  = pw->pw_TopBorder;
    bleft = pw->pw_LeftBorder;

    strcpy( &fname[ 0 ], &GuiInfo.gui_FontName[ 0 ] );

    if ( ptr = strrchr( &fname[ 0 ], '.' ))
        *ptr = 0;

    MyFPrintf( MainSource, "\tif ( ! LocDone[ %ld ] )\n\t\tFixGadgets( &%sNGad[ 0 ], %s_CNT );\n\n", GTX_GetNodeNumber(( struct List * )&Windows, ( struct Node * )pw ), &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

    MyFPrintf( MainSource, "\tfor( lc = 0, tc = 0; lc < %s_CNT; lc++ ) {\n\n", &pw->pw_Name[ 0 ] );
    MyFPrintf( MainSource, "\t\tCopyMem(( void * )&%sNGad[ lc ], ( void * )&ng, (long)sizeof( struct NewGadget ));\n\n", &pw->pw_Name[ 0 ] );
    FPuts( MainSource, "\t\tng.ng_VisualInfo = VisualInfo;\n" );

    if ( SET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) {
        FPuts( MainSource, "\t\tng.ng_TextAttr   = Font;\n" );
        FPuts( MainSource, "\t\tng.ng_LeftEdge   = OffX + ComputeX( ng.ng_LeftEdge );\n" );
        FPuts( MainSource, "\t\tng.ng_TopEdge    = OffY + ComputeY( ng.ng_TopEdge );\n" );
        if ( CheckGeneric()) {
            for ( tmp  = pw->pw_Gadgets.gl_First; tmp->en_Next; tmp = tmp->en_Next ) {
                if ( tmp->en_Kind == GENERIC_KIND ) {
                    FPuts( MainSource, "\n\t\tif (( ULONG )ng.ng_UserData != GENERIC_KIND ) {\n" );
                    FPuts( MainSource, "\t\t\tng.ng_Width      = ComputeX( ng.ng_Width );\n" );
                    FPuts( MainSource, "\t\t\tng.ng_Height     = ComputeY( ng.ng_Height);\n\t\t}\n\n" );
                    goto skipTheShit;
                }
            }
        }
        FPuts( MainSource, "\t\tng.ng_Width      = ComputeX( ng.ng_Width );\n" );
        FPuts( MainSource, "\t\tng.ng_Height     = ComputeY( ng.ng_Height);\n\n" );
    } else {
        MyFPrintf( MainSource, "\t\tng.ng_TextAttr   = &%s%ld;\n", &fname[0], GuiInfo.gui_Font.ta_YSize );
        FPuts( MainSource, "\t\tng.ng_LeftEdge  += offx;\n\t\tng.ng_TopEdge   += offy;\n\n" );
    }

    skipTheShit:

    if ( CheckJoined()) {
        for( tmp = pw->pw_Gadgets.gl_First; tmp->en_Next; tmp = tmp->en_Next ) {
            if ( tmp->en_Kind == LISTVIEW_KIND && (( tmp->en_Flags & GDF_NEEDLOCK ) == GDF_NEEDLOCK )) {
                MyFPrintf( MainSource, "\t\tif (( ULONG )ng.ng_UserData == LISTVIEW_KIND ) {\n\t\t\tif ( tmp = FindTagItem( GTLV_ShowSelected, ( struct TagItem * )&%sGTags[ tc ] )) {\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
                MyFPrintf( MainSource, "\t\t\t\tif ( tmp->ti_Data ) tmp->ti_Data = (ULONG)g;\n\t\t\t}\n\t\t}\n\n", &pw->pw_Name[ 0 ] );
                break;
            } else if ( tmp->en_Kind == PALETTE_KIND )
                MyFPrintf( MainSource, "\t\tif (( ULONG )ng.ng_UserData == PALETTE_KIND )\n\t\t\tGTX_SetTagData( GTPA_Depth, Scr->BitMap.Depth, ( struct TagItem * )&%sGTags[  tc  ] );\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
        }
    }

    MyFPrintf( MainSource, "\t\tif ( ! LocDone[ %ld ] )\n"
                           "\t\t\tFixTags(( struct TagItem * )&%sGTags[ tc ], ( ULONG )ng.ng_UserData );\n\n", GTX_GetNodeNumber(( struct List * )&Windows, ( struct Node * )pw ), &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

    MyFPrintf( MainSource, "\t\t%sGadgets[ lc ] = g = GTX_CreateGadgetA( %sHandle, (ULONG)ng.ng_UserData, g, &ng, ( struct TagItem * )&%sGTags[ tc ] );\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

    if ( CheckGeneric()) {
        for ( tmp = pw->pw_Gadgets.gl_First; tmp->en_Next; tmp = tmp->en_Next ) {
            if ( tmp->en_Kind == GENERIC_KIND ) {
                FPuts( MainSource, "\t\tif (( ULONG )ng.ng_UserData == GENERIC_KIND ) {\n" );
                FPuts( MainSource, "\t\t\tg->Flags             |= GFLG_GADGIMAGE | GFLG_GADGHIMAGE;\n\t\t\tg->Activation        |= GACT_RELVERIFY;\n" );
                FPuts( MainSource, "\t\t\tg->GadgetRender       = (APTR)getImage;\n\t\t\tg->SelectRender       = (APTR)getImage;\n\t\t}\n\n" );
                break;
            }
        }
    }

    MyFPrintf( MainSource, "\t\twhile( %sGTags[ tc ] ) tc += 2;\n\t\ttc++;\n\n", &pw->pw_Name[ 0 ] );
    FPuts( MainSource, "\t\tif ( NOT g )\n\t\t\treturn( 2L );\n\t}\n\n" );
}

/*
 *      Generate OpenWindow routine header.
 */
Local VOID GenHeader( struct ProjectWindow *pw )
{
    struct ExtNewGadget *eng;

    MyFPrintf( Protos, "extern UWORD Open%sWindow( void );\n", &pw->pw_Name[ 0 ] );
    MyFPrintf( MainSource, "UWORD Open%sWindow( void )\n{\n", &pw->pw_Name[ 0 ] );

    FPuts( MainSource, "\tstruct NewGadget\tng;\n\tstruct Gadget\t*g;\n" );
    FPuts( MainSource, "\tstruct TagItem\t*tmp;\n" );
    FPuts( MainSource, "\tUWORD\t\tlc, tc;\n" );

    if ( SET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) {
        MyFPrintf( MainSource, "\tUWORD\t\twleft = %sLeft, wtop = %sTop, ww, wh;\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
        MyFPrintf( MainSource, "\tComputeFont( %sWidth, %sHeight );\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
        MyFPrintf( MainSource, "\tww = ComputeX( %sWidth );\n\twh = ComputeY( %sHeight );\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
        FPuts( MainSource, "\tif (( wleft + ww + OffX + Scr->WBorRight ) > Scr->Width ) wleft = Scr->Width - ww;\n"\
                     "\tif (( wtop + wh + OffY + Scr->WBorBottom ) > Scr->Height ) wtop = Scr->Height - wh;\n\n" );
        if ( SET( SourceConfig.gc_GenCFlags0, CS0_SYSFONT ))
            MyFPrintf( MainSource, "\tif ( ! ( %sFont = OpenFont( Font )))\n\t\treturn( 5L );\n\n", &pw->pw_Name[ 0 ] );
    } else {
        if ( SET( pw->pw_WindowFlags, WFLG_BACKDROP ))
            FPuts( MainSource, "\tUWORD\t\toffx = 0," );
        else
            FPuts( MainSource, "\tUWORD\t\toffx = Scr->WBorLeft," );
        FPuts( MainSource, " offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;\n\n" );
    }
}

/*
 *      Generate window.
 */
Local VOID GenWindow( struct ProjectWindow *pw )
{
    MyFPrintf( MainSource, "\tif ( ! ( %sWnd = OpenWindowTags( NULL,\n", &pw->pw_Name[ 0 ] );

    if ( NSET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) {
        MyFPrintf( MainSource, "\t\t\t\tWA_Left,\t%sLeft,\n", &pw->pw_Name[ 0 ] );
        MyFPrintf( MainSource, "\t\t\t\tWA_Top,\t\t%sTop,\n", &pw->pw_Name[ 0 ] );
    } else {
        FPuts( MainSource, "\t\t\t\tWA_Left,\twleft,\n" );
        FPuts( MainSource, "\t\t\t\tWA_Top,\t\twtop,\n" );
    }

    if ( NSET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) {

        if ( SET( pw->pw_TagFlags, WDF_INNERWIDTH )) FPuts( MainSource, "\t\t\t\tWA_InnerWidth,\t" );
        else                                         FPuts( MainSource, "\t\t\t\tWA_Width,\t" );

        MyFPrintf( MainSource, "%sWidth,\n", &pw->pw_Name[ 0 ] );

        if ( SET( pw->pw_TagFlags, WDF_INNERHEIGHT )) FPuts( MainSource, "\t\t\t\tWA_InnerHeight,\t" );
        else                                          FPuts( MainSource, "\t\t\t\tWA_Height,\t" );

        MyFPrintf( MainSource, "%sHeight", &pw->pw_Name[ 0 ] );

        if ( NSET( pw->pw_TagFlags, WDF_INNERHEIGHT )) FPuts( MainSource, " + offy" );
        FPuts( MainSource, ",\n" );

    } else {
        MyFPrintf( MainSource, "\t\t\t\tWA_Width,\tww + OffX + Scr->WBorRight,\n", &pw->pw_Name[ 0 ] );
        MyFPrintf( MainSource, "\t\t\t\tWA_Height,\twh + OffY + Scr->WBorBottom,\n", &pw->pw_Name[ 0 ] );
    }

    FPuts( MainSource, "\t\t\t\tWA_IDCMP,\t" );
    WriteIDCMPFlags( pw->pw_IDCMP|IDCMP_REFRESHWINDOW, &pw->pw_Gadgets );
    FPuts( MainSource, ",\n" );

    FPuts( MainSource, "\t\t\t\tWA_Flags,\t" );
    WriteWindowFlags( pw->pw_WindowFlags );
    FPuts( MainSource, ",\n" );

/****    if ( pw->pw_Gadgets.gl_First->en_Next )
        MyFPrintf( MainSource, "\t\t\t\tWA_Gadgets,\t%sGList,\n", &pw->pw_Name[ 0 ] ); ****/

    if ( NSET( pw->pw_WindowFlags, WFLG_BACKDROP ))
            MyFPrintf( MainSource, "\t\t\t\tWA_Title,\t%sWdt,\n", &pw->pw_Name[ 0 ] );

    if ( strlen( &pw->pw_ScreenTitle[ 0 ] ))
        MyFPrintf( MainSource, "\t\t\t\tWA_ScreenTitle,\tAppStrings[ MSG_STRING_%ld ].as_Str,\n", GetStringNumber( &Strings, &pw->pw_ScreenTitle[ 0 ] ));

    if ( SET( GuiInfo.gui_Flags0, GU0_CUSTOM ))
            FPuts( MainSource, "\t\t\t\tWA_CustomScreen,\tScr,\n" );
    else if ( SET( GuiInfo.gui_Flags0, GU0_PUBLIC ))
            FPuts( MainSource, "\t\t\t\tWA_PubScreen,\tScr,\n" );

    if ( SET( pw->pw_WindowFlags, WFLG_SIZEGADGET )) {
        if ( GTX_TagInArray( WA_MinWidth, pw->pw_Tags ))
            MyFPrintf( MainSource, "\t\t\t\tWA_MinWidth,\t%ld,\n", GetTagData( WA_MinWidth, NULL, pw->pw_Tags ));
        if ( GTX_TagInArray( WA_MinHeight, pw->pw_Tags ))
            MyFPrintf( MainSource, "\t\t\t\tWA_MinHeight,\t%ld,\n", GetTagData( WA_MinHeight, NULL, pw->pw_Tags ));
        if ( GTX_TagInArray( WA_MaxWidth, pw->pw_Tags ))
            MyFPrintf( MainSource, "\t\t\t\tWA_MaxWidth,\t%ld,\n", GetTagData( WA_MaxWidth, NULL, pw->pw_Tags ));
        if ( GTX_TagInArray( WA_MaxHeight, pw->pw_Tags ))
            MyFPrintf( MainSource, "\t\t\t\tWA_MaxHeight,\t%ld,\n", GetTagData( WA_MaxHeight, NULL, pw->pw_Tags ));
    } else {
        if ( SET( pw->pw_TagFlags, WDF_ZOOM ) || SET( pw->pw_TagFlags, WDF_DEFAULTZOOM ))
            MyFPrintf( MainSource, "\t\t\t\tWA_Zoom,\t%sZoom,\n", &pw->pw_Name[ 0 ] );
    }

    if ( SET( pw->pw_TagFlags, WDF_MOUSEQUEUE ))
        MyFPrintf( MainSource, "\t\t\t\tWA_MouseQueue,\t%ld,\n", pw->pw_MouseQueue);
    if ( SET( pw->pw_TagFlags, WDF_RPTQUEUE ))
        MyFPrintf( MainSource, "\t\t\t\tWA_RptQueue,\t%ld,\n", pw->pw_RptQueue );
    if ( SET( pw->pw_TagFlags, WDF_AUTOADJUST ))
        FPuts( MainSource, "\t\t\t\tWA_AutoAdjust,\tTRUE,\n" );
    if ( SET( pw->pw_TagFlags, WDF_FALLBACK ))
        FPuts( MainSource, "\t\t\t\tWA_PubScreenFallBack,\tTRUE,\n" );
    FPuts( MainSource, "\t\t\t\tWA_NewLookMenus,\tTRUE,\n" );
    FPuts( MainSource, "\t\t\t\tTAG_DONE )))\n\treturn( 4L );\n\n" );
}

/*
 *      Generate the cleanup stuff.
 */
Local VOID GenCleanup( struct ProjectWindow *pw )
{
    MyFPrintf( Protos, "extern VOID Close%sWindow( void );\n", &pw->pw_Name[ 0 ] );
    MyFPrintf( MainSource, "VOID Close%sWindow( void )\n{\n", &pw->pw_Name[ 0 ] );

    if ( pw->pw_Menus.ml_First->em_Next )
        MyFPrintf( MainSource, "\tif ( %sMenus      ) {\n\t\tClearMenuStrip( %sWnd );\n\t\tFreeMenus( %sMenus );\n\t\t%sMenus = NULL;\t}\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

    MyFPrintf( MainSource, "\tif ( %sWnd        ) {\n\t\tCloseWindow( %sWnd );\n\t\t%sWnd = NULL;\n\t}\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

    if ( pw->pw_Gadgets.gl_First->en_Next )
        MyFPrintf( MainSource, "\n\tif ( %sGList      ) {\n\t\tFreeGadgets( %sGList );\n\t\t%sGList = NULL;\n\t}\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

    if ( SET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) {
        if ( SET( SourceConfig.gc_GenCFlags0, CS0_SYSFONT ))
            MyFPrintf( MainSource, "\n\tif ( %sFont ) {\n\t\tCloseFont( %sFont );\n\t\t%sFont = NULL;\n\t}\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
    }

    MyFPrintf( MainSource, "\n\tif ( %sHandle ) {\n\t\tGTX_FreeHandle( %sHandle );\n\t\t%sHandle = NULL;\n\t}\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

    FPuts( MainSource, "}\n\n" );
}

/*
 *      Generate rendering routine.
 */
Local VOID GenRender( struct ProjectWindow *pw )
{
    struct BevelBox     *box;
    UWORD                offx, offy, bleft, btop;

    bleft = pw->pw_LeftBorder;
    btop  = pw->pw_TopBorder;

    offx = bleft;
    offy = btop;

    MyFPrintf( Protos, "extern VOID %sRender( void );\n", &pw->pw_Name[ 0 ] );
    MyFPrintf( MainSource, "VOID %sRender( void )\n{\n", &pw->pw_Name[ 0 ]  );

    if ( NSET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) {
        FPuts( MainSource, "\tUWORD\t\toffx, offy;\n\n" );
        if ( NSET( pw->pw_WindowFlags, WFLG_BACKDROP ))
            MyFPrintf( MainSource, "\toffx = %sWnd->BorderLeft;\n\toffy = %sWnd->BorderTop;\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
        else
            FPuts( MainSource, "\toffx = 0;\n\toffy = Scr->WBorTop + Scr->Font->ta_YSize + 1;\n\n" );

        if ( pw->pw_Boxes.bl_First->bb_Next ) {
            FPuts( MainSource, "\n" );
            for ( box = pw->pw_Boxes.bl_First; box->bb_Next; box = box->bb_Next ) {
                MyFPrintf( MainSource, "\tmyDrawBevelBox( %sWnd->RPort, offx + %ld, offy + %ld, %ld, %ld, GT_VisualInfo, VisualInfo, ",
                                 &pw->pw_Name[ 0 ], box->bb_Left - bleft, box->bb_Top - btop, box->bb_Width, box->bb_Height );
                if ( box->bb_Flags & BBF_RECESSED )
                    FPuts( MainSource, "GTBB_Recessed, TRUE, TAG_DONE );\n" );
                else
                    FPuts( MainSource, "TAG_DONE );\n" );
                if ( box->bb_Flags & BBF_DROPBOX ) {
                    MyFPrintf( MainSource, "\tmyDrawBevelBox( %sWnd->RPort, offx + %ld, offy + %ld, %ld, %ld, GT_VisualInfo, VisualInfo, GTBB_Recessed, TRUE, TAG_DONE );\n",
                                     &pw->pw_Name[ 0 ], box->bb_Left - bleft + 4, box->bb_Top - btop + 2, box->bb_Width - 8, box->bb_Height - 4 );
                }
            }
        }
        FPuts( MainSource, "}\n\n" );
    } else {
        MyFPrintf( MainSource, "\tComputeFont( %sWidth, %sHeight );\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
        if ( pw->pw_Boxes.bl_First->bb_Next ) {
            for ( box = pw->pw_Boxes.bl_First; box->bb_Next; box = box->bb_Next ) {
                MyFPrintf( MainSource, "\tmyDrawBevelBox( %sWnd->RPort, OffX + ComputeX( %ld ),\n"\
                                 "\t\t\t\t\tOffY + ComputeY( %ld ),\n"\
                                 "\t\t\t\t\tComputeX( %ld ),\n"\
                                 "\t\t\t\t\tComputeY( %ld ),\n"\
                                 "\t\t\t\t\tGT_VisualInfo, VisualInfo, ",
                    &pw->pw_Name[ 0 ], box->bb_Left - offx, box->bb_Top - offy, box->bb_Width, box->bb_Height );
                if ( box->bb_Flags & BBF_RECESSED )
                    FPuts( MainSource, "GTBB_Recessed, TRUE, TAG_DONE );\n" );
                else
                    FPuts( MainSource, "TAG_DONE );\n" );
                if ( box->bb_Flags & BBF_DROPBOX ) {
                    MyFPrintf( MainSource, "\tmyDrawBevelBox( %sWnd->RPort, OffX + ComputeX( %ld ),\n"\
                                     "\t\t\t\t\tOffY + ComputeY( %ld ),\n"\
                                     "\t\t\t\t\tComputeX( %ld ),\n"\
                                     "\t\t\t\t\tComputeY( %ld ),\n"\
                                     "\t\t\t\t\tGT_VisualInfo, VisualInfo, GTBB_Recessed, TRUE, TAG_DONE );\n",
                        &pw->pw_Name[ 0 ], box->bb_Left - offx + 4, box->bb_Top - offy + 2, box->bb_Width - 8, box->bb_Height - 4 );
                }
            }
        }
        FPuts( MainSource, "}\n\n" );
    }
}

/*
 *      Source Generation.
 */
VOID Generate( void )
{
    struct ProjectWindow            *pw;
    UBYTE                            fname[ 32 ], *ptr;

    strcpy( &fname[ 0 ], &GuiInfo.gui_FontName[ 0 ] );

    if ( ptr = strrchr( &fname[ 0 ], '.' ))
        *ptr = 0;

    Print( STRING( MSG_XREF_STRINGS ));

    if ( BuiltDuplicates()) {
        if ( OpenFiles()) {

            Print( STRING( MSG_GENERATING_SOURCE ));

            MyFPrintf( MainSource, MainHeader, &SourceConfig.gc_GTConfig.gtc_UserName[ 0 ] );
            MyFPrintf( Header,     MainHeader, &SourceConfig.gc_GTConfig.gtc_UserName[ 0 ] );
            MyFPrintf( Protos,     MainHeader, &SourceConfig.gc_GTConfig.gtc_UserName[ 0 ] );

            DoConditionals();

            GenID();
            GenGlobals();
            if ( NSET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT )) GenTextAttr();
            WriteStrings();
            GenMenus();
            GenGArrays();
            GenGTags();

            GenLocal();

            for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {

                if ( pw->pw_Boxes.bl_First->bb_Next )
                    GenRender( pw );

                GenHeader( pw );

                if ( strlen( &pw->pw_WindowTitle[ 0 ] ))
                    MyFPrintf( MainSource, "\t%sWdt = ( UBYTE * )AppStrings[ MSG_STRING_%ld ].as_Str;\n\n", &pw->pw_Name[ 0 ], GetStringNumber( &Strings, &pw->pw_WindowTitle[ 0 ] ));
                else
                    MyFPrintf( MainSource, "\t%sWdt = ( UBYTE * )NULL;\n\n", &pw->pw_Name[ 0 ] );

                MyFPrintf( MainSource, "\tif ( ! ( %sHandle = GTX_GetHandleA( &HandleTags[ 0 ] )))\n\t\treturn( 10L );\n\n", &pw->pw_Name[ 0 ] );

                if ( pw->pw_Gadgets.gl_First->en_Next ) {
                    MyFPrintf( MainSource, "\tif ( ! ( g = CreateContext( &%sGList )))\n\t\treturn( 1L );\n\n", &pw->pw_Name[ 0 ] );
                    GenGadgetInit( pw );
                }

                if ( pw->pw_Menus.ml_First->em_Next ) {
                    MyFPrintf( MainSource, "\tif ( ! LocDone[ %ld ] )\n\t\tFixMenus( %sNewMenu );\n\n", GTX_GetNodeNumber(( struct List * )&Windows, ( struct Node * )pw ), &pw->pw_Name[ 0 ] );
                    MyFPrintf( MainSource, "\tif ( ! ( %sMenus = CreateMenus( %sNewMenu, TAG_DONE )))\n\t\treturn( 3L );\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
                    MyFPrintf( MainSource, "\tLayoutMenus( %sMenus, VisualInfo, GTMN_NewLookMenus, TRUE, ", &pw->pw_Name[ 0 ] );
                    if ( NSET( SourceConfig.gc_GTConfig.gtc_ConfigFlags0, GC0_FONTADAPT ))
                        MyFPrintf( MainSource, "GTMN_TextAttr, &%s%ld, TAG_DONE );\n\n", fname, GuiInfo.gui_Font.ta_YSize );
                    else
                        MyFPrintf( MainSource, "TAG_DONE );\n\n" );
                }

                MyFPrintf( MainSource, "\tLocDone[ %ld ] = TRUE;\n\n", GTX_GetNodeNumber(( struct List * )&Windows, ( struct Node * )pw ));

                if ( NSET( pw->pw_WindowFlags, WFLG_SIZEGADGET )) {
                    if ( SET( pw->pw_TagFlags, WDF_ZOOM )) {
                        MyFPrintf( MainSource, "\t%sZoom[0] = %sLeft;\n\t%sZoom[1] = %sTop;\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ],  &pw->pw_Name[ 0 ] );
                        goto rZoom;
                    } else if ( SET( pw->pw_TagFlags, WDF_DEFAULTZOOM )) {
                        MyFPrintf( MainSource, "\t\t%sZoom[0] = %sZoom[1] = 0;\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
                        rZoom:
                        MyFPrintf( MainSource, "\tif ( %sWdt )\n", &pw->pw_Name[ 0 ] );
                        MyFPrintf( MainSource, "\t\t%sZoom[2] = TextLength( &Scr->RastPort, (UBYTE *)%sWdt, strlen((char *)%sWdt )) + 80;\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );
                        MyFPrintf( MainSource, "\telse\n\t\t%sZoom[2]  = 80L;\n", &pw->pw_Name[ 0 ] );
                        MyFPrintf( MainSource, "\t\t%sZoom[3] = Scr->WBorTop + Scr->RastPort.TxHeight + 1;\n\n", &pw->pw_Name[ 0 ] );
                    }
                }

                GenWindow( pw );

                if ( pw->pw_Menus.ml_First->em_Next )
                    MyFPrintf( MainSource, "\tSetMenuStrip( %sWnd, %sMenus );\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

                MyFPrintf( MainSource, "\tBackFill( %sWnd );\n\n", &pw->pw_Name[ 0 ] );

                if ( pw->pw_Boxes.bl_First->bb_Next )
                    MyFPrintf( MainSource, "\t%sRender();\n\n", &pw->pw_Name[ 0 ] );

                if ( pw->pw_Gadgets.gl_First->en_Next )
                    MyFPrintf( MainSource, "\tAddGList( %sWnd, %sGList, -1, -1, NULL );\n\tRefreshGList( %sGList, %sWnd, NULL, -1 );\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

                MyFPrintf( MainSource, "\tGTX_RefreshWindow( %sHandle, %sWnd, NULL );\n\n", &pw->pw_Name[ 0 ], &pw->pw_Name[ 0 ] );

                FPuts( MainSource, "\treturn( 0 );\n}\n\n" );

                GenCleanup( pw );
            }

            FPuts( Header, "#endif" );
            FPuts( Protos, "#endif" );

            GenCD();
        } else
            Print( STRING( MSG_SOURCE_FILE_ERROR ));
        CloseFiles();
    }
    RunCatComp();
}
