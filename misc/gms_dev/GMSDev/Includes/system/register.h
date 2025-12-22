#ifndef SYSTEM_REGISTER_H
#define SYSTEM_REGISTER_H TRUE

/****************************************************************************
** Module ID Numbers.
*/

#define MOD_BLITTER    1
#define MOD_SOUND      2
#define MOD_SCREENS    3
#define MOD_VECTORS    4
#define MOD_CACTUS     5
#define MOD_ANIM       6
#define MOD_CARDS      7
#define MOD_TEXT       8
#define MOD_OBJECTS    9
#define MOD_NETWORK   10
#define MOD_TEST      11
#define MOD_JOYPORTS  12
#define MOD_FILES     13
#define MOD_KEYBOARD  14
#define MOD_PICTURES  15
#define MOD_MUSIC     16
#define MOD_COLOURS   17
#define MOD_COLLISION 18
#define MOD_STRINGS   19
#define MOD_CONFIG    20

#define MOD_END       25

/****************************************************************************
** Special ID Numbers.
*/

#define ID_HIDDEN     -1
#define ID_MEMBLOCK   -2
#define ID_LIST       -3
#define ID_GENTAGS    -4
#define ID_SPCTAGS    -5
#define ID_OBJECTLIST -6
#define ID_CHILD      -7

#define TAGS       ((ID_GENTAGS<<16)|01)
#define LIST1      ((ID_LIST<<16)|01)
#define LIST2      ((ID_LIST<<16)|02)
#define OBJECTLIST ((ID_OBJECTLIST<<16)|01)

/****************************************************************************
** System Object Numbers.
*/

#define ID_JOYDATA       1
#define ID_PICTURE       2
#define ID_SOUND         3
#define ID_SPRITE        4
#define ID_BITMAP        5
#define ID_BOB           6
#define ID_MBOB          7
#define ID_RESTORE       8
#define ID_SCREEN        9
#define ID_ANIM          10
#define ID_ANIMBOB       11
#define ID_CARDSET       12
#define ID_RAWDATA       13
#define ID_DIRECTORY     14
#define ID_EVENT         15
#define ID_FILE          16
#define ID_FILENAME      17
#define ID_TASK          18
#define ID_REFERENCE     19
#define ID_SEGMENT       20
#define ID_SYSOBJECT     21
#define ID_MEMPTR        22
#define ID_MAP           23
#define ID_MODULE        24
#define ID_UNIVERSE      25
#define ID_TIME          26
#define ID_OBJECTFILE    27
#define ID_PALETTE       28
#define ID_KEYBOARD      29
#define ID_RASTER        30
#define ID_ITEMLIST      31
#define ID_DATAPROCESSOR 32
#define ID_DESKTOP       33
#define ID_FONT          34
#define ID_ICON          35
#define ID_MENUBAR       36
#define ID_MENU          37
#define ID_MENUITEM      38
#define ID_WINDOW        39
#define ID_CHAIN         40
#define ID_MUSIC         41
#define ID_JUKEBOX       42
#define ID_TITLEBAR      43
#define ID_CONFIG        44
#define ID_COMPONENT     45
#define ID_APPLICATION   46

#endif /* SYSTEM_REGISTER_H */
