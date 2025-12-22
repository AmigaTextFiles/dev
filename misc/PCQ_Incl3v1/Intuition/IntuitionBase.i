{ IntuitionBase.i }

{$I   "Include:Exec/Libraries.i"}
{$I   "Include:Intuition/Intuition.i"}
{$I   "Include:Exec/Interrupts.i"}
{$I   "Include:Exec/Types.i"}

{ these are the display modes for which we have corresponding parameter
 *  settings in the config arrays
 }
CONST
 DMODECOUNT    =  $0002;  { how many modes there are }
 HIRESPICK     =  $0000;
 LOWRESPICK    =  $0001;

 EVENTMAX = 10;             { size of event array }

{ these are the system Gadget defines }
 RESCOUNT       = 2;
 HIRESGADGET    = 0;
 LOWRESGADGET   = 1;

 GADGETCOUNT    = 8;
 UPFRONTGADGET  = 0;
 DOWNBACKGADGET = 1;
 SIZEGADGET     = 2;
 CLOSEGADGET    = 3;
 DRAGGADGET     = 4;
 SUPFRONTGADGET = 5;
 SDOWNBACKGADGET= 6;
 SDRAGGADGET    = 7;



{ ======================================================================== }
{ === IntuitionBase ====================================================== }
{ ======================================================================== }
{
 * Be sure to protect yourself against someone modifying these data as
 * you look at them.  This is done by calling:
 *
 * lock = LockIBase(0), which returns an Integer.  When done call
 * UnlockIBase(lock) where lock is what LockIBase() returned.
 }

Type

    IntuitionBase = record
{ IntuitionBase should never be directly modified by programs   }
{ even a little bit, guys/gals; do you hear me? }

        LibNode         : Library;

        ViewLord        : View;

        ActiveWindow    : WindowPtr;
        ActiveScreen    : ScreenPtr;

    { the FirstScreen variable points to the frontmost Screen.   Screens are
     * then maintained in a front to back order using Screen.NextScreen
     }

        FirstScreen     : ScreenPtr;    { for linked list of all screens }

        Flags           : Integer;      { see definitions below }
        MouseY,
        MouseX          : Short;        { mouse position relative to View }

        Seconds         : Integer;      { timestamp of most current input event }
        Micros          : Integer;      { timestamp of most current input event }

    { I told you this was private.
     * The data beyond this point has changed, is changing, and
     * will continue to change.
     }

    end;
    IntuitionBasePtr = ^IntuitionBase;


