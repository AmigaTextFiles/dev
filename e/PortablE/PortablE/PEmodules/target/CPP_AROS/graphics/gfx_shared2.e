OPT NATIVE
MODULE 'target/exec/types'

TYPE PLANEPTR IS NATIVE {PLANEPTR} ARRAY


NATIVE {tPoint} OBJECT tpoint
    {x}	x	:INT
    {y}	y	:INT
ENDOBJECT /*Point*/
NATIVE {Point} OBJECT

NATIVE {BitMap} OBJECT bitmap
    {BytesPerRow}	bytesperrow	:UINT
    {Rows}	rows	:UINT
    {Flags}	flags	:UBYTE
    {Depth}	depth	:UBYTE
    {pad}	pad	:UINT
    {Planes}	planes[8]	:ARRAY OF PLANEPTR
ENDOBJECT

NATIVE {Rectangle} OBJECT rectangle
    {MinX}	minx	:INT
    {MinY}	miny	:INT
    {MaxX}	maxx	:INT
    {MaxY}	maxy	:INT
ENDOBJECT


NATIVE {Region} OBJECT region
    {bounds}	bounds	:rectangle
    {RegionRectangle}	regionrectangle	:PTR TO regionrectangle
ENDOBJECT

NATIVE {RegionRectangle} OBJECT regionrectangle
    {Next}	next	:PTR TO regionrectangle
    {Prev}	prev	:PTR TO regionrectangle
    {bounds}	bounds	:rectangle
ENDOBJECT
