/*
**      $VER: Short demo of the AppIconClass 1.0 (28.6.95) Doguet Emmanuel
**
**/

#include <proto/exec.h>
#include <proto/alib.h>
#include <proto/intuition.h>
#include <Boopsi/AppIconClass.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>

#include <stdio.h>

#ifdef _DCC
#include <lib/misc.h>
#endif

int main( int argc, char **argv )
{
Class   *AppIconClass;
Object  *MyIcon;
ULONG   WaitMask;
BOOL    running=TRUE;
int i;
struct  AppMessage  *AppMsg;
struct  WBArg       *wa;

    /*
    **  Init. the class
    **/
    if( !(AppIconClass=InitAppIconClass()) )
    {
        printf("Can't init the AppIconClass\n");
        return(30);
    }

    /*
    **  Create the object
    **/
    MyIcon=NewObject( AppIconClass, NULL, GA_ID, 0, AIC_AppName, "TinyTest Dock", AIC_IconFileName, argv[0], TAG_END );

    if( MyIcon )
    {
        GetAttr( AIC_AppIconMask, MyIcon, &WaitMask );

        do{
            Wait( WaitMask );


            while( (AppMsg=(struct AppMessage *)DoMethod( MyIcon, GM_HANDLEINPUT )) )
            {
                // If Icon clicked, end of program
                if( APP_CLICKED(AppMsg) )
                    running=FALSE;
                else
                // We scan all the entries
                for(i=0, wa=AppMsg->am_ArgList; i<APP_NUMARGS(AppMsg); i++, wa++ )
                {
                    if( APP_IS_DIR( wa ) )
                        printf("You put a dir/volume on my AppIcon ;-)\n");
                    else
                    if( APP_IS_FILE( wa ) )
                        printf("You put a file on my AppIcon ;-)\n");
                    else
                        printf("You put somethink like an AppIcon on my AppIcon ?? :-(\n");
                }
                ReplyMsg( (struct Message *)AppMsg );
            }

        }while( running );
    }
    else
        printf("Can't create the object :-(((\n");

    if( MyIcon )
        DisposeObject( MyIcon );

    if( AppIconClass )
        FreeAppIconClass( AppIconClass );

    return(0);
}


#ifdef _DCC
int wbmain( struct WBStartup *w )
{
    OpenConsole("CON:0/400//50/TinyTest ouput");
    return( main(1, &(w->sm_ArgList->wa_Name)) );
}
#endif
