/*
**      $Filename: DupStrings.c $
**      $Release: 1.0 $
**      $Revision: 38.1 $
**
**      Get all strings from the file into a seperate list
**      filtering out all double strings.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard.
**/

#include "GenGTXSource.h"

Prototype BOOL BuiltDuplicates( void );
Prototype VOID FreeDuplicates( void );
Prototype UWORD GetStringNumber( struct StringList *, UBYTE * );
Prototype UWORD GetArrayNumber( struct ArrayList *, UBYTE ** );
Prototype UWORD CountArray( UBYTE ** );

/*
 *      Count the number of strings in an array.
 */
UWORD CountArray( UBYTE **array )
{
    UWORD       i = 0;

    while ( array[ i ] ) i++;

    return( i - 1 );
}

/*
 *      Compare two string arrays.
 */
BOOL CompareArrays( UBYTE **array1, UBYTE **array2 )
{
    UWORD           ac1, ac2, i;

    ac1 = CountArray( array1 );
    ac2 = CountArray( array2 );

    if ( ac1 != ac2 ) return( FALSE );

    for ( i = 0; i < ac1; i++ ) {
        if ( strcmp( array1[ i ], array2[ i ] ))
            return( FALSE );
    }

    return( TRUE );
}

/*
 *      Find a string.
 */
struct StringNode *FindString( struct StringList *list, UBYTE *string )
{
    struct StringNode       *sn;

    for ( sn = list->sl_First; sn->sn_Next; sn = sn->sn_Next ) {
        if ( ! strcmp( sn->sn_String, string ))
            return( sn );
    }
    return( NULL );
}

/*
 *      Find an array.
 */
struct ArrayNode *FindArray( struct ArrayList *list, UBYTE **array )
{
    struct ArrayNode        *an;

    for ( an = list->al_First; an->an_Next; an = an->an_Next ) {
        if ( CompareArrays( an->an_Array, array ))
            return( an );
    }
    return( NULL );
}

/*
 *      Add a string.
 */
BOOL AddString( struct StringList *list, UBYTE *string )
{
    struct StringNode       *sn;

    if ( string == ( UBYTE * )NM_BARLABEL )
        return( TRUE );

    if ( ! FindString( list, string )) {
        if ( sn = ( struct StringNode * )AllocVecItem( Chain, sizeof( struct StringNode ), MEMF_PUBLIC )) {
            sn->sn_String = string;
            AddTail(( struct List * )list, ( struct Node * )sn );
            return( TRUE );
        }
    } else
        return( TRUE );
    return( FALSE );
}

/*
 *      Add an array.
 */
BOOL AddArray( struct ArrayList *list, UBYTE **array )
{
    struct ArrayNode        *an;

    if ( ! FindArray( list, array )) {
        if ( an = ( struct ArrayNode * )AllocVecItem( Chain, sizeof( struct ArrayNode ), MEMF_PUBLIC )) {
            an->an_Array = array;
            AddTail(( struct List * )list, ( struct Node * )an );
            while ( *array ) {
                if ( ! AddString( &Strings, *array ))
                    return( FALSE );
                array++;
            }
            return( TRUE );
        }
    } else
        return( TRUE );
    return( FALSE );
}

/*
 *      Get the ordinal string number.
 */
UWORD GetStringNumber( struct StringList *list, UBYTE *string )
{
    struct StringNode       *sn;

    sn = FindString( list, string );

    return( sn->sn_Number );
}

/*
 *      Get the ordinal array number.
 */
UWORD GetArrayNumber( struct ArrayList *list, UBYTE **array )
{
    struct ArrayNode        *an;

    an = FindArray( list, array );

    return( an->an_Number );
}

/*
 *      Number the duplicates.
 */
Local VOID NumberDuplicates( void )
{
    struct StringNode       *sn;
    struct ArrayNode        *an;
    UWORD                    num;

    for ( sn = Strings.sl_First, num = 0; sn->sn_Next; sn = sn->sn_Next, num++ )
        sn->sn_Number = num;

    for ( an = Arrays.al_First, num = 0; an->an_Next; an = an->an_Next, num++ )
        an->an_Number = num;
}

/*
 *      Built the string and array list.
 */
BOOL BuiltDuplicates( void )
{
    struct ProjectWindow            *pw;
    struct IntuiText                *it;
    struct ExtNewGadget             *eng;
    struct ExtNewMenu               *menu, *item, *sub;
    UBYTE                          **array, *string;

   /*
    *   First of all add the screen title to the string list.
    */
    if ( ! AddString( &Strings, &GuiInfo.gui_ScreenTitle[ 0 ] ))
        goto memoryError;

    for ( pw = Windows.wl_First; pw->pw_Next; pw = pw->pw_Next ) {
       /*
        *   Add the Window title to the string list.
        */
        if ( strlen( &pw->pw_WindowTitle[ 0 ] )) {
            if ( ! AddString( &Strings, &pw->pw_WindowTitle[ 0 ] ))
                goto memoryError;
        }

       /*
        *   Add the Window Screen title to the string list.
        */
        if ( strlen( &pw->pw_ScreenTitle[ 0 ] )) {
            if ( ! AddString( &Strings, &pw->pw_ScreenTitle[ 0 ] ))
                goto memoryError;
        }

       /*
        *   Add the IntuiTexts to the string list.
        */
        if ( it = pw->pw_WindowText ) {
            while ( it ) {
                if ( ! AddString( &Strings, it->IText ))
                    goto memoryError;
                it = it->NextText;
            }
        }

       /*
        *   Add the Gadget texts to the string list and
        *   the MX or CYCLE arrays to the array list.
        */
        for ( eng = pw->pw_Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
            if ( strlen( &eng->en_GadgetText[ 0 ] )) {
                if ( ! AddString( &Strings, &eng->en_GadgetText[ 0 ] ))
                    goto memoryError;
            }

            switch ( eng->en_Kind ) {
                case    MX_KIND:
                    if ( array = ( UBYTE ** )GetTagData( GTMX_Labels, NULL, eng->en_Tags )) {
                        if ( ! AddArray( &Arrays, array ))
                            goto memoryError;
                    }
                    break;
                case    CYCLE_KIND:
                    if ( array = ( UBYTE ** )GetTagData( GTCY_Labels, NULL, eng->en_Tags )) {
                        if ( ! AddArray( &Arrays, array ))
                            goto memoryError;
                    }
                    break;
                case    STRING_KIND:
                    if ( string = ( UBYTE * )GetTagData( GTST_String, NULL, eng->en_Tags )) {
                        if ( ! AddString( &Strings, string ))
                            goto memoryError;
                    }
                    break;
                case    TEXT_KIND:
                    if ( string = ( UBYTE * )GetTagData( GTTX_Text, NULL, eng->en_Tags )) {
                        if ( ! AddString( &Strings, string ))
                            goto memoryError;
                    }
                    break;
                case    SLIDER_KIND:
                    if ( string = ( UBYTE * )GetTagData( GTSL_LevelFormat, NULL, eng->en_Tags )) {
                        if ( ! AddString( &Strings, string ))
                            goto memoryError;
                    }
                    break;
            }
        }

       /*
        * Add the menu, item and subitem titles and CommKey's to the string list.
        */
        for ( menu = pw->pw_Menus.ml_First; menu->em_Next; menu = menu->em_Next ) {
            if ( ! AddString( &Strings, &menu->em_MenuTitle[ 0 ] ))
                goto memoryError;
            for ( item = menu->em_Items->ml_First; item->em_Next; item = item->em_Next ) {
                if ( ! AddString( &Strings, &item->em_MenuTitle[ 0 ] ))
                    goto memoryError;
                if ( strlen( &item->em_CommKey[ 0 ] )) {
                    if ( ! AddString( &Strings, &item->em_CommKey[ 0 ] ))
                        goto memoryError;
                }
                for ( sub = item->em_Items->ml_First; sub->em_Next; sub = sub->em_Next ) {
                    if ( ! AddString( &Strings, &sub->em_MenuTitle[ 0 ] ))
                        goto memoryError;
                    if ( strlen( &sub->em_CommKey[ 0 ] )) {
                        if ( ! AddString( &Strings, &sub->em_CommKey[ 0 ] ))
                            goto memoryError;
                    }
                }
            }
        }
    }
    NumberDuplicates();
    return( TRUE );

    memoryError:
    Print( STRING( MSG_OUT_OF_MEMORY ));
    return( FALSE );
}

/*
 *      Free up the duplicates.
 */
VOID FreeDuplicates( void )
{
    struct Node         *node;

    while ( node = RemHead(( struct List * )&Strings ))
        FreeVecItem( Chain, node );

    while ( node = RemHead(( struct List * )&Arrays ))
        FreeVecItem( Chain, node );
}
