{
        Layers.i for PCQ Pascal
}

{$I   "Include:Exec/Lists.i"}
{$I   "Include:Exec/Semaphores.i"}
{$I   "Include:Utility/Hooks.i"}
{$I   "Include:Graphics/Gfx.i"}

var
    LayersBase  : Address;

const

    LAYERSIMPLE         = 1;
    LAYERSMART          = 2;
    LAYERSUPER          = 4;
    LAYERUPDATING       = $10;
    LAYERBACKDROP       = $40;
    LAYERREFRESH        = $80;
    LAYER_CLIPRECTS_LOST = $100;        { during BeginUpdate }
                                        { or during layerop }
                                        { this happens if out of memory }
    LMN_REGION          = -1;

type
 Layer_Info = Record
    top_layer           : Address;
    check_lp            : Address;              { !! Private !! }
    obs                 : Address;
    FreeClipRects       : Address;              { !! Private !! }
    PrivateReserve1,                            { !! Private !! }
    PrivateReserve2     : Integer;              { !! Private !! }
    Lock                : SignalSemaphore;      { !! Private !! }
    gs_Head             : MinList;              { !! Private !! }
    PrivateReserve3     : WORD;                 { !! Private !! }
    PrivateReserve4     : Address;              { !! Private !! }
    Flags               : WORD;
    fatten_count        : Byte;                 { !! Private !! }
    LockLayersCount     : Byte;                 { !! Private !! }
    PrivateReserve5     : WORD;                 { !! Private !! }
    BlankHook,                                  { !! Private !! }
    LayerInfo_extra     : Address;              { !! Private !! }
 end;
 Layer_InfoPtr = ^Layer_info;

const
    NEWLAYERINFO_CALLED = 1;

{
 * LAYERS_NOBACKFILL is the value needed to get no backfill hook
 * LAYERS_BACKFILL is the value needed to get the default backfill hook
 }
 LAYERS_NOBACKFILL      = 1;
 LAYERS_BACKFILL        = 0;

Function BeginUpdate(l : LayerPtr): Boolean;
    External;

Function BehindLayer(l : LayerPtr) : Boolean;
    External;

Function CreateBehindLayer(li : Layer_InfoPtr; bm : Address;
                           x0,y0,x1,y1 : Integer; flags : Integer;
                           bm2 : Address) : LayerPtr;
    External;

Function CreateUpfrontLayer(li : Layer_InfoPtr; bm : Address;
                            x0,y0,x1,y1 : Integer; flags : Integer;
                            bm2 : Address) : LayerPtr;
    External;

Function DeleteLayer(l : LayerPtr) : Boolean;
    External;

Procedure DisposeLayerInfo(li : Layer_InfoPtr);
    External;

Procedure EndUpdate(l : LayerPtr; flag : Boolean);
    External;

Function InstallClipRegion(l : LayerPtr; region : Address) : Address;
    External;   { both Address's are RegionPtr }

Procedure LockLayer(l : LayerPtr);
    External;

Procedure LockLayerInfo(li : Layer_InfoPtr);
    External;

Procedure LockLayers(li : Layer_InfoPtr);
    External;

Function MoveLayer(l : LayerPtr; dx, dy : Integer) : Boolean;
    External;

Function MoveLayerInFrontOf(layertomove, targetlayer : LayerPtr) : Boolean;
    External;

Function NewLayerInfo : Layer_InfoPtr;
    External;

Procedure ScrollLayer(l : LayerPtr; dx, dy : Integer);
    External;

Function SizeLayer(l : LayerPtr; dx, dy : Integer) : Boolean;
    External;

Procedure SwapBitsRastPortClipRect(rp : Address; cr : Address);
    External;   { rp is a RastPortPtr }
                { cr is a ClipRectPtr }

Procedure UnlockLayer(l : LayerPtr);
    External;

Procedure UnlockLayerInfo(li : Layer_InfoPtr);
    External;

Procedure UnlockLayers(li : Layer_InfoPtr);
    External;

Function UpfrontLayer(l : LayerPtr) : Boolean;
    External;

Function WhichLayer(li : Layer_InfoPtr; x, y : Integer) : LayerPtr;
    External;

{ --- functions in V39 or higher (Release 3) --- }

FUNCTION InstallLayerInfoHook(li : Layer_InfoPtr; H : HookPtr) : HookPtr;
    External;

PROCEDURE SortLayerCR(l : LayerPtr; dx, dy : Integer);
    External;

PROCEDURE DoHookClipRects(H : HookPtr; RP : RastPortPtr; Rect : RectanglePtr);
    External;

{ --- functions added that were missing -------- }

FUNCTION MoveSizeLayer(layer : LayerPtr; dx, dy, dw, dh : Integer): Boolean;
EXTERNAL;

FUNCTION CreateUpfrontHookLayer(li : Layer_InfoPtr; bm : BitMapPtr;
                                x0, y0, x1, y1, flags: Integer;
                                hoook : HookPtr; bm2 : BitMapPtr): LayerPtr;
EXTERNAL;

FUNCTION CreateBehindHookLayer(li : Layer_InfoPtr; bm : BitMapPtr;
                                x0, y0, x1, y1, flags: Integer;
                                hoook : HookPtr; bm2 : BitMapPtr): LayerPtr;
EXTERNAL;

FUNCTION InstallLayerHook(lay : LayerPtr; hoook : HookPtr): HookPtr;
EXTERNAL;



