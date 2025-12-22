/* $VER: layers.h 39.4 (14.4.1992) */
OPT NATIVE, POINTER
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/lists', 'target/exec/semaphores'
MODULE 'target/utility/hooks' /*, 'target/graphics/clip'*/
{MODULE 'graphics/layers'}

NATIVE {LAYERSIMPLE}		CONST LAYERSIMPLE		= 1
NATIVE {LAYERSMART}		CONST LAYERSMART		= 2
NATIVE {LAYERSUPER}		CONST LAYERSUPER		= 4
NATIVE {LAYERUPDATING}		CONST LAYERUPDATING		= $10
NATIVE {LAYERBACKDROP}		CONST LAYERBACKDROP		= $40
NATIVE {LAYERREFRESH}		CONST LAYERREFRESH		= $80
NATIVE {LAYERIREFRESH}		CONST LAYERIREFRESH		= $200
NATIVE {LAYERIREFRESH2}		CONST LAYERIREFRESH2		= $400
NATIVE {LAYER_CLIPRECTS_LOST}	CONST LAYER_CLIPRECTS_LOST	= $100	/* during BeginUpdate */
					/* or during layerop */
					/* this happens if out of memory */

->"OBJECT layer_info" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

NATIVE {NEWLAYERINFO_CALLED} CONST NEWLAYERINFO_CALLED = 1

/*
 * LAYERS_NOBACKFILL is the value needed to get no backfill hook
 * LAYERS_BACKFILL is the value needed to get the default backfill hook
 */
NATIVE {LAYERS_NOBACKFILL}	CONST LAYERS_NOBACKFILL	= 1!!VALUE!!PTR TO hook
NATIVE {LAYERS_BACKFILL}		CONST LAYERS_BACKFILL		= 0!!VALUE!!PTR TO hook
