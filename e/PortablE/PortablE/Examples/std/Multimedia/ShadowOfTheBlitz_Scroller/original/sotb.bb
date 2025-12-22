; Shadow of the Blitz v0.1a
; done by aNa|0Gue
; analogue@glop.org
; http://www.glop.org
; mandarine style !
; http://www.mandarine.org
;
; all gfx are (c) psygnosis

; global inits
Global gWidth=320
Global gHeight=240
Global gDepth=8

Global iWidth=288
Global iHeight=200
Global iScroll=0

Global bmpCiel
Global bmpLune
Global bmpBarriere
Global bmpMontagne
Dim bmpHerbe(10)
Dim bmpNuage(10)

; beginning of program
Graphics gWidth,gHeight;,gDepth
AppTitle "Shadow of the Blitz"

; gfx inits
;ClsColor 0,255,0
Viewport 0,0,iWidth,iHeight

bmpLune=LoadImage("gfx/lune.bmp")
MaskImage bmpLune,255,0,255
bmpBarriere=LoadImage("gfx/barriere.bmp")
MaskImage bmpBarriere,255,0,255
bmpMontagne=LoadImage("gfx/montagnes.bmp")
MaskImage bmpMontagne,255,0,255

bmpHerbe(0)=LoadImage("gfx/herbe0.bmp")
bmpHerbe(1)=LoadImage("gfx/herbe1.bmp")
bmpHerbe(2)=LoadImage("gfx/herbe2.bmp")
bmpHerbe(3)=LoadImage("gfx/herbe3.bmp")
bmpHerbe(4)=LoadImage("gfx/herbe4.bmp")

bmpNuage(0)=LoadImage("gfx/nuages0.bmp")
bmpNuage(1)=LoadImage("gfx/nuages1.bmp")
bmpNuage(2)=LoadImage("gfx/nuages2.bmp")
bmpNuage(3)=LoadImage("gfx/nuages3.bmp")
bmpNuage(4)=LoadImage("gfx/nuages4.bmp")
For n=0 To 4
	MaskImage bmpNuage(n),255,0,255
Next

; create the sky
bmpCiel=CreateImage(iWidth,164)
SetBuffer ImageBuffer(bmpCiel)
Color 99,113,132
Rect 0,0,iWidth,76
DrawImage bmpLune,184,16
Color 115,113,132
Rect 0,76,iWidth,27
Color 132,113,132
Rect 0,103,iWidth,14
Color 148,113,132
Rect 0,117,iWidth,10
Color 165,113,132
Rect 0,127,iWidth,8
Color 181,113,132
Rect 0,135,iWidth,7
Color 198,113,132
Rect 0,142,iWidth,6
Color 214,113,132
Rect 0,148,iWidth,6
Color 231,113,132
Rect 0,154,iWidth,4
Color 247,113,132
Rect 0,158,iWidth,6
SetBuffer BackBuffer()

; main loop
While Not KeyHit(1)
	Cls
	DrawBlock bmpCiel,0,0
	DrawNuages()
	DrawSol()
	Viewport 0,0,iWidth,iHeight
	iScroll=iScroll+1
	Flip
Wend

; end of program
FreeMemory()
EndGraphics
End

Function DrawNuages()
	Viewport 0,0,iWidth,21
	TileImage bmpNuage(0),iScroll,0
	Viewport 0,22,iWidth,40
	TileImage bmpNuage(1),iScroll/2,22
	Viewport 0,63,iWidth,19
	TileImage bmpNuage(2),iScroll/3,63
	Viewport 0,82,iWidth,9
	TileImage bmpNuage(3),iScroll/4,82
	Viewport 0,91,iWidth,6
	TileImage bmpNuage(4),iScroll/5,91
End Function

Function DrawSol()
	Viewport 0,97,iWidth,73
	TileImage bmpMontagne,iScroll/2,97
	Viewport 0,170,iWidth,2
	TileBlock bmpHerbe(0),iScroll,170
	Viewport 0,172,iWidth,3
	TileBlock bmpHerbe(1),iScroll*2,172
	Viewport 0,175,iWidth,7
	TileBlock bmpHerbe(2),iScroll*3,175
	Viewport 0,182,iWidth,7
	TileBlock bmpHerbe(3),iScroll*4,182
	Viewport 0,189,iWidth,11
	TileBlock bmpHerbe(4),iScroll*5,189
	Viewport 0,179,iWidth,21
	TileImage bmpBarriere,iScroll*6,179
End Function

Function FreeMemory()
	FreeImage bmpLune
	FreeImage bmpBarriere
	FreeImage bmpMontagne
	FreeImage bmpCiel
	For n=0 To 4
		FreeImage bmpHerbe(n)
		FreeImage bmpNuage(n)
	Next
End Function