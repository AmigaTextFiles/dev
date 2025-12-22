\ String Art Demo by Mark Hellman
\ Copyright 1991, 1994 by M.V.Micro
\
\ This demo is designed to show how to use the Amiga system interface
\ provided by JAX4TH
\
\ This was possibly the first working application written in dpANS Forth

: TASK-DEMO ;

VARIABLE INTUILIB   \ Intuition Lib Base Ptr
VARIABLE GRAPHLIB   \ Graphics Lib Base Ptr

VARIABLE CurWindow     \ Current Window
VARIABLE CurRastPort   \ ABSAddr of Rastport for current Window

: IF>REL ( ABSAddr | 0 -- RELAddr | 0 )
   DUP IF ABS>DATA THEN
;

: IF>ABS ( RELAddr | 0 -- ABSAddr | 0 )
   DUP IF DATA>ABS THEN
;

\ Exec.lib support

: OpenLib() ( 0LibName -- ABSBase | 0, Opens an Amiga Libary )
   IF>ABS 1 >AREG -408 EXEC CALL
;

: CloseLib() ( ABSLibPtr -- , Closes an Amiga Libary )
   1 >AREG -414 EXEC CALL
;

: GetMsg() ( RELPort -- RELMsg | 0, Gets a message from a port if one available )
   IF>ABS 0 >AREG -372 EXEC CALL IF>REL
;

: ReplyMsg() ( RELMsg -- , Replys to a received message )
   IF>ABS 1 >AREG -378 EXEC CALL DROP
;

\ Intuition.lib support

: OpenWindow() ( RELNewWindow -- RELWindow | 0, Opens a window )
   IF>ABS 0 >AREG -204 INTUILIB CALL IF>REL
;

: CloseWindow() ( RELWindow -- , Close a window )
   IF>ABS 0 >AREG -72 INTUILIB CALL DROP
;

\ Graphics.lib support

: Move() ( ABSRastPort X Y -- , Move graphics cursor to X,Y )
   1 >DREG 0 >DREG 1 >AREG -240 GRAPHLIB CALL DROP
;

: Draw() ( ABSRastPort X Y -- , Draw with graphics cursor to X,Y )
   1 >DREG 0 >DREG 1 >AREG -246 GRAPHLIB CALL DROP
;

: SetAPen() ( ABSRastPort Pen -- , Set graphics cursor Pen color  )
   0 >DREG 1 >AREG -342 GRAPHLIB CALL DROP
;

: SetDrMd() ( ABSRastPort DrawMode -- , Set graphics cursor Drawing mode )
   0 >DREG 1 >AREG -354 GRAPHLIB CALL DROP
;


\ Simple 'High Level' support for graphics

: gr.Move ( X Y -- , Move graphics cursor to X.y )
   CurRastPort @ -ROT Move()
;

: gr.Draw ( X Y -- , Draw to X.Y )
   CurRastPort @ -ROT Draw()
;

: gr.SetAPen ( Color -- , Set the Apen to Color )
   CurRastPort @ SWAP SetAPen()
;

: gr.SetDrawMode ( Mode -- , Set the current draw mode )
   CurRastPort @ SWAP SetDrMd()
;

: gr.CloseCurWin ( -- )
   CurWindow @ ?DUP IF CloseWindow() 0 CurWindow ! THEN
;


CREATE (GraphLibName) ," graphics.library" 0 w,
CREATE (IntuiLibName) ," intuition.library" 0 w,
CREATE (WindowName)   ," Jax4th 'String Art' by Mark Hellman" 0 w,

: GraphLibName ( -- 0Name )   (GraphLibName) 1+ ;
: IntuiLibName ( -- 0Name )   (IntuiLibName) 1+ ;
: WindowName   ( -- 0Name )   (WindowName) 1+ ;

\ This Doesn't work!

\ CREATE MyWindow  \ This is  the Default NewWindow structure
\    320 w, 20 w,  \ window XY origin relative to TopLeft of screen
\    320 w, 170 w, \ window width and height
\    0 c, 1 c,     \ detail and block pens
\    512 ,         \ IDCMP flags - CLOSEWINDOW
\    8 ,           \ other window flags - WINDOWCLOSE
\    0 ,           \ first gadget in gadget list
\    0 ,           \ custom CHECKMARK imagery
\    0 ,           \ window title
\    0 ,           \ custom screen pointer
\    0 ,           \ custom bitmap
\    5 w, 5 w,     \ minimum width and height
\    -1 w, -1 w,   \ maximum width and height
\    1 w,          \ destination screen type - WBENCHSCREEN


CREATE MyWindow  48 ALLOT   \ This is  the Default NewWindow structure

: Init.NewWindow ( -- )
   MyWindow
   320 OVER     W! 20  OVER 2 + W!
   320 OVER 4 + W! 170 OVER 6 + W!
   0   OVER 8 + C! 1   OVER 9 + C!
   512 OVER 10 + !
   8   OVER 14 + !
   0   OVER 18 + !
   0   OVER 22 + !
   WindowName DATA>ABS OVER 26 + !
   0   OVER 30 + !
   0   OVER 34 + !
   5   OVER 38 + W! 5  OVER 40 + W!
   -1  OVER 42 + W! -1 OVER 44 + W!
   1   SWAP 46 + W!
;

: Close.Sys ( -- , Frees open stuff )
   CurWindow @ ?DUP IF CloseWindow() 0 DUP CurWindow ! CurRastPort ! THEN
   INTUILIB @ ?DUP IF CloseLib() 0 INTUILIB ! THEN
   GRAPHLIB @ ?DUP IF CloseLib() 0 GRAPHLIB ! THEN
;

: Init.Sys ( --  Opens the Intuition.lib, Graphics.libs and window )
   Init.NewWindow
   IntuiLibName OpenLib() DUP 0 = ABORT" Open Intui FAILED" INTUILIB !
   GraphLibName OpenLib() DUP 0 = ABORT" Open Graph FAILED" GRAPHLIB !
   MyWindow OpenWindow() DUP 0 = ABORT" Open Window FAILED"
   DUP CurWindow !
   50 + @ CurRastPort !
   0 gr.SetDrawMode 1 gr.SetAPen
;

: ?CloseBox ( -- Flag, Checks if Close Box Hit )
   CurWindow @ 86 + @ ABS>DATA GetMsg() DUP IF DUP ReplyMsg() THEN
;

VARIABLE X1        0 X1 !         \ Current Start X
VARIABLE Y1        10 Y1 !         \ Current Start Y
VARIABLE X2        0 X2 !         \ Current End X
VARIABLE Y2        170 Y2 !       \ Current End Y
VARIABLE CurColor  1 CurColor !   \ Current Color

: Phase1
   32 0 DO X1 @ Y1 @ gr.Move X2 @ Y2 @ gr.Draw 5 Y1 +! 10 X2 +! LOOP
;

: Phase2
   32 0 DO X1 @ Y1 @ gr.Move X2 @ Y2 @ gr.Draw 10 X1 +! Y2 @ 5 - Y2 ! LOOP
;

: Phase3
   32 0 DO X1 @ Y1 @ gr.Move X2 @ Y2 @ gr.Draw Y1 @ 5 - Y1 ! X2 @ 10 - X2 ! LOOP
;

: Phase4
   32 0 DO X1 @ Y1 @ gr.Move X2 @ Y2 @ gr.Draw X1 @ 10 - X1 ! 5 Y2 +! LOOP
;

: DrawWin
   Phase1 Phase2 Phase3 Phase4
;

: IncColor
   CurColor @ 1+ 3 AND ?DUP 0 = IF 1 THEN
   DUP CurColor ! gr.SetAPen
;

: Demo ( -- )
   Init.Sys
   BEGIN DrawWin IncColor ?CloseBox UNTIL
   Close.Sys
;

: MyText ." Enter 'Demo' for a show" cr ;

MyText
