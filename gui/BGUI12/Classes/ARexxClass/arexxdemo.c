;/* Execute me to compile with DICE V3.0
dcc arexxdemo.c -proto -mi -ms -lbgui -larexxclass.o
quit
*/
/*
**             File: arexxdemo.c
**      Description: Simple demonstration of the arexx class.
**        Copyright: (C) Copyright 1994-1995 Jaba Development.
**                   (C) Copyright 1994-1995 Jan van den Baard.
**                   All Rights Reserved.
**/

#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>
#include <libraries/gadtools.h>

#include <dos/dos.h>
#include <dos/datetime.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/bgui.h>
#include <proto/intuition.h>
#include <proto/dos.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "arexxclass.h"

/*
**      ARexx class base variable.
**/
Class                           *ARexxClass;

/*
**      Protos for the arexx command functions.
**/
VOID rx_Name( REXXARGS *, struct RexxMsg * );
VOID rx_Version( REXXARGS *, struct RexxMsg * );
VOID rx_Author( REXXARGS *, struct RexxMsg * );
VOID rx_Date( REXXARGS *, struct RexxMsg * );

/*
**      The following commands are
**      valid for this demo.
**/
REXXCOMMAND Commands[] = {
        "NAME",                 NULL,                   rx_Name,
        "VERSION",              NULL,                   rx_Version,
        "AUTHOR",               NULL,                   rx_Author,
        "DATE",                 "SYSTEM/S",             rx_Date,
};

/*
**      NAME
**/
VOID rx_Name( REXXARGS *ra, struct RexxMsg *rxm )
{
        /*
        **      Simply return the program name.
        **/
        ra->ra_Result = "ARexxDemo";
}

/*
**      VERSION
**/
VOID rx_Version( REXXARGS *ra, struct RexxMsg *rxm )
{
        /*
        **      Simply return the program version.
        **/
        ra->ra_Result = "1.0";
}

/*
**      AUTHOR
**/
VOID rx_Author( REXXARGS *ra, struct RexxMsg *rxm )
{
        /*
        **      Simply return the authors name.
        **/
        ra->ra_Result = "Jan van den Baard";
}

/*
**      Buffer for the system date.
**/
UBYTE                   systemDate[ 10 ];

/*
**      DATE
**/
VOID rx_Date( REXXARGS *ra, struct RexxMsg *rxm )
{
        struct DateTime                 dt;

        /*
        **      SYSTEM switch specified?
        **/
        if ( ! ra->ra_ArgList[ 0 ] )
                /*
                **      No. Simply return the compilation date.
                **/
                ra->ra_Result = "25-09-94";
        else {
                /*
                **      Compute system date.
                **/
                DateStamp(( struct DateStamp * )&dt );
                dt.dat_Format  = FORMAT_CDN;
                dt.dat_StrDate = systemDate;
                dt.dat_Flags   = 0;
                dt.dat_StrDay  = NULL;
                dt.dat_StrTime = NULL;
                DateToStr(&dt);
                /*
                **      And return it.
                **/
                ra->ra_Result = systemDate;
        }
}

/*
**      Object ID's.
**/
#define ID_QUIT                 1

int main( int argc, char *argv[] )
{
        struct Window           *window;
        Object                  *WO_Window, *GO_Quit, *AO_Rexx;
        ULONG                    signal = 0, rxsig = 0L, rc, sigrec;
        BOOL                     running = TRUE;

        /*
        **      Initialize the ARexxClass.
        **/
        if ( ARexxClass = InitARexxClass()) {
                /*
                **      Create host object.
                **/
                if ( AO_Rexx = NewObject( ARexxClass, NULL, AC_HostName, "RXDEMO", AC_CommandList, Commands, TAG_END )) {
                        /*
                        **      Create the window object.
                        **/
                        WO_Window = WindowObject,
                                WINDOW_Title,           "ARexx Demo",
                                WINDOW_SizeGadget,      FALSE,
                                WINDOW_RMBTrap,         TRUE,
                                WINDOW_AutoAspect,      TRUE,
                                WINDOW_MasterGroup,
                                        VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BackFill, SHINE_RASTER,
                                                StartMember,
                                                        InfoFixed( NULL,
                                                                   ISEQ_C "This is a small demonstration of\n"
                                                                   "the ARexx BOOPSI class. Please run the\n"
                                                                   ISEQ_B "Demo.rexx" ISEQ_N " script and see\n"
                                                                   "what happens",
                                                                   NULL,
                                                                   4 ),
                                                EndMember,
                                                StartMember,
                                                        HGroupObject,
                                                                VarSpace( 50 ),
                                                                StartMember, GO_Quit  = KeyButton( "_Quit",  ID_QUIT  ), EndMember,
                                                                VarSpace( 50 ),
                                                        EndObject,
                                                EndMember,
                                        EndObject,
                        EndObject;

                        /*
                        **      Object created OK?
                        **/
                        if ( WO_Window ) {
                                /*
                                **      Assign a key to the button.
                                **/
                                if ( GadgetKey( WO_Window, GO_Quit,  "q" )) {
                                        /*
                                        **      try to open the window.
                                        **/
                                        if ( window = WindowOpen( WO_Window )) {
                                                /*
                                                **      Obtain wait masks.
                                                **/
                                                GetAttr( WINDOW_SigMask, WO_Window, &signal );
                                                GetAttr( AC_RexxPortMask, AO_Rexx, &rxsig );
                                                /*
                                                **      Event loop...
                                                **/
                                                do {
                                                        sigrec = Wait( signal | rxsig );

                                                        /*
                                                        **      ARexx event?
                                                        **/
                                                        if ( sigrec & rxsig )
                                                                DoMethod( AO_Rexx, ACM_HANDLE_EVENT );

                                                        /*
                                                        **      Window event?
                                                        **/
                                                        if ( sigrec & signal ) {
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
                                                        }
                                                } while ( running );
                                        } else
                                                puts ( "Could not open the window" );
                                } else
                                        puts( "Could not assign gadget keys" );
                                DisposeObject( WO_Window );
                        } else
                                puts( "Could not create the window object" );
                        DisposeObject( AO_Rexx );
                } else
                        puts( "Could not create the ARexx host." );
                FreeARexxClass( ARexxClass );
        } else
                puts( "Unable to setup the arexx class" );

        return( 0 );
}

#ifdef _DCC
int wbmain( struct WBStartup *wbs )
{
        return( main( 0, NULL ));
}
#endif

/*
 *      $Log: arexxdemo.c,v $
 * Revision 1.1  1994/09/25  14:31:28  jaba
 * Initial revision
 *
 */
