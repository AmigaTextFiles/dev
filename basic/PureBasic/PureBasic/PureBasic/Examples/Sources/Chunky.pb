
; ***********************************
;
;  Chunky example file for PureBasic
;
;    © 2001 - Fantaisie Software -
;
; ***********************************


#Width  = 320
#Height = 256

 Dim tags.l(3)

 Test.l=InitChunky(9,1,1)

 If InitBitMap(0) AND InitPalette(0) AND InitScreen(0) AND Test.l > 0
 
   PrintNumberN(Test.l)

   bm0.l=AllocateLinearBitMap(0,#Width,#Height,8)
   pal0.l=LoadPalette(0,"PureBasic:Examples/WaponezII/Back_1")

   cb0.l=AllocateChunkyBuffer(0,#Width,#Height)
   cb1.l=AllocateChunkyBuffer(1,#Width,#Height)

   csb0.l=CreateChunkySpriteBuffer(0,4000)  
   csb1.l=CreateChunkySpriteBuffer(1,4000)  

   lcs.l=LoadChunkySprites(0,6,"PureBasic:Examples/Data/ChunkyDemo.csp") 
   Print("ChunkySprites Loaded..") : PrintNumberN(lcs.l) 

   If bm0 AND pal0 AND cb0 AND cb1 AND csb0 AND csb1 AND lcs

     tags(0)=#SA_BitMap : tags(1)=BitMapID()
     tags(2)=0          : tags(3)=0

     ;If OpenScreen(0,#Width,#Height,8,@tags(0))
     If OpenP96Screen()
       ;DisplayPalette(0,ScreenID())
       UseChunkyBuffer(0)
       ChunkyCls(3)

       For x.l=0 to 64
         For y.l=0 to 64 step 2
           ChunkyPlot(x.l,y.l,4)
         Next
       Next


       ChunkyBufferToP96Screen()
       ;ChunkyP96ToPlanar(cb0.l,BitMapID(),#Height)
       Delay(25) 

       MouseWait()

       GrabChunkySprite(7,BitMapID(),0,0,16,16)
       GrabChunkySprite(8,BitMapID(),0,0,32,32)
       GrabChunkySprite(9,BitMapID(),0,0,64,64)

       test.l=SaveChunkySprites(5,9,"Ram:ChunkyDemo.csp")
       Print("ChunkySprites Saved..") : PrintNumberN(test.l)

       ChunkyCls(0)

       For c.l=0 To 1
         For cc.l=0 To 19
           DisplayChunkySpriteBlock(7,cc.l*16,c.l*16)
           ;ChunkyToPlanar(cb0.l,BitMapID(),#Height)
           ChunkyBufferToP96Screen()
         Next 
       Next

       For c.l=0 To 2
         For cc.l=0 To 9
           DisplayChunkySpriteBlock(8,cc.l*32,c.l*32+32)
           ;ChunkyToPlanar(cb0.l,BitMapID(),#Height)
           ChunkyBufferToP96Screen()
         Next 
       Next

       For c.l=0 To 1
         For cc.l=0 To 4
           DisplayChunkySpriteBlock(9,cc.l*64,c.l*64+128)
           ;ChunkyToPlanar(cb0.l,BitMapID(),#Height)
           ChunkyBufferToP96Screen()
         Next 
       Next

       For c.l=7 To 9
         FreeChunkySprite(c.l)
       Next

       DisplayChunkySprite(0,16,50)
       DisplayChunkySprite(1,34,100)
       DisplayTransparantChunkySprite(2,160,16)
       DisplayTransparantChunkySprite(3,190,64)
       ;ChunkyToPlanar(cb0.l,BitMapID(),#Height)
       ChunkyBufferToP96Screen()
       
       GrabChunkySprite(7,BitMapID(),0,0,320,256)
       UseChunkyBuffer(1)
       DisplayChunkySpriteBlock(7,0,0)
       FreeChunkySprite(7)

       cb.l=1 : csb.l=1
       CopyChunkySprite(3,7)
       ChunkySpriteHandle(7,ChunkySpriteWidth(7)/2,ChunkySpriteHeight(7)/2)

       For c.l=0 To 99

         ;VWait()

         cb.l=1-cb.l
         UseChunkyBuffer(cb.l)

         csb.l=1-csb.l
         UseChunkySpriteBuffer(csb.l)

         RestoreChunkyBuffer()

         DisplayBufferedChunkySprite(6,c.l+30,30)
         DisplayBufferedChunkySprite(7,c.l+50,100)
         ;ChunkyToPlanar(ChunkyBufferID(),BitMapID(),#Height)
         ChunkyBufferToP96Screen()

       Next 

       FlushChunkySpriteBuffer(csb.l)
       RestoreChunkyBuffer()
       ChunkyToPlanar(ChunkyBufferID(),BitMapID(),#Height)
       Delay(25)

     EndIf

    CloseP96Screen()
   EndIf

 EndIf

 PrintN("End of Program.")
 End

