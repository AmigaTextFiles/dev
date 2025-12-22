
#Width=640
#Height=480
#Depth=8


 If InitPicasso96(1,0)
 
   bm0.l=AllocatePicasso96BitMap(0,#Width,#Height,#Depth)
   bm1.l=AllocatePicasso96BitMap(1,#Width,#Height,#Depth)

   If bm0 AND bm1

     If OpenPicasso96Screen(0,0,"Picasso96...")

       For x.l=0 To #Width-1
         Picasso96Plot(0,x.l,000,1)
         Picasso96Plot(0,x.l,239,1)
         Picasso96Plot(0,x.l,479,1)
       Next

       For y.l=0 To #Height-1
         Picasso96Plot(0,000,y.l,1)
         Picasso96Plot(0,319,y.l,1)
         Picasso96Plot(0,639,y.l,1)
       Next

       For x.l=0 To #Width-1
         Picasso96Plot(1,x.l,000,2)
         Picasso96Plot(1,x.l,239,2)
         Picasso96Plot(1,x.l,479,2)
       Next

       For y.l=0 To #Height-1
         Picasso96Plot(1,000,y.l,2)
         Picasso96Plot(1,319,y.l,2)
         Picasso96Plot(1,639,y.l,2)
       Next

       x.l=0 : y.l=0 : dx.l=1 : dy.l=1

       Repeat

         VWait()
         ShowPicasso96BitMap(bm.l,x.l,x.l)

         bm.l=1-bm.l
         x.l+dx.l : y.l+dy.l

         If x.l <= 0 OR x.l >= #Width-1
           dx.l=-dx.l
         EndIf

         If y.l <= 0 OR y.l >= #Height-1
           dy.l=-dy.l
         EndIf

       Until MouseButtons() = 3

     EndIf

   EndIf

 EndIf

 PrintN("End of Program.")
 End

