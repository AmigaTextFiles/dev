/*______________________________________________________________________________________
 |                                                                                      |
 |    waveforms image                                                                   |
 |    Copyright (c) 2000 stranded UFO productions                                       |
 |    Written by Paul Juhasz                                                            |
 |______________________________________________________________________________________*/


#define __USE_SYSBASE        // perhaps only recognized by SAS/C

#include "compiler.h"
#include "waveforms.h"
#include "waveforms_protos.h"

#undef  GfxBase
#undef  IntuitionBase
#undef  UtilityBase
#define SysBase                  cb->wfi_SysBase
#define GfxBase                  cb->wfi_GfxBase
#define IntuitionBase            cb->wfi_IntuitionBase
#define UtilityBase              cb->wfi_UtilityBase


/****** waveforms.image/--datasheet-- ***********************************************
*
*    NAME
*       waveforms.image--Audio Waveforms display images.                 (V0)
*
*    SUPERCLASS
*       imageclass
*
*    DESCRIPTION
*       The waveforms.image class provides a selectable waveform image display.
*
*    METHODS
*       OM_NEW--Create the waveforms.  Passed to superclass, then OM_SET.
*
*       OM_SET--Set object attributes.  Passed to superclass first.
*
*       OM_GET--Get object attributes.  Passed to superclass first.
*
*       OM_UPDATE--Set object notification attributes.  Passed to superclass
*           first.
*
*       IM_DRAW--Renders the images.  Overrides the superclass.
*
*       All other methods are passed to the superclass, including OM_DISPOSE.
*
*    ATTRIBUTES
*
*       SYSIA_DrawInfo (struct DrawInfo *) -- Contains important pen                 IS
*           information.  This is required if IA_BGPen and IA_FGPen are
*           not specified.
*
*       IA_Pens -- pointer to UWORD pens[]                                           IS
*
*       IA_FGPen (LONG) -- Pen to use to draw the hilite box outline or BLOCKPEN.    IS
*
*       IA_BGPen (LONG) -- Pen to use to draw the shadow box outline or DETAILPEN.   IS
*
*       IA_Width (WORD) -- Width of the image - def 64 pixels.                       IS
*
*       IA_Height (WORD) -- Height of the image - def 64 pixels.                     IS
*
*
*    Private Tags:
*
*       WFI_WaveType (LONG) -- Which of the 5 types of waveforms is used.            ISG
*
*              WF_SINE_WAVE         0
*              WF_TRIANGULAR_WAVE   1
*              WF_RAMPUP_WAVE       2
*              WF_RAMPDOWN_WAVE     3
*              WF_SQUARE_WAVE       4
*
*       WFI_WaveShape (LONG) -- Pulse width for square wave only. Values can be      ISG
*                                             from -98 to +98.
*
*       WFI_Outline (LONG) -- Draw the wave either as WF_SOLID_DISPLAY               ISG
*                                                  or as WF_DOTTED_DISPLAY
*
*       WFI_BoxFrame (LONG) -- Draw a box frame around the graphic or none           IS
*                                   the graphic will be adjusted to fit inside
*
*       WFI_OsciPen (WORD) -- Pen to use to draw the 'oscilloscope screen'           ISG
*                                   background.  If -1 is specified then
*                                   BARBLOCKPEN is used.
*
*       WFI_WavePen (WORD) -- Pen to use to draw the wave.  If -1 is                 IS
*                                   specified then BARDETAILPEN is used.
*
*       WFI_ZeroPen (WORD) -- Draw the zero line using this colour.  The             ISG
*                                   zero line is only drawn when the option
*                                   WF_DOTTED_DISPLAY is selected.  Defaults
*                                   to WF_OsciPen for 'invisible' line or to
*                                   BARTRIMPEN if -1 is specified.
*
*
*******************************************************************************
*
*  P. Juhasz
*
*/


/*______________________________________________________________________________________
 |                                                                                      |
 |    Inquire attribute tag values from the waveform.image                              |
 |______________________________________________________________________________________*/

STATIC ULONG getAttrsMethod( Class *cl, struct Image *im, struct opGet *msg )
{
   struct waveformData *wfd  = INST_DATA( cl, im );

   switch ( msg->opg_AttrID )
   {
      case WFI_WaveType:
         *msg->opg_Storage = (ULONG)wfd->wf_WaveType;
         break;

      case WFI_WaveShape:
         *msg->opg_Storage = (ULONG)wfd->wf_WaveShape;
         break;

      case WFI_Outline:
         *msg->opg_Storage = (ULONG)wfd->wf_Outline;
         break;

      case WFI_OsciPen:
         *msg->opg_Storage = (ULONG)wfd->wf_OsciPen;
         break;

      case WFI_ZeroPen:
         *msg->opg_Storage = (ULONG)wfd->wf_ZeroPen;
         break;

      /* Let the superclass try */
      default:
         return((ULONG)DoSuperMethodA( cl, (Object *)im, (Msg)msg ));
   }
   return( 1UL );
}


/*______________________________________________________________________________________
 |                                                                                      |
 |    Update the waveform.image from tag values and prepare it                          |
 |______________________________________________________________________________________*

STATIC LONG notifyMethod( Class *cl, struct Image *im, struct opSet *msg )
{
   struct WFIBase         *cb = cl->cl_Dispatcher.h_Data;
   struct waveformData    *wfd  = INST_DATA( cl, im );
   struct TagItem         *tags = msg->ops_AttrList, *tstate, *tag;
   ULONG                   tidata;
   LONG                    refresh = 0L;

   return( refresh );
} */


/*______________________________________________________________________________________
 |                                                                                      |
 |    Update the waveform.image from tag values and prepare it                          |
 |______________________________________________________________________________________*/

STATIC LONG setAttrsMethod( Class *cl, struct Image *im, struct opSet *msg, BOOL init )
{
   struct WFIBase         *cb = cl->cl_Dispatcher.h_Data;
   struct waveformData    *wfd  = INST_DATA( cl, im );
   struct TagItem         *tags = msg->ops_AttrList, *tstate, *tag;
   ULONG                   tidata;
   LONG                    refresh = 0L;

   /* Initialize the variables */
   tstate = tags;

   if ( init )       im->Width = im->Height = 64;

   else              refresh = DoSuperMethodA( cl, (Object *)im, (Msg)msg );

   while ( tag = NextTagItem( &tstate ))
   {
      tidata = tag->ti_Data;
      switch ( tag->ti_Tag )
      {
         case SYSIA_DrawInfo:
            wfd->wf_DrawInfo = (struct DrawInfo *)tidata;
            break;

         case IA_BGPen:
            wfd->wf_ShadowPen = (WORD)tidata;
            refresh = 1;
            break;

         case IA_FGPen:
            wfd->wf_HiLitePen = (WORD)tidata;
            refresh = 1;
            break;

         case IA_Width:
            im->Width = (WORD)tidata;
            refresh = 1;
            break;

         case IA_Height:
            im->Height = (WORD)tidata;
            refresh = 1;
            break;

         case WFI_OsciPen:
            wfd->wf_OsciPen = (WORD)tidata;
            refresh = 1;
            break;

         case WFI_WavePen:
            wfd->wf_WavePen = (WORD)tidata;
            refresh = 1;
            break;

         case WFI_ZeroPen:
            wfd->wf_ZeroPen = (WORD)tidata;
            refresh = 1;
            break;

         case WFI_WaveShape:
            wfd->wf_WaveShape = tidata;
            refresh = 1;
            break;

         case WFI_WaveType:
            wfd->wf_WaveType = tidata;
            refresh = 1;
            break;

         case WFI_Outline:
            wfd->wf_Outline = tidata;
            refresh = 1;
            break;

         case WFI_BoxFrame:
            wfd->wf_BoxFrame = tidata;
            refresh = 1;
            break;

         default:
            break;
      }
   }

   /* Make sure we have valid pens and other sanity checks... */
   if ( wfd->wf_DrawInfo ) {
      if ( wfd->wf_ShadowPen == -1 )
         wfd->wf_ShadowPen = wfd->wf_DrawInfo->dri_Pens[BLOCKPEN];
      if ( wfd->wf_HiLitePen == -1 )
         wfd->wf_HiLitePen = wfd->wf_DrawInfo->dri_Pens[DETAILPEN];
      if ( wfd->wf_WavePen == -1 )
         wfd->wf_WavePen = wfd->wf_DrawInfo->dri_Pens[BARDETAILPEN];
      if ( wfd->wf_OsciPen == -1 )
         wfd->wf_OsciPen = wfd->wf_DrawInfo->dri_Pens[BARBLOCKPEN];
      if ( wfd->wf_ZeroPen == -1 )
         wfd->wf_ZeroPen = wfd->wf_DrawInfo->dri_Pens[BARTRIMPEN];
   }

   if (( wfd->wf_WaveType > WF_SQUARE_WAVE ) || ( wfd->wf_WaveType < WF_SINE_WAVE ))
      wfd->wf_WaveType = WF_SINE_WAVE;
   if (( wfd->wf_WaveShape > 98L ) || ( wfd->wf_WaveShape < -98L ))
      wfd->wf_WaveShape = 0L;
   if (( wfd->wf_Outline != WF_SOLID_DISPLAY ) && ( wfd->wf_Outline != WF_DOTTED_DISPLAY ))
      wfd->wf_Outline = WF_DOTTED_DISPLAY;

   return( refresh );
}


/*__________________________________________________________________________________________
 |                                                                                          |
 |    Data for Sintable                                                                     |
 |    As using Floating Point Numbers would be Tooooo Slow for the Computer to              |
 |    attain a suitable frame rate the values are first all multiplied by 16384             |
 |    which just happens to be 14 shifts left  (very helpfull) which gets                   |
 |    rid of the decimal Point and then when multiplied with X or Y are then                |
 |    Divided by 16384 (14 shifts right)                                                    |
 |    Using this technique fast 3d graphics can be possible.                                |
 |__________________________________________________________________________________________*/

/*__________________________________________________________________________________________
 |                                                                                          |
 |    Draw the selected waveform.image into the window                                      |
 |__________________________________________________________________________________________*/

STATIC LONG drawMethod( Class *cl, struct Image *im, struct impDraw *msg )
{
   struct WFIBase         *cb = cl->cl_Dispatcher.h_Data;
   struct waveformData    *wfd = INST_DATA( cl, im );
   struct RastPort        *rp = msg->imp_RPort;
   LONG                    wwid = im->Width - 1L, whgt = im->Height - 1L;
   LONG                    tx = msg->imp_Offset.X, ty = msg->imp_Offset.Y,
                           ix, gwid, ghgt, ghlf, gmid, shape, samval, samdiv,
                           halfw, quart, incr, fram = 1L, dfram, amplitude, sinstep;
   const WORD              sin_tab[] = { 0,
         286,   572,   857,  1143,  1428,  1713,  1997,  2280,  2563,  2845,  3126,  3406,  3686,
        3964,  4240,  4516,  4790,  5063,  5334,  5604,  5872,  6138,  6402,  6664,  6924,  7182,
        7438,  7692,  7943,  8192,  8438,  8682,  8923,  9162,  9397,  9630,  9860, 10087, 10311,
       10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911,
       13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849,
       14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026,
       16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382, 16384,  /*   90  */
       16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964,
       15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14967, 14849, 14726,
       14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733,
       12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087,
        9860,  9630,  9397,  9162,  8923,  8682,  8438,  8192,  7943,  7692,  7438,  7182,  6924,
        6664,  6402,  6138,  5872,  5604,  5334,  5063,  4790,  4516,  4240,  3964,  3686,  3406,
        3126,  2845,  2563,  2280,  1997,  1713,  1428,  1143,   857,   572,   286,     0,  /*  180  */
        -286,  -572,  -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686,
       -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182,
       -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860,-10087,-10311,
      -10531,-10749,-10963,-11174,-11381,-11585,-11786,-11982,-12176,-12365,-12551,-12733,-12911,
      -13085,-13255,-13421,-13583,-13741,-13894,-14044,-14189,-14330,-14466,-14598,-14726,-14849,
      -14968,-15082,-15191,-15296,-15396,-15491,-15582,-15668,-15749,-15826,-15897,-15964,-16026,
      -16083,-16135,-16182,-16225,-16262,-16294,-16322,-16344,-16362,-16374,-16382,-16384,  /*  270  */
      -16382,-16374,-16362,-16344,-16322,-16294,-16262,-16225,-16182,-16135,-16083,-16026,-15964,
      -15897,-15826,-15749,-15668,-15582,-15491,-15396,-15296,-15191,-15082,-14967,-14849,-14726,
      -14598,-14466,-14330,-14189,-14044,-13894,-13741,-13583,-13421,-13255,-13085,-12911,-12733,
      -12551,-12365,-12176,-11982,-11786,-11585,-11381,-11174,-10963,-10749,-10531,-10311,-10087,
       -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924,
       -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406,
       -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857,   -572,  -286,     0,     0
   };

   /* Initialise the constants and variables that we need */
   shape = wfd->wf_WaveShape;
   SetBPen( rp, wfd->wf_OsciPen );

   SetAPen( rp, wfd->wf_OsciPen );                 /* switching to 'oscilloscope' colour */
   RectFill( rp, tx, ty, tx + wwid, ty + whgt );      /* for the background */

   if ( wfd->wf_BoxFrame ) {
      SetAPen( rp, wfd->wf_ShadowPen );            /* switching to shadow outline */
      Move( rp, tx, ty + whgt );
      Draw( rp, tx, ty );                             /* Draw half of the box */
      Draw( rp, tx + wwid, ty );
      SetAPen( rp, wfd->wf_HiLitePen );            /* switching to hilite outline */
      Draw( rp, tx + wwid, ty + whgt );
      Draw( rp, tx, ty + whgt );                      /* draw other half of box */
      fram = ( wwid >= 25L ) ? ( wwid / 12L ) : 2L; /* adjust waveform to fit inside frame */
   }

   dfram = fram * 2L;
   tx += fram; ty += fram;
   gwid = wwid - dfram; ghgt = whgt - dfram;
   gmid = ( gwid / 2 ); ghlf = ( ghgt / 2 );

   if ( wfd->wf_Outline == WF_DOTTED_DISPLAY ) {
      if ( wfd->wf_ZeroPen ) {
         SetAPen( rp, wfd->wf_ZeroPen );           /* Draw the zero line when needed */
         Move( rp, tx, ty + ghlf );
         Draw( rp, tx + gwid, ty + ghlf );
      }
   }

   /* ...and all is ready now, so let's draw up the wave for display */
   SetAPen( rp, wfd->wf_WavePen );

   switch ( wfd->wf_WaveType ) {

      case WF_SINE_WAVE:                  /*    use the above pre-calculated sine-table.  */
         ix = 0L; sinstep = 0L;
         while ( ix < gwid ) {
            amplitude = (((LONG)sin_tab[( sinstep / 100L )] * ghlf ) >> 14 );
            sinstep += ( 36000 / gwid );
            if ( wfd->wf_Outline == WF_SOLID_DISPLAY ) {
               Move( rp, tx + ix, ty + ghlf );
               Draw( rp, tx + ix, ty + ghlf - amplitude );
            } else      WritePixel( rp, tx + ix, ( ty + ghlf - amplitude ));
            ix++;
         }
         break;

      case WF_TRIANGULAR_WAVE:

         quart = gmid >> 1;
         samval = 0; incr = ( ghlf * 1000 ) / quart;
         for ( ix = 0; ix <= quart; ix++ ) {
            samdiv = samval / 1000;
            if ( wfd->wf_Outline == WF_SOLID_DISPLAY ) {
               Move( rp, tx + ix, ty + ghlf );
               Draw( rp, tx + ix, ty + ghlf - samdiv );              /* first quarter */
               Move( rp, tx + ( gmid - ix ), ty + ghlf );
               Draw( rp, tx + ( gmid - ix ), ty + ghlf - samdiv );   /* second quarter */
               Move( rp, tx + gmid + ix, ty + ghlf );
               Draw( rp, tx + gmid + ix, ty + ghlf + samdiv );       /* third quarter */
               Move( rp, tx + gmid + gmid - ix, ty + ghlf );
               Draw( rp, tx + gmid + gmid - ix, ty + ghlf + samdiv );   /* fourth quarter */
            } else {
               WritePixel( rp, tx + ix, ( ty + ghlf - samdiv ));
               WritePixel( rp, tx + ( gmid - ix ), ( ty + ghlf - samdiv ));
               WritePixel( rp, tx + ( gmid + ix ), ( ty + ghlf + samdiv ));
               WritePixel( rp, tx + ( gwid - ix ), ( ty + ghlf + samdiv ));
            }
            samval += incr;
         }
         break;

      case WF_RAMPUP_WAVE:
         samval = ( ghlf * 1000 );
         incr = -(( ghlf * 1000 ) / gmid );
         if ( wfd->wf_Outline == WF_DOTTED_DISPLAY ) {               /* first vertical */
            Move( rp, tx, ty + ghlf );
            Draw( rp, tx, ty + ghlf + ghlf );
         }
         for ( ix = 1; ix < gwid; ix++ ) {
            if ( wfd->wf_Outline == WF_SOLID_DISPLAY ) {
               Move( rp, tx + ix, ty + ghlf );
               Draw( rp, tx + ix, ty + ghlf + samval / 1000 );
            } else      WritePixel( rp, tx + ix, ( ty + ghlf + samval / 1000 ));
            samval += incr;
         }
         if ( wfd->wf_Outline == WF_DOTTED_DISPLAY ) {
            Move( rp, tx + ix, ty );
            Draw( rp, tx + ix, ty + ghlf );                       /* last vertical */
         }
         break;

      case WF_RAMPDOWN_WAVE:
         samval = -( ghlf * 1000 );
         incr = (( ghlf * 1000 ) / gmid );
         if ( wfd->wf_Outline == WF_DOTTED_DISPLAY ) {            /* first vertical */
            Move( rp, tx, ty );
            Draw( rp, tx, ty + ghlf );
         }
         for ( ix = 1; ix < gwid; ix++ ) {
            if ( wfd->wf_Outline == WF_SOLID_DISPLAY ) {
               Move( rp, tx + ix, ty + ghlf );
               Draw( rp, tx + ix, ty + ghlf + samval / 1000 );
            } else      WritePixel( rp, tx + ix, ( ty + ghlf + samval / 1000 ));
            samval += incr;
         }
         if ( wfd->wf_Outline == WF_DOTTED_DISPLAY ) {
            Move( rp, tx + ix, ty + ghlf );
            Draw( rp, tx + ix, ty + ghlf + samval / 1000 );       /* last vertical */
         }
         break;

      case WF_SQUARE_WAVE:
         halfw = gmid;
         halfw += (( gmid * shape ) / 100 );
         if ( halfw <= 1 )             halfw += 1;
         if ( halfw >= ( gwid - 1 ))   halfw -= 1;
         if ( wfd->wf_Outline == WF_DOTTED_DISPLAY ) {            /* first vertical */
            Move( rp, tx, ty + ghlf );
            Draw( rp, tx, ty + 1 );
         }
         for ( ix = 1; ix < halfw; ix++ ) {
            if ( wfd->wf_Outline == WF_SOLID_DISPLAY ) {
               Move( rp, tx + ix, ty + ghlf );
               Draw( rp, tx + ix, ty + 1 );
            } else      WritePixel( rp, tx + ix, ( ty + 1 ));
         }
         if ( wfd->wf_Outline == WF_DOTTED_DISPLAY ) {            /* middle vertical */
            Move( rp, tx + ix, ty + 1 );
            Draw( rp, tx + ix, ty + ghgt - 1 );
         }
         for ( ix = halfw; ix < gwid; ix++ ) {
            if ( wfd->wf_Outline == WF_SOLID_DISPLAY ) {
               Move( rp, tx + ix, ty + ghlf );
               Draw( rp, tx + ix, ty + ghgt - 1 );
            } else      WritePixel( rp, tx + ix, ( ty + ghgt - 1 ));
         }
         if ( wfd->wf_Outline == WF_DOTTED_DISPLAY ) {            /* last vertical */
            Move( rp, tx + ix, ty + ghlf );
            Draw( rp, tx + ix, ty + ghgt - 1 );
         }
         break;

      default: break;
   }

   tx -= fram; ty -= fram;                               /* reset frame coordinates */
   SetAPen( rp, TEXTPEN );
   return( 0 );
}



/*______________________________________________________________________________________
 |                                                                                      |
 |    Create a new waveform.image                                                       |
 |______________________________________________________________________________________*/

STATIC LONG newMethod( Class *cl, struct Image *im, struct opSet *msg )
{
   struct Image        *newobj;

   /* Create the new object */
   if ( newobj = (struct Image *)DoSuperMethodA( cl, (Object *)im, (Msg)msg ))
      setAttrsMethod( cl, newobj, msg, TRUE );   /* Update the attributes */
   return((LONG)newobj );
}



/*______________________________________________________________________________________
 |                                                                                      |
 |    The waveform.image class dispatcher                                               |
 |______________________________________________________________________________________*/

LONG __asm dispatchWFI( REGISTER __a0 Class *cl, REGISTER __a2 struct Image *im,
                           REGISTER __a1 ULONG *msg )
{
   LONG                 retval;

   switch ( *msg )
   {
      case OM_NEW:
         retval = newMethod( cl, im, (struct opSet *)msg );
         break;

      case OM_SET:
      case OM_UPDATE:
         retval = setAttrsMethod( cl, im, (struct opSet *)msg, FALSE );
         break;

      case OM_GET:
         retval = getAttrsMethod( cl, im, (struct opGet *)msg );
         break;

/*      case OM_NOTIFY:
         retval = notifyMethod( cl, im, struct opSet *)msg );
         break; */

      case IM_DRAW:
         retval = drawMethod( cl, im, (struct impDraw *)msg );
         break;

      case OM_DISPOSE:
         retval = (LONG)DoSuperMethodA( cl, (Object *)im, ( Msg )msg );
         break;

      default:
         retval = (LONG)DoSuperMethodA( cl, (Object *)im, ( Msg )msg );
         break;

   }
   return( retval );
}





