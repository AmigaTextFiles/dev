{
        GfxBase.i for PCQ Pascal
}

{$I   "Include:Exec/Lists.i"}
{$I   "Include:Exec/Libraries.i"}
{$I   "Include:Exec/Interrupts.i"}
{$I   "Include:exec/Semaphores.i"}
{$I   "Include:Graphics/Monitor.i"}

type

    GfxBaseRec = record
        LibNode         : Library;
        ActiView        : Address;      { ViewPtr }
        copinit         : Address; { (copinitptr) ptr to copper start up list }
        cia             : Address;      { for 8520 resource use }
        blitter         : Address;      { for future blitter resource use }
        LOFlist         : Address;
        SHFlist         : Address;
        blthd,
        blttl           : Address;
        bsblthd,
        bsblttl         : Address;      { Previous four are (bltnodeptr) }
        vbsrv,
        timsrv,
        bltsrv          : Interrupt;
        TextFonts       : List;
        DefaultFont     : Address;      { TextFontPtr }
        Modes           : Short;        { copy of current first bplcon0 }
        VBlank          : Byte;
        Debug           : Byte;
        BeamSync        : Short;
        system_bplcon0  : Short; { it is ored into each bplcon0 for display }
        SpriteReserved  : Byte;
        bytereserved    : Byte;
        Flags           : Short;
        BlitLock        : Short;
        BlitNest        : Short;

        BlitWaitQ       : List;
        BlitOwner       : Address;      { TaskPtr }
        TOF_WaitQ       : List;
        DisplayFlags    : Short;        { NTSC PAL GENLOC etc}

                { Display flags are determined at power on }

        SimpleSprites   : Address;      { SimpleSpritePtr ptr }
        MaxDisplayRow   : Short;        { hardware stuff, do not use }
        MaxDisplayColumn : Short;       { hardware stuff, do not use }
        NormalDisplayRows : Short;
        NormalDisplayColumns : Short;

        { the following are for standard non interlace, 1/2 wb width }

        NormalDPMX      : Short;        { Dots per meter on display }
        NormalDPMY      : Short;        { Dots per meter on display }
        LastChanceMemory : Address;     { SignalSemaphorePtr }
        LCMptr          : Address;
        MicrosPerLine   : Short;        { 256 time usec/line }
        MinDisplayColumn : Short;
        ChipRevBits0    : Byte;
        crb_reserved  :  Array[0..4] of Byte;
        monitor_id  : Short;             { normally null }
        hedley  : Array[0..7] of Integer;
        hedley_sprites  : Array[0..7] of Integer;     { sprite ptrs for intuition mouse }
        hedley_sprites1 : Array[0..7] of Integer;            { sprite ptrs for intuition mouse }
        hedley_count    : Short;
        hedley_flags    : Short;
        hedley_tmp      : Short;
        hash_table      : Address;
        current_tot_rows : Short;
        current_tot_cclks : Short;
        hedley_hint     : Byte;
        hedley_hint2    : Byte;
        nreserved       : Array[0..3] of Integer;
        a2024_sync_raster : Address;
        control_delta_pal : Short;
        control_delta_ntsc : Short;
        current_monitor : MonitorSpecPtr;
        MonitorList     : List;
        default_monitor : MonitorSpecPtr;
        MonitorListSemaphore : SignalSemaphorePtr;
        DisplayInfoDataBase : Address;
        ActiViewCprSemaphore : SignalSemaphorePtr;
        UtilityBase  : Address;           { for hook AND tag utilities   }
        ExecBase     : Address;              { to link with rom.lib }
        bwshifts     : Address;
        StrtFetchMasks,
        StopFetchMasks,
        Overrun,
        RealStops    : Address;
        SpriteWidth,                    { current width (in words) of sprites }
        SpriteFMode  : WORD;            { current sprite fmode bits    }
        SoftSprites,                    { bit mask of size change knowledgeable sprites }
        arraywidth   : BYTE;
        DefaultSpriteWidth : WORD;      { what width intuition wants }
        SprMoveDisable,
        WantChips,
        BoardMemType,
        Bugs         : Byte;
        gb_LayersBase : Address;
        ColorMask    : Integer;
        IVector,
        IData        : Address;
        SpecialCounter : Integer;         { special for double buffering }
        DBList       : Address;
        MonitorFlags : WORD;
        ScanDoubledSprites,
        BP3Bits      : Byte;
        MonitorVBlank  : AnalogSignalInterval;
        natural_monitor  : MonitorSpecPtr;
        ProgData     : Address;
        ExtSprites   : Byte;
        pad3         : Byte;
        GfxFlags     : WORD;
        VBCounter    : Integer;
        HashTableSemaphore  : SignalSemaphorePtr;
        HWEmul       : Array[0..8] of Address;
    end;
    GfxBasePtr = ^GfxBaseRec;

const

    NTSC        = 1;
    GENLOC      = 2;
    PAL         = 4;
    TODA_SAFE   = 8;

    BLITMSG_FAULT = 4;

{ bits defs for ChipRevBits }
   GFXB_BIG_BLITS = 0 ;
   GFXB_HR_AGNUS  = 0 ;
   GFXB_HR_DENISE = 1 ;
   GFXB_AA_ALICE  = 2 ;
   GFXB_AA_LISA   = 3 ;
   GFXB_AA_MLISA  = 4 ;      { internal use only. }

   GFXF_BIG_BLITS = 1 ;
   GFXF_HR_AGNUS  = 1 ;
   GFXF_HR_DENISE = 2 ;
   GFXF_AA_ALICE  = 4 ;
   GFXF_AA_LISA   = 8 ;
   GFXF_AA_MLISA  = 16;      { internal use only }

{ Pass ONE of these to SetChipRev() }
   SETCHIPREV_A   = GFXF_HR_AGNUS;
   SETCHIPREV_ECS = (GFXF_HR_AGNUS OR GFXF_HR_DENISE);
   SETCHIPREV_AA  = (GFXF_AA_ALICE OR GFXF_AA_LISA OR SETCHIPREV_ECS);
   SETCHIPREV_BEST= $ffffffff;

{ memory type }
   BUS_16         = 0;
   NML_CAS        = 0;
   BUS_32         = 1;
   DBL_CAS        = 2;
   BANDWIDTH_1X   = (BUS_16 OR NML_CAS);
   BANDWIDTH_2XNML= BUS_32;
   BANDWIDTH_2XDBL= DBL_CAS;
   BANDWIDTH_4X   = (BUS_32 OR DBL_CAS);

{ GfxFlags (private) }
   NEW_DATABASE   = 1;

   GRAPHICSNAME   = "graphics.library";


FUNCTION SetChipRev(want : Integer) : Integer;
    External;


