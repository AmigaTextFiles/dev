{ Intuition STRUCTS and CONSTs.

  Date: 13th,24th January 1993,
	12th December 1993,
	17th July 1994,
	2nd August 1994 }

#include <stddef.h>

struct Border
  SHORTINT  LeftEdge
  SHORTINT  TopEdge
  BYTE	    FrontPen
  BYTE	    BackPen
  BYTE	    DrawMode
  BYTE	    Count
  LONGINT   XY
  LONGINT   NextBorder 
end struct

struct IntuiText
  BYTE 	    FrontPen
  BYTE 	    BackPen
  BYTE 	    DrawMode
  BYTE 	    KludgeFill00
  SHORTINT  LeftEdge
  SHORTINT  TopEdge
  LONGINT   ITextFont 
  LONGINT   IText
  LONGINT   NextText
end struct

struct IntuiGadget
  LONGINT   NextIntuiGadget
  SHORTINT  LeftEdge
  SHORTINT  TopEdge
  SHORTINT  Wdth
  SHORTINT  Height
  SHORTINT  Flags
  SHORTINT  Activation
  SHORTINT  IntuiGadgetType
  LONGINT   IntuiGadgetRender
  LONGINT   SelectRender
  LONGINT   IntuiGadgetText
  LONGINT   MutualExclude
  LONGINT   SpecialInfo
  SHORTINT  IntuiGadgetID
  LONGINT   UserData    
end struct

struct IntuiMessage
  STRING    ExecMessage SIZE 20  
  LONGINT   Class
  SHORTINT  Code
  SHORTINT  Qualifier
  LONGINT   IAddress
  SHORTINT  MouseX
  SHORTINT  MouseY
  LONGINT   Seconds
  LONGINT   Micros
  LONGINT   IDCMPWindow
  LONGINT   SpecialLink
end struct

struct ScreenStruct
   LONGINT  NextScreen '*Screen
   LONGINT  FirstWindow '*Window
   SHORTINT LeftEdge
   SHORTINT TopEdge
   SHORTINT xWidth
   SHORTINT Height
   SHORTINT MouseY
   SHORTINT MouseX
   SHORTINT Flags
   LONGINT  Title '*
   LONGINT  DefaultTitle '*
   BYTE     BarHeight
   BYTE     BarVBorder
   BYTE     BarHBorder
   BYTE     MenuVBorder
   BYTE     MenuHBorder
   BYTE     WBorTop
   BYTE     WBorLeft
   BYTE     WBorRight
   BYTE     WBorBottom
   BYTE	    KludgeFill00
   LONGINT  xFont '*
   STRING   ViewPort   SIZE 40  'struct
   STRING   RastPort   SIZE 100 'struct
   STRING   BitMap     SIZE 40  'struct
   STRING   Layer_Info SIZE 102 'struct
   LONGINT  FirstGadget '*Gadget
   BYTE     DetailPen
   BYTE     BlockPen
   SHORTINT SaveColor0
   LONGINT  BarLayer '*
   LONGINT  ExtData '*
   LONGINT  UserData '*
end struct

struct WindowStruct
   LONGINT  NextWindow '*Window
   SHORTINT LeftEdge
   SHORTINT TopEdge
   SHORTINT xWidth
   SHORTINT Height
   SHORTINT MouseY
   SHORTINT MouseX
   SHORTINT MinWidth
   SHORTINT MinHeight
   SHORTINT MaxWidth
   SHORTINT MaxHeight
   LONGINT  Flags
   LONGINT  MenuStrip '*Menu
   LONGINT  Title '*
   LONGINT  FirstRequest '*
   LONGINT  DMRequest '*
   SHORTINT ReqCount
   LONGINT  WScreen '*Screen
   LONGINT  RPort '*RastPort
   BYTE     BorderLeft
   BYTE     BorderTop
   BYTE     BorderRight
   BYTE     BorderBottom
   LONGINT  BorderRPort '*RastPort
   LONGINT  FirstGadget '*Gadget
   LONGINT  Parent '*Window
   LONGINT  Descendant '*Window
   LONGINT  Pointer '*
   BYTE     PtrHeight
   BYTE     PtrWidth
   BYTE     XOffset
   BYTE     YOffset
   LONGINT  IDCMPFlags
   LONGINT  UserPort '*
   LONGINT  WindowPort '*
   LONGINT  MessageKey '*
   BYTE     DetailPen
   BYTE     BlockPen
   LONGINT  CheckMark '*
   LONGINT  ScreenTitle '*
   SHORTINT GZZMouseX
   SHORTINT GZZMouseY
   SHORTINT GZZWidth
   SHORTINT GZZHeight
   LONGINT  ExtData '*
   LONGINT  UserData '*
   LONGINT  WLayer '*
   LONGINT  IFont '*
end struct

'..draw modes
const JAM1 = 0&
const JAM2 = 1&
const COMPLEMENT = 2&
const INVERSVID  = 4&

'..gadgets
const GADGHCOMP  = 0&
const RELVERIFY  = 1&
const BOOLGADGET = 1&

'..IDCMP
const GADGETDOWN = 32&
const GADGETUP   = 64&
const CLOSEWINDOW = 512&
const VANILLAKEY = 2097152&
const INTUITICKS = 4194304&
