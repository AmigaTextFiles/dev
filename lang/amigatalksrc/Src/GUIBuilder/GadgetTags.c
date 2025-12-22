/****h* GadgetTags.c [2.0] ***************************************
*
* NAME
*    GadgetTags.c
*
* DESCRIPTION
*    Convert GadTools Tags/Flags etc to string equivalents.
*
* NOTES
*    $VER: GadgetTags.c 2.0 (01-Nov-2004) by J.T. Steichen
******************************************************************
*
*/

#ifndef    EXEC_TYPES_H
# include <exec/types.h>
#endif

#include <AmigaDOSErrs.h>

#ifndef    UTILITY_TAGITEM_H
# include <utility/tagitem.h>
#endif

#ifndef    INTUITION_INTUITION_H
# include <intuition/intuition.h>
#endif

#ifndef    INTUITION_GADGETCLASS_H
# include <intuition/gadgetclass.h>
#endif

#ifndef    LIBRARIES_GADTOOLS_H
# include <libraries/gadtools.h>
#endif

#include <StringFunctions.h>

PUBLIC char *getGadgetType( int gtype )
{
   switch (gtype)
      {
      case GENERIC_KIND:
         return( "GENERIC_KIND" );      

      default:
      case BUTTON_KIND:
         return( "BUTTON_KIND" );

      case CHECKBOX_KIND:
         return( "CHECKBOX_KIND" );

      case INTEGER_KIND:
         return( "INTEGER_KIND" );

      case LISTVIEW_KIND:
         return( "LISTVIEW_KIND" );

      case MX_KIND:
         return( "MX_KIND" );

      case NUMBER_KIND:
         return( "NUMBER_KIND" );

      case CYCLE_KIND:
         return( "CYCLE_KIND" );

      case PALETTE_KIND:
         return( "PALETTE_KIND" );

      case SCROLLER_KIND:
         return( "SCROLLER_KIND" );

      case SLIDER_KIND:
         return( "SLIDER_KIND" );

      case STRING_KIND:
         return( "STRING_KIND" );

      case TEXT_KIND:
         return( "TEXT_KIND" );
      }
}

PUBLIC char *getGadgetIDCMP( int gtype )
{
   switch (gtype)
      {
      default:
      case GENERIC_KIND:
      case BUTTON_KIND:
         return( "BUTTONIDCMP" );

      case CHECKBOX_KIND:
         return( "CHECKBOXIDCMP" );
         
      case INTEGER_KIND:
         return( "INTEGERIDCMP" );

      case LISTVIEW_KIND:
         return( "LISTVIEWIDCMP" );

      case MX_KIND:
         return( "MXIDCMP" );

      case NUMBER_KIND:
         return( "NUMBERIDCMP" );

      case CYCLE_KIND:
         return( "CYCLEIDCMP" );

      case PALETTE_KIND:
         return( "PALETTEIDCMP" );

      case SCROLLER_KIND:
         return( "ARROWIDCMP | SCROLLERIDCMP" );

      case SLIDER_KIND:
         return( "SLIDERIDCMP" );

      case STRING_KIND:
         return( "STRINGIDCMP" );

      case TEXT_KIND:
         return( "TEXTIDCMP" );
      }
}

PUBLIC char *getGadgetTextLoc( int textLocFlag )
{
   switch (textLocFlag)
      {
      default:
      case PLACETEXT_LEFT:
         return( "PLACETEXT_LEFT" );

      case PLACETEXT_RIGHT:
         return( "PLACETEXT_RIGHT" );

      case PLACETEXT_ABOVE:
         return( "PLACETEXT_ABOVE" );

      case PLACETEXT_BELOW:
         return( "PLACETEXT_BELOW" );

      case PLACETEXT_IN:
         return( "PLACETEXT_IN" );

      case NG_HIGHLABEL:
         return( "NG_HIGHLABEL" );
      }
}

PUBLIC char *getMenuType( int mtype )
{
   if (mtype == (int) NM_BARLABEL)
      return( "NM_BARLABEL" );
      
   switch (mtype)
      {
      default:
      case NM_IGNORE:
         return( "NM_IGNORE" );

      case NM_TITLE:
         return( "NM_TITLE" );
      
      case NM_ITEM:
         return( "NM_ITEM" );
      
      case NM_SUB:
         return( "NM_SUB" );

      case IM_ITEM:              // (NM_ITEM|MENU_IMAGE) Graphical menu item:
         return( "IM_ITEM" );
      
      case IM_SUB:               // (NM_SUB|MENU_IMAGE) Graphical menu sub-item:
         return( "IM_SUB" );

      case NM_END:
         return( "NM_END" );
      }
}

PUBLIC char *getMenuFlag( int mflag )
{
   switch (mflag)
      {
      default: 
         return( "NM_UNKNOWN_FLAG_ERROR" );

      case NM_MENUDISABLED:             // MENUENABLED:
         return( "NM_MENUDISABLED" );

      case NM_ITEMDISABLED:             // ITEMENABLED:
         return( "NM_ITEMDISABLED" );

      case NM_COMMANDSTRING:            // COMMSEQ:
         return( "NM_COMMANDSTRING" );
      }
}

PUBLIC char *getMenuTag( int mtag )
{
   switch (mtag)
      {
      default: 
         return( "GTMN_UNKNOWN_TAG_ERROR" );

      case GTMN_FullMenu:
         return( "GTMN_FullMenu" );

      case GTMN_SecondaryError:
         return( "GTMN_SecondaryError" );

      case GTMN_TextAttr:
         return( "GTMN_TextAttr" );

      case GTMN_FrontPen:
         return( "GTMN_FrontPen" );

      case GTMN_Menu:
         return( "GTMN_Menu" );

      case GTMN_Checkmark:
         return( "GTMN_Checkmark" );

      case GTMN_AmigaKey:
         return( "GTMN_AmigaKey" );

      case GTMN_NewLookMenus:
         return( "GTMN_NewLookMenus" );
      }
}

PUBLIC char *getBevelBoxTag( int btag )
{
   switch (btag)
      {
      case GTBB_Recessed:
         return( "GTBB_Recessed" );

      case GTBB_FrameType:
         return( "GTBB_FrameType" );

      default:
         return( "GTBB_TAG_ERROR" );
      }
}

PUBLIC char *getBevelBoxFrameType( int btype )
{
   switch (btype)
      { 
      default:
      case BBFT_BUTTON:	               // 1 Standard button gadget box
         return( "BBFT_BUTTON" );
               
      case BBFT_RIDGE:	               // 2 Standard string gadget box
         return( "BBFT_RIDGE" );
         
      case BBFT_ICONDROPBOX:           // 3 Standard icon drop box
         return( "BBFT_ICONDROPBOX" );
      }
}

PUBLIC char *getTextJustifyType( int jtype )
{
   switch (jtype)
      {
      default:
      case GTJ_LEFT:            // 0:
         return( "GTJ_LEFT" );      

      case GTJ_RIGHT:           // 1:
         return( "GTJ_RIGHT" );      

      case GTJ_CENTER:          // 2:
         return( "GTJ_CENTER" );      
      }
}

PUBLIC char *getGadgetOrientation( int otype )
{
   switch (otype)
      {
      default:
      case LORIENT_NONE:   // 0
         return( "LORIENT_NONE" );

      case LORIENT_HORIZ:  // 1
         return( "LORIENT_HORIZ" );

      case LORIENT_VERT:   // 2
         return( "LORIENT_VERT" );
      }
}

PUBLIC int  gadgetStrToInt( char *str )
{
   if (StringComp( str, "LAYOUTA_LayoutObj" ) == 0)
      return( LAYOUTA_LayoutObj );

   if (StringComp( str, "LAYOUTA_Spacing" ) == 0)
      return( LAYOUTA_Spacing );

   if (StringComp( str, "LAYOUTA_Orientation" ) == 0)
      return( LAYOUTA_Orientation );

   if (StringComp( str, "LAYOUTA_ChildMaxWidth" ) == 0)
      return( LAYOUTA_ChildMaxWidth );

   if (StringComp( str, "LAYOUTA_ChildMaxHeight" ) == 0)
      return( LAYOUTA_ChildMaxHeight );
   
   if (StringComp( str, "STRINGA_Justification" ) == 0)
      return( STRINGA_Justification );

   if (StringComp( str, "PGA_Freedom" ) == 0)
      return( PGA_Freedom );

   if (StringComp( str, "PGA_Borderless" ) == 0)
      return( PGA_Borderless );

   if (StringComp( str, "PGA_HorizPot" ) == 0)
      return( PGA_HorizPot );

   if (StringComp( str, "PGA_HorizBody" ) == 0)
      return( PGA_HorizBody );

   if (StringComp( str, "PGA_VertPot" ) == 0)
      return( PGA_VertPot );

   if (StringComp( str, "PGA_VertBody" ) == 0)
      return( PGA_VertBody );

   if (StringComp( str, "PGA_Total" ) == 0)
      return( PGA_Total );

   if (StringComp( str, "PGA_Visible" ) == 0)
      return( PGA_Visible );

   if (StringComp( str, "PGA_Top" ) == 0)
      return( PGA_Top );

   if (StringComp( str, "PGA_NewLook" ) == 0)
      return( PGA_NewLook );

   if (StringComp( str, "STRINGA_MaxChars" ) == 0)
      return( STRINGA_MaxChars );

   if (StringComp( str, "GTCB_Checked" ) == 0)
      return( GTCB_Checked );

   if (StringComp( str, "GTCB_Scaled" ) == 0)
      return( GTCB_Scaled );

   if (StringComp( str, "GTLV_Top" ) == 0)
      return( GTLV_Top );

   if (StringComp( str, "GTLV_Labels" ) == 0)
      return( GTLV_Labels );

   if (StringComp( str, "GTLV_ReadOnly" ) == 0)
      return( GTLV_ReadOnly );

   if (StringComp( str, "GTLV_ScrollWidth" ) == 0)
      return( GTLV_ScrollWidth );

   if (StringComp( str, "GTLV_ShowSelected" ) == 0)
      return( GTLV_ShowSelected );

   if (StringComp( str, "GTLV_Selected" ) == 0)
      return( GTLV_Selected );

   if (StringComp( str, "GTLV_MakeVisible" ) == 0)
      return( GTLV_MakeVisible );

   if (StringComp( str, "GTLV_ItemHeight" ) == 0)
      return( GTLV_ItemHeight );

   if (StringComp( str, "GTLV_CallBack" ) == 0)
      return( GTLV_CallBack );

   if (StringComp( str, "GTLV_MaxPen" ) == 0)
      return( GTLV_MaxPen );

   if (StringComp( str, "GTMX_Labels" ) == 0)
      return( GTMX_Labels );

   if (StringComp( str, "GTMX_Active" ) == 0)
      return( GTMX_Active );

   if (StringComp( str, "GTMX_Spacing" ) == 0)
      return( GTMX_Spacing );

   if (StringComp( str, "GTMX_Scaled" ) == 0)
      return( GTMX_Scaled );

   if (StringComp( str, "GTMX_TitlePlace" ) == 0)
      return( GTMX_TitlePlace );

   if (StringComp( str, "GTTX_Text" ) == 0)
      return( GTTX_Text );

   if (StringComp( str, "GTTX_Border" ) == 0)
      return( GTTX_Border );

   if (StringComp( str, "GTTX_CopyText" ) == 0)
      return( GTTX_CopyText );

   if (StringComp( str, "GTTX_FrontPen" ) == 0)
      return( GTTX_FrontPen );

   if (StringComp( str, "GTTX_BackPen" ) == 0)
      return( GTTX_BackPen );

   if (StringComp( str, "GTTX_Justification" ) == 0)
      return( GTTX_Justification );

   if (StringComp( str, "GTTX_Clipped" ) == 0)
      return( GTTX_Clipped );

   if (StringComp( str, "GTNM_Number" ) == 0)
      return( GTNM_Number );

   if (StringComp( str, "GTNM_Border" ) == 0)
      return( GTNM_Border );

   if (StringComp( str, "GTNM_FrontPen" ) == 0)
      return( GTNM_FrontPen );             // Same as GTTX_FrontPen 

   if (StringComp( str, "GTNM_BackPen" ) == 0)
      return( GTNM_BackPen );              // Same as GTTX_BackPen

   if (StringComp( str, "GTNM_Justification" ) == 0)
      return( GTNM_Justification );        // Same as GTTX_Justification

   if (StringComp( str, "GTNM_Format" ) == 0)
      return( GTNM_Format );

   if (StringComp( str, "GTNM_MaxNumberLen" ) == 0)
      return( GTNM_MaxNumberLen );

   if (StringComp( str, "GTCY_Labels" ) == 0)
      return( GTCY_Labels );

   if (StringComp( str, "GTCY_Active" ) == 0)
      return( GTCY_Active );

   if (StringComp( str, "GTPA_Depth" ) == 0)
      return( GTPA_Depth );

   if (StringComp( str, "GTPA_Color" ) == 0)
      return( GTPA_Color );

   if (StringComp( str, "GTPA_ColorOffset" ) == 0)
      return( GTPA_ColorOffset );

   if (StringComp( str, "GTPA_IndicatorWidth" ) == 0)
      return( GTPA_IndicatorWidth );

   if (StringComp( str, "GTPA_IndicatorHeight" ) == 0)
      return( GTPA_IndicatorHeight );

   if (StringComp( str, "GTPA_NumColors" ) == 0)
      return( GTPA_NumColors );

   if (StringComp( str, "GTPA_ColorTable" ) == 0)
      return( GTPA_ColorTable );

   if (StringComp( str, "GTSC_Top" ) == 0)
      return( GTSC_Top );

   if (StringComp( str, "GTSC_Total" ) == 0)
      return( GTSC_Total );

   if (StringComp( str, "GTSC_Visible" ) == 0)
      return( GTSC_Visible );

   if (StringComp( str, "GTSC_Overlap" ) == 0)
      return( GTSC_Overlap );

   if (StringComp( str, "GTSC_Arrows" ) == 0)
      return( GTSC_Arrows );

   if (StringComp( str, "GTSL_Min" ) == 0)
      return( GTSL_Min );

   if (StringComp( str, "GTSL_Max" ) == 0)
      return( GTSL_Max );

   if (StringComp( str, "GTSL_Level" ) == 0)
      return( GTSL_Level );

   if (StringComp( str, "GTSL_MaxLevelLen" ) == 0)
      return( GTSL_MaxLevelLen );

   if (StringComp( str, "GTSL_LevelFormat" ) == 0)
      return( GTSL_LevelFormat );

   if (StringComp( str, "GTSL_LevelPlace" ) == 0)
      return( GTSL_LevelPlace );

   if (StringComp( str, "GTSL_DispFunc" ) == 0)
      return( GTSL_DispFunc );

   if (StringComp( str, "GTSL_MaxPixelLen" ) == 0)
      return( GTSL_MaxPixelLen );

   if (StringComp( str, "GTSL_Justification" ) == 0)
      return( GTSL_Justification );

   if (StringComp( str, "GTST_String" ) == 0)
      return( GTST_String );

   if (StringComp( str, "GTST_MaxChars" ) == 0)
      return( GTST_MaxChars );

   if (StringComp( str, "GTST_EditHook" ) == 0)
      return( GTST_EditHook );

   if (StringComp( str, "GTIN_Number" ) == 0)
      return( GTIN_Number );

   if (StringComp( str, "GTIN_MaxChars" ) == 0)
      return( GTIN_MaxChars );

   if (StringComp( str, "GTIN_EditHook" ) == 0)
      return( GTIN_EditHook );             // Same as GTST_EditHook

   if (StringComp( str, "GT_VisualInfo" ) == 0)
      return( GT_VisualInfo );

   if (StringComp( str, "GT_Underscore" ) == 0)
      return( GT_Underscore );
      
   if (StringComp( str, "GA_Left" ) == 0)
      return( GA_Left );

   if (StringComp( str, "GA_RelRight" ) == 0)
      return( GA_RelRight );

   if (StringComp( str, "GA_Top" ) == 0)
      return( GA_Top );

   if (StringComp( str, "GA_RelBottom" ) == 0)
      return( GA_RelBottom );

   if (StringComp( str, "GA_Width" ) == 0)
      return( GA_Width );

   if (StringComp( str, "GA_RelWidth" ) == 0)
      return( GA_RelWidth );

   if (StringComp( str, "GA_Height" ) == 0)
      return( GA_Height );

   if (StringComp( str, "GA_RelHeight" ) == 0)
      return( GA_RelHeight );

   if (StringComp( str, "GA_Text" ) == 0)
      return( GA_Text );

   if (StringComp( str, "GA_Image" ) == 0)
      return( GA_Image );

   if (StringComp( str, "GA_Border" ) == 0)
      return( GA_Border );

   if (StringComp( str, "GA_SelectRender" ) == 0)
      return( GA_SelectRender );

   if (StringComp( str, "GA_Highlight" ) == 0)
      return( GA_Highlight );

   if (StringComp( str, "GA_Disabled" ) == 0)
      return( GA_Disabled );

   if (StringComp( str, "GA_GZZGadget" ) == 0)
      return( GA_GZZGadget );

   if (StringComp( str, "GA_ID" ) == 0)
      return( GA_ID );

   if (StringComp( str, "GA_UserData" ) == 0)
      return( GA_UserData );

   if (StringComp( str, "GA_SpecialInfo" ) == 0)
      return( GA_SpecialInfo );

   if (StringComp( str, "GA_Selected" ) == 0)
      return( GA_Selected );

   if (StringComp( str, "GA_EndGadget" ) == 0)
      return( GA_EndGadget );

   if (StringComp( str, "GA_Immediate" ) == 0)
      return( GA_Immediate );

   if (StringComp( str, "GA_RelVerify" ) == 0)
      return( GA_RelVerify );

   if (StringComp( str, "GA_FollowMouse" ) == 0)
      return( GA_FollowMouse );

   if (StringComp( str, "GA_RightBorder" ) == 0)
      return( GA_RightBorder );

   if (StringComp( str, "GA_LeftBorder" ) == 0)
      return( GA_LeftBorder );

   if (StringComp( str, "GA_TopBorder" ) == 0)
      return( GA_TopBorder );

   if (StringComp( str, "GA_BottomBorder" ) == 0)
      return( GA_BottomBorder );

   if (StringComp( str, "GA_ToggleSelect" ) == 0)
      return( GA_ToggleSelect );

   if (StringComp( str, "GA_SysGadget" ) == 0)
      return( GA_SysGadget );

   if (StringComp( str, "GA_SysGType" ) == 0)
      return( GA_SysGType );

   if (StringComp( str, "GA_Previous" ) == 0)
      return( GA_Previous );

   if (StringComp( str, "GA_Next" ) == 0)
      return( GA_Next );

   if (StringComp( str, "GA_DrawInfo" ) == 0)
      return( GA_DrawInfo );

   if (StringComp( str, "GA_IntuiText" ) == 0)
      return( GA_IntuiText );

   if (StringComp( str, "GA_LabelImage" ) == 0)
      return( GA_LabelImage );

   if (StringComp( str, "GA_TabCycle" ) == 0)
      return( GA_TabCycle );

   if (StringComp( str, "GA_GadgetHelp" ) == 0)
      return( GA_GadgetHelp );

   if (StringComp( str, "GA_Bounds" ) == 0)
      return( GA_Bounds );

   if (StringComp( str, "GA_RelSpecial" ) == 0)
      return( GA_RelSpecial );

   if (StringComp( str, "GA_TextAttr" ) == 0)
      return( GA_TextAttr );

   if (StringComp( str, "GA_ReadOnly" ) == 0)
      return( GA_ReadOnly );

   if (StringComp( str, "GA_Underscore" ) == 0)
      return( GA_Underscore );

   if (StringComp( str, "GA_ActivateKey" ) == 0)
      return( GA_ActivateKey );

   if (StringComp( str, "GA_BackFill" ) == 0)
      return( GA_BackFill );

   if (StringComp( str, "GA_GadgetHelpText" ) == 0)
      return( GA_GadgetHelpText );

   if (StringComp( str, "GA_UserInput" ) == 0)
      return( GA_UserInput );

   if (StringComp( str, "STRINGA_Buffer" ) == 0)
      return( STRINGA_Buffer );

   if (StringComp( str, "STRINGA_UndoBuffer" ) == 0)
      return( STRINGA_UndoBuffer );

   if (StringComp( str, "STRINGA_WorkBuffer" ) == 0)
      return( STRINGA_WorkBuffer );

   if (StringComp( str, "STRINGA_BufferPos" ) == 0)
      return( STRINGA_BufferPos );

   if (StringComp( str, "STRINGA_DispPos" ) == 0)
      return( STRINGA_DispPos );

   if (StringComp( str, "STRINGA_AltKeyMap" ) == 0)
      return( STRINGA_AltKeyMap );

   if (StringComp( str, "STRINGA_Font" ) == 0)
      return( STRINGA_Font );

   if (StringComp( str, "STRINGA_Pens" ) == 0)
      return( STRINGA_Pens );

   if (StringComp( str, "STRINGA_ActivePens" ) == 0)
      return( STRINGA_ActivePens );

   if (StringComp( str, "STRINGA_EditHook" ) == 0)
      return( STRINGA_EditHook );

   if (StringComp( str, "STRINGA_EditModes" ) == 0)
      return( STRINGA_EditModes );

   if (StringComp( str, "STRINGA_ReplaceMode" ) == 0)
      return( STRINGA_ReplaceMode );

   if (StringComp( str, "STRINGA_FixedFieldMode" ) == 0)
      return( STRINGA_FixedFieldMode );

   if (StringComp( str, "STRINGA_NoFilterMode" ) == 0)
      return( STRINGA_NoFilterMode );

   if (StringComp( str, "STRINGA_LongVal" ) == 0)
      return( STRINGA_LongVal );

   if (StringComp( str, "STRINGA_TextVal" ) == 0)
      return( STRINGA_TextVal );

   if (StringComp( str, "STRINGA_ExitHelp" ) == 0)
      return( STRINGA_ExitHelp );
   else
      return( -1 );
}

PUBLIC char *getGadgetTag( int itTag )
{
   switch (itTag)
      {
      default: 
         return( "GT_UNKNOWN_TAG_ERROR" );

      case GTCB_Checked:            // CHECKBOX_KIND: (0x800800??)
         return( "GTCB_Checked" );

      case GTCB_Scaled:
         return( "GTCB_Scaled" );

      case GTLV_Top:                // LISTVIEW_KIND:
         return( "GTLV_Top" );

      case GTLV_Labels:                // 0x80080006
         return( "GTLV_Labels" );

      case GTLV_ReadOnly:
         return( "GTLV_ReadOnly" );

      case GTLV_ScrollWidth:
         return( "GTLV_ScrollWidth" );

      case GTLV_ShowSelected:          // 0x80080035
         return( "GTLV_ShowSelected" );

      case GTLV_Selected:
         return( "GTLV_Selected" );

      case GTLV_MakeVisible:
         return( "GTLV_MakeVisible" );

      case GTLV_ItemHeight:
         return( "GTLV_ItemHeight" );

      case GTLV_CallBack:
         return( "GTLV_CallBack" );

      case GTLV_MaxPen:
         return( "GTLV_MaxPen" );

      case GTMX_Labels:              // 0x80080009, MX_KIND:
         return( "GTMX_Labels" );

      case GTMX_Active:
         return( "GTMX_Active" );

      case GTMX_Spacing:             // 0x8008003D
         return( "GTMX_Spacing" );

      case GTMX_Scaled:
         return( "GTMX_Scaled" );

      case GTMX_TitlePlace:
         return( "GTMX_TitlePlace" );

      case GTTX_Text:                // TEXT_KIND:
         return( "GTTX_Text" );

      case GTTX_Border:
         return( "GTTX_Border" );

      case GTTX_CopyText:
         return( "GTTX_CopyText" );

      case GTTX_FrontPen:
         return( "GTTX_FrontPen" );

      case GTTX_BackPen:
         return( "GTTX_BackPen" );

      case GTTX_Justification:
         return( "GTTX_Justification" );

      case GTTX_Clipped:
         return( "GTTX_Clipped" );

      case GTNM_Number:              // NUMBER_KIND:
         return( "GTNM_Number" );

      case GTNM_Border:
         return( "GTNM_Border" );
/*
      case GTNM_FrontPen:                  // Same as GTTX_FrontPen 
         return( "GTNM_FrontPen" );

      case GTNM_BackPen:                   // Same as GTTX_BackPen
         return( "GTNM_BackPen" );

      case GTNM_Justification:             // Same as GTTX_Justification
         return( "GTNM_Justification" );
*/
      case GTNM_Format:
         return( "GTNM_Format" );

      case GTNM_MaxNumberLen:
         return( "GTNM_MaxNumberLen" );

      case GTCY_Labels:               // CYCLE_KIND:
         return( "GTCY_Labels" );

      case GTCY_Active:
         return( "GTCY_Active" );

      case GTPA_Depth:                // PALETTE_KIND:
         return( "GTPA_Depth" );

      case GTPA_Color:
         return( "GTPA_Color" );

      case GTPA_ColorOffset:
         return( "GTPA_ColorOffset" );

      case GTPA_IndicatorWidth:
         return( "GTPA_IndicatorWidth" );

      case GTPA_IndicatorHeight:
         return( "GTPA_IndicatorHeight" );

      case GTPA_NumColors:
         return( "GTPA_NumColors" );

      case GTPA_ColorTable:
         return( "GTPA_ColorTable" );

      case GTSC_Top:                  // SCROLLER_KIND:   
         return( "GTSC_Top" );

      case GTSC_Total:
         return( "GTSC_Total" );

      case GTSC_Visible:
         return( "GTSC_Visible" );

      case GTSC_Overlap:
         return( "GTSC_Overlap" );

      case GTSC_Arrows:
         return( "GTSC_Arrows" );

      case GTSL_Min:                  // SLIDER_KIND:
         return( "GTSL_Min" );

      case GTSL_Max:
         return( "GTSL_Max" );

      case GTSL_Level:
         return( "GTSL_Level" );

      case GTSL_MaxLevelLen:
         return( "GTSL_MaxLevelLen" );

      case GTSL_LevelFormat:
         return( "GTSL_LevelFormat" );

      case GTSL_LevelPlace:
         return( "GTSL_LevelPlace" );

      case GTSL_DispFunc:
         return( "GTSL_DispFunc" );

      case GTSL_MaxPixelLen:
         return( "GTSL_MaxPixelLen" );

      case GTSL_Justification:
         return( "GTSL_Justification" );

      case GTST_String:               // 0x8008002D, STRING_KIND:
         return( "GTST_String" );

      case GTST_MaxChars:             // 0x8008002E
         return( "GTST_MaxChars" );

      case GTST_EditHook:
         return( "GTST_EditHook" );

      case GTIN_Number:               // 0x8008002F, INTEGER_KIND:
         return( "GTIN_Number" );

      case GTIN_MaxChars:             // 0x80080030
         return( "GTIN_MaxChars" );
/*
      case GTIN_EditHook:             // Same as GTST_EditHook
         return( "GTIN_EditHook" );
*/
      case GT_VisualInfo:             // MISC:
         return( "GT_VisualInfo" );

      case GT_Underscore:             // 0x80080040
         return( "GT_Underscore" );
      
      // GA_Dummy (0x80030000)

      case GA_Left:
         return( "GA_Left" );

      case GA_RelRight:
         return( "GA_RelRight" );

      case GA_Top:
         return( "GA_Top" );

      case GA_RelBottom:
         return( "GA_RelBottom" );

      case GA_Width:
         return( "GA_Width" );

      case GA_RelWidth:
         return( "GA_RelWidth" );

      case GA_Height:
         return( "GA_Height" );

      case GA_RelHeight:
         return( "GA_RelHeight" );

      case GA_Text:
         return( "GA_Text" );

      case GA_Image:
         return( "GA_Image" );

      case GA_Border:
         return( "GA_Border" );

      case GA_SelectRender:
         return( "GA_SelectRender" );

      case GA_Highlight:
         return( "GA_Highlight" );

      case GA_Disabled:
         return( "GA_Disabled" );

      case GA_GZZGadget:
         return( "GA_GZZGadget" );

      case GA_ID:
         return( "GA_ID" );

      case GA_UserData:
         return( "GA_UserData" );

      case GA_SpecialInfo:
         return( "GA_SpecialInfo" );

      case GA_Selected:
         return( "GA_Selected" );

      case GA_EndGadget:
         return( "GA_EndGadget" );

      case GA_Immediate:
         return( "GA_Immediate" );

      case GA_RelVerify:
         return( "GA_RelVerify" );

      case GA_FollowMouse:
         return( "GA_FollowMouse" );

      case GA_RightBorder:
         return( "GA_RightBorder" );

      case GA_LeftBorder:
         return( "GA_LeftBorder" );

      case GA_TopBorder:
         return( "GA_TopBorder" );

      case GA_BottomBorder:
         return( "GA_BottomBorder" );

      case GA_ToggleSelect:
         return( "GA_ToggleSelect" );

      case GA_SysGadget:
         return( "GA_SysGadget" );

      case GA_SysGType:
         return( "GA_SysGType" );

      case GA_Previous:
         return( "GA_Previous" );

      case GA_Next:
         return( "GA_Next" );

      case GA_DrawInfo:
         return( "GA_DrawInfo" );

      case GA_IntuiText:
         return( "GA_IntuiText" );

      case GA_LabelImage:
         return( "GA_LabelImage" );

      case GA_TabCycle:
         return( "GA_TabCycle" );

      case GA_GadgetHelp:
         return( "GA_GadgetHelp" );

      case GA_Bounds:
         return( "GA_Bounds" );

      case GA_RelSpecial:
         return( "GA_RelSpecial" );

      case GA_TextAttr:
         return( "GA_TextAttr" );

      case GA_ReadOnly:
         return( "GA_ReadOnly" );

      case GA_Underscore:
         return( "GA_Underscore" );

      case GA_ActivateKey:
         return( "GA_ActivateKey" );

      case GA_BackFill:
         return( "GA_BackFill" );

      case GA_GadgetHelpText:
         return( "GA_GadgetHelpText" );

      case GA_UserInput:
         return( "GA_UserInput" );

        // PROPGCLASS attributes: PGA_Dummy 0x80031000
      case PGA_Freedom:
         return( "PGA_Freedom" );

      case PGA_Borderless:
         return( "PGA_Borderless" );

      case PGA_HorizPot:
         return( "PGA_HorizPot" );

      case PGA_HorizBody:
         return( "PGA_HorizBody" );

      case PGA_VertPot:
         return( "PGA_VertPot" );

      case PGA_VertBody:
         return( "PGA_VertBody" );

      case PGA_Total:
         return( "PGA_Total" );

      case PGA_Visible:
         return( "PGA_Visible" );

      case PGA_Top:
         return( "PGA_Top" );

      case PGA_NewLook:
         return( "PGA_NewLook" );

        // STRGCLASS attributes STRINGA_Dummy (0x80032000)
      case STRINGA_MaxChars:
         return( "STRINGA_MaxChars" );

      case STRINGA_Buffer:
         return( "STRINGA_Buffer" );

      case STRINGA_UndoBuffer:
         return( "STRINGA_UndoBuffer" );

      case STRINGA_WorkBuffer:
         return( "STRINGA_WorkBuffer" );

      case STRINGA_BufferPos:
         return( "STRINGA_BufferPos" );

      case STRINGA_DispPos:
         return( "STRINGA_DispPos" );

      case STRINGA_AltKeyMap:
         return( "STRINGA_AltKeyMap" );

      case STRINGA_Font:
         return( "STRINGA_Font" );

      case STRINGA_Pens:
         return( "STRINGA_Pens" );

      case STRINGA_ActivePens:
         return( "STRINGA_ActivePens" );

      case STRINGA_EditHook:
         return( "STRINGA_EditHook" );

      case STRINGA_EditModes:
         return( "STRINGA_EditModes" );

      case STRINGA_ReplaceMode:
         return( "STRINGA_ReplaceMode" );

      case STRINGA_FixedFieldMode:
         return( "STRINGA_FixedFieldMode" );

      case STRINGA_NoFilterMode:
         return( "STRINGA_NoFilterMode" );

      case STRINGA_Justification:
         return( "STRINGA_Justification" );

      case STRINGA_LongVal:
         return( "STRINGA_LongVal" );

      case STRINGA_TextVal:
         return( "STRINGA_TextVal" );

      case STRINGA_ExitHelp:
         return( "STRINGA_ExitHelp" );

        // Gadget layout related attributes LAYOUTA_Dummy 0x80038000
      case LAYOUTA_LayoutObj:
         return( "LAYOUTA_LayoutObj" );

      case LAYOUTA_Spacing:
         return( "LAYOUTA_Spacing" );

      case LAYOUTA_Orientation:
         return( "LAYOUTA_Orientation" );

      case LAYOUTA_ChildMaxWidth:
         return( "LAYOUTA_ChildMaxWidth" );

      case LAYOUTA_ChildMaxHeight:
         return( "LAYOUTA_ChildMaxHeight" );
      }
}

/* --------- END of GadgetTags.c file! --------------------- */
