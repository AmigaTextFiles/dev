OPT	LINK='chunky.lib'

RPROC Conv24To8(d0:LONG)(L)
RPROC Conv24ToGrey(a0:PTR TO chunky,a1:PTR TO chunky32)
RPROC CopyChunky(a0:PTR TO chunky,d0,d1,a1:PTR TO chunky,d2,d3,d4,d5)
RPROC CopyChunkyMask(a0:PTR TO chunky,d0,d1,a1:PTR TO chunky,d2,d3,d4,d5,d6)
RPROC CopyChunkyBright(a0:PTR TO chunky,d0,d1,a1:PTR TO chunky,d2,d3,d4,d5)
RPROC FillChunky(a0:PTR TO chunky,d0:L)
RPROC FillChunky32Z(a0:PTR TO chunky32,d0:L,fp0:F)
RPROC GetPixel(a0:PTR TO chunky,d0:L,d1:L)(L)
RPROC GetPixel32(a0:PTR TO chunky32,d0:L,d1:L)(L)
RPROC GetPixel32Smooth(a0:PTR TO chunky32,fp0:F,fp1:F)(L)
RPROC GetPixel32Z(a0:PTR TO chunky32,d0:L,d1:L)(L,F)
RPROC PutPixel(a0:PTR TO chunky,d0:L,d1:L,d2:L)(L)
RPROC PutPixel32(a0:PTR TO chunky32,d0:L,d1:L,d2:L)
RPROC PutPixel32Z(a0:PTR TO chunky32,d0:L,d1:L,d2:L,fp0:F)
RPROC PutPixelFast(a0:PTR TO chunky,d0:L,d1:L,d2:L)
RPROC HLine(a0:PTR TO chunky,d0:L,d1:L,d2:L,d3:L)
RPROC HLineFast(a0:PTR TO chunky,d0:L,d1:L,d2:L,d3:L)
EPROC DrawTriangle(dst:PTR TO chunky,xy:PTR TO F,colour)
RPROC Triangle1(a0:PTR TO chunky,d0,d1,d2,d3,d4,d5)
RPROC Pack32(d0:L,d1:L,d2:L,d3:L)(L)
RPROC UnPack32(d0:UL)(L,L,L,L)
EPROC CreateChunky(w,h)(PTR)
EPROC CreateChunky32(w,h)(PTR)
EPROC CreateChunky32Z(w,h)(PTR)
EPROC DeleteChunky(ch)

OBJECT chunky
	wi/he:L,
	pixel:PTR TO UB

OBJECT chunky32
	wi/he:L,
	pixel:PTR TO UL,
	zbuff:PTR TO F
