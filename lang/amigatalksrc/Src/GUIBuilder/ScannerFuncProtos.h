/****h* GTBGenC/ScannerFuncProtos.h [1.0] *******************
*
* NAME
*    ScannerFuncProtos.h
*
* DESCRIPTION
*************************************************************
*
*/

#ifndef  SCANNERFUNCPROTOS_H
# define SCANNERFUNCPROTOS_H

# include <AmigaDOSErrs.h>

PUBLIC struct BBox {

  UWORD bb_Left;
  UWORD bb_Top;
  UWORD bb_Width;
  UWORD bb_Height;
  UWORD bb_Flags;
  
};

# ifdef __amigaos4__
#  define MEMATTR __attribute__ ((__packed__))
# else
#  define MEMATTR
# endif

# define NUM_GADGET_TAGS 12

PUBLIC struct myNewGadget {

   UWORD            ng_LeftEdge                MEMATTR;
   UWORD            ng_TopEdge                 MEMATTR;
   UWORD            ng_Width                   MEMATTR;
   UWORD            ng_Height                  MEMATTR;
   UBYTE           *ng_GadgetText              MEMATTR;
   struct TextAttr *ng_TextAttr                MEMATTR;   
   UWORD            ng_GadgetID                MEMATTR;
   ULONG            ng_Flags                   MEMATTR;
   APTR             ng_VisualInfo              MEMATTR;
   APTR             ng_UserData                MEMATTR;
   UWORD            ng_Type                    MEMATTR;
   UWORD            ng_NumberOfTags            MEMATTR;
   UWORD            ng_NumberOfChoices         MEMATTR;
      
   struct TagItem   ng_Tags[ NUM_GADGET_TAGS ] MEMATTR; // Maximum size
};

# define GADGET_TAG_SPACE NUM_GADGET_TAGS * sizeof( struct TagItem )

// -------- From WindowTags.c: --------------------------

IMPORT char *getIDCMPFlag(  int idcmpValue );
IMPORT char *getWindowFlag( int wFlagValue );
IMPORT char *getWindowTag(  int wTag       );

// -------- From GadgetTags.c: --------------------------

IMPORT char *getGadgetType(        int gtype       );
IMPORT char *getGadgetIDCMP(       int gtype       );
IMPORT char *getGadgetTextLoc(     int textLocFlag );
IMPORT char *getMenuType(          int mtype       );
IMPORT char *getMenuFlag(          int mflag       );
IMPORT char *getMenuTag(           int mtag        );
IMPORT char *getBevelBoxTag(       int btag        );
IMPORT char *getBevelBoxFrameType( int btype       );
IMPORT char *getTextJustifyType(   int jtype       );
IMPORT char *getGadgetOrientation( int otype       );
IMPORT char *getGadgetTag(         int itTag       );

#endif

/* ------------ END of ScannerFuncProtos.h file! ------------ */
