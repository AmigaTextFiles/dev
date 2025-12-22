/****h* Z80Simulator/Z80Code.c [2.5] ********************************
*
* NAME
*    Z80Code.c
*
* DESCRIPTION
*    The Output_Code() function!
*
* HISTORY
*    05/02/98 - Modified with the rest of the GadTools additions.
*    04/12/94 - Corrected LD (HL),n decoding.
*
* NOTES
*    CALLS:         convert_byte(), convert_2_bytes(),
*                   get_op_reg(), get_op_dreg(), get_ccode().
*                   cleanup() in Z80Env.c
*                   Update_Regs();
*
*    SEQUENCE:
*
*       void Output_Code( char *mnemonic, UWORD address, 
*                         int addrmode, int op1, int op2,
*                         int b1, int b2, int b3, int b4 
*                       );
*
*    PARAMETERS:    mnemonic - the mnemonic to display.
*                   address  - where the PC is.
*                   addrmode - see Z80Code.h file.
*                   op1, op2 - the operands for further
*                              decoding in the function.
*                   b1, b2,
*                   b3, b4   - the bytes of machine code.
*                              If a byte is -1, then it isn't
*                              displayed.
*********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuitionbase.h>

#include <libraries/gadtools.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Z80FuncProtos.h"
#include "Z80Sim.h"
#include "Z80Code.h"
#include "Z80SimGTGUI.h" // For SrcCodeListView & CurrentInst #defines

#include <MyFunctions.h>

IMPORT   UBYTE    reg[];
IMPORT   UWORD    dreg[];

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct Window *Z80SimWnd;
IMPORT struct Gadget *Z80SimGadgets[];
IMPORT struct List    SCList;
IMPORT char          *SCItemBuffer;
/* ----------------------------------- */


PRIVATE void  build_indirect( int b1, int b2, char *sym1, 
                              char *out, char *temp 
                            )
{
   (void) strcat( out, "(" );

   if (sym1 != NULL)
      (void) strcat( out, sym1 );

   if (b1 != -1)  
      {
      to_hexstr( (unsigned int) b1, temp, 2 );
      (void) strcat( out, temp );
      }

   if (b2 != -1)  
      {
      to_hexstr( (unsigned int) b2, temp, 2 );
      (void) strcat( out, temp );
      }

   (void) strcat( out, ")" );

   return;
}

PRIVATE void  convert_byte( int byte, char *out, char *temp )
{
   to_hexstr( (unsigned int) byte, temp, 2 );

   (void) strcat( out, " " );
   (void) strcat( out, temp );

   return;
}

PRIVATE void  convert_2_bytes( int by1, int by2, char *out, char *temp )
{
   to_hexstr( (unsigned int) by1, temp, 2 );
   (void) strcat( out, temp );

   to_hexstr( (unsigned int) by2, temp, 2 );
   (void) strcat( out, temp );

   return;
}

PRIVATE void  get_op_reg( int op, char *str1 )
{
   switch ( op )  
      {
      case A:  (void) strcat( str1, "A" );  break;
      case B:  (void) strcat( str1, "B" );  break;
      case C:  (void) strcat( str1, "C" );  break;
      case D:  (void) strcat( str1, "D" );  break;
      case E:  (void) strcat( str1, "E" );  break;
      case H:  (void) strcat( str1, "H" );  break;
      case L:  (void) strcat( str1, "L" );  break;
      case I:  (void) strcat( str1, "I" );  break;
      case R:  (void) strcat( str1, "R" );  break;
      default: (void) strcat( str1, "?" );  break;
      }

   return;
}

PRIVATE void  get_op_dreg( int op, char *str1 )
{
   switch ( op )  
      {
      case AF:  (void) strcat( str1, "AF" );  break;
      case BC:  (void) strcat( str1, "BC" );  break;
      case DE:  (void) strcat( str1, "DE" );  break;
      case HL:  (void) strcat( str1, "HL" );  break;
      case SP:  (void) strcat( str1, "SP" );  break;
      case IX:  (void) strcat( str1, "IX" );  break;
      case IY:  (void) strcat( str1, "IY" );  break;
      default:  (void) strcat( str1, "??" );  break;
      }

   return;
}

PRIVATE void  get_ccode( int op, char *str1 )
{
   switch ( op )  
      {
      case NC_:  (void) strcat( str1, "NC" );  break;
      case C_:   (void) strcat( str1, "C" );   break;
      case NZ_:  (void) strcat( str1, "NZ" );  break;
      case Z_:   (void) strcat( str1, "Z" );   break;
      case PO_:  (void) strcat( str1, "PO" );  break;
      case PE_:  (void) strcat( str1, "PE" );  break;
      case P_:   (void) strcat( str1, "P" );   break;
      case M_:   (void) strcat( str1, "M" );   break;
      default:   (void) strcat( str1, "??" );  break;
      }

   return;
}

PRIVATE int CItemIndex = 0;

PRIVATE void DisplaySrcCode( char *codestring )
{
   IMPORT UWORD dreg[];
   
   /* since the SCItemBuffer is re-used after SCMAXITEM is reached,
   ** we must check & make sure that there is no overflowing of the
   ** buffer & adjust the Current Item Index accordingly:
   */
   if ((CItemIndex + 1) > SCMAXITEM)
      {
      int i, max = SCMAXITEM * SCITEMLENGTH;
      
      CItemIndex = 0;

      Update_Regs( dreg[ PC ] );

      for (i = 0; i < max; i++)
         *(SCItemBuffer + i) = '\0'; /* Clear the buffer. */

      /* Disable the ListView momentarily: */
      GT_SetGadgetAttrs( Z80SimGadgets[SrcCodeListView], Z80SimWnd, NULL,
                         GTLV_Labels, ~0,
                         TAG_END
                       );
   
      (void) strcpy( &SCItemBuffer[ CItemIndex * SCITEMLENGTH ],
                     codestring
                   );

      /* Re-enable the ListView gadget: */
      GT_SetGadgetAttrs( Z80SimGadgets[SrcCodeListView], Z80SimWnd, NULL,
                         GTLV_Labels, &SCList,
                         GTLV_MakeVisible, CItemIndex,
                         GTLV_Selected,    CItemIndex,
                         TAG_END
                       );

      /* Copy the latest instruction to the Current Instruction String
      ** Gadget:
      */
      GT_SetGadgetAttrs( Z80SimGadgets[CurrentInst], Z80SimWnd, NULL,
                         GTTX_Text, codestring,
                         TAG_END
                       );
      }   
   else
      {
      /* Disable the ListView momentarily: */
      GT_SetGadgetAttrs( Z80SimGadgets[SrcCodeListView], Z80SimWnd, NULL,
                         GTLV_Labels, ~0,
                         TAG_END
                       );
   
      (void) strcpy( &SCItemBuffer[ CItemIndex * SCITEMLENGTH ],
                     codestring
                   );

      /* Re-enable the ListView gadget: */
      GT_SetGadgetAttrs( Z80SimGadgets[SrcCodeListView], Z80SimWnd, NULL,
                         GTLV_Labels, &SCList,
                         GTLV_MakeVisible, CItemIndex,
                         GTLV_Selected,    CItemIndex,
                         TAG_END
                       );

      /* Copy the latest instruction to the Current Instruction String
      ** Gadget:
      */
      GT_SetGadgetAttrs( Z80SimGadgets[CurrentInst], Z80SimWnd, NULL,
                         GTTX_Text, codestring,
                         TAG_END
                       );
      }

   CItemIndex++;

   return;
}

/* --------------------------------------------------------------
** the Source code string is structured as follows:
** 
**     aaaa: b1 b2 b3 b4 MNEM OP1,OP2  
** -------------------------------------------------------------- */


VISIBLE void  Output_Code( char *mnem, UWORD addr, int mode, int op1, 
                           int op2, int b1, int b2, int b3, int b4 
                         )
{
   char a[20], str[40], *adr = &a[0], *st = &str[0];

   to_hexstr( (unsigned int) addr, adr, 4 );

   (void) strcat( adr, ": " );
   (void) strcpy( st, adr );

   to_hexstr( (unsigned int) b1, adr, 2 );
   (void) strcat( st, adr );                  /* got address & byte1 */

   /* adr is now used as temporary storage: */

   if (b2 != -1)
      convert_byte( b2, st, adr );
   else 
      (void) strcat( st, "   " );

   if (b3 != -1)
      convert_byte( b3, st, adr );
   else 
      (void) strcat( st, "   " );

   if (b4 != -1)
      convert_byte( b4, st, adr );
   else 
      (void) strcat( st, "   " );

Skip_Bytes:

   (void) strcat( st, " " );
   (void) strcat( st, mnem );      /* got address, bytes & mnemonic */

   switch( mode ) 
      {
      case IMPL:  break;  /* No further work is necessary! */

      case IMPL2: if (op1 == -1)  
                     {                         /* OUT (xx),A */
                     build_indirect( b2, -1, NULL, st, adr );
                     (void) strcat( st, ",A" );
                     break;
                     }
                  else if (op2 == -1)   
                     {                  /* IN A,(xx) */
                     build_indirect( b2, -1, NULL, st, adr );
                     break;
                     }

      case BITA:  to_hexstr( (unsigned int) op1, adr, 2 );
                  (void) strcat( st, adr );
                  (void) strcat( st, "," );
                  if (op2 == -1)  
                     {
                     (void) strcat( st, "(HL)" );
                     break;
                     }
                  else if (op2 == -2)  
                     {
                     build_indirect( b3, -1, "IX+", st, adr );
                     break;
                     }
                  else if (op2 == -3)  
                     {
                     build_indirect( b3, -1, "IY+", st, adr );
                     break;
                     }
                  else
                     get_op_reg( op2, st );
                  break;

      case INDX1:
                  if (op2 == -2)   
                     {                    /* OP (IX+d),n */
                     build_indirect( b3, -1, "IX+", st, adr );
                     (void) strcat( st, "," );
                     to_hexstr( (unsigned int) b4, adr, 2 );
                     (void) strcat( st, adr );
                     break;
                     }
                  else if (op2 != -1)  
                     {                    /* OP (IX+d),reg */
                     build_indirect( b3, -1, "IX+", st, adr );
                     (void) strcat( st, "," );
                     get_op_reg( op2, st );
                     break;
                     }
                  else if (op2 == -1)                   /* no op2! */
                     break;

      case INDX2: if (op1 == -2)                        /* OP IX,(aa) */
                     build_indirect( b4, b3, NULL, st, adr );
                  else if (op1 == -1)  
                     {                  /* OP (aa),IX */
                     build_indirect( b4, b3, NULL, st, adr );
                     (void) strcat( st, ",IX" );
                     }
                  else  
                     {
                     get_op_reg( op1, st );             /* OP reg,(IX+d) */
                     (void) strcat( st, "," );
                     build_indirect( b3, -1, "IX+", st, adr );
                     }
                  break;

      case INDY3:                                         /* OP IY,dreg */
      case INDX3: get_op_dreg( op1, st );                 /* OP IX,dreg */
                  break;

      case INDY4:                                         /* OP IY,nn */
      case INDX4: convert_2_bytes( b4, b3, st, adr );     /* OP IX,nn */
                  break;

      case INDX5: build_indirect( b3, -1, "IX+", st, adr ); /* OP (IX+d) */
                  break;

      case INDY5: build_indirect( b3, -1, "IY+", st, adr ); /* OP (IY+d) */
                  break;

      case INDY1:
                  if (op2 == -2)   
                     {                    /* OP (IY+d),n */
                     build_indirect( b3, -1, "IY+", st, adr );
                     (void) strcat( st, "," );
                     to_hexstr( (unsigned int) b4, adr, 2 );
                     (void) strcat( st, adr );
                     break;
                     }
                  else if (op2 != -1)  
                     {                /* OP (IY+d),reg */
                     build_indirect( b3, -1, "IY+", st, adr );
                     (void) strcat( st, "," );
                     get_op_reg( op2, st );
                     break;
                     }
                  else if (op2 == -1)                     /* no op2! */
                     break;

      case INDY2: if (op1 == -2)                          /* OP IY,(aa) */
                     build_indirect( b4, b3, NULL, st, adr );
                  else if (op1 == -1)  
                     {                  /* OP (aa),IY */
                     build_indirect( b4, b3, NULL, st, adr );
                     (void) strcat( st, ",IY" );
                     }
                  else  
                     {
                     get_op_reg( op1, st );             /* OP reg,(IY+d) */
                     (void) strcat( st, "," );
                     build_indirect( b3, -1, "IY+", st, adr );
                     }
                  break;

      case IMMD:  if (op1 == -1 && op2 == -1)  
                     {             /* OP nn */
                     to_hexstr( (unsigned int) b2, adr, 2 );
                     (void) strcat( st, adr );
                     break;
                     }
                  break;

      case IMMD2: get_op_reg( op1, st );               /* OP reg,nn */
                  (void) strcat( st, "," );
                  to_hexstr( (unsigned int ) b2, adr, 2 );
                  (void) strcat( st, adr );
                  break;

      case EXTI1: build_indirect( b3, b2, NULL, st, adr ); // OP (aa),dreg
                  (void) strcat( st, "," );
                  get_op_dreg( op2, st );
                  break;

      case EXTI2: if (op2 == -1)                           /* OP dr,aa */
                     convert_2_bytes( b3, b2, st, adr );
                  else                                     /* OP dr,(aa) */
                     build_indirect( b3, b2, NULL, st, adr );
                  break;

      case REGA2: get_op_reg( op2, st );      /* OP [R],reg  */
                  break;

      case REGA3: if (op1 == -1)              /* OUT (C),reg */
                     get_op_reg( op2, st );
                  else if (op2 == -1)  
                     {                        /* IN reg,(C)  */
                     get_op_reg( op1, st );
                     (void) strcat( st, ",(C)" );
                     }
                  break;

      case REGA4: get_op_reg( op1, st );      /* OP reg,[R] */
                  (void) strcat( st, "," );
                  get_op_reg( op2, st );
                  break;

      case REGD2: get_op_dreg( op2, st );           /* OP dr,dreg */
                  break;

      case REGI1: if (op1 != -1 && op2 != -1)
                     {                              /* OP (dr),reg */
                     (void) strcat( st, "(" );
                     get_op_dreg( op1, st );
                     (void) strcat( st, ")," );
                     get_op_reg( op2, st );
                     break;
                     }
                  else if (op1 != -1 && op2 == -1)  // corrected on 4/12/94
                     {                              /* OP (dr),n */
                     (void) strcat( st, "(" );
                     get_op_dreg( op1, st );
                     (void) strcat( st, ")," );
                     to_hexstr( (unsigned int) b2, adr, 2 );
                     (void) strcat( st, adr );
                     }
                  break;

      case REGI2: if (op1 != -1)
                     {                              /* OP reg,(dr) */
                     get_op_reg( op1, st );
                     (void) strcat( st, ",(" );
                     get_op_dreg( op2, st );
                     (void) strcat( st, ")" );
                     }
                  else  
                     {                              /* OP A,(dr) */
                     (void) strcat( st, "(" );
                     get_op_dreg( op2, st );
                     (void) strcat( st, ")" );
                     }
                  break;

      case REGI3: build_indirect( b3, b2, NULL, st, adr ); /* OP (nn),A */
                  (void) strcat( st, ",A" );
                  break;

      case EXTA1: if (op2 != -1)  
                     get_ccode( op2, st );                /*  RET cc */
                  else                                    /* JP nn & */
                     convert_2_bytes( b3, b2, st, adr );  /* CALL nn */
                  break;

      case EXTA2: build_indirect( b3, b2, NULL, st, adr ); /* OP r,(nn) */
                  break;

      case EXTA3: get_ccode( op1, st );                    /* OP cc,nn */
                  (void) strcat( st, "," );
                  convert_2_bytes( b3, b2, st, adr );
                  break;

      case EXTA4: get_op_dreg( op1, st );                  /* OP dr,nn */
                  (void) strcat( st, "," );
                  convert_2_bytes( b3, b2, st, adr );
                  break;

      case MPZA:  to_hexstr( (unsigned int ) op2, adr, 2 );
                  (void) strcat( st, adr );
                  break;

      case RELA1:        /* no difference between 1 & 2 here! */

      case RELA2: to_hexstr( (unsigned int) b2, adr, 2 ); // JR or DJNZ e
                  (void) strcat( st, adr );
                  break;

      default:    fprintf( stderr, "got a bad mode in Output_Code()!\n");
                  if (Handle_Problem( "Bad Addressing Mode!",
                                      "OutputCode() problem:", NULL ) == 0)
                     break;
      }

Output_Text:

   DisplaySrcCode( st );

   return;
}

/* -------------------- End of Z80Code.c file!! ------------------- */
