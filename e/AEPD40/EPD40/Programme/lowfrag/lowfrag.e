/* LowFrag - patches AllocMem() and AllocVec(), trying to ease up
   memory fragmentation - version 1.2 */

/* Future ideas:

      Task filter list?
      Promote "MEMF_PUBLIC" allocations?

   -Safer removal (check if no-one patched over me before removing).
*/

MODULE 'exec/memory','dos/dos'


PROC main()
DEF oldfalloc,oldfallocvec
DEF limit

    IF StrLen(arg) >0
       limit:=Val(arg)
       IF (limit <10) OR (limit > 1000000)
          WriteF('Invalid value!\n')
          CleanUp(20)
       ENDIF
       PutLong({threshold},limit)
    ENDIF

    Forbid()     -> Protect our back.

-> Patch AllocMem()...

    IF oldfalloc:=SetFunction(execbase, $ff28, {newfalloc})
       PutLong({patchalloc}, oldfalloc)

-> ...and AllocVec().

       IF oldfallocvec:=SetFunction(execbase, $fd54, {newfallocvec})
          PutLong({patchallocvec}, oldfallocvec)

-> Return to normal.
          Permit()

-> Wait for CTRL-C.
          Wait(SIGBREAKF_CTRL_C)

-> Restoring the original vectors.   NOTE: Not safe - should check if no one
-> has done a SetFunction() over me!

          Forbid()
          SetFunction(execbase, $fd54, oldfallocvec)
       ENDIF
       SetFunction(execbase, $ff28, oldfalloc)
    ENDIF

    Permit()

ENDPROC


-> Storage for the threshold value
-> Default to 32 Kb.  This value seemed to be pretty good on my system.
threshold:
LONG 32768

-> Storage for the original vectors
patchalloc:
LONG 0

patchallocvec:
LONG 0


/* The new code, which will "promote" allocations when needed, before
   returning to the real AllocMem/AllocVec code. */

newfalloc:
  CMP.L threshold(PC), D0
  BGE exit2
  OR.L #MEMF_REVERSE, D1
exit2:
  MOVE.L patchalloc(PC), -(A7)
  RTS

newfallocvec:
  CMP.L threshold(PC), D0
  BGE exit1
  OR.L #MEMF_REVERSE, D1
exit1:
  MOVE.L patchallocvec(PC), -(A7)
  RTS


CHAR '$VER:lowfrag 1.2 (1.2.96) By Eric Sauvageau.',0
