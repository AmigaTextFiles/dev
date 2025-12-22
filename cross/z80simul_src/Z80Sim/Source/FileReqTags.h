/****h* Z80Simulator/FileReqTags.h [2.5] ********************************
*
* NAME
*    FileReqTags.h
*
* DESCRIPTION
*    Tag structures for the file requester.
*************************************************************************
*
*/

#define  FR_LEFTEDGE    120
#define  FR_TOPEDGE     32
#define  FR_WIDTH       400
#define  FR_HEIGHT      300

#define LOAD   0
#define SAVE   1
#define EDIT   2
#define TRANS1 3
#define TRANS2 4
#define MACRO  5
#define ASSEM  6
#define PRINT  7
#define MACRO2 8

#ifdef ALLOCATE 

struct TagItem Titles[] = {

    ASLFR_TitleText, (ULONG) "Z80Simulator: Load a Config File...",
    ASLFR_TitleText, (ULONG) "Z80Simulator: Save a Config File...",
    ASLFR_TitleText, (ULONG) "Editor: Edit a File...",
    ASLFR_TitleText, (ULONG) "Z80XLate: Get Intel Input File...",

    ASLFR_TitleText, (ULONG) "Z80XLate: Get .cfg Output File...",
    ASLFR_TitleText, (ULONG) "Macro: Preprocess a File...",
    ASLFR_TitleText, (ULONG) "Z80Asm: Assemble a File...",
    ASLFR_TitleText, (ULONG) "Print: Make a listing...",
    ASLFR_TitleText, (ULONG) "Macro: Get an Output FileName...",

    TAG_IGNORE,      NULL,
    TAG_DONE 
};

struct TagItem   DefaultTags[] = {

    ASLFR_Window,          NULL,   
    ASLFR_TitleText,       (ULONG) "Z80Simulator:",
    ASLFR_InitialHeight,   FR_HEIGHT,
    ASLFR_InitialWidth,    FR_WIDTH,
    ASLFR_InitialTopEdge,  FR_TOPEDGE,
    ASLFR_InitialLeftEdge, FR_LEFTEDGE,
    ASLFR_PositiveText,    (ULONG) " OKAY! ",
    ASLFR_NegativeText,    (ULONG) " CANCEL! ",
    ASLFR_InitialPattern,  (ULONG) "#?",
    ASLFR_InitialFile,     (ULONG) "",
    ASLFR_InitialDrawer,   (ULONG) "RAM:",
    ASLFR_Flags1,          FRF_DOMULTISELECT | FRF_DOPATTERNS,
    ASLFR_Flags2,          FRF_REJECTICONS,
    TAG_IGNORE,            NULL,
    TAG_DONE 
};

struct TagItem   SaveTags[] = {
   
    ASLFR_Window,          NULL,   
    ASLFR_TitleText,       (ULONG) "Z80Simulator: Save a Config File...",
    ASLFR_InitialHeight,   FR_HEIGHT,
    ASLFR_InitialWidth,    FR_WIDTH,
    ASLFR_InitialTopEdge,  FR_TOPEDGE,
    ASLFR_InitialLeftEdge, FR_LEFTEDGE,
    ASLFR_PositiveText,    (ULONG) " OKAY! ",
    ASLFR_NegativeText,    (ULONG) " CANCEL! ",
    ASLFR_InitialPattern,  (ULONG) "#?.cfg",
    ASLFR_InitialFile,     (ULONG) "Z80.cfg",
    ASLFR_InitialDrawer,   (ULONG) "RAM:",
    ASLFR_Flags1,          FRF_DOMULTISELECT | FRF_DOPATTERNS | FRF_DOSAVEMODE,
    ASLFR_Flags2,          FRF_REJECTICONS,
    TAG_IGNORE,            NULL,
    TAG_DONE 
};

struct TagItem   LoadTags[] = {
   
    ASLFR_Window,          NULL,   
    ASLFR_TitleText,       (ULONG) "Z80Simulator: Load a Config File...",
    ASLFR_InitialHeight,   FR_HEIGHT,
    ASLFR_InitialWidth,    FR_WIDTH,
    ASLFR_InitialTopEdge,  FR_TOPEDGE,
    ASLFR_InitialLeftEdge, FR_LEFTEDGE,
    ASLFR_PositiveText,    (ULONG) " OKAY! ",
    ASLFR_NegativeText,    (ULONG) " CANCEL! ",
    ASLFR_InitialPattern,  (ULONG) "#?.cfg",
    ASLFR_InitialFile,     (ULONG) "Z80.cfg",
    ASLFR_InitialDrawer,   (ULONG) "RAM:",
    ASLFR_Flags1,          FRF_DOMULTISELECT | FRF_DOPATTERNS,
    ASLFR_Flags2,          FRF_REJECTICONS,
    TAG_IGNORE,            NULL,
    TAG_DONE 
};

#else

IMPORT struct TagItem   Titles[];
IMPORT struct TagItem   DefaultTags[];
IMPORT struct TagItem   SaveTags[];
IMPORT struct TagItem   LoadTags[];

#endif

/* ------------ END of FileReqTags.h file ------------------------- */
