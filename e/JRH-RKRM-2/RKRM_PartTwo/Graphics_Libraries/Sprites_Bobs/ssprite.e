-> ssprite.e - Simple Sprite example

->>> Header (globals)
OPT PREPROCESS

MODULE 'dos/dos',
       'exec/memory',
       'graphics/gfx',
       'graphics/gfxmacros',
       'graphics/sprite',
       'graphics/view',
       'hardware/custom',
       'hardware/dmabits',
       'intuition/screens'

ENUM ERR_NONE, ERR_KICK, ERR_SCRN, ERR_SPRT

RAISE ERR_KICK IF KickVersion()=FALSE,
      ERR_SCRN IF OpenScreenTagList()=NIL,
      ERR_SPRT IF GetSprite()=-1

DEF sprite_data
->>>

->>> PROC main()
PROC main() HANDLE
  DEF sprite:simplesprite, viewport, sprite_num=-1, delta_move, ktr1, ktr2,
      colour_reg, screen=NIL:PTR TO screen
  KickVersion(37)
  screen:=OpenScreenTagList(NIL, NIL)
  viewport:=screen.viewport
  sprite_num:=GetSprite(sprite, 2)

  -> Calculate the correct base colour register number,
  -> set up the colour registers.
  colour_reg:=16+((sprite_num AND $06)*2)
  WriteF('colour_reg=\d\n', colour_reg)
  SetRGB4(viewport, colour_reg+1, 12,  3,  8)
  SetRGB4(viewport, colour_reg+2, 13, 13, 13)
  SetRGB4(viewport, colour_reg+3,  4,  4, 15)

  sprite.x:=0  -> Initialise position and size info to match that shown in
  sprite.y:=0  -> sprite_data so system knows layout of data later.
  sprite.height:=9

  -> E-Note: data is really a lot of LONGs
  sprite_data:=copyListToChip([0,          -> Position control
                               $ffff0000,  -> Image data line 1, color 1
                               $ffff0000,  -> Image data line 2, color 1
                               $0000ffff,  -> Image data line 3, color 2
                               $0000ffff,  -> Image data line 4, color 2
                               $00000000,  -> Image data line 5, transparent
                               $0000ffff,  -> Image data line 6, color 2
                               $0000ffff,  -> Image data line 7, color 2
                               $ffffffff,  -> Image data line 8, color 3
                               $ffffffff,  -> Image data line 9, color 3
                               0])         -> Reserved, must init to 0

  -> Install sprite data and move sprite to start position.
  ChangeSprite(viewport, sprite, sprite_data)
  MoveSprite(viewport, sprite, 30, 0)

  -> Move the sprite back and forth.
  delta_move:=1
  FOR ktr1:=0 TO 5
    FOR ktr2:=0 TO 99
      MoveSprite(viewport, sprite, sprite.x+delta_move, sprite.y+delta_move)
      WaitTOF()  -> One move per video frame.

      -> Show the effect of turning off sprite DMA.
      IF ktr2=40 THEN OFF_SPRITE
      IF ktr2=60 THEN ON_SPRITE
    ENDFOR
    delta_move:=-delta_move
  ENDFOR

  -> Note: if you turn off the sprite at the wrong time (when it is being
  -> displayed), the sprite will appear as a vertical bar on the screen.
  -> To really get rid of the sprite, you must OFF_SPRITE while it is not
  -> displayed.  This is hard in a multi-tasking system (the solution is not
  -> addressed in this program).
  ON_SPRITE  -> Just to be sure

EXCEPT DO
  IF sprite_num<>-1 THEN FreeSprite(sprite_num)
  IF screen THEN CloseScreen(screen)
  SELECT exception
  CASE ERR_KICK;  WriteF('Error: requires V37\n')
  CASE ERR_SCRN;  WriteF('Error: could not open screen\n')
  CASE ERR_SPRT;  WriteF('Error: could not allocate a new sprite\n')
  ENDSELECT
ENDPROC IF exception<>ERR_NONE THEN RETURN_FAIL ELSE RETURN_OK
->>>

->>> PROC copyListToChip(data)
-> E-Note: get some Chip memory and copy list (quick, since LONG aligned)
PROC copyListToChip(data)
  DEF size, mem
  size:=ListLen(data)*SIZEOF LONG
  mem:=NewM(size, MEMF_CHIP)
  CopyMemQuick(data, mem, size)
ENDPROC mem
->>>
