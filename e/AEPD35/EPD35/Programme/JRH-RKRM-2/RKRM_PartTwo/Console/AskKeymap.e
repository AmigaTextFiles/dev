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
                               $ffff