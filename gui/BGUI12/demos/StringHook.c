;/* Execute me to compile with DICE V3.0
dcc stringhook.c -proto -mi -ms -mRR -lbgui
quit
*/
/*
 *      STRINGHOOK.C
 *
 *      (C) Copyright 1995 Jaba Development.
 *      (C) Copyright 1995 Jan van den Baard.
 *          All Rights Reserved.
 */

#include "democode.h"

#include <ctype.h>

/*
**      Object ID's.
**/
#define ID_QUIT                 1

/*
**      Info text.
**/
UBYTE  *WinInfo = ISEQ_C "This demo shows you how to include a\n"
                  "string object edit hook. The string object\n"
                  "has a edit hook installed which only allows\n"
                  "you to enter hexadecimal characters. It will\n"
                  "also convert the character you click on to 0.";

/*
**      String object edit hook. Copied from the
**      RKM-Manual Libraries. Page 162-166.
**/
SAVEDS ASM HexHookFunc( REG(a0) struct Hook *hook, REG(a2) struct SGWork *sgw, REG(a1) ULONG *msg )
{
        ULONG           rc = ~0;

        switch ( *msg ) {

                case    SGH_KEY:
                        /*
                        **      Only allow for hexadecimal characters and convert
                        **      lowercase to uppercase.
                        **/
                        if ( sgw->EditOp == EO_REPLACECHAR || sgw->EditOp == EO_INSERTCHAR ) {
                                if ( ! isxdigit( sgw->Code )) {
                                        sgw->Actions |= SGA_BEEP;
                                        sgw->Actions &= ~SGA_USE;
                                } else {
                                        sgw->WorkBuffer[ sgw->BufferPos - 1 ] = toupper( sgw->Code );
                                }
                        }
                        break;

                case    SGH_CLICK:
                        /*
                        **      Convert the character under the
                        **      cursor to 0.
                        **/
                        if ( sgw->BufferPos < sgw->NumChars )
                                sgw->WorkBuffer[ sgw->BufferPos ] = '0';
                        break;

                default:
                        rc = 0L;
                        break;
        }
        return( rc );
}

/*
**      Uncomment the below typedef if your compiler
**      complains about it.
**/

/* typedef ULONG (*HOOKFUNC)(); */

struct Hook HexHook = { NULL, NULL, (HOOKFUNC)HexHookFunc, NULL, NULL };

VOID StartDemo( void )
{
        struct Window           *window;
        Object                  *WO_Window, *GO_Quit;
        ULONG                    signal, rc;
        BOOL                     running = TRUE;

        /*
        **      Create the window object.
        **/
        WO_Window = WindowObject,
                WINDOW_Title,           "String Edit Hook Demo",
                WINDOW_AutoAspect,      TRUE,
                WINDOW_LockHeight,      TRUE,
                WINDOW_RMBTrap,         TRUE,
                WINDOW_MasterGroup,
                        VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BackFill, SHINE_RASTER,
                                StartMember,
                                        InfoFixed( NULL, WinInfo, NULL, 5 ),
                                EndMember,
                                StartMember,
                                        HGroupObject, HOffset( 4 ), VOffset( 4 ), FRM_Type, FRTYPE_BUTTON, FRM_Recessed, TRUE,
                                                StartMember,
                                                        StringObject,
                                                                LAB_Label,              "Only HEX characters:",
                                                                LAB_Style,              FSF_BOLD,
                                                                RidgeFrame,
                                                                STRINGA_MaxChars,       256,
                                                                STRINGA_EditHook,       &HexHook,
                                                        EndObject,
                                                EndMember,
                                        EndObject,
                                EndMember,
                                StartMember,
                                        HGroupObject,
                                                VarSpace( 50 ),
                                                StartMember, GO_Quit  = KeyButton( "_Quit",  ID_QUIT  ), EndMember,
                                                VarSpace( 50 ),
                                        EndObject, FixMinHeight,
                                EndMember,
                        EndObject,
        EndObject;

        /*
        **      Object created OK?
        **/
        if ( WO_Window ) {
                /*
                **      Assign the key to the button.
                **/
                if ( GadgetKey( WO_Window, GO_Quit,  "q" )) {
                        /*
                        **      try to open the window.
                        **/
                        if ( window = WindowOpen( WO_Window )) {
                                /*
                                **      Obtain it's wait mask.
                                **/
                                GetAttr( WINDOW_SigMask, WO_Window, &signal );
                                /*
                                **      Event loop...
                                **/
                                do {
                                        Wait( signal );
                                        /*
                                        **      Handle events.
                                        **/
                                        while (( rc = HandleEvent( WO_Window )) != WMHI_NOMORE ) {
                                                /*
                                                **      Evaluate return code.
                                                **/
                                                switch ( rc ) {

                                                        case    WMHI_CLOSEWINDOW:
                                                        case    ID_QUIT:
                                                                running = FALSE;
                                                                break;
                                                }
                                        }
                                } while ( running );
                        } else
                                Tell( "Could not open the window\n" );
                } else
                        Tell( "Could not assign gadget keys\n" );
                /*
                **      Disposing of the window object will
                **      also close the window if it is
                **      already opened and it will dispose of
                **      all objects attached to it.
                **/
                DisposeObject( WO_Window );
        } else
                Tell( "Could not create the window object\n" );
}
