(*
(****** LockWindow/--AMOK-Header-- ******************************************

:Program.    LockWindow.mod
:Author.     Albert Weinert [awn], Kai Bolai [kai],
:Author.     hartmut Goebel [hG], Oliver Knorr [olk]
:Version.    $VER: LockWindow.mod 1.4 (16.2.95)
:Copyright.  Freeware
:Language.   Oberon
:Translator. Amiga Oberon 3.11
:Contents.   Procedures for setting a "busy"-mousepointer and for "locking"
:Contents.   windows, so all user input is blocked.

*****************************************************************************
*
*)
*)

MODULE LockWindow;

(****** LockWindow/--background-- *******************************************
*
*       The "User Interface Style Guide" (UISG) suggests that the user
*       should be informed when a window can temporary not accept any
*       input. The most simple possibility is to use a "busy" mouse-pointer.
*       A "busy"-pointer has a special look defined in the UISG.
*
*       This module gives you one set of procedures to set and remove
*       only the busy-pointer and another to both change the mouse-pointer
*       and block all user input by opening an invisible Intuition
*       Requester.
*
*****************************************************************************
*
*)

(****** LockWindow/--history-- **********************************************
*
*   V1.4   : 16-Feb-1995 [olk]
*       UnlockWindow() uses ClearWaitPointer() instead of I.ClearPointer().
*       All procedures now check for NIL-pointers.
*       Documentation revised and translated to English.
*
*   V1.3   : 24-Sep-1993 [awn]
*       New documentation in AutoDoc-Format.
*
*   V1.2   : 19-Sep-1993 [hG] (based on V1.1)
*       LockWindow() now uses SYSTEM.ALLOCATE().
*       Under V39+ the default BusyPointer is used.
*       Now works with garbage collector.
*       Needs V39 Interfaces.
*
*   V1.1.1 : ??-???-???? [kai]
*       Under V39+ the default BusyPointer is used.
*
*   V1.1   : 19-Aug-1992 [awn]
*       Mouse-pointer setting has been moved to separate Procedures.
*
*   V1.0   : 02-Aug-1992 [awn]
*       First working version.
*
*****************************************************************************
*
*)


IMPORT
  I * := Intuition,
  u := Utility,
  SYSTEM;

TYPE
  sprite = ARRAY 36 OF INTEGER;

(* $DataChip+ *)
CONST
  waitPointer = sprite(
    00000H, 00000U,
    00400H, 007C0U,
    00000H, 007C0U,
    00100H, 00380U,
    00000H, 007E0U,
    007C0H, 01FF8U,
    01FF0H, 03FECU,
    03FF8H, 07FDEU,
    03FF8H, 07FBEU,
    07FFCH, 0FF7FU,
    07EFCH, 0FFFFU,
    07FFCH, 0FFFFU,
    03FF8H, 07FFEU,
    03FF8H, 07FFEU,
    01FF0H, 03FFCU,
    007C0H, 01FF8U,
    00000H, 007E0U,
    00000H, 00000H);             (* reserved, must be NULL *)
(* $DataChip- *)


(****** LockWindow/SetWaitPointer *******************************************
*
*   NAME
*       SetWaitPointer -- set a window's mouse-pointer to "busy"-state
*
*   SYNOPSIS
*       SetWaitPointer (window: I.WindowPtr)
*
*   FUNCTION
*       Changes the look of an Intuition Window's mouse-pointer to "busy".
*
*   INPUTS
*       window = Intuition Window that shall get a "busy" mouse-pointer.
*
*   NOTES
*       Running und Intuition V39 or higher, the busy-pointer defined in
*       preferences will be used. Under ealier versions, the busy-pointer
*       suggested by the UISG (a clock) will be used.
*
*       This Procedure only changes the mouse-pointer look, input is *not*
*       blocked by this.
*
*   SEE ALSO
*       ClearWaitPointer(), LockWindow()
*
*****************************************************************************
*
*)

  PROCEDURE SetWaitPointer * (window: I.WindowPtr);

    BEGIN
      IF window # NIL THEN
        IF I.int.libNode.version >= 39 THEN
          I.SetWindowPointer(window, I.waBusyPointer,  I.LTRUE,
                                     I.waPointerDelay, I.LTRUE,
                                     u.done, 0)
        ELSE
          I.SetPointer(window, waitPointer, 16, 16, -6, 0)
        END
      END
    END SetWaitPointer;


(****** LockWindow/ClearWaitPointer *****************************************
*
*   NAME
*       ClearWaitPointer -- set a window's mouse-pointer to "normal"-state
*
*   SYNOPSIS
*       ClearWaitPointer (window: I.WindowPtr)
*
*   FUNCTION
*       Removes the "busy" mouse-pointer from a window.
*
*   INPUTS
*       window = Intuition Window that shall get a "normal" mouse-pointer,
*                as defined in preferences.
*
*   NOTES
*
*   SEE ALSO
*       SetWaitPointer()
*
*****************************************************************************
*
*)

  PROCEDURE ClearWaitPointer * (window: I.WindowPtr);

    BEGIN
      IF window # NIL THEN
        IF I.int.libNode.version >= 39 THEN I.SetWindowPointer(window, u.done, 0)
                                       ELSE I.ClearPointer(window) END
      END
    END ClearWaitPointer;


(****** LockWindow/LockWindow ***********************************************
*
*   NAME
*       LockWindow -- lock an Intuition Window
*
*   SYNOPSIS
*       LockWindow (window: I.WindowPtr): I.RequesterPtr
*
*   FUNCTION
*       Locks an Intuition Window by opening an invisible Requester,
*       so all user input is completely blocked. To give the user a visible
*       hint for this, the mouse-pointer is set to "busy"-look with
*       SetWaitPointer().
*
*   INPUTS
*       window = Intuition Window that shall be locked
*
*   RESULTS
*       Pointer to the invisible Intuition Requester. Use it to
*       unlock the Window again.
*
*   EXAMPLE
*
*       MODULE Test.
*
*       IMPORT lw := LockWindow,
*              I  := Intuition,
*
*       VAR req: I.RequesterPtr;
*           win: I.WindowPtr;
*
*       BEGIN
*         [......]
*         req := lw.LockWindow( win );
*         [......]
*         lw.UnlockWindow( req );
*       END Test.
*
*   NOTES
*
*   BUGS
*       The size-gadget of a locked window (if it has one) can still be
*       used. So please mind that the user might have changed the window
*       size while it was locked.
*
*   SEE ALSO
*       UnlockWindow(), SetWaitPointer(), Intuition/Request()
*
*****************************************************************************
*
*)

  PROCEDURE LockWindow * (window: I.WindowPtr): I.RequesterPtr;

    VAR
      req: I.RequesterPtr;

    BEGIN
      IF window = NIL THEN RETURN NIL END;
      SYSTEM.ALLOCATE(req);
      IF (req # NIL) THEN
        IF I.Request(req,window) THEN
          SetWaitPointer(window)
        ELSE
          (* $IFNOT GarbageCollector *)
            DISPOSE(req);
          (* $END *)
            req := NIL
        END
      END;
      RETURN req
    END LockWindow;


(****** LockWindow/UnlockWindow *********************************************
*
*   NAME
*       UnlockWindow -- unlock an Intuition Window
*
*   SYNOPSIS
*       UnlockWindow (VAR req: I.RequesterPtr)
*
*   FUNCTION
*       Unlocks a window that has been locked with LockWindow() and
*       restores the normal mouse-pointer.
*
*   INPUTS
*       req = Pointer to the Requester returned by LockWindow().
*
*   NOTES
*
*   SEE ALSO
*       LockWindow(), ClearWaitPointer()
*
*****************************************************************************
*
*)

  PROCEDURE UnlockWindow * (VAR req: I.RequesterPtr);

    BEGIN
      IF req # NIL THEN
        ClearWaitPointer(req.rWindow);
        I.EndRequest(req,req.rWindow);
        (* $IFNOT GarbageCollector *)
          DISPOSE(req);
        (* $END *)
        req := NIL
      END
    END UnlockWindow;


END LockWindow.
