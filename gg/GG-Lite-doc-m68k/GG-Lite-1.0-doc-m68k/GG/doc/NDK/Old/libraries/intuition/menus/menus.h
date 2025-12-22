/* menus.h -- all the structures needed to make the menus. */
/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */


#define   IWIDTH  96
#define   IHEIGHT  8

/* Topaz 8, just in case we can't handle the default font */
struct TextAttr TOPAZ80 = 
    {(STRPTR)"topaz.font",TOPAZ_EIGHTY,0,0};

/* Preferences Item IntuiText */
struct IntuiText PrefText[] =
    {
       {2,1,JAM2,CHECKWIDTH,1, NULL, " Sound...", NULL},
       {2,1,JAM2,CHECKWIDTH,1, NULL, " Auto Save", NULL},
       {2,1,JAM2,CHECKWIDTH,1, NULL, " Have Your Cake", NULL},
       {2,1,JAM2,CHECKWIDTH,1, NULL, " Eat It Too", NULL}
    };

struct MenuItem PrefItem[] =
    {
       /* "Sound..." */
       {&PrefItem[1], 0,  0, IWIDTH, IHEIGHT, 
        ITEMTEXT|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&PrefText[0], NULL, NULL, NULL, MENUNULL
       },
       /* "Auto Save" (toggle-select, initially selected) */
       {&PrefItem[2], 0, 10, IWIDTH, IHEIGHT, 
        ITEMTEXT|ITEMENABLED|HIGHCOMP|CHECKIT|MENUTOGGLE|CHECKED, 0,
        (APTR)&PrefText[1], NULL, NULL, NULL, MENUNULL
       },
       /* "Have Your Cake" (initially selected, excludes "Eat It Too") */
       {&PrefItem[3], 0,  0, IWIDTH, IHEIGHT, 
        ITEMTEXT|ITEMENABLED|HIGHCOMP|CHECKIT|CHECKED, 8,
        (APTR)&PrefText[2], NULL, NULL, NULL, MENUNULL
       },
       /* "Eat It Too" (excludes "Have Your Cake") */
       {NULL        , 0,  0, IWIDTH, IHEIGHT, 
        ITEMTEXT|ITEMENABLED|HIGHCOMP|CHECKIT, 4,
        (APTR)&PrefText[3], NULL, NULL, NULL, MENUNULL
       }
    };

/* Edit Menu Item IntuiText */
struct IntuiText EditText[] =
    {
       {2,1,JAM2,2,1, NULL, "Undo",  NULL},
       {2,1,JAM2,2,1, NULL, "Cut",   NULL},
       {2,1,JAM2,2,1, NULL, "Copy",  NULL},
       {2,1,JAM2,2,1, NULL, "Paste", NULL},
       {2,1,JAM2,2,1, NULL, "Erase All", NULL}
    };

/* Edit Menu Items */
struct MenuItem EditItem[] =
    {
       /* "Undo" MenuItem (key-equivalent: 'Z') */
       {&EditItem[1], 0,  0, IWIDTH, IHEIGHT, 
        ITEMTEXT|COMMSEQ|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&EditText[0], NULL,  'Z', NULL, MENUNULL
       },
       /* "Cut" (key-equivalent: 'X') */
       {&EditItem[2], 0, 10, IWIDTH, IHEIGHT, 
        ITEMTEXT|COMMSEQ|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&EditText[1], NULL,  'X', NULL, MENUNULL
       },
       /* "Copy" (key-equivalent: 'C') */
       {&EditItem[3], 0, 20, IWIDTH, IHEIGHT, 
        ITEMTEXT|COMMSEQ|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&EditText[2], NULL,  'C', NULL, MENUNULL
       },
       /* "Paste" (key-equivalent: 'V') */
       {&EditItem[4], 0, 30, IWIDTH, IHEIGHT, 
        ITEMTEXT|COMMSEQ|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&EditText[3], NULL,  'V', NULL, MENUNULL
       },
       /* "Erase All" (disabled) */
       {NULL,         0, 40, IWIDTH, IHEIGHT, 
        ITEMTEXT|HIGHCOMP, 0,
        (APTR)&EditText[4], NULL, NULL, NULL, MENUNULL
       }
   };

/* IntuiText for the Print Sub-Items */
struct IntuiText PrtText[] =
    {
       {2, 1, JAM2,2,1, NULL, "NLQ",   NULL},
       {2, 1, JAM2,2,1, NULL, "Draft", NULL}
    };

/* Print Sub-Items */
struct MenuItem PrtItem[] =
    {
       /* "NLQ" */
       {&PrtItem[1], 61,-1, IWIDTH, IHEIGHT, ITEMTEXT|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&PrtText[0], NULL, NULL, NULL, MENUNULL
       },
       /* "Draft" */
       {NULL,        61, 9, IWIDTH, IHEIGHT, ITEMTEXT|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&PrtText[1], NULL, NULL, NULL, MENUNULL
       }
    };

/*   Uses the >> character to indicate a sub-menu 
 *   \273 Octal, 0xBB Hex or ALT-0 from the Keyboard
 */

/* Project Menu Item IntuiText */
struct IntuiText ProjText[] =
    {
       {2, 1, JAM2,2,1, NULL, "  New",         NULL},
       {2, 1, JAM2,2,1, NULL, "  Open...",     NULL},
       {2, 1, JAM2,2,1, NULL, "  Save",        NULL},
       {2, 1, JAM2,2,1, NULL, "  Save As...",  NULL},
       {2, 1, JAM2,2,1, NULL, "\273 Print",   NULL},
       {2, 1, JAM2,2,1, NULL, "  About...",    NULL},
       {2, 1, JAM2,2,1, NULL, "  Quit",        NULL}
    };

/* Project Menu Items */
struct MenuItem ProjItem[] =
    {
       /* "New" */
       {&ProjItem[1],0, 0, IWIDTH, IHEIGHT,
        ITEMTEXT|ITEMENABLED|HIGHCOMP, 0, 
        (APTR)&ProjText[0], NULL, NULL, NULL, MENUNULL
       },
       /* "Open..." (key-equivalent: 'O') */
       {&ProjItem[2],0,10, IWIDTH, IHEIGHT,
        ITEMTEXT|COMMSEQ|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&ProjText[1], NULL, 'O', NULL, MENUNULL
       },
       /* "Save" (key-equivalent: 'S') */
       {&ProjItem[3],0,20, IWIDTH, IHEIGHT,
        ITEMTEXT|COMMSEQ|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&ProjText[2], NULL, 'S', NULL, MENUNULL
       },
       /* "Save As..." */
       {&ProjItem[4],0,30, IWIDTH, IHEIGHT,
        ITEMTEXT|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&ProjText[3], NULL, NULL, NULL, MENUNULL
       },
       /* "Print" (has sub-menu) */
       {&ProjItem[5],0,40, IWIDTH, IHEIGHT,
        ITEMTEXT|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&ProjText[4], NULL, NULL, &PrtItem[0], MENUNULL
       },
       /* "About..." */
       {&ProjItem[6],0,50, IWIDTH, IHEIGHT,
        ITEMTEXT|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&ProjText[5], NULL, NULL, NULL, MENUNULL
       },
       /* "Quit" (key-equivalent: 'Q' */
       {NULL,        0,60, IWIDTH, IHEIGHT, 
        ITEMTEXT|COMMSEQ|ITEMENABLED|HIGHCOMP, 0,
        (APTR)&ProjText[6], NULL, 'Q', NULL, MENUNULL
       }
    };

/* Menu Titles */
struct Menu Menus[] =
    {
        {&Menus[1],  0, 0, 63, 0, MENUENABLED, "Project",    &ProjItem[0]},
        {&Menus[2], 70, 0, 39, 0, MENUENABLED, "Edit",       &EditItem[0]},
        {NULL,     120, 0, 88, 0, MENUENABLED, "Preferences",&PrefItem[0]},
    };

/* A pointer to the first menu for easy reference */
struct Menu *FirstMenu = &Menus[0];

/* Window Text for Explanation of Program */
struct IntuiText WinText[] =
    {
       {3, 0, JAM2, 54, 28, &TOPAZ80, "How to do a Menu",        NULL},
       {3, 0, JAM2, 70, 38, &TOPAZ80, "(with Style)",     &WinText[0]}
    };

/* NewWindow structure for our example window */
struct NewWindow NewWindow =
    {
    202,66, 234,66, 2,1, MENUPICK|CLOSEWINDOW,
    WINDOWDRAG|WINDOWDEPTH|WINDOWCLOSE|ACTIVATE|NOCAREREFRESH,
    NULL, NULL, "Menus", NULL, NULL, 0, 0, -1, -1, WBENCHSCREEN
    };
