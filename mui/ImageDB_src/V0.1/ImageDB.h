/*-------------------------------------------------
  Name: ImageDB.h
  Version: 0.1
  Date: 4.7.2000
---------------------------------------------------*/

#ifndef IMANAGERDB_H
#define IMANAGERDB_H


//--- error codes
// #define GUIGFX_NOT_A_PICTURE    -1

//--- Delete an image
struct MUIP_ImageDB_DeleteImage {
    ULONG MethodID;
    char *id;
};

//--- DrawImage
struct MUIP_ImageDB_DrawImage {
    ULONG MethodID;
    ULONG *what;
    int mode;
};

//--- GetImage
struct MUIP_ImageDB_GetImage {
    ULONG MethodID;
    char *id;
};

//--- GetName
struct MUIP_ImageDB_GetName {
    ULONG MethodID;
    struct GLImage *source;
};

//--- GetTexture
struct MUIP_ImageDB_GetTexture {
    ULONG MethodID;
    char *id;
};

//--- Init Image
struct MUIP_ImageDB_InitImage {
    ULONG MethodID;
    char *id;
    ULONG what;
    int mode;
};

//--- Init Texture
struct MUIP_ImageDB_InitTexture {
    ULONG MethodID;
    char *id;
    ULONG what;
    int mode;
};

//--- LoadImage
struct MUIP_ImageDB_LoadImage {
    ULONG MethodID;
    char *filename;
    char *id;
    int width;
    int height;
    int flipxy;
};

//--- LoadTexture
struct MUIP_ImageDB_LoadTexture {
    ULONG MethodID;
    char *filename;
    char *id;
};

//--- RemoveImage ---
struct MUIP_ImageDB_RemoveImage {
    ULONG MethodID;
    char *source;
};

//--- ScaleImage
struct MUIP_ImageDB_ScaleImage {
    ULONG MethodID;
    char *source;
    char *newid;
    int width;
    int height;
    int flipxy;
};

//--- List of loaded bitmaps ---
struct ImageDB_MUI_BitMapEntry {
    struct Node node;
    struct BitMap bitmap;
    char id[255];
};

//--- List of loaded images ---
struct ImageDB_MUI_ImageEntry {
    struct Node node;
    struct GLImage *glimage;
    char id[255];
};


struct Data {
   //--- Debug ---
   BPTR fh;

   //--- lists ---
   struct List bitmaplist;
   int numbitmap;
   struct List imagelist;
   int numimage;

   //--- ImageDB Class attributs
   APTR App;
};
#endif
