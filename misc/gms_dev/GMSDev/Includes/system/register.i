	IFND	SYSTEM_REGISTER_I
SYSTEM_REGISTER_I = 1

*****************************************************************************
* Module ID Numbers.

MOD_BLITTER   =  1    ;Standard
MOD_SOUND     =  2    ;Standard
MOD_SCREENS   =  3    ;Standard
MOD_VECTORS   =  4    ;Extra
MOD_CACTUS    =  5    ;Extra
MOD_ANIM      =  6    ;Extra
MOD_CARDS     =  7    ;Extra
MOD_TEXT      =  8    ;Extra
MOD_OBJECTS   =  9    ;Standard
MOD_NETWORK   = 10    ;Extra
MOD_TEST      = 11    ;Test
MOD_JOYPORTS  = 12    ;Standard
MOD_FILES     = 13    ;Standard
MOD_KEYBOARD  = 14    ;Standard
MOD_PICTURES  = 15    ;Standard
MOD_MUSIC     = 16    ;Extra
MOD_COLOURS   = 17    ;Extra
MOD_COLLISION = 18    ;Extra
MOD_STRINGS   = 19    ;Standard
MOD_CONFIG    = 20    ;Extra

MOD_END       = 25

*****************************************************************************
* Special ID Numbers.

ID_HIDDEN     = -1
ID_MEMBLOCK   = -2
ID_LIST       = -3
ID_GENTAGS    = -4
ID_SPCTAGS    = -5
ID_OBJECTLIST = -6
ID_CHILD      = -7

TAGS       = ((ID_GENTAGS<<16)|01)
LIST1      = ((ID_LIST<<16)|01)
LIST2      = ((ID_LIST<<16)|02)
OBJECTLIST = ((ID_OBJECTLIST<<16)|01)

*****************************************************************************
* System Object ID Numbers.

ID_JOYDATA       = 1
ID_PICTURE       = 2
ID_SOUND         = 3
ID_SPRITE        = 4
ID_BITMAP        = 5
ID_BOB           = 6
ID_MBOB          = 7
ID_RESTORE       = 8
ID_SCREEN        = 9
ID_ANIM          = 10
ID_ANIMBOB       = 11
ID_CARDSET       = 12
ID_RAWDATA       = 13
ID_DIRECTORY     = 14
ID_EVENT         = 15
ID_FILE          = 16
ID_FILENAME      = 17
ID_TASK          = 18
ID_REFERENCE     = 19
ID_SEGMENT       = 20
ID_SYSOBJECT     = 21
ID_MEMPTR        = 22
ID_MAP           = 23
ID_MODULE        = 24
ID_UNIVERSE      = 25
ID_TIME          = 26
ID_OBJECTFILE    = 27
ID_PALETTE       = 28
ID_KEYBOARD      = 29
ID_RASTER        = 30
ID_ITEMLIST      = 31
ID_DATAPROCESSOR = 32
ID_DESKTOP       = 33
ID_FONT          = 34
ID_ICON          = 35
ID_MENUBAR       = 36
ID_MENU          = 37
ID_MENUITEM      = 38
ID_WINDOW        = 39
ID_CHAIN         = 40
ID_MUSIC         = 41
ID_JUKEBOX       = 42
ID_TITLEBAR      = 43
ID_CONFIG        = 44
ID_COMPONENT     = 45
ID_APPLICATION   = 46

 ENDC ;SYSTEM_REGISTER_I
