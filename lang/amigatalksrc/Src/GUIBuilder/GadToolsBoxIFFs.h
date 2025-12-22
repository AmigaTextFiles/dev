/****h* GadToolsBoxIFFs.h [1.0] ****************************************
*
* NAME
*    GadToolsBoxIFFs.h
*
* DESCRIPTION
*    This file contains the structure definitions that GadToolsBox V2.0
*    writes as IFF Chunks (there are more, but we can ignore them).
************************************************************************
*
*/

#ifndef  GADTOOLSBOXIFFS_H
# define GADTOOLSBOXIFFS_H

# include <stdio.h>

# include <exec/types.h>

# include <AmigaDOSErrs.h>

# include <libraries/iffparse.h>
# include <libraries/gadtools.h>

# include <intuition/intuition.h>

# include <utility/tagitem.h>

// ID_FORM already defined.

# define ID_GXWD MAKE_ID('G','X','W','D')
# define ID_WDDA MAKE_ID('W','D','D','A') // Window Definitions Attributes

# define ID_GXTX MAKE_ID('G','X','T','X')
# define ID_ITXT MAKE_ID('I','T','X','T') // IntuiText Definitions Attributes

# define ID_GXGA MAKE_ID('G','X','G','A')
# define ID_GADA MAKE_ID('G','A','D','A') // Gadget Definitions Attributes

# define ID_GXBX MAKE_ID('G','X','B','X')
# define ID_BBOX MAKE_ID('B','B','O','X') // BevelBox Attributes

# define ID_GXMN MAKE_ID('G','X','M','N') 
# define ID_MEDA MAKE_ID('M','E','D','A') // Menu Definitions Attributes

# define ID_GXUI MAKE_ID('G','X','U','I') // Header Chunks (ignored for now)
# define ID_GGUI MAKE_ID('G','G','U','I') // Project level chunk
# define ID_GTCO MAKE_ID('G','T','C','O') // Copyright chunk
# define ID_GENC MAKE_ID('G','E','N','C') // C-generation chunk
# define ID_GENA MAKE_ID('G','E','N','A') // Assy-generation chunk
# define ID_PREF MAKE_ID('P','R','E','F') // Preferences
# define ID_PRHD MAKE_ID('P','R','H','D') // PrefHeader

# ifdef __amigaos4__
#  define MEMATTR __attribute__ ((__packed__))
# else
#  define MEMATTR
# endif

PUBLIC struct winChunk {

//   ULONG wc_FormID;           // 'F','O','R','M'
//   ULONG wc_FileSize;
//   ULONG wc_GXWD;             // ID_GXWD
//   ULONG wc_WDDA;             // ID_WDDA
//   ULONG wc_ChunkSize;        // 0x15c = 348 Bytes
   
   UBYTE wc_ProjectName[34] MEMATTR;  // 34 0x14 to 0x35
   
   UBYTE wc_WindowTitle[80] MEMATTR;  // 114 0x36 to 0x85 WA_Title
   
   UBYTE wc_ScreenTitle[78] MEMATTR;  // 192 0x86 to 0xD5 WA_ScreenTitle
   
   ULONG wc_Pad1 MEMATTR;             // 196 Unknown value is usually 0x0000000E
    
   UWORD wc_StartID MEMATTR;          // 198 Ignore this
   
   ULONG wc_IDCMPFlags MEMATTR;       // 202 WA_IDCMP

   ULONG wc_Flags MEMATTR;            // 206 WA_Flags
   
   UWORD wc_Pad2 MEMATTR;             // 208 Usually 0x0000
   
   UWORD wc_InnerFlags MEMATTR;       // 210 
   
   UWORD wc_InnerWidth MEMATTR;       // 212 WA_InnerWidth
   UWORD wc_InnerHeight MEMATTR;      // 214 WA_InnerHeight

   UWORD wc_Pad3 MEMATTR;             // 216 ?????????
   
   UWORD wc_MouseQueue MEMATTR;       // 218 for WA_MouseQueue
   UWORD wc_ReportQueue MEMATTR;      // 220 for WA_RptQueue
   
   ULONG wc_Pad4 MEMATTR;             // 224 Usually 0x00000002
   UWORD wc_Pad5 MEMATTR;             // 226 Usually 0x0014
   UWORD wc_Pad6 MEMATTR;             // 228 Usually 0x0000
   ULONG wc_Pad7 MEMATTR;             // 232 Usually 0x00000000    
   ULONG wc_Pad8 MEMATTR;             // 236 Usually 0x00000000
   
   struct TagItem wc_Tags[14] MEMATTR; // 348
};

PUBLIC struct intuiChunk {
    
//   ULONG ic_FormID;
//   ULONG ic_FileSize;
//   ULONG ic_GXTX;
//   ULONG ic_ITXT;
//   ULONG ic_ChunkSize; // 108 = 0x6C
   
   UBYTE ic_FrontPen MEMATTR;
   UBYTE ic_BackPen MEMATTR;
   
   UBYTE ic_DrawMode MEMATTR;
   UBYTE ic_Pad1 MEMATTR;
   
   UWORD ic_LeftEdge MEMATTR;
   UWORD ic_TopEdge MEMATTR;
   
   ULONG ic_Pad2 MEMATTR;     // struct TextAttr  *ITextFont??
   ULONG ic_Pad3 MEMATTR;     // struct IntuiText *NextText??
   ULONG ic_Pad4 MEMATTR;
   
   UBYTE ic_IText[80] MEMATTR;
};

PUBLIC struct bevelChunk {

//   ULONG bc_FormID;
//   ULONG bc_FileSize; // 0x16 = 22 bytes for one box, add 18 for each additional box
//   ULONG bc_GXBX;
//   ULONG bc_BBOX;
//   ULONG bc_ChunkSize; // 0x0A for BBOXes

   UWORD bc_LeftEdge MEMATTR;
   UWORD bc_TopEdge MEMATTR;
   UWORD bc_Width MEMATTR;
   UWORD bc_Height MEMATTR;
   UWORD bc_Flags MEMATTR;    // 0 = Normal, 1 = GTBB_Recessed, 2 = DropBox
};

PUBLIC struct gadgetChunk {

//   ULONG gc_FormID;
//   ULONG gc_FileSize;
//   ULONG gc_GXGA;
//   ULONG gc_GADA;
//   ULONG gc_ChunkSize; // 0x13C (max) = 316 Bytes

   UWORD gc_LeftEdge MEMATTR;
   UWORD gc_TopEdge MEMATTR;
   UWORD gc_Width MEMATTR;
   UWORD gc_Height MEMATTR; // 8
   
   ULONG gc_Pad1 MEMATTR;
   ULONG gc_Pad2 MEMATTR;   // 16
   
   UWORD gc_GadgetID MEMATTR;
   UWORD gc_Pad3 MEMATTR;   // 20

   UWORD gc_Flags MEMATTR;  // 22
   ULONG gc_Pad4 MEMATTR;   // 26
   ULONG gc_Pad5 MEMATTR;   // 30
   
   UBYTE gc_GadgetText[80] MEMATTR; 
   UBYTE gc_SrcLabel[32] MEMATTR;
   
   ULONG gc_Pad6 MEMATTR;            // Usually 0x00000002

   UWORD gc_Pad7 MEMATTR;
   UWORD gc_Type MEMATTR;
   UWORD gc_NumberOfTags MEMATTR; // 152

   ULONG gc_Pad9 MEMATTR;
   ULONG gc_Pad10[3] MEMATTR; // 164
   
   struct TagItem gc_Tags[11] MEMATTR; // Maximum size

   UBYTE          gc_Pad11 MEMATTR; // 253
   UBYTE          gc_FmtStr[ 0x3F ] MEMATTR; // 316, For the Slider Type only
   
   /* The number of Tags required by each Gadget Type is not the same.
   ** This is how many each Kind of GadTools Gadget uses in GadToolsBox:
   **
   **   GENERIC_KIND:    1
   **   BUTTON_KIND:     2
   **   CHECKBOX_KIND:   3
   **   INTEGER_KIND:    8
   **   LISTVIEW_KIND:   6
   **   MX_KIND:         4
   **   NUMBER_KIND:     3
   **   CYCLE_KIND:      4
   **   PALETTE_KIND:    8
   **   SCROLLER_KIND:   10
   **   SLIDER_KIND:     11
   **   STRING_KIND:     6
   **   TEXT_KIND:       3
   */
};

PUBLIC struct menuChunk {

//   ULONG m_FormID;
//   ULONG m_FileSize;
//   ULONG m_GXMN;
//   ULONG m_MEDA;
//   ULONG m_ChunkSize;            // == 0x8A = 138 Bytes
   
   UWORD m_Type           MEMATTR; // 0x100 = TITLE, 0x200 = ITEM, 0x300 = SUBITEMS
   ULONG m_BarValue       MEMATTR; // == NM_BARLABEL (0xFFFFFFFF) for NM_BARLABELs
   ULONG m_Pad1           MEMATTR;
   UWORD m_Flags          MEMATTR;
   
   ULONG m_Pad2           MEMATTR;
   ULONG m_Pad3           MEMATTR;
   UBYTE m_MenuString[32] MEMATTR; // == NM_BARLABEL for NM_BARLABELs
   
   ULONG m_Pad5[12]       MEMATTR;
   UBYTE m_SrcLabel[32]   MEMATTR; // For MenuItems & SubItems only.

   UWORD m_Pad6           MEMATTR; // For MenuItems & SubItems only.
   UBYTE m_CommKey[3]     MEMATTR; // Only m_CommKey[0] has something in it (for english)
   UBYTE m_Pad7           MEMATTR; // Usually 0x02
};

PUBLIC struct projectChunk {

//   ULONG pc_FormID;
//   ULONG pc_FileSize;
//   ULONG pc_GXUI;
//   ULONG pc_GGUI;
//   ULONG pc_ChunkSize;                 // 0x252 = 594 Bytes

   ULONG pc_Pad1 MEMATTR;                // Usually 0x5
   UBYTE pc_ScreenTagsTitle[80] MEMATTR; // 84
   
   ULONG pc_Pad2 MEMATTR;                // 90
   UWORD pc_ScrWidth MEMATTR;
   UWORD pc_ScrHeight MEMATTR;           // 94
   
   UWORD pc_Pad3 MEMATTR;                // Usually 0x10
   ULONG pc_ScreenModeID MEMATTR;        // 104
   UWORD pc_Pad4 MEMATTR;                // 106

   ULONG pc_Pad5[ 71 ] MEMATTR;          // 390 Junk I'm going to ignore
   
   UBYTE pc_FontName[32] MEMATTR;        // 422
   
   ULONG pc_Pad6[25] MEMATTR;            // 522  
   UWORD pc_FontSize MEMATTR;
   UWORD pc_Pad7 MEMATTR;                // 526
   ULONG pc_Pad8 MEMATTR;                // 530 
   
   ULONG pc_Pad9[8] MEMATTR;             // 562 Usually zeroes
   ULONG pc_Pad10 MEMATTR;
   ULONG pc_Pad11 MEMATTR;               // 570 Usually 2
   UWORD pc_ScreenWidth MEMATTR;
   UWORD pc_ScreenHeight MEMATTR;        // 574 
   ULONG pc_Pad12 MEMATTR;               // 578
   
   UWORD pc_GridX MEMATTR;               // 580
   UWORD pc_GridY MEMATTR;
   
   ULONG pc_Pad13[4] MEMATTR;            // 598  
   UWORD pc_Pad14 MEMATTR;               // 600
};

PUBLIC struct authorChunk {

//   ULONG ac_FormID;
//   ULONG ac_FileSize;
//   ULONG ac_PREF;
//   ULONG ac_PRHD;
   
//   ULONG ac_Pad1;        // 0x6
//   UWORD ac_pad2;
//   ULONG ac_Pad3;
   
//   ULONG ac_GTCO;
//   ULONG ac_ChunkSize;               // 0xDC = 220 Bytes
   ULONG ac_Pad4 MEMATTR;
   ULONG ac_Pad5 MEMATTR;              // 8
   
   UWORD ac_Pad6 MEMATTR;              // Usually 1
   UWORD ac_pad7 MEMATTR;              // Usually 2
   UBYTE ac_AuthorName[64] MEMATTR;    // 76
   UBYTE ac_IconPathName[128] MEMATTR; // 204
   
   ULONG ac_Pad8[4] MEMATTR;           // 220  
};

PUBLIC struct gencChunk {

//   ULONG gcc_FormID;
//   ULONG gcc_FileSize;
//   ULONG gcc_PREF;
//   ULONG gcc_PRHD;
   
//   ULONG gcc_Pad1;       // chunkSize = 6
//   ULONG gcc_Pad2;
//   UWORD gcc_Pad3;
//   ULONG gcc_GENC;     
//   ULONG gcc_ChunkSize;        // 0xF4 = 244 Bytes
   ULONG gcc_Pad4 MEMATTR;
   ULONG gcc_Pad5 MEMATTR;       // 8 
   UWORD gcc_Pad6 MEMATTR;       // usually 1
   UWORD gcc_Pad7 MEMATTR;       // usaully 2
   
   UBYTE gcc_AuthorName[64] MEMATTR;     // 76
   UBYTE gcc_IconPathName[128] MEMATTR;  // 204
   UWORD gcc_Pad8 MEMATTR;               // 206
   ULONG gcc_Pad9[4] MEMATTR;            // 222
   UWORD gcc_CheckBoxes MEMATTR;         // 224
   UWORD gcc_Pad10 MEMATTR;              // 226
   ULONG gcc_Pad11[4] MEMATTR;           // 242
   UWORD gcc_Pad12 MEMATTR;              // 244  
};

PUBLIC struct genaChunk {

//   ULONG gac_FormID;
//   ULONG gac_FileSize;
//   ULONG gac_PREF;
//   ULONG gac_PRHD;

//   ULONG gac_Pad1;      // chunkSize = 6
//   ULONG gac_Pad2;
//   UWORD gac_Pad3;
   
//   ULONG gac_GENA;
//   ULONG gac_ChunkSize;       // 0xF4 = 244 Bytes
   ULONG gac_Pad4 MEMATTR;
   ULONG gac_Pad5 MEMATTR;
   UWORD gac_Pad6 MEMATTR;      // usaully 1
   UWORD gac_Pad7 MEMATTR;      // Usually 2

   UBYTE gac_AuthorName[64] MEMATTR;
   UBYTE gac_IconPathName[128] MEMATTR;

   ULONG gac_Pad8[2] MEMATTR;

   ULONG gac_CheckBoxes MEMATTR;

   ULONG gac_Pad9[5] MEMATTR;
};
           
#endif

/* ---------------- END of GadToolsBoxIFFs.h file! --------------- */
