/* $Id: layers.h,v 1.19 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE, POINTER
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/lists', 'target/exec/semaphores', 'target/graphics/gfx'
MODULE 'target/utility/hooks', 'target/utility/tagitem'
{#include <graphics/layers.h>}
NATIVE {GRAPHICS_LAYERS_H} CONST

/*
 * layer status flags. These really belong to
 * graphics/clip.h but are here for traditional reason
 * (and to confuse you).
 */

NATIVE {LAYERSIMPLE}           CONST LAYERSIMPLE           = 1
NATIVE {LAYERSMART}            CONST LAYERSMART            = 2
NATIVE {LAYERSUPER}            CONST LAYERSUPER            = 4
NATIVE {LAYERUPDATING}         CONST LAYERUPDATING         = $10
NATIVE {LAYERBACKDROP}         CONST LAYERBACKDROP         = $40
NATIVE {LAYERREFRESH}          CONST LAYERREFRESH          = $80
NATIVE {LAYER_CLIPRECTS_LOST}  CONST LAYER_CLIPRECTS_LOST  = $100   /* during BeginUpdate */
                                      /* or during layerop */
                                      /* this happens if out of memory */
NATIVE {LAYERIREFRESH}         CONST LAYERIREFRESH         = $200
NATIVE {LAYERIREFRESH2}        CONST LAYERIREFRESH2        = $400

NATIVE {LAYERSAVEBACK}         CONST LAYERSAVEBACK         = $800   /* New for V44: Set if clips
                                       * are saved back */
NATIVE {LAYERHIDDEN}           CONST LAYERHIDDEN           = $1000  /* New for V45: Layer is invisible */
NATIVE {LAYERSTAYTOP}          CONST LAYERSTAYTOP          = $2000  /* New for V45: Layer can't be moved
                                       * behind other layers */
NATIVE {LAYERMOVECHANGESSHAPE} CONST LAYERMOVECHANGESSHAPE = $4000  /* New for V45: Report MoveLayer()
                                       * to shapechangehook */

/*
 * Thor says: Keep hands off this Layer_Info. There's really nothing in
 * here to play with. The only thing you possibly may be interested in
 * is the top_layer that points to the topmost layer of this layer_info,
 * and the Lock which locks this structure. Even that is quite private,
 * but everything else is really really private. Leave all this to
 * layers.library as some fields are likely to change their meaning
 * in the near future.
 */

->"OBJECT layer_info" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

NATIVE {NEWLAYERINFO_CALLED} CONST NEWLAYERINFO_CALLED = 1

/*
 * Special backfill hook values you may want to install here.
 *
 * LAYERS_NOBACKFILL is the value needed to get no backfill hook
 * LAYERS_BACKFILL is the value needed to get the default backfill hook
 */
NATIVE {LAYERS_NOBACKFILL}  CONST LAYERS_NOBACKFILL  = 1!!VALUE!!PTR TO hook
NATIVE {LAYERS_BACKFILL}    CONST LAYERS_BACKFILL    = 0!!VALUE!!PTR TO hook

/*
 * Special codes for ShowLayer():
 * Give this as target layer where
 * to move your layer to.
 */
NATIVE {LAYER_BACKMOST}     CONST LAYER_BACKMOST     = 0!!VALUE!!PTR TO layer
NATIVE {LAYER_FRONTMOST}    CONST LAYER_FRONTMOST    = 1!!VALUE!!PTR TO layer

/*
 * CreateBackFillHookA() attributes
 */
NATIVE {LAYERS_DUMMY}       CONST LAYERS_DUMMY       = (TAG_USER)
NATIVE {BFHA_APen}          CONST BFHA_APEN          = (LAYERS_DUMMY+0)  /* foreground color (def ~0) */
NATIVE {BFHA_BPen}          CONST BFHA_BPEN          = (LAYERS_DUMMY+1)  /* background color (def ~0) */
NATIVE {BFHA_DrMd}          CONST BFHA_DRMD          = (LAYERS_DUMMY+2)  /* drawmode (def JAM2) */
NATIVE {BFHA_PatSize}       CONST BFHA_PATSIZE       = (LAYERS_DUMMY+3)  /* pattern size, see SetAfPt() */
NATIVE {BFHA_Pattern}       CONST BFHA_PATTERN       = (LAYERS_DUMMY+4)  /* the pattern */
NATIVE {BFHA_BitMap}        CONST BFHA_BITMAP        = (LAYERS_DUMMY+5)  /* bitmap to use as backfill */
NATIVE {BFHA_Width}         CONST BFHA_WIDTH         = (LAYERS_DUMMY+6)  /* width of bm */
NATIVE {BFHA_Height}        CONST BFHA_HEIGHT        = (LAYERS_DUMMY+7)  /* height of bm */
NATIVE {BFHA_OffsetX}       CONST BFHA_OFFSETX       = (LAYERS_DUMMY+8)  /* x offset into the bm */
NATIVE {BFHA_OffsetY}       CONST BFHA_OFFSETY       = (LAYERS_DUMMY+9)  /* y offset into the bm */

/*
 * CreateLayerA() attributes
 */
NATIVE {LAYA_MinX}          CONST LAYA_MINX          = (LAYERS_DUMMY+30) /* upper left corner */
NATIVE {LAYA_MinY}          CONST LAYA_MINY          = (LAYERS_DUMMY+31) /* of layer */
NATIVE {LAYA_MaxX}          CONST LAYA_MAXX          = (LAYERS_DUMMY+32) /* lower right corner */
NATIVE {LAYA_MaxY}          CONST LAYA_MAXY          = (LAYERS_DUMMY+33) /* of layer */
NATIVE {LAYA_ShapeRegion}   CONST LAYA_SHAPEREGION   = (LAYERS_DUMMY+34) /* shape of this layer */
NATIVE {LAYA_ShapeHook}     CONST LAYA_SHAPEHOOK     = (LAYERS_DUMMY+35) /* hook to create layer shape */
NATIVE {LAYA_InFrontOf}     CONST LAYA_INFRONTOF     = (LAYERS_DUMMY+36) /* create the layer in front
                                              * of the given one */
NATIVE {LAYA_BitMap}        CONST LAYA_BITMAP        = (LAYERS_DUMMY+37) /* common bitmap used by
                                              * all layers */
NATIVE {LAYA_SuperBitMap}   CONST LAYA_SUPERBITMAP   = (LAYERS_DUMMY+38) /* the superbitmap, sets
                                              * LAYERSUPER */
NATIVE {LAYA_SimpleRefresh} CONST LAYA_SIMPLEREFRESH = (LAYERS_DUMMY+39) /* make it a simple refresh
                                              * layer */
NATIVE {LAYA_SmartRefresh}  CONST LAYA_SMARTREFRESH  = (LAYERS_DUMMY+40) /* smart refresh layer
                                              * (default TRUE) */
NATIVE {LAYA_Hidden}        CONST LAYA_HIDDEN        = (LAYERS_DUMMY+41) /* make it invisible */
NATIVE {LAYA_Backdrop}      CONST LAYA_BACKDROP      = (LAYERS_DUMMY+42) /* request backdrop layer */
NATIVE {LAYA_Flags}         CONST LAYA_FLAGS         = (LAYERS_DUMMY+43) /* layer flags */
NATIVE {LAYA_BackFillHook}  CONST LAYA_BACKFILLHOOK  = (LAYERS_DUMMY+44) /* backfill hook for this layer */
NATIVE {LAYA_Behind}        CONST LAYA_BEHIND        = (LAYERS_DUMMY+45) /* create behind layer
                                              * (default FALSE) */
NATIVE {LAYA_StayTop}       CONST LAYA_STAYTOP       = (LAYERS_DUMMY+46) /* create a window that stays
                                              * on top of all other layers */

/*
 * The message a backfill hook receives
 */
NATIVE {BackFillMessage} OBJECT backfillmessage
    {Layer}	layer	:PTR TO layer
    {Bounds}	bounds	:rectangle
    {OffsetX}	offsetx	:VALUE
    {OffsetY}	offsety	:VALUE
ENDOBJECT
