OPT NATIVE
MODULE 'target/exec/types'

TYPE PLANEPTR IS ARRAY


NATIVE {rectangle} OBJECT rectangle
    {minx}	minx	:INT
	{miny}	miny	:INT
    {maxx}	maxx	:INT
	{maxy}	maxy	:INT
ENDOBJECT

NATIVE {tpoint} OBJECT tpoint
    {x}	x	:INT
	{y}	y	:INT
ENDOBJECT /*Point*/

NATIVE {bitmap} OBJECT bitmap
    {bytesperrow}	bytesperrow	:UINT
    {rows}	rows	:UINT
    {flags}	flags	:UBYTE
    {depth}	depth	:UBYTE
    {pad}	pad	:UINT
    {planes}	planes[8]	:ARRAY OF PLANEPTR
ENDOBJECT


NATIVE {regionrectangle} OBJECT regionrectangle
    {next}	next	:PTR TO regionrectangle
	{prev}	prev	:PTR TO regionrectangle
    {bounds}	bounds	:rectangle
ENDOBJECT

NATIVE {region} OBJECT region
    {bounds}	bounds	:rectangle
    {regionrectangle}	regionrectangle	:PTR TO regionrectangle
ENDOBJECT
