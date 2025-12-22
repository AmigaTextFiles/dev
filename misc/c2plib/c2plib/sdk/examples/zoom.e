
/*
  This example will operate on every pixel of the image. The idea is that a
  pixel in the next frame gets a neighbor pixel from the previous frame, from
  center to the borders.

  The effect can represented using two arrays of displacements, for X and Y
  coords, in which store the displacement of the current pixel from the
  previous.

  LEFT                       CENTER OF SCREEN                         RIGHT
  +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
  | 3 | 3 | 2 | 2 | 2 | 1 | 1 | 1 | 0 | 0 |-1 |-1 |-1 |-2 |-2 |-2 |-3 |-3 |
  +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+

  +-----------------------------------------+     +---+
  |                    ^                    |     | 2 |  TOP
  |                    ^                    |     +---+
  |                    ^                    |     | 1 |
  | <<<  <<  <<  <  <  0  >  >  >>  >>  >>> |     +---+
  |                    v                    |     | 1 |
  |                    v                    |     +---+
  |                    v                    |     | 0 |
  +-----------------------------------------+     +---+  MIDDLE OF SCREEN
                                                  | 0 |
                                                  +---+
                                                  |-1 |
                                                  +---+
                                                  |-1 |
                                                  +---+
                                                  |-2 |
                                                  +---+  BOTTOM

  The effect is similar to a pinch zoom. On every frame a group of random
  pixels is drawn onto the screen. Using single pixels, the algorithm seems
  to be similare to a starfield, but it'snt. Maybe it's worth to test the
  algorithm using a image.

  This example is not optimized, please see the zoom-optimized.e source and
  compare the performances.
*/


MODULE 'c2p',
       'libraries/c2p'

MODULE 'exec/memory',
       'exec/types',
       'graphics/gfx',
       'graphics/view',
       'intuition/intuition',
       'intuition/screens'

MODULE 'amigalib/random'



CONST WIDTH         = 320,
      HEIGHT        = 240,
      PLANAR_FORMAT = C2P_CONTEXT_PLANAR_FORMAT_4_BIT,
      SPEED         = 32,
      NUM_FRAMES    = 255



PROC main()
  DEF context : LONG
  DEF chunky : PTR TO CHAR
  DEF bitmap : PTR TO bitmap
  DEF scr : PTR TO screen
  DEF win : PTR TO window
  DEF i : LONG
  DEF buffer : PTR TO CHAR
  DEF dx : PTR TO LONG
  DEF dy : PTR TO LONG
  DEF x, y, c : LONG
  DEF step : LONG
  DEF size : LONG
  DEF swap : PTR TO CHAR

  DEF startsec, startmic : LONG
  DEF seconds, micros : LONG
  DEF fps_str[20] : STRING, frame_count, fps

  DEF error : LONG

  size := WIDTH * HEIGHT
  error := 0

  IF c2pbase := OpenLibrary('c2p.library', 0)
    IF context := Cp_CreateContext()

      error := Cp_SetContextParameter(context, C2P_CONTEXT_PARAMETER_TYPE, C2P_CONTEXT_TYPE_BITMAP)
      IF error <> 0 THEN JUMP destroy_context
      error := Cp_SetContextParameter(context, C2P_CONTEXT_PARAMETER_WIDTH, WIDTH)
      IF error <> 0 THEN JUMP destroy_context
      error := Cp_SetContextParameter(context, C2P_CONTEXT_PARAMETER_HEIGHT, HEIGHT)
      IF error <> 0 THEN JUMP destroy_context
      error := Cp_SetContextParameter(context, C2P_CONTEXT_PARAMETER_PLANAR_FORMAT, PLANAR_FORMAT)
      IF error <> 0 THEN JUMP destroy_context

      IF Cp_InitializeContext(context) = 0

        bitmap := Cp_GetContextParameter(context, C2P_CONTEXT_PARAMETER_BITMAP)
        chunky := Cp_GetContextParameter(context, C2P_CONTEXT_PARAMETER_CHUNKY)

        buffer := Cp_AllocMem(context, size)

        -> delta initialization
        dx := Cp_AllocMem(context, WIDTH * 4)
        dy := Cp_AllocMem(context, HEIGHT * 4)

        step := 1
        i := 0
        FOR x := 0 TO (WIDTH / 2) - 2
          dx[WIDTH / 2 - x - 2] := step
          dx[WIDTH / 2 + x + 1] := -step
          INC i
          IF i >= SPEED
            i := 0
            INC step
          ENDIF
        ENDFOR

        step := 1
        i := 0
        FOR y := 0 TO (HEIGHT / 2) - 2
          dy[HEIGHT / 2 - y - 2] := step
          dy[HEIGHT / 2 + y + 1] := -step
          INC i
          IF i >= SPEED
            i := 0
            INC step
          ENDIF
        ENDFOR

        scr := OpenScreenTagList( 0, [
          SA_DEPTH,       PLANAR_FORMAT,
          SA_WIDTH,       WIDTH,
          SA_HEIGHT,      HEIGHT,
          /*
          SA_DISPLAYID,   LORES_KEY,
          */
          SA_TITLE,       'c2p.library',
          SA_SHOWTITLE,   FALSE,
          SA_TYPE,        CUSTOMSCREEN OR CUSTOMBITMAP,
          SA_BITMAP,      bitmap,
          SA_EXCLUSIVE,   TRUE,
          SA_QUIET,       TRUE,
          0])
        IF scr <> 0

          win := OpenWindowTagList(0, [
            WA_IDCMP,           IDCMP_CLOSEWINDOW OR IDCMP_VANILLAKEY,
            WA_TOP,             0,
            WA_LEFT,            0,
            WA_WIDTH,           WIDTH,
            WA_HEIGHT,          HEIGHT,
            WA_CUSTOMSCREEN,    scr,
            WA_BACKDROP,        TRUE,
            WA_BORDERLESS,      TRUE,
            WA_FLAGS,           WFLG_RMBTRAP,
            0])
          IF win <> 0

            setPalette(scr.viewport)
            ScreenToFront(scr)
            ActivateWindow(win)

            CurrentTime({startsec}, {startmic})
            frame_count := 0

            FOR i:=0 TO NUM_FRAMES

              FOR step := 0 TO 10
                x := rangeRand(WIDTH)
                y := rangeRand(HEIGHT)
                c := rangeRand(16)
                Cp_WritePixel(context, x, y, c)
              ENDFOR

              update(buffer, chunky, dx, dy)

              -> change chunky buffer source
              error := Cp_SetContextParameter(context, C2P_CONTEXT_PARAMETER_CHUNKY, buffer)
              IF error <> 0 THEN JUMP end_loop

              -> swap for next round
              swap := chunky
              chunky := buffer
              buffer := swap

              WaitTOF()
              Cp_Chunky2Planar(context)

              INC frame_count
            ENDFOR
end_loop:
            CurrentTime({seconds}, {micros})
            seconds := seconds - startsec
            WriteF('Total time = \d seconds -> ', seconds)
            fps := frame_count! / (seconds!)
            WriteF('\s frame per second...\n', RealF(fps_str, fps, 3))

            CloseWindow(win)
          ENDIF

          CloseScreen(scr)
        ENDIF

      ENDIF

destroy_context:
      Cp_DestroyContext(context)
    ENDIF
  ENDIF

  IF error <> 0
    WriteF('Got error: \d\n', error)
  ENDIF

ENDPROC





PROC setPalette(vp : PTR TO viewport)
  DEF i : LONG
  DEF r, g, b : LONG

  FOR i := 0 TO 15
    r := i
    g := Max(0, i - 1)
    b := i / 4
    SetRGB4(vp, i, r, g, b)
  ENDFOR

ENDPROC





PROC update(buffer : PTR TO CHAR, chunky : PTR TO CHAR, dx : PTR TO LONG, dy : PTR TO LONG)
  DEF x, y : LONG
  DEF c : LONG
  DEF buffer_row : PTR TO CHAR
  DEF chunky_row : PTR TO CHAR
  DEF row : PTR TO CHAR
  DEF middle : LONG

  buffer_row := buffer
  chunky_row := chunky

  FOR y := 0 TO HEIGHT - 1
    row := chunky_row + (dy[y] * WIDTH)

    FOR x := 0 TO WIDTH - 1
      c := row[x + dx[x]]
      buffer_row[x] := c
    ENDFOR

    buffer_row := buffer_row + WIDTH
    chunky_row := chunky_row + WIDTH
  ENDFOR

  middle := (WIDTH / 2) -1
  row := buffer + (WIDTH * ((HEIGHT / 2) - 1)) + middle
  row[0] := 0
  row[1] := 0
  row := row + WIDTH
  row[0] := 0
  row[1] := 0

ENDPROC

