#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/bgui.h>
#include <proto/intuition.h>
#include <proto/dos.h>

#include <stdio.h>
#include <string.h>

#include <Boopsi/AppIconClass.h>


struct Library *BGUIBase;

/*
**  Class base
**/
Class       *AppIconClass;


int main( int argc, char *argv[] )
{
struct Window   *window;
Object          *WO_Window;
ULONG           Sig, WindowMask=0, AppIconMask;
BOOL            running=TRUE;
int             rc, i;
struct          AppMessage  *Mess;
struct          WBArg       *wa;

Object          *AO_Icon, *AO_Icon2;
char            *ProgName;

#ifndef _DCC
    if( !argc )
        ProgName=((struct WBStartup *)argv) -> sm_ArgList -> wa_Name;
    else
#endif
        ProgName = argv[0];

    /*
    **  Open the bgui.library
    **/
    if( !( BGUIBase = OpenLibrary( "bgui.library", 39L )) )
    {
        printf("Can't open bgui.library v39\n");
        return(30);
    }

    /*
    **  Init. the AppIconClass
    **/
    if( !(AppIconClass=InitAppIconClass() ))
    {
        printf("Impossible d'initialiser la class\n");
        return(1);
    }

    /*
    **  Creare object.
    **/
    AO_Icon=NewObject( AppIconClass, NULL, GA_ID, 22, /*AIC_AppName, "TOTO",*/ AIC_IconFileName, ProgName, AIC_AppIconX, 250, AIC_AppIconY, 100,TAG_END );

    AO_Icon2=NewObject( AppIconClass, NULL, GA_ID, 23, AIC_AppName, "TOTO 2", AIC_IconFileName, ProgName, AIC_AppMenuItem, TRUE, TAG_END );

    if( !AO_Icon )   printf("NewObject 1 failed!\n");
    if( !AO_Icon2 )  printf("NewObject 2 failed!\n");

    /*
    **  Create window.
    **/
    WO_Window=WindowObject,
            WINDOW_Title,   "AppIcon test",
            WINDOW_RMBTrap, TRUE,
            WINDOW_AutoAspect,  TRUE,
            WINDOW_MasterGroup,
            VGroupObject,
                StartMember, Button("End of test", 0), EndMember,
            EndObject,
            EndObject;
    if(!WO_Window)  return(20);


    window=WindowOpen( WO_Window );


    GetAttr( WINDOW_SigMask, WO_Window, &WindowMask );
    GetAttr( AIC_AppIconMask, AO_Icon, &AppIconMask );

    /*
    **
    **/
    do{
        Sig=Wait( WindowMask | AppIconMask );

        if(Sig&AppIconMask )
        {
            while( (Mess=(struct AppMessage *)DoMethod( AO_Icon, GM_HANDLEINPUT )) )
            {
                if( !Mess->am_NumArgs )
                    printf(" ** Double Click !\n");
                else
                {
                    for(i=0, wa=Mess->am_ArgList; i<Mess->am_NumArgs; i++, wa++ )
                        printf(" ** Receive: '%s'\n", wa->wa_Name );
                }

                ReplyMsg( (struct Message *)Mess );
            }
        }

        /*
        ** Signal en provenance de la fenêtre ?
        **/
        if(Sig&WindowMask)
            while( (rc=HandleEvent( WO_Window ) )!= WMHI_NOMORE )
            {
                switch (rc ) {
                    case 0:
                    case WMHI_CLOSEWINDOW:  running=FALSE;
                                            break;
                }
            }

    }while( running );

    /*
    **  Dispose object
    **/
    if( AO_Icon )DisposeObject( AO_Icon );
    if( AO_Icon2 ) DisposeObject( AO_Icon2 );

    if( WO_Window ) DisposeObject( WO_Window );


    /*
    **  Dispose class.
    **/
    FreeAppIconClass(AppIconClass);

    /*
    **  Close bgui.library
    **/
    CloseLibrary( BGUIBase );

    return( 0 );
}

#ifdef _DCC
int wbmain( struct WBStartup *w )
{
    return(main(1, &(w->sm_ArgList->wa_Name) ));
}
#endif
