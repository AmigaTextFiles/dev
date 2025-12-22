/*
**  $VER: register.e
**
**  System Register.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

/****************************************************************************
** Module ID numbers. 
*/

CONST MOD_BLITTER  =  1,
      MOD_SOUND    =  2,
      MOD_SCREENS  =  3,
      MOD_VECTORS  =  4,
      MOD_CACTUS   =  5,
      MOD_ANIM     =  6,
      MOD_CARDS    =  7,
      MOD_TEXT     =  8,
      MOD_OBJECTS  =  9,
      MOD_NETWORK  = 10,
      MOD_TEST     = 11,
      MOD_JOYPORTS = 12,
      MOD_FILES    = 13,
      MOD_KEYBOARD = 14,
      MOD_PICTURES = 15,
      MOD_MUSIC    = 16,
      MOD_COLOURS  = 17,
      MOD_COLLISION= 18,
      MOD_STRINGS  = 19,
      MOD_CONFIG   = 20

/***************************************************************************
** Special ID Numbers.
*/

CONST ID_HIDDEN     = -1,
      ID_MEMBLOCK   = -2,
      ID_LIST       = -3,
      ID_GENTAGS    = -4,
      ID_SPCTAGS    = -5,
      ID_OBJECTLIST = -6,
      ID_CHILD      = -7

#define TAGS       (Shl(ID_GENTAGS,16) OR 1)
#define LIST1      (Shl(ID_LIST,16) OR 1)
#define LIST2      (Shl(ID_LIST,16) OR 2)
#define OBJECTLIST (Shl(ID_OBJECTLIST<<16) OR 1)

/****************************************************************************
** System Object Numbers.
*/

CONST ID_JOYDATA       = 1,
      ID_PICTURE       = 2,
      ID_SOUND         = 3,
      ID_SPRITE        = 4,
      ID_BITMAP        = 5,
      ID_BOB           = 6,
      ID_MBOB          = 7,
      ID_RESTORE       = 8,
      ID_SCREEN        = 9,
      ID_ANIM          = 10,
      ID_ANIMBOB       = 11,
      ID_CARDSET       = 12,
      ID_RAWDATA       = 13,
      ID_DIRECTORY     = 14,
      ID_EVENT         = 15,
      ID_FILE          = 16,
      ID_FILENAME      = 17,
      ID_TASK          = 18,
      ID_REFERENCE     = 19,
      ID_SEGMENT       = 20,
      ID_SYSOBJECT     = 21,
      ID_MEMPTR        = 22,
      ID_MAP           = 23,
      ID_MODULE        = 24,
      ID_UNIVERSE      = 25,
      ID_TIME          = 26,
      ID_OBJECTFILE    = 27,
      ID_PALETTE       = 28,
      ID_KEYBOARD      = 29,
      ID_RASTER        = 30,
      ID_ITEMLIST      = 31,
      ID_DATAPROCESSOR = 32,
      ID_DESKTOP       = 33,
      ID_FONT          = 34,
      ID_ICON          = 35,
      ID_MENUBAR       = 36,
      ID_MENU          = 37,
      ID_MENUITEM      = 38,
      ID_WINDOW        = 39,
      ID_CHAIN         = 40,
      ID_MUSIC         = 41,
      ID_JUKEBOX       = 42,
      ID_TITLEBAR      = 43,
      ID_CONFIG        = 44,
      ID_COMPONENT     = 45,
      ID_APPLICATION   = 46

