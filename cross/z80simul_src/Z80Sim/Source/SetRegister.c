/****h* Z80Simulator/SetRegister.c [2.5] ***************************
*
* NAME
*    SetRegister.c
*
* DESCRIPTION
*    Allow the user to change Z80 register values via this
*    requester code.
*
* Functional Interface:
*
*  VISIBLE int HandleSetRegister( void );
*
*  GUI Designed by : Jim Steichen
********************************************************************
*
*/

#include <string.h>

#include <exec/types.h>

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

#define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)

#define OkayBt     0
#define CancelBt   1
#define RegButtons 2
#define Str8Bit    3
#define Str16Bit   4

#define SR_CNT     5

IMPORT BOOL sregchanged[], dregchanged[];

IMPORT UBYTE reg[ 18 ]; /* Located in Z80Vars.h */
IMPORT UWORD dreg[ 5 ];
 
/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
/* ----------------------------------- */

PRIVATE struct Window       *SRWnd   = NULL;
PRIVATE struct Gadget       *SRGList = NULL;
PRIVATE struct IntuiMessage  SRMsg;
PRIVATE struct Gadget       *SRGadgets[ SR_CNT ];

PRIVATE UWORD  SRLeft   = 271;
PRIVATE UWORD  SRTop    = 175;
PRIVATE UWORD  SRWidth  = 369;
PRIVATE UWORD  SRHeight = 291;
PRIVATE UBYTE *SRWdt    = "Set a Register's value:";

PRIVATE UBYTE *Labels[] = {

   (UBYTE *) "A ",   (UBYTE *) "B ",
   (UBYTE *) "C ",   (UBYTE *) "D ",
   (UBYTE *) "E ",   (UBYTE *) "F ",
   (UBYTE *) "H ",   (UBYTE *) "L ",
   (UBYTE *) "A'",   (UBYTE *) "B'",
   (UBYTE *) "C'",   (UBYTE *) "D'",
   (UBYTE *) "E'",   (UBYTE *) "F'",
   (UBYTE *) "H'",   (UBYTE *) "L'",
   (UBYTE *) "IX",   (UBYTE *) "IY",
   (UBYTE *) "SP",   (UBYTE *) "PC",
   (UBYTE *) "I ",   (UBYTE *) "R ",
   (UBYTE *) "NONE", NULL 
};

PRIVATE struct IntuiText SRIText[] = {

   2, 0, JAM1, 222,   8, &topaz8, (UBYTE *) "Select Register:", 
   &SRIText[1],
   
   2, 0, JAM1,  43,   9, &topaz8, (UBYTE *) "Register Value:", 
   &SRIText[2],
   
   1, 0, JAM1,   6,  78, &topaz8, (UBYTE *) "You may change as many", 
   &SRIText[3],
   
   1, 0, JAM1,   6,  86, &topaz8, (UBYTE *) "registers as you like,", 
   &SRIText[4],
   
   1, 0, JAM1,   6,  94, &topaz8, (UBYTE *) "simply press done when", 
   &SRIText[5],
   
   1, 0, JAM1,   6, 103, &topaz8, (UBYTE *) "you've changed everything", 
   &SRIText[6],
   
   1, 0, JAM1,   6, 112, &topaz8, (UBYTE *) "you wanted to change.", NULL 
};

PRIVATE UWORD SRGTypes[] = {

   BUTTON_KIND, BUTTON_KIND,
   MX_KIND,     STRING_KIND,
   STRING_KIND
};

PRIVATE int OkayBtClicked(   int dummy    );
PRIVATE int CancelBtClicked( int dummy    );
PRIVATE int RadioClicked(    int whichreg );
PRIVATE int Str8BitClicked(  int dummy    );
PRIVATE int Str16BitClicked( int dummy    );

PRIVATE struct NewGadget SRNGad[] = {

     6, 126, 62, 21, (UBYTE *) " _DONE ",   NULL, OkayBt, 
   PLACETEXT_IN, NULL, (APTR) OkayBtClicked,
   
     6, 156, 69, 21, (UBYTE *) " _CANCEL ", NULL, CancelBt, 
   PLACETEXT_IN, NULL, (APTR) CancelBtClicked,

   281,  24, 17,  9,                  NULL, NULL, RegButtons, 
   PLACETEXT_LEFT, NULL, (APTR) RadioClicked,

    76,  24, 37, 15, (UBYTE *) "8-Bit:",    NULL, Str8Bit, 
   PLACETEXT_LEFT, NULL, (APTR) Str8BitClicked,

    76,  45, 61, 15, (UBYTE *) "16-Bit:",   NULL, Str16Bit, 
   PLACETEXT_LEFT, NULL, (APTR) Str16BitClicked
};

PRIVATE ULONG SRGTags[] = {

   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE),

   (GTMX_Labels), (ULONG) &Labels[ 0 ], 
   (GTMX_Spacing), 3, (GTMX_Active), 22, (TAG_DONE),

   (GA_TabCycle), FALSE, (GTST_MaxChars), 3, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
   
   (GA_TabCycle), FALSE, (GTST_MaxChars), 7, 
   (STRINGA_Justification), (GACT_STRINGCENTER), 
   (GA_Disabled), TRUE, (TAG_DONE)
};

PRIVATE int  WhichRegSelected = -1;     /* No register selected. */
PRIVATE char VN[5], *ValueStr = &VN[0]; /* The register value.   */

PRIVATE int  Valid8BitStr     = FALSE;
PRIVATE int  Valid16BitStr    = FALSE;

PRIVATE UBYTE regs[ 18 ] = { 0, };
PRIVATE UWORD dregs[ 5 ] = { 0, };

PRIVATE void CloseSRWindow( void )
{
   if (SRWnd != NULL) 
      {
      CloseWindow( SRWnd );
      SRWnd = NULL;
      }

   if (SRGList != NULL) 
      {
      FreeGadgets( SRGList );
      SRGList = NULL;
      }
 
   return;
}

PRIVATE void UpdateRegisters( void )
{
   int i; 

   /* copy the temporary arrays to the Z80 registers: */

   for (i = 0; i < 18; i++)
      {
      if (reg[i] != regs[i])
         sregchanged[i] = TRUE;
      else
         sregchanged[i] = FALSE;
         
      reg[i] = regs[i];
      }
      
   for (i = 0; i < 5; i++)
      {
      if (dreg[i] != dregs[i])
         dregchanged[i] = TRUE;
      else
         dregchanged[i] = FALSE;
         
      dreg[i] = dregs[i];
      }
      
   return;
}

#define CHANGE_REGISTERS 21

PRIVATE int OkayBtClicked( int dummy )
{
   UpdateRegisters();

   CloseSRWindow();

   return( CHANGE_REGISTERS );
}

PRIVATE int CancelBtClicked( int dummy )
{
   CloseSRWindow();

   return( (int) FALSE );
}

PRIVATE int RadioClicked( int whichreg )
{
   /* Based on which radio button is pressed, enable or disable &
   ** clear the appropriate String gadget for either 8-bit registers or
   ** 16-bit registers.
   */

   WhichRegSelected = whichreg;
   
   switch (whichreg)
      {
      case 0:  // Register A selected:
      case 1:  // Register B selected:
      case 2:  // Register C selected:
      case 3:  // Register D selected:
      case 4:  // Register E selected:
      case 5:  // Register F selected:
      case 6:  // Register H selected:
      case 7:  // Register L selected:
      case 8:  // Register A' selected:
      case 9:  // Register B' selected:
      case 10: // Register C' selected:
      case 11: // Register D' selected:
      case 12: // Register E' selected:
      case 13: // Register F' selected:
      case 14: // Register H' selected:
      case 15: // Register L' selected:
      case 20: // Register I selected:
      case 21: // Register R selected:
 
         GT_SetGadgetAttrs( SRGadgets[ Str16Bit ], SRWnd, NULL,
                            GA_DISABLED, TRUE, TAG_END 
                          );

         GT_SetGadgetAttrs( SRGadgets[ Str8Bit ], SRWnd, NULL,
                            GA_DISABLED, FALSE, TAG_END 
                          );

         GT_SetGadgetAttrs( SRGadgets[ Str8Bit ], SRWnd, NULL,
                            GTST_String, (STRPTR) "",
                            TAG_END
                          );

         Valid8BitStr = FALSE;
         break;

      case 16: // Register IX selected:
      case 17: // Register IY selected:
      case 18: // Register SP selected:
      case 19: // Register PC selected:

         GT_SetGadgetAttrs( SRGadgets[ Str16Bit ], SRWnd, NULL,
                            GA_DISABLED, FALSE, TAG_END 
                          );

         GT_SetGadgetAttrs( SRGadgets[ Str8Bit ], SRWnd, NULL,
                            GA_DISABLED, TRUE, TAG_END 
                          );

         GT_SetGadgetAttrs( SRGadgets[ Str16Bit ], SRWnd, NULL,
                            GTST_String, (STRPTR) "",
                            TAG_END
                          );

         Valid16BitStr = FALSE;
         break;

      case 22:
         break;  /* 'NONE' radio button */
      }

   return( (int) TRUE );
}

PRIVATE void Copy8BitValue( int RegVal )
{
   switch (WhichRegSelected)
      {
      case 0:  // Register A selected:
         regs[ A ] = RegVal;
         break;

      case 1:  // Register B selected:
         regs[ B ] = RegVal;
         break;

      case 2:  // Register C selected:
         regs[ C ] = RegVal;
         break;

      case 3:  // Register D selected:
         regs[ D ] = RegVal;
         break;

      case 4:  // Register E selected:
         regs[ E ] = RegVal;
         break;

      case 5:  // Register F selected:
         regs[ F ] = RegVal;
         break;

      case 6:  // Register H selected:
         regs[ H ] = RegVal;
         break;

      case 7:  // Register L selected:
         regs[ L ] = RegVal;
         break;

      case 8:  // Register A' selected:
         regs[ A + 1 ] = RegVal;
         break;

      case 9:  // Register B' selected:
         regs[ B + 1 ] = RegVal;
         break;

      case 10: // Register C' selected:
         regs[ C + 1 ] = RegVal;
         break;

      case 11: // Register D' selected:
         regs[ D + 1 ] = RegVal;
         break;

      case 12: // Register E' selected:
         regs[ E + 1 ] = RegVal;
         break;

      case 13: // Register F' selected:
         regs[ F + 1 ] = RegVal;
         break;

      case 14: // Register H' selected:
         regs[ H + 1 ] = RegVal;
         break;

      case 15: // Register L' selected:
         regs[ L + 1 ] = RegVal;
         break;

      case 20: // Register I selected:
         regs[ I ] = RegVal;
         break;

      case 21: // Register R selected:
         regs[ R ] = RegVal;
         break;

      default:
         break;
      }

   return;
}

PRIVATE int Str8BitClicked( int dummy )
{
   int RegVal = 0;
   
   if (WhichRegSelected > 21)
      return( (int) TRUE );

   (void) stch_i( (char *) StrBfPtr( SRGadgets[Str8Bit] ), &RegVal );

   /* Verify correct 8-bit range was entered: */

   if (RegVal >= 0 && RegVal <= 0xFF)
      {
      Valid8BitStr = TRUE;
      Copy8BitValue( RegVal );
      }
   else
      {
      (void) Handle_Problem( "Invalid 8-bit value!", 
                             "Set Register Problem:", NULL 
                           );

      GT_SetGadgetAttrs( SRGadgets[ Str8Bit ], SRWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );

      Valid8BitStr = FALSE;
      }

   Valid16BitStr = FALSE;

   return( (int) TRUE );
}

PRIVATE void Copy16BitValue( int RegVal )
{
   switch (WhichRegSelected)
      {
      case 16:
         dregs[ IX ] = RegVal;
         break;

      case 17:
         dregs[ IY ] = RegVal;
         break;

      case 18:
         dregs[ SP ] = RegVal;
         break;

      case 19:
         dregs[ PC ] = RegVal;
         break;

      default:
         break; 
      }

   return;
}

PRIVATE int Str16BitClicked( int dummy )
{
   int RegVal = 0;

   if (WhichRegSelected > 21)
      return( (int) TRUE );

   (void) stch_i( (char *) StrBfPtr( SRGadgets[Str16Bit] ), &RegVal );

   /* Verify correct 16-bit range was entered: */

   if (RegVal >= 0 && RegVal <= 0xFFFF)
      {
      Valid16BitStr = TRUE;
      Copy16BitValue( RegVal );
      }
   else
      {
      (void) Handle_Problem( "Invalid 16-bit value!", 
                             "Set Register Problem:", NULL 
                           );

      GT_SetGadgetAttrs( SRGadgets[ Str16Bit ], SRWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      Valid16BitStr = FALSE;
      }

   Valid8BitStr = FALSE;

   return( (int) TRUE );
}

PRIVATE void SRRender( void )
{
   UWORD offx, offy;

   offx = SRWnd->BorderLeft;
   offy = SRWnd->BorderTop;

   DrawBevelBox( SRWnd->RPort, offx + 4, offy + 5, 
                 208, 70, GT_VisualInfo, VisualInfo, TAG_DONE 
               );

   DrawBevelBox( SRWnd->RPort, offx + 218, offy + 5, 
                 138, 278, GT_VisualInfo, VisualInfo, TAG_DONE 
               );

   PrintIText( SRWnd->RPort, SRIText, offx, offy );

   return;
}

PRIVATE int OpenSRWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc, i;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   /* copy the current contents of the Z80 registers to the 
   ** temporary arrays regs[] & dregs[]:
   */

   for (i = 0; i < 18; i++)
      regs[i] = reg[i];

   for (i = 0; i < 5; i++)
      dregs[i] = dreg[i];

       
   if ((g = CreateContext( &SRGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < SR_CNT; lc++) 
      {
      CopyMem( (char *) &SRNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      SRGadgets[ lc ] = g = CreateGadgetA( (ULONG) SRGTypes[ lc ],
                                 g, 
                                 &ng, 
                                 (struct TagItem *) &SRGTags[ tc ] );

      while (SRGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((SRWnd = OpenWindowTags( NULL,

                   WA_Left,        SRLeft,
                   WA_Top,         SRTop,
                   WA_Width,       SRWidth,
                   WA_Height,      SRHeight + offy,
                   WA_IDCMP,       BUTTONIDCMP | MXIDCMP | STRINGIDCMP
                     | IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW
                     | IDCMP_VANILLAKEY,
                   
                   WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE 
                     | WFLG_RMBTRAP,
                   
                   WA_Gadgets,     SRGList,
                   WA_Title,       SRWdt,
                   TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( SRWnd, NULL );
   SRRender();

   return( 0 );
}

PRIVATE int SRCloseWindow( void )
{
   CloseSRWindow();

   return( (int) FALSE );
}

PRIVATE int SRVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'd':
      case 'D':
      case 'o':
      case 'O':
         rval = OkayBtClicked( 0 );
         break;
   
      case 'c':
      case 'C':
      case 'a':
      case 'A':
         rval = CancelBtClicked( 0 );
         break;
      }
      
   return( rval );
}

PRIVATE int HandleSRIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)( int );
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( SRWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << SRWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &SRMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (SRMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( SRWnd );
            SRRender();
            GT_EndRefresh( SRWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = SRVanillaKey( SRMsg.Code );
            break;
            
         case IDCMP_CLOSEWINDOW:
            running = SRCloseWindow();
            break;

         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (void *)((struct Gadget *)SRMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func( SRMsg.Code );
            
            break;
         }
      }

   return( running );
}

VISIBLE int HandleSetRegister( void )
{
   if (OpenSRWindow() < 0)
      {
      (void) Handle_Problem( "Couldn't open Set Register Requester!", 
                             "Set Register Problem:", NULL 
                           );
      return( -1 );
      }

   return( HandleSRIDCMP() );
}

/* ------------------- END of SetRegister.c file ------------------- */
