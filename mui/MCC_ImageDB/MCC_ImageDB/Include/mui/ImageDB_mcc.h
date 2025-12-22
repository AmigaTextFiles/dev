/*-------------------------------------------------
  Name: ImageDB_mcc.h
  Version: 0.1
  Date: 26.12.2000
  Author: Bodmer Stephan [sbodmer@lsi-media.ch]
---------------------------------------------------*/
#ifndef MUI_IMAGEDB_MCC_H
#define MUI_IMAGEDB_MCC_H

struct GLImage {
    int width;
    int height;
    int format;
    UBYTE *image;   // width * height * 3 (format: GL_RGB type: GL_UNSIGNED_BYTE)
    APTR picture;
};

//--- Macros ---
#define MUIC_ImageDB "ImageDB.mcc"
#define ImageDBObject MUI_NewObject(MUIC_ImageDB


//-------------------------------------------------------------------------
// Tag values
// First: 0x0100
// Last : 0x0138
//------------------------------------------------------------------------
#define MUI_SERIAL (0xfec4<<16)

#define MUIA_ImageDB_Application     (TAG_USER | MUI_SERIAL | 0x0100)
#define MUIA_ImageDB_GuiGFXBase      (TAG_USER | MUI_SERIAL | 0x0101)

// #define MUIM_ImageDB_DeleteBitMap    (TAG_USER | MUI_SERIAL | 0x0121)
#define MUIM_ImageDB_DeleteImage     (TAG_USER | MUI_SERIAL | 0x0122)
// #define MUIM_ImageDB_DeleteTexture   (TAG_USER | MUI_SERIAL | 0x0123)
// #define MUIM_ImageDB_GetBitMap       (TAG_USER | MUI_SERIAL | 0x0125)
#define MUIM_ImageDB_GetImage        (TAG_USER | MUI_SERIAL | 0x0126)
//#define MUIM_ImageDB_GetTexture      (TAG_USER | MUI_SERIAL | 0x0127)
#define MUIM_ImageDB_GetName         (TAG_USER | MUI_SERIAL | 0x013A)
// #define MUIM_ImageDB_InitImage       (TAG_USER | MUI_SERIAL | 0x0132)
// #define MUIM_ImageDB_InitTexture     (TAG_USER | MUI_SERIAL | 0x0135)
// #define MUIM_ImageDB_LoadBitMap      (TAG_USER | MUI_SERIAL | 0x0129)
#define MUIM_ImageDB_LoadImage       (TAG_USER | MUI_SERIAL | 0x012a)
// #define MUIM_ImageDB_LoadTexture     (TAG_USER | MUI_SERIAL | 0x012b)
// #define MUIM_ImageDB_RemoveBitMap    (TAG_USER | MUI_SERIAL | 0x0136)
#define MUIM_ImageDB_RemoveImage     (TAG_USER | MUI_SERIAL | 0x0137)
// #define MUIM_ImageDB_RemoveTexture   (TAG_USER | MUI_SERIAL | 0x0138)
#define MUIM_ImageDB_ScaleImage      (TAG_USER | MUI_SERIAL | 0x0130)

//--- Special values  ---

// #define MUIV_ImageDB_ScaleImage_Replace  "-1"
#define MUIV_ImageDB_Scale_Default    -1

// #define MUIV_ImageDB_InitImage_Allocate  -100
// #define MUIV_ImageDB_InitImage_Copy      -200
// #define MUIV_ImageDB_InitImage_Set       -300

// #define MUIV_ImageDB_InitTexture_Allocate  -100
// #define MUIV_ImageDB_InitTexture_Copy      -200
// #define MUIV_ImageDB_InitTexture_Set       -300

// #define MUIV_ImageDB_EntryType_Name      100
// #define MUIV_ImageDB_EntryType_BitMap    300
// #define MUIV_ImageDB_EntryType_Image     200
// #define MUIV_ImageDB_EntryType_Texture   400

#define MUIF_ImageDB_FlipX  0x01
#define MUIF_ImageDB_FlipY  0x10

#endif
