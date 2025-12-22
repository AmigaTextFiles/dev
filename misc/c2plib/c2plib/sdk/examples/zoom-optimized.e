
/*
  This is an optimized version of zoom.e example, using a scrambled buffer.
  The main idea is to merge the scrambled offsets with the dx displacements,
  this save 1 memory read for each pixel.
  Another improvement is to creating a global displacement table, instead of
  dx and dy displacements arrays. This save another 1 memory read for each
  pixel.
  Eventually, the update loop is rewritten using AmigaE's assembler
  instructions. This speeds'up a lot, even if only MC68000 assembly language
  is recognized.
  Further optimizations may implements an assembly that use the MC68020+
  notation, loop unrolling and maybe reading 4 pixels and 4 displacements
  each time.
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
      USE_SCRAMBLED = TRUE,
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
  DEF displacements : PTR TO LONG
  DEF x, y, c : LONG
  DEF step : LONG
  DEF size : LONG
  DEF scrambled_count, mask : LONG
  DEF scrambled_offsets : PTR TO LONG
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
      IF USE_SCRAMBLED
        error := Cp_SetContextParameter(context, C2P_CONTEXT_PARAMETER_FORCE_SCRAMBLED, TRUE)
        IF error <> 0 THEN JUMP destroy_context
      ENDIF

      IF Cp_InitializeContext(context) = 0

        bitmap := Cp_GetContextParameter(context, C2P_CONTEXT_PARAMETER_BITMAP)
        chunky := Cp_GetContextParameter(context, C2P_CONTEXT_PARAMETER_CHUNKY)

        buffer := Cp_AllocMem(context, size)

        scrambled_count := Cp_GetContextParameter(context, C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSETS_COUNT)
        scrambled_offsets := Cp_AllocMem(context, scrambled_count * 4)
        FOR i := 0 TO scrambled_count - 1
          scrambled_offsets[i] := Cp_GetContextIndexedParameter(context, C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSET, i);
        ENDFOR
        mask := scrambled_count - 1

        -> delta initialization
        dx := Cp_AllocMem(context, WIDTH * 4)
        dy := Cp_AllocMem(context, HEIGHT * 4)
        displacements := Cp_AllocMem(context, size * 4)

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

        IF USE_SCRAMBLED
          -> add offsets displacements directly do delta x
          FOR i := 0 TO WIDTH - 1
            x := i + dx[i]
            step := scrambled_offsets[x AND mask]
            dx[i] := dx[i] + step
          ENDFOR
        ENDIF

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

        -> initialize displacements table
        FOR y := 0 TO HEIGHT - 1
          FOR x := 0 TO WIDTH - 1
            step := (x + dx[x]) + ((y + dy[y]) * WIDTH)
            IF USE_SCRAMBLED
              i := scrambled_offsets[x AND mask]
              displacements[x + i + (y * WIDTH)] := step
            ELSE
              displacements[x + (y * WIDTH)] := step
            ENDIF
          ENDFOR
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

              update(buffer, chunky, displacements, size)

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





PROC update(buffer : PTR TO CHAR, chunky : PTR TO CHAR, displacements : PTR TO LONG, size : LONG)
  DEF row : PTR TO CHAR
  DEF middle : LONG

/*
  FOR x := 0 TO size - 1
    offset := displacements[x]
    c := chunky[offset]
    buffer[x] := c
  ENDFOR
*/
  -> BEGIN assembly optimization

      MOVE.L      displacements,A0
      MOVE.L      chunky,A1
      MOVE.L      buffer,A2

  ->FOR x := 0 TO size - 1
      MOVE.L      size,D0
      SUBQ.L      #1,D0
loop:

    ->offset := displacements[x]
      MOVE.L      (A0)+,D1

    ->c := chunky[offset]
      MOVE.B      0(A1,D1.L),D2

    ->buffer[x] := c
      MOVE.B      D2,(A2)+

  ->ENDFOR
      SUBQ.L      #1,D0
      BGE.S       loop

  -> END assembly optimization


  middle := (WIDTH / 2) -1
  row := buffer + (WIDTH * ((HEIGHT / 2) - 1)) + middle
  row[0] := 0
  row[1] := 0
  row := row + WIDTH
  row[0] := 0
  row[1] := 0

ENDPROC

