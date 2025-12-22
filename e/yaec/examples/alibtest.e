
/* example of using an amigalib function */

MODULE 'amigalib'

PROC main()
   DEF a, seed=$F0987601
   FOR a := 0 TO 100 DO WriteF('random val = \d\n', seed := FastRand(seed))
ENDPROC
