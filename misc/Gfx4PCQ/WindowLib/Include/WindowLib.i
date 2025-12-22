{*****************************************************************
 ** Windowlib                                                   **
 **                                                             **
 ** © 1994/97 THOR-Software inc.                                **
 ** Version 2.00 / 19.07.1997                                   **
 **                                                             **
 ** Useful graphics support for PCQ                             **
 *****************************************************************}

CONST
{ --- IDCMP Classes ------------------------------------------------------ }
    NEWSIZE_f           = $00000002;  { See the Programmer's Guide  }
    REFRESHWINDOW_f     = $00000004;  { See the Programmer's Guide  }
    MOUSEBUTTONS_f      = $00000008;  { See the Programmer's Guide  }
    MOUSEMOVE_f         = $00000010;  { See the Programmer's Guide  }
    GADGETDOWN_f        = $00000020;  { See the Programmer's Guide  }
    GADGETUP_f          = $00000040;  { See the Programmer's Guide  }
    MENUPICK_f          = $00000100;  { See the Programmer's Guide  }
    CLOSEWINDOW_f       = $00000200;  { See the Programmer's Guide  }
    RAWKEY_f            = $00000400;  { See the Programmer's Guide  }
    DISKINSERTED_f      = $00008000;  { See the Programmer's Guide  }
    DISKREMOVED_f       = $00010000;  { See the Programmer's Guide  }
    ACTIVEWINDOW_f      = $00040000;  { See the Programmer's Guide  }
    INACTIVEWINDOW_f    = $00080000;  { See the Programmer's Guide  }
    INTUITICKS_f        = $00400000;  { See the Programmer's Guide  }

{ --- Qualifier ---------------------------------------------------------- }

        QUALIFIER_LSHIFT          = $0001;
        QUALIFIER_RSHIFT          = $0002;
        QUALIFIER_CAPSLOCK        = $0004;
        QUALIFIER_CONTROL         = $0008;
        QUALIFIER_LALT            = $0010;
        QUALIFIER_RALT            = $0020;
        QUALIFIER_LCOMMAND        = $0040;
        QUALIFIER_RCOMMAND        = $0080;
        QUALIFIER_NUMERICPAD      = $0100;
        QUALIFIER_REPEAT          = $0200;
        QUALIFIER_MIDBUTTON       = $1000;
        QUALIFIER_RBUTTON         = $2000;
        QUALIFIER_LEFTBUTTON      = $4000;

{ --- Menu Command constants --------------------------------------------- }
        MC_MENU         = 1;            { entry is a menu }
        MC_ITEM         = 2;            { entry is a item of a menu }
        MC_SUBITEM      = 3;            { entry is a subitem of a item }
        MC_LASTMENU     = $81;          { dummy entry to mark end of menu }
        MC_LASTITEM     = $82;          { end of item list of a menu }
        MC_LASTSUBITEM  = $83;          { end of subitem list of a item }
                
{ --- Menu Command flags ------------------------------------------------- }
        MC_MENUENABLED  = 1;            {menu is active (menus only) }
        MC_NORMALMENU   = 1;            {same}
                                        {item and subitem only flags }
        MC_ITEMENABLED  = $10;          {item is active}
        MC_HIGHCOMP     = $40;          {item is beeing inverted }
        MC_CHECKIT      = $01;          {item is checkable}
        MC_TOGGLE       = $08;          {item is toggleable}
                                        {combined flags}
        MC_BAR          = $C0;          {item is a separator bar }
        MC_READONLY     = $D0;          {item is not selectable }
        MC_NORMAL       = $50;          {normal item type}
        MC_OFF          = $40;          {selectable, but disabled}
        MC_CHECKABLE    = $59;          {a checkmark item}
        MC_OFFCHECK     = $49;          {a disabled checkmark}
                
{ Each menu command entry consists of four entries:
        i)      the menu command constant defining the type of the entry
        ii)     the menu command flags
        iii)    a shortcut character, if any (items & subitems only)
        iv)     the name of the entry as NUL-terminated string OR 
                an empty string if flags are MC_BAR
                
        A sample menu command list:
        
        MC_MENU,MC_NORMALMENU,0,"Menu 1"
         MC_ITEM,MC_NORMALITEM,'O',"Open..."
         MC_ITEM,MC_BAR,0,0
         MC_ITEM,MC_OFF,'S',"Save..."
         MC_LASTITEM,0,0,""
        MC_MENU,MC_NORMALMENU,0,"Flags"
         MC_ITEM,MC_NORMALITEM,0,"Style"
          MC_SUBITEM,MC_CHECKABLE,'P',"Plain"
          MC_SUBITEM,MC_CHECKABLE,'I',"Italic"
          MC_SUBITEM,MC_CHECKABLE,'B',"Bold"
          MC_SUBITEM,MC_CHECKABLE,'U',"Underline"
          MC_LASTSUBITEM,0,0,""
         MC_ITEM,MC_OFFCHECK,0,"Save ASCII"
         MC_LASTITEM,0,0,""
        MC_LASTMENU,0,0,""
}

{ --- Monitor Types ------------------------------------------------------ }
        {OR all types together to get monitor. PAL,NTSC etc. work only
         in 2.0 or higher...}
         
        {Monitor types...}
        MON_NTSC        =       $11000;
        MON_PAL         =       $21000;
        MON_VGA         =       $31004; {OR with HIRES, or you get SUPERLORES}
        MON_A2024       =       $41000;
        MON_A2024_15    =       $49000;
        MON_SUPER72     =       $81000;
        MON_EURO36      =       $71000;
        MON_EURO72      =       $61004; {OR with HIRES, or you get SUPERLOWRES}
        MON_DBLNTSC     =       $91000;
        MON_DBLPAL      =       $A1000;
        
        
        MON_LORES       =       $0000;
        MON_HIRES       =       $8000;
        MON_SUPER       =       $8020;
        MON_HAM         =       $0800;
        MON_LACE        =       $0004;
        MON_VGALACE     =       $0001; {USE for VGA,EURO72}
        MON_EHB         =       $0080;

{ some useful window flags }

        WINFLG_SIZEGADGET   =  $00000001;  { include sizing system-gadget? }
        WINFLG_DRAGBAR      =  $00000002;  { include dragging system-gadget? }
        WINFLG_DEPTHGADGET  =  $00000004;  { include depth arrangement gadget? }
        WINFLG_CLOSEGADGET  =  $00000008;  { include close-box system-gadget? }

        WINFLG_SIZEBRIGHT   =  $00000010;  { size gadget uses right border }
        WINFLG_SIZEBBOTTOM  =  $00000020;  { size gadget uses bottom border }

{ --- refresh modes ------------------------------------------------------ }
{ combinations of the WFLG_REFRESHBITS select the refresh type }

        WINFLG_SMART_REFRESH = $00000000;
        WINFLG_SIMPLE_REFRESH= $00000040;

        WINFLG_BACKDROP      = $00000100;  { this is a backdrop window }
        WINFLG_BORDERLESS    = $00000800;  { to get a Window sans border }
        WINFLG_ACTIVATE      = $00001000;  { when Window opens, it's Active }

{ defintions for the sprite allocation OpenSprite }

        SPRITE_HARDWARE         = $1;   { use real hardware sprite }
        SPRITE_SAVEBACK         = $2;   { save background for bobs }
        SPRITE_OVERLAY          = $4;   { overlay over background }
        SPRITE_MUSTDRAWN        = $8;   { sprite must be drawn }

{ definitions for the border collisions }
        COLLIDE_BORDER          = $1;   { set this as hitmask to receive boundary hits }

        COLLIDE_TOP             = $10000; { get these results } 
        COLLIDE_BOTTOM          = $20000;
        COLLIDE_LEFT            = $40000;
        COLLIDE_RIGHT           = $80000;
          
TYPE
        SpritePtr       =       Address;
        ScreenPtr       =       Address;
        WindowPtr       =       Address;
        GadgetPtr       =       Address;
        IntuiMessagePtr =       Address;        { DO NOT care, DO NOT touch! }
        MenuCommand     =       RECORD
                MenuType        :       BYTE;
                MenuFlags       :       BYTE;
                ShortCut        :       CHAR;
                reserved        :       BYTE;
                MenuText        :       String;
        END;
        MenuCommandArray = ARRAY[0..0] OF MenuCommand; {define for own purposes}

VAR
        ConsoleBase,
        DiskFontBase,
        LayersBase,
        GfxBase         :       Address;
                

PROCEDURE SortCoords(VAR x1,y1,x2,y2 : SHORT);
EXTERNAL;
{ sort two pairs of coordinates to be left,top,right,bottom }
        
PROCEDURE ExitGraphics;
EXTERNAL;
{ close graphic subsystem: You MUST call this before exit}
        
PROCEDURE InitGraphics;
EXTERNAL;
{ initialize graphic subsytem: You MUST call this before starting}
        
PROCEDURE InstallStdClip(w : WindowPtr);
EXTERNAL;
{ installes standard cliprect in non-GZZ-windows. You can use this call
  to restore the cliprect back to default values after Clip,SetOffset. }

PROCEDURE DeleteButton(g : GadgetPtr);
EXTERNAL;
{ given a gadget, this procedure removes the gadget from the window 
  and deletes it }

PROCEDURE OffButton(g : GadgetPtr);
EXTERNAL;
{ disable a gadget }
        
PROCEDURE OnButton(g : GadgetPtr);
EXTERNAL;
{ enable a gadget }

PROCEDURE RefreshButton(g : GadgetPtr);
EXTERNAL;
{ redraw a gadget }
        
FUNCTION CreateTextButton(w : WindowPtr;x,y,xsize,ysize : SHORT;text : String) : GadgetPtr;
EXTERNAL;
{ create a button with a text in it at given coordinates and given size }

FUNCTION CreateTextToggle(w : WindowPtr;x,y,xsize,ysize : SHORT;text : String) : GadgetPtr;
EXTERNAL;
{ create a toggle button with a text in it at given coordinates and given size }
        
PROCEDURE SetToggle(g : GadgetPtr;state : BOOLEAN);
EXTERNAL;
{ set state of a toggle gadget};
        
FUNCTION GetToggle(g : GadgetPtr) : BOOLEAN;
EXTERNAL;
{ get state of a toggle gadget};
        
FUNCTION IDFromGadget(g : GadgetPtr) : SHORT;
EXTERNAL;
{ calculates the ID of a given gadget }
        
FUNCTION GadgetFromID(w : WindowPtr;id : SHORT) : GadgetPtr;
EXTERNAL;
{ calculates the gadgethandle from the ID, returns NIL if not found }
        
PROCEDURE RequestStart(w : WindowPtr;what : INTEGER);
EXTERNAL;
{ starts a request of given type (see constants above) at given window }

PROCEDURE RequestEnd(w : WindowPtr;what : INTEGER);
EXTERNAL;
{ ends a request }

FUNCTION NextRequest(w : WindowPtr) : INTEGER;
EXTERNAL;
{ returns the last event happened or 0 if not }

FUNCTION WaitRequest(w : WindowPtr) : INTEGER;
EXTERNAL;
{ returns the last event happend or waits if not }

FUNCTION LastGadgetID(w : WindowPtr) : INTEGER;
EXTERNAL;
{ returns the ID of the last gadget selected }

FUNCTION MouseButton(w : WindowPtr) : BOOLEAN;
EXTERNAL;
{ returns the state of the mouse button, may send task to sleep for
  max. 1/6 sec. }
        
FUNCTION ModIDCMP(w : WindowPtr; new : INTEGER) : INTEGER;
EXTERNAL;
{ modifies the IDCMP-flags. You should know what you're doing if you
  call this. Return the previous flags.
  This call should not be used by quiche-eaters...}
  
FUNCTION GetWindowMsg(w : WindowPtr)    : IntuiMessagePtr;
EXTERNAL;
{ returns the lastest message arrived at window w. After using it,
  you should reply it with ReplyMsg(msg). 
  Also no use for quiche-eaters...}
  
FUNCTION WaitUntilWindow(w : WindowPtr) : IntuiMessagePtr;
EXTERNAL;
{ send task to sleep untit message arrives, returns the message -
  already removed from window - in contrast to WaitMsg.
  Use this only if you're shure what it does...}
  
FUNCTION OpenAWindow(left,top,wdth,hght,flgs: INTEGER; tit : String) : WindowPtr;
EXTERNAL;
{ opens a window at given position, given size, flags and title. Returns
  a handle to that window - as needed by all other procedures.
  Flags should be 14 for most resons, see Libraries/Autodocs for more.
  THIS CALL MAY FAIL ! - Check the value: If NIL, there's no window !
  This call is only present for backward compatibility, use
  OpenScreenWindow with Screen set to NIL instead ! }
  
FUNCTION OpenScreenWindow(s : ScreenPtr;left,top,wdth,hght,flgs : INTEGER; tit : String) : WindowPtr;
EXTERNAL;
{ works like OpenAWindow, but opens window on given screen. NIL is the
  workbench.
  THIS CALL MAY FAIL ! }
  
PROCEDURE CloseAWindow(w : WindowPtr);
EXTERNAL;
{ closes given window. After this call, the windowpointer is no longer
  available.
  Works fine for both OpenAWindow and OpenScreenWindow }
  
FUNCTION OpenAScreen(left,top,wdth,hgth,dpth,flgs : INTEGER; tit : String) : ScreenPtr;
EXTERNAL;
{ opens a new screen at left,top with given width and height.
        WARNING 1:left will be ignored prior to 2.0
  The screen depth is given in dpth.
        WARNING 2:not all depth will work, use them in a range of 1..6
                for MON_LORES or 1..4 with MON_HIRES.
  The screen type is determinated by flgs (see definitions above).
        WARNING 3:not all monitors support all types, some types
                (EHB,HAM) need a depth of 6 and NO LORES.
  The default title will be tit.
  The return value is a handle to the screen.
        WARNING 4:THIS CALL MAY FAIL ! If it returns NIL, there's NO
        SCREEN !}
        
PROCEDURE CloseAScreen(s : ScreenPtr);
EXTERNAL;
{ closes a given screen (removes it from display and memory).
  You should close all windows of this screen (else this
        procedure does it for you...) }

PROCEDURE SetColor(s : ScreenPtr;reg,r,g,b : SHORT);
EXTERNAL;
{ sets given color register }
        
PROCEDURE GetColor(s : ScreenPtr;reg : SHORT;VAR r,g,b : SHORT);
EXTERNAL;
{ read given color register }
                
PROCEDURE WaitForIDCMP(w : WindowPtr; what : INTEGER);
EXTERNAL;
{ wait until given IDCMP-flag arrives. They don't queue up in this
  release, so watch out. Call this only if you know what IDCMP is. }
  
PROCEDURE Mouse(w : WindowPtr;VAR x,y : SHORT);
EXTERNAL;
{ returns current mouse position. Because of multitasking, the values
  returned may be incorrect by a small amount. }
  
PROCEDURE WaitLeftClick(w : WindowPtr;VAR x,y : SHORT);
EXTERNAL;
{ wait until user presses left button and return the position }
        
PROCEDURE WaitForClick(w : WindowPtr);
EXTERNAL;
{ as above, but does not return mouse position }
        
FUNCTION MouseDown(w : WindowPtr; VAR x,y : SHORT) : BOOLEAN;
EXTERNAL;
{ returns position of mouse button - TRUE for down - and position
  of the mouse. This call may send your task to sleep for 1/6th
  second. }
  
FUNCTION MouseMove(w : WindowPtr; VAR x,y : SHORT) : BOOLEAN;
EXTERNAL;
{ as above, but waits until mouse get moved }
        
PROCEDURE WaitForClose(w : WindowPtr);
EXTERNAL;
{ waits until user presses the close gadget. It's your job to close
  the window with CloseAWindow - that's not done by this procedure}
  
PROCEDURE Color(w : WindowPtr; c : BYTE);
EXTERNAL;
{ sets foreground drawing color }
        
PROCEDURE BgColor(w : WindowPtr; c : BYTE);
EXTERNAL;
{ sets background color for text }
        
PROCEDURE OlColor(w : WindowPtr; c: BYTE);
EXTERNAL;
{ sets outline color, only used if boundary(w,TRUE) called }
        
PROCEDURE Boundary(w : WindowPtr; onoff : BOOLEAN);
EXTERNAL;
{ if called with onoff=TRUE, all filled shapes are drawn with a
  frame of color OlColor around them }
  
PROCEDURE DrawMode(w : WindowPtr; mode : BYTE);
EXTERNAL;
{ selects drawmode }
        
PROCEDURE SetDrawPattern(w : WindowPtr; pat : SHORT);
EXTERNAL;
{ selects pattern for lines }

PROCEDURE SetFillPattern(w: WindowPtr; pat : Address ; power : BYTE ; depth : Integer);
EXTERNAL;
{ select fill style. 2^power is the height of the pattern. 
  depth is the depth. Only one or the depth of the screen is allowed here.
  pat is the bit pattern, no chip mem needed!}
        
PROCEDURE ClearRaster(w : WindowPtr; color : BYTE);
EXTERNAL;
{ fill entire window with given color }
        
PROCEDURE ClearWindow(w : WindowPtr);
EXTERNAL;
{ fill entire window with background color }
        
PROCEDURE SetBitMask(w : WindowPtr; mask : BYTE);
EXTERNAL;
{ sets bitplane mask }
        
PROCEDURE DrawTo(w : WindowPtr; x,y : SHORT);
EXTERNAL;
{ draws a line from last plot/position point to this one }
        
PROCEDURE Ellipse(w : WindowPtr; xm,ym,x,y : SHORT);
EXTERNAL;
{ draws a ellipse around xm,ym with radii x,y }
        
FUNCTION Locate(w : WindowPtr; x,y : SHORT) : BYTE;
EXTERNAL;
{ returns color of point at x,y or -1 if outside of window }
        
PROCEDURE Scroll(w : WindowPtr; x1,y1,x2,y2,dx,dy : SHORT);
EXTERNAL;
{ scroll rectangle x1,y1,x2,y2 given amount dx,dy }
        
PROCEDURE DrawText(w : WindowPtr;text : String);
EXTERNAL;
{ write text at last position/plot point }

FUNCTION GetTextLength(w : WindowPtr;text : String) : SHORT;
EXTERNAL;
{ returns length of text in pixels }

PROCEDURE Plot(w : WindowPtr; x,y : SHORT);
EXTERNAL;
{ draw one point at x,y in foreground color }
        

PROCEDURE Position(w : WindowPtr; x,y : SHORT);
EXTERNAL;
{ selects next position for drawto,text,...}
        
PROCEDURE Line(w : WindowPtr; x1,y1,x2,y2 : SHORT);
EXTERNAL;
{ draw a line from x1,y1 to x2,y2}
        
PROCEDURE Fill(w : WindowPtr; x,y : SHORT);
EXTERNAL;
{ starts flood fill at x,y. THIS CALL MAY FAIL }
  
PROCEDURE PBox(w : WindowPtr; x1,y1,x2,y2 : SHORT);
EXTERNAL;
{ draw a filled box from x1,y1,x2,y2 - draw frame around it
  if boudary is TRUE }
  
PROCEDURE Box(w : WindowPtr; x1,y1,x2,y2 : SHORT);
EXTERNAL;
{ draw a frame from x1,y1 to x2,y2 }
        
PROCEDURE SetOffset(w : WindowPtr; x,y : SHORT);
EXTERNAL;
{ sets coordinate offset. Normally, the leftmost, topmost point
  will have the coordinates 0,0 - after this call it's -x,-y.
  You should note that x,y is relative to a already installed
  offset anyway - so SetOffset(w,0,0) does nothing usefull.
  Use SetOffset(w,-x,-y) or InstallStdClip(w) to restore old
  values. }
  
PROCEDURE Clip(w : WindowPtr; x1,y1,x2,y2 : SHORT);
EXTERNAL;
{ installes a clipping rectangle in given window - only
  points inside of the rectangle x1,y1,x2,y2 are affected
  by drawing. To remove the ClipRect again, call 
  InstallStdClip(w).
  However, the coordinates of all points are not moved -
  use SetOffset to move point 0,0 to the left edge of
  your clipping rectangle.}
  
PROCEDURE AddAreaEllipse(w : WindowPtr; xm,ym,x,y : SHORT);
EXTERNAL;
{ this is a area function. This means: calling this type of function
  stacks all operation back - the objects are drawn later with a
  call to CompleteArea.
  This call adds a filled ellipse at xm,ym, radii x,y to the object
  stack. }
  
PROCEDURE AddAreaDraw(w : WindowPtr; x,y : SHORT);
EXTERNAL;
{ this call adds a point to a filled polygon to the object stack.
  The polygon is completed with a AddAreaPoint or a CompleteArea.
  This call does actually not the drawing, call CompleteArea to
  make your object visible after defining all points. }
  
PROCEDURE AddAreaMove(w : WindowPtr; x,y : SHORT);
EXTERNAL;
{ complete old filled polygon - if any - and start a new one at
  x,y. This is again an area function, so its operation is
  invisible until a call to CompleteArea. }
  
PROCEDURE CompleteArea(w : WindowPtr);
EXTERNAL;
{ complete all objects and draw them, start a new invisible
  object definition. You must call this if you want to see
  your defined area-objects. }
  
PROCEDURE PEllipse(w : WindowPtr; xm,ym,x,y : SHORT);
EXTERNAL;
{ draw a filled ellipse at xm,ym with radii x,y.
  Cause this call uses area-functions, you should not use it
  inside of an area definition or all your objects get lost. }
  
PROCEDURE SetAreaSize(w : WindowPtr; size : SHORT);
EXTERNAL;
{ sets size of area object stack. Default is 256 points.
  You should call this if you get an area buffer overflow error. }
        
PROCEDURE Dimensions(w : WindowPtr; VAR width,height : SHORT);
EXTERNAL;
{ get size of drawable area in pixels }
        
PROCEDURE SelectPoint(w : WindowPtr; VAR x,y : SHORT);
EXTERNAL;
{ let user select a point of the window. }

PROCEDURE DragBox(w : WindowPtr; xanc,yanc : SHORT; VAR x,y : SHORT);
EXTERNAL;
{ let the user select the other edge of a rectangle.
  This call assumes the user is already pressing the mouse button,
  use this call together with SelectPoint to define a rectangle:
  SelectPoint(w,x1,y1);
  DragBox(w,x2,y2); 
  will do this job - after all x1,y1,x2,y2 contain the rectangle }

FUNCTION SetWindowFont(w : WindowPtr;name : String;size : SHORT) : BOOLEAN;
EXTERNAL;
{ select the default font of the window.
  This call may fail if the desired font is not available }
  
PROCEDURE Print(w : WindowPtr;text : String);
EXTERNAL;
{ Print a string to the window. Unlike DrawText, all escape
  sequences are interpreted, but Print is much slower. }
  
PROCEDURE SetStyle(w : WindowPtr;style : SHORT);
EXTERNAL;
{ Select the style of the window default font. }
        
FUNCTION CreateStringField(w : WindowPtr;x,y,xsize,ysize : SHORT) : GadgetPtr;
EXTERNAL;
{ Create a field ready for string entry }
        
FUNCTION ActivateField(g : GadgetPtr) : BOOLEAN;
EXTERNAL;
{ Activates a string field, returns TRUE on success }
        
FUNCTION BufferFromField(g : GadgetPtr) : String;
EXTERNAL;
{ given a string field returns buffer contents }
        
PROCEDURE SetSlider(g : GadgetPtr;choices,viewable,first : SHORT);
EXTERNAL;
{ set slider position, viewable elements and # of choices }
        
PROCEDURE SetSliderFirst(g : GadgetPtr;first : SHORT);
EXTERNAL;
{ set only position of slider }
        
FUNCTION CreateSlider(w : WindowPtr;x,y,xsize,ysize : SHORT;vert : BOOLEAN) : GadgetPtr;
EXTERNAL;
{ create a slider gadget at position with given size.
  if vert is true, it's moveable vertically, else horizontally.}
  
FUNCTION FirstFromSlider(w : GadgetPtr) : SHORT;
EXTERNAL;
{ returns current position of slider }

PROCEDURE CreateMenu(w : WindowPtr;cmd : Address);
EXTERNAL;
{ create a menu }

PROCEDURE DeleteMenu(w : WindowPtr);
EXTERNAL;
{ delete menu }
        
PROCEDURE LastMenu(w : WindowPtr;VAR menu,item,subitem : SHORT);
EXTERNAL;
{ get number of last menu selected, returns -1 if not }
        
PROCEDURE OnMenuPoint(w : WindowPtr;menu,item,subitem : SHORT);
EXTERNAL;
{ enable given menu point }
        
PROCEDURE OffMenuPoint(w : WindowPtr;menu,item,subitem : SHORT);
EXTERNAL;
{ disable given menu point }
        
PROCEDURE CheckMenu(w : WindowPtr;menu,item,subitem : SHORT;check : BOOLEAN);
EXTERNAL;
{ set checkmark of a menupoint. Set if check is TRUE, else clear. }
        
FUNCTION CheckMarkOfMenu(w : WindowPtr;menu,item,subitem : SHORT) : BOOLEAN;
EXTERNAL;
{ returns the state of the checkmark of a given menu }

PROCEDURE LastKey(w : WindowPtr;text : String;VAR qualifier : SHORT);
EXTERNAL;
{ copies the last keyboard entry to text.
  Text should be at least 16 characters long. }

PROCEDURE ScreenToBack(s : ScreenPtr);
EXTERNAL;
{ make given screen the backmost }
        
PROCEDURE ScreenToFront(s : ScreenPtr);
EXTERNAL;
{ make screen the topmost }

PROCEDURE ShowTitle(s : ScreenPtr;showit : BOOLEAN);
EXTERNAL;
{ show or remove title bar }
        
PROCEDURE WBenchToFront;
EXTERNAL;

PROCEDURE WBenchToBack;
EXTERNAL;

PROCEDURE OpenWorkBench;
EXTERNAL;

PROCEDURE CloseWorkBench;
EXTERNAL;

PROCEDURE SetCopperSize(s : ScreenPtr; size : Integer);
EXTERNAL;
{selects the size of the copper list in instructions.
 Usually not needed.}

PROCEDURE CopperMove(s : ScreenPtr; register : Integer; value : SHORT);
EXTERNAL;
{add set a hw register by a copper list}

PROCEDURE CopperWait(s : ScreenPtr; x,y : SHORT);
EXTERNAL;
{wait for a display position in a copper list}

PROCEDURE CopperDone(s : ScreenPtr);
EXTERNAL;
{call this if your copper list is done}

PROCEDURE CopperQuit(s : ScreenPtr);
EXTERNAL;
{remove copper list explicitly. Usually NOT needed.}

PROCEDURE CopperSetColor(s : ScreenPtr;reg,r,g,b : SHORT);
EXTERNAL;
{ sets given color register }

PROCEDURE UnlinkSprite(add : SpritePtr);
EXTERNAL;
{remove linkage of one sprite as animation component of another sprite }

PROCEDURE CloseSprite(sp : SpritePtr);
EXTERNAL;
{remove sprite from display }

FUNCTION OpenSprite(w : WindowPtr;shape : ^String; height : Integer; flags : Integer) : SpritePtr;
EXTERNAL;
{create a sprite. The data is encoded in an Array of strings in ASCII-art.
 Each character in each String represents one pixel. Colors are either
 given as numbers from 0 to 9,A to F OR as the following characters:
 space  =       color 0
 .      =       color 1
 +      =       color 2
 *      =       color 3
 -      =       color 4
 /      =       color 5
 |      =       color 6
 ^      =       color 7
 _      =       color 8
 #      =       color 9

 height is the height of the Array in lines. The width is taken from the
 widest String in the Array, all other lines are padded WITH zeros
 at the right edge.
 Flags is an ORed value of the SPRITE_ flags above. }


PROCEDURE SetSpriteColor(sp : SpritePtr;reg,r,g,b : Integer);
EXTERNAL;
{ Define colors FOR hardware TYPE sprites. reg is one to three,
  r,g,b the red, green OR blue component as 4 bit integers, i.e.
  range from 0 to 15 }

PROCEDURE SetSpriteShape(sp : SpritePtr;shape : ^String);
EXTERNAL;
{ redefine the sprite shape, syntax like OpenSprite. Please note that
  the dimension MUST be the same. IF NOT, you have to CloseSprite()
  the old sprite AND create a new WITH OpenSprite! }

PROCEDURE SetCollisionMasks(sp : SpritePtr; me, hit : Short);
EXTERNAL;
{ sets the memask AND hitmask FOR the sprite. Collision detection is
  however NOT yet support. }

PROCEDURE HideSprite(sp : SpritePtr);
EXTERNAL;
{ hide the sprite, i.e. prevent it from drawing }

PROCEDURE ShowSprite(sp : SpritePtr);
EXTERNAL;
{ show a sprite after hiding }

PROCEDURE PlaceSprite(sp : SpritePtr; x,y : Integer);
EXTERNAL;
{ move a sprite to a specific position }

PROCEDURE LinkSprite(base : SpritePtr; add : SpritePtr);
EXTERNAL;
{ link a sprite to a base sprite. Both sprites form an animation
  sequence. All subsequent control calls must go to the base
  sprite.
  THIS IS NOT related to any hardware linking supported by
  denise, i.e. 16 color hardware sprites ARE NOT supported.}

PROCEDURE SetSpriteTimer(sp : SpritePtr; time : Short);
EXTERNAL;
{ define the time how long a sprite is shown as a part of an
  animation sequence. Makes only sense IF more than one
  sprite is linked together. }

PROCEDURE InFrontOf(sp1,sp2 : SpritePtr);
EXTERNAL;
{ definie sprite 1 to be drawn in front of sprite 2.
  Please avoid circular linking WITH this call as this
  WILL cause crashes! }

PROCEDURE Unordered(sp : SpritePtr);
EXTERNAL;
{ don't care about the drawing order of the given sprite }

PROCEDURE AnimateSprites(w : WindowPtr);
EXTERNAL;
{ update the position of the sprites AND animate them }

PROCEDURE RedrawSprites(w : WindowPtr);
EXTERNAL;
{ update the shapes AND the colors of the sprites on the screen }

PROCEDURE ShareColors(base, add : SpritePtr);
EXTERNAL;
{ tell windowlib that two sprites share the same color. This will
  improve the sprite scelduring }


PROCEDURE OwnColors(sp : SpritePtr);
EXTERNAL;
{ tell windowlib that a sprite should use its own colors again }

FUNCTION Stick(n : Short) : Short;
EXTERNAL;

FUNCTION Strig(n : Short) : Boolean;
EXTERNAL;

FUNCTION StickUp(n : Short) : Boolean;
EXTERNAL;

FUNCTION StickDown(n : Short) : Boolean;
EXTERNAL;

FUNCTION StickLeft(n : Short) : Boolean;
EXTERNAL;

FUNCTION StickRight(n : Short) : Boolean;
EXTERNAL;

PROCEDURE WaitForStick(unit : Short);
EXTERNAL;

PROCEDURE FreeJoystick(unit : Short);
EXTERNAL;

FUNCTION ReadCollisionMask(sp : SpritePtr; clearit : Boolean) : Integer;
EXTERNAL;

PROCEDURE ShiftSprite(sp : SpritePtr; x,y : Integer);
EXTERNAL;
