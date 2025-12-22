/****h* Z80Simulator/SetBrkPt.c [2.5] ****************************
*
* NAME
*    SetBrkPt.c
*
* DESCRIPTION
*    Set BreakPoint requester for the Z80 Simulator program.
*
* RETURNS
*    0 for success, -1 for failure.
*
* Functional interface:
*
*   PUBLIC int  HandleSetBreakPt( char *breakbuffer );
*   PUBLIC int  CheckBkpt( void );
*   PUBLIC void InitBKPTS( void );
*
* GUI Designed by : Jim Steichen
******************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Z80Sim.h"
#include "Z80Vars.h"       // for status variable.

#define   ALLOCATE      1
# include "Z80BKPT.h"
#undef    ALLOCATE 

#define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)

#define BrkListView  0
#define OkayBt       1
#define AbortBt      2
#define RegRadioBt   3
#define Str8Bit      4
#define Str16Bit     5

#define SBP_CNT      6

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
/* ----------------------------------- */

/* ----------------    ListView contents: */
VISIBLE struct List    BreakPtList;
VISIBLE struct Node    BreakPtItems[ MAXBKPT + 1 ];
VISIBLE char           *BrkStrs = NULL; // [ MAXBKPT ][ BREAKLINE_LENGTH ];
/* ----------------                       */
#define BREAK_STR( i ) (BrkStrs + i * BREAKLINE_LENGTH)
 
VISIBLE unsigned short BkptNum  = 0;

/* where is the last breakpoint in the list? */

VISIBLE int            LastBkpt = 0;  


PRIVATE struct Window       *SBPWnd    = NULL;
PRIVATE struct Gadget       *SBPGList  = NULL;
PRIVATE struct IntuiMessage  SBPMsg;
PRIVATE struct Gadget       *SBPGadgets[6];

PRIVATE UWORD  SBPLeft   = 210;
PRIVATE UWORD  SBPTop    = 115;
PRIVATE UWORD  SBPWidth  = 430;
PRIVATE UWORD  SBPHeight = 364;
PRIVATE UBYTE *SBPWdt    = "Set a BreakPoint:";

PRIVATE UBYTE *RegBtLabels[] = {

   (UBYTE *)"A ", (UBYTE *)"B ",
   (UBYTE *)"C ", (UBYTE *)"D ",
   (UBYTE *)"E ", (UBYTE *)"F ",
   (UBYTE *)"H ", (UBYTE *)"L ",
   (UBYTE *)"A'", (UBYTE *)"B'",
   (UBYTE *)"C'", (UBYTE *)"D'",
   (UBYTE *)"E'", (UBYTE *)"F'",
   (UBYTE *)"H'", (UBYTE *)"L'",
   (UBYTE *)"IX", (UBYTE *)"IY",
   (UBYTE *)"SP", (UBYTE *)"PC",
   (UBYTE *)"I ", (UBYTE *)"R ",
   NULL 
};


PRIVATE struct IntuiText SBPIText[] = {

   2, 0, JAM1, 282,   8, &topaz8, (UBYTE *) "Select Register:", &SBPIText[1],
   2, 0, JAM1,  42, 260, &topaz8, (UBYTE *) "Hex Trigger Value:", NULL 
};

PRIVATE UWORD SBPGTypes[] = {

   LISTVIEW_KIND, BUTTON_KIND,
   BUTTON_KIND,   MX_KIND,
   STRING_KIND,   STRING_KIND
};

PRIVATE int ListViewClicked( int itemnum  );
PRIVATE int RadioClicked(    int whichreg );
PRIVATE int Str8BitClicked(  int dummy    );
PRIVATE int Str16BitClicked( int dummy    );
PRIVATE int OkayClicked(     int dummy    );
PRIVATE int AbortClicked(    int dummy    );

PRIVATE struct NewGadget SBPNGad[] = {

   7,    16, 268, 240, (UBYTE *)"BreakPoints:", NULL, BrkListView, 
   PLACETEXT_ABOVE | NG_HIGHLABEL, NULL, (APTR) ListViewClicked,
   
   7,   335,  62,  21, (UBYTE *)" _DONE ",      NULL, OkayBt, 
   PLACETEXT_IN, NULL, (APTR) OkayClicked,
   
   349, 335,  62,  21, (UBYTE *)" _ABORT ",     NULL, AbortBt, 
   PLACETEXT_IN, NULL, (APTR) AbortClicked,
   
   341,  24,  17,   9,                    NULL, NULL, RegRadioBt, 
   PLACETEXT_LEFT, NULL, (APTR) RadioClicked,
   
   84,  279,  60,  15, (UBYTE *)"8-Bit:",       NULL, Str8Bit, 
   PLACETEXT_LEFT, NULL, (APTR) Str8BitClicked,
   
   84,  301,  60,  15, (UBYTE *)"16-Bit:",      NULL, Str16Bit, 
   PLACETEXT_LEFT, NULL, (APTR) Str16BitClicked
};

PRIVATE ULONG SBPGTags[] = {

   (GTLV_ShowSelected), NULL, (TAG_DONE),

   (GT_Underscore),      '_', (TAG_DONE),
   (GT_Underscore),      '_', (TAG_DONE),

   (GTMX_Labels), (ULONG) &RegBtLabels[ 0 ], (GTMX_Spacing), 3, (TAG_DONE),

   (GA_TabCycle), FALSE, (GTST_MaxChars), 5, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
   
   (GA_TabCycle), FALSE, (GTST_MaxChars), 5,
   (STRINGA_Justification), (GACT_STRINGCENTER), 
   (GA_Disabled), TRUE, (TAG_DONE)
};


/* -------------------- Start of functions: --------------------- */


PUBLIC void InitBKPTS( void )        /* called from main() */
{
   short i, j;

   for (i = 0; i < MAXBKPT; i++)  
      {
      breakpoint[i].BkptIndx = LAST_BKPT;
      breakpoint[i].BkptFlag = CLRBKPT;

      for (j = 0; j < 28; j++)
         breakpoint[i].reg[j] = RESET_BKPT;
      }

   /* Set up the Breakpoint list & node structures for the ListViewer: */

   for (i = 0; i < MAXBKPT; i++)
      BreakPtItems[i].ln_Name = BREAK_STR( i );

   NewList( &BreakPtList );

   for (i = 0; i < MAXBKPT; i++)
      AddTail( &BreakPtList, &BreakPtItems[i] );

   LastBkpt = 0;
   BkptNum  = 0;

   return;
}

/* --------------- CheckBkpt()-related code: -------------------- */

PRIVATE void Form_RegStr( int num, char *buf );

/* convert the register number & the breakpoint index into a string
** that tells the user which register & what value the breakpoint is
** breaking for.
*/

PRIVATE int Flag_BKPT( int regnum, int whichbreak )
{
   char  nil_FB[ 20 ], *outstr = &nil_FB[0];
   char  nil_FB2[ 5 ], *valstr = &nil_FB2[0];

   (void) strcpy( outstr, "Reg: " );

   Form_RegStr( regnum, outstr );  // Convert regnum to a register string.

   if (regnum >= 0 && regnum < 18)   
      {
      // 8-bit register value to hex string conversion:
      breakpoint[ whichbreak ].reg[ regnum ] &= BYTE_MASK;

      to_hexstr( breakpoint[ whichbreak ].reg[ regnum ], valstr, 2 );
      }
   else if (regnum > 17 && regnum < 28) // 16-bit register:
      to_hexstr( breakpoint[ whichbreak ].reg[ regnum ], valstr, 4 );

   (void) strcat( outstr, " = " );
   (void) strcat( outstr, valstr );
   (void) strcat( outstr, ".  Press ABORT to halt!" );

   if (Handle_Problem( outstr, "Hit a BreakPoint!!", NULL ) < 0)
      return( -1 );  // User asked for a HALT!
   else
      return( 0 );
}

/* called by CheckBkpt */

PRIVATE int CompareDReg( int r1, int r2, UWORD newval ) 
{
   IMPORT UBYTE    reg[];

   UWORD  maskhi = 0xFF00, masklo = 0x00FF;

   if (( ((maskhi & newval) >> 8) == reg[r1]) &&
         ((masklo & newval) == reg[r2]))
      return( TRUE );

   return( FALSE );      /* no match found! */
}


/* called from (main()) & (Execute_Instruction()) */

PUBLIC int CheckBkpt( void )
{
   IMPORT UBYTE    reg[];
   IMPORT UWORD    dreg[];

   short    index = 0;
   UWORD    whichreg;

   while ((whichreg = breakpoint[index].BkptIndx) != LAST_BKPT
           && index < MAXBKPT)
      {
      if (breakpoint[ index ].BkptFlag == CLRBKPT)   
         {
         /* skip over disabled bkpts */
         index++;
         continue;
         }

      if (whichreg >= 0 && whichreg < 18)  
         {
         // 8-bit register checking:
         if (reg[ whichreg ] ==
                        (breakpoint[ index ].reg[ whichreg ] & BYTE_MASK))
            if (Flag_BKPT( whichreg, index ) < 0)
               status = HALT;
         }
      else if (whichreg > 17 && whichreg < 28)
         {
         // 16-bit register values:
         switch (whichreg)   
            {    
            /* translate whichreg to dreg index */
            case  REGIX:
               if (dreg[ IX ] == breakpoint[ index ].reg[ REGIX ])
                  if (Flag_BKPT( whichreg, index ) < 0)
                     status = HALT;
               break;

            case  REGIY:
               if (dreg[ IY ] == breakpoint[ index ].reg[ REGIY ])
                  if (Flag_BKPT( whichreg, index ) < 0)
                     status = HALT;
               break;

            case  REGSP:
               if (dreg[ SP ] == breakpoint[ index ].reg[ REGSP ])
                  if (Flag_BKPT( whichreg, index ) < 0)
                     status = HALT;
               break;

            case  REGPC:
               if (dreg[ PC ] == breakpoint[ index ].reg[ REGPC ])
                  if (Flag_BKPT( whichreg, index ) < 0)
                     status = HALT;
               break;
            }
         }
      index++;    /* check next breakpoint */
      }

   return( index );
}

/* ScanBkpt() is NOT currently being used! */

PRIVATE int ScanBkpt( int start )     /* Find end of Breakpoint List */
{
   short  breaknum;

   breaknum = start;
   while (breakpoint[ breaknum ].BkptIndx != LAST_BKPT)
      breaknum++;

   LastBkpt = breaknum;
   return( breaknum );
}

/* ------------------------------------------------------------
** Part of making the breakpoint string: 
*/

PRIVATE void Form_RegStr( int num, char *buf )
{
   switch (num)
      {
      case A:      (void) strcat( buf, "A " );  break;
      case A+1:    (void) strcat( buf, "A'" );  break;
      case B:      (void) strcat( buf, "B " );  break;
      case B+1:    (void) strcat( buf, "B'" );  break;
      case C:      (void) strcat( buf, "C " );  break;
      case C+1:    (void) strcat( buf, "C'" );  break;
      case D:      (void) strcat( buf, "D " );  break;
      case D+1:    (void) strcat( buf, "D'" );  break;
      case E:      (void) strcat( buf, "E " );  break;
      case E+1:    (void) strcat( buf, "E'" );  break;
      case H:      (void) strcat( buf, "H " );  break;
      case H+1:    (void) strcat( buf, "H'" );  break;
      case L:      (void) strcat( buf, "L " );  break;
      case L+1:    (void) strcat( buf, "L'" );  break;
      case F:      (void) strcat( buf, "F " );  break;
      case F+1:    (void) strcat( buf, "F'" );  break;
      case I:      (void) strcat( buf, "I " );  break;
      case R:      (void) strcat( buf, "R " );  break;
/*
      case REGBC:  (void) strcat( buf, "BC" );  break;
      case REGBCP: (void) strcat( buf, "BC'" ); break;
      case REGDE:  (void) strcat( buf, "DE" );  break;
      case REGDEP: (void) strcat( buf, "DE'" ); break;
      case REGHL:  (void) strcat( buf, "HL" );  break;
      case REGHLP: (void) strcat( buf, "HL'" ); break;
*/
      case REGIX:  (void) strcat( buf, "IX" );  break;
      case REGIY:  (void) strcat( buf, "IY" );  break;
      case REGSP:  (void) strcat( buf, "SP" );  break;
      case REGPC:  (void) strcat( buf, "PC" );  break;
      default:     return;
      }
   return;
}


PRIVATE char   *s1       = "#: ",   *REGSTR   = " reg ";
PRIVATE char   *DREGSTR  = "dreg ", *VALUESTR = "  value: ";
PRIVATE char   *off      = "** ";


PRIVATE void Form_Element( int index, char *line )
{
   char   nil[5], *temp = &nil[0];
   int    BreakIndex;

   BreakIndex = breakpoint[ index ].BkptIndx;

   if (breakpoint[ index ].BkptFlag == CLRBKPT)
      (void) strcpy( line, off );    /* Show disabled breakpoint */
   else
      (void) strcpy( line, s1 );

   itoa( index, temp );
   (void) strcat( line, temp );
   (void) strcat( line, " - " );

   if (BreakIndex >= 0 && BreakIndex < 18)
      (void) strcat( line, REGSTR );     /* Single reg' breakpoint */
   else
      (void) strcat( line, DREGSTR );


   Form_RegStr( BreakIndex, line );
   (void) strcat( line, "  " );

   switch (BreakIndex)
      {
      case   A:      to_hexstr( breakpoint[ index ].reg[A], temp, 4 );
                     breakpoint[ index ].reg[A]   &= BYTE_MASK;
                     break;
      case   A+1:    to_hexstr( breakpoint[ index ].reg[A+1], temp, 4 );
                     breakpoint[ index ].reg[A+1] &= BYTE_MASK;
                     break;
      case   B:      to_hexstr( breakpoint[ index ].reg[B], temp, 4 );
                     breakpoint[ index ].reg[B]   &= BYTE_MASK;
                     break;
      case   B+1:    to_hexstr( breakpoint[ index ].reg[B+1], temp, 4 );
                     breakpoint[ index ].reg[B+1] &= BYTE_MASK;
                     break;
      case   C:      to_hexstr( breakpoint[ index ].reg[C], temp, 4 );
                     breakpoint[ index ].reg[C]   &= BYTE_MASK;
                     break;
      case   C+1:    to_hexstr( breakpoint[ index ].reg[C+1], temp, 4 );
                     breakpoint[ index ].reg[C+1] &= BYTE_MASK;
                     break;
      case   D:      to_hexstr( breakpoint[ index ].reg[D], temp, 4 );
                     breakpoint[ index ].reg[D]   &= BYTE_MASK;
                     break;
      case   D+1:    to_hexstr( breakpoint[ index ].reg[D+1], temp, 4 );
                     breakpoint[ index ].reg[D+1] &= BYTE_MASK;
                     break;
      case   E:      to_hexstr( breakpoint[ index ].reg[E], temp, 4 );
                     breakpoint[ index ].reg[E]   &= BYTE_MASK;
                     break;
      case   E+1:    to_hexstr( breakpoint[ index ].reg[E+1], temp, 4 );
                     breakpoint[ index ].reg[E+1] &= BYTE_MASK;
                     break;
      case   H:      to_hexstr( breakpoint[ index ].reg[H], temp, 4 );
                     breakpoint[ index ].reg[H]   &= BYTE_MASK;
                     break;
      case   H+1:    to_hexstr( breakpoint[ index ].reg[H+1], temp, 4 );
                     breakpoint[ index ].reg[H+1] &= BYTE_MASK;
                     break;
      case   L:      to_hexstr( breakpoint[ index ].reg[L], temp, 4 );
                     breakpoint[ index ].reg[L]   &= BYTE_MASK;
                     break;
      case   L+1:    to_hexstr( breakpoint[ index ].reg[L+1], temp, 4 );
                     breakpoint[ index ].reg[L+1] &= BYTE_MASK;
                     break;
      case   F:      to_hexstr( breakpoint[ index ].reg[F], temp, 4 );
                     breakpoint[ index ].reg[F]   &= BYTE_MASK;
                     break;
      case   F+1:    to_hexstr( breakpoint[ index ].reg[F+1], temp, 4 );
                     breakpoint[ index ].reg[F+1] &= BYTE_MASK;
                     break;
      case   I:      to_hexstr( breakpoint[ index ].reg[I], temp, 4 );
                     breakpoint[ index ].reg[I]   &= BYTE_MASK;
                     break;
      case   R:      to_hexstr( breakpoint[ index ].reg[R], temp, 4 );
                     breakpoint[ index ].reg[R]   &= BYTE_MASK;
                     break;
/*
      case   REGBC:  to_hexstr( breakpoint[ index ].reg[REGBC], temp, 4 );
                     break;
      case   REGBCP: to_hexstr( breakpoint[ index ].reg[REGBCP], temp, 4 );
                     break;
      case   REGDE:  to_hexstr( breakpoint[ index ].reg[REGDE], temp, 4 );
                     break;
      case   REGDEP: to_hexstr( breakpoint[ index ].reg[REGDEP], temp, 4 );
                     break;
      case   REGHL:  to_hexstr( breakpoint[ index ].reg[REGHL], temp, 4 );
                     break;
      case   REGHLP: to_hexstr( breakpoint[ index ].reg[REGHLP], temp, 4 );
                     break;
*/
      case   REGIX:  to_hexstr( breakpoint[ index ].reg[REGIX], temp, 4 );
                     break;
      case   REGIY:  to_hexstr( breakpoint[ index ].reg[REGIY], temp, 4 );
                     break;
      case   REGSP:  to_hexstr( breakpoint[ index ].reg[REGSP], temp, 4 );
                     break;
      case   REGPC:  to_hexstr( breakpoint[ index ].reg[REGPC], temp, 4 );

      default:  /*   can't happen! */  break;
      }
   (void) strcat( line, VALUESTR );
   (void) strcat( line, temp );

   return; 
}


/************************************************************************/
/*                       SetBreakPt()-related code:                     */
/************************************************************************/

PRIVATE int  WhichRegSelected = -1;     /* The A Register. */
PRIVATE char VN[5], *ValueStr = &VN[0]; /* The register value. */


PRIVATE int GetIndexFromString( char *regstr )
{
   if (strcmp( regstr, "A" ) == 0)
      return( 0 );

   if (strcmp( regstr, "B" ) == 0)
      return( 1 );

   if (strcmp( regstr, "C" ) == 0)
      return( 2 );

   if (strcmp( regstr, "D" ) == 0)
      return( 3 );

   if (strcmp( regstr, "E" ) == 0)
      return( 4 );

   if (strcmp( regstr, "F" ) == 0)
      return( 5 );

   if (strcmp( regstr, "H" ) == 0)
      return( 6 );

   if (strcmp( regstr, "L" ) == 0)
      return( 7 );

   if (strcmp( regstr, "A'" ) == 0)
      return( 8 );

   if (strcmp( regstr, "B'" ) == 0)
      return( 9 );

   if (strcmp( regstr, "C'" ) == 0)
      return( 10 );

   if (strcmp( regstr, "D'" ) == 0)
      return( 11 );

   if (strcmp( regstr, "E'" ) == 0)
      return( 12 );

   if (strcmp( regstr, "F'" ) == 0)
      return( 13 );

   if (strcmp( regstr, "H'" ) == 0)
      return( 14 );

   if (strcmp( regstr, "L'" ) == 0)
      return( 15 );

   if (strcmp( regstr, "IX" ) == 0)
      return( 16 );

   if (strcmp( regstr, "IY" ) == 0)
      return( 17 );

   if (strcmp( regstr, "SP" ) == 0)
      return( 18 );

   if (strcmp( regstr, "PC" ) == 0)
      return( 19 );

   if (strcmp( regstr, "I" ) == 0)
      return( 20 );
   else             /* (strcmp( regstr, "R" ) == 0) */
      return( 21 );
}


/* Breakpoint string structure:
**
** line ==> '** idx - reg ?  value: ##'
**       or '#: idx - reg ?  value: ##'
**
** line ==> '** idx - dreg ??  value: ####'
**       or '#: idx - dreg ??  value: ####'
**
** ??  ==> register string ==> A, A', SP, PC, IX, IY, BC, BC', I, R
** idx ==> breakpoint number.
** ##  ==> register value.
*/


/* Just highlight the entry that the user clicked on & then
** set the radio buttons & string gadgets accordingly.
*/
   
PRIVATE int ListViewClicked( int itemnum )
{
   int  StartRStr, EndRStr, StartVStr, EndVStr;
   int  i, j, RegIndex, SmallReg;

   char BPN[4], *RegStr = &BPN[0];
   char *TheItem = (char *) BreakPtItems[ itemnum ].ln_Name;

   for (i = 0; i < 4; i++)  // Null out the buffer.
      *(RegStr + i) = '\0';

   if ((EndVStr = strlen( TheItem )) < 1) // Non-existent break string.
      return( (int) TRUE );
             
   if ((StartRStr = str_index( TheItem, "dreg" )) != -1)
      {
      StartRStr += 5;
      SmallReg   = FALSE;
      }
   else
      {
      StartRStr = str_index( TheItem, "reg" ) + 4;
      SmallReg  = TRUE;
      }
      

   if ((EndRStr = str_index( TheItem, "val" )) != -1)
      {
      StartVStr = EndRStr + 7;
      EndRStr  -= 2;
      }
   else // Should never reach this code:
      {
      fprintf( stderr, "%s is a malformed BreakPoint!\n", TheItem ); 
      return( (int) TRUE );
      }


   if (SmallReg == TRUE)
      {
      GT_SetGadgetAttrs( SBPGadgets[ Str8Bit ], SBPWnd, NULL,
                         GTST_String, &TheItem[ StartVStr ],
                         GA_DISABLED, FALSE, TAG_END 
                       );

      GT_SetGadgetAttrs( SBPGadgets[ Str16Bit ], SBPWnd, NULL,
                         GA_DISABLED, TRUE, TAG_END 
                       );
      }
   else
      {
      GT_SetGadgetAttrs( SBPGadgets[ Str16Bit ], SBPWnd, NULL,
                         GTST_String, &TheItem[ StartVStr ],
                         GA_DISABLED, FALSE, TAG_END 
                       );

      GT_SetGadgetAttrs( SBPGadgets[ Str8Bit ], SBPWnd, NULL,
                         GA_DISABLED, TRUE, TAG_END 
                       );
      }
   // Copy only valid Register characters to RegStr buffer:

   for (j = 0, i = StartRStr; i < EndRStr; i++, j++)
      {
      if (*(TheItem + i) != ' ')
         {
         *(RegStr + j) = *(TheItem + i);
         }
      }

   RegIndex = GetIndexFromString( RegStr );

   GT_SetGadgetAttrs( SBPGadgets[ RegRadioBt ], SBPWnd, NULL,
                      GTMX_Active, RegIndex, TAG_END
                    );

   return( (int) TRUE );
}

PRIVATE int RadioClicked( int whichreg )
{
   /* Based on which radio button is pressed, enable or disable the
   ** appropriate String gadget for either 8-bit registers or
   ** 16-bit registers.
   */

   WhichRegSelected = whichreg;
   
   switch (whichreg)
      {
      case 0:  // Register A  selected:
      case 1:  // Register B  selected:
      case 2:  // Register C  selected:
      case 3:  // Register D  selected:
      case 4:  // Register E  selected:
      case 5:  // Register F  selected:
      case 6:  // Register H  selected:
      case 7:  // Register L  selected:
      case 8:  // Register A' selected:
      case 9:  // Register B' selected:
      case 10: // Register C' selected:
      case 11: // Register D' selected:
      case 12: // Register E' selected:
      case 13: // Register F' selected:
      case 14: // Register H' selected:
      case 15: // Register L' selected:
      case 20: // Register I  selected:
      case 21: // Register R  selected:
 
         GT_SetGadgetAttrs( SBPGadgets[ Str16Bit ], SBPWnd, NULL,
                            GA_DISABLED, TRUE, TAG_END 
                          );

         GT_SetGadgetAttrs( SBPGadgets[ Str8Bit ], SBPWnd, NULL,
                            GA_DISABLED, FALSE, TAG_END 
                          );
         break;

      case 16: // Register IX selected:
      case 17: // Register IY selected:
      case 18: // Register SP selected:
      case 19: // Register PC selected:

         GT_SetGadgetAttrs( SBPGadgets[ Str16Bit ], SBPWnd, NULL,
                            GA_DISABLED, FALSE, TAG_END 
                          );

         GT_SetGadgetAttrs( SBPGadgets[ Str8Bit ], SBPWnd, NULL,
                            GA_DISABLED, TRUE, TAG_END 
                          );
         break;
      }
   return( (int) TRUE );
}

PRIVATE int Valid8BitStr  = FALSE;
PRIVATE int Valid16BitStr = FALSE;

/* routine when gadget "8-Bit:" is clicked. */

PRIVATE int Str8BitClicked( int dummy )
{
   int BreakVal = 0;

   (void) stch_i( (char *) StrBfPtr( SBPGadgets[Str8Bit] ), &BreakVal );

   /* Verify correct 8-bit range was entered: */

   if (BreakVal >= 0 && BreakVal <= 0xFF)
      {
      Valid8BitStr = TRUE;
      }
   else
      {
      (void) Handle_Problem( "Invalid 8-bit value!", 
                             "Set Breakpoint Problem:", NULL 
                           );

      GT_SetGadgetAttrs( SBPGadgets[ Str8Bit ], SBPWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      Valid8BitStr = FALSE;
      }

   (void) strcpy( ValueStr, StrBfPtr( SBPGadgets[ Str8Bit ] ) );
   Valid16BitStr = FALSE;
   return( (int) TRUE );
}

/* routine when gadget "16-Bit:" is clicked. */

PRIVATE int Str16BitClicked( int dummy )
{
   int BreakVal = 0;

   (void) stch_i( (char *) StrBfPtr( SBPGadgets[Str16Bit] ), &BreakVal );

   /* Verify correct 16-bit range was entered: */

   if (BreakVal >= 0 && BreakVal <= 0xFFFF)
      {
      Valid16BitStr = TRUE;
      }
   else
      {
      (void) Handle_Problem( "Invalid 16-bit value!", 
                             "Set Breakpoint Problem:", NULL 
                           );

      GT_SetGadgetAttrs( SBPGadgets[ Str16Bit ], SBPWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      Valid16BitStr = FALSE;
      }

   (void) strcpy( ValueStr, StrBfPtr( SBPGadgets[ Str16Bit ] ) );
   Valid8BitStr  = FALSE;
   return( (int) TRUE );
}


PRIVATE void CloseSBPWindow( void )
{
   if (SBPWnd != NULL)    
      {
      CloseWindow( SBPWnd );
      SBPWnd = NULL;
      }

   if (SBPGList != NULL) 
      {
      FreeGadgets( SBPGList );
      SBPGList = NULL;
      }
 
   return;
}

/* Called by Z80Loader functions BrkByte1() & BrkByte2(): */

VISIBLE void MakeBreakString( int whichreg, int value )
{
   breakpoint[ BkptNum ].BkptIndx        = whichreg;
   breakpoint[ BkptNum ].BkptFlag        = NONBKPT;
   breakpoint[ BkptNum ].reg[ whichreg ] = value;
   
   Form_Element( BkptNum, BREAK_STR( BkptNum ) );

   GT_SetGadgetAttrs( SBPGadgets[ BrkListView ], SBPWnd, NULL,
                      GTLV_Labels, ~NULL,
                      TAG_END
                    );

   BreakPtItems[ BkptNum ].ln_Name = BREAK_STR( BkptNum );

   GT_SetGadgetAttrs( SBPGadgets[ BrkListView ], SBPWnd, NULL,
                      GTLV_Labels, &BreakPtList,
                      TAG_END
                    );
   BkptNum++;

   return;
}

PRIVATE int TranslateRegNum( int RadioValue )
{
   int rval = 0;
   
   switch (RadioValue)
      {
      case 0:
         rval = A;
         break;

      case 1:
         rval = B;
         break;

      case 2:
         rval = C;
         break;

      case 3:
         rval = D;
         break;

      case 4:
         rval = E;
         break;

      case 5:
         rval = F;
         break;

      case 6:
         rval = H;
         break;

      case 7:
         rval = L;
         break;

      case 8:
         rval = A + 1;
         break;

      case 9:
         rval = B + 1;
         break;

      case 10:
         rval = C + 1;
         break;

      case 11:
         rval = D + 1;
         break;

      case 12:
         rval = E + 1;
         break;

      case 13:
         rval = F + 1;
         break;

      case 14:
         rval = H + 1;
         break;

      case 15:
         rval = L + 1;
         break;

      case 20:
         rval = I;
         break;

      case 21:
         rval = R;
         break;

      case 16:
         rval = REGIX;
         break;

      case 17:
         rval = REGIY;
         break;

      case 18:
         rval = REGSP;
         break;

      case 19:
         rval = REGPC;
         break;
      }

   return( rval );
}

PRIVATE int OkayClicked( int dummy )
{
   int regnum = 0, BreakVal = 0; 

   /* check the string gadget for a valid value, & check the radio
   ** buttons to determine which register the breakpoint is for,
   ** then create the
   ** break point to add to the list.  Finally, copy the result to
   ** ValueStr
   */

   if (WhichRegSelected < 0) // No button pushed, default to the A reg:
      WhichRegSelected = 0;

   if (Valid8BitStr == TRUE || Valid16BitStr == TRUE)
      {
      if (WhichRegSelected > 15 && WhichRegSelected < 20)
         {
         // 16-bit register selected from radio button list:
         if ((BkptNum + 1) < MAXBKPT)
            {
            regnum = TranslateRegNum( WhichRegSelected );
            (void) stch_i( (char *) StrBfPtr( SBPGadgets[Str16Bit] ), 
                           &BreakVal 
                         );

            MakeBreakString( regnum, BreakVal );
            (void) strcpy( ValueStr, StrBfPtr( SBPGadgets[ Str16Bit ] ) );
            }
         else
            {
            (void) Handle_Problem( "Maximum # of Breakpoints exceeded!", 
                                   "Set Breakpoint Problem:", NULL 
                                 );
            return( (int) FALSE );
            }
         }
      else   // 8-bit register selected:
         {
         if ((BkptNum + 1) < MAXBKPT)
            {
            regnum = TranslateRegNum( WhichRegSelected );
            (void) stch_i( (char *) StrBfPtr( SBPGadgets[Str8Bit] ), 
                           &BreakVal 
                         );

            MakeBreakString( regnum, BreakVal );
            (void) strcpy( ValueStr, StrBfPtr( SBPGadgets[ Str8Bit ] ) );
            }
         else
            {
            (void) Handle_Problem( "Maximum # of Breakpoints exceeded!", 
                                   "Set Breakpoint Problem:", NULL 
                                 );
            return( (int) FALSE );
            }
         }
      }
   else   // No valid data in the string gadgets:
      {
      if (WhichRegSelected > 15 && WhichRegSelected < 20)
         {
         // Validate the 16-Bit string gadget:
         (void) stch_i( (char *) StrBfPtr( SBPGadgets[Str16Bit] ), 
                        &BreakVal 
                      );

         if (BreakVal >= 0 && BreakVal <= 0xFFFF)
            {
            Valid16BitStr = TRUE;
            (void) strcpy( ValueStr, StrBfPtr( SBPGadgets[ Str16Bit ] ) );
            }
         else
            {
            (void) Handle_Problem( "Invalid 16-bit value!", 
                                   "Set Breakpoint Problem:", NULL 
                                 );

            GT_SetGadgetAttrs( SBPGadgets[ Str16Bit ], SBPWnd, NULL,
                               GTST_String, (STRPTR) "",
                               TAG_END
                             );
            Valid16BitStr = FALSE;
            return( (int) TRUE );
            }

         if ((BkptNum + 1) < MAXBKPT)
            {
            regnum = TranslateRegNum( WhichRegSelected );
            MakeBreakString( regnum, BreakVal );
            }
         else
            {
            (void) Handle_Problem( "Maximum # of Breakpoints exceeded!", 
                                   "Set Breakpoint Problem:", NULL 
                                 );
            return( (int) FALSE );
            }
         }
      else
         {
         // Validate the 8-Bit string gadget:
         (void) stch_i( (char *) StrBfPtr( SBPGadgets[Str8Bit] ), 
                        &BreakVal 
                      );

         if (BreakVal >= 0 && BreakVal <= 0xFF)
            {
            Valid8BitStr = TRUE;
            (void) strcpy( ValueStr, StrBfPtr( SBPGadgets[ Str8Bit ] ) );
            }
         else
            {
            (void) Handle_Problem( "Invalid 8-bit value!", 
                                   "Set Breakpoint Problem:", NULL 
                                 );

            GT_SetGadgetAttrs( SBPGadgets[ Str8Bit ], SBPWnd, NULL,
                               GTST_String, (STRPTR) "",
                               TAG_END
                             );
            Valid8BitStr = FALSE;
            return( (int) TRUE );
            }

         if ((BkptNum + 1) < MAXBKPT)
            {
            regnum = TranslateRegNum( WhichRegSelected );
            MakeBreakString( regnum, BreakVal );
            }
         else
            {
            (void) Handle_Problem( "Maximum # of Breakpoints exceeded!", 
                                   "Set Breakpoint Problem:", NULL 
                                 );
            return( (int) FALSE );
            }
         }
      }

   LastBkpt = BkptNum;
   Delay( 80 );  // Let user see the updated break list before closing.
   
   CloseSBPWindow();

   return( (int) FALSE );
}

PRIVATE int AbortClicked( int dummy )
{
   *ValueStr = '\0';

   CloseSBPWindow();

   return( (int) FALSE );
}


PRIVATE void SBPRender( void )
{
   UWORD offx, offy;

   offx = SBPWnd->BorderLeft;
   offy = SBPWnd->BorderTop;


   DrawBevelBox( SBPWnd->RPort, offx + 6, offy + 256, 208, 70, 
                 GT_VisualInfo, VisualInfo, TAG_DONE 
               );

   DrawBevelBox( SBPWnd->RPort, offx + 278, offy + 5, 138, 278,
                 GT_VisualInfo, VisualInfo, TAG_DONE 
               );

   PrintIText( SBPWnd->RPort, SBPIText, offx, offy );

   return;
}

PRIVATE int OpenSBPWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &SBPGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < SBP_CNT; lc++) 
      {
      CopyMem( (char *) &SBPNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      SBPGadgets[ lc ] = g = CreateGadgetA( (ULONG) SBPGTypes[ lc ], 
                               g, 
                               &ng, 
                               (struct TagItem *) &SBPGTags[ tc ] );

      while (SBPGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   /* Set up the Breakpoint list & node structures: */

   for (lc = 0; lc < MAXBKPT; lc++)
      BreakPtItems[lc].ln_Name = BREAK_STR( lc );

   NewList( &BreakPtList );

   for (lc = 0; lc < MAXBKPT; lc++)
      AddTail( &BreakPtList, &BreakPtItems[lc] );

   if ((SBPWnd = OpenWindowTags( NULL,

                    WA_Left,        SBPLeft,
                    WA_Top,         SBPTop,
                    WA_Width,       SBPWidth,
                    WA_Height,      SBPHeight + offy,
                    WA_IDCMP,       LISTVIEWIDCMP | BUTTONIDCMP | MXIDCMP
                      | STRINGIDCMP | IDCMP_REFRESHWINDOW
                      | IDCMP_VANILLAKEY,

                    WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                      | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                    WA_Gadgets,     SBPGList,
                    WA_Title,       SBPWdt,
                    TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_SetGadgetAttrs( SBPGadgets[ BrkListView ], SBPWnd, NULL,
                      GTLV_Labels,       &BreakPtList,
                      GTLV_ShowSelected, NULL,
                      GTLV_Selected,     0,
                      GTLV_MaxPen,       255,
                      GTLV_ItemHeight,   12,
                      TAG_END
                    );

   GT_RefreshWindow( SBPWnd, NULL );
   SBPRender();

   return( 0 );
}

PRIVATE int SBPVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'd':
      case 'D':
      case 'o':
      case 'O':
         rval = OkayClicked( 0 );
         break;

      case 'a':
      case 'A':
         rval = AbortClicked( 0 );
         break;
      }

   return( rval );
}

PRIVATE int HandleSBPIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)( int );
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( SBPWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << SBPWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &SBPMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );
      switch (SBPMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( SBPWnd );
            SBPRender();
            GT_EndRefresh( SBPWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = SBPVanillaKey( SBPMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (void *)((struct Gadget *)SBPMsg.IAddress)->UserData;
           
            if (func != NULL)
               running = func( SBPMsg.Code );
           
            break;
         }
      }

   return( running );
}


PUBLIC int HandleSetBreakPt( char *bkptbuffer )
{
   if (OpenSBPWindow() < 0)
      {
      (void) Handle_Problem( "Couldn't open SetBreakPt Requester!", 
                             "Set Break Point Problem:", NULL 
                           );
      return( -1 );
      }

   (void) HandleSBPIDCMP();
   strcpy( bkptbuffer, ValueStr );  // Obsolete.

   return( 0 );
}

/* ----------------- END of SetBrkPt.c file --------------------- */
