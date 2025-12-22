{--------------------------------------------------------------------------

                         OPALVISION LIBRARY UNIT

                   ( HighSpeed Pascal for the Amiga )

                   Programmed by Kelly J. Petlig 1992

                 Copyright (c) 1992 All rights reserved

  Version : Date (mm/dd/yy) : Comment
  -----------------------------------
    1.00 : 12/27/92 : First version
    1.01 : 12/30/92 : Fixed bug (called procedures as functions)
    1.02 : 12/31/92 : Added OpalRequestor procedure
    1.03 : 01/11/93 : CloseScreen24 now is a procedure, not a function
    1.04 : 01/13/93 : Bug in _fd file caused problem with LowMemUpdate24

--------------------------------------------------------------------------}

Unit Opal;

INTERFACE

Uses Exec, Intuition;

Const

  MAXCOPROINS   = 290;     { Number of CoPro instructions }

          { Screen flags }

  HIRES24       = $0001;   { High resolution screen. }
  ILACE24       = $0002;   { Interlaced screen. }
  OVERSCAN24    = $0004;   { Overscan screen. }
  NTSC24        = $0008;   { NTSC Screen - Not user definable }
  CLOSEABLE24   = $0010;   { Screen is closeable. }
  PLANES8       = $0020;   { Screen has 8 bitplanes. }
  PLANES15      = $0040;   { Screen has 15 bitplanes. }
  CONTROLONLY24 = $2000;   { Used for updating control bits only }
  PALMAP24      = $4000;   { Screen is in palette mapped mode }
  INCHIP24      = $8000;   { In chip ram - Not user definable }

  FLAGSMASK24 = $6077;

          { LoadImage24 Flags }

  CONVERT24       = 1;  { Force conversion of palette mapped to 24 bit }
  KEEPRES24       = 2;  { Keep the current screen resolution }
  LOADMASK24      = 4;  { Load mask plane if it exists }
  VIRTUALSCREEN24 = 8;  { Load complete image into fast ram }

          { SaveIFF24 Flags }

  OVFASTFORMAT = 1;     { Save as opalvision fast format }
  NOTHUMBNAIL  = 4;     { Inhibit thumbnail chunk }
  SAVEMASK24   = 8;     { Save MaskPlane with image }

          { Config Flags }

  OVCF_OPALVISION = 1;      { Display board is an OpalVision }
  OVCF_COLORBURST = 2;      { Display board is a ColorBurst }

          { Opal Requestor Flags }

  NO_INFO   = 1;        { Exclude files ending in .info }
  LASTPATH  = 2;        { Use Last selected path as current }

  OR_ERR_OUTOFMEM = 1;
  OR_ERR_INUSE    = 2;

  OPALREQ_HEIGHT  = 345;    { The height of the Requester }

          { Coprocessor bits. }

  VIDMODE0     = $01;    { Video control bit 1 (S0) }
  VIDMODE1     = $02;    { Video control bit 1 (S1) }
  DISPLAYBANK2 = $04;    { Select display bank 2 }
  HIRESDISP    = $08;    { Enable hi-res display }
  DUALDISPLAY  = $10;    { Select dual display mode (active low) }
  OVPRI        = $20;    { Set OpalVision priority }
  PRISTENCIL   = $40;    { Enable priority stencil }
  ADDLOAD      = $80;    { Address load bit. Active low }

  ADDLOAD_B      = 7;
  PRISTENCIL_B   = 6;
  OVPRI_B        = 5;
  DUALDISPLAY_B  = 4;
  HIRESDISP_B    = 3;
  DISPLAYBANK2_B = 2;
  VIDMODE1_B     = 1;
  VIDMODE0_B     = 0;

          { Control line bits }

  VALID0        = $00001;
  VALID1        = $00002;
  VALID2        = $00004;
  VALID3        = $00008;
  WREN          = $00010;
  COL_COPRO     = $00020;
  AUTO          = $00040;
  DUALPLAYFIELD = $00080;
  FIELD         = $00100;
  AUTOFIELD     = $00200;
  DISPLAYLATCH  = $00400;
  FRAMEGRAB     = $00800;
  RWR1          = $01000;
  RWR2          = $02000;
  GWR1          = $04000;
  GWR2          = $08000;
  BWR1          = $10000;
  BWR2          = $20000;
  VLSIPROG      = $40000;
  FREEZEFRAME   = $80000;

  VALID0_B        =  0;
  VALID1_B        =  1;
  VALID2_B        =  2;
  VALID3_B        =  3;
  WREN_B          =  4;
  COL_COPRO_B     =  5;
  AUTO_B          =  6;
  DUALPLAYFIELD_B =  7;
  FIELD_B         =  8;
  AUTOFIELD_B     =  9;
  DISPLAYLATCH_B  = 10;
  FRAMEGRAB_B     = 11;
  RWR1_B          = 12;
  RWR2_B          = 13;
  GWR1_B          = 14;
  GWR2_B          = 15;
  BWR1_B          = 16;
  BWR2_B          = 17;
  VLSIPROG_B      = 18;
  FREEZEFRAME_B   = 19;

  NUMCONTROLBITS  = 20;
  VALIDCODE       =  5;

          { Error return codes }

  OL_ERR_OUTOFMEM      =  1;
  OL_ERR_OPENFILE      =  2;
  OL_ERR_NOTIFF        =  3;
  OL_ERR_FORMATUNKNOWN =  3;
  OL_ERR_NOTILBM       =  4;
  OL_ERR_FILEREAD      =  5;
  OL_ERR_FILEWRITE     =  6;
  OL_ERR_BADIFF        =  7;
  OL_ERR_CANTCLOSE     =  8;
  OL_ERR_OPENSCREEN    =  9;
  OL_ERR_NOTHUMBNAIL   = 10;
  OL_ERR_BADJPEG       = 11;
  OL_ERR_UNSUPPORTED   = 12;
  OL_ERR_CTRLC         = 13;
  OL_ERR_MAXERR        = 40;

Type
  tOpalScreen = Record
    Width : Integer;
    Height : Integer;
    Depth : Integer;            { Is this actually Depth / 2 ? }
    ClipX1,ClipY1 : Integer;
    ClipX2,ClipY2 : Integer;
    BytesPerLine : Integer;
    Flags : Word;
    RelX : Integer;
    RelY : Integer;
    UserPort : pMsgPort;
    MaxFrames : Integer;
    VStart : Integer;
    CoProOffset : Integer;
    LastWait : Integer;
    LastCoProIns : Word;
    BitPlanes : Array [0..23] of pShortInt; { 24 }
    MaskPlane : pShortInt;
    AddressReg : LongInt;
    UpdateDelay : Byte;
    PalLoadAddress : Byte;
    PixelReadMask : Byte;
    CommandReg : Byte;
    Palette : Array [0..767] of Byte; { 3 * 256 }
    Pen_R : Byte;
    Pen_G : Byte;
    Pen_B : Byte;
    Red : Byte;
    Green : Byte;
    Blue : Byte;
    CoProData : Array [0..289] of Byte; { MAXCOPROINS }
    Modulo : Integer;
    Reserved : Array [0..37] of Byte; { 38 }

  {$Ifdef OPAL_PRIVATE }
    CopList_Cycle : Array [0..11] of LongInt; { 12 }
    Update_Cycles : Byte;
    Pad : Byte;
  {$endif }

    end;

  pOpalScreen = ^tOpalScreen;

  tOpalReqBase = Record
          OR_Lib : tLibrary;
          OR_SegList : LongInt;
          end;

  tOpalReq = Record
          TopEdge : Word;         { Top Line of requester }
          Hail : pShortInt;       { Hailing text }
          File_ : pShortInt;      { Filename buffer (>=31 chars) }
          Dir : pShortInt;        { Directory name. }
          Extension : pShortInt;  { File extension to include }
          Window : pWindow;       { Window to display requester. }
          OScrn : pOpalScreen;    { OpalScreen to display req. }
          Pointer : pWord;        { Sprite mouse pointer }
          OKHit : Integer;        { TRUE if OK gadget hit }
          NeedRefresh : Integer;  { OpalScreen needs a refresh }
          Flags : LongInt;        { See Below }
          BackPen : Integer;      { Pen # to use for BG rendering }
          PrimaryPen : Integer;   { Pen # for primary rendering }
          SecondaryPen : Integer; { Pen # for secondary rendering }
          end;

pOpalReq = ^tOpalReq;

Var
  OpalBase: pLibrary;
  OpalReqBase : pOpalReq;

Function OpenScreen24 (Modes: LongInt): pOpalScreen;
Procedure CloseScreen24;
Function WritePixel24
                 (Screen: pOpalScreen;
                  x,
                  y: LongInt): LongInt;

Function ReadPixel24
                 (Screen: pOpalScreen;
                  x,
                  y: LongInt): LongInt;

Procedure ClearScreen24 (Screen: pOpalScreen);
Procedure ILBMtoOV
                 (Screen : pOpalScreen;
                  ILBMData: Pointer;
                  SourceWidth,
                  Lines,
                  TopLine,
                  Planes: LongInt);

Procedure UpdateDelay24 (Frames: LongInt);
Procedure Refresh24;
Function SetDisplayBottom24 (BottomLine: LongInt): LongInt;
Procedure ClearDisplayBottom24;
Procedure SetSprite24
                 (SpriteData: Pointer;
                  SpriteNum: LongInt);

Procedure AmigaPriority;
Procedure OVPriority;
Procedure DualDisplay24;
Procedure SingleDisplay24;
Procedure AppendCopper24 (CopperArray: Pointer);
Procedure RectFill24
                 (Screen: pOpalScreen;
                  x1,
                  y1,
                  x2,
                  y2: LongInt);

Procedure UpdateCoPro24;
Procedure SetControlBit24
                 (List,
                  Bit,
                  State: LongInt);

Procedure PaletteMap24 (State: LongInt);
Procedure UpdatePalette24;
Procedure Scroll24
                 (Deltax,
                  Deltay: LongInt);

Function LoadImage24
                 (Screen: pOpalScreen;
                  FileName: pCString;
                  Flags: LongInt): LongInt;

Procedure SetScreen24 (Screen: pOpalScreen);
Function SaveIFF24
                 (Screen: pOpalScreen;
                  FileName: pCString;
                  ChunkFunc: Pointer;
                  Flags: LongInt): LongInt;

Function CreateScreen24
                 (ScreenModes,
                  Width,
                  Height: LongInt): pOpalScreen;

Procedure FreeScreen24 (Screen: pOpalScreen);
Procedure UpdateRegs24;
Procedure SetLoadAddress24;
Procedure RGBtoOV
                 (Screen: pOpalScreen;
                  RGBData: Pointer;
                  x,
                  y,
                  w,
                  h: LongInt);

Function ActiveScreen24: pOpalScreen;
Procedure FadeIn24 (HundredthsSecs: LongInt);  { Must be > 1 }
Procedure FadeOut24 (HundredthsSecs: LongInt);   { Must be > 1 }
Procedure ClearQuick24;
Function WriteThumbnail24
                 (Screen: pOpalScreen;
                  File_: Pointer): LongInt;

Procedure SetRGB24
                 (Entry,
                  R,
                  G,
                  B: LongInt);

Procedure DrawLine24
                 (Screen: pOpalScreen;
                  x1,
                  y1,
                  x2,
                  y2: LongInt);

Procedure StopUpdate24;
Function WritePFPixel24
                 (Screen: pOpalScreen;
                  x,
                  y: LongInt): LongInt;

Function WritePRPixel24
                 (Screen: pOpalScreen;
                  x,
                  y: LongInt): LongInt;

Function OVtoRGB
                 (Screen: pOpalScreen;
                  RGBData: Pointer;
                  x,
                  y,
                  w,
                  h: LongInt): LongInt;

Procedure OVtoILBM
                 (Screen: pOpalScreen;
                  ILBMData: Pointer;
                  DestWidth,
                  Lines,
                  TopLine: LongInt);

Procedure UpdateAll24;
Procedure UpdatePFStencil24;
Procedure EnablePRStencil24;
Procedure DisablePRStencil24;
Procedure ClearPRStencil24 (Screen: pOpalScreen);
Procedure SetPRStencil24 (Screen: pOpalScreen);
Procedure DisplayFrame24 (Frame: LongInt);
Procedure WriteFrame24 (Frame: LongInt);
Procedure BitPlanetoOV
                 (Screen: pOpalScreen;
                  SrcPlanes: Pointer;
                  BytesPerLine,
                  Lines,
                  TopLine,
                  Depth: LongInt);

Procedure SetCoPro24
                 (Line,
                  Instruction: LongInt);

Procedure RegWait24;
Procedure DualPlayField24;
Procedure SinglePlayField24;
Procedure ClearPFStencil24 (Screen: pOpalScreen);
Procedure SetPFStencil24 (Screen: pOpalScreen);
Function ReadPRPixel24
                 (Screen: pOpalScreen;
                  x,
                  y: LongInt): LongInt;

Function ReadPFPixel24
                 (Screen: pOpalScreen;
                  x,
                  y: LongInt): LongInt;

Procedure OVtoBitPlane
                 (Screen: pOpalScreen;
                  DestPlanes: Pointer;
                  DestWidth,
                  Lines,
                  TopLine: LongInt);

Procedure FreezeFrame24 (Freeze: LongInt);
Function LowMemUpdate24
                 (Screen: pOpalScreen;
                  Frame: LongInt): pOpalScreen;
Function DisplayThumbnail24
                 (Screen: pOpalScreen;
                  FileName: pCString;
                  x,
                  y: LongInt): LongInt;

Function Config24: LongInt;
Procedure AutoSync24 (Sync: LongInt);
Procedure DrawEllipse24
                 (Screen: pOpalScreen;
                  Cx,
                  Cy,
                  a,
                  b: LongInt);

Procedure LatchDisplay24 (Latch: LongInt);
Procedure SetHires24
                 (TopLine,
                  Lines: LongInt);

Procedure SetLores24
                 (TopLine,
                  Lines: LongInt);

Function DownLoadFrame24
                 (Screen: pOpalScreen;
                  x,
                  y,
                  w,
                  h: LongInt): LongInt;

Function SaveJPEG24
                 (Screen: pOpalScreen;
                  FileName: pCString;
                  Flags,
                  Quality: LongInt): LongInt;

Function LowMem2Update24
                 (Screen: pOpalScreen;
                  Frame: LongInt): pOpalScreen;

Function LowMemRGB24
                 (Screen: pOpalScreen;
                  Frame,
                  Width,
                  Height,
                  Modulo: LongInt;
                  RGBPlanes: Pointer): pOpalScreen;

Procedure OpalRequestor (OpalReq : pOpalReq);
