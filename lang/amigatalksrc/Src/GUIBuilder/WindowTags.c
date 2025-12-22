/****h* WindowTags.c [2.0] ***********************************
*
* NAME
*    WindowTags.c
*
* DESCRIPTION
*    Translate Window IDCMP/Flags/Tags to string equivalents.
*
* NOTES
*    $VER: WindowTags.c 2.0 (01-Nov-2004) by J.T. Steichen
**************************************************************
*
*/

#ifndef    INTUITION_INTUITION_H
# include <intuition/intuition.h>
#endif

#include <AmigaDOSErrs.h>

PUBLIC char *getIDCMPFlag( int idcmpValue )
{
   switch (idcmpValue)
      {
      case IDCMP_SIZEVERIFY:
         return( "IDCMP_SIZEVERIFY" );

      case IDCMP_NEWSIZE:
         return( "IDCMP_NEWSIZE" );

      case IDCMP_REFRESHWINDOW:
         return( "IDCMP_REFRESHWINDOW" );

      case IDCMP_MOUSEBUTTONS:
         return( "IDCMP_MOUSEBUTTONS" );

      case IDCMP_MOUSEMOVE:
         return( "IDCMP_MOUSEMOVE" );

      case IDCMP_GADGETDOWN:
         return( "IDCMP_GADGETDOWN" );

      case IDCMP_GADGETUP:
         return( "IDCMP_GADGETUP" );

      case IDCMP_REQSET:
         return( "IDCMP_REQSET" );

      case IDCMP_MENUPICK:
         return( "IDCMP_MENUPICK" );

      case IDCMP_CLOSEWINDOW:
         return( "IDCMP_CLOSEWINDOW" );

      case IDCMP_RAWKEY:
         return( "IDCMP_RAWKEY" );

      case IDCMP_REQVERIFY:
         return( "IDCMP_REQVERIFY" );

      case IDCMP_REQCLEAR:
         return( "IDCMP_REQCLEAR" );

      case IDCMP_MENUVERIFY:
         return( "IDCMP_MENUVERIFY" );

      case IDCMP_NEWPREFS:
         return( "IDCMP_NEWPREFS" );

      case IDCMP_DISKINSERTED:
         return( "IDCMP_DISKINSERTED" );

      case IDCMP_DISKREMOVED:
         return( "IDCMP_DISKREMOVED" );

      case IDCMP_WBENCHMESSAGE:
         return( "IDCMP_WBENCHMESSAGE" );

      case IDCMP_ACTIVEWINDOW:
         return( "IDCMP_ACTIVEWINDOW" );

      case IDCMP_INACTIVEWINDOW:
         return( "IDCMP_INACTIVEWINDOW" );

      case IDCMP_DELTAMOVE:
         return( "IDCMP_DELTAMOVE" );

      case IDCMP_VANILLAKEY:
         return( "IDCMP_VANILLAKEY" );

      case IDCMP_INTUITICKS:
         return( "IDCMP_INTUITICKS" );

      case IDCMP_IDCMPUPDATE:
         return( "IDCMP_IDCMPUPDATE" );

      case IDCMP_MENUHELP:
         return( "IDCMP_MENUHELP" );

      case IDCMP_CHANGEWINDOW:
         return( "IDCMP_CHANGEWINDOW" );

      case IDCMP_GADGETHELP:
         return( "IDCMP_GADGETHELP" );
         
      default:
         return( "IDCMP_ERRORVALUE" );
      }
}

PUBLIC char *getWindowFlag( int wFlagValue )
{
   switch (wFlagValue)
      {
      default:
         return( "WFLG_VALUE_ERROR" );
         
      case WFLG_SIZEGADGET:
         return( "WFLG_SIZEGADGET" );

      case WFLG_DRAGBAR:
         return( "WFLG_DRAGBAR" );

      case WFLG_DEPTHGADGET:
         return( "WFLG_DEPTHGADGET" );

      case WFLG_CLOSEGADGET:
         return( "WFLG_CLOSEGADGET" );

      case WFLG_SIZEBRIGHT:
         return( "WFLG_SIZEBRIGHT" );

      case WFLG_SIZEBBOTTOM:
         return( "WFLG_SIZEBBOTTOM" );

      case WFLG_SMART_REFRESH:
         return( "WFLG_SMART_REFRESH" );

      case WFLG_SIMPLE_REFRESH:
         return( "WFLG_SIMPLE_REFRESH" );

      case WFLG_SUPER_BITMAP:
         return( "WFLG_SUPER_BITMAP" );

      case WFLG_OTHER_REFRESH:
         return( "WFLG_OTHER_REFRESH" );

      case WFLG_BACKDROP:
         return( "WFLG_BACKDROP" );

      case WFLG_REPORTMOUSE:
         return( "WFLG_REPORTMOUSE" );

      case WFLG_GIMMEZEROZERO:
         return( "WFLG_GIMMEZEROZERO" );

      case WFLG_BORDERLESS:
         return( "WFLG_BORDERLESS" );

      case WFLG_ACTIVATE:
         return( "WFLG_ACTIVATE" );

      case WFLG_RMBTRAP:
         return( "WFLG_RMBTRAP" );

      case WFLG_NOCAREREFRESH:
         return( "WFLG_NOCAREREFRESH" );

      case WFLG_NW_EXTENDED:
         return( "WFLG_NW_EXTENDED" );

      case WFLG_NEWLOOKMENUS:
         return( "WFLG_NEWLOOKMENUS" );

      case WFLG_VISITOR:
         return( "WFLG_VISITOR" );

      case WFLG_ZOOMED:
         return( "WFLG_ZOOMED" );

      case WFLG_HASZOOM:
         return( "WFLG_HASZOOM" );
      }
}

PUBLIC char *getWindowTag( int wTag )
{
   switch (wTag)
      {
      default:
         return( "WA_TAG_VALUE_ERROR" );
         
      case WA_Left:
         return( "WA_Left" );

      case WA_Top:
         return( "WA_Top" );

      case WA_Width:
         return( "WA_Width" );

      case WA_Height:
         return( "WA_Height" );

      case WA_DetailPen:
         return( "WA_DetailPen" );

      case WA_BlockPen:
         return( "WA_BlockPen" );

      case WA_IDCMP:
         return( "WA_IDCMP" );

      case WA_Flags:
         return( "WA_Flags" );

      case WA_Gadgets:
         return( "WA_Gadgets" );

      case WA_Checkmark:
         return( "WA_Checkmark" );

      case WA_Title:
         return( "WA_Title" );

      case WA_ScreenTitle:
         return( "WA_ScreenTitle" );

      case WA_CustomScreen:
         return( "WA_CustomScreen" );

      case WA_SuperBitMap:
         return( "WA_SuperBitMap" );

      case WA_MinWidth:
         return( "WA_MinWidth" );

      case WA_MinHeight:
         return( "WA_MinHeight" );

      case WA_MaxWidth:
         return( "WA_MaxWidth" );

      case WA_MaxHeight:
         return( "WA_MaxHeight" );

      case WA_InnerWidth:
         return( "WA_InnerWidth" );

      case WA_InnerHeight:
         return( "WA_InnerHeight" );

      case WA_PubScreenName:
         return( "WA_PubScreenName" );

      case WA_PubScreen:
         return( "WA_PubScreen" );

      case WA_PubScreenFallBack:
         return( "WA_PubScreenFallBack" );

      case WA_WindowName:
         return( "WA_WindowName" );

      case WA_Colors:
         return( "WA_Colors" );

      case WA_Zoom:
         return( "WA_Zoom" );

      case WA_MouseQueue:
         return( "WA_MouseQueue" );

      case WA_BackFill:
         return( "WA_BackFill" );

      case WA_RptQueue:
         return( "WA_RptQueue" );

      case WA_SizeGadget:
         return( "WA_SizeGadget" );

      case WA_DragBar:
         return( "WA_DragBar" );

      case WA_DepthGadget:
         return( "WA_DepthGadget" );

      case WA_CloseGadget:
         return( "WA_CloseGadget" );

      case WA_Backdrop:
         return( "WA_Backdrop" );

      case WA_ReportMouse:
         return( "WA_ReportMouse" );

      case WA_NoCareRefresh:
         return( "WA_NoCareRefresh" );

      case WA_Borderless:
         return( "WA_Borderless" );

      case WA_Activate:
         return( "WA_Activate" );

      case WA_RMBTrap:
         return( "WA_RMBTrap" );

      case WA_WBenchWindow:
         return( "WA_WBenchWindow" );

      case WA_SimpleRefresh:
         return( "WA_SimpleRefresh" );

      case WA_SmartRefresh:
         return( "WA_SmartRefresh" );

      case WA_SizeBRight:
         return( "WA_SizeBRight" );

      case WA_SizeBBottom:
         return( "WA_SizeBBottom" );

      case WA_AutoAdjust:
         return( "WA_AutoAdjust" );

      case WA_GimmeZeroZero:
         return( "WA_GimmeZeroZero" );

      case WA_MenuHelp:
         return( "WA_MenuHelp" );

      case WA_NewLookMenus:
         return( "WA_NewLookMenus" );

      case WA_AmigaKey:
         return( "WA_AmigaKey" );

      case WA_NotifyDepth:
         return( "WA_NotifyDepth" );

      case WA_Pointer:
         return( "WA_Pointer" );

      case WA_BusyPointer:
         return( "WA_BusyPointer" );

      case WA_PointerDelay:
         return( "WA_PointerDelay" );

      case WA_TabletMessages:
         return( "WA_TabletMessages" );

      case WA_HelpGroup:
         return( "WA_HelpGroup" );

      case WA_HelpGroupWindow:
         return( "WA_HelpGroupWindow" );
      }
}
