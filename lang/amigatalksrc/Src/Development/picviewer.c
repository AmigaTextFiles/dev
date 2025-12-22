/* 
* Simple datatype picture loader
* If you don't use sas/c, you will have to open the libraries by hand.
* intuition.library, graphics.library, datatypes.library, dos.lib
* And it uses the latest picture.datatype V43. The header files are
* in the archive on aminet.
*/

#include <AmigaDOSErrs.h>

#include <proto/intuition.h>
#include <proto/datatypes.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/dos.h>

#include <pragmas/datatypes_pragmas.h>

#include <intuition/gadgetclass.h>

#include <datatypes/datatypesclass.h>
#include <datatypes/pictureclass.h>
#include <datatypes/pictureclassExt.h>

#include <exec/memory.h>

#include <stdio.h>
#include <stdlib.h>

#include "CPGM:GLobalObjects/CommonFuncs.h"

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase       = NULL;
struct Library       *GadToolsBase  = NULL;
struct Library       *DataTypesBase = NULL;

struct Pic {

   Object        *dto;
   struct BitMap *bitmap;
   int            width, height;
   int            depth;
};

struct Pic    *gpic;
struct Window *gwin;
struct Screen *gscreen;

struct FrameInfo gfri = { 0, };

    
// ---------------------------------------------------------------------

void error( char *errstr )
{
   if (*errstr != 0)
      Printf( "%s\n", errstr );

   if (gpic != 0)
      {
      if (gpic->dto != 0) 
         DisposeDTObject( gpic->dto );
      
      FreeVec( gpic );
      }
 
   if (gwin != 0) 
      CloseWindow( gwin );
 
   if (gscreen != 0) 
      UnlockPubScreen( NULL, gscreen );

   if (IntuitionBase != NULL)
      CloseLibs();
   
   if (DataTypesBase != NULL)
      CloseLibrary( DataTypesBase );
    
   exit( IoErr() );
}

struct Pic *LoadPic( char *filename, struct Screen *screen, int count )
{
   struct Pic *pic;
   struct BitMapHeader *BitMapHeader;

   if (pic = (struct Pic *) AllocVec( sizeof( struct Pic ), MEMF_PUBLIC ))
      {
      if (pic->dto = NewDTObject( filename,

            DTA_SourceType,         DTST_FILE,
            DTA_GroupID,            GID_PICTURE,
            PDTA_Remap,             TRUE,
            PDTA_Screen,            screen,
            PDTA_FreeSourceBitMap,  TRUE,
            PDTA_DestMode,          MODE_V43,
            PDTA_UseFriendBitMap,   TRUE,
            OBP_Precision,          PRECISION_IMAGE,
            TAG_DONE))
         {
         if (DoMethod( pic->dto, DTM_PROCLAYOUT, NULL, 1 ))
            {
            if (GetDTAttrs( pic->dto, PDTA_BitMapHeader, &BitMapHeader, 
                            PDTA_DestBitMap, &pic->bitmap, TAG_DONE )==2)
               {
               /* Store picture info */
               pic->width  = BitMapHeader->bmh_Width;
               pic->height = BitMapHeader->bmh_Height;
               pic->depth  = BitMapHeader->bmh_Depth;

               return( pic );
               }
            }

         if (count == 2)
            {
            DisposeDTObject( pic->dto );

            pic->dto = NULL;
            }
         }
      
      if (count == 2)
         {
         FreeVec( pic );
         pic = NULL;
         }
      }
   
   return( NULL );
}

struct Window *createwin( struct Screen *screen )
{
   struct Window *crwin;

   if ((crwin = OpenWindowTags(NULL,

         WA_Width,         200,
         WA_Height,        20,
         WA_DragBar,       TRUE,
         WA_DepthGadget,   TRUE,
         WA_CloseGadget,   TRUE,
         WA_SimpleRefresh, TRUE ,

         WA_IDCMP,         IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW,

         WA_PubScreen,     screen,
         WA_AutoAdjust,    TRUE,
         WA_Activate,      TRUE,
         WA_Title,         "Loading",
         WA_ScreenTitle,   "Loading",

         TAG_END )) == NULL)
      {
      Printf( "Could not open window" );
      return( NULL );
      }

   return( crwin );
}

/****h* DoDTFrameBoxSpecify() ************************************************* 
*
* NAME
*    DoDTFrameBoxSpecify()
*
* DESCRIPTION
*    Tell the object about the environment it will be going into 
*******************************************************************************
*
*/

PRIVATE ULONG DoDTFrameBoxSpecify( Object           *dto, 
                                   struct Window    *win, 
                                   struct Requester *req, // Normally NULL
                                   struct FrameInfo *fri
                                 )
{
   if (dto != NULL && fri != NULL)
      {
      struct Screen       *scr = win->WScreen;
      struct DisplayInfo   di;
      struct dtFrameBox    dtf;

      // Get the Screen ModeID number:

      ULONG modeid = GetVPModeID( (&(scr->ViewPort)) );

      // ------------------------------------------------------

      (void) GetDisplayInfoData( NULL, (APTR) &di, 
                                 sizeof( struct DisplayInfo ), 
                                 DTAG_DISP, modeid
                               );
      
      // Fill fri with zeroes:

      memset( (void *) fri, 0, sizeof( struct FrameInfo ) );

      // Fill in the frame info:

      fri->fri_PropertyFlags     = di.PropertyFlags;
      fri->fri_Resolution        = *( &(di.Resolution) );
      fri->fri_RedBits           = di.RedBits;
      fri->fri_GreenBits         = di.GreenBits;
      fri->fri_BlueBits          = di.BlueBits;

      fri->fri_Dimensions.Width  = scr->Width;
      fri->fri_Dimensions.Height = scr->Height;
      fri->fri_Dimensions.Depth  = scr->BitMap.Depth;
      fri->fri_Screen            = scr;
      fri->fri_ColorMap          = scr->ViewPort.ColorMap;

      /* Send the message */
      dtf.MethodID          = DTM_FRAMEBOX;
      dtf.dtf_GInfo         = NULL;
      dtf.dtf_ContentsInfo  = fri;
      dtf.dtf_FrameInfo     = NULL;
      dtf.dtf_SizeFrameInfo = sizeof( struct FrameInfo );
      dtf.dtf_FrameFlags    = FRAMEF_SPECIFY;

      return( DoDTMethodA( dto, win, req, (Msg) &dtf ) );
      }

   return( 0UL );
}

void HandleIDCMP( int argc )
{
   struct IntuiMessage *intmess;
   ULONG                clazz;

   while (1)
      {
      WaitPort( gwin->UserPort );
      
      while( (intmess = (struct IntuiMessage *) GetMsg( gwin->UserPort )))
         {
         APTR handle = 0L;
         
         clazz = intmess->Class;
         
         ReplyMsg( (struct Message *) intmess );

         switch (clazz)
            {
            case IDCMP_CLOSEWINDOW:
               if (argc == 3)
                  {
                  ReleaseDTDrawInfo( gpic->dto, handle );
                  
                  RemoveDTObject( gwin, gpic->dto );
                  }
                 
               error( "" );
               break;
            
            case IDCMP_REFRESHWINDOW:
               if (argc == 2)
                  { 
                  // Blit when sizewin is finished
                  // This code draws the picture just fine:
                  BltBitMapRastPort( gpic->bitmap, 0, 0, 
                                     gwin->RPort,
                                     gwin->BorderLeft, 
                                     gwin->BorderTop,
                                     gpic->width, 
                                     gpic->height, 0xC0
                                   );
                  }
               else // try alternate method of displaying picture:
                  {
                  SetDTAttrs( gpic->dto, gwin, NULL,

                              DTA_RastPort, gwin->RPort,
                              GA_Left,      0,
                              GA_Top,       0,
                              GA_Width,     gpic->width,
                              GA_Height,    gpic->height,
                              TAG_DONE
                            );

//                  ObtainDTDrawInof() docs say NO AddDTObject() call needed!
//                  AddDTObject( gwin, NULL, gpic->dto, -1 );

                  // Doesn't appear to help!
//                  DoDTFrameBoxSpecify( gpic->dto, gwin, NULL, (&gfri) );

                  if ((handle = ObtainDTDrawInfo( gpic->dto,
                                                  PDTA_Screen, gscreen,
                                                  TAG_DONE )) == NULL)
                     {
                     // Why do we keep ending up here??
                     RemoveDTObject( gwin, gpic->dto );
                        
                     error( "ObtainDTDrawInfo() returned a NULL!" );
                     }
                  
                  DrawDTObject( gwin->RPort, 
                                gpic->dto, 
                                gwin->BorderLeft,
                                gwin->BorderTop,
                                gpic->width,
                                gpic->height,
                                0,
                                0,
                                TAG_DONE
                              );

                  RefreshDTObject( gpic->dto, gwin, NULL, TAG_DONE );
                  }

               break;
               
            default:
               break;
            }
         }
      }
}

void main( int argc, char **argv )
{
   char   title[200];

   gscreen = NULL;
   gwin    = NULL;

   if (argc == 1)
      {
      Printf( "Usage: %s <pic_file> [flag]", argv[0] );
      exit( ERROR_REQUIRED_ARG_MISSING );
      }

   if (OpenLibs() < 0) // Open IntuitionBase, GfxBase & GadToolsBase.
      {
      error( "error: OpenLibs()" );
      }
      
   if ((DataTypesBase = OpenLibrary( "datatypes.library", 44L )) == NULL)
      {
      error( "error: OpenLibrary( \"datatypes.library\", V44+ )" );
      }
      
   if ((gscreen = LockPubScreen( NULL )) == NULL)
      error( "error: LockPubScreen" );

   if ((gwin = createwin( gscreen )) == NULL)
      error( "error: CreateWindow" );

   if ((gpic = LoadPic( argv[1], gscreen, argc )) == NULL)
      error( "pic not loaded" );

   // Not so good, since the mem could be trashed:

   sprintf( title, "%s = (w: %ld, h: x%ld, d: x%ld)", argv[1], 
                   gpic->width, gpic->height, gpic->depth
          );

   ChangeWindowBox( gwin, 
                    (gscreen->Width  - gpic->width ) / 2, 
                    (gscreen->Height - gpic->height) / 2,
                    gpic->width  + gwin->BorderLeft + gwin->BorderRight, 
                    gpic->height + gwin->BorderTop  + gwin->BorderBottom
                  );

   SetWindowTitles( gwin, argv[1], title );

   HandleIDCMP( argc );
   
   return;
}
