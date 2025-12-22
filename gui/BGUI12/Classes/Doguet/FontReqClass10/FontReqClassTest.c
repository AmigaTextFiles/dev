#include <proto/asl.h>
#include <proto/intuition.h>
#include <clib/alib_protos.h>
#include <Boopsi/FontReqClass.h>

#include <stdio.h>

#ifdef _DCC
#include <lib/Misc.h>
#endif

main( int argc, char **argv )
{
Class   *FontReqClass=NULL;
Object  *ReqObj=NULL;
ULONG   t;

    FontReqClass=InitFontReqClass();


    if( FontReqClass )
    {
        ReqObj = NewObject( FontReqClass, NULL, ASLFO_FixedWidthOnly, TRUE, TAG_END );

        if( FontRequester( ReqObj ) )
        {
            GetAttr( FC_TTextAttr, ReqObj, &t );
            printf("FontName: %s\n", ((struct TTextAttr *)t)->tta_Name );
        }

        DisposeObject( ReqObj );

        FreeFontReqClass( FontReqClass );
    }

    return(0);
}

#ifdef _DCC
int wbmain( struct WBStartup *w )
{
    OpenConsole( "CON:0/150//100/FontReqClassTest output/WAIT/CLOSE" );
    return( main( 0, 0 ) );
}
#endif
