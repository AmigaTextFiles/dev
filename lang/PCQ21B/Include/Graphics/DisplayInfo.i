  {   include define file for displayinfo database }

{$I   "Include:Exec/Types.i"}
{$I   "Include:Graphics/Gfx.i"}
{$I   "Include:Graphics/Monitor.i"}
{$I   "Include:Utility/TagItem.i"}
{$I   "Include:Graphics/View.i"}
{$I   "Include:Graphics/ModeID.i"}

{ the "public" handle to a DisplayInfoRecord }
Type
 DisplayInfoHandle = APTR;

{ datachunk type identifiers }

CONST
 DTAG_DISP            =   $80000000;
 DTAG_DIMS            =   $80001000;
 DTAG_MNTR            =   $80002000;
 DTAG_NAME            =   $80003000;
 DTAG_VEC             =   $80004000;      { internal use only }

Type
  QueryHeader = Record
   tructID,                    { datachunk type identifier }
   DisplayID,                  { copy of display record key   }
   SkipID,                     { TAG_SKIP -- see tagitems.h }
   Length  :  Integer;         { length of local data in double-longwords }
  END;
  QueryHeaderPtr = ^QueryHeader;

  DisplayInfo = Record
   Header : QueryHeader;
   NotAvailable : Short;   { IF NULL available, else see defines }
   PropertyFlags : Integer;  { Properties of this mode see defines }
   Resolution : Point;     { ticks-per-pixel X/Y                 }
   PixelSpeed : Short;     { aproximation in nanoseconds         }
   NumStdSprites : Short;  { number of standard amiga sprites    }
   PaletteRange : Short;   { distinguishable shades available    }
   SpriteResolution : Point; { std sprite ticks-per-pixel X/Y    }
   pad : Array[0..3] of Byte;
   reserved : Array[0..1] of Integer;    { terminator }
  END;
  DisplayInfoPtr = ^DisplayInfo;

{ availability }

CONST
 DI_AVAIL_NOCHIPS        =$0001;
 DI_AVAIL_NOMONITOR      =$0002;
 DI_AVAIL_NOTWITHGENLOCK =$0004;

{ mode properties }

 DIPF_IS_LACE          =  $00000001;
 DIPF_IS_DUALPF        =  $00000002;
 DIPF_IS_PF2PRI        =  $00000004;
 DIPF_IS_HAM           =  $00000008;

 DIPF_IS_ECS           =  $00000010;      {      note: ECS modes (SHIRES, VGA, AND **
                                                 PRODUCTIVITY) do not support      **
                                                 attached sprites.                 **
                                                                                        }
 DIPF_IS_AA            =  $00010000;      { AA modes - may only be available
                                                ** if machine has correct memory
                                                ** type to support required
                                                ** bandwidth - check availability.
                                                ** (V39)
                                                }
 DIPF_IS_PAL           =  $00000020;
 DIPF_IS_SPRITES       =  $00000040;
 DIPF_IS_GENLOCK       =  $00000080;

 DIPF_IS_WB            =  $00000100;
 DIPF_IS_DRAGGABLE     =  $00000200;
 DIPF_IS_PANELLED      =  $00000400;
 DIPF_IS_BEAMSYNC      =  $00000800;

 DIPF_IS_EXTRAHALFBRITE = $00001000;

{ The following DIPF_IS_... flags are new for V39 }
  DIPF_IS_SPRITES_ATT           =  $00002000;      { supports attached sprites }
  DIPF_IS_SPRITES_CHNG_RES      =  $00004000;      { supports variable sprite resolution }
  DIPF_IS_SPRITES_BORDER        =  $00008000;      { sprite can be displayed in the border }
  DIPF_IS_SCANDBL               =  $00020000;      { scan doubled }
  DIPF_IS_SPRITES_CHNG_BASE     =  $00040000;
                                                   { can change the sprite base colour }
  DIPF_IS_SPRITES_CHNG_PRI      =  $00080000;
                                                                                        { can change the sprite priority
                                                                                        ** with respect to the playfield(s).
                                                                                        }
  DIPF_IS_DBUFFER       =  $00100000;      { can support double buffering }
  DIPF_IS_PROGBEAM      =  $00200000;      { is a programmed beam-sync mode }
  DIPF_IS_FOREIGN       =  $80000000;      { this mode is not native to the Amiga }

Type
 DimensionInfo = Record
  Header : QueryHeader;
  MaxDepth,             { log2( max number of colors ) }
  MinRasterWidth,       { minimum width in pixels      }
  MinRasterHeight,      { minimum height in pixels     }
  MaxRasterWidth,       { maximum width in pixels      }
  MaxRasterHeight : Short;      { maximum height in pixels     }
  Nominal,              { "standard" dimensions        }
  MaxOScan,             { fixed, hardware dependant    }
  VideoOScan,           { fixed, hardware dependant    }
  TxtOScan,             { editable via preferences     }
  StdOScan  : Rectangle; { editable via preferences     }
  pad  : Array[0..13] of Byte;
  reserved : Array[0..1] of Integer;          { terminator }
 END;
 DimensionInfoPtr = ^DimensionInfo;

 MonitorInfo = Record
  Header : QueryHeader;
  Mspc   : MonitorSpecPtr;         { pointer to monitor specification  }
  ViewPosition,                    { editable via preferences          }
  ViewResolution : Point;          { standard monitor ticks-per-pixel  }
  ViewPositionRange : Rectangle;   { fixed, hardware dependant }
  TotalRows,                       { display height in scanlines       }
  TotalColorClocks,                { scanline width in 280 ns units    }
  MinRow,                          { absolute minimum active scanline  }
  Compatibility : Short;           { how this coexists with others     }
  pad : Array[0..35] of Byte;
  reserved : Array[0..1] of Integer;          { terminator }
 END;
 MonitorInfoPtr = ^MonitorInfo;

{ monitor compatibility }

CONST
 MCOMPAT_MIXED =  0;       { can share display with other MCOMPAT_MIXED }
 MCOMPAT_SELF  =  1;       { can share only within same monitor }
 MCOMPAT_NOBODY= -1;       { only one viewport at a time }

 DISPLAYNAMELEN = 32;

Type
 NameInfo = Record
  Header : QueryHeader;
  Name   : Array[0..DISPLAYNAMELEN-1] of Char;
  reserved : Array[0..1] of Integer;          { terminator }
 END;
 NameInfoPtr = ^NameInfo;


{****************************************************************************}

{ The following VecInfo structure is PRIVATE, for our use only
 * Touch these, and burn! (V39)
 }
Type
 VecInfo = Record
        Header  : QueryHeader;
        Vec     : Address;
        Data    : Address;
        vi_Type : WORD;               { Type in C Includes }
        pad     : Array[0..2] of WORD;
        reserved : Array[0..1] of Integer;
 end;


FUNCTION FindDisplayInfo(ID : Integer) : DisplayInfoHandle;
    External;

FUNCTION GetDisplayInfoData(handle : DisplayInfoHandle; Buf : Address; Size, tagID, ID : Integer) : Integer;
    External;

FUNCTION GetVPModeID(VP : ViewPortPtr) : Integer;
    External;

FUNCTION ModeNotAvailable(ModeID : Integer) : Integer;
    External;

FUNCTION NextDisplayInfo(LastID : Integer) : Integer;
    External;

