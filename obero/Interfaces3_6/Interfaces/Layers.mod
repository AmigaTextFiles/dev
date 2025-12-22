(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Layers.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Layers;

IMPORT
  e * := Exec,
  g * := Graphics,
  u * := Utility;

TYPE
  LONGBOOL * = e.LONGBOOL;

CONST
  layersName * = "layers.library";
  LTRUE * = e.LTRUE;
  LFALSE * = e.LFALSE;

VAR
  base * : e.LibraryPtr;

PROCEDURE InitLayers        *{base,- 30}(li{8}         : g.LayerInfoPtr);
PROCEDURE CreateUpfrontLayer*{base,- 36}(li{8}         : g.LayerInfoPtr;
                                         bm{9}         : g.BitMapPtr;
                                         x0{0}         : LONGINT;
                                         y0{1}         : LONGINT;
                                         x1{2}         : LONGINT;
                                         y1{3}         : LONGINT;
                                         flags{4}      : SET;
                                         bm2{10}       : g.BitMapPtr): g.LayerPtr;
PROCEDURE CreateBehindLayer *{base,- 42}(li{8}         : g.LayerInfoPtr;
                                         bm{9}         : g.BitMapPtr;
                                         x0{0}         : LONGINT;
                                         y0{1}         : LONGINT;
                                         x1{2}         : LONGINT;
                                         y1{3}         : LONGINT;
                                         flags{4}      : SET;
                                         bm2{10}       : g.BitMapPtr): g.LayerPtr;
PROCEDURE UpfrontLayer      *{base,- 48}(layer{9}      : g.LayerPtr): BOOLEAN;
PROCEDURE BehindLayer       *{base,- 54}(layer{9}      : g.LayerPtr): BOOLEAN;
PROCEDURE MoveLayer         *{base,- 60}(layer{9}      : g.LayerPtr;
                                         dx{0}         : LONGINT;
                                         dy{1}         : LONGINT): BOOLEAN;
PROCEDURE SizeLayer         *{base,- 66}(layer{9}      : g.LayerPtr;
                                         dx{0}         : LONGINT;
                                         dy{1}         : LONGINT): BOOLEAN;
PROCEDURE ScrollLayer       *{base,- 72}(layer{9}      : g.LayerPtr;
                                         dx{0}         : LONGINT;
                                         dy{1}         : LONGINT);
PROCEDURE BeginUpdate       *{base,- 78}(l{8}          : g.LayerPtr): BOOLEAN;
PROCEDURE EndUpdate         *{base,- 84}(layer{8}      : g.LayerPtr;
                                         flag{0}       : LONGBOOL);
PROCEDURE DeleteLayer       *{base,- 90}(layer{9}      : g.LayerPtr): BOOLEAN;
PROCEDURE LockLayer         *{base,- 96}(layer{9}      : g.LayerPtr);
PROCEDURE UnlockLayer       *{base,-102}(layer{8}      : g.LayerPtr);
PROCEDURE LockLayers        *{base,-108}(li{8}         : g.LayerInfoPtr);
PROCEDURE UnlockLayers      *{base,-114}(li{8}         : g.LayerInfoPtr);
PROCEDURE LockLayerInfo     *{base,-120}(li{8}         : g.LayerInfoPtr);
PROCEDURE SwapBitsRastPortClipRect*{base,-126}(rp{8}   : g.RastPortPtr;
                                         VAR cr{9}     : g.ClipRect);
PROCEDURE WhichLayer        *{base,-132}(li{8}         : g.LayerInfoPtr;
                                         x{0}          : LONGINT;
                                         y{1}          : LONGINT): g.LayerPtr;
PROCEDURE UnlockLayerInfo   *{base,-138}(VAR li{8}     : g.LayerInfo);
PROCEDURE NewLayerInfo      *{base,-144}(): g.LayerInfoPtr;
PROCEDURE DisposeLayerInfo  *{base,-150}(li{8}         : g.LayerInfoPtr);
PROCEDURE FattenLayerInfo   *{base,-156}(li{8}         : g.LayerInfoPtr);
PROCEDURE ThinLayerInfo     *{base,-162}(li{8}         : g.LayerInfoPtr);
PROCEDURE MoveLayerInFrontOf*{base,-168}(layertomove{8}: g.LayerPtr;
                                         otherlayer{9} : g.LayerPtr): BOOLEAN;
PROCEDURE InstallClipRegion *{base,-174}(layer{8}      : g.LayerPtr;
                                         region{9}     : g.RegionPtr): g.RegionPtr;
(* ---   functions in V36 or higher  (distributed as Release 2.0)   --- *)
(* --- REMEMBER: You are to check the version BEFORE you use this ! --- *)
PROCEDURE MoveSizeLayer     *{base,-180}(layer{8}      : g.LayerPtr;
                                         dx{0}         : LONGINT;
                                         dy{1}         : LONGINT;
                                         dw{2}         : LONGINT;
                                         dh{3}         : LONGINT): BOOLEAN;
PROCEDURE CreateUpfrontHookLayer*{base,-186}(li{8}     : g.LayerInfoPtr;
                                         bm{9}         : g.BitMapPtr;
                                         x0{0}         : LONGINT;
                                         y0{1}         : LONGINT;
                                         x1{2}         : LONGINT;
                                         y1{3}         : LONGINT;
                                         flags{4}      : SET;
                                         hook{11}      : u.HookPtr;
                                         bm2{10}       : g.BitMapPtr): g.LayerPtr;
PROCEDURE CreateBehindHookLayer*{base,-192}(li{8}      : g.LayerInfoPtr;
                                         bm{9}         : g.BitMapPtr;
                                         x0{0}         : LONGINT;
                                         y0{1}         : LONGINT;
                                         x1{2}         : LONGINT;
                                         y1{3}         : LONGINT;
                                         flags{4}      : SET;
                                         hook{11}      : u.HookPtr;
                                         bm2{10}       : g.BitMapPtr): g.LayerPtr;
PROCEDURE InstallLayerHook  *{base,-198}(layer{8}      : g.LayerPtr;
                                         hook{9}       : u.HookPtr): u.HookPtr;

(*--- functions in V39 or higher (Release 3) ---*)

PROCEDURE InstallLayerInfoHook*{base,-0CCH}(li{8}      : g.LayerInfoPtr;
                                            hook{9}    : u.HookPtr): u.HookPtr;
PROCEDURE SortLayerCR       *{base,-0D2H}(layer{8}     : g.LayerPtr;
                                          dx{0}        : LONGINT;
                                          dy{1}        : LONGINT);
PROCEDURE DoHookClipRects   *{base,-0D8H}(hook{8}      : u.HookPtr;
                                          rport{9}     : g.RastPortPtr;
                                          rect{10}     : g.Rectangle);


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
 base := e.OpenLibrary(layersName,33);
 IF base=NIL THEN HALT(20) END;

CLOSE

 IF base#NIL THEN e.CloseLibrary(base) END;

END Layers.

