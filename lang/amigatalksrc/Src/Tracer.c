/****h* AmigaTalk/Tracer.c [3.0] *************************************
*
* NAME
*    Tracer.c
*
* DESCRIPTION
*    A GUI to the internal variables list known to AmigaTalk.
*
* HISTORY 
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    04-Jan-2003 - All string constants moved to StringConstants.h
*
* NOTES
*    $VER: Tracer.c 3.0 (25-Oct-2004) by J.T. Steichen
**********************************************************************
*
*/

#include <string.h>
#include <stdio.h>

#include <exec/types.h>
#include <exec/nodes.h>
#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/diskfont.h>
# include <proto/utility.h>

IMPORT struct Library        *IntuitionBase;
IMPORT struct IntuitionIFace *IIntuition;

#endif

#include "Constants.h"
#include "ATStructs.h"

#include "FuncProtos.h" 

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#ifndef  StrBfPtr
# define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
#endif

#define VarNamesLV     0
#define VarValuesLV    1
#define VariableTxt    2
#define VarValueTxt    3
#define ShowAddrStr    4

#define Tr_CNT         5

#define VAR_LIST    TrGadgets[ VarNamesLV ]
#define VAL_LIST    TrGadgets[ VarValuesLV ]

#define VAR_TEXTGAD TrGadgets[ VariableTxt ]
#define VAL_TEXTGAD TrGadgets[ VarValueTxt ]

#define ADDRESS_STR TrGadgets[ ShowAddrStr ]

// ---------------------------------------------------------------------

IMPORT struct varPage *retrieveVarPages( void );

IMPORT struct Library *GadToolsBase;

IMPORT struct Screen   *Scr;
IMPORT struct Window   *ATWnd;
IMPORT struct TextAttr *Font;
IMPORT struct CompFont  CFont;
IMPORT APTR             VisualInfo;

IMPORT UBYTE *ErrMsg;

IMPORT UBYTE *ATalkProblem;
IMPORT UBYTE *SystemProblem;
IMPORT UBYTE *AllocProblem;
IMPORT UBYTE *UserProblem;

IMPORT char *symbol_value( SYMBOL * );

// ---------------------------------------------------------------------

PRIVATE struct TextFont     *TrFont  = NULL;
PRIVATE struct Window       *TrWnd   = NULL;
PRIVATE struct Gadget       *TrGList = NULL;
PRIVATE struct IntuiMessage  TrMsg;
PRIVATE struct Gadget       *TrGadgets[ Tr_CNT ] = { NULL, };

PRIVATE UWORD  TrLeft   = 0;
PRIVATE UWORD  TrTop    = 16;
PRIVATE UWORD  TrWidth  = 635;
PRIVATE UWORD  TrHeight = 345;
PUBLIC  UBYTE *TrWdt    = NULL; // Visible to CatalogTracer();

// ---------------------------------------------------------------------

#define TXTLENGTH   80

PRIVATE struct List    VarLVList    = { 0, };
PRIVATE struct List    ValLVList    = { 0, };

PRIVATE struct Node   *VarLVNodes   = NULL; // really LVVars->lvm_Nodes
PRIVATE struct Node   *ValLVNodes   = NULL; // really LVVals->lvm_Nodes

PRIVATE UBYTE         *VarNodeStrs  = NULL; // really LVVars->lvm_NodeStrs
PRIVATE UBYTE         *ValNodeStrs  = NULL; // really LVVals->lvm_NodeStrs

PRIVATE struct ListViewMem *LVVars = NULL;
PRIVATE struct ListViewMem *LVVals = NULL;

// ---------------------------------------------------------------------

PUBLIC struct IntuiText TrIText[] = { 2, 0, JAM1, 423, 327, NULL, NULL, NULL }; // Visible to CatalogTracer();

PRIVATE UWORD TrGTypes[ Tr_CNT ] = {

   LISTVIEW_KIND, LISTVIEW_KIND, TEXT_KIND,
   TEXT_KIND,     STRING_KIND
};

PRIVATE int VarNamesLVClicked(  int whichitem );
PRIVATE int VarValuesLVClicked( int dummy     );
PRIVATE int ShowAddrStrClicked( int dummy     );

PUBLIC struct NewGadget TrNGad[ Tr_CNT ] = { // Visible to CatalogTracer();

     8,  20, 250, 280, NULL,   NULL, VarNamesLV, 
   PLACETEXT_ABOVE, NULL, (APTR) VarNamesLVClicked,
   
   265,  20, 359, 280, NULL,  NULL, VarValuesLV, 
   PLACETEXT_ABOVE | NG_HIGHLABEL, NULL, (APTR) VarValuesLVClicked,

     8, 297, 250,  17, NULL, NULL, VariableTxt, 
   0, NULL, NULL,
   
   265, 297, 359,  17, NULL, NULL, VarValueTxt, 
   0, NULL, NULL,

   147, 319, 111,  17, NULL, NULL, ShowAddrStr, 
   PLACETEXT_LEFT, NULL, (APTR) ShowAddrStrClicked
};

PRIVATE ULONG TrGTags[] = {

   GTLV_ShowSelected, 0L, 
   GTLV_Selected,     0,
   LAYOUTA_Spacing,   2, 
   TAG_DONE,
   
   (GTLV_ReadOnly), TRUE, (LAYOUTA_Spacing), 2, (TAG_DONE),

   (GTTX_Border), TRUE, (TAG_DONE),
   (GTTX_Border), TRUE, (TAG_DONE),

   (GTST_MaxChars), 12, (STRINGA_Justification), (GACT_STRINGCENTER), 
   (TAG_DONE)
};

// ---------------------------------------------------------------------

PRIVATE void ConvertBytes( char *buff,    UBYTE *barray, 
                           int   bufsize, int    bsize
                         )
{
   char hexch[] = "0123456789ABCDEF";
   
   int i = 0, j = 0, n = 0, k = bsize;

   int ch1, ch2;

   /* Terminate the while loop if we run out of buffer or if 
   ** there are no more bytecodes to display:
   */   
   while ((j < (bufsize - 1)) && (k > 0))
      {
      ch1 = hexch[ (*(barray + i) >> 4) & 0x0F ];
      ch2 = hexch[  *(barray + i)       & 0x0F ];
      
      buff[j++] = ch1;
      buff[j++] = ch2;

      if (n > 60)
         {
         buff[j++] = NEWLINE_CHAR; // Wrap to next line.
         n = 0;
         }               
      else
         {
         buff[j++] = SPACE_CHAR;
         n = j;
         } 

      i++;
      k--;
      } 

   buff[j] = NIL_CHAR;
         
   return;
}

// ---------------------------------------------------------------------

PRIVATE int VarNamesLVClicked( int whichitem )
{
   char buff[TXTLENGTH] = { 0, };
   
   StringNCopy( buff, &VarNodeStrs[ whichitem * TXTLENGTH ], TXTLENGTH - 1 );

   GT_SetGadgetAttrs( VAR_TEXTGAD, TrWnd, NULL,
                      GTTX_Text, (STRPTR) buff, TAG_DONE
                    );

   StringNCopy( buff, &ValNodeStrs[ whichitem * TXTLENGTH ], TXTLENGTH - 1 );

   GT_SetGadgetAttrs( VAL_TEXTGAD, TrWnd, NULL,
                      GTTX_Text, (STRPTR) buff, TAG_DONE
                    );

   // ADDRESS_STR TrGadgets[ ShowAddrStr ]

   return( TRUE );
}

PRIVATE int VarValuesLVClicked( int dummy )
{
   // Don't do anything (yet!).

   return( TRUE );
}

PRIVATE void DisplayTrObject( OBJECT *addr ); // Forward Declaration

PRIVATE void DisplayUserObject( OBJECT *addr )
{
   IMPORT ULONG DisplayLargeArray( OBJECT *addr, struct Window *parent );

   STRPTR claz    = NULL;
   STRPTR super   = NULL;
   CLASS *cl      = (CLASS *) addr->Class;
   CLASS *sup     = (CLASS *) fnd_super( addr );
   ULONG  retaddr = 0L;
   int    i       = 0;

   char   bbuf[2048] = { 0, }; // bbuf = BIG buffer.
   
   if (cl) // != NULL) 
      claz  = symbol_value( (SYMBOL *) cl->class_name );
         
   if (sup) // != NULL)
      {
      super = (STRPTR) symbol_value( (SYMBOL *) sup->class_name );
            
      // There's an unexpected extra level of indirection here:
      super = (STRPTR) symbol_value( (SYMBOL *) super );
      }

   sprintf( ErrMsg, TraceCMsg( MSG_USERCLASS_HEADER_TRACE ),
                    (!claz) ? TraceCMsg( MSG_NO_CLASS_NAME_TRACE ) : claz,
                    objRefCount( addr ), objSize( addr ),
                    addr->Class,     addr->super_obj
          );

   i = 0;
   StringCopy( bbuf, ErrMsg );

   if (objSize( addr ) > 28)
      {
      if ((retaddr = DisplayLargeArray( addr, TrWnd ))) // != NULL)
         DisplayTrObject( (OBJECT *) retaddr ); // Indirect RECURSION!
      
      return;
      }

   if (objSize( addr ) == 1)
      {
      char num[64] = { 0, };
            
      StringCat( bbuf, TraceCMsg( MSG_SPC_INST1_TRACE ) );

      sprintf( num, TraceCMsg( MSG_FMT_INST1_TRACE ), addr->inst_var[i] );

      StringCat( bbuf, num );
      }
   else
      {
      while (i < objSize( addr ))
         { 
         char num[64] = { 0, };
            
         StringCat( bbuf, TraceCMsg( MSG_SPC4_INST_TRACE ) );

         sprintf( num, TraceCMsg( MSG_FMT4_INST_TRACE ), i, addr->inst_var[i] );

         StringCat( bbuf, num );
         i++;

         if (i < objSize( addr )) // No easy way around this:
            {
            StringCat( bbuf, TraceCMsg( MSG_SPC2_INST_TRACE ) );

            sprintf( num, TraceCMsg( MSG_FMT2_INST_TRACE ), i, addr->inst_var[i] );

            StringCat( bbuf, num );
            i++;
            }
         }
      }

   sprintf( ErrMsg, TraceCMsg( MSG_FMT_CLASSSUPER_TRACE ),
                    (!claz)  ? TraceCMsg( MSG_NO_CLASS_NAME_TRACE ) : claz,
                    (!super) ? TraceCMsg( MSG_NO_SUPER_NAME_TRACE ) : super
          );

   StringCat( bbuf, ErrMsg ); 
        
   UserInfo( bbuf, TraceCMsg( MSG_OBJECT_IS_TRACE ) );

   return;
}

// ---------------------------------------------------------------------

PRIVATE OBJECT *ObjectTrace( OBJECT *addr )
{
   DisplayUserObject( addr );
 
   return( addr );
}

PRIVATE OBJECT *ClassTrace( OBJECT *addr )
{
   CLASS *cl = (CLASS *) addr;
         
   sprintf( ErrMsg, TraceCMsg( MSG_CLASS_HEADER_TRACE ),
                    symbol_value( (SYMBOL *) cl->class_name ),
                    objRefCount( (OBJECT *) cl ),
                    cl->class_name,    cl->super_class,
                    cl->file_name,     cl->inst_vars,
                    cl->message_names, cl->methods,
                    cl->context_size,  cl->stack_max,
                    cl->class_special
          );
   
   return( (OBJECT *) cl );
}

PRIVATE OBJECT *BytesTrace( OBJECT *addr )
{
   char bf[256] = { 0, };
   int  len;
         
   BYTEARRAY *b = (BYTEARRAY *) addr;
         
   sprintf( ErrMsg, TraceCMsg( MSG_BARRAY_HEADER_TRACE ),
                    objRefCount( (OBJECT *) b ), b->bsize
          );
         
   ConvertBytes( bf, b->bytes, 255, b->bsize );
         
   len = StringLength( ErrMsg );
         
   StringNCat( ErrMsg, bf, 256 - len );

   return( (OBJECT *) b );
}

PRIVATE OBJECT *SymbolTrace( OBJECT *addr )
{
   SYMBOL *s = (SYMBOL *) addr;   

   sprintf( ErrMsg, TraceCMsg( MSG_SYMBOL_HEADER_TRACE ),
                    symbol_value( s ),
                    objRefCount( (OBJECT *) s ),
                    s->value
          );

   return( (OBJECT *) s );
}
         
PRIVATE OBJECT *InterpTrace( OBJECT *addr )
{
   INTERPRETER *ip = (INTERPRETER *) addr;
                
   sprintf( ErrMsg, TraceCMsg( MSG_INTERP_HEADER_TRACE ),
                    objRefCount( (OBJECT *) ip ),
                    ip->creator,   ip->sender,
                    ip->bytecodes, ip->receiver,
                    ip->literals,  ip->context,
                    ip->stack,     ip->stacktop,
                    ip->currentbyte
          );

   return( (OBJECT *) ip );
}
         
PRIVATE OBJECT *ProcessTrace( OBJECT *addr )
{
   PROCESS *p = (PROCESS *) addr;
                
   sprintf( ErrMsg, TraceCMsg( MSG_PROCESS_HEADER_TRACE ),
                    objRefCount( (OBJECT *) p ),
                    p->interp,    p->prev,
                    p->next,      p->state
          );

   return( (OBJECT *) p );
}
         
PRIVATE OBJECT *BlockTrace( OBJECT *addr )
{
   BLOCK *baddr = (BLOCK *) addr;
         
   sprintf( ErrMsg, TraceCMsg( MSG_BLOCK_HEADER_TRACE ),
                          objRefCount( (OBJECT *) baddr ),
                          baddr->interpreter, baddr->numargs,
                          baddr->arglocation
          );

   return( (OBJECT *) baddr );
} 
         
PRIVATE OBJECT *FileTrace( OBJECT *addr )
{
   AT_FILE *fp = (AT_FILE *) addr;
         
   sprintf( ErrMsg, TraceCMsg( MSG_FILE_HEADER_TRACE ),
                          objRefCount( (OBJECT *) fp ), fp->file_mode, fp->fp
          );
   
   return( (OBJECT *) fp );
}

PRIVATE OBJECT *CharTrace( OBJECT *addr )
{
   INTEGER *it = (INTEGER *) addr;
         
   sprintf( ErrMsg, TraceCMsg( MSG_CHAR_HEADER_TRACE ),
                    it->value, objRefCount( (OBJECT *) it ), it->value
          );

   return( (OBJECT *) it );
}

PRIVATE OBJECT *IntegerTrace( OBJECT *addr )
{
   INTEGER *it = (INTEGER *) addr;
         
   sprintf( ErrMsg, TraceCMsg( MSG_INTEGER_HEADER_TRACE ),
                    it->value, objRefCount( (OBJECT *) it ), it->value
          );

   return( (OBJECT *) it );
}
         
PRIVATE OBJECT *StringTrace( OBJECT *addr )
{
   STRING *s = (STRING *) addr;
               
   sprintf( ErrMsg, TraceCMsg( MSG_STRING_HEADER_TRACE ),
                    s->value, objRefCount( (OBJECT *) s ),
                    s->value, s->value
          );

   return( (OBJECT *) s );
}

PRIVATE OBJECT *FloatTrace( OBJECT *addr )
{
   SFLOAT *fl = (SFLOAT *) addr;
         
   sprintf( ErrMsg, TraceCMsg( MSG_FLOAT_HEADER_TRACE ),
                    fl->value, objRefCount( (OBJECT *) fl ), fl->value
          );
 
   return( (OBJECT *) fl );
}
         
PRIVATE OBJECT *ClassSpecTrace( OBJECT *addr )
{
   CLASS_SPEC *sp = (CLASS_SPEC *) addr;
         
   sprintf( ErrMsg, TraceCMsg( MSG_SPECIAL_HEADER_TRACE ),
                    objRefCount( (OBJECT *) sp ), objSize( (OBJECT *) sp ), 
                    symbol_value( (SYMBOL *) sp->class_name ),
                    sp->super_class, sp->myInstance,
                    (sp->flags & SPF_INITIALIZED) ? TraceCMsg( MSG_INITIALIZED_TRACE ) 
                                                  : TraceCMsg( MSG_CLEAR_STR_TRACE )
           );

   return( (OBJECT *) sp );
}
         
PRIVATE OBJECT *ClassEntryTrace( OBJECT *addr )
{
   sprintf( ErrMsg, TraceCMsg( MSG_FMT_UNKNOWN_HEADER_TRACE ), addr );
          
   return( addr );
}

PRIVATE OBJECT *SDictTrace( OBJECT *addr )
{
   sprintf( ErrMsg, TraceCMsg( MSG_FMT_UNKNOWN_HEADER_TRACE ), addr );
          
   return( addr );
}

PRIVATE OBJECT *AddressTrace( OBJECT *addr )
{
   AT_ADDRESS *it = (AT_ADDRESS *) addr;
         
   sprintf( ErrMsg, TraceCMsg( MSG_ADDRESS_HEADER_TRACE ),
                    it, objRefCount( (OBJECT *) it ), it->value
          );

   return( (OBJECT *) it );
}

PRIVATE ULONG Tracers[] = {
   
   (ULONG) &ObjectTrace,    (ULONG) &ClassTrace,      (ULONG) &BytesTrace,  (ULONG) &SymbolTrace, 
   (ULONG) &InterpTrace,    (ULONG) &ProcessTrace,    (ULONG) &BlockTrace,  (ULONG) &FileTrace,  
   (ULONG) &CharTrace,      (ULONG) &IntegerTrace,    (ULONG) &StringTrace, (ULONG) &FloatTrace, 
   (ULONG) &ClassSpecTrace, (ULONG) &ClassEntryTrace, (ULONG) &SDictTrace,  (ULONG) &AddressTrace
};

PRIVATE void DisplayTrObject( OBJECT *addr )
{
   FBEGIN( printf( "DisplayTrObject( 0x%08LX )\n", addr ) );    

   (void) ObjActionByType( addr, 
                           (OBJECT * (**)( OBJECT * )) Tracers 
                         );
   
   UserInfo( ErrMsg, TraceCMsg( MSG_OBJECT_IS_TRACE ) );

   FEND( printf( "DisplayTrObject() exits\n" ) );   

   return;
}

PRIVATE int ShowAddrStrClicked( int dummy )
{
   IMPORT char *symbol_value( SYMBOL * );

   char   buff[33] = { 0, };
   OBJECT *addr     = NULL;
   long    obj_addr = 0L;
      
   StringCopy( buff, StrBfPtr( ADDRESS_STR ) );

#  ifdef  __SASC
   (void) stch_l( buff, &obj_addr );
#  else
   (void) hexStrToLong( buff, &obj_addr );
#  endif

   addr = (OBJECT *) obj_addr;

   DisplayTrObject( addr );
   
   return( TRUE );
}

// ---------------------------------------------------------------------

PRIVATE void TrRender( void )
{
   struct IntuiText it;
   
   ComputeFont( Scr, Font, &CFont, TrWidth, TrHeight );

   CopyMem( (char *) &TrIText[ 0 ], (char *) &it, 
            (long) sizeof( struct IntuiText )
          );

   it.ITextFont = Font;

   it.LeftEdge  = CFont.OffX + ComputeX( CFont.FontX, it.LeftEdge ) 
                             - (IntuiTextLength( &it ) >> 1);

   it.TopEdge   = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge ) 
                             - (Font->ta_YSize >> 1);

   PrintIText( TrWnd->RPort, &it, 0, 0 );

   return;
}

PRIVATE int OpenTrWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = TrLeft, wtop = TrTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, TrWidth, TrHeight );

   ww = ComputeX( CFont.FontX, TrWidth );
   wh = ComputeY( CFont.FontY, TrHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;
   
   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if (!(TrFont = OpenDiskFont( Font ))) // == NULL)
      return( -5 );

   if (!(g = CreateContext( &TrGList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < Tr_CNT; lc++) 
      {
      CopyMem( (char *) &TrNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = Font;

      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, 
                                                ng.ng_LeftEdge
                                              );

      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY, 
                                                ng.ng_TopEdge
                                              );

      ng.ng_Width      = ComputeX( CFont.FontX, ng.ng_Width );
      ng.ng_Height     = ComputeY( CFont.FontY, ng.ng_Height);

      TrGadgets[ lc ] = g = CreateGadgetA( (ULONG) TrGTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &TrGTags[ tc ] );

      while (TrGTags[ tc ] != TAG_DONE) 
         tc += 2;
      
      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(TrWnd = OpenWindowTags( NULL,

            WA_Left,         wleft,
            WA_Top,          wtop,
            WA_Width,        ww + CFont.OffX + Scr->WBorRight,
            WA_Height,       wh + CFont.OffY + Scr->WBorBottom,

            WA_IDCMP,        LISTVIEWIDCMP | TEXTIDCMP | STRINGIDCMP
              | IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

            WA_Flags,        WFLG_DRAGBAR | WFLG_DEPTHGADGET 
              | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE
              | WFLG_RMBTRAP,

            WA_Gadgets,      TrGList,
            WA_Title,        TrWdt,
            WA_CustomScreen, Scr,
            TAG_DONE )
      
      )) // == NULL)
      return( -4 );

   GT_RefreshWindow( TrWnd, NULL );

   TrRender();

   return( 0 );
}

PRIVATE void CloseTrWindow( void )
{
   if (TrWnd) // != NULL) 
      {
      CloseWindow( TrWnd );
      TrWnd = NULL;
      }

   if (TrGList) // != NULL) 
      {
      FreeGadgets( TrGList );
      TrGList = NULL;
      }

   if (TrFont) // != NULL) 
      {
      CloseFont( TrFont );
      TrFont = NULL;
      }

   return;
}

PRIVATE int TrCloseWindow( void )
{
   CloseTrWindow();

   return( FALSE );
}

PRIVATE int TrVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case CAP_Q_CHAR:
      case SMALL_Q_CHAR:

         rval = FALSE;
         break;
      }
      
   return( rval );
}

PRIVATE int HandleTrIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( int );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( TrWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << TrWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &TrMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch ( TrMsg.Class ) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( TrWnd );
            TrRender();
            GT_EndRefresh( TrWnd, TRUE );
            break;

         case IDCMP_CLOSEWINDOW:
            running = TrCloseWindow();
            break;

         case IDCMP_VANILLAKEY:
            running = TrVanillaKey( TrMsg.Code );
            break;

         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (int (*)( int )) ((struct Gadget *)TrMsg.IAddress)->UserData;

            if (func) // != NULL)
               running = func( TrMsg.Code );

            break;
         }
      }

   return( running );
}

// ----------------------------------------------------------------------

PRIVATE char    valbuf[  512       ] = { 0, };
PRIVATE char    objtype[ TXTLENGTH ] = { 0, };
PRIVATE ULONG   addr                 = 0L;

PRIVATE OBJECT *var_values  = NULL;
PRIVATE OBJECT *var_names   = NULL;

// ----------------------------------------------------------------------

PRIVATE OBJECT *fillWithObject( OBJECT *obj )
{
   CLASS  *cl   = (CLASS  *) obj->Class;
   SYMBOL *name = (SYMBOL *) obj;
      
   valbuf[0] = '\0';
               
   if (!cl) // == NULL)
      {
      sprintf( valbuf, TraceCMsg( MSG_FMT_TEMPOBJ_TRACE ), obj ); 
      }
   else
      {
      STRPTR claz = NULL;
            
      name = (SYMBOL *) cl->class_name;

      if (symbol_value( name )) // != NULL)
         claz = (STRPTR) symbol_value( name );
                                         
      sprintf( valbuf, TraceCMsg( MSG_FMT_USEROBJ_TRACE ),
                       obj,
                       (!claz) ? TraceCMsg( MSG_NULL_QUESTION_TRACE ) : claz 
             ); 
      }

   return( obj );
}

PRIVATE OBJECT *fillWithClass( OBJECT *obj )
{
   SYMBOL *cname = (SYMBOL *) obj;

   valbuf[0] = '\0';
               
   StringNCopy( &objtype[0], TraceCMsg( MSG_CLASS_ARROW_TRACE ), 50 );

   addr = (ULONG) obj;

   sprintf( valbuf, TraceCMsg( MSG_FMT_SYMBOLVAL_TRACE ),
                    objtype, symbol_value( cname ), addr
          );

   return( obj );
}

PRIVATE OBJECT *fillWithByteArray( OBJECT *obj )
{
   char       ba[ TXTLENGTH - 14 ] = { 0, };
   int        bsize;
   BYTEARRAY *byt;
               
   valbuf[0] = '\0';

   StringNCopy( &objtype[0], TraceCMsg( MSG_BARRAY_ARROW_TRACE ), 50 );
                           
   byt   = (BYTEARRAY *) obj;
   bsize = byt->bsize;

   ConvertBytes( &ba[0], byt->bytes, TXTLENGTH - 14, bsize );
               
   sprintf( valbuf, TraceCMsg( MSG_FMT_BARRAYVAL_TRACE ), 
                    objtype, obj, bsize, &ba[0]
          );

   return( obj );
}

PRIVATE OBJECT *fillWithSymbol( OBJECT *obj )
{
   SYMBOL *name = (SYMBOL *) obj;
      
   valbuf[0] = '\0';

   StringNCopy( &objtype[0], TraceCMsg( MSG_SYMBOL_ARROW_TRACE ), 50 );
         
   sprintf( valbuf, TraceCMsg( MSG_FMT_SYMBOLVAL2_TRACE ),
                    objtype, symbol_value( name ), obj
          );
 
   return( obj );
}

PRIVATE OBJECT *fillWithInterp( OBJECT *obj )
{
   INTERPRETER *sender;
                
   valbuf[0] = '\0';

   StringNCopy( &objtype[0], TraceCMsg( MSG_INTERP_ARROW_TRACE ), 50 );

   addr   = (ULONG) obj;
   sender = ((INTERPRETER *) obj)->sender;

   sprintf( valbuf, TraceCMsg( MSG_FMT_INTERPVAL_TRACE ), 
                    objtype, addr, sender
          );

   return( obj );
}

PRIVATE OBJECT *fillWithProcess( OBJECT *obj )
{
   INTERPRETER *interp;
                
   valbuf[0] = '\0';

   StringNCopy( &objtype[0], TraceCMsg( MSG_PROCESS_ARROW_TRACE ), 50 );

   addr   = (ULONG) obj;
   interp = ((PROCESS *) obj)->interp;

   sprintf( valbuf, TraceCMsg( MSG_FMT_PROCESSADDR_TRACE ), 
                    objtype, addr, interp
          );

   return( obj );
}

PRIVATE OBJECT *fillWithBlock( OBJECT *obj )
{
   ULONG interp = (ULONG) (((BLOCK *) obj)->interpreter);

   valbuf[0] = '\0';
   
   StringNCopy( &objtype[0], TraceCMsg( MSG_BLOCK_ARROW_TRACE ), 50 );

   addr = (ULONG) obj;

   sprintf( valbuf, TraceCMsg( MSG_FMT_INTERPADDR_TRACE ),
                         objtype, addr, interp
          );
   
   return( obj );
}

PRIVATE OBJECT *fillWithFile( OBJECT *obj )
{
   valbuf[0]  = '\0';
   objtype[0] = '\0';
   
   StringNCopy( &objtype[0], TraceCMsg( MSG_FILE_ARROW_TRACE ), 50 );

   addr = (ULONG) obj;

   sprintf( valbuf, TraceCMsg( MSG_FMT_FILEADDR_TRACE ),
                    objtype, addr
          );

   return( (OBJECT *) addr );
}

PRIVATE OBJECT *fillWithChar( OBJECT *obj )
{
   valbuf[0]  = '\0';

   StringNCopy( &objtype[0], TraceCMsg( MSG_CHAR_ARROW_TRACE ), 50 );

   sprintf( valbuf, TraceCMsg( MSG_FMT_CHARVALUE_TRACE ), 
                    objtype, char_value( obj ), obj
          );

   return( obj );
}

PRIVATE OBJECT *fillWithInteger( OBJECT *obj )
{
   valbuf[0]  = '\0';

   StringNCopy( &objtype[0], TraceCMsg( MSG_INTEGER_ARROW_TRACE ), 50 );

   sprintf( valbuf, TraceCMsg( MSG_FMT_INTEGERVAL_TRACE ),
                    objtype, int_value( obj ), obj
          );

   return( obj );
}

PRIVATE OBJECT *fillWithString( OBJECT *obj )
{
   char *str = (char *) string_value( (STRING *) obj ); 
               
   valbuf[0]  = '\0';

   StringNCopy( &objtype[0], TraceCMsg( MSG_STRING_ARROW_TRACE ), 50 );
               
   sprintf( valbuf, TraceCMsg( MSG_FMT_STRINGVAL_TRACE ), objtype, obj, str );

   return( obj );
}

PRIVATE OBJECT *fillWithFloat( OBJECT *obj )
{
   valbuf[0]  = '\0';

   StringNCopy( &objtype[0], TraceCMsg( MSG_FLOAT_ARROW_TRACE ), 50 );

   sprintf( valbuf, TraceCMsg( MSG_FMT_FLOATVAL_TRACE ), 
                    objtype, float_value( obj ), obj
          );

   return( (OBJECT *) obj );
}

PRIVATE OBJECT *fillWithUnknown( OBJECT *obj )
{
   CLASS  *cl   = (CLASS  *) obj->Class;
   SYMBOL *name = (SYMBOL *) obj;
      
   valbuf[0] = '\0';
         
   if (!cl) // == NULL)
      {
      sprintf( valbuf, TraceCMsg( MSG_FMT_TEMPOBJ_TRACE ), obj ); 
      }
   else
      {
      STRPTR claz = NULL;
            
      name = (SYMBOL *) cl->class_name;

      if (symbol_value( name )) // != NULL)
         claz = (STRPTR) symbol_value( name );
                                         
      sprintf( valbuf, TraceCMsg( MSG_FMT_USEROBJ_TRACE ),
                       obj,
                       (!claz) ? TraceCMsg( MSG_NULL_QUESTION_TRACE ) : claz 
             ); 
      }
 
   return( obj );
}

PRIVATE OBJECT *fillWithAddress( OBJECT *obj )
{
   valbuf[0]  = '\0';

   StringNCopy( &objtype[0], TraceCMsg( MSG_INTEGER_ARROW_TRACE ), 50 );

   sprintf( valbuf, TraceCMsg( MSG_FMT_INTEGERVAL_TRACE ),
                    objtype, int_value( obj ), obj
          );

   return( obj );
}


PRIVATE ULONG fillAction[] = {

   (ULONG) &fillWithObject,  (ULONG) &fillWithClass,   (ULONG) &fillWithByteArray, (ULONG) &fillWithSymbol,
   (ULONG) &fillWithInterp,  (ULONG) &fillWithProcess, (ULONG) &fillWithBlock,     (ULONG) &fillWithFile,
   (ULONG) &fillWithChar,    (ULONG) &fillWithInteger, (ULONG) &fillWithString,    (ULONG) &fillWithFloat,
   (ULONG) &fillWithUnknown, (ULONG) &fillWithUnknown, (ULONG) &fillWithUnknown,   (ULONG) &fillWithAddress
};

PRIVATE void FillListViewers( int numitems )
{
   IMPORT OBJECT *retrieveVarValues( void ); // In Drive.c
   IMPORT OBJECT *makeVarNameObject( void );

   int  i;

   FBEGIN( printf( "void FillListViewers( %d )\n", numitems ) );   

   var_values = retrieveVarValues();
   var_names  = makeVarNameObject();
   
   for (i = 0; i < numitems; i++)
      {
      SYMBOL *name;
      
      name = (SYMBOL *) var_names->inst_var[i];
      
      StringNCopy( &VarNodeStrs[ i * TXTLENGTH ], 
                symbol_value( name ), TXTLENGTH - 1
             );

      (void) ObjActionByType( var_values->inst_var[i], 
                              (OBJECT * (**)( OBJECT * )) fillAction 
                            );
      
      StringNCopy( &ValNodeStrs[ i * TXTLENGTH ], valbuf, TXTLENGTH - 1 );
      }

   ModifyListView( VAR_LIST, TrWnd, &VarLVList, VAR_TEXTGAD );

   ModifyListView( VAL_LIST, TrWnd, &ValLVList, VAL_TEXTGAD );

   FEND( printf( "FillListViewers() exits\n" ) );

   return;
}

// Called from Main.c & ATMenus.c:

PUBLIC void Trace( struct Window *parent )
{
   IMPORT ULONG retrieveVarCount( void ); // In Drive.c

   IMPORT struct Window *ATWnd;
   
   int numitems; //, Guard1 = 0, Guard2 = 0;   

   if (OpenTrWindow() < 0)
      {
      NotOpened( 1 ); // TraceTraceCMsg( MSG_WINDOW_TRACE ) );
      
      return;
      }

   numitems = retrieveVarCount();
   
   if (!(LVVars = Guarded_AllocLV( numitems, TXTLENGTH ))) // == NULL)
      {
      ReportAllocLVError();

      return;
      }

   VarNodeStrs = LVVars->lvm_NodeStrs;
   VarLVNodes  = LVVars->lvm_Nodes;
               
   if (!(LVVals = Guarded_AllocLV( numitems, TXTLENGTH ))) // == NULL)
      {
      ReportAllocLVError();

      Guarded_FreeLV( LVVars );
      return;
      }

   ValNodeStrs = LVVals->lvm_NodeStrs;
   VarLVNodes  = LVVals->lvm_Nodes;

   SetupList( &VarLVList, LVVars );
   SetupList( &ValLVList, LVVals );

   FillListViewers( numitems );

   SetNotifyWindow( TrWnd );
   
   (void) HandleTrIDCMP();
    
   Guarded_FreeLV( LVVals );

   Guarded_FreeLV( LVVars );

   SetNotifyWindow( parent );

   return;
}

/* --------------------- END of Tracer.c file! ------------------- */
