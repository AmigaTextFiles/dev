/*
**
** TestMagnify.c (C) 1995 by Reinhard Katzmann
**
*/

#define __USE_SYSBASE 1
#include <exec/execbase.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <libraries/asl.h>
#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>
#include <graphics/gfxmacros.h>
#include <ifflib/iff.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/bgui.h>

#include <gadgets/magnifyclass.h>
#ifdef RES_TRACK
#include "restrack.h"
#endif

/*
 *  For the shared library version we want pragmas,
 *  for the linked version only protos.
 */
#ifdef __SLIB
#include <proto/magnifyclass.h>
#else
#include <clib/magnifyclass_protos.h>
#endif

/*
**  Compiler stuff.
*/
#ifdef _DCC
#define SAVEDS __geta4
#define ASM
#define REG(x) __ ## x
#else
#define SAVEDS __saveds
#define ASM __asm
#define REG(x) register __ ## x
#endif

/*
**  Object ID.
*/
#define ID_QUIT         1
#define ID_LOAD         2
#define ID_SAVE         3
#define ID_ZOOM         4
#define ID_GRID         6
#define ID_EDIT         5
#define ID_REGX         7
#define ID_REGY         8

#define OSVERSION(ver)  SysBase->LibNode.lib_Version >= (ver)

/*
 *  Library base and class base.
 */
#ifdef __SLIB
#define LIBSTRING "Shared library version."
struct Library *BGUIMagnifyBase;
#else
#define LIBSTRING "Linked library version."
#endif
extern struct Library *BGUIBase;
/* extern KPrintF(const char *,...); */
struct Library          *IFFBase;       /* Nothing goes without that */
struct Window *window;
struct BitMap *mbmapp;
int GADWIDTH=320;
int GADHEIGHT=150;
ULONG factor=1, grid=0;

Class  *MagnifyClass;
Object *GO_Edit, *GO_RegX, *GO_RegY;

/*
 *      Map-lists.
 */
ULONG a2i[] = { PGA_Top, INDIC_Level, TAG_END };
ULONG e2rx[] = { MAGNIFY_BoxWidth, PGA_Visible, TAG_END };
ULONG e2ry[] = { MAGNIFY_BoxHeight, PGA_Visible, TAG_END };

Object       *WO_Window;
Object       *filereq;

void CloseAll(void)
{
   if (mbmapp) DoMethod(GO_Edit,MAGM_FreeBitMap,&mbmapp);
    if (filereq) DisposeObject( filereq);
    if (WO_Window) DisposeObject( WO_Window );
#ifndef __SLIB
    if (MagnifyClass) FreeMagnifyClass( MagnifyClass );
#else
    if (BGUIMagnifyBase)    CloseLibrary( BGUIMagnifyBase );
#endif
#ifdef RES_TRACK
   EndResourceTracking();
#endif
}

/*
**      Put up a simple requester.
**/
ULONG Req( struct Window *win, UBYTE *gadgets, UBYTE *body, ... )
{
    struct bguiRequest      req = { NULL };

    req.br_GadgetFormat     = gadgets;
    req.br_TextFormat       = body;
    req.br_Flags            = BREQF_CENTERWINDOW | BREQF_LOCKWINDOW;
    req.br_Underscore       = '_';

    return( BGUI_RequestA( win, &req, ( ULONG * )( &body + 1 )));
}

/*
**      Print out specific IFF error
*/
static void PrintIFFError(void)
{
    char *text;

    switch (IFFL_IFFError() )
    {
        case IFFL_ERROR_OPEN:
            text = "Can't open file";
            break;

        case IFFL_ERROR_READ:
            text = "Error reading file";
            break;

        case IFFL_ERROR_NOMEM:
            text = "Not enough memory";
            break;

        case IFFL_ERROR_NOTIFF:
            text = "Not an IFF file";
            break;

        case IFFL_ERROR_NOBMHD:
            text = "No IFF BMHD found";
            break;

        case IFFL_ERROR_NOBODY:
            text = "No IFF BODY found";
            break;

        case IFFL_ERROR_BADCOMPRESSION:
            text = "Unsupported compression mode";
            break;

        default:
            text = "Unspecified error";
            break;
    }
    if ((Req(window, "_Continue", ISEQ_C "%s\n",text)))
        printf("%s\n", text);
}

struct BitMap *AllocBM(LONG width,LONG height)
{
   struct BitMap *bm;

   if (OSVERSION(39) )
   {
      struct Screen *screen;

        screen = LockPubScreen(NULL);
        bm = AllocBitMap(width,height, 2, BMF_CLEAR | GetBitMapAttr(screen->RastPort.BitMap,BMA_FLAGS), NULL);
        UnlockPubScreen(NULL, screen);
   }
   else
   {
     struct BitMap tbm;

     tbm.BytesPerRow  = width/8;
     tbm.Rows = height;
     tbm.Depth  = 2;
     DoMethod(GO_Edit,MAGM_AllocBitMap,&bm,&tbm);
   }

   return bm;
}

BOOL PicLoad(void)
/* Load an IFF Brush (two Planes!) from disk */
{
    IFFL_HANDLE ifffile;    /* IFF file handle */
    struct Screen *screen;
    struct IFFL_BMHD        *bmhd;
    ULONG fname;

    if (! (IFFBase = OpenLibrary(IFFNAME, 19L)) ) {
        printf("Could not open iff.library.\n");
        CloseAll();
        exit(FALSE);
    }

    screen = LockPubScreen(NULL);
    if (! (filereq = FileReqObject, ASLFR_DoPatterns, TRUE, EndObject)) {
        if (! (Req(window, "_Continue", ISEQ_C "Could not open File Requester\n")))
            printf("Could not open File Requester\n");
        return FALSE;
    }

    if (screen) {
        SetAttrs(filereq, ASLFR_InitialHeight, screen->Height-20);
        UnlockPubScreen(NULL, screen);
    }

    if ((DoRequest( filereq ))) return FALSE; /* Return if Cancel is pressed */

    GetAttr(FILEREQ_Path, filereq, &fname);

    if ( !(ifffile = IFFL_OpenIFF((char *)fname, IFFL_MODE_READ)) )
    {
        PrintIFFError();
        return FALSE;
    }

    if ( *(((ULONG *)ifffile)+2) != ID_ILBM)
    {
        if ((Req(window, "_Continue", ISEQ_C "Not an ILBM picture\n")))
            printf("Not an ILBM picture\n");
        return FALSE;
    }

    if ( !(bmhd = IFFL_GetBMHD(ifffile)) )
    {
        PrintIFFError();
        return FALSE;
    }

   if (mbmapp) DoMethod(GO_Edit,MAGM_FreeBitMap,&mbmapp);
   if (!( mbmapp = AllocBM(bmhd->w, bmhd->h))) {
        printf("FATAL: Could not allocate Bitmap\n");
        if(ifffile) IFFL_CloseIFF(ifffile);
        CloseAll();
        exit(FALSE);
    }
    GADWIDTH=bmhd->w;
    GADHEIGHT=bmhd->h;

    /* Colortable is ignored, this is only a small example :-) */

    if (! (IFFL_DecodePic(ifffile, mbmapp) ) )
    {
      printf("FATAL: Could not decode picture.\n");
      PrintIFFError();
      if(ifffile) IFFL_CloseIFF(ifffile);
      CloseAll();
      exit(FALSE);
    }

    /* All went well, so we can close the file */
    if(ifffile) IFFL_CloseIFF(ifffile);

    /* Magnify Class in main() function */
    if (IFFBase) CloseLibrary(IFFBase);
    return TRUE;
}

BOOL PicSave(void)
/* Saves an IFF Brush (two Planes!) to disk */
{
    struct Screen *screen;
    struct BitMap *tmpbm;
    ULONG fname;
    UWORD i;

    if (!mbmapp) return FALSE; /* Sanity check */

    if (! (IFFBase = OpenLibrary(IFFNAME, 19L)) ) {
        printf("Could not open iff.library.\n");
        CloseAll();
        exit(FALSE);
    }

    screen = LockPubScreen(NULL);
    if (! (filereq = FileReqObject, ASLFR_DoPatterns, TRUE, EndObject)) {
        if (! (Req(window, "_Continue", ISEQ_C "Could not open File Requester\n")))
            printf("Could not open File Requester\n");
        return FALSE;
    }

    if (screen)
        SetAttrs(filereq, ASLFR_InitialHeight, screen->Height-20);

    SetAttrs(filereq, ASLFR_DoSaveMode, TRUE);

    if ((DoRequest( filereq ))) return FALSE; /* Return if Cancel is pressed */

    GetAttr(FRQ_Path, filereq, &fname);

    /* Create native OS2.x Bitmap with current picture settings */
    {
        LONG depth=2, width=mbmapp->BytesPerRow*8, height=mbmapp->Rows;
        LONG planesize, bmsize = sizeof(struct BitMap);
        UWORD count = screen->ViewPort.ColorMap->Count, *colortable=NULL;

        /*
        **  If the bitmap has more than 8 planes, we add the size of the
        **  additional plane pointers to the amount of memory we allocate
        **  for the bitmap structure.
        */
        if (depth > 8)
            bmsize += sizeof(PLANEPTR) * (depth-8);

        if (tmpbm = AllocVec(bmsize, MEMF_PUBLIC | MEMF_CLEAR) )
        {
            int i;

            InitBitMap(tmpbm, depth, width, height);
            planesize = tmpbm->BytesPerRow * tmpbm->Rows;

            for (i = 0; i < depth; ++i)
            {
                if (tmpbm->Planes[i] = AllocMem(planesize, MEMF_CHIP | MEMF_CLEAR) )
                {
                }
                else
                {
                    for (i = 0; i < depth; ++i)
                        if (tmpbm->Planes[i])
                            FreeMem(tmpbm->Planes[i], planesize);
                    FreeVec(tmpbm);
                    return FALSE;
                }
            }
        } else return FALSE;

        /* BltBitmap will make the BitMap conversion (f.e. Chunky2Planar) if necessary */
        BltBitMap(mbmapp,0,0,tmpbm,0,0,width,height,0xC0,0xFF,NULL);

        /* Create Colortable (Old IFF only for this demo) */
        if(colortable = (UWORD *)AllocVec(count << 1, MEMF_CLEAR))
        {
            for(i=0; i<count; i++)
                colortable[i]=GetRGB4(screen->ViewPort.ColorMap,i);
        }

        /* Now save the copied BitMap to disk using iff.library */
        if (!(IFFL_SaveBitMap((char *)fname,tmpbm,(WORD *)colortable,1)))
            PrintIFFError();

        /* Cleanup Bitmap */
        for (i = 0; i < tmpbm->Depth; ++i)
        {
            if (tmpbm->Planes[i])
            {
                FreeMem(tmpbm->Planes[i], planesize);
            }
        }
        if (colortable) FreeVec(colortable);
        FreeVec(tmpbm);
        tmpbm=NULL;
   }
   if (screen) UnlockPubScreen(NULL, screen);
   if (IFFBase) CloseLibrary(IFFBase);
   return TRUE;
}

int main( int argc, char **argv )
{
    Object          *GO_Quit, *GO_B, *GO_S, *GO_L, *GO_Zoom, *GO_Grid, *ind;
    ULONG            signal, rc, tmp = 0, regx, regy;
    BOOL             running = TRUE;
    struct IBox *area;
    struct Screen *screen = LockPubScreen(NULL);

	/* char str[256]; */
	UBYTE numl=7;
   UBYTE *InfoTxt =  ISEQ_C
                             "You can edit the picture in the big Gadget\n"
                             "and change the magnification of the picture\n"
                             "with the scroller beside the Grid gadget.\n"
                             "Load/Save of brushes into the edit gadget.\n"
                             "(WARNING: Only 2 Bitplanes are used here.)\n\n" ISEQ_B
                             LIBSTRING;

    if (!screen)
    {
        printf("Could not lock Public Screen.\n");
        CloseAll();
        exit(FALSE);
    }
    if(screen->Height<380)
    {
       numl=1;
       strcpy(InfoTxt,ISEQ_C ISEQ_B LIBSTRING);
       GADWIDTH=200;
       GADHEIGHT=100;
    }
    UnlockPubScreen(NULL, screen);

#ifdef RES_TRACK
   StartResourceTracking (RTL_ALL);
#endif

#ifndef __SLIB
    if (! (MagnifyClass = InitMagnifyClass()) ) {
#else
    if ( ! (BGUIMagnifyBase = OpenLibrary( "gadgets/magnify_bgui.gadget", 39 ))) {
#endif
        printf("Could not init Magnify Class.\n");
        CloseAll();
        exit(FALSE);
    }
#ifdef __SLIB
    MagnifyClass = MAGNIFY_GetClassPtr();
#endif

    if (! (GO_Edit = NewObject( MagnifyClass, NULL, FRM_Type, FRTYPE_BUTTON,
                                                                    /* MAGNIFY_PicArea, mbmapp, */
                                                                    MAGNIFY_CurrentPen, 1,
                                                                    GA_ID, ID_EDIT,
                                                                    TAG_END)) ) {
        printf("Could not create Edit Object.\n");
        CloseAll();
        exit(FALSE);
    }

   if (!(mbmapp=AllocBM(GADWIDTH, GADHEIGHT))) {
        printf("Could not allocate Bitmap.\n");
        CloseAll();
        exit(FALSE);
    }
    SetGadgetAttrs( (struct Gadget *)GO_Edit, window, NULL, MAGNIFY_PicArea, mbmapp, TAG_END);

    /*
    **  Create the window object.
    **/
    if (! ( WO_Window = WindowObject,
        WINDOW_Title,       "MagnifyClass Demo",
        WINDOW_AutoAspect,  TRUE,
        WINDOW_SmartRefresh,    TRUE,
        WINDOW_RMBTrap,         TRUE,
        WINDOW_ScaleHeight,     30,
        WINDOW_IDCMP,       IDCMP_MOUSEMOVE,
        WINDOW_MasterGroup,
            VGroupObject, HOffset(4), VOffset(4), Spacing(4),
                GROUP_BackFill,         SHINE_RASTER,
                StartMember,
                    InfoFixed( NULL, InfoTxt, NULL, numl ), FixMinHeight,
                EndMember,
                StartMember,
                    HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
                        FRM_Type,       FRTYPE_BUTTON,
                        FRM_Recessed,       TRUE,
                        StartMember, GO_B = Button( "Magnify Demo", 0 ), EndMember,
                    EndObject, FixMinHeight,
                EndMember,
                StartMember,
                    HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing(4),
                        StartMember, GO_Grid = CheckBox("Grid",FALSE,ID_GRID), EndMember,
                        StartMember, ind=IndicatorFormat(0, 10, 0, IDJ_CENTER, "%ld%"), FixWidth(16), EndMember,
                        StartMember, GO_Zoom = HorizScroller(NULL, 0, 11, 1, ID_ZOOM), EndMember,
                    EndObject, FixMinHeight,
                EndMember,
                StartMember,
                    VGroupObject, VOffset( 4 ), HOffset( 4 ), Spacing (2),
                        StartMember, GO_RegX = HorizScroller(NULL, 0, (mbmapp->BytesPerRow*8), GADWIDTH, ID_REGX), FixMinHeight, EndMember,
                        StartMember, HGroupObject, Spacing(2),
                            StartMember, GO_Edit, /* FixWidth((GADWIDTH/8)*8), FixHeight((GADHEIGHT/8)*8), */ EndMember,
                            StartMember, GO_RegY = VertScroller(NULL, 0, mbmapp->Rows, GADHEIGHT, ID_REGY), FixMinWidth, EndMember,
                        EndObject, EndMember,
                    EndObject,
                EndMember,
                StartMember,
                    HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing(4),
                        StartMember, GO_L = KeyButton( "_Load", ID_LOAD ), EndMember,
                        StartMember, GO_S = KeyButton( "_Save", ID_SAVE ), EndMember,
                        StartMember, GO_Quit = KeyButton( "_Quit", ID_QUIT ), EndMember,
                    EndObject, FixMinHeight,
                EndMember,
            EndObject,
        EndObject ) )   {
        printf("Could not create Window Object.\n");
        CloseAll();
        exit(FALSE);
    }

    tmp += GadgetKey( WO_Window, GO_L, "l");
    tmp += GadgetKey( WO_Window, GO_S, "s");
    tmp += GadgetKey( WO_Window, GO_Quit, "q");
    tmp += AddMap( GO_Zoom, ind, a2i);
    tmp += AddMap( GO_Edit, GO_RegX, e2rx);
    tmp += AddMap( GO_Edit, GO_RegY, e2ry);
    if (tmp < 6) {
        printf("Could not assign Gadget keys or map.\n");
        CloseAll();
        exit(FALSE);
    }

   if (!(window=WindowOpen(WO_Window))) {
     printf("Could not open window\n");
     CloseAll();
     exit(FALSE);
   }

   /* Main Loop */

   GetAttr(WINDOW_SigMask, WO_Window, &signal);
   do
   {
        Wait(signal);
        while ((rc=HandleEvent(WO_Window)) != WMHI_NOMORE) {
            switch(rc) {
                case WMHI_CLOSEWINDOW:
                case ID_QUIT:
                    running=FALSE;
                    break;
                case ID_LOAD:
                    if (PicLoad()) {
                        GetAttr( BT_HitBox, GO_Edit, &tmp);
                        SetGadgetAttrs( (struct Gadget *)GO_Edit, window, NULL, MAGNIFY_PicArea, mbmapp, TAG_END);
                        SetGadgetAttrs( (struct Gadget *)GO_RegX, window, NULL, PGA_Total, (mbmapp->BytesPerRow*8), TAG_END);
                        SetGadgetAttrs( (struct Gadget *)GO_RegY, window, NULL, PGA_Total, mbmapp->Rows, TAG_END);
                    }
                    break;
                case ID_SAVE:
                    PicSave();
                    break;
                case ID_REGX:
                    GetAttr( PGA_Top, GO_RegX, &regx);
                    SetGadgetAttrs( (struct Gadget *)GO_Edit, window, NULL, MAGNIFY_SelectRegionX, regx, TAG_END);
                    break;
                case ID_REGY:
                    GetAttr( PGA_Top, GO_RegY, &regy);
                    SetGadgetAttrs( (struct Gadget *)GO_Edit, window, NULL, MAGNIFY_SelectRegionY, regy, TAG_END);
                    break;
                case ID_GRID:
                    GetAttr(GA_Selected, GO_Grid, &grid);
                    if (grid) grid=1;
                    GetAttr( BT_HitBox, GO_Edit, &tmp);
                    area=(struct IBox *)tmp;
                    /* sprintf(str,"grid=%d,factor=%d\n",grid,factor);
                    KPrintF("%s",str); */
                    if (grid==TRUE) SetGadgetAttrs( (struct Gadget *)GO_Edit, window, NULL, MAGNIFY_Grid, TRUE, TAG_END);
                    else SetGadgetAttrs( (struct Gadget *)GO_Edit, window, NULL, MAGNIFY_Grid, FALSE, TAG_END);
                    if ( (factor + grid) !=0 )
                    {
                        SetGadgetAttrs( (struct Gadget *)GO_RegX, window, NULL, PGA_Visible, area->Width/(factor+grid), TAG_END);
                        SetGadgetAttrs( (struct Gadget *)GO_RegY, window, NULL, PGA_Visible, area->Height/(factor+grid), TAG_END);
                    }
                    break;
                case ID_ZOOM:
                    GetAttr( PGA_Top, GO_Zoom, &factor);
                    GetAttr( BT_HitBox, GO_Edit, &tmp);
                    area=(struct IBox *)tmp;
                    factor++;
                    SetGadgetAttrs( (struct Gadget *)GO_Edit, window, NULL, MAGNIFY_MagFactor, factor, TAG_END);
                    SetGadgetAttrs( (struct Gadget *)GO_RegX, window, NULL, PGA_Visible, area->Width/(factor+grid), TAG_END);
                    SetGadgetAttrs( (struct Gadget *)GO_RegY, window, NULL, PGA_Visible, area->Height/(factor+grid), TAG_END);
                    break;
            }
        }
    } while(running);

    CloseAll();
    exit(TRUE);
}

#ifdef _DCC
int wbmain( struct WBStartup *wbs )
{
    return( main( 0, wbs ));
}
#endif
