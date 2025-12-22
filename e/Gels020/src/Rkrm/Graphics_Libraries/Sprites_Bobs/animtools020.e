-> animtools.e
->
-> This file is a collection of tools which are used with the VSprite, Bob and
-> Animation system software.  It is intended as a useful EXAMPLE, and while it
-> shows what must be done, it is not the only way to do it.  If Not Enough
-> Memory, or error return, each cleans up after itself before returning.
-> NOTE that these routines assume a very specific structure to the GEL lists.
-> Make sure that you use the correct pairs together
-> (i.e., makeOb()/freeOb())

->>> Header (globals)
OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'exec/memory',
       'graphics/gels',
       'graphics/gels020',
       'graphics/gfx',
       'graphics/rastport'

-> 'intuition/intuitionbase' does not define a library name.
#define INTUITIONNAME 'intuition.library'

-> These objects are used by the functions below to allow for an easier
-> interface to the animation system.
->>>

->>> OBJECT newVSprite
-> Object to hold information for a new VSprite.
OBJECT newVSprite
  image:PTR TO INT      -> Image data for the VSprite
  colorSet:PTR TO INT   -> Colour array for the VSprite
  wordWidth:INT         -> Width in words
  lineHeight:INT        -> Height in lines
  imageDepth:INT        -> Depth of the image
  x:INT                 -> Initial x position
  y:INT                 -> Initial y position
  flags:INT             -> VSprite flags
  hitMask:INT           -> Hit mask
  meMask:INT            -> Me mask
ENDOBJECT
->>>

->>> OBJECT newBob
-> Object to hold information for a new Bob.
OBJECT newBob
  image:PTR TO INT  -> Image data FOR the Bob
  wordWidth:INT     -> Width in words
  lineHeight:INT    -> Height in lines
  imageDepth:INT    -> Depth of the image
  planePick:INT     -> Planes that get image data
  planeOnOff:INT    -> Unused planes to turn on
  bFlags:INT        -> Bob flags
  dBuf:INT          -> 1=double buf, 0=not
  rasDepth:INT      -> Depth of the raster
  x:INT             -> Initial x position
  y:INT             -> Initial y position
  hitMask:INT       -> Hit mask
  meMask:INT        -> Me mask
ENDOBJECT
->>>

->>> OBJECT newAnimComp
-> Object to hold information for a new animation component.
OBJECT newAnimComp
  routine:LONG  -> Routine called when Comp IS displayed
  xt:INT        -> Initial delta offset position
  yt:INT
  time:INT      -> Initial timer value
  cFlags:INT    -> Flags for the Comp
ENDOBJECT
->>>

->>> OBJECT newAnimSeq
-> Object to hold information for a new animation sequence.
OBJECT newAnimSeq
  headOb:PTR TO ao      -> Common head of object
  images:PTR TO INT     -> Array of Comp image data
  xt:PTR TO INT         -> Arrays of initial offsets
  yt:PTR TO INT
  times:PTR TO INT      -> Array of initial timer values
  routines:PTR TO LONG  -> Array of functions called when Comp is drawn
  cFlags:INT            -> Flags for the Comp
  count:INT             -> Number of Comps in sequence (= arrays size)
  singleImage:INT       -> One (or count) images
ENDOBJECT
->>>

->>> PROC setupGelSys(rPort:PTR TO rastport, reserved) HANDLE
-> Setup the GELs system.  After this call is made you can use VSprites, Bobs,
-> AnimComps and AnimObs.  Note that this links the GelsInfo structure into the
-> RastPort, and calls InitGels().  It uses information in your rastport
-> object to establish boundary collision defaults at the outer edges of the
-> raster.  This routine sets up for everything - collision detection and all.
-> You must already have run LoadView before ReadyGelSys is called.
PROC setupGelSys(rPort:PTR TO rastport, reserved) HANDLE
  DEF gInfo=NIL:PTR TO gelsinfo, vsHead=NIL:PTR TO vs, vsTail=NIL:PTR TO vs
  NEW gInfo, vsHead, vsTail
  NEW gInfo.nextline[8], gInfo.lastcolor[8], gInfo.collhandler
  gInfo.sprrsrvd:=reserved
  -> Set left- and top-most to 1 to better keep items inside the display
  -> boundaries.
  gInfo.leftmost:=1; gInfo.topmost:=1
  gInfo.rightmost:=(rPort.bitmap.bytesperrow*8)-1
  gInfo.bottommost:=rPort.bitmap.rows-1
  rPort.gelsinfo:=gInfo
  InitGels(vsHead, vsTail, gInfo)
EXCEPT
  IF gInfo THEN END gInfo.nextline[8], gInfo.lastcolor[8], gInfo.collhandler
  END gInfo, vsHead, vsTail
  ReThrow()
ENDPROC gInfo
->>>

->>> PROC cleanupGelSys(gInfo:PTR TO gelsinfo, rPort:PTR TO rastport)
-> Free all of the stuff allocated by setupGelSys().  Only call this routine if
-> setupGelSys() returned successfully.  The GelsInfo structure IS the one
-> returned by setupGelSys().  It also unlinks the GelsInfo from the RastPort.
PROC cleanupGelSys(gInfo:PTR TO gelsinfo, rPort:PTR TO rastport)
  rPort.gelsinfo:=NIL
  END gInfo.nextline[8], gInfo.lastcolor[8], gInfo.collhandler,
      gInfo.gelhead, gInfo.geltail
  END gInfo
ENDPROC
->>>

->>> PROC makeVSprite(nVSprite:PTR TO newVSprite) HANDLE
-> Create a VSprite from the information given in nVSprite.  Use freeVSprite()
-> to free this GEL.
PROC makeVSprite(nVSprite:PTR TO newVSprite) HANDLE
  DEF vsprite=NIL:PTR TO vs, line_size, plane_size
  line_size:=SIZEOF INT * nVSprite.wordWidth
  plane_size:=line_size * nVSprite.lineHeight
  NEW vsprite
  vsprite.borderline := NewM(line_size, MEMF_CHIP)
  vsprite.collmask   := NewM(plane_size, MEMF_CHIP)
  vsprite.y          := nVSprite.y
  vsprite.x          := nVSprite.x
  vsprite.vsflags    := nVSprite.flags
  vsprite.width      := nVSprite.wordWidth
  vsprite.depth      := nVSprite.imageDepth
  vsprite.height     := nVSprite.lineHeight
  vsprite.memask     := nVSprite.meMask
  vsprite.hitmask    := nVSprite.hitMask
  vsprite.imagedata  := nVSprite.image
  vsprite.sprcolors  := nVSprite.colorSet
  vsprite.planepick  := 0
  vsprite.planeonoff := 0
  InitMasks(vsprite)
EXCEPT
  IF vsprite
    Dispose(vsprite.borderline)
    Dispose(vsprite.collmask)
  ENDIF
  END vsprite
  ReThrow()
ENDPROC vsprite
->>>

->>> PROC makeBob(nBob:PTR TO newBob) HANDLE
-> Create a Bob from the information given in nBob.  Use freeBob() to free this
-> GEL.  A VSprite is created for this bob.  This routine properly allocates
-> all double buffered information if it is required.
PROC makeBob(nBob:PTR TO newBob) HANDLE
  DEF bob=NIL:PTR TO bob, vsprite=NIL:PTR TO vs, rassize
  rassize:=SIZEOF INT * nBob.wordWidth * nBob.lineHeight * nBob.rasDepth
  NEW bob
  bob.savebuffer:=NewM(rassize, MEMF_CHIP)  
  vsprite:=makeVSprite([nBob.image, NIL, nBob.wordWidth, nBob.lineHeight,
                        nBob.imageDepth, nBob.x, nBob.y, nBob.bFlags,
                        nBob.hitMask, nBob.meMask]:newVSprite)
  vsprite.planepick:=nBob.planePick
  vsprite.planeonoff:=nBob.planeOnOff
  vsprite.vsbob:=bob
  bob.bobvsprite:=vsprite
  bob.imageshadow:=vsprite.collmask
  bob.bobflags:=0
  bob.before:=NIL
  bob.after:=NIL
  bob.bobcomp:=NIL

  IF nBob.dBuf
    NEW bob.dbuffer
    bob.dbuffer.bufbuffer:=NewM(rassize, MEMF_CHIP)
  ELSE
    bob.dbuffer:=NIL
  ENDIF
EXCEPT
  IF vsprite THEN freeVSprite(vsprite)
  IF bob
    IF bob.dbuffer THEN Dispose(bob.dbuffer.bufbuffer)
    END bob.dbuffer
    Dispose(bob.savebuffer)
  ENDIF
  END bob
  ReThrow()
ENDPROC bob
->>>

->>> PROC makeComp(nBob:PTR TO newBob, nAnimComp:PTR TO newAnimComp) HANDLE
-> Create a Animation Component from the information given in nAnimComp and
-> nBob.  Use freeComp() to free this GEL.  makeComp() calls makeBob(), and
-> links the Bob into an AnimComp.
PROC makeComp(nBob:PTR TO newBob, nAnimComp:PTR TO newAnimComp) HANDLE
  DEF compBob=NIL:PTR TO bob, aComp=NIL:PTR TO ac020
  NEW aComp
  compBob:=makeBob(nBob)
  compBob.before:=NIL
  compBob.after:=NIL
  compBob.bobcomp:=aComp  -> Link 'em up
  aComp.animbob      := compBob
  aComp.timeset      := nAnimComp.time  -> Number of ticks active
  aComp.ytrans       := nAnimComp.yt    -> Offset relative to HeadOb
  aComp.xtrans       := nAnimComp.xt
  aComp.animcroutine := nAnimComp.routine
  aComp.compflags    := nAnimComp.cFlags
  aComp.timer        := 0
  aComp.prevseq      := NIL
  aComp.nextseq      := NIL
  aComp.prevcomp     := NIL
  aComp.nextcomp     := NIL
  aComp.headob       := NIL
  aComp.pad          := 0 -> pad is unused but must be 0
EXCEPT
  -> E-Note: Don't need to freeBob(compBob)...
  END aComp
  ReThrow()
ENDPROC GET_AC(aComp)
->>>

->>> PROC makeSeq(nBob:PTR TO newBob, nAnimSeq:PTR TO newAnimSeq) HANDLE
-> Create an Animation Sequence from the information given in nAnimSeq and
-> nBob.  Use freeSeq() to free this GEL.  This routine creates a linked list
-> of animation components which make up the animation sequence.  It links them
-> all up, making a circular list of the prevseq and nextseq pointers.  That is
-> to say, the first component of the sequence's prevseq points to the last
-> component; the last component of the sequence's nextseq points back to the
-> first component.  If dbuf is on, the underlying Bobs will be set up for
-> double buffering.  If singleImage is non-zero, the 'images' pointer is
-> assumed to point to an array of only one image, instead of an array of
-> 'count' images, and all Bobs will use the same image.
PROC makeSeq(nBob:PTR TO newBob, nAnimSeq:PTR TO newAnimSeq) HANDLE
  DEF seq, firstCompInSeq=NIL:PTR TO ac, seqComp=NIL:PTR TO ac,
      lastCompMade=NIL:PTR TO ac, image_size, nAnimComp:newAnimComp
  -> Get the initial image.  This is the only image that is used if
  -> nAnimSeq.singleImage is non-zero.
  nBob.image:=nAnimSeq.images
  image_size:=nBob.lineHeight * nBob.imageDepth * nBob.wordWidth

  -> For each comp in the sequence
  FOR seq:=0 TO nAnimSeq.count-1
    nAnimComp.xt      := nAnimSeq.xt[seq]
    nAnimComp.yt      := nAnimSeq.yt[seq]
    nAnimComp.time    := nAnimSeq.times[seq]
    nAnimComp.routine := nAnimSeq.routines[seq]
    nAnimComp.cFlags  := nAnimSeq.cFlags
    seqComp:=makeComp(nBob, nAnimComp)
    seqComp.headob:=nAnimSeq.headOb
    -> Make a note of where the first component is.
    IF firstCompInSeq=NIL THEN firstCompInSeq:=seqComp
    -> Link the component into the list
    IF lastCompMade<>NIL THEN lastCompMade.nextseq:=seqComp
    seqComp.nextseq:=NIL
    seqComp.prevseq:=lastCompMade
    lastCompMade:=seqComp
    -> If nAnimSeq.singleImage is zero, the image array has nAnimSeq.count
    -> images.
    IF nAnimSeq.singleImage=0
      -> E-Note: image_size is in INTs so multiply up first
      nBob.image:=nBob.image+(image_size*SIZEOF INT)
    ENDIF
  ENDFOR
  -> On the last component in the sequence, set Next/Prev to make the linked
  -> list a loop of components.
  lastCompMade.nextseq:=firstCompInSeq
  firstCompInSeq.prevseq:=lastCompMade
EXCEPT
  IF firstCompInSeq THEN freeSeq(firstCompInSeq, nBob.rasDepth)
  ReThrow()
ENDPROC firstCompInSeq
->>>

->>> PROC freeVSprite(vsprite:PTR TO vs)
-> Free the data created by makeVSprite().  Assumes images deallocated
-> elsewhere.
PROC freeVSprite(vsprite:PTR TO vs)
  DEF line_size, plane_size
  line_size:=SIZEOF INT * vsprite.width
  plane_size:=line_size * vsprite.height
  Dispose(vsprite.borderline)
  Dispose(vsprite.collmask)
  END vsprite
ENDPROC
->>>

->>> PROC freeBob(bob:PTR TO bob, rasdepth)
-> Free the data created by makeBob().  It's important that rasdepth match the
-> depth you passed to makeBob() when this GEL was made.  Assumes images
-> deallocated elsewhere.
PROC freeBob(bob:PTR TO bob, rasdepth)
  DEF rassize
  rassize:=SIZEOF INT * bob.bobvsprite.width * bob.bobvsprite.height * rasdepth
  IF bob.dbuffer THEN Dispose(bob.dbuffer.bufbuffer)
  END bob.dbuffer
  Dispose(bob.savebuffer)
  freeVSprite(bob.bobvsprite)
  END bob
ENDPROC
->>>

->>> PROC freeComp(myComp:PTR TO ac, rasdepth)
-> Free the data created by makeComp().  It's important that rasdepth match
-> the depth you passed to makeComp() when this GEL was made. Assumes images
-> deallocated elsewhere.
PROC freeComp(myComp:PTR TO ac, rasdepth)
  freeBob(myComp.animbob, rasdepth)
  END myComp
ENDPROC
->>>

->>> PROC freeSeq(headComp:PTR TO ac, rasdepth)
-> Free the data created by makeSeq().  Complementary to makeSeq(), this
-> routine goes through the nextseq pointers and frees the Comps.  This routine
-> only goes forward through the list, and so it must be passed the first
-> component in the sequence, or the sequence must be circular (which is
-> guaranteed if you use makeSeq()).  It's important that rasdepth match the
-> depth you passed to makeSeq() when this GEL was made.   Assumes images
-> deallocated elsewhere!
PROC freeSeq(headComp:PTR TO ac, rasdepth)
  DEF curComp:PTR TO ac, nextComp
  -> Break the nextseq loop, so we get a NIL at the end of the list.
  headComp.prevseq.nextseq:=NIL

  curComp:=headComp  -> Get the start of the list
  WHILE curComp<>NIL
    nextComp:=curComp.nextseq
    freeComp(curComp, rasdepth)
    curComp:=nextComp
  ENDWHILE
ENDPROC
->>>

->>> PROC freeOb(headOb:PTR TO ao, rasdepth)
-> Free an animation object (list of sequences).  freeOb() goes through the
-> nextcomp pointers, starting at the AnimOb's headcomp, and frees every
-> sequence.  It only goes forward.  It then frees the Object itself.  Assumes
-> images deallocated elsewhere!
PROC freeOb(headOb:PTR TO ao, rasdepth)
  DEF curSeq:PTR TO ac, nextSeq
  curSeq:=headOb.headcomp  -> Get the start of the list
  WHILE curSeq<>NIL
    nextSeq:=curSeq.nextcomp
    freeSeq(curSeq, rasdepth)
    curSeq:=nextSeq
  ENDWHILE
  END headOb
ENDPROC
->>>
