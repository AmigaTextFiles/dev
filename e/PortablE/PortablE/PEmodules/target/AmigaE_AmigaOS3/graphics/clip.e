/* $VER: clip.h 39.0 (2.12.1991) */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/exec/semaphores', 'target/utility/hooks'
/*MODULE 'target/graphics/layers', 'target/graphics/regions'*/
{MODULE 'graphics/clip'}

->"OBJECT layer" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

->"OBJECT cliprect" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

/* internal cliprect flags */
NATIVE {CR_NEEDS_NO_CONCEALED_RASTERS}  CONST CR_NEEDS_NO_CONCEALED_RASTERS  = 1
NATIVE {CR_NEEDS_NO_LAYERBLIT_DAMAGE}   CONST CR_NEEDS_NO_LAYERBLIT_DAMAGE   = 2

/* defines for code values for getcode */
NATIVE {ISLESSX} CONST ISLESSX = 1
NATIVE {ISLESSY} CONST ISLESSY = 2
NATIVE {ISGRTRX} CONST ISGRTRX = 4
NATIVE {ISGRTRY} CONST ISGRTRY = 8
