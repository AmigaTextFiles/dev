
/*

  on a boring weekend i tried how to code such screen effects some blankers
  do while "blanking" the screen.
  the result is this demonstration program written using wouters e (i guess
  everybody should "translate" it into his/her favourit language)

  greez fly to Knuddel, "PackMAN" Falk Zühlsdorff, "Zet" Mathhias Zinke,
  Marcus, the DOSen-Friix and any other who knows me (or even not ;)

  read the routines notes so can find tips for optimizing and making
  more funny effects; the spot effect is "in work" so maybe ScreenFX 2
  will follow with some more and other effect (write me if you have
  suggestions!)

  the code is documented, but if you have any question you may mail:

            jt18@irz.inf.tu-dresden.de

  SPECIAL NOTE: USAGE IS YOUR OWN RISK!!!!! FAILURE OR LOST DATA ARE NOT
                MY FAULT.

  now have fun,
  savage

*/

MODULE 'intuition/intuitionbase',
       'intuition/intuition',
       'intuition/screens',
       'graphics/gfx',
       'graphics/view',
       'graphics/rastport',
       'graphics/videocontrol',
       'exec/memory',
       'hardware/blit'

ENUM BYE,MELT,BACKPOINTS,BLACKPOINTS,DISSOLVE,FADE,BLUR

ENUM DOWN=100,SWIM,SUCK

DEF copyscreen=NIL : PTR TO screen,
    copyviewport=NIL : PTR TO viewport,
    copywindow=NIL : PTR TO window,
    rastport=NIL : PTR TO rastport,
    numbercolors=0

PROC main()

DEF response

  -> init the rnd-generator
  Rnd(-1)

  WHILE (response := req('Welcome to ScreenFX by Jens Tröger\n\n'+
                         'This will show you how to program\n'+
                         'several Effects like Blankers do.\n\n'+
                         'USAGE IS YOUR OWN RISK !',
                         'Melt|BackPoints|BlackPoints|Dissolve|Fade|Blur| Bye ')) <> BYE

/***************************************************************************

 the melt function use the BltBitMap() gfx function to blit random parts
 of the source bitmap into the same bitmap; try different minterms
 (mad: ANBNC OR ANBC ;)

 all other procs use simple gfx functions such like RectFill(), WritePixel(),
 SetRGB4() and so on...

 ***************************************************************************/


      -> the folowing will only call the routines (if nothing happens
      -> copyFirstScreen() failed (i did *NO* error message handling!)
      SELECT response

        CASE MELT

          response := req('Select type of melt...','Suck|Down|Swim')

          SELECT response
            CASE 1

              IF copyFirstScreen()
                melt(SUCK, ABNC OR ABC)
                closeCopyScreen()
              ENDIF

            CASE 2

              IF copyFirstScreen()
                melt(DOWN, ABNC OR ABC)
                closeCopyScreen()
              ENDIF

            CASE 0

              IF copyFirstScreen()
                melt(SWIM, ABNC OR ABC)
                closeCopyScreen()
              ENDIF
              
          ENDSELECT

        CASE BACKPOINTS

          IF copyFirstScreen()
            backPoints()
            closeCopyScreen()
          ENDIF

        CASE BLACKPOINTS

          IF copyFirstScreen()
            blackPoints()
            closeCopyScreen()
          ENDIF

        CASE DISSOLVE

          IF copyFirstScreen()
            dissolve()
            closeCopyScreen()
          ENDIF

        CASE FADE

          IF copyFirstScreen()
            fade()
            closeCopyScreen()
          ENDIF

        CASE BLUR

          IF copyFirstScreen()
            blur()
            closeCopyScreen()
          ENDIF

      ENDSELECT

  ENDWHILE

ENDPROC

PROC copyFirstScreen()

/*
    NOTE (taken from RKRM)
    "An application may not steal the bitmap of a screen that it
    does not own. Stealing the Workbench screen`s bitmap, or that
    of any other public screen, is strictly illegal."

    NOTE
    i should not draw into screens rastport directly so i open a
    "fullsize" window and copy source-screens bitmap into windows
    rastport

    NOTE
    returns TRUE or FALSE, !!*NOT*!! the screen address!!!!
*/

-> define some variables as pointers
DEF intbase=NIL: PTR TO intuitionbase,
    iblock=NIL,
    srcscreen=NIL: PTR TO screen,
    srcbitmap=NIL: PTR TO bitmap,
    srcviewport=NIL: PTR TO viewport,
    srcrastport=NIL: PTR TO rastport,
    srccolormap=NIL: PTR TO colormap

  -> so i can examine the intuitionbase
  intbase := intuitionbase

  -> lock the intuitionbase and get the pointer to the frontmost
  -> screen (firstscreen)
  iblock := LockIBase(NIL)
  srcscreen := intbase.firstscreen
  UnlockIBase(iblock)

  -> initialize some pointers
  srcrastport := srcscreen.rastport
  srcbitmap := srcrastport.bitmap
  srcviewport := srcscreen.viewport
  srccolormap := srcviewport.colormap

  -> calc number of colors from screens depth
  numbercolors := Shl(2,srcbitmap.depth-1)

  -> now open the screen
  copyscreen := OpenScreenTagList(NIL,
                                  [SA_LEFT,srcscreen.leftedge,
                                   SA_TOP,0,
                                   SA_WIDTH,srcscreen.width,
                                   SA_HEIGHT,srcscreen.height,
                                   SA_DEPTH,srcbitmap.depth,
                                   SA_DISPLAYID,GetVPModeID(srcscreen.viewport),
                                   SA_BEHIND,TRUE,
                                   NIL])
  IF copyscreen

    -> get the viewport OF the copyscreen
    copyviewport := copyscreen.viewport

    -> set colors
    LoadRGB4(copyscreen.viewport,srccolormap.colortable,srccolormap.count)

    copywindow := OpenWindowTagList(NIL,
                                    [WA_LEFT,0,
                                     WA_TOP,0,
                                     WA_WIDTH,srcscreen.width,
                                     WA_HEIGHT,srcscreen.height,
                                     WA_BORDERLESS,TRUE,
                                     WA_CUSTOMSCREEN,copyscreen,
                                     NIL])
    IF copywindow

      -> copy source-screens`s bitmap (disable task-switching)
      Forbid()
      BltBitMapRastPort(srcbitmap,0,0,
                        copywindow.rport,0,0,
                        copywindow.width,copywindow.height,
                        $C0)
      Permit()

      -> set the global rastport and the e-internal reastport
      -> to my windows rastport
      rastport := copywindow.rport
      SetStdRast(copywindow.rport)

      -> pop the screen to front
      ScreenToFront(copyscreen)

      RETURN TRUE

    ENDIF

    CloseScreen(copyscreen)

  ENDIF

ENDPROC FALSE
PROC closeCopyScreen()

  -> move the screen to back and close the window and screen
  ScreenToBack(copyscreen)
  CloseWindow(copywindow)
  CloseScreen(copyscreen)

ENDPROC
PROC borderOff()

  -> switch off the border
  VideoControl(copyviewport.colormap,[VTAG_BORDERBLANK_SET,0,NIL])

  -> now refresh the display (RethinkDisplay() is not enough :)
  RemakeDisplay()

ENDPROC
PROC req(text, gads)

  -> simply set up a intuition requester and return its response
  RETURN EasyRequestArgs(NIL,[20,0,'ScreenFX by Jens Tröger',text,gads]:LONG,NIL,NIL)

ENDPROC

PROC blur()

DEF x,y

  WHILE Not(LeftMouse(copywindow))

    -> get a random pixel of my screen...
    x := Rnd(copyscreen.width)
    y := Rnd(copyscreen.height)

    -> ...find and set its color as apen...
    SetAPen(rastport, ReadPixel(rastport,x,y))

    -> ...and paint a little rect in this color
    RectFill(rastport,x,y,x+1,y+1)

  ENDWHILE

ENDPROC
PROC fade()

-> NOTE: you will get a smoother fading if you do not set every register
->       itself by calling SetRGB4() but creating a own colormap via
->       GetColorMap(), fill it an after this call LoadRGB4()

-> inspirated by Holger Gzella (thanx Holger: are you in Germany again??)

DEF fade=TRUE,count,color,red,green,blue

  -> fade will be set to TRUE if one of the color registers is
  -> not zero (black)
  WHILE (fade = TRUE) AND (Not(LeftMouse(copywindow)))

    -> do with every color register starting by 0
    FOR count := 0 TO numbercolors-1

      -> get color register`s color
      -> NOTE: all are 4-bit-rgb-values!
      color := GetRGB4(copyviewport.colormap,count)

      -> if color is not black get the parts of it (red, green, blue)
      -> with shifting and masking the bits and count down these values
      IF color > 0

        -> get the parts
        red := Shr(And(color,$0f00),8)
        green := Shr(And(color,$00f0),4)
        blue := And(color,$000f)

        -> count down
        IF (red>=blue) AND (red>=green) AND (red>0) THEN red--
        IF (green>=blue) AND (green>=red) AND (green>0) THEN green--
        IF (blue>=red) AND (blue>=green) AND (blue>0) THEN blue--

        -> set the new (a little darker) color
        SetRGB4(copyviewport,count,red,green,blue)

        -> wait a little time (5 x 1/50s)
        Delay(5)

        -> set fade to true for a new loop
        fade := TRUE

      ELSE

        -> all (or the last) are black!
        fade := FALSE

      ENDIF

    ENDFOR

  ENDWHILE

ENDPROC
PROC dissolve()

DEF x,y

  WHILE Not(LeftMouse(copywindow))

    -> get a random pixel
    x := Rnd(copyscreen.width)
    y := Rnd(copyscreen.height)

    -> mask the bitplanes using Rnd()
    rastport.mask := Rnd(numbercolors+1)

    -> scroll my random rect (size is 5x5) in a random direction
    -> (direction is max 5 pixel horizontal and/or vertical)
    ScrollRaster(rastport,Rnd(5), Rnd(5),x,y,x+5,y+5)

  ENDWHILE                                                  

ENDPROC
PROC blackPoints()

  -> use black as draw-pen (hope reg 1 will hold black!!!, otherwise
  -> use the pen-array given by the draw-info structure to find the
  -> darkest color)
  SetAPen(rastport,1)

  -> switch off the border
  borderOff()

  WHILE Not(LeftMouse(copywindow))

    -> draw and draw and draw black pixels
    WritePixel(rastport,Rnd(copyscreen.width),Rnd(copyscreen.height))

  ENDWHILE

ENDPROC
PROC backPoints()

  -> if reg 0 holds the background pen this will work otherwise use the
  -> draw-info BACKGROUNDPEN
  SetAPen(rastport,0)

  WHILE Not(LeftMouse(copywindow))

    -> draw and draw "invisible" pixels
    WritePixel(rastport,Rnd(copyscreen.width),Rnd(copyscreen.height))

  ENDWHILE

ENDPROC

PROC melt(mode,minterm)

-> this code was inspirated/taken from "MELT.C" by Stephen Coy and
-> modified for different effects

DEF mask,x,y,u,v,dx,dy,temp

  -> BltBitMap() needs some CHIP-Mem as a temporary memory
  -> if there are overlapping blits
  IF (temp := NewM(MAXBYTESPERROW, MEMF_CHIP OR MEMF_CLEAR)) = NIL THEN RETURN

  -> do melting while the LMB is not pressed
  WHILE Not(LeftMouse(copywindow))

    -> bitplane mask
    mask := 1

    REPEAT

      -> get the dimension of the blit-rect and its
      -> position
      u := Rnd((copyscreen.width-3)/2)+1
      v := Rnd((copyscreen.height-3)/2)+1
      x := Rnd(copyscreen.width-1-u)+1
      y := Rnd(copyscreen.height-2-v)+1

      -> check what melt and randowmize the
      -> dirction
      IF mode = DOWN
        dx := Rnd(3)-1
        dy := Rnd(3)
      ELSEIF mode = SWIM
        dx := Rnd(3)-1
        dy := Rnd(3)-1
      ELSEIF mode = SUCK
        IF (x < (copyscreen.width / 2))
          IF (y < (copyscreen.height / 2))
            dx := Rnd(3)
            dy := Rnd(3)
          ELSE
            dx := Rnd(3)
            dy := - Rnd(3)-2
          ENDIF
        ELSE
          IF (y < (copyscreen.height / 2))
            dx := - Rnd(3)-2
            dy := Rnd(3)
          ELSE
            dx := - Rnd(3)-2
            dy := - Rnd(3)-2
          ENDIF
        ENDIF
      ENDIF

      -> now blit the rect
      -> ZET-NOTE (and other friix): replace mask with $FFFFFFFF  ;0)
      BltBitMap(rastport.bitmap, x, y,
                rastport.bitmap, x+dx, y+dy,
                u, v, minterm, mask, temp);

      -> activate next bitplanes
      mask ++

    UNTIL mask >= (numbercolors-1)

  ENDWHILE

  -> free the temporary memory
  Dispose(temp)

ENDPROC



