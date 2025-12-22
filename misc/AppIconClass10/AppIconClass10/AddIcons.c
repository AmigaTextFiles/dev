/*
**
**  $VER: AppIconClass Demo 1.0 (28.6.95) Doguet Emmanuel
**
**/

#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>
#include <libraries/gadtools.h>
#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/bgui_protos.h>
#include <clib/intuition_protos.h>
#include <clib/icon_protos.h>
#include <clib/wb_protos.h>
#include <workbench/startup.h>

#include <stdio.h>
#include <stdlib.h>

#include <Boopsi/AppIconClass.h>

#ifdef _DCC
#include <lib/misc.h>
#endif

#define ID_ADD      0
#define ID_REM      1
#define ID_QUIT     2

/*
**      Library base pointer.
**      NOTE: The intuition.library is opened by DICE
**      it's auto-init code.
**/
struct Library          *BGUIBase;

int main( int argc, char *argv[] )
{
struct Window           *window;
Object                  *WO_Window, *GO_Add, *GO_Quit, *GO_Rem, *addobj[20];
ULONG                    signal = 0, rc, tmp = 0;
BOOL                     running = TRUE, ok = FALSE;
int                      x = 0, xx;

Class                    *MasterClass;

    if ( BGUIBase = OpenLibrary( BGUINAME, BGUIVERSION ))
    {

        // Window definition
        WO_Window = WindowObject,
        WINDOW_Title,             "AppIcon demo",
        WINDOW_RMBTrap,           TRUE,
        WINDOW_SizeGadget,      TRUE,
        WINDOW_MasterGroup,
            HGroupObject,
                StartMember, GO_Add  = XenKeyButton( "_Add", ID_ADD ), EndMember,
                StartMember, GO_Rem  = XenKeyButton( "_Remove all", ID_REM ), EndMember,
                StartMember, GO_Quit = XenKeyButton( "_Quit",  ID_QUIT  ), EndMember,
            EndObject,
        EndObject;

        // Initialise the class
        if( MasterClass=InitAppIconClass() )
        {
            if ( WO_Window )
            {
                tmp += GadgetKey( WO_Window, GO_Add, "a" );
                tmp += GadgetKey( WO_Window, GO_Quit,  "q" );
                tmp += GadgetKey( WO_Window, GO_Rem,  "r" );

                if ( tmp == 3 )
                {
                    if ( window = WindowOpen( WO_Window ))
                    {
                        GetAttr( WINDOW_SigMask, WO_Window, &signal );
                        do
                        {
                            Wait( signal );
                            while (( rc = HandleEvent( WO_Window )) != WMHI_NOMORE )
                            {
                                switch ( rc )
                                {
                                    case  WMHI_CLOSEWINDOW:
                                    case  ID_QUIT:      if (x>0)
                                                        {
                                                            for (xx=0;xx<x;xx++)
                                                                DisposeObject( addobj[xx] );
                                                            x=0;
                                                        }
                                                        running = FALSE;
                                                        break;

                                    case  ID_ADD:       if(x<20)
                                                        {
                                                            addobj[x]  =
                                                            NewObject( MasterClass, NULL, GA_ID, x, AIC_AppName, "Added", AIC_IconFileName, argv[0], TAG_END );
                                                            if( addobj[x] )
                                                                x++;
                                                            else
                                                                printf("Erreur NeWOvjec\n");
                                                        }
                                                       break;

                                    case  ID_REM:       if (x>0)
                                                        {
                                                            for (xx=0;xx<x;xx++)
                                                                DisposeObject( addobj[xx] );
                                                            x=0;
                                                        }
                                                        else
                                                            printf("There's not AppIcon!\n");
                                                        break;
                                }
                            }
                        }
                        while ( running );
                    }
                    else
                        puts ( "Could not open the window" );
                }
                else
                    puts( "Could not assign gadget keys" );

                DisposeObject( WO_Window );

                FreeAppIconClass( MasterClass );
            }
            else
                puts( "Could not create the window object" );

        }
        else    puts("Could not init. the AppIcon Class");

        CloseLibrary( BGUIBase );
    }
    else
        puts( "Unable to open the bgui.library" );

   return( 0 );
}


#ifdef _DCC
int wbmain( struct WBStartup *wbs )
{
    OpenConsole("CON:0/400//50/AddIcons Output");
    return( main( 1, &(wbs->sm_ArgList->wa_Name) ));
}
#endif

