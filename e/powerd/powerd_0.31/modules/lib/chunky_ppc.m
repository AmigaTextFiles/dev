OPT	LINK='chunky_ppc.lib',CPU=603

EPROC Conv24To8(d0:LONG)(L)
EPROC Conv24ToGrey(a0:PTR TO chunky,a1:PTR TO chunky32)
//EPROC CopyChunky(a0:PTR TO chunky,d0,d1,a1:PTR TO chunky,d2,d3,d4,d5)
//EPROC CopyChunkyMask(a0:PTR TO chunky,d0,d1,a1:PTR TO chunky,d2,d3,d4,d5,d6)
//EPROC CopyChunkyBright(a0:PTR TO chunky,d0,d1,a1:PTR TO chunky,d2,d3,d4,d5)
EPROC FillChunky(a0:PTR TO chunky,d0:L)
EPROC FillChunky32(a0:PTR TO chunky,d0:L)
EPROC FillChunky32Z(a0:PTR TO chunky32,d0:L,fp0:F)
EPROC GetPixel(a0:PTR TO chunky,d0:L,d1:L)(L)
EPROC GetPixel32(a0:PTR TO chunky32,d0:L,d1:L)(L)
EPROC GetPixel32Z(a0:PTR TO chunky32,d0:L,d1:L)(L,F)
EPROC PutPixel(a0:PTR TO chunky,d0:L,d1:L,d2:L)(L)
EPROC PutPixel32(a0:PTR TO chunky32,d0:L,d1:L,d2:L)
EPROC PutPixel32Z(a0:PTR TO chunky32,d0:L,d1:L,d2:L,fp0:F)
EPROC PutPixelFast(a0:PTR TO chunky,d0:L,d1:L,d2:L)
//EPROC HLine(a0:PTR TO chunky,d0:L,d1:L,d2:L,d3:L)
//EPROC HLineFast(a0:PTR TO chunky,d0:L,d1:L,d2:L,d3:L)
EPROC Pack32(d0:L,d1:L,d2:L,d3:L)(L)
EPROC UnPack32(d0:UL)(L,L,L,L)

OBJECT chunky
	wi/he:L,
	pixel:PTR TO UB

OBJECT chunky32
	wi/he:L,
	pixel:PTR TO UL,
	zbuff:PTR TO F
