    IFND    EGS_EGSLAYERS_I
EGS_EGSLAYERS_I                SET     1
*\
*  $
*  $ FILE     : E_G_S:Wartung&Pflege/asm/egslayers.i
*  $ VERSION  : 1
*  $ REVISION : 5
*  $ DATE     : 04-Feb-93 10:13
*  $
*  $ Author   : mvk
*  $
*
*
* (c) Copyright 1990/93 VIONA Development
*     All Rights Reserved
*
*\
    IFND    EXEC_TYPES_I
    INCLUDE "exec/types.i"
    ENDC
    IFND    EXEC_PORTS_I
    INCLUDE "exec/ports.i"
    ENDC
    IFND    EXEC_LISTS_I
    INCLUDE "exec/lists.i"
    ENDC
    IFND    EXEC_SEMAPHORES_I
    INCLUDE "exec/semaphores.i"
    ENDC
    IFND    EGS_EGS_I
    INCLUDE "egs.i"
    ENDC
    IFND    EGS_EGSBLIT_I
    INCLUDE "egsblit.i"
    ENDC

*
*  This library manages overlapping, independent, rectangular screen areas
*  (layers).  They form the base of each window system.
*
*  Layers can be moved, sized and put from front to back or vice versa.  The
*  library offers adequate functions.  Areas to be clipped, hidden and
*  restored are held in lists of "ClipRects".  That structure is defined in
*  EGSBlit so there are no complications for clipping.
*
*  Currently four kinds of Layers are supported:
*
*  - no care refresh : Layer parts hidden by other layers are never refreshed.
*                      No list of rectangles to be refreshed is kept.
*                      This layer kind is recommended if the layer's contents
*                      are automatically refreshed in constant intervals,
*                      e.g. for animation.
*
*  - simple refresh  : The library keeps a list which contains the parts that
*                      need refreshing.  If this list changes, i.e. if refresh
*                      is needed, an appropriate message is sent to a given
*                      port.
*                      Then the program should refresh its display.  For this,
*                      "BeginRefresh" and "EndRefresh" claim the part to be
*                      refreshed as the current drawing area so that only the
*                      damaged screen parts are drawn into during refresh.
*                      This layer kind is the best compromise between memory
*                      usage and execution speed.  It should be used whenever
*                      possible since layers saving their hidden parts eat
*                      a lot of memory in high resolution graphics.
*
*  - super bitmap    : These layers own a Bitmap that can greatly exceed the
*                      visible portion.  The layer forms a window over this
*                      BitMap that you may move as you like.  Damaged screen
*                      areas are refreshed by restoring them with data from
*                      this special background BitMap.  This layer's disad-
*                      vantage is the gigantic memory requirement.  You should
*                      use them only if really necessary, e.g. pixel oriented
*                      graphics.
*
*  - smart refresh   : For all obscured areas, these layers create restoring
*                      areas which are managed dynamically and are later
*                      freed automatically.
*                      So you need not pay attention to refresh as drawing
*                      operations are performed even in these restoring areas.
*                      But a refresh message is sent as soon as the layer is
*                      sized.
*                      The disadvantage of this layer is its gigantic memory
*                      usage especially for big bit depths.  You should
*                      use this type in such screens scarcely.
*

*
*  LayerFlags, LayerFlagSet
*
*  - SIMPLE_REFRESH  : Set if "simple refresh layer".
*  - SUPER_BITMAP    : Set if "super bitmap layer".
*  - SMART_REFRESH   : Set if "smart refresh layer".
*
*  - IN_REFRESH      : Layer is currently being refreshed.
*  - NEW_TO_REFRESH...
*  - TO_REFRESH      : Layer needs a refresh.
*  - NO_BACKFILL     : If an obscured layer part is made visible, this part
*                      is filled with the layer's background colour.  If this
*                      flag is set then no fill occurs.  This saves time if
*                      the part will be overwritten completely during refresh
*                      anyway (e.g. window border).
*  - CLIPS_INVALID   : The layer was modified after this flag had been cleared
*                      the last time.  You can use this flag to put an addi-
*                      tional Clip region over the layer.
*  - BACKDROP        : The layer lies behind all non-backdrop-layers.
*

* Corresponding LayerFlagSet has 32 bits !

EL_SIMPLE_REFRESH            EQU     $00000001
EL_SUPER_BITMAP              EQU     $00000002
EL_IN_REFRESH                EQU     $00000004
EL_NEW_TO_REFRESH            EQU     $00000008
EL_TO_REFRESH                EQU     $00000010
EL_NO_BACKFILL               EQU     $00000020
EL_OBSOLETE1                 EQU     $00000040
EL_BACKDROP                  EQU     $00000080
EL_SMART_REFRESH             EQU     $00000100

*
*  Layer, LayerPtr
*
*  Structure for management of a layer.
*
*  !!! READ-ONLY !!!
*
*  .Front,
*  .Back      : Chaining.
*  .LayerInfo : Pointer to assigned "AreaInfo" structure.
*  .MaxBorder : Maximum layer size in screen coordinates.
*  .Border    : Maximum visible area of the layer on the screen.
*  .FrontClip : Clip area for drawing onto the visible area.  The area is the
*               union of all specified ClipRects.
*  .BackClip  : Clip area for drawing into the background BitMap (only for
*               super bitmap).  The border is specified in screen coordinates
*               and might be adjusted when necessary.
*  .FrontMap  : Front Bitmap.
*  .BackMap   : Background BitMap, NIL if missing.
*  .Damage    : List of damaged screen areas.
*  .Flags     : Flags (what else ?)
*  .Lock      : Layer's lock.  A layer must be locked before using elements
*               from it since operations with other layers might change them.
*  .Window    : Slave pointer pointing to the corresponding window.
*  .ExtData   : PRIVATE !
*  .BackColor : Background colour of the layer.
*  .DispX,
*  .DispY     : Coordinates of the top left point in layer coordinates.
*  .Key       : Current refresh key (refer to "BeginUpdate").
*  .ClipKey   : actuall version of the layer, is incremented by one by any
*               layer operation that modifies the cliprects.
*  .BackHook  : Current hook for layer back fill operations.
*
*                                Layer, .MmaxBorder
*           DispX               /
*          /     \             /
*         /+-------------------------+
*   DispY| |                         |
*         \|     #############---------- visible area, .Border
*          |     #############       |
*          |     #############       |
*          |     #############       |
*          |     #############       |
*          |     #############       |
*          |     #############       |
*          |     #############       |
*          |     #############       |
*          |                         |
*          |                         |
*          +-------------------------+
*
*  Layers should always be created and changed with the library functions as
*  support for disk-based BitMaps will be added and the structure will be
*  extended certainly.
*
 STRUCTURE  ELSmartClip,0

* PRIVATE
    STRUCT  elsc_Cliprect,ebcr_SIZEOF
    APTR    elsc_EMapp
    WORD    elsc_DispX
    WORD    elsc_DispY
    APTR    elsc_EMap
    LABEL   elsc_SIZEOF

*
*  EL_BackHook
*
*  Descriptive structure for layer and layer info back fill function.
*  Calling conventions are:
*
*   A0 map      : E_EBitMapPtr  : map to fill in
*   A1 UserData : APTR          : own user data from hook
*   D0 x        : WORD          : left edge of rectangle
*   D1 y        : WORD          : top edge of rectangle
*   D2 w        : WORD          : width of rectangle
*   D3 h        : WORD          : height of rectangle
*   D4 ox       : WORD          : left offset of rectangle in full rectangle
*   D5 oy       : WORD          : top offset of rectangle in full rectangle
*
*  Use this structure only in conjunction with EL_InstallLHook and
*  EL_InstallLIHook, never change the field in a layer or layerinfo structure
*  directly.
*
*

 STRUCTURE  ELBackHook,0
    APTR    elbh_Call          *      in C   VOID   (*Call)();
    APTR    elbh_UserData
    LABEL   elbh_SIZEOF


 STRUCTURE  ELLayer,0
    APTR    ella_front
    APTR    ella_back
    APTR    ella_LayerInfo
    STRUCT  ella_MaxBorder,ebcr_SIZEOF
    STRUCT  ella_Border,ebcr_SIZEOF
    APTR    ella_FrontClip
    APTR    ella_BackClip
    APTR    ella_FrontMap
    APTR    ella_BackMap
    APTR    ella_Damage
    APTR    ella_FrontSave
    APTR    ella_BackSave
    ULONG   ella_Flags
    STRUCT  ella_Lock,SS_SIZE
    WORD    ella_Pad_1
    APTR    ella_Window
    APTR    ella_ExtData
    LONG    ella_BackColor
    WORD    ella_DispX
    WORD    ella_DispY
    LONG    ella_Key
    LONG    ella_ClipKey
    APTR    ella_BackHook
    LABEL   ella_SIZEOF

*
*  LayerInfo, LayerInfoPtr
*
*  Interface structure between a BitMap and the layers that use it.  This
*  structure must be created if layers are to be used.
*
*  !!! READ-ONLY !!!
*
*  .First        : Front layer on the screen.
*  .Last         : Layer on the screen behind all other layers.
*  .AllLocks     : Super-lock for all locks in the liste; if several layers
*                  of a screen are to be locked, this semaphore must be locked
*                  first (refer to "LockLayers" and "LockLayerInfo").
*  .Map          : BitMap of that screen which the layers are belonging to.
*  .Port         : Message port that refresh messages are sent to.
*  .BackColor    : Background colour.
*  .BackPattern  : Background pattern; if specified then the screen's back
*                  ground is filled with the pattern, otherwise the background
*                  colour is used.  The pattern can have any size, the size
*                  depends on its BitMap.
*  .Border       : Border coordinates of the BitMap; a kind of ClipRect with
*                  highest priority.
*
*  LayerInfo structures should always be created and changed with the library
*  functions since it is possible that they are extended in future.
*
 STRUCTURE  ELLayerInfo,0
    APTR    elli_First
    APTR    elli_Last
    STRUCT  elli_Lock,SS_SIZE
    WORD    elli_Pad_1
    STRUCT  elli_AllLocks,LH_SIZE
    WORD    elli_Pad_2
    APTR    elli_Map
    APTR    elli_Port
    LONG    elli_BackColor
    APTR    elli_BackPattern
    STRUCT  elli_Border,ebcr_SIZEOF
    APTR    elli_BackHook
    LABEL   elli_SIZEOF

*
*  LayerMsg, LayerMsgPtr
*
*  Message that is sent when a layer wants refreshing.
*
*  .Layer   : Layer to be refreshed.
*  .Key     : Current refresh key of the layer (refer to "BeginUpdate").
*
*  This message must be replied after having received it.
*
 STRUCTURE  ELLayerMsg,0
    STRUCT  ellm_Msg,MN_SIZE
    APTR    ellm_Layer
    LONG    ellm_Key
    LABEL   ellm_SIZEOF

    ENDC    * EGS_EGSLAYERS_I
