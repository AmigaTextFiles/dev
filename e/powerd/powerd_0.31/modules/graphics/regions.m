MODULE	'graphics/gfx'

OBJECT RegionRectangle
	Next:PTR TO RegionRectangle,
	Prev:PTR TO RegionRectangle,
	bounds:Rectangle

OBJECT Region
	bounds:Rectangle,
	RegionRectangle:PTR TO RegionRectangle

