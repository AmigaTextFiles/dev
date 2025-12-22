#ifndef	GRAPHICS_REGIONS_H
#define	GRAPHICS_REGIONS_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef GRAPHICS_GFX_H
MODULE  'graphics/gfx'
#endif
OBJECT RegionRectangle

      Next:PTR TO RegionRectangle
Prev:PTR TO RegionRectangle
      bounds:Rectangle
ENDOBJECT

OBJECT Region

      bounds:Rectangle
      RegionRectangle:PTR TO RegionRectangle
ENDOBJECT

#endif	
