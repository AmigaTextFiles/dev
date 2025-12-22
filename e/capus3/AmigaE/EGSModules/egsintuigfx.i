    IFND    EGS_EGSINTUIGFX_I
EGS_EGSINTUIGFX_I     SET     1
*\
*  $
*  $ FILE     : egsintuigfx.i
*  $ VERSION  : 1
*  $ REVISION : 2
*  $ DATE     : 02-Feb-93 22:52
*  $
*  $ Author   : mvk
*  $
*
*
* (c) Copyright 1990/93 VIONA Development
*     All Rights Reserved
*
*\
    IFND    EGS_EGSGFX_I
    INCLUDE "egsgfx.i"
    ENDC

*
*  To make rendering of graphics in windows, menus and gadgets as flexible,
*  efficient and powerful as possible, the ESGIntui library has an inter-
*  preter that executes programs of a simple stack graphics language.
*
*  Programs in this language are used for all EGSIntui graphics such as
*  gadgets, menus and "requesters".  As the language knows subroutines with
*  parameters, this technique is much more flexible than the known one
*  with separate border, text and image lists.
*
*   Examples:
*
*    - If you need similar shadowed text for requesters or menus you need to
*      define only one such procedure.  Then you call it each time you need
*      that text with the string as parameter.
*
*    - For gadgets with three-dimensional borders it is sufficient to program
*      that border only once since the EGSIntui library passes over the
*      position and size for the .select and .release graphics of requesters
*      and menus.
*
*    - If you need the same element for some graphics, e.g. colour selection
*      requesters, these can be rendered by a program loop.
*
*    - Frequently used graphics elements can be collected in a module and be
*      reused again and again.
*
*    - As you have access to the standard colours of a window (screen) from
*      inside an IntuiGfx program, the same requesters can be used for
*      different bit depths and colour palettes without change.
*
*    - As gadgets or menue elements may vary in size, according to the used
*      font and/or language, functions for rescalable images are supported.
*
*

*
*  WinColors
*
*  To give requesters etc. an optimal colouring even for different bit depths,
*  for each screen (or window) a structure is defined that contains the usual
*  colours with their values.  These colours can be accessed from IntuiGfx
*  programs.  Moreover, the colours are used in (string) gadgets.
*
*  .Light     : A light coulour for 3D structures.
*  .Normal    : The colour of a non-selected object.
*  .Dark      : A dark colour for shadow effects.
*  .Select    : The colour of a selected object.
*  .Back      : A window's background colour.
*  .TxtFront  : Colour for text.
*  .TxtBack   : Background colour for text.
*
 STRUCTURE  IGWinColors,0
    LONG    igwc_Light
    LONG    igwc_Normal
    LONG    igwc_Dark
    LONG    igwc_Select
    LONG    igwc_Back
    LONG    igwc_TxtFront
    LONG    igwc_TxtBack
    LABEL   igwc_SIZEOF

*
*  An IntuiGfx program consists of an array of long words containing con-
*  stants, addresses or commands.  Commands and constants differ from addresses
*  in that their highest bit is set (even Commodore uses this high-bit so
*  that no compatibility problems should occur).  The end of a program is
*  specified by the special command "RTS" or "RTF+...".
*
*  The language is stack oriented, i.e. commands and procedures always refer
*  to parameters pushed onto the stack.  Besides the stack pointer (SP) there
*  exists a frame pointer (FP) that addresses parameters and local variables.
*  By the command "FRAME" this variable range can be increased.
*
*  For many commands needing constant data that data is simply added to the
*  command token.
*
*  The stack works with predecrement (PUSH) and postincrement (POP) so that
*  older elements are addressed with positive displacements.
*
*  All commands returning a value pass it on the stack, likewise all commands
*  and procedures expect their parameters on the stack and deallocate them
*  automatically.
*
*  All graphics coordinates in an IntuiGfx program regard the graphics cursor
*  position at the beginning of the procedure as origin.  The interpreter
*  can be invoked with parameters that are passed on the stack as usual.
*  EGSIntui does this too, e.g. for .active and .release calls for gadgets
*  and menus.
*
*  The normal parameters for intui structures as gadgets or menues is
*  (width, height).
*
* ###########################################################################
*
*  Command overview:
*
*
*  (1). Stack and frame specific commands
*
*
*   POP   : Removes the topmost stack element.
*           INC(SP)
*
*   POPN  : Removes the number of stack element as specified by SP[0].
*           INC(SP,SP[0]+1)
*
*   DUP   : Duplicates the topmost stack element.
*           SP-^:=SP[0]
*
*   DUPN  : Duplicates as many elements as specified by SP[0].
*           x:=SP+^;SP-^:=SP[0..x]
*
*   DUPI  : Duplicates as many elements as specified by DUPI.
*           x:='DUPI';SP-^:=SP[0..x]
*
*   SWAP  : Swaps the two topmost stack elements.
*           PS[1] <-> SP[0];
*
*   ROT3  : Rotates the topmost three elements.
*           SP[2] -> SP[0] -> SP[1] -> SP[2]
*
*   ROTN  : Rotates as many elements as specified by SP[0].
*           x:=SP+^;SP[x] -> SP[0] -> SP[1] -...-> SP[x]
*
*   BYTE  : Reads a byte from the memory address SP^.
*           SP[0]:=BytePtr(SP[0])^
*
*   VAL   : Reads a word from the memory address SP^.
*           SP[0]:=IntPtr(SP[0])^
*
*   ADR   : Reads a long word from the memory address SP^.
*           SP[0]:=LongPtr(SP[0])^
*
*  There are also POKE commands for byte, word and long (see below) !
*
*   GET1  : Gets the second stack element.
*           SP-^:=SP[1]
*
*   GET2  : Gets the third stack element.
*           SP-^:=SP[2]
*
*   GETN  : Gets the SP[0]'th stack element.
*           SP[0]:=SP[SP[0]+1]
*
*   GETSI : Gets the stack element specified by GETSI.
*           SP-^:=SP['GETSI']
*
*   GETF  : Gets the SP[0]'th stack element.
*           SP[0]:=FP[SP[0]]
*
*   GETFI : Get the frame element specified by GETFI.
*           SP-^:=FP['GETFI']
*
*   PUTF  : Writes SP[1] to the frame element specified by SP[0].
*           FP[SP[0]]:=SP[1];INC(SP,2)
*
*   PUTFI : Writes SP[0] to the frame element specified by PUTFI.
*           FP['PUTFI']:=SP[0];INC(SP)
*
*   Const : Pushes a constant onto the stack.
*           SP-^:='Const'
*
*   Const24:Pushes the constant in Const24 shifted left by eight bits onto
*           the stack (for 24 bit colours).
*           SP-^:='Const24' SHL 8
*
*   STKADR: Pushes the actual value of the stackpointer onto the stack.
*           SP-^:=SP;
*
*  (2). Arithmetic and logic commands
*
*
*   ADD   : Adds the two topmost stack elements.
*           SP[1]:=SP[1]+SP[0];INC(SP)
*
*   ADDI  : Adds the ADDI constant to SP[0].
*           SP[0]:=SP[0]+'ADDI'
*
*   SUB   : Subtracts the first stack element from the second.
*           SP[1]:=SP[1]-SP[0];INC(SP)
*
*   NEG   : Negates the topmost stack element.
*           SP[0]:=-SP[0]
*
*   MUL   : Multiplies the two topmost stack elements.
*           SP[1]:=SP[1]SP[0];INC(SP)
*
*   IDIV  : Divides the second stack element by the first.
*           SP[1]:=SP[1]/SP[0];INC(SP)
*
*   IMOD  : Divides the second stack element by the first and yields the
*           modulus of the operation.
*           SP[1]:=SP[1] mod SP[0];INC(SP)
*
*   SEQ   : Tests if SP[1] is equal to SP[0]; result -1 if true, else 0.
*           IF SP[1]=SP[0] THEN SP[1]:=-1 ELSE SP[1]:=0 END;INC(SP)
*
*   SNE   : Tests if SP[1] not equal to SP[0]; result -1 if true, else 0.
*           IF SP[1]#SP[0] THEN SP[1]:=-1 ELSE SP[1]:=0 END;INC(SP)
*
*   SGT   : Tests if SP[1] greater than SP[0]; result -1 if true, else 0.
*           IF SP[1]>SP[0] THEN SP[1]:=-1 ELSE SP[1]:=0 END;INC(SP)
*
*   SLT   : Tests if SP[1] less than SP[0].
*           IF SP[1]<SP[0] THEN SP[1]:=-1 ELSE SP[1]:=0 END;INC(SP)
*
*   SGE   : Tests if SP[1] greater or equal to SP[0].
*           IF SP[1]>=SP[0] THEN SP[1]:=-1 ELSE SP[1]:=0 END;INC(SP)
*
*   SLE   : Tests if SP[1] less or equal to SP[0].
*           IF SP[1]<=SP[0] THEN SP[1]:=-1 ELSE SP[1]:=0 END;INC(SP)
*
*   SNOT  : Result 0 if SP[0] not zero, else -1.
*           IF SP[0]=0 THEN SP[0]:=-1 ELSE SP[0]:=0 END;
*
*   SAND  : Result -1 if SP[0] and SP[1] are both not zero, else 0.
*           IF SP[0]#0 AND SP[1]#0 THEN SP[1]:=-1 ELSE SP[1]:=0 END;INC(SP)
*
*   SOR   : Result -1 if SP[0] or SP[1] is not zero, else 0.
*           IF SP[0]#0 OR SP[1]#0 THEN SP[1]:=-1 ELSE SP[1]:=0 END;INC(SP)
*
*
*  (3). Program control commands
*
*
*   JMP   : Jumps to the address SP[0].
*           PC:=SP[0];INC(SP)
*
*   RTS   : Return from a subroutine without frame deallocation.
*           POP(PC)
*
*   RTF   : Return form a subroutine with frame deallocation.
*           SP:=FP+'RTF';POP(PC)
*
*   JSR   : Calls a subroutine at the specified location.
*           PUSH(PC);PC:=SP[0];INC(SP)
*
*   While S1 Do S2 End : Executes program segments S1 and S2 as long as after
*                        S1 a value not equal to zero 0 is on the stack.
*                        Then that value is deallocated.
*
*   If S1 Else S2 End  : Executes S1 if for "If" a value not equal to zero
*                        is on the stack, else S2 is executed.  Then that
*                        value is deallocated.
*
*   Repeat S1 Until    : Executes S1 until then a value not equal to zero is
*                        on the stack.  Then that value is deallocated.
*
*
*  (4). Graphics commands
*
*
*   Color : Sets the current colour to the value in SP[0].
*           SetAPen(r,SP[0]);INC(SP)
*
*   Back  : Sets the background colour to the value in SP[0].
*           SetBPen(r,SP[0]);INC(SP)
*
*   ModeA : Sets drawing mode "drawAPen".
*           SetDrMd(r,drawAPen)
*
*   ModeAB: Sets drawing mode "drawABPen".
*           SetDrMd(r,drawABPen)
*
*   ModeInvers: Sets drawing mode "invert".
*           SetDrMd(r,invert)
*
*   Image : Copies the contents of a BitMap specified by SP[0] to the
*           current cursor position.
*           map:=BitMapPtr(SP[0]);INC(SP);
*           CopyBitMapRastPort(map,r,0,0,map.^width,map.^height,r^.cx,r^.cy);
*
*   Packed: Unpacks an image from bit plane form and copies it to the current
*           cursor position.
*           image:=ImagePtr(SP[0]);col:=ColorTablePtr(SP[1]);INC(SP,2);
*           IF UnpackImage(map,image^,r^.depth,col^) THEN
*             CopyBitMapRastPort(map'PTR,r,0,0,map.width,map.height...
*             DisposeBitMap(map)
*           END
*
*   Move  : Moves the graphics cursor by the distance in (SP[1],SP[0]).
*           INC(r^.cx,SP[1]);INC(r^.cy,SP[0]);INC(SP,2)
*
*   Locate: Sets the cursor to the position (SP[1],SP[0]).
*           Move(r,SP[1],SP[0]);INC(SP,2)
*
*   Locate00: Resets the cursor to the origion.
*             Move(r,0,0)
*
*   Draw  : Draws a line by (SP[1],SP[0]) relative from the cursor position.
*           Draw(r,r^.cx+SP[1],r^.cy+SP[0]);INC(SP,2);
*
*   DrawAbs:Draws a line from the cursor to the point (SP[1],SP[0]).
*           Draw(r,SP[1],SP[0]);INC(SP,2)
*
*   Box   : Draws a filled rectangle with width SP[1] and height SP[0].
*           RectangleFill(r,r^.cx,r^.cy,SP[1],SP[0]);INC(SP,2)
*
*   Box2d : Draws a rectangular border width width SP[1] and height SP[0].
*             Draw(rast,r.cx+SP[1]-1,r.cy);
*             Draw(rast,r.cx,r.cy+SP[0]-1);
*             Draw(rast,r.cx-SP[1]+1,r.cy);
*             Draw(rast,r.cx,r.cy-SP[0]+1);
*             DEC(SP,2);
*
*   Box3d : Draws a pseudo three dimensional rectangular border.
*           width SP[1], height SP[0], top left color SP[2] and bottom
*           right color SP[3];
*
*   Rect3d: Draws a pseudo three dimensional filled rectangular border.
*           width SP[1], height SP[0], top left color SP[2] and bottom
*           right color SP[3], interiour color SP[4];
*
*   Write : Writes text to the current cursor position.  SP[0] is the string
*           pointer.  The first byte contains the string length, followed
*           by the string characters.  ATTENTION:  This is a Cluster string !
*           Text(r,SP[0]^.data'PTR,SP[0]^.len);INC(SP)
*
*   Text  : Writes text to the current cursor position aus.  SP[0] is the
*           string pointer to a null-terminated string.  This procedure
*           should be used by C programmers.
*           Text(r,SP[0],Length(SP[0]^));
*
*   Font  : Sets an EFont given by SP[0].  SP[0] is the pointer to an opened
*           EFont.
*           r^.font:=EFontPtr(SP[0]);INC(SP)
*
*
*
*  (5). Graphics functions
*
*
*   GetPosX: Gets the current cursor X coordinate.
*            INC(SP);SP[0]:=r^.cx
*
*   GetPosY: Gets the current cursor Y coordinate.
*            INC(SP);SP[0]:=r^.cy;
*
*   GetColor: Gets the current drawing colour.
*             INC(SP);SP[0]:=r^.aPen
*
*   GetBack : Gets the current background colour.
*             INC(SP);SP[0]:=r^.bPen
*
*   CLight    : Gets the light window colour.
*   CNormal   : Gets the normale window border colour.
*   CDark     : Gets the dark window colour.
*   CSelect   : Gets the "selected" window colour.
*   CBack     : Gets the window background colour.
*   CTxtFront : Gets the recommended window text front colour.
*   CTxtBack  : Gets the recommenden window text background colour.
*
*   CTAGs     : Gets the value of a window color. The value of the command
*               is the same as that of the tag.
*
*
*  (6). Scaled functions
*
*   All scaled command work in a fixed coordinate space [0..4095]x[0..4095].
*   This coordinate space is translated to a selected rectangular area that
*   is specified by 'SetScale'.
*
*   SetScale  : Sets the rectangular area in which to work, width in SP[1]
*               and height in SP[0].
*   SetRatio  : Forces a ratio of SP[1]/SP[0], and changes the drawing
*               coordinates to fit inside the original area.
*
*   SMove     : Moves the graphiccursor by SP[1]/SP[0].
*   SLocate   : Moves the graphiccursor to SP[1]/SP[0].
*   SDraw     : Draws a line by SP[1]/SP[0].
*   SDrawAbs  : Draws a line to SP[1]/SP[0].
*   SCurve    : Draws a curve with SP[5]/SP[4] and SP[3]/SP[2] by SP[1]/SP[0]
*   SCurveAbs : Draws a curve with SP[5]/SP[4] and SP[3]/SP[2] to SP[1]/SP[0]
*   SEllipse  : Draws an ellipse with SP[1] as half the width, and
*               SP[0] as half the height. Drawn around the cursor.
*
*   SAMove    : Moves the graphiccursor by SP[1]/SP[0].
*   SALocate  : Moves the graphiccursor to SP[1]/SP[0].
*   SADraw    : Adds an edge to a polygon by SP[1]/SP[0].
*   SADrawAbs : Adds an edge to a polygon to SP[1]/SP[0].
*   SACurve   : Adds a curve to a filled object with SP[5]/SP[4] and
*               SP[3]/SP[2] by SP[1]/SP[0]
*   SACurveAbs: Adds a curve to a filled object with SP[5]/SP[4] and
*               SP[3]/SP[2] to SP[1]/SP[0]
*   SAEnd     : Closes the current area-polygon and fills it.
*   SAEllipse : Draws a filled ellipse with SP[1] as half the width, and
*               SP[0] as half the height. Drawn around the cursor.
*
*
IG_JMP          EQU     $80000001
IG_RTS          EQU     $80000002
IG_JSR          EQU     $80000003
IG_CALL         EQU     $80000004
IG_POP          EQU     $80000011
IG_DUP          EQU     $80000012
IG_SWAP         EQU     $80000013
IG_ROT3         EQU     $80000014
IG_ROTN         EQU     $80000015
IG_BYTE         EQU     $80000111
IG_VAL          EQU     $80000016
IG_ADR          EQU     $80000017
IG_GET1         EQU     $80000018
IG_GET2         EQU     $80000019
IG_GETN         EQU     $8000001A
IG_POPN         EQU     $8000001B
IG_DUPN         EQU     $8000001C
IG_GETF         EQU     $8000001D
IG_PUTF         EQU     $8000001E
IG_STKADR       EQU     $8000001F
IG_POKEB        EQU     $80000113
IG_POKEW        EQU     $80000114
IG_POKE         EQU     $80000115
IG_ADD          EQU     $80000021
IG_NEG          EQU     $80000022
IG_SUB          EQU     $80000023
IG_MUL          EQU     $80000024
IG_IDIV         EQU     $8000002E
IG_IMOD         EQU     $8000002F
IG_SEQ          EQU     $80000025
IG_SNE          EQU     $80000026
IG_SGT          EQU     $80000027
IG_SLT          EQU     $80000028
IG_SGE          EQU     $80000029
IG_SLE          EQU     $8000002A
IG_SNOT         EQU     $8000002B
IG_SAND         EQU     $8000002C
IG_SOR          EQU     $8000002D
IG_GetPosX      EQU     $80000031
IG_GetPosY      EQU     $80000032
IG_GetColor     EQU     $80000033
IG_GetBack      EQU     $80000034
IG_Color        EQU     $80000041
IG_Back         EQU     $80000042
IG_ModeA        EQU     $80000043
IG_ModeAB       EQU     $80000044
IG_ModeInvers   EQU     $80000112
IG_Image        EQU     $80000045
IG_Move         EQU     $80000046
IG_Draw         EQU     $80000047
IG_Write        EQU     $80000048
IG_Text         EQU     $8000004F
IG_Box          EQU     $80000049
IG_Locate       EQU     $8000004A
IG_Locate00     EQU     $8000004B
IG_Packed       EQU     $8000004C
IG_Font         EQU     $8000004D
IG_DrawA        EQU     $8000004E
IG_Box3d        EQU     $80000401
IG_Rect3d       EQU     $80000402
IG_Box2d        EQU     $80000403
IG_CLight       EQU     $80000050
IG_CNormal      EQU     $80000051
IG_CDark        EQU     $80000052
IG_CSelect      EQU     $80000053
IG_CBack        EQU     $80000054
IG_CTxtFront    EQU     $80000055
IG_CTxtBack     EQU     $80000056
IG_While        EQU     $80000101
IG_Do           EQU     $80000102
IG_If           EQU     $80000103
IG_Else         EQU     $80000104
IG_End          EQU     $80000105
IG_Repeat       EQU     $80000106
IG_Until        EQU     $80000107
IG_Debug        EQU     $80000200
IG_Const        EQU     $81008000
IG_Const24      EQU     $89000000
IG_GETFI        EQU     $82000000
IG_PUTFI        EQU     $83000000
IG_GETSI        EQU     $84000000
IG_FRAME        EQU     $85000000
IG_RTF          EQU     $86000000
IG_ADDI         EQU     $87008000
IG_DUPI         EQU     $88000000
IG_POPI         EQU     $8A000000
IG_SetScale     EQU     $80000300
IG_SetRadio     EQU     $80000301
IG_SMove        EQU     $80000311
IG_SLocate      EQU     $80000312
IG_SDraw        EQU     $80000313
IG_SDrawAbs     EQU     $80000314
IG_SCurve       EQU     $80000315
IG_SCurveAbs    EQU     $80000316
IG_SEllipse     EQU     $80000317
IG_SAMove       EQU     $80000321
IG_SALocate     EQU     $80000322
IG_SADraw       EQU     $80000323
IG_SADrawAbs    EQU     $80000324
IG_SACurve      EQU     $80000325
IG_SACurveAbs   EQU     $80000326
IG_SAEllipse    EQU     $80000327
IG_SAEnd        EQU     $8000033F

* Examples of using IntuiGfx stack programs:
*
*
*   Examples:
*
*     - Box3d       : Draw a rectangle in two colours.  To get a 3D effect
*                     the top and left line are coloured different from the
*                     bottom and right line. (Same as IG_Box3d).
*                     Thus parameters are two colours, "bottomRight" and
*                     "topLeft", and the "width" and "height".
*
*                     Parameters:
*
*                        - bottomRight (FP+3) : Colour for left and top
*                        - topLeft     (FP+2) : Colour for right and bottom
*                        - width       (FP+1) : Width
*                        - height      (FP+0) : Height
*
*
*ULONG Box3d[] = {
*  IG_ADDI-1,                             decrease height by one
*  IG_SWAP,                               swap width and height
*  IG_ADDI-1,                             decrease width by one
*  IG_SWAP,                               swap again
*  IG_GETFI+2,IG_Color,                   get and set color for
*                                         left and top
*  IG_GETFI+1,IG_Const+0,IG_Draw,         draw a line of width to the right
*  IG_GETFI+3,IG_Color,                   get and set colour for
*                                         right and bottom
*  IG_Const+0,IG_GETFI+0,IG_Draw,         draw line of height to the bottom
*  IG_GETFI+1,IG_NEG,IG_Const+0,IG_Draw,  draw line of negated
*                                         width to the right
*  IG_GETFI+2,IG_Color,                   set colour for top and left
*  IG_Const+0,IG_GETFI+0,IG_NEG,IG_Draw,  draw line of height to the top
*  IG_RTF+4                               clear stack and return
*};
*
*
*
*     - Border3d    : Draw a double-bordered 3D rectangle using the procedure
*                     "Box3d".  As it is unknown if the rectangle is to appear
*                     highlighted or pressed, again two colours must be
*                     specified.  The subroutine "Box3d" is called twice, once
*                     with the parameters of Border3d and once with exchanged
*                     colours and a smaller inner rectangle.
*
*                     Parameters:
*
*                        - dark        (FP+3) : First colour
*                        - light       (FP+2) : Second colour
*                        - width       (FP+1) : Width
*                        - height      (FP+0) : Height
*
*
*ULONG Border3d[] = {
*  IG_GETFI+2,IG_GETFI+3,      push colours reversed onto the stack
*  IG_GETFI+1,IG_ADDI-2,       get width decreased by two so that the inner
*                              rectangle is created
*  IG_GETFI+0,IG_ADDI-2,       get height decreaed by two
*  IG_Const+1,IG_DUP,IG_Move,  move cursor by one pixel to bottom and left
*  &Box3d,IG_JSR,              call "Box3d" with modified parameters
*  IG_Locate00,                reset cursor to top left corner
*  &Box3d,IG_JSR,              call "Box3d" for outer rectangle with the
*                              original parameters
*  IG_RTS                      return; no parameter deallocation as already
*                              performed by "Box3d" (dirty trick)
*};
*
*
*     - Rect3d      : Draw a filled 3D rectangle.  This routine uses "Box3d"
*                     to draw a border around the rectangle.  Now a third
*                     colour is needed, too, since the inner part of the
*                     rectangle is coloured, either.
*
*                     Parameters:
*
*                        - inner       (FP+4) : Colour of inner part
*                        - bottomRight (FP+3) : Colour for bottom and right
*                        - leftTop     (FP+2) : Colour for top and left
*                        - width       (FP+1) : Width
*                        - height      (FP+0) : Height
*
*
*ULONG Rect3d[] = {
*  IG_GETFI+4,IG_Color,            set inner colour
*  IG_Const+1,IG_Const+1,IG_Move,  set inner cursor
*  IG_GETFI+1,IG_ADDI-2,           get width decreased by two for inner
*                                  rectangle
*  IG_GETFI+0,IG_ADDI-2,           get height decreased by two
*  IG_Box,                         draw filled inner rect
*  IG_Locate00,                    back to the roots
*  IG_DUPI+4,                      get data for "Box3d". As the order is
*                                  the same, you could use the parameters
*                                  already on the stack, but this is the
*                                  clean and neat solution.
*  &Box3d,IG_JSR,                  call "Box3d"
*  IG_RTF+5                        return and clear stack
*};
*
*
*     - BigBorder3d : Draw a wide, filled 3D border.  The parameters are the
*                     same as for "Rect3d".
*
*                     Parameters:
*
*                        - inner       (FP+4) : Colour for inner border parts
*                        - bottomRight (FP+3) : Colour for bottom and right
*                        - leftTop     (FP+2) : Colour for top and left
*                        - width       (FP+1) : Width
*                        - height      (FP+0) : Height
*
*
*ULONG BigBorder3d[] = {
*  IG_DUPI+4,&Box3d,IG_JSR,           draw outer border
*
*  IG_GETFI+2,IG_GETFI+3,             draw inner border
*  IG_GETFI+1,IG_ADDI-30,
*  IG_GETFI+0,IG_ADDI-30,
*  IG_Const+15,IG_Const+15,IG_Move,
*  &Box3d,IG_JSR,
*
*  IG_GETFI+4,IG_Color,               set colour for inner part
*
*  IG_Const+1,IG_Const+1,IG_Locate,   draw top bar
*  IG_GETFI+1,IG_ADDI-16,
*  IG_Const+14,IG_Box,
*
*  IG_Const+0,IG_Const-14,IG_Move,    draw right bar
*  IG_Const+14,
*  IG_GETFI+0,IG_ADDI-16,IG_Box,
*
*  IG_Const+1,IG_Const+15,IG_Locate,  draw left bar
*  IG_Const+14,
*  IG_GETFI+0,IG_ADDI-16,IG_Box,
*
*  IG_Const+0,IG_Const-14,IG_Move,    draw bottom bar
*  IG_GETFI+1,IG_ADDI-16,
*  IG_Const+14,IG_Box,
*
*  IG_Locate00,                       clean up
*  IG_RTF+5
*};
*
*    - Write3d      : Write text with shadow effect.  For that the text is
*                     first written in a darker shade and slightly shifted,
*                     then the text is again written in a lighter colour
*                     at the specified position.
*
*                     Parameters:
*
*                        - light       (FP+2) : Light colour
*                        - shade       (FP+1) : Shadow colour
*                        - text        (FP+0) : Text to be written (C string)
*
*
*ULONG Write3d[] = {
*  IG_ModeA,                       turn to "drawAPen"
*  IG_GETFI+1,IG_Color,            set darker colour
*  IG_Const+1,IG_Const+1,IG_Move,  altered position for shadowed text
*  IG_GETFI+0,IG_Text,             write shadowed text
*  IG_Locate00,                    back to the roots
*  IG_GETFI+2,IG_Color,            set light colour
*  IG_GETFI+0,IG_Text,             write text
*  IG_RTF+3                        clean up
*};
*
*
  ENDC                       * EGS_EGSINTUIGFX_H
