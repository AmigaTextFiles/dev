{
    View.i for PCQ Pascal
}


{$I   "Include:Graphics/GFX.i"}
{$I   "Include:Graphics/Copper.i"}
{$I   "Include:Graphics/GFXNodes.i"}
{$I   "Include:Graphics/Monitor.i"}

Type
    RasInfo = record    { used by callers to and InitDspC() }
        Next    : ^RasInfo;     { used for dualpf }
        BitMap  : BitMapPtr;
        RxOffset,
        RyOffset : Short;       { scroll offsets in this BitMap }
    end;
    RasInfoPtr = ^RasInfo;

    View = record
        v_ViewPort      : Address;      { ViewPortPtr }
        LOFCprList      : cprlistptr;   { used for interlaced and noninterlaced }
        SHFCprList      : cprlistptr;   { only used during interlace }
        DyOffset,
        DxOffset        : Short;        { for complete View positioning }
                                { offsets are +- adjustments to standard #s }
        Modes           : Short;        { such as INTERLACE, GENLOC }
    end;
    ViewPtr = ^View;

{ these structures are obtained via GfxNew }
{ and disposed by GfxFree }
Type
       ViewExtra = Record
        n : ExtendedNode;
        ve_View : View;       { backwards link }   { view in C-Includes }
        Monitor : MonitorSpecPtr; { monitors for this view }
       END;
       ViewExtraPtr = ^ViewExtra;


    ViewPort = record
        Next    : ^ViewPort;
        ColorMap : Address; { table of colors for this viewport }        { ColorMapPtr }
                          { if this is nil, MakeVPort assumes default values }
        DspIns  : CopListPtr;   { user by MakeView() }
        SprIns  : CopListPtr;   { used by sprite stuff }
        ClrIns  : CopListPtr;   { used by sprite stuff }
        UCopIns : UCopListPtr;  { User copper list }
        DWidth,
        DHeight : Short;
        DxOffset,
        DyOffset : Short;
        Modes   : Short;
        SpritePriorities : Byte;        { used by makevp }
        reserved : Byte;
        RasInfo : RasInfoPtr;
    end;
    ViewPortPtr = ^ViewPort;


{ this structure is obtained via GfxNew }
{ and disposed by GfxFree }
 ViewPortExtra = Record
  n : ExtendedNode;
  vpe_ViewPort : ViewPortPtr;      { backwards link }   { ViewPort in C-Includes }
  DisplayClip  : Rectangle;  { makevp display clipping information }
        { These are added for V39 }
  VecTable     : Address;                { Private }
  DriverData   : Array[0..1] of Address;
  Flags        : WORD;
  Origin       : Array[0..1] of Point;  { First visible point relative to the DClip.
                                         * One for each possible playfield.
                                         }
  cop1ptr,                  { private }
  cop2ptr      : Integer;   { private }
 END;
 ViewPortExtraPtr = ^ViewPortExtra;


    ColorMap = record
        Flags   : Byte;
        CType   : Byte;         { This is "Type" in C includes }
        Count   : Short;
        ColorTable      : Address;
        cm_vpe  : ViewPortExtraPtr;
        TransparencyBits : Address;
        TransparencyPlane,
        reserved1        : Byte;
        reserved2        : Short;
        cm_vp            : Address;   { ViewPortPtr }
        NormalDisplayInfo,
        CoerceDisplayInfo : Address;
        cm_batch_items   : Address;
        VPModeID         : Integer;
    end;
    ColorMapPtr = ^ColorMap;

{ if Type == 0 then ColorMap is V1.2/V1.3 compatible }
{ if Type != 0 then ColorMap is V36       compatible }
{ the system will never create other than V39 type colormaps when running V39 }

CONST
 COLORMAP_TYPE_V1_2     = $00;
 COLORMAP_TYPE_V1_4     = $01;
 COLORMAP_TYPE_V36      = COLORMAP_TYPE_V1_4;    { use this definition }
 COLORMAP_TYPE_V39      = $02;


{ Flags variable }
 COLORMAP_TRANSPARENCY   = $01;
 COLORPLANE_TRANSPARENCY = $02;
 BORDER_BLANKING         = $04;
 BORDER_NOTRANSPARENCY   = $08;
 VIDEOCONTROL_BATCH      = $10;
 USER_COPPER_CLIP        = $20;


CONST
 EXTEND_VSTRUCT = $1000;  { unused bit in Modes field of View }


{ defines used for Modes in IVPargs }

CONST
 GENLOCK_VIDEO  =  $0002;
 LACE           =  $0004;
 SUPERHIRES     =  $0020;
 PFBA           =  $0040;
 EXTRA_HALFBRITE=  $0080;
 GENLOCK_AUDIO  =  $0100;
 DUALPF         =  $0400;
 HAM            =  $0800;
 EXTENDED_MODE  =  $1000;
 VP_HIDE        =  $2000;
 SPRITES        =  $4000;
 HIRES          =  $8000;

 VPF_A2024      =  $40;
 VPF_AGNUS      =  $20;
 VPF_TENHZ      =  $20;

 BORDERSPRITES   = $40;

 CMF_CMTRANS   =  0;
 CMF_CPTRANS   =  1;
 CMF_BRDRBLNK  =  2;
 CMF_BRDNTRAN  =  3;
 CMF_BRDRSPRT  =  6;

 SPRITERESN_ECS       =   0;
{ ^140ns, except in 35ns viewport, where it is 70ns. }
 SPRITERESN_140NS     =   1;
 SPRITERESN_70NS      =   2;
 SPRITERESN_35NS      =   3;
 SPRITERESN_DEFAULT   =   -1;

{ AuxFlags : }
 CMAB_FULLPALETTE = 0;
 CMAF_FULLPALETTE = 1;
 CMAB_NO_INTERMED_UPDATE = 1;
 CMAF_NO_INTERMED_UPDATE = 2;
 CMAB_NO_COLOR_LOAD = 2;
 CMAF_NO_COLOR_LOAD = 4;
 CMAB_DUALPF_DISABLE = 3;
 CMAF_DUALPF_DISABLE = 8;

Type
    PaletteExtra = Record                            { structure may be extended so watch out! }
        pe_Semaphore  : SignalSemaphore;                { shared semaphore for arbitration     }
        pe_FirstFree,                                   { *private*                            }
        pe_NFree,                                       { number of free colors                }
        pe_FirstShared,                                 { *private*                            }
        pe_NShared    : WORD;                           { *private*                            }
        pe_RefCnt     : Address;                        { *private*                            }
        pe_AllocList  : Address;                        { *private*                            }
        pe_ViewPort   : ViewPortPtr;                    { back pointer to viewport             }
        pe_SharableColors : WORD;                       { the number of sharable colors.       }
    end;
    PaletteExtraPtr = ^PaletteExtra;
{ flags values for ObtainPen }
Const
 PENB_EXCLUSIVE = 0;
 PENB_NO_SETCOLOR = 1;

 PENF_EXCLUSIVE = 1;
 PENF_NO_SETCOLOR = 2;

{ obsolete names for PENF_xxx flags: }

 PEN_EXCLUSIVE = PENF_EXCLUSIVE;
 PEN_NO_SETCOLOR = PENF_NO_SETCOLOR;

{ precision values for ObtainBestPen : }

 PRECISION_EXACT = -1;
 PRECISION_IMAGE = 0;
 PRECISION_ICON  = 16;
 PRECISION_GUI   = 32;


{ tags for ObtainBestPen: }
 OBP_Precision = $84000000;
 OBP_FailIfBad = $84000001;

{ From V39, MakeVPort() will return an error if there is not enough memory,
 * or the requested mode cannot be opened with the requested depth with the
 * given bitmap (for higher bandwidth alignments).
 }

 MVP_OK        =  0;       { you want to see this one }
 MVP_NO_MEM    =  1;       { insufficient memory for intermediate workspace }
 MVP_NO_VPE    =  2;       { ViewPort does not have a ViewPortExtra, and
                                 * insufficient memory to allocate a temporary one.
                                 }
 MVP_NO_DSPINS =  3;       { insufficient memory for intermidiate copper
                                 * instructions.
                                 }
 MVP_NO_DISPLAY = 4;       { BitMap data is misaligned for this viewport's
                                 * mode and depth - see AllocBitMap().
                                 }
 MVP_OFF_BOTTOM = 5;       { PRIVATE - you will never see this. }

{ From V39, MrgCop() will return an error if there is not enough memory,
 * or for some reason MrgCop() did not need to make any copper lists.
 }

 MCOP_OK       =  0;       { you want to see this one }
 MCOP_NO_MEM   =  1;       { insufficient memory to allocate the system
                                 * copper lists.
                                 }
 MCOP_NOP      =  2;       { MrgCop() did not merge any copper lists
                                 * (eg, no ViewPorts in the list, or all marked as
                                 * hidden).
                                 }
Type
    DBufInfo = Record
        dbi_Link1   : Address;
        dbi_Count1  : Integer;
        dbi_SafeMessage : Message;         { replied to when safe to write to old bitmap }
        dbi_UserData1   : Address;                     { first user data }

        dbi_Link2   : Address;
        dbi_Count2  : Integer;
        dbi_DispMessage : Message; { replied to when new bitmap has been displayed at least
                                                        once }
        dbi_UserData2 : Address;                  { second user data }
        dbi_MatchLong : Integer;
        dbi_CopPtr1,
        dbi_CopPtr2,
        dbi_CopPtr3   : Address;
        dbi_BeamPos1,
        dbi_BeamPos2  : WORD;
    end;
    DBufInfoPtr = ^DBufInfo;


Procedure FreeColorMap(colormap : ColorMapPtr);
    External;

Procedure FreeVPortCopLists(vp : ViewPortPtr);
    External;

Function GetColorMap(entries : Integer) : ColorMapPtr;
    External;

Function GetRGB4(colomap : ColorMapPtr; entry : Integer) : Integer;
    External;

Procedure InitView(view : ViewPtr);
    External;

Procedure InitVPort(vp : ViewPortPtr);
    External;

Procedure LoadRGB4(vp : ViewPortPtr; colors : Address; count : Short);
    External;

Procedure LoadView(view : ViewPtr);
    External;

FUNCTION MakeVPort(view : ViewPtr; viewport : ViewPortPtr) : Integer;
    External;

FUNCTION MrgCop(view : ViewPtr) : Integer;
    External;

Procedure ScrollVPort(vp : ViewPortPtr);
    External;

Procedure SetRGB4(vp : ViewPortPtr; n : Short; r, g, b : Byte);
    External;

Procedure SetRGB4CM(cm : ColorMapPtr; n : Short; r, g, b : Byte);
    External;

Function VBeamPos : Integer;
    External;

Procedure WaitBOVP(vp : ViewPortPtr);
    External;

Procedure WaitTOF;
    External;

 { New for V39 }

FUNCTION CalclIVG(v : ViewPtr; vp : ViewPortPtr) : Word;
    External;

FUNCTION AttachPalExtra(cm : ColorMapPtr; vp : ViewPortPtr;) : Integer;
    External;

PROCEDURE SetRGB32(VP : ViewPortPtr; n, r, g, b : Integer);
    External;

PROCEDURE LoadRGB32(VP : ViewPortPtr; table : Address);
    External;

PROCEDURE GetRGB32(cm : ColorMapPtr; firstcolor, ncolors : Integer; table : Address);
    External;

FUNCTION AllocDBufInfo(VP : ViewPortPtr) : DBufInfoPtr;
    External;

PROCEDURE FreeDBufInfo(dbi : DBufInfoPtr);
    External;

PROCEDURE SetRGB32CM(CM : ColorMapPtr; n, r, g, b : Integer);
    External;

FUNCTION FindColor(CM : ColorMapPtr; r, g, b, maxcolor : Integer) : Integer;
    External;


