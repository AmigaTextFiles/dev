OPT	MODULE
OPT	PREPROCESS

OBJECT	p2cstruct
	bmap:PTR TO bitmap
	startx:INT,starty:INT
	width:INT,height:INT
	chunkybuffer:PTR TO CHAR
ENDOBJECT

MODULE	'*planar2chunky'
MODULE	'graphics/gfx'

EXPORT	PROC	__planar2chunky(bm:PTR TO bitmap,chunky,szer,wys)
DEF	p2c:p2cstruct

	p2c.bmap:=bm
	p2c.chunkybuffer:=chunky
	p2c.startx:=0
	p2c.starty:=0
	p2c.width:=szer
	p2c.height:=wys

	planarToChunkyAsm(p2c)
ENDPROC

