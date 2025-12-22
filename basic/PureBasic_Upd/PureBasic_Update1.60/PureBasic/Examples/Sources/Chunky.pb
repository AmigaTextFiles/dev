
InitChunky(0)
InitBitMap(0)
InitScreen(0)

#Width  = 320
#Height = 200

*MyChunky = AllocateChunkyBuffer(0, #Width, #Height)
AllocateLinearBitMap(0, #Width, 256, 8)

DrawingOutput(BitMapRastport())

Cls(2) ; Black border :)

ChunkyCls(3)

;For x=0 To 10 Step 2
;  ChunkyPlotFast(x, x, 6)
;Next

for x=0 to 320 step 2
  for y=0 to 180 step 2
    ChunkyPlot(x,y,6)
  next
next

Dim Shape1.b(15*15)

Shape1(0)  = 3
Shape1(9) = 3
Shape1(99) = 3
Shape1(90)  = 3


If OpenScreen(0, 320, #Height, 8, 0)

  ShowBitMap(0, ScreenID(), 0, 0)

  Delay(40)

 ; Repeat
 ;   a+1
 ;   ChunkyBlock(9, 9, @Shape1(), a, 50)
    ChunkyToPlanar(*MyChunky, BitMapID(), 200)  ; Convert the chunky buffer to planar ! You can specify the height too.
 ; Until a = 25

EndIf

MouseWait()
End


