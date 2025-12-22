/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/gadgetclass.h>
#include <graphics/text.h>              // graphics
#include <libraries/gadtools.h>         // libraries
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/gadtools_pragmas.h>

#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Expanders/defs.h"
#include "Edit.h"
///
/// Prototypes
static void     FGetString( BPTR, STRPTR );
static void     PutString( BPTR, STRPTR );

struct GFInfo {
        struct  Node gi_Node;
        UWORD   gi_Kind;
        UBYTE   gi_Flags;
        UBYTE   gi_Pad;
        APTR    gi_Reserved;
        UBYTE   gi_Reserved2[80];
        UBYTE   gi_Label[40];
        WORD    gi_User1;
        WORD    gi_Left;
        WORD    gi_Top;
        UWORD   gi_Width;
        UWORD   gi_Height;
        BOOL    gi_disabled;
};

extern long DOSBase;

__chip USHORT GF_Imagedata[] =
{
   0x0000, 0x1000,
   0x0000, 0x3000,
   0x003C, 0x3000,
   0x0042, 0x3000,
   0x0F81, 0x3000,
   0x0FC1, 0x3000,
   0x0C3F, 0x3000,
   0x0C01, 0x3000,
   0x0C01, 0x3000,
   0x0C01, 0x3000,
   0x0FFF, 0x3000,
   0x0000, 0x3000,
   0x0000, 0x3000,
   0x7FFF, 0xF000,

   0xFFFF, 0xE000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0xC000, 0x0000,
   0x8000, 0x0000,

   };

struct Image GetFileImage =
{
   0,0,                 /* X, Y */
   20, 14, 2,           /* Width, Height, Depth */
   &GF_Imagedata[0],        /* Image Data*/
   3, 0,                /* PlanePick, PlaneOnOff */
   NULL                 /* Next Image Structure*/
};
///



/// I/O support functions
void FGetString( BPTR File, STRPTR str )
{
    UBYTE   len;

    len = FGetC( File );

    FRead( File, str, len, 1 );

    str[ len ] = '\0';

    if(!( len & 1 ))
        FGetC( File );
}

void PutString( BPTR File, STRPTR str )
{
    UBYTE   len;

    len = strlen( str );

    FPutC( File, len );
    FWrite( File, str, len, 1 );

    if(!( len & 1 ))
        FPutC( File, 0 );
}
///


/*  Starting function           */
/// IEX_Mount Doc
/****** expander.library/IEX_Mount ******************************************
*
*   NAME
*       IEX_Mount  -  Provide expander informations
*
*   SYNOPSIS
*       error = IEX_Mount( IE_Data );
*                            A0
*
*       ULONG IEX_Mount( struct IE_Data * );
*
*   FUNCTION
*       This function is called by IEditor before first usage of the
*       expander. The expander should fill its base with informations
*       about its abilities and open its source description file.
*
*   INPUTS
*       IE_Data -   information about IE
*
*   RESULT
*       error   -   IEX_OK or an error code
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h
*
*****************************************************************************
*
*/
///
/// IEX_Mount
__geta4 ULONG IEX_Mount( __A0 struct IE_Data *IE )
{
    BPTR                    DescFile;
    struct FileInfoBlock   *fib;
    ULONG                   ret = IEX_ERROR_NO_DESC_FILE;
    static UBYTE            FileName[] = "PROGDIR:Expanders/GetFile.desc";

    Forbid();   /* we're going to write to a GLOBAL variable */

    if( Desc ) {            /* already mounted? */
        Permit();
        return( IEX_OK );
    }

    LibBase->Kind      = IEX_OBJECT_KIND;

    LibBase->Resizable = FALSE;
    LibBase->Movable   = TRUE;
    LibBase->HasItems  = FALSE;
    LibBase->UseFonts  = FALSE;

    LibBase->Node.ln_Name = "GETFILE";

    if( fib = AllocDosObject( DOS_FIB, NULL )) {
        if( DescFile = Lock( FileName, ACCESS_READ )) {

            Examine( DescFile, fib );
            UnLock( DescFile );

            if( Desc = AllocVec( fib->fib_Size, 0L )) {
                if( DescFile = Open( FileName, MODE_OLDFILE )) {

                    Read( DescFile, Desc, fib->fib_Size );
                    Close( DescFile );

                    ( *IE->IEXFun->SplitLines )( Desc ); // VERY important!

                    STRPTR pri;

                    pri = ( *IE->IEXFun->GetFirstLine )( Desc, "RENDPRI" );

                    if( pri )
                        LibBase->Node.ln_Pri = atoi( pri );
                    else
                        LibBase->Node.ln_Pri = 0;

                    ret = IEX_OK;

                } else {
                    FreeVec( Desc );
                    Desc = NULL;
                }
            }

        }

        FreeDosObject( DOS_FIB, fib );
    }

    Permit();

    return( ret );
}
///


/*  Edit functions              */
/// IEX_Add Doc
/****** expander.library/IEX_Add ********************************************
*
*   NAME
*       IEX_Add  -  Add an object to the active window
*
*   SYNOPSIS
*       success = IEX_Add( ID, IE_Data, x, y, width, heigth );
*                          D0    A0     D1 D2  D3      D4
*
*       BOOL IEX_Add( UWORD, struct IE_Data *, WORD, WORD, UWORD, UWORD );
*
*   FUNCTION
*       This function is called by IEditor when the user selects the
*       name of our object from the Add Gadget list.
*       If our object can be moved and resized, the user will be asked
*       to draw it (like gadtools gadgets) and then IE will call this
*       function with the coordinates and the size of the drawn box.
*
*       If your object needs a label for the source, you must provide
*       it, in the case the user doesn't want to type it in.
*       E.g.
*                   sprintf( Obj->Label, "%sGad%03ld",
*                            IE->win_info->wi_Label,
*                            IE->win_info->wi_NewGadID );
*                   IE.win_info->wi_NewGadID += 1;
*
*
*       You must also update the IE->win_info->wi_NumObjects variable.
*
*   INPUTS
*       ID          -   ID assigned by IE. You MUST put it in the o_Kind
*                       field.
*       IE_Data     -   information about IE
*       x, y        -   top left corner of the box drawn by the user
*       width, height - size of the box
*
*   RESULT
*       success     -   TRUE for success, FALSE for failure
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEX_Remove()
*
*****************************************************************************
*
*/
///
/// IEX_Add
__geta4 BOOL IEX_Add( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 WORD x, __D2 WORD y, __D3 UWORD width, __D4 UWORD height )
{
    struct GFInfo   *temp_data;
    BOOL                ret = FALSE;

    if( temp_data = AllocMem( sizeof( struct GFInfo ), MEMF_CLEAR )) {

        temp_data->gi_Kind   = ID;       /* DON'T FORGET!!! */
        temp_data->gi_Left   = x;
        temp_data->gi_Top    = y;
        temp_data->gi_Width  = 21;
        temp_data->gi_Height = 14;
        temp_data->gi_Flags  = G_ATTIVO; /* make it active  */

        sprintf( temp_data->gi_Label, "%sGFGad%03ld",
                 IE->win_info->wi_Label,
                 IE->win_info->wi_NewGadID );
        IE->win_info->wi_NewGadID += 1;

        /* add our object to the list */
        AddTail((struct List *)&IE->win_info->wi_Gadgets, (struct Node *)temp_data );

        IE->win_info->wi_NumObjects += 1;

        ret = TRUE;
    }

    return( ret );
}
///
/// IEX_Remove Doc
/****** expander.library/IEX_Remove *****************************************
*
*   NAME
*       IEX_Remove  -  Remove our objects
*
*   SYNOPSIS
*       IEX_Remove( ID, IE_Data );
*                   D0     A0
*
*       void IEX_Remove( UWORD, struct IE_Data * );
*
*   FUNCTION
*       IEditor calls this function when the user wants to delete
*       some objects it doesn't know.
*       You should then remove all the object whose o_Kind field
*       is equal to the ID passed by IE  *AND*  that are selected
*       (check the G_ATTIVO flag in o_flags2).
*
*       This function is called alse when deleting a window or
*       freeing the GUI: of course, all objects will be selected.
*
*   INPUTS
*       ID          -   your ID
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*       Don't forget to update the IE->win_info->wi_NumObjects variable!
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEX_Add()
*
*****************************************************************************
*
*/
///
/// IEX_Remove
__geta4 void IEX_Remove( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct GFInfo   *temp_data, *next;

    for( temp_data = IE->win_info->wi_Gadgets.mlh_Head; temp_data->gi_Node.ln_Succ; temp_data = temp_data->gi_Node.ln_Succ ) {
        /* remove only the objects of our kind and that are selected  */
        if(( temp_data->gi_Kind == ID ) && ( temp_data->gi_Flags & G_ATTIVO )) {
            next = temp_data->gi_Node.ln_Pred;

            Remove(( struct Node * )temp_data );

            IE->win_info->wi_NumObjects -= 1;

            FreeMem( temp_data, sizeof( struct GFInfo ));
            temp_data = next;
        }
    }
}
///
/// IEX_Edit Doc
/****** expander.library/IEX_Edit *******************************************
*
*   NAME
*       IEX_Edit  -  Edit our objects
*
*   SYNOPSIS
*       edited = IEX_Edit( ID, IE_Data );
*                          D0     A0
*
*       BOOL IEX_Edit( UWORD, struct IE_Data * );
*
*   FUNCTION
*       IEditor calls this function when the user wants to edit
*       some objects it doesn't know.
*       You should then open your edit window on IEditor's screen
*       for all objects whose o_Kind field is equal to the ID passed
*       by IE  *AND*  that are selected (check the G_ATTIVO flag in
*       o_flags2).
*       If your expander doesn't support the edit function, it MUST
*       return FALSE.
*
*   INPUTS
*       ID          -   your ID
*       IE_Data     -   information about IE
*
*   RESULT
*       edited      -   TRUE if the user changed some object params,
*                       otherwise FALSE
*
*   NOTES
*       You can find very comfortable to generate the GUI for your
*       expanders using the C_IE_Mod.generator.
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h
*
*****************************************************************************
*
*/
///
/// IEX_Edit
__geta4 BOOL IEX_Edit( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    BOOL                ret = FALSE;
    struct GFInfo      *temp_gad;
    struct Window      *Wnd;
    struct Gadget      *GList, *Gadgets[ Main_CNT ];

   
    for( temp_gad = IE->win_info->wi_Gadgets.mlh_Head; temp_gad->gi_Node.ln_Succ; temp_gad = temp_gad->gi_Node.ln_Succ )
        {
        if(( temp_gad->gi_Kind == ID ) && ( temp_gad->gi_Flags & G_ATTIVO ))
           {

            GList = NULL;

            if( OpenMainWindow( &Wnd, &GList, &Gadgets[0], IE ))
                {
                (*IE->Functions->Status)( "Cannot open my window!", TRUE, 0 );
                }
            else
               {
                ret=HandleWindow(Wnd, Gadgets[0], temp_gad,IE, );
               }

            CloseWnd( &Wnd, &GList );
           }
        }

    return( ret );
}

BOOL HandleWindow(struct Window *Wnd, struct Gadget *Gadgets[], struct GFInfo *temp_gad, struct IE_Data *IE)
{
     struct TagItem GTTags[] = {
                          {NULL, NULL},
                          {TAG_END, NULL}
                          };
     int rt;
     BOOL rcode=FALSE;

     GTTags[0].ti_Tag=GTST_String;
     GTTags[0].ti_Data=(ULONG)(temp_gad->gi_Label);

     GT_SetGadgetAttrsA( Gadgets[ GD_Label ], Wnd, NULL,&GTTags[0]);

     GTTags[0].ti_Tag=GTCB_Checked;
     GTTags[0].ti_Data=(ULONG)(temp_gad->gi_disabled);
     GT_SetGadgetAttrsA( Gadgets[ GD_Disabled ], Wnd, NULL,&GTTags[0]);

     IE->UserData = temp_gad;

     do
         {
         WaitPort( Wnd->UserPort );
         rt = HandleMainIDCMP( Wnd, &Gadgets[0], IE );
         }
     while( rt == 0 );

     if( rt < 0 )
         {
         STRPTR label;

         label = GetString( Gadgets[ GD_Label ] );

         if( label[0] )
             strcpy( temp_gad->gi_Label, label );

         GT_GetGadgetAttrsA(Gadgets[ GD_Disabled ], Wnd, NULL,&GTTags[0]);

         rcode = TRUE;  /*  VERY important !!!  */
         }
return rcode;
}

BOOL MainVanillaKey( UBYTE code, struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
    switch( code ) {
        case 13:
            return( -1 );
            break;
        case 27:
            return( 1 );
            break;
    }

    return( 0 );
}

BOOL OkKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    return( -1 );
}

BOOL CancKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    return( 1 );
}

BOOL OkClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    return( -1 );
}

BOOL CancClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    return( 1 );
}

BOOL LabelClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    return( 0 );
}

BOOL DisabledKeyPressed( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
   return(0);
}

BOOL DisabledClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
   return(0);
}

///
/// IEX_Copy Doc
/****** expander.library/IEX_Copy *******************************************
*
*   NAME
*       IEX_Copy  -  Copy our objects
*
*   SYNOPSIS
*       success = IEX_Copy( ID, IE_Data, offx, offy );
*                           D0     A0     D1    D2
*
*       BOOL IEX_Copy( UWORD, struct IE_Data *, WORD, WORD );
*
*   FUNCTION
*       IEditor calls this function when the user wants to copy
*       some objects it doesn't know.
*
*   INPUTS
*       ID          -   your ID
*       IE_Data     -   information about IE
*       offx, offy  -   offset of the copy
*
*   RESULT
*       success     -   TRUE if succeeded, FALSE if there was no
*                       enough memory
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h
*
*****************************************************************************
*
*/
///
/// IEX_Copy
__geta4 BOOL IEX_Copy( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 WORD offx, __D2 WORD offy )
{
    struct GFInfo   *getfile, *copy;

    for( getfile = IE->win_info->wi_Gadgets.mlh_Head; getfile->gi_Node.ln_Succ; getfile = getfile->gi_Node.ln_Succ ) {
        if(( getfile->gi_Kind == ID ) && ( getfile->gi_Flags & G_ATTIVO )) {

            if( copy = AllocMem( sizeof( struct GFInfo ), 0L )) {

                CopyMem((char *)getfile, (char *)copy, (long)sizeof( struct GFInfo ));

                AddTail((struct List *)&IE->win_info->wi_Gadgets, (struct Node *)copy );

                IE->win_info->wi_NumObjects += 1; /* Don't forget! */

                copy->gi_Left += offx;  /* update its position */
                copy->gi_Top  += offy;

                /* I don't want a neverending loop... ;-) */
                copy->gi_Flags &= ~G_ATTIVO;

            } else
                return( FALSE );
        }
    }

    return( TRUE );
}
///
/// IEX_Make Doc
/****** expander.library/IEX_Make *******************************************
*
*   NAME
*       IEX_Make  -  Put our objects on the window
*
*   SYNOPSIS
*       next_gadget = IEX_Make( ID, IE_Data, GList );
*                               D0     A0     A1
*
*       struct Gadget *IEX_Make( UWORD, struct IE_Data *, struct Gadget * );
*
*   FUNCTION
*       IEditor calls this function before opening a window or after
*       the user has selected 'Gadget/Tags...' and he has done some
*       change.
*
*   INPUTS
*       ID          -   your ID
*       IE_Data     -   information about IE
*       GList       -   gadget list to which append yours.
*
*   RESULT
*       next_gadget -   a pointer to the last gadget you've created
*                       or NULL for failure.
*
*   NOTES
*       NOTE WELL: the window of your object could be closed when IE
*                  calls this function!!!
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEX_Refresh()
*
*****************************************************************************
*
*/
///
/// IEX_Make
__geta4 struct Gadget *IEX_Make( __D0 UWORD ID, __A0 struct IE_Data *IE, __A1 struct Gadget *glist )
{
 struct NewGadget ng;
 struct Gadget *my_gad;

/*The Single gad ;)*/

 ng.ng_TextAttr     = NULL;
 ng.ng_VisualInfo   = IE->ScreenData->Visual;
 ng.ng_Flags        = 0;

 ng.ng_LeftEdge     = 50;  /*Errr*/
 ng.ng_Width        = 21;
 ng.ng_Height       = 14;
 ng.ng_GadgetText   = "";
 ng.ng_TopEdge      = 20;  /*Errr*/
 ng.ng_GadgetID     = 0;

 my_gad = glist= CreateGadgetA(GENERIC_KIND, glist, &ng,NULL);


my_gad->Flags             |= GFLG_GADGIMAGE | GFLG_GADGHCOMP;
my_gad->Activation        |= GACT_RELVERIFY;
my_gad->GadgetRender       = (APTR)&GetFileImage;
my_gad->SelectRender       = NULL;

    return( glist );
}
///
/// IEX_Free Doc
/****** expander.library/IEX_Free *******************************************
*
*   NAME
*       IEX_Free  -  Free all the unused memory when the window is closed
*
*   SYNOPSIS
*       IEX_Free( ID, IE_Data );
*                 D0     A0
*
*       void IEX_Free( UWORD, struct IE_Data * );
*
*   FUNCTION
*       IEditor calls this function after closing a window.
*       You must then release all the memory you can (e.g. when
*       IE closes a window, it FreeGadgets() its GList).
*
*   INPUTS
*       ID          -   your ID
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h
*
*****************************************************************************
*
*/
///
/// IEX_Free
__geta4 void IEX_Free( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    /*  We've got nothing to free when the window is closed  */
}
///
/// IEX_Refresh Doc
/****** expander.library/IEX_Refresh ****************************************
*
*   NAME
*       IEX_Refresh  -  Refresh your objects
*
*   SYNOPSIS
*       IEX_Refresh( ID, IE_Data );
*                    D0     A0
*
*       void IEX_Refresh( UWORD, struct IE_Data * );
*
*   FUNCTION
*       IEditor calls this function when the window needs refreshing.
*       If your objects have some graphic element that can be corrupted,
*       you must redrawn it, or refresh them in some way.
*
*   INPUTS
*       ID          -   your ID
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEX_Make()
*
*****************************************************************************
*
*/
///
/// IEX_Refresh
__geta4 void IEX_Refresh( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
}
///


/*  I/O Functions               */
/// IEX_Save Doc
/****** expander.library/IEX_Save *******************************************
*
*   NAME
*       IEX_Save  -  Save our objects in the file
*
*   SYNOPSIS
*       IEX_Save( ID, IE_Data, File );
*                 D0     A0     D1
*
*       void IEX_Save( UWORD, struct IE_Data *, BPTR );
*
*   FUNCTION
*       IEditor calls this function only if we have some object
*       in the GUI. We must then save in the provided file all
*       the objects found in the win_info list that have the right ID .
*
*       We must also check the G_ATTIVO flag, since this function is
*       called also when the user selects "Gadgets/Save..."
*
*   INPUTS
*       ID          -   your ID
*       IE_Data     -   information about IE
*       File        -   BPTR of the file
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEX_Load()
*
*****************************************************************************
*
*/
///
/// IEX_Save
__geta4 void IEX_Save( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 BPTR File )
{
    struct GFInfo   *getfile;

    for( getfile = IE->win_info->wi_Gadgets.mlh_Head; getfile->gi_Node.ln_Succ; getfile = getfile->gi_Node.ln_Succ ) {
        if(( getfile->gi_Kind == ID ) && ( getfile->gi_Flags & G_ATTIVO )) {
            PutString( File, getfile->gi_Label );
            FPutC(File,getfile->gi_disabled);
        }
    }
}
///
/// IEX_Load Doc
/****** expander.library/IEX_Load *******************************************
*
*   NAME
*       IEX_Load  -  Load our objects from the file
*
*   SYNOPSIS
*       success = IEX_Load( ID, IE_Data, File, Num );
*                           D0     A0     D1   D2
*
*       BOOL IEX_Load( UWORD, struct IE_Data *, BPTR, UWORD );
*
*   FUNCTION
*       IEditor calls this function to load some object from a file.
*
*       We must then load <Num> objects and link them to the
*       win_info's list.
*
*   INPUTS
*       ID          -   your ID
*       IE_Data     -   information about IE
*       File        -   BPTR of the file
*       Num         -   number of objects to load
*
*   RESULT
*       success     -   TRUE for success, FALSE otherwise (= out of mem)
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEX_Save()
*
*****************************************************************************
*
*/
///
/// IEX_Load
__geta4 BOOL IEX_Load( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 BPTR File, __D2 UWORD Num )
{
    struct GFInfo   *getfile;
    UWORD               cnt;

    for( cnt = 0; cnt < Num; cnt++ ) {
        if( getfile = AllocMem( sizeof( struct GFInfo ), MEMF_CLEAR )) {

            getfile->gi_Kind = ID;  /* VERY important!!! */

            AddTail(( struct List * )&IE->win_info->wi_Gadgets, ( struct Node * )getfile );

            FGetString( File, getfile->gi_Label );
            (getfile->gi_disabled)=FGetC(File);

        } else
            return( FALSE );
    }

    return( TRUE );
}
///


/*  Source related functions    */
/// IEX_StartSrcGen Doc
/****** expander.library/IEX_StartSrcGen ************************************
*
*   NAME
*       IEX_StartSrcgen  -  Are you ready to generate the source? ;-)
*
*   SYNOPSIS
*       support_function = IEX_StartSrcGen( ID, IE_Data );
*                                           D0     A0
*
*       STRPTR IEX_StartSrcGen( UWORD, struct IE_Data * );
*
*   FUNCTION
*       IEditor calls this function just before generating the source.
*       The expander should then walk through the window list, setting
*       the right fields of the window info structures in order to
*       let IE know what it need to put in the source.
*
*       Then, the expander must return a STRPTR to its support
*       function(s), if any. They will be written in the source by IE,
*       that will filter out any duplicate function.
*
*   INPUTS
*       ID          -   your ID
*       IE_Data     -   information about IE
*
*   RESULT
*       support_function -  STRPTR to a support function(s) or NULL
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h
*
*****************************************************************************
*
*/
///
/// IEX_StartSrcGen
__geta4 STRPTR IEX_StartSrcGen( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct GFInfo      *getfile;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
        if( wnd->wi_NumObjects ) {
            for( getfile = wnd->wi_Gadgets.mlh_Head; getfile->gi_Node.ln_Succ; getfile = getfile->gi_Node.ln_Succ ) {
                if( getfile->gi_Kind == ID )
                    wnd->wi_NeedRender = TRUE;
            }
        }
    }

    return(( *IE->IEXFun->GetFirstLine )( Desc,"SUPPORT"));
}
///
/// IEX_WriteGlobals Doc
/****** expander.library/IEX_WriteGlobals ***********************************
*
*   NAME
*       IEX_WriteGlobals  -  Write your global variables
*
*   SYNOPSIS
*       IEX_WriteGlobals( ID, GenFiles, IE_Data );
*                         D0     A0        A1
*
*       void IEX_WriteGlobals( UWORD, struct GenFiles *, struct IE_Data * );
*
*   FUNCTION
*       Write your global variables into the GenFiles->XDef file.
*
*   INPUTS
*       ID          -   your ID
*       GenFiles    -   file BPTRs
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEditor/generatorlib.h
*
*****************************************************************************
*
*/
///
/// IEX_WriteGlobals
__geta4 void IEX_WriteGlobals( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
}
///
/// IEX_WriteSetup Doc
/****** expander.library/IEX_WriteSetup *************************************
*
*   NAME
*       IEX_WriteSetup  -  Write your setup routine
*
*   SYNOPSIS
*       IEX_WriteSetup( ID, GenFiles, IE_Data );
*                       D0     A0        A1
*
*       void IEX_WriteSetup( UWORD, struct GenFiles *, struct IE_Data * );
*
*   FUNCTION
*       This function is invoked in the SetupScreen routine, after
*       the screen locking or opening and after the call to
*       GetVisualInfo().
*
*       This can be useful if you need to alloc or do something
*       just once before any window is opened.
*
*   INPUTS
*       ID          -   your ID
*       GenFiles    -   file BPTRs
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEX_WriteCloseDown()
*
*****************************************************************************
*
*/
///
/// IEX_WriteSetup
__geta4 void IEX_WriteSetup( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
}
///
/// IEX_WriteCloseDown Doc
/****** expander.library/IEX_WriteCloseDown *********************************
*
*   NAME
*       IEX_WriteCloseDown
*
*   SYNOPSIS
*       IEX_WriteCloseDown( ID, GenFiles, IE_Data );
*                           D0     A0        A1
*
*       void IEX_WriteCloseDown( UWORD, struct GenFiles *, struct IE_Data * );
*
*   FUNCTION
*       This function is invoked in the CloseDown routine, before
*       the screen unlocking or closing.
*
*   INPUTS
*       ID          -   your ID
*       GenFiles    -   file BPTRs
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEX_WriteSetup()
*
*****************************************************************************
*
*/
///
/// IEX_WriteCloseDown
__geta4 void IEX_WriteCloseDown( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
}
///
/// IEX_WriteHeaders Doc
/****** expander.library/IEX_WriteHeaders ***********************************
*
*   NAME
*       IEX_WriteHeaders  -  Write your headers
*
*   SYNOPSIS
*       IEX_WriteHeaders( ID, GenFiles, IE_Data );
*                         D0     A0        A1
*
*       void IEX_WriteHeaders( UWORD, struct GenFiles *, struct IE_Data * );
*
*   FUNCTION
*       Write your headers into the GenFiles->XDef file.
*
*   INPUTS
*       ID          -   your ID
*       GenFiles    -   file BPTRs
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEditor/generatorlib.h
*
*****************************************************************************
*
*/
///
/// IEX_WriteHeaders
__geta4 void IEX_WriteHeaders( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    STRPTR string;

    if( string = ( *IE->IEXFun->GetFirstLine )( Desc, "HEADER" ))
        FPuts( Files->XDef, string );
}

///
/// IEX_WriteRender Doc
/****** expander.library/IEX_WriteRender ************************************
*
*   NAME
*       IEX_WriteRender  -  Write your render routine
*
*   SYNOPSIS
*       IEX_WriteRender( ID, GenFiles, IE_Data );
*                        D0     A0        A1
*
*       void IEX_WriteRender( UWORD, struct GenFiles *, struct IE_Data * );
*
*   FUNCTION
*       This function is called by the generator in the <Wnd Label>Render
*       routine. If your object need some rendering instructions, then
*       you must write them into the source file.
*
*   INPUTS
*       ID          -   your ID
*       GenFiles    -   file BPTRs
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEditor/generatorlib.h
*
*****************************************************************************
*
*/
///
/// IEX_WriteRender
__geta4 void IEX_WriteRender( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
}
///
/// IEX_GetIDCMP Doc
/****** expander.library/IEX_GetIDCMP ***************************************
*
*   NAME
*       IEX_GetIDCMP  -  Get the IDCMP you need
*
*   SYNOPSIS
*       IDCMP = IEX_GetIDCMP( ID, IDCMP, IE_Data );
*                             D0    D1      A0
*
*       ULONG IEX_GetIDCMP( UWORD, ULONG, struct IE_Data * );
*
*   FUNCTION
*       When called, this function must check if some objects fo your
*       kind are present in IE->win_info: if so, you should perform a
*       OR operation between the IDCMP passed by IE and the ones your
*       objects need to be fully functional.
*
*   INPUTS
*       ID          -   your ID
*       IDCMP       -   IDCMP of the window
*       IE_Data     -   information about IE
*
*   RESULT
*       IDCMP       -   new window IDCMPs
*
*   EXAMPLE
*       If your objects were Listviews, this is what your function should
*       look like:
*
*       ULONG IEX_GetIDCMP( __D0 UWORD ID, __D1 ULONG idcmp,
*                           __A0 struct IE_Data *IE )
*       {
*           struct MyObj    *obj;
*
*           for( obj = IE->win_info->wi_Gadgets.mlh_Head;
*                obj->Node.ln_Succ; obj = obj->Node.ln_Succ ) {
*
*               if( obj->Kind == ID )
*                   return( idcmp | LISTVIEWIDCMP );
*           }
*
*           return( idcmp );
*       }
*
*   NOTES
*       If your objects don't need any IDCMP, then you *must* return
*       the same IDCMP you received from IE.
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h
*
*****************************************************************************
*
*/
///
/// IEX_GetIDCMP
__geta4 ULONG IEX_GetIDCMP( __D0 UWORD ID, __D1 ULONG idcmp, __A0 struct IE_Data *IE )
{
   struct GFInfo    *obj;

           for( obj = IE->win_info->wi_Gadgets.mlh_Head;
                obj->gi_Node.ln_Succ; obj = obj->gi_Node.ln_Succ ) {

               if( obj->gi_Kind == ID )
                   return( idcmp | BUTTONIDCMP );
           }

   return( idcmp );
}
///
/// IEX_WriteData Doc
/****** expander.library/IEX_WriteData **************************************
*
*   NAME
*       IEX_WriteData  -  Write your data
*
*   SYNOPSIS
*       IEX_WriteData( ID, GenFiles, IE_Data );
*                      D0     A0        A1
*
*       void IEX_WriteData( UWORD, struct GenFiles *, struct IE_Data * );
*
*   FUNCTION
*       Write your objects' data into the file.
*
*   INPUTS
*       ID          -   your ID
*       GenFiles    -   file BPTRs
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEditor/generatorlib.h
*
*****************************************************************************
*
*/
///
/// IEX_WriteData
__geta4 void IEX_WriteData( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
UBYTE               X[6], Y[6];
    struct Descriptor   Dsc[] = {
        { 'o', NULL },
        { 'x', X },
        { 'y', Y },
        { 'i',7 },     /*Errr*/
        { 0, NULL }
    };
    struct GFInfo   *getfile;
    struct WindowInfo  *wnd;
    STRPTR              Xdef, Data;
    static UBYTE        ld[] = "%ld";

    Xdef = ( *IE->IEXFun->GetFirstLine )( Desc, "EXTERN" );
    Data = ( *IE->IEXFun->GetFirstLine )( Desc, "DATA" );

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
        if( wnd->wi_NumObjects ) {
            for( getfile = wnd->wi_Gadgets.mlh_Head; getfile->gi_Node.ln_Succ; getfile = getfile->gi_Node.ln_Succ ) {
                if( getfile->gi_Kind == ID ) {

                    Dsc[0].Meaning = getfile->gi_Label;

                    if( Xdef )
                        ( *IE->IEXFun->WriteFormatted )( Files->XDef, Xdef, &Dsc[0] );

                    sprintf( X, ld, getfile->gi_Left - IE->ScreenData->XOffset );
                    sprintf( Y, ld, getfile->gi_Top  - IE->ScreenData->YOffset );

                    if( Data )
                        ( *IE->IEXFun->WriteFormatted )( Files->Std, Data, &Dsc[0] );
                }
            }
        }
    }
}
///
/// IEX_WriteChipData Doc
/****** expander.library/IEX_WriteChipData **********************************
*
*   NAME
*       IEX_WriteChipData  -  Write your chip data
*
*   SYNOPSIS
*       IEX_WriteChipData( ID, GenFiles, IE_Data );
*                          D0     A0        A1
*
*       void IEX_WriteChipData( UWORD, struct GenFiles *, struct IE_Data * );
*
*   FUNCTION
*       Write your objects' chip data into the file.
*
*   INPUTS
*       ID          -   your ID
*       GenFiles    -   file BPTRs
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEditor/generatorlib.h
*
*****************************************************************************
*
*/
///
/// IEX_WriteChipData
__geta4 void IEX_WriteChipData( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
 STRPTR string;

    if( string = ( *IE->IEXFun->GetFirstLine )( Desc, "CHIP" ))
        FPuts( Files->XDef, string );
}
///
/// IEX_WriteOpenWnd Doc
/****** expander.library/IEX_WriteOpenWnd ***********************************
*
*   NAME
*       IEX_WriteOpenWnd  -  Write your open wnd code
*
*   SYNOPSIS
*       IEX_WriteOpenWnd( ID, GenFiles, IE_Data );
*                         D0     A0        A1
*
*       void IEX_WriteOpenWnd( UWORD, struct GenFiles *, struct IE_Data * );
*
*   FUNCTION
*       This function is called inside every Open<Wnd Label>Window routine,
*       just before opening the window. You can use it to write some code
*       needed by your objects that must be executed at that time.
*
*   INPUTS
*       ID          -   your ID
*       GenFiles    -   file BPTRs
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEditor/generatorlib.h
*
*****************************************************************************
*
*/
///
/// IEX_WriteOpenWnd
__geta4 void IEX_WriteOpenWnd( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
  struct Descriptor   Dsc[] = {
        { 'o', NULL },
        { 0, NULL }
    };
    struct GFInfo       *getfile;
    STRPTR              String;

    if(( IE->win_info->wi_NumObjects ) && ( String = ( *IE->IEXFun->GetFirstLine )( Desc, "OPENWND" ))) {
        for( getfile = IE->win_info->wi_Gadgets.mlh_Head; getfile->gi_Node.ln_Succ; getfile = getfile->gi_Node.ln_Succ ) {
            if( getfile->gi_Kind == ID ) {

                Dsc[0].Meaning = getfile->gi_Label;

                ( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );
            }
        }
    }
}
///
/// IEX_WriteCloseWnd Doc
/****** expander.library/IEX_WriteCloseWnd ***********************************
*
*   NAME
*       IEX_WriteCloseWnd  -  Write your close wnd code
*
*   SYNOPSIS
*       IEX_WriteCloseWnd( ID, GenFiles, IE_Data );
*                         D0     A0        A1
*
*       void IEX_WriteCloseWnd( UWORD, struct GenFiles *, struct IE_Data * );
*
*   FUNCTION
*       This function is called inside every Close<Wnd Label>Window routine,
*       just before closing the window. You can use it to write some code
*       needed by your objects that must be executed at that time.
*
*   INPUTS
*       ID          -   your ID
*       GenFiles    -   file BPTRs
*       IE_Data     -   information about IE
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       IEditor/Expander.h, IEditor/generatorlib.h
*
*****************************************************************************
*
*/
///
/// IEX_WriteCloseWnd
__geta4 void IEX_WriteCloseWnd( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
}
///
