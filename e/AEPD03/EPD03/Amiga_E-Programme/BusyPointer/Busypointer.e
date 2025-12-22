/*
   SetPointer() demo.  Compile and run.  Click left mouse button in window
   to see the Busy Pointer.  Click the right mouse button in window to quit.

   Eric, I have modified Dave's example to make the function that sets the
   pointer a little more reusable.  In order for it to work right some things
   must be considered:
   1.  In order for the pointer size calculation to work, pointerImage must
       be a List of INT.  Since E variables are even-byte aligned, and the
       pointer data are paired, we can use CopyMemQuick().  This is a bonus,
       but the gain is not significant with this small data size.
   2.  If you don't open your own window, then (I think) you must go through
       a lot of hassle to get a pointer to the Workbench window.  If anyone
       knows differently, please let us know.
   3.  You have to know a little about images in order to code them.  There
       are some utils out there to capture the pointer to C source code, or
       convert a brush to C source code.  You'll have to hunt for those.
       If you want a tutorial on how to construct image data, I might could 
       cook something up for you.  RKRMs discuss it, but rather tersely.
*/

MODULE 'exec/memory'
MODULE 'intuition/intuition'
MODULE 'intuition/screens'

CONST SIZEOF_INT = 2

PROC mySetPointer (win : PTR TO window,
                   pointerImage : PTR TO INT)
  /* NOTE: pointerImage CAN reside in any type of MEM. */
  DEF chipMem = NIL,
      sizePointer = 0
  sizePointer := ListLen (pointerImage) * SIZEOF_INT
  IF chipMem := AllocMem (sizePointer, MEMF_CHIP)
    CopyMemQuick (pointerImage, chipMem, sizePointer)
    SetPointer (win, chipMem, 16, 16, -6, 0)
    /*---------------------------------------*/
    /*--         DON'T do this!!!          --*/
    /*--  (SetPointer() does it for you.)  --*/
    /*--                                   --*/
    /*  FreeMem (pointerImage, sizePointer)  */
    /*--                                   --*/
    /*---------------------------------------*/
  ENDIF
ENDPROC

PROC main ()
  DEF myWin       = NIL,
      busyPointer = NIL : PTR TO INT
  IF myWin := OpenW (20, 20, 100, 100, 0, 0,
                     'BusyPointer', NIL, WBENCHSCREEN, NIL)
    busyPointer := [$0000, $0000,  /* Reserved, must be NULL */
                    $0400, $07c0,
                    $0000, $07c0,
                    $0100, $0380,
                    $0000, $07e0,
                    $07c0, $1ff8,
                    $1ff0, $3fec,
                    $3ff8, $7fde,
                    $3ff8, $7fbe,
                    $7ffc, $ff7f,
                    $7efc, $ffff,
                    $7ffc, $ffff,
                    $3ff8, $7ffe,
                    $3ff8, $7ffe,
                    $1ff0, $3ffc,
                    $07c0, $1ff8,
                    $0000, $07e0,
                    $0000, $0000] : INT  /* Reserved, must be NULL */
    mySetPointer (myWin, busyPointer)
    WHILE Mouse () <> 2 DO WaitTOF ()
    CloseW (myWin)
  ENDIF
ENDPROC
