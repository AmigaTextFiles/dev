/* shows/hides the mousepointer of an window
*/

OPT MODULE

MODULE 'exec/memory'

OBJECT min_spriteimage
  posct[2]:ARRAY OF INT
  data[32]:ARRAY OF INT     -> data[16][2] (16 row)
  reserved[2]:ARRAY OF INT
ENDOBJECT

DEF sprite:PTR TO min_spriteimage


/* switches the mousepointer off
** returns TRUE on success
*/
EXPORT PROC offMousePointer(win) HANDLE

  IF win

    -> first time? Allocate chip memory and copy the sprite datas
    IF sprite=NIL
      sprite:=NewM(SIZEOF min_spriteimage,MEMF_CHIP OR MEMF_CLEAR)
      ->BltClear(sprite,SIZEOF min_spriteimage,0)
    ENDIF

    SetPointer(win,sprite,16,16,-6,0)
    RETURN TRUE

  ENDIF

EXCEPT
  -> memory allocation failed
ENDPROC FALSE


/* switches mousepointer on
*/
EXPORT PROC onMousePointer(win)
  IF win THEN ClearPointer(win)
ENDPROC


