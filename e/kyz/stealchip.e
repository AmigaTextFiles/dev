-> 'Steal' an area of low memory, ie make a copy without causing
-> enforcer hits or otherwise annoying the MMU

-> error := stealchip(chip_addr, anywhere, size)
-> will copy [size] bytes from [chip_addr] to [anywhere].
-> will return zero if operation succeeded, or non-zero on failure.
-> NOTES:
-> - [chip_addr], [anywhere] and [size] be even values, or they
->   will be rounded down
-> - [chip_addr] MUST be in chip memory.
-> - function requires the blitter, and some chip memory

OPT MODULE, PREPROCESS

MODULE 'exec/memory', 'hardware/blit', 'hardware/custom', 'hardware/dmabits'

-> error codes
EXPORT CONST STEAL_OK=0, STEAL_NOTCHIP=-1, STEAL_NOMEM=-2, STEAL_OVERLAP=-3


EXPORT PROC stealchip(src, dst, len)
  DEF c=CUSTOMADDR:PTR TO custom, mem=NIL, sze

  src := src AND -2  -> ensure even addresses
  dst := dst AND -2
  len := len AND -2

  -> ensure src is in chip memory
  IF src > 1024 THEN IF (TypeOfMem(src) AND MEMF_CHIP) = 0 THEN
    RETURN STEAL_NOTCHIP

  -> if dst isn't in chip, then we need a buffer for it
  IF (TypeOfMem(dst) AND MEMF_CHIP) = 0
    IF (mem := AllocMem(1024, MEMF_CHIP)) = NIL THEN RETURN STEAL_NOMEM
  ENDIF

  -> if src and dst now overlap, we cannot perform the operation
  IF overlap(
    src, IF mem THEN mem  ELSE dst,
    len, IF mem THEN 1024 ELSE len
  ) THEN RETURN STEAL_OVERLAP

  OwnBlitter()
  WaitBlit()

  -> A to D copy, no mask, no shift. A=src, D=dst
  c.dmacon  := DMAF_SETCLR OR DMAF_MASTER OR DMAF_BLITTER
  c.bltcon0 := BC0F_SRCA OR BC0F_DEST OR A_TO_D
  c.bltcon1 := 0
  c.bltafwm := -1
  c.bltalwm := -1
  c.bltamod := 0
  c.bltdmod := 0

  WHILE len
    -> copy-loop. Copy 1k at a time, until last copy of <=1k
    sze := IF len > 1024 THEN 1024 ELSE len

    c.bltapt  := src
    c.bltdpt  := IF mem THEN mem ELSE dst
    c.bltsize := Shl(sze, 5) + 1 -> (sze/2)<<6 + 1
    WaitBlit()
    IF mem THEN CopyMem(mem, dst, sze)

    src := src + sze
    dst := dst + sze
    len := len - sze
  ENDWHILE

  DisownBlitter()
  IF mem THEN FreeMem(mem, 1024)
ENDPROC STEAL_OK


-> returns true if x->(x+xl) overlaps y->(y+yl)
PROC overlap(x, y, xl, yl) IS
  IF x = y THEN TRUE ELSE IF x > y THEN (y+yl) > x ELSE (x+xl) > y
