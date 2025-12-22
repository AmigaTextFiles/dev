(Menu (NextMenu 0 Menu . t) (LeftEdge 4 . 2) (TopEdge 6 . 2) (Width 8 . 2) 
(Height 10 . 2) (Flags 12 . 2) (MenuName 14 byte . t) (FirstItem 18 
MenuItem . t) (JazzX 22 . 2) (JazzY 24 . 2) (BeatX 26 . 2) (BeatY 28 . 2))

(MenuItem (NextItem 0 MenuItem . t) (LeftEdge 4 . 2) (TopEdge 6 . 2) (Width
8 . 2) (Height 10 . 2) (Flags 12 . 2) (MutualExclude 14 . 4) (ItemFill 18 
byte . t) (SelectFill 22 byte . t) (Command 26 . 1) (SubItem 28 MenuItem . 
t) (NextSelect 32 . 2))

(Requester (OlderRequest 0 Requester . t) (LeftEdge 4 . 2) (TopEdge 6 . 2) 
(Width 8 . 2) (Height 10 . 2) (RelLeft 12 . 2) (RelTop 14 . 2) (ReqGadget 
16 Gadget . t) (ReqBorder 20 Border . t) (ReqText 24 IntuiText . t) (Flags 
28 . 2) (BackFill 30 . 1) (ReqLayer 32 Layer . t) (ReqPad1 36 32 . 1) (
ImageBMap 68 BitMap . t) (RWindow 72 Window . t) (ReqPad2 76 36 . 1))

(Gadget (NextGadget 0 Gadget . t) (LeftEdge 4 . 2) (TopEdge 6 . 2) (Width 8
. 2) (Height 10 . 2) (Flags 12 . 2) (Activation 14 . 2) (GadgetType 16 . 2)
(GadgetRender 18 byte . t) (SelectRender 22 byte . t) (GadgetText 26 
IntuiText . t) (MutualExclude 30 . 4) (SpecialInfo 34 byte . t) (GadgetID 
38 . 2) (UserData 40 byte . t))

(BoolInfo (Flags 0 . 2) (Mask 2 word . t) (Reserved 6 . 4))

(PropInfo (Flags 0 . 2) (HorizPot 2 . 2) (VertPot 4 . 2) (HorizBody 6 . 2) 
(VertBody 8 . 2) (CWidth 10 . 2) (CHeight 12 . 2) (HPotRes 14 . 2) (VPotRes
16 . 2) (LeftBorder 18 . 2) (TopBorder 20 . 2))

(StringInfo (Buffer 0 byte . t) (UndoBuffer 4 byte . t) (BufferPos 8 . 2) (
MaxChars 10 . 2) (DispPos 12 . 2) (UndoPos 14 . 2) (NumChars 16 . 2) (
DispCount 18 . 2) (CLeft 20 . 2) (CTop 22 . 2) (LayerPtr 24 Layer . t) (
LongInt 28 . 4) (AltKeyMap 32 KeyMap . t))

(IntuiText (FrontPen 0 . 1) (BackPen 1 . 1) (DrawMode 2 . 1) (LeftEdge 4 . 
2) (TopEdge 6 . 2) (ITextFont 8 TextAttr . t) (IText 12 byte . t) (NextText
16 IntuiText . t))

(Border (LeftEdge 0 . 2) (TopEdge 2 . 2) (FrontPen 4 . 1) (BackPen 5 . 1) (
DrawMode 6 . 1) (Count 7 . 1) (XY 8 word . t) (NextBorder 12 Border . t))

(Image (LeftEdge 0 . 2) (TopEdge 2 . 2) (Width 4 . 2) (Height 6 . 2) (Depth
8 . 2) (ImageData 10 word . t) (PlanePick 14 . 1) (PlaneOnOff 15 . 1) (
NextImage 16 Image . t))

(IntuiMessage (ExecMessage 0 Message) (Class 20 . 4) (Code 24 . 2) (
Qualifier 26 . 2) (IAddress 28 byte . t) (MouseX 32 . 2) (MouseY 34 . 2) (
Seconds 36 . 4) (Micros 40 . 4) (IDCMPWindow 44 Window . t) (SpecialLink 48
IntuiMessage . t))

(Window (NextWindow 0 Window . t) (LeftEdge 4 . 2) (TopEdge 6 . 2) (Width 8
. 2) (Height 10 . 2) (MouseY 12 . 2) (MouseX 14 . 2) (MinWidth 16 . 2) (
MinHeight 18 . 2) (MaxWidth 20 . 2) (MaxHeight 22 . 2) (Flags 24 . 4) (
MenuStrip 28 Menu . t) (Title 32 byte . t) (FirstRequest 36 Requester . t) 
(DMRequest 40 Requester . t) (ReqCount 44 . 2) (WScreen 46 Screen . t) (
RPort 50 RastPort . t) (BorderLeft 54 . 1) (BorderTop 55 . 1) (BorderRight 
56 . 1) (BorderBottom 57 . 1) (BorderRPort 58 RastPort . t) (FirstGadget 62
Gadget . t) (Parent 66 Window . t) (Descendant 70 Window . t) (Pointer 74 
word . t) (PtrHeight 78 . 1) (PtrWidth 79 . 1) (XOffset 80 . 1) (YOffset 81
. 1) (IDCMPFlags 82 . 4) (UserPort 86 MsgPort . t) (WindowPort 90 MsgPort .
t) (MessageKey 94 IntuiMessage . t) (DetailPen 98 . 1) (BlockPen 99 . 1) (
CheckMark 100 Image . t) (ScreenTitle 104 byte . t) (GZZMouseX 108 . 2) (
GZZMouseY 110 . 2) (GZZWidth 112 . 2) (GZZHeight 114 . 2) (ExtData 116 byte
. t) (UserData 120 byte . t) (WLayer 124 Layer . t) (IFont 128 TextFont . t
))

(NewWindow (LeftEdge 0 . 2) (TopEdge 2 . 2) (Width 4 . 2) (Height 6 . 2) (
DetailPen 8 . 1) (BlockPen 9 . 1) (IDCMPFlags 10 . 4) (Flags 14 . 4) (
FirstGadget 18 Gadget . t) (CheckMark 22 Image . t) (Title 26 byte . t) (
Screen 30 Screen . t) (BitMap 34 BitMap . t) (MinWidth 38 . 2) (MinHeight 
40 . 2) (MaxWidth 42 . 2) (MaxHeight 44 . 2) (Type 46 . 2))

(Screen (NextScreen 0 Screen . t) (FirstWindow 4 Window . t) (LeftEdge 8 . 
2) (TopEdge 10 . 2) (Width 12 . 2) (Height 14 . 2) (MouseY 16 . 2) (MouseX 
18 . 2) (Flags 20 . 2) (Title 22 byte . t) (DefaultTitle 26 byte . t) (
BarHeight 30 . 1) (BarVBorder 31 . 1) (BarHBorder 32 . 1) (MenuVBorder 33 .
1) (MenuHBorder 34 . 1) (WBorTop 35 . 1) (WBorLeft 36 . 1) (WBorRight 37 . 
1) (WBorBottom 38 . 1) (Font 40 TextAttr . t) (ViewPort 44 ViewPort) (
RastPort 84 RastPort) (BitMap 184 BitMap) (LayerInfo 224 Layer_Info) (
FirstGadget 326 Gadget . t) (DetailPen 330 . 1) (BlockPen 331 . 1) (
SaveColor0 332 . 2) (BarLayer 334 Layer . t) (ExtData 338 byte . t) (
UserData 342 byte . t))

(NewScreen (LeftEdge 0 . 2) (TopEdge 2 . 2) (Width 4 . 2) (Height 6 . 2) (
Depth 8 . 2) (DetailPen 10 . 1) (BlockPen 11 . 1) (ViewModes 12 . 2) (Type 
14 . 2) (Font 16 TextAttr . t) (DefaultTitle 20 byte . t) (Gadgets 24 
Gadget . t) (CustomBitMap 28 BitMap . t))

(Preferences (FontHeight 0 . 1) (PrinterPort 1 . 1) (BaudRate 2 . 2) (
KeyRptSpeed 4 timeval) (KeyRptDelay 12 timeval) (DoubleClick 20 timeval) (
PointerMatrix 28 36 . 2) (XOffset 100 . 1) (YOffset 101 . 1) (color17 102 .
2) (color18 104 . 2) (color19 106 . 2) (PointerTicks 108 . 2) (color0 110 .
2) (color1 112 . 2) (color2 114 . 2) (color3 116 . 2) (ViewXOffset 118 . 1)
(ViewYOffset 119 . 1) (ViewInitX 120 . 2) (ViewInitY 122 . 2) (EnableCLI 
124 . 2) (PrinterType 126 . 2) (PrinterFilename 128 30 . 1) (PrintPitch 158
. 2) (PrintQuality 160 . 2) (PrintSpacing 162 . 2) (PrintLeftMargin 164 . 2
) (PrintRightMargin 166 . 2) (PrintImage 168 . 2) (PrintAspect 170 . 2) (
PrintShade 172 . 2) (PrintThreshold 174 . 2) (PaperSize 176 . 2) (
PaperLength 178 . 2) (PaperType 180 . 2) (SerRWBits 182 . 1) (SerStopBuf 
183 . 1) (SerParShk 184 . 1) (LaceWB 185 . 1) (WorkName 186 30 . 1) (
padding 216 16 . 1))

(Remember (NextRemember 0 Remember . t) (RememberSize 4 . 4) (Memory 8 byte
. t))

