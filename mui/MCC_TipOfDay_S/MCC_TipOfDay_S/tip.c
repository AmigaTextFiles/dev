
/*
** $Id: tip.c,v 1.6 2000/06/29 22:41:48 carlos Exp $
**
** If your editor supports folding, set /// as  the
** opening and //| as closing phrases.
**
** Anyone who will fuck up the source indentation
** will die screaming!
**
** Carlos
*/

#include "tip.h"

/// Data
struct Data
{
    ULONG  showonstartup;
    Object *board;
    Object *bulb;
    Object *checkmark;

    struct Locale  *locale;
    struct Catalog *catalog;
};
//|
/// CLASS

#define CLASS       MUIC_Tipwindow
#define SUPERCLASS  MUIC_Window

#define UserLibID VERSTAG " © 1999-2000 Marcin Orlowski <carlos@amiga.com.pl>"
#define MASTERVERSION 14

#define __NAME "Tipwindow"
#define MCC_USES_LOCALE

#define VERSION TIP_VERSION
#define REVISION TIP_REVISION
#define VERSTAG TIP_VERSTAG
#include "mccheader.c"

struct Locale  *MyLocale  = NULL;
struct Catalog *MyCatalog = NULL;

//|

/// MakeCheck

Object *MakeCheck(char *num)
{
// Czekmark z szortkatem

    Object *obj = MUI_MakeObject(MUIO_Checkmark, num);
    if(obj)
       set(obj, MUIA_CycleChain, TRUE);

    return(obj);
}

//|
/// TextButton

Object *TextButton(char *num)
{
// buton textowy

        Object *obj = MUI_MakeObject(MUIO_Button,num);

        if(obj) set(obj, MUIA_CycleChain, TRUE);
        return(obj);
}

//|

/// _HomePage
ULONG _HomePage(struct IClass *cl, Object *obj, Msg msg)
{
//struct Data *data = INST_DATA(cl,obj);
char  *lib_name = "openurl.library";
ULONG  lib_vmin = 2;

struct Library *OpenURLBase;

    if( OpenURLBase = OpenLibrary(lib_name, lib_vmin) )
       {
       URL_Open( "http://amiga.com.pl/mcc/", TAG_DONE );

       CloseLibrary( OpenURLBase );
       }
    else
       {
       DisplayBeep(0);
       }

    return( 0 );
}
//|
/// _ShowTip
ULONG _ShowTip(struct IClass *cl, Object *obj, struct MUIP_Tip_Show *msg)
{
struct Data *data = INST_DATA(cl,obj);
char   show = TRUE;

    if( !xget(obj, MUIA_Window_Open ) )
       {
       get( data->board, MUIA_Tipb_ShowOnStartup, &data->showonstartup );
       set( data->checkmark, MUIA_Selected, data->showonstartup );
       }

    if( msg->Flags == MUIV_Tip_Show_Startup )
       show = data->showonstartup;

    if( show )
       {
       DoMethod( data->board, MUIM_Tipb_Show, msg->Flags );

       set( obj, MUIA_Window_Open, TRUE );
       }

    return( 0 );
}
//|

/// GS

extern struct Library *LocaleBase;

char *GS( LONG stringNum )
{
LONG   *l;
UWORD  *w;
char   *builtIn;

    l = (LONG *)tipwindow_Block;

    while (*l != stringNum)
       {
       w = (UWORD *)((ULONG)l + 4);
       l = (LONG *)((ULONG)l + (ULONG)*w + 6);
       }
    builtIn = (STRPTR)((ULONG)l + 6);

    if( LocaleBase )
            return(GetCatalogStr(MyCatalog, stringNum, builtIn));

    return(builtIn);
}
//|

/// OM_NEW

ULONG ASM _New( REG(a0) struct IClass *cl,
                REG(a2) Object *obj,
                REG(a1) Msg msg )
{
struct Data *data;
Object *board, *CH_Show, *BT_NextTip, *BT_PrevTip, *BT_RandTip;
Object *BC_Bulb = NULL;



    D(bug(__NAME ": OM_NEW\n"));


    MyLocale  = OpenLocale(NULL);
    MyCatalog = OpenCatalog(NULL, "TipWindow.catalog",
                                  OC_BuiltInLanguage, "english",
                                  TAG_DONE);

    D(bug( "Locale: %lx, Catalog: %lx\n", MyLocale, MyCatalog ));


    // gimme bulb body
    BC_Bulb = (Object *)GetTagData( MUIA_Tip_BulbObject, NULL,  ((struct opSet *)msg)->ops_AttrList );


    // default bulb if no other supplied
    if( !BC_Bulb )
       {
       BC_Bulb = BodychunkObject,
                          NoFrame,
                          MUIA_InputMode    , MUIV_InputMode_RelVerify,

                          MUIA_Group_Spacing, 0,
                          MUIA_FixWidth             , BULB3_WIDTH ,
                          MUIA_FixHeight            , BULB3_HEIGHT,
                          MUIA_Bitmap_Width         , BULB3_WIDTH ,
                          MUIA_Bitmap_Height        , BULB3_HEIGHT,
                          MUIA_Bodychunk_Depth      , BULB3_DEPTH ,
                          MUIA_Bodychunk_Body       , (UBYTE *) bulb3_body,
                          MUIA_Bodychunk_Compression, BULB3_COMPRESSION,
                          MUIA_Bodychunk_Masking    , BULB3_MASKING,
                          MUIA_Bitmap_SourceColors  , (ULONG *) bulb3_colors,

                          MUIA_ShortHelp, GS( MSG_BULB_HELP ),
                          End;
       }

    if( !BC_Bulb )
       {
       D(bug(__NAME ": Can't create default bulb!\n"));
       goto cleanup;
       }


    // let's create the board
    obj = (Object *)DoSuperNew(cl, obj,
               MUIA_Window_ID      , 'TODD',
               MUIA_Window_Title   , GS( MSG_WIN_TITLE ),
               MUIA_Window_NoMenus , TRUE,
               WindowContents,
                  VGroup,

//                  Child, VGroup,
//                         TextFrame, TextBack,

                         // header
                         Child, HGroup,
/*
///                               Child, BodychunkObject,
                   Child, BodychunkObject,
//                          GroupFrame,
                          MUIA_Group_Spacing, 0,
                          MUIA_FixWidth             , TIP_WIDTH ,
                          MUIA_FixHeight            , TIP_HEIGHT,
                          MUIA_Bitmap_Width         , TIP_WIDTH ,
                          MUIA_Bitmap_Height        , TIP_HEIGHT,
                          MUIA_Bodychunk_Depth      , TIP_DEPTH ,
                          MUIA_Bodychunk_Body       , (UBYTE *) tip_body,
                          MUIA_Bodychunk_Compression, TIP_COMPRESSION,
                          MUIA_Bodychunk_Masking    , TIP_MASKING,
                          MUIA_Bitmap_SourceColors  , (ULONG *) tip_colors,
                          End,
//|
*/
                                Child, BC_Bulb,

                                Child, HVSpace,

                                Child, BT_RandTip = TextObject,
                                        WindowBack,
                                        MUIA_InputMode    , MUIV_InputMode_RelVerify,
                                        MUIA_Font, MUIV_Font_Big,
                                        MUIA_Text_Contents, GS( MSG_DO_YOU_KNOW ),
                                       End,

                                Child, HVSpace,
                                End,


                          // the board
                          Child, board = TipboardObject, End,

                  // buttons
                  Child, HGroup,
                         Child, HGroup,
                                MUIA_Font, MUIV_Font_Tiny,
                                MUIA_ShortHelp, GS( MSG_SHOW_HELP ),
                                Child, CH_Show = MakeCheck( GS( MSG_SHOW_TIPS ) ),
                                Child, MUI_MakeObject( MUIO_Label, GS( MSG_SHOW_TIPS ), MUIO_Label_SingleFrame ),
                                End,
                         Child, HVSpace,
                         Child, HGroup,
                                MUIA_Weight, 35,
                                    Child, BT_PrevTip  = TextButton( GS( MSG_PREV ) ),
                                    Child, BT_NextTip  = TextButton( GS( MSG_NEXT ) ),
                                End,
                         End,


                  End,


           TAG_DONE);


    if( !obj )
       {
       D(bug(__NAME ": Class object creation failed!\n"));
       goto cleanup;
       }


    // Short help

    set( CH_Show   , MUIA_ShortHelp, GS( MSG_SHOW_HELP ) );
    set( BT_PrevTip, MUIA_ShortHelp, GS( MSG_PREV_HELP ) );
    set( BT_RandTip, MUIA_ShortHelp, GS( MSG_RAND_HELP ) );
    set( BT_NextTip, MUIA_ShortHelp, GS( MSG_NEXT_HELP ) );


    // presetting..

    data = INST_DATA(cl, obj);


    data->board = board;
    data->bulb  = BC_Bulb;
    data->checkmark = CH_Show;
    data->showonstartup = TRUE;

    data->locale  = MyLocale;
    data->catalog = MyCatalog;


    // notification...

    DoMethod( obj, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
               MUIV_Notify_Self, 3 ,MUIM_Set, MUIA_Window_Open, FALSE
            );


    DoMethod( BC_Bulb, MUIM_Notify, MUIA_Pressed, FALSE,
           board, 1, MUIM_Tip_GoHomePage
           );
    DoMethod( BT_NextTip, MUIM_Notify, MUIA_Pressed, FALSE,
           board, 2, MUIM_Tipb_Show, MUIV_Tipb_Show_Next
           );
    DoMethod( BT_RandTip, MUIM_Notify, MUIA_Pressed, FALSE,
           board, 2, MUIM_Tipb_Show, MUIV_Tipb_Show_Random
           );
    DoMethod( BT_PrevTip, MUIM_Notify, MUIA_Pressed, FALSE,
           board, 2, MUIM_Tipb_Show, MUIV_Tipb_Show_Prev
           );
    DoMethod( CH_Show, MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
           board, 3, MUIM_Set, MUIA_Tipb_ShowOnStartup, MUIV_TriggerValue
           );

    DoMethod( obj, MUIM_Notify, MUIA_Window_InputEvent, "right",
           board, 2, MUIM_Tipb_Show, MUIV_Tipb_Show_Next
           );
    DoMethod( obj, MUIM_Notify, MUIA_Window_InputEvent, "left",
           board, 2, MUIM_Tipb_Show, MUIV_Tipb_Show_Prev
           );


    /*** trick to set arguments ***/
    msg->MethodID = OM_SET;
    DoMethodA(obj, (Msg)msg);
    msg->MethodID = OM_NEW;


    return((ULONG)obj);


cleanup:

    D(bug(__NAME ": OM_NEW: cleanup called\n"));

    if( BC_Bulb )
       MUI_DisposeObject( BC_Bulb );

    return( NULL );

}
//|
/// OM_DISPOSE
ULONG _Dispose(struct IClass *cl, Object *obj, struct opSet *msg)
{
struct Data *data = INST_DATA(cl,obj);


    D(bug(__NAME ": OM_DISPOSE\n"));

    if( data->locale )  CloseLocale( data->locale );
    if( data->catalog ) CloseCatalog( data->catalog );

    return(DoSuperMethodA(cl, obj, msg));
}
//|
/// OM_SET

ULONG ASM _Set(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
{
struct Data *data = INST_DATA(cl,obj);
struct TagItem *tags,*tag;

    for(tags=((struct opSet *)msg)->ops_AttrList; tag=NextTagItem(&tags); )
       {
       switch(tag->ti_Tag)
          {
          case MUIA_Tip_FileBase:
          case MUIA_Tipb_FileBase:
               set( data->board, MUIA_Tipb_FileBase, tag->ti_Data );
               break;
          }
       }

    return(DoSuperMethodA(cl, obj, msg));
}

//|
/// OM_GET
static ULONG ASM _Get(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
{
struct Data *data = INST_DATA(cl,obj);
ULONG  *store = ((struct opGet *)msg)->opg_Storage;

//    D(bug(__NAME ": GET\n"));

    switch(((struct opGet *)msg)->opg_AttrID)
       {
       case MUIA_Tip_FileBase:
            *store = xget(data->board, MUIA_Tipb_FileBase );
            break;

       case MUIA_Tip_WindowObject:
            *store = (ULONG)obj;
            break;

       case MUIA_Tip_BulbObject:
            *store = (ULONG)data->bulb;
            break;

       case MUIA_Version:
            *store = (ULONG)VERSION;
            break;

       case MUIA_Revision:
            *store = (ULONG)REVISION;
            break;
       }

    return(DoSuperMethodA(cl, obj, msg));
}
//|

/// Dispatcher
ULONG ASM SAVEDS _Dispatcher(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
{

    switch (msg->MethodID)
       {
       case OM_NEW    : return(_New     (cl, obj, (APTR)msg));
       case OM_DISPOSE: return(_Dispose (cl, obj, (APTR)msg));
       case OM_SET    : return(_Set     (cl, obj, (APTR)msg));
       case OM_GET    : return(_Get     (cl, obj, (APTR)msg));

       case MUIM_Tip_Show       : return(_ShowTip (cl, obj, (APTR)msg));
       case MUIM_Tip_GoHomePage : return(_HomePage (cl, obj, (APTR)msg));
       }

    return((ULONG)DoSuperMethodA(cl, obj, msg));

}
//|

