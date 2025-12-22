OPT MODULE

MODULE	'wb','icon','workbench/workbench'

EXPORT OBJECT chunkyimage
	width:INT
	height:INT
	numcolors:INT
	flags:INT
	palette:LONG
	chunkydata:LONG
ENDOBJECT

EXPORT CONST CIF_COLOR_0_TRANSP=1

EXPORT OBJECT newdiskobject
	ndo_stdobject:PTR TO diskobject
	ndo_normalimage:PTR TO chunkyimage
	ndo_selectedimage:PTR TO chunkyimage
ENDOBJECT
