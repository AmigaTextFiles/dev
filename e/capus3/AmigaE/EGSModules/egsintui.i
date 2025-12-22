    IFND    EGS_EGSINTUI_I
EGS_EGSINTUI_I       SET     1
*\
*  $
*  $ FILE     : egsintui.i
*  $ VERSION  : 1
*  $ REVISION : 6
*  $ DATE     : 04-Feb-93 00:09
*  $
*  $ Author   : mvk
*  $
*
*
*
* (c) Copyright 1990/93 VIONA Development
*     All Rights Reserved
*
*\
    IFND    EXEC_TYPES_I
    INCLUDE "exec/types.i"
    ENDC
    IFND    EXEC_PORTS_I
    INCLUDE "exec/ports.i"
    ENDC
    IFND    DEVICES_INPUTEVENT_I
    INCLUDE "devices/inputevent.i"
    ENDC
    IFND    GRAPHICS_TEXT_I
    INCLUDE "graphics/text.i"
    ENDC
    IFND    EGS_EGS_I
    INCLUDE "egs.i"
    ENDC
    IFND    EGS_EGSBLIT_I
    INCLUDE "egsblit.i"
    ENDC
    IFND    EGS_EGSLAYERS_I
    INCLUDE "egslayers.i"
    ENDC
    IFND    EGS_EGSGFX_I
    INCLUDE "egsgfx.i"
    ENDC
    IFND    EGS_EGSINTUIGFX_I
    INCLUDE "egsintuigfx.i"
    ENDC

*
*  This library implements a complete window system with menus, gadgets etc.
*  It uses only the other EGS libraries and is thus implementable for other
*  graphics cards than the GVP EGS-110/24.  The library works as indepen-
*  dent from the current graphics mode as possible.
*
*  The basic structure of the system resembles Commodore's Intuition library.
*  Most names and structures derive from it but are sometimes modified a
*  great deal.
*
*  The library uses an extended EGS screen type to give you the choice of
*  whether to use the window system or not.
*
*  All graphics drawing (windows, gadget and menus) is carried out by IntuiGfx
*  stack programs (refer to "egsintuigfx.h") which is the most significant
*  difference to the Commodore library.  The reasons for this technique is the
*  clumsy implementation of Intuition graphics in Commodore's library (three
*  lists, no multiple usage of the structures, waste of memory by overloaded
*  structures and lacking flexibility).  The IntuiGfx solution is so flexible
*  that even the knobs of PropGadets are realised by such a program; even the
*  graphics for window borders is driven by IntuiGfx programs.
*
*  Unless you use the EGSGadBox library, it is recommended to use
*  "GimmeZeroZero" windows as the overhead is not that gigantic in contrast
*  to Commodore's implementation. However, using a ClipRect (see EGSGfx's
*  EG_InstallClipRect, the same effect can be achieved.
*
*  Requesters are not implemented in the library since all requesters are in
*  fact windows, and the overhead for an extra structure does not pay.
*
*  Menus have two new features: they can "hang" at the window border and they
*  can be teared off and then stay open.  The advantage is that the menu way
*  is minimized and often-used menus are accessible directly.
*

*
*  Menus
*
*  Menus serve to invoke an action or modify a state.  Menus pop up by
*  pressing the right mouse button and appear at the screen or the window
*  title.  A menu item is selected by moving the pointer over it while
*  pressing the right mouse button and releasing the button over it (alter-
*  natively "toggleSelect" menu items can be flipped by shortly pressing the
*  left mouse button).
*
*  A menu item can have submenus which open when the item is reached with the
*  mouse pointer and which can then be selected.  This nesting is infinite
*  but should not be exaggerated.
*
*  You can tear off menus, i.e. they stay open even after you released the
*  right mouse button.  This is performed by a special menu item.  These open
*  menus can be selected with the right mouse button and moved with the left
*  one.
*
* ---------------------------------------------------------------------------
*
*  Structures:
*
*  Menu, MenuPtr
*
*    .ItemMaster : Pointer to menu item the menu of which is this menu's super
*                  menu.  NIL if this menu is the main menu.
*    .MenuMaster : Pointer to menu that is this menu's super menu.  NIL if
*                  this menu is the main menu.
*    .FirstItem  : Pointer to the first menu item of this menu.
*    .LeftEdge,
*    .TopEdge    : Coordinates of the menu relative to the super menu or
*                  title bar.
*    .Width,
*    .Height     : Menu's size that determines the background that is saved
*                  when the menu is displayed.  This means the size should at
*                  least contain the menu with all its menu items but also
*                  should not exceed that area to save memory.
*    .Border     : Render program for the basic menu structure without items.
*                  This stack program is passed over the width (in FP+1) and
*                  height (in FP+0) of the menu so that it can be used for
*                  all menus. This routine should also clear the background
*                  of the menu.
*
*   MenuItem, MenuItemPtr
*
*    .Prev,
*    .Next          : Menu item chaining; the first and last menu item
*                     contain NIL in the corresponding field.
*    .LeftEdge,
*    .TopEgde       : Coordinates of the item's top left corner, relative to
*                     its menu.
*    .Width,
*    .Height        : Item's size.
*    .Active        : Render program if the item is active.
*    .Passive       : Render program if the item is passive. If this routine
*                     is NULL the library uses a ghosting feature to show
*                     unselectable items.
*    .CheckMark     : Render program if the item is selected for
*                     "ToggleSelect".
*    .Select        : Render program executed when the item is actice and
*                     the mouse touches it.  The program is passed over the
*                     width (in FP+1) and height (in FP+0) of the item so
*                     that all items can share the same program.
*    .Release       : Render program called when the mouse leaves the item.
*                     The program is passed over the item size, too.  It is
*                     called even when the menu is drawn so that the normal
*                     render programs need not draw the graphics for "not
*                     selected".
*    .Flags         : Flags of the item:
*
*      - MENU_ACTIVE    : Item is active and selectable.
*      - MENU_SELECTED  : Item is selected; for items that can be switched on
*                         and off.
*      - MENU_SELECTABLE: Item is selectable.
*      - MENU_TOGGLE    : Items toggles its state each time when selected.
*      - MENU_LEAVE     : Item causes no message but the menu containing this
*                         item is teared off.
*
*    .ID            : Number of the item; is passed over as "code" of the
*                     EIDCMP message.  The advantage is that for inserting
*                     new items the message for old items does not change.
*    .SubMenu       : Submenu, NIL if missing.
*    .MutualExclude : Set of items that are to be deselected if this item is
*                     selected.  For those items no extra message is sent.
*    .MutualInclude : Set of items that are to be selected if this item is
*                     selected.  For those items no extra message is sent.
*    .HotKey        : ASCII-Code selecting this item when pressed together
*                     with the right Amiga key
*
*
*  The menu structure is practically only the drawing area on which items are
*  located.  A title bar as for Commodore's Intuition should be designed such
*  that the main menu is as wide as the title bar, and each menu title is an
*  item of this main menu.  The real menus are then logical submenus of that
*  title bar main menu.  Then a Commodore Intuition menu with submenus (e.g.
*  Project.Load.IFFPicture) has really two submenus in the EGSIntui library.
*  For pop up menus it might be better to start with a real vertical
*  oriented menu.
*

* Corresponding MenuItemFlagSet has 16 bits !
EI_MENU_ACTIVE                  EQU     1
EI_MENU_SELECTED                EQU     2
EI_MENU_SELECTABLE              EQU     4
EI_MENU_TOGGLE                  EQU     8
EI_MENU_MOUSED                  EQU     16
EI_MENU_MOVE                    EQU     32
EI_MENU_LEAVE                   EQU     64

 STRUCTURE  EIMenu,0
    APTR    eime_WinPrev
    APTR    eime_WinNext
    APTR    eime_ItemMaster
    APTR    eime_MenuMaster
    APTR    eime_FirstItem
    WORD    eime_LeftEdge
    WORD    eime_TopEdge
    WORD    eime_Width
    WORD    eime_Height
    APTR    eime_Border
    APTR    eime_BackSave
    APTR    eime_Layer
    APTR    eime_Rast
    LABEL   eime_SIZEOF

 STRUCTURE  EIMenuItem,0
    APTR    eimi_Prev
    APTR    eimi_Next
    WORD    eimi_LeftEdge
    WORD    eimi_TopEdge
    WORD    eimi_Width
    WORD    eimi_Height
    APTR    eimi_Active
    APTR    eimi_Passive
    APTR    eimi_CheckMark
    APTR    eimi_Select
    APTR    eimi_Release
    UWORD   eimi_Flags
    UWORD   eimi_Pad_1
    ULONG   eimi_ID
    APTR    eimi_SubMenu
    ULONG   eimi_MutualExclude
    ULONG   eimi_MutualInclude
    BYTE    eimi_Pad_2
    UBYTE   eimi_HotKey
    UWORD   eimi_Pad_3
    LABEL   eimi_SIZEOF

*
*  Gadgets are window elements that the user can click on and thereby give
*  the application information.  There are six kinds of gadgets:
*
*    - ActionGadget  : When pressing the gadget the program gets a message.
*                      This gadget can only be selected.
*
*    - BoolGadget    : By pressing this gadget a flag is toggled from TRUE to
*                      FALSE and vice versa.  With such gadgets flags can be
*                      requested.  You can choose whether or not you want a
*                      message when the gadget is selected.
*
*    - StringGadget  : In these gadgets you can have a string edited, e.g.
*                      file names.  The library offers some editing capabili-
*                      ties which need not be implemented.  If required, you
*                      can get a message when the gadget is entered and/or
*                      left.
*
*    - PropGadget    : With these gadget a numerical value can be changed.
*                      For that a knob in a rectangle is created which can be
*                      moved with the mouse.  Its position indicates the
*                      value, and its size represents the ratio of its value
*                      and the maximum number possible.  You can get messages
*                      when the gadget is selected, moved and/or left.
*                      Move message should be used only if your program can
*                      cope with the amount of messages arriving.
*
*    - IntegerGadget : This is an extended string gadget allowing only
*                      editing of an integer number.
*
*    - RealGadget    : Like an integer gadget but for IEEE double precision
*                      numbers.
*
*    - UserDefGadget : A gadget that calls user functions on activation,
*                      release and on any requested IDCMP event that
*                      occurs in between.
*
*    - MasterGadget  : A gadget that serves as handle for several other gadgets
*                      that are linked to it. Gadget operations that are
*                      executed for the master gadget are also recursivly
*                      called for all its son gadgets. By using the callback
*                      feature in the gadget structure, one can even build
*                      complex gadgets, consisting of several normal gadgets,
*                      but appearing as being one normal gadget.
*                      See also "egsgadbox..." for examples and more
*                      information.
*
* ---------------------------------------------------------------------------
*
*  Structures:
*
*  All gadgets own the same basic structure and have then additional elements
*  depending on their type.
*
*  Gadget, GadgetPtr
*
*    .Prev,
*    .Next          : Chaining of the gadgets, the first and last element of
*                     a list always point to NIL.
*    .LeftEdge,
*    .TopEgde       : Coordinates of the top left corner.
*    .Width,
*    .Height        : Gadget size.
*    .Id            : Identification number.
*    .Active        : Render program drawing the gadget if it is active.
*    .Passive       : Render program drawing the gadget if it is passive.
*                     If this routine is NULL the library uses a ghosting
*                     mechanism for displaying deactivated gadgets.
*    .Select        : Render program executed when the gadget is selected.
*                     The program is passed over the width (in FP+1) and
*                     height (in FP+0) of the item so that several gadgets
*                     can share the same program.  If it is a PropGadget then
*                     the size of the KNOB (in FP+0) or the height of the
*                     knob for vertical PropGadget (in FP+0) is passed over !
*    .Release       : Render program called when the gadget is released.
*                     The program is passed over the item size, too. It is
*                     called even when the gadget is drawn so that at the
*                     beginning it is deselected. For PropGadgets this programm
*                     is called for the KNOB when the gadget is passive.
*
*    .Flags         : Gadget flags.
*
*      - GADGET_BORDER   : Gadget is in the window border.
*      - REL_RIGHT       : Gadget coordinates are relative to the right window
*                          border.
*      - REL_BOTTOM      : Gadget coordinates are relative to the bottom
*                          window border.
*      - SYS_GADGET      : It is a system gadget.
*      - GADGET_SELECTED : Gadget is currently selected.
*      - REL_VERIFY      : Gadget sends message only if the pointer was over
*                          it when the mouse button was released.
*      - GADGET_IMMEDIATE: Gadget sends message as soon as clicked onto.
*      - TOGGLE_SELECT   : For bool gadgets, the gadget toggles its state each
*                          time selected.
*      - REPEAT_GADGET   : As long as pressed, the gadget sends messages in
*                          short intervals.
*      - GADGET_INACTIVE : Gadget cannot be selected.
*      - STD_HIGHLIGHT   : Gadget gets a standard highlight methode, a 3D
*                          border.
*      - STD_COMPLEMENT  : Gadget gets a standard highlight method by inverting
*                          the gadget area.
*
*    .Type          : Gadget's type.
*    .HotKey        : Character that the user can use to activate/toggle..
*                     the gadget. A null byte stands for no activating key.
*    .Call          : Function called before the gadget sends its message.
*                     The function gets a message pointer in A1 and may change
*                     the message to its gusto.  If the message's EIDCMP flags
*                     are cleared, the message is not sent.
*    .UserData      : Free for user data (wonderful).
*
*
*  BoolGadget:
*
*    .Flag          : Flag set or cleared corresponding to the gadget state.
*    .Exclude,
*    .Include       : Arrays of pointer to boolgadgets, that shall change their
*                     state if this gadget is activated.
*
*  StringGadget:
*
*    .Buffer        : Pointer to a buffer containing the text.  The text
*                     terminates with a null byte and can be read from this
*                     buffer after processing.
*    .UndoBuffer    : Pointer to undo buffer.  The undo buffer must be at
*                     least as big as the original buffer.  Selecting the
*                     gadget copies the buffer's contents into the undo
*                     buffer.  By pressing Amiga-O the undo buffer is copied
*                     into the original buffer.
*    .BufferPos     : Cursor posititon in the text buffer.
*    .MaxChars      : Maximum characters in the buffer.
*    .numChars      : Contains during and after processing the number of
*                     characters in the buffer.
*    .UndoPos       : Cursor position in the undo buffer.
*
*    .Justify       : Specifies if the text is to appear on the left, right
*                     or in the center of the gadget box.
*    .Font          : EFont to use for editing, must be non proportional
*
*
*   The programs "select" and "release" have no function for string gadgets
*   as then the activity is indicated by the visible cursor.
*
*
*  PropGadget:
*
*    .Propflags     : Gadget flags:
*
*      - PROP_HORIZ      : Gadget moves horizontally if this bit is set, else
*                         vertically.
*      - PROP_FOLLOW     : The program gest a new message each time the knob
*                         moves.  You should use this flag with care as
*                         messages are sent frequently.
*      - PROP_BORDER     : The gadget is resized automatically if the window
*                         is resized.
*      - PROP_MOVES      : The gadget's knob is currently being moved.
*
*
*    .Maximum       : Maximum gadget value.
*    .Size          : Knob size in gadget units.
*    .Value         : Value of the gadget.
*
*   The programs "active"/"passive" should draw the gadget border.
*   The programs "select"/"release" are called to draw the knob and are passed
*   over the knob width (the knob height for vertical PropGadgets).
*   Example:  .maximum contains 1000.  Then .value and .size must be in the
*   range from 0 to 1000.  If one fifth of the data is visible, then .size
*   is 1000/5 = 200 and the maximum value for .value is 800.
*
*
*  IntegerGadget, RealGadget:
*
*    .Value         : Value after editing is finished.
*    .Valid         : Flag set after editing is finished.
*
*
*  UserGadget:
*
*    SelectCall     : Function to be called, when the gadget is selected,
*                     or NULL for no call, same parameters as .call.
*    ReleaseCall    : Function to be called, if the gadget is released,
*                     or NULL for no call, same parameters as .call.
*    ActionCall     : Function to be called, when the gadget is active and
*                     and event specified in .callFlags occurs.
*
*  MasterGadget:
*
*    MasterType     : Custom type identifier for this gadget.
*    FirstSon       : Pointer to first secondary gadget
*    NumSons        : Number of secondary gadgets
*
*
*

* Corresponding GadgetFlagSet has 16 bits !

EI_GADGET_BORDER              EQU     $0001
EI_REL_RIGHT                  EQU     $0002
EI_REL_BOTTOM                 EQU     $0004
EI_SYS_GADGET                 EQU     $0008
EI_GADGET_SELECTED            EQU     $0010
EI_REL_VERIFY                 EQU     $0020
EI_GADGET_IMMEDIATE           EQU     $0040
EI_TOGGLE_SELECT              EQU     $0080
EI_REPEAT_GADGET              EQU     $0100
EI_GADGET_INACTIVE            EQU     $0200
EI_STD_HIGHLIGHT              EQU     $0400
EI_STD_COMPLEMENT             EQU     $0800
EI_OLD_SELECT                 EQU     $1000
EI_CALL_ON_ELSEKEY            EQU     $2000
EI_CALL_ON_ANYKEY             EQU     $4000

EI_ACTION_GADGET              EQU     0
EI_BOOL_GADGET                EQU     1
EI_STRING_GADGET              EQU     2
EI_PROP_GADGET                EQU     3
EI_INTEGER_GADGET             EQU     4
EI_USERDEF_GADGET             EQU     5
EI_MASTER_GADGET              EQU     6
EI_REAL_GADGET                EQU     7

 STRUCTURE  EIGadget,0
    APTR           eiga_PrevGadget
    APTR           eiga_NextGadget
    WORD           eiga_CheckLeft
    WORD           eiga_CheckTop
    WORD           eiga_LeftEdge
    WORD           eiga_TopEdge
    WORD           eiga_Width
    WORD           eiga_Height
    LONG           eiga_GadgetID
    APTR           eiga_Active
    APTR           eiga_Passive
    APTR           eiga_Select
    APTR           eiga_Release
    UWORD          eiga_Flags
    UBYTE          eiga_GadgetType
    UBYTE          eiga_HotKey
    APTR           eiga_Call


* You get the message in A1, and have to adhere to standard calling
*  convention (A0/A1, D0/D1 are scratch).
*
    APTR    eiga_UserData
    LABEL   eiga_SIZEOF

 STRUCTURE  EIBoolGadget,0
    STRUCT  eibg_Class,eiga_SIZEOF
    UBYTE   eibg_Flag
    UBYTE   eibg_Pad_1
    UBYTE   eibg_Pad_2
    UBYTE   eibg_Pad_3
    APTR    eibg_Exclude
    APTR    eibg_Include
    LABEL   eibg_SIZEOF

* Corresponding EI_PropFlagSet has 16 bits !

EI_PROP_HORIZ                  EQU     1
EI_PROP_FOLLOW                 EQU     2
EI_PROP_MOVES                  EQU     4
EI_PROP_BORDER                 EQU     8
EI_PROP_DELTA_REFRESH          EQU     16

* Optimized refresh (described below)

 STRUCTURE  EIPropGadget,0
    STRUCT  eipg_Class,eiga_SIZEOF
    UWORD   eipg_Propflags
    WORD    eipg_Maximum
    WORD    eipg_Size
    WORD    eipg_Value
    WORD    eipg_V_height
    WORD    eipg_V_pos
    LABEL   eipg_SIZEOF

*
*
*   These are examples of prop-gadget IntuiGfx programs for
*   rendering.
*
*   The PropBorder program must then be put in the field called
*   Active. This program renders the full border of the gadget
*   and clears the interior.
*
*   IG_IntuiGfx PropBorder[] = {
*       IG_Const-1,IG_Const-1,IG_Move,
*       IG_CNormal,IG_CLight,IG_CDark,
*       IG_GETFI+1,IG_ADDI+2,
*       IG_GETFI+0,IG_ADDI+2,
*       IG_Rect3d,IG_RTF+2 };
*
*   These are the knob programs for verical and horizontal prop-gadgets,
*   respectively. They are put into the Select field in the EI_Gadget
*   structure.
*
*   IG_IntuiGfx VPropKnobb[] = {
*       IG_CNormal, IG_CDark,   IG_CLight,
*       IG_GETFI+1, IG_GETFI+0,
*       IG_Rect3d,
*       IG_RTF+2 };
*
*   IG_IntuiGfx HPropKnobb[] = {
*       IG_CNormal, IG_CDark, IG_CLight,
*       IG_GETFI+0, IG_GETFI+1,
*       IG_Rect3d,  IG_RTF+2 };
*
*   If you want an optimized refresh for the knob, you have to set
*   the flag EI_PROP_DELTA_REFRESH and put a program into the Release
*   field. The program PropDeltaB[] below is an example of this.
*
*   IG_IntuiGfx PropDeltaB[] = {
*       IG_CNormal, IG_Color,
*       IG_GETFI+1, IG_GETFI+0,
*       IG_Box,     IG_RTF+2 };
*
*
*

* Enumeration type EI_StringJustify has 8 bits !

EI_JUSTIFY_LEFT                     EQU     0
EI_JUSTIFY_RIGHT                    EQU     1
EI_JUSTIFY_CENTER                   EQU     2

 STRUCTURE  EIStringGadget,0
    STRUCT  eisg_Class,eiga_SIZEOF
    APTR    eisg_Buffer
    APTR    eisg_UndoBuffer
    WORD    eisg_BufferPos
    WORD    eisg_MaxChars
    WORD    eisg_DispPos
    WORD    eisg_UndoPos
    WORD    eisg_NumChars
    WORD    eisg_DispCount
    WORD    eisg_DispFront
    WORD    eisg_CLeft
    WORD    eisg_CTop
    UBYTE   eisg_Justify
    UBYTE   eisg_Pad
    APTR    eisg_Font
    LABEL   eisg_SIZEOF

 STRUCTURE  EIIntGadget,0
    STRUCT  eiig_SG,eisg_SIZEOF
    LONG    eiig_Value
    UBYTE   eiig_Valid
    UBYTE   eiig_Pad
    LABEL   eiig_SIZEOF

 STRUCTURE  EIUserGadget,0
    STRUCT  eiug_Class,eiga_SIZEOF
    APTR    eiug_SelectCall
    APTR    eiug_ReleaseCall
    APTR    eiug_ActionCall

* IDCMPFlags to respond to for ActionCall:
    ULONG   eiug_CallFlags
    LABEL   eiug_SIZEOF

* You get the message in A1, and have to adhere to standard calling
*  convention (A0/A1, D0/D1 are scratch).
*
 STRUCTURE  EIMasterGadget,0
    STRUCT  eimg_Class,eiga_SIZEOF
    LONG    eimg_MasterType
    APTR    eimg_FirstSon
    WORD    eimg_NumSons
    WORD    eimg_Pad
    LABEL   eimg_SIZEOF

* STRUCTURE  EI_RealGadget,0
*    STRUCT  eirg_SG,eisg_SIZEOF
*    DOUBLE  eirg_Value
*    UBYTE   eirg_Valid
*    UBYTE   eirg_Pad
*    LABEL   eirg_SIZEOF

*
*  Screens
*
*  Screens are logical successors of the EGS "EScreens".  They are extended
*  by fields for window and layer support.
*
*  If no windows are needed it does not pay to use the screens from this
*  module as they have some overhead.  Moreover, EGSIntui screens cannot
*  catch and redirect events.
*
* ---------------------------------------------------------------------------
*
*  Structures:
*
*  NewScreen
*
*    .Mode        : Screen mode, refer to EGS library.
*    .Depth       : Screen depth, refer to EGS library.
*    .Title       : Screen title appearing in the title bar.
*    .Colors      : Screen colours, refer to EGS library.
*    .WinColors   : Recommended colours for windows.
*    .BackPen     : Screen background pen.
*    .BackPattern : Background pattern or picture for the screen.
*    .Mouse       : Standard mouse pointer for the screen.
*    .Font        : Font for screens and windows titlebar, if NULL the
*                   default fonts are used
*    .Flags       : The new screens screenflags
*
*  Screen,ScreenPtr
*
*    .Front,
*    .Back        : Chaining.
*    .EScreen     : Pointer to the EScreen structure.
*    .FirstWindow
*    .LastWindow  : Pointer to the screen's windows.
*    .RastPort    : Screen RastPort.
*    .Info        : Pointer to LayerInfo structure.
*    .BarLayer    : Pointer to layer of the title bar.
*    .BarRast     : Pointer to screen's RastPort.
*    .WinColors   : Recommended window colours of the screen.
*    .Width       : Screen width.
*    .Height      : Screen height.
*    .Title       : Pointer to screen title string (beware, a Cluster string).
*    .Mouse       : Pointer to standard mouse pointer of screen.
*    .Font        : The title font of the screen
*    .Flags       : The screens flags
*
*

* Corresponding EI_ScreenFlagSet has 8 bits
EI_SCREENQUIET                   EQU     1
EI_SCREENBEHIND                  EQU     2

 STRUCTURE  EINewScreen,0
    APTR    eins_Mode
    WORD    eins_Depth
    UWORD   eins_Pad_1
    APTR    eins_Title
    APTR    eins_Colors
    STRUCT  eins_WinColors,igwc_SIZEOF
    LONG    eins_BackPen
    APTR    eins_BackPattern
    APTR    eins_Mouse
    APTR    eins_Font
    UBYTE   eins_Flags
    UBYTE   eins_Pad
    LABEL   eins_SIZEOF

 STRUCTURE  EIScreen,0
    APTR    eisc_Front
    APTR    eisc_Back
    APTR    eisc_EScreen
    APTR    eisc_FirstWindow
    APTR    eisc_LastWindow
    APTR    eisc_RastPort
    APTR    eisc_LayerInfo
    APTR    eisc_BarLayer
    APTR    eisc_BarRast
    STRUCT  eisc_WinColors,igwc_SIZEOF
    WORD    eisc_Width
    WORD    eisc_Height
    APTR    eisc_Title
    APTR    eisc_Mouse
    APTR    eisc_Font
    WORD    eisc_GadSize
    UWORD   eisc_Pad1
    APTR    eisc_GadImages
    UBYTE   eisc_Flags
    UBYTE   eisc_Pad2
    UBYTE   eisc_Pad3
    UBYTE   eisc_Pad4
    APTR    eisc_WindowFont
    APTR    eisc_SGadImage
    APTR    eisc_Colors
    APTR    eisc_ColorLock
    APTR    eisc_UpGadImages
    LABEL   eisc_SIZEOF

*
*  Colortags
*
EI_CTAGBASE                EQU     $80010000
EIC_SCREEN_BACKPEN         EQU     (EI_CTAGBASE+$00)
EIC_WINDOW_BACKPEN         EQU     (EI_CTAGBASE+$01)
EIC_UNKNWON_PEN            EQU     (EI_CTAGBASE+$02)
EIC_TEXT_FRONT_PEN         EQU     (EI_CTAGBASE+$03)
EIC_TEXT_BACK_PEN          EQU     (EI_CTAGBASE+$04)
EIC_SCREENLIGHT            EQU     (EI_CTAGBASE+$05)
EIC_SCREEN_PEN             EQU     (EI_CTAGBASE+$06)
EIC_SCREEN_DARK            EQU     (EI_CTAGBASE+$07)
EIC_SCREEN_TEXT            EQU     (EI_CTAGBASE+$08)
EIC_WIN_LIGHT              EQU     (EI_CTAGBASE+$09)
EIC_WIN_PEN                EQU     (EI_CTAGBASE+$0A)
EIC_WIN_DARK               EQU     (EI_CTAGBASE+$0B)
EIC_WIN_TEXT               EQU     (EI_CTAGBASE+$0C)
EIC_WIN_ACTIVE_LIGHT       EQU     (EI_CTAGBASE+$0D)
EIC_WIN_ACTIVE_PEN         EQU     (EI_CTAGBASE+$0E)
EIC_WIN_ACTIVE_DARK        EQU     (EI_CTAGBASE+$0F)
EIC_WIN_ACTIVE_TEXT        EQU     (EI_CTAGBASE+$10)
EIC_WIN_SLEEP_LIGHT        EQU     (EI_CTAGBASE+$11)
EIC_WIN_SLEEP_PEN          EQU     (EI_CTAGBASE+$12)
EIC_WIN_SLEEP_DARK         EQU     (EI_CTAGBASE+$13)
EIC_WIN_SLEEP_TEXT         EQU     (EI_CTAGBASE+$14)
EIC_GADGET_LIGHT           EQU     (EI_CTAGBASE+$15)
EIC_GADGET_PEN             EQU     (EI_CTAGBASE+$16)
EIC_GADGET_DARK            EQU     (EI_CTAGBASE+$17)
EIC_GADGET_TEXT            EQU     (EI_CTAGBASE+$18)
EIC_GADGET_SEL_LIGHT       EQU     (EI_CTAGBASE+$19)
EIC_GADGET_SEL_PEN         EQU     (EI_CTAGBASE+$1A)
EIC_GADGET_SEL_DARK        EQU     (EI_CTAGBASE+$1B)
EIC_GADGET_SEL_TEXT        EQU     (EI_CTAGBASE+$1C)
EIC_TEXT_GADGET_FRONT      EQU     (EI_CTAGBASE+$1D)
EIC_TEXT_GADGET_BACK       EQU     (EI_CTAGBASE+$1E)
EIC_PROP_LIGHT             EQU     (EI_CTAGBASE+$1F)
EIC_PROP_PEN               EQU     (EI_CTAGBASE+$20)
EIC_PROP_DARK              EQU     (EI_CTAGBASE+$21)
EIC_KNOB_LIGHT             EQU     (EI_CTAGBASE+$22)
EIC_KNOB_PEN               EQU     (EI_CTAGBASE+$23)
EIC_KNOB_DARK              EQU     (EI_CTAGBASE+$24)
EIC_MENU_LIGHT             EQU     (EI_CTAGBASE+$25)
EIC_MENU_PEN               EQU     (EI_CTAGBASE+$26)
EIC_MENU_DARK              EQU     (EI_CTAGBASE+$27)
EIC_MENU_TEXT              EQU     (EI_CTAGBASE+$28)
EIC_MENU_SEL_LIGHT         EQU     (EI_CTAGBASE+$29)
EIC_MENU_SEL_PEN           EQU     (EI_CTAGBASE+$2A)
EIC_MENU_SEL_DARK          EQU     (EI_CTAGBASE+$2B)
EIC_MENU_SEL_TEXT          EQU     (EI_CTAGBASE+$2C)
EIC_MASTER_LIGHT           EQU     (EI_CTAGBASE+$2D)
EIC_MASTER_PEN             EQU     (EI_CTAGBASE+$2E)
EIC_MASTER_DARK            EQU     (EI_CTAGBASE+$2F)
EIC_MASTER_TEXT            EQU     (EI_CTAGBASE+$30)
EIC_WIN_GADGET_LIGHT       EQU     (EI_CTAGBASE+$31)
EIC_WIN_GADGET_DARK        EQU     (EI_CTAGBASE+$32)
EIC_WIN_GADGET_BACK        EQU     (EI_CTAGBASE+$33)
EIC_WIN_GADGET_PEN         EQU     (EI_CTAGBASE+$34)
EIC_TEXT_SELECT_FRONT_PEN  EQU     (EI_CTAGBASE+$35)
EIC_TEXT_SELECT_BACK_PEN   EQU     (EI_CTAGBASE+$36)
EIC_CURSOR_FRONT_PEN       EQU     (EI_CTAGBASE+$37)
EIC_CURSOR_BACK_PEN        EQU     (EI_CTAGBASE+$38)
EIC_CURSOR_SELECT_FRONT_PEN   EQU     (EI_CTAGBASE+$39)
EIC_CURSOR_SELECT_BACK_PEN    EQU     (EI_CTAGBASE+$3A)
EIC_CURSOR_INACTIVE_FRONT_PEN EQU     (EI_CTAGBASE+$3B)
EIC_CURSOR_INACTIVE_BACK_PEN  EQU     (EI_CTAGBASE+$3C)

EI_MTAGBASE                   EQU     $80020000
EIM_STANDARD_MOUSE            EQU     (EI_MTAGBASE+$00)
EIM_SLEEP_MOUSE               EQU     (EI_MTAGBASE+$01)
EIM_WAIT_MOUSE                EQU     (EI_MTAGBASE+$02)
EIM_DISK_READ_MOUSE           EQU     (EI_MTAGBASE+$03)
EIM_DISK_WRITE_MOUSE          EQU     (EI_MTAGBASE+$04)
EIM_DISKIO_MOUSE              EQU     (EI_MTAGBASE+$05)
EIM_WORKING_MOUSE             EQU     (EI_MTAGBASE+$06)
EIM_PLAY_MACRO_MOUSE          EQU     (EI_MTAGBASE+$07)
EIM_PRINTING_MOUSE            EQU     (EI_MTAGBASE+$08)
EIM_SEARCHING_MOUSE           EQU     (EI_MTAGBASE+$09)
EIM_FROZEN_MOUSE              EQU     (EI_MTAGBASE+$0A)
EIM_COPY_MOUSE                EQU     (EI_MTAGBASE+$0B)
EIM_SWAP_MOUSE                EQU     (EI_MTAGBASE+$0C)
EIM_MOVE_MOUSE                EQU     (EI_MTAGBASE+$0D)
EIM_SELECT_MOUSE              EQU     (EI_MTAGBASE+$0E)
EIM_ZOOM_MOUSE                EQU     (EI_MTAGBASE+$0F)
EIM_FILL_MOUSE                EQU     (EI_MTAGBASE+$10)
EIM_PASTE_MOUSE               EQU     (EI_MTAGBASE+$11)
EIM_CUT_MOUSE                 EQU     (EI_MTAGBASE+$12)
EIM_RECORD_MACRO_MOUSE        EQU     (EI_MTAGBASE+$13)
EIM_CROSSHAIR_MOUSE           EQU     (EI_MTAGBASE+$14)
EIM_SIZE_MOUSE                EQU     (EI_MTAGBASE+$15)
EIM_TEXT_MOUSE                EQU     (EI_MTAGBASE+$16)
EIM_AIRBRUSH_MOUSE            EQU     (EI_MTAGBASE+$17)
EIM_PICK_MOUSE                EQU     (EI_MTAGBASE+$18)
EIM_DRAW_MOUSE                EQU     (EI_MTAGBASE+$19)
EIM_PAINT_MOUSE               EQU     (EI_MTAGBASE+$1A)
EIM_SELECT_TO_MOUSE           EQU     (EI_MTAGBASE+$1B)
EIM_RANGE_MOUSE               EQU     (EI_MTAGBASE+$1C)
EIM_CLICK_MOUSE               EQU     (EI_MTAGBASE+$1D)
EIM_ROTATE_MOUSE              EQU     (EI_MTAGBASE+$1E)

*
*  Windows
*
*  Windows use layers, RastPorts and screens.  They are the super structure
*  of gadgets and menus.  If required, they send messages about user actions
*  and other events.
*
*  A window consists of one or two layers (GimmeZeroZero).  The overhead of
*  the second layer is not as big as to destroy the advantage of automatic
*  clipping.  Only simple requester windows without a sizing gadget should
*  be implemented with one-layered windows.
*
*  Windows can have a render program being executed automatically at refresh
*  by the library.  This frees the program from refreshing constant graphics
*  elements.
*
* ---------------------------------------------------------------------------
*
*  Structures:
*
*  EIntuiMsg, EIntuiMsgPtr
*
*    .class      : Type of message:
*
*      - iMOUSEBUTTONS  : Mouse button message; which button and whether
*                         pressed or released is contained in the code field.
*      - iMOUSEMOVE     : Mouse movement.
*      - iRAWKEY        : "Raw" key message, i.e. scan code and qualifier.
*                         If VanillaKey is also selected, normal key are
*                         reported as Vanillakey and control keys as RawKey
*                         message (like 2.0).
*      - iACTIVATE      : Window was activated.
*      - iWINDOWREFRESH : Window wants a refresh, the refresh key (refer to
*                         EGSLayers) is in the field "iAddress".
*      - iCLOSEWINDOW   : User has clicked onto the close gadget.
*      - iNEWSIZE       : Window was resized.
*      - iMENUPICK      : Menu item has been selected.
*      - iGADGETUP      : Gadget was selected.
*      - iVANILLakEY    : Message about translated key press, the ASCII code
*                         of the key is in the code field.
*      - iSIZEVERIFY    : If the user tries to resize the window, a SizeVerify
*                         message is sent.  EGSIntui waits until the message
*                         is replied.  The program can cancel the sizing
*                         action with the corresponding message in the code
*                         field.
*      - iDISKINSERTED  : Self-explanatory.
*      - iDISKREMOVED   : Self-explanatory.
*      - iNEWPREFS      : The Amiga preferences were changed.
*
*    .Code       : Additional information about the message.
*    .Qualifier  : State of the qualifiers (shift etc.) when the event was
*                  sent.
*    .IAddress   : Address of the structure that caused the event (gadget or
*                  menu).
*    .MouseX,
*    .MouseY     : Mouse position at event time, relative to top left corner
*                  of the window.
*    .Seconds,
*    .Micros     : Event time.
*    .IDCMPWindow: Window sending the message.
*
*  NewWindow
*
*    .LeftEdge,
*    .TopEdge    : Top left window corner.
*    .Width,
*    .Height     : Size of window's contents.
*    .MinWidth,
*    .MinHeight  : Minimum window size.
*    .MaxWidth,
*    .MaxHeight  : Maximum window size.
*    .Screen     : Screen on which the window shall open.  If NIL is speci-
*                  fied, the window is opened on a standard screen.  The
*                  program should make no assumptions regarding the screen,
*                  neither size nor depth.
*    .SysGadgets : System gadgets of the window:
*
*      - WINDOWCLOSE     : Close gadget.
*      - WINDOWSIZE      : Size gadget in the bottom right corner.
*      - WINDOWFRONT     : Gadget for window-to-front.
*      - WINDOWBACK      : Gadget for window-to-back; if only one of both
*                          gadgets is there it serves for both purposes just
*                          like Kick 2.0.
*      - WINDOWFLIP      : Flipping between two positions and sizes like
*                          Kick 2.0.
*      - WINDOWBIG       : Gadget for maximum size.
*      - WINDOWSMALL     : Gadget for minimum size.
*      - WINDOWICON      : Iconify.
*      - WINDOWARROWL,
*      - WINDOWARROWR,
*      - WINDOWARROWU,
*      - WINDOWARROWD    : Arrows for scrolling gadgets.
*      - WINDOWSCROLLH,
*      - WINDOWSCROLLV   : Scrolling gadgets for the window.
*      - WINDOWDRAG      : Dragging gadget.
*
*    .Gadgets    : List of gadgets that the window is to have from the
*                  beginning.
*    .Name       : Window title.
*    .Flags      : Window flags (what else ?).
*
*      - GIMMEZEROZERO   : GZZ window with two layers and extra RastPort for
*                          inner area and the border.
*      - BORDERLESS      : Window has no border and cannot be moved.
*      - SUPERBITMAP     : Window gets a SuperBitMap layer, all initializing
*                          is done automatically, the size of the SuperBitMap
*                          is derived from the maximum window size.
*      - SIMPLEREFRESH   : User gets messages about refreshs.
*      - WINDOWACTIVE    : Window is currently active.
*      - WINDOWMENUlOCAL : Window menu is relative to the window title.
*      - OWNCOLORPALETTE : Window has a colour table on its own for its
*                          border etc.
*      - RMBTRAP         : If not pressed outside the window, a message is
*                          sent for the right mouse button instead of
*                          starting menu selection.
*      - REPORTMOUSE     : The mouse position is in intervals written into
*                          the window structure.  This flag is neccessary to
*                          get MouseMove events.
*      - BACKDROP        : The window is opened behind all other windows.
*      - SMARTREFRESH    : The window automatically refreshes itself in most
*                          cases apart from resizing.
*      - WINDOWMENUPOPUP : This window's menus appear directly at the mouse
*                          position.
*      - WINDOWSIZEBOTTOM: The window sizing gadget belongs only to the bottom
*                          border.
*      - WINDOWSIZERIGHT : The window sizing gadget belongs only to the right
*                          border.
*      - WINDOWUSERSTYLE : The window has its own rendering routine for its
*                          borders and gadgets
*      - ACTIVETOFRONT   : The window always comes to the front, when it is
*                          activated.
*      - QUICKSCROLL     : The window offset follows immediately the scroll-
*                          ing gadgets
*      - FIXWINDOWRATIO  : The window keeps the width/height ratio according
*                          to the maximum size, when resized by the user.
*
*    .IDCMPFlags : Events to be sent by the window.
*    .UserPort   : Pointer to a message port for user actions.  If the pointer
*                  is NIL the library creates an extra port and removes that
*                  port when closing the window.
*    .Colors     : Own colour table for border and text.
*    .MenuStrip  : Pointer to window menu.
*    .Render     : Render program to draw the standard window contents.
*
*  Window, WindowPtr
*
*    .LeftEdge,
*    .TopEdge    : Top left window corner.
*    .Width,
*    .Height     : Size of the inner window parts.
*    .LeftBorder,
*    .TopBorder,
*    .RightBorder,
*    .BottomBorder : Width or height of the window border.
*    .RPort      : RastPort of the window contents.
*    .Layer      : Layer of the window.
*    .Screen     : Pointer to the window's screen.
*    .MouseX,
*    .MouseY     : The mouse position relative to the top left window edge
*    .UserPort   : The windows message port
*

* Corresponding EI_SysGadgetSet has 32 bits !

EI_WINDOWCLOSE                  EQU     $00000001
EI_WINDOWSIZE                   EQU     $00000002
EI_WINDOWFRONT                  EQU     $00000004
EI_WINDOWBACK                   EQU     $00000008
EI_WINDOWFLIP                   EQU     $00000010
EI_WINDOWBIG                    EQU     $00000020
EI_WINDOWSMALL                  EQU     $00000040
EI_WINDOWICON                   EQU     $00000080
EI_WINDOWARROWL                 EQU     $00000100
EI_WINDOWARROWR                 EQU     $00000200
EI_WINDOWARROWU                 EQU     $00000400
EI_WINDOWARROWD                 EQU     $00000800
EI_WINDOWSCROLLH                EQU     $00001000
EI_WINDOWSCROLLV                EQU     $00002000
EI_WINDOWDRAG                   EQU     $00004000

* Corresponding EI_WindowFlagSet has 32 bits !

EI_GIMMEZEROZERO                EQU     $00000001
EI_BORDERLESS                   EQU     $00000002
EI_SUPER_BITMAP                 EQU     $00000004
EI_SIMPLE_REFRESH               EQU     $00000008
EI_WINDOWREFRESH                EQU     $00000010
EI_WINDOWACTIVE                 EQU     $00000020
EI_WINDOW_MENULOCAL             EQU     $00000040
EI_OWN_IDCMPPORT                EQU     $00000080
EI_OWN_COLORPALETTE             EQU     $00000100
EI_FRONTBACKGADGET              EQU     $00000200
EI_RMBTRAP                      EQU     $00000400
EI_REPORTMOUSE                  EQU     $00000800
EI_BACKDROP                     EQU     $00001000
EI_SMART_REFRESH                EQU     $00002000
EI_WINDOW_MENUPOPUP             EQU     $00004000
EI_SIZEBBOTTOM                  EQU     $00008000
EI_SIZEBRIGHT                   EQU     $00010000
EI_WINDOW_USERSTYLE             EQU     $00020000
EI_ACTIVETOFRONT                EQU     $00040000
EI_QUICKSCROLL                  EQU     $00080000
EI_WINDOW_SLEEPING              EQU     $00100000
EI_FIXWINDOW_RATIO              EQU     $00200000
EI_FORCE_TO_SCREEN              EQU     $00400000
EI_WINDOWCENTER                 EQU     $00800000
EI_SEND_OUTSIDEMOVES            EQU     $01000000

* Corresponding EI_EIDCMPFlagSet has 32 bits !

EI_iMOUSEBUTTONS                EQU     $00000001
EI_iMOUSEMOVE                   EQU     $00000002
EI_iRAWKEY                      EQU     $00000004
EI_iACTIVEWINDOW                EQU     $00000008
EI_iREFRESHWINDOW               EQU     $00000010
EI_iCLOSEWINDOW                 EQU     $00000020
EI_iNEWSIZE                     EQU     $00000040
EI_iMENUPICK                    EQU     $00000080
EI_iGADGETDOWN                  EQU     $00000100
EI_iGADGETUP                    EQU     $00000200
EI_iMENUVERIFY                  EQU     $00000400
EI_iVANILLAKEY                  EQU     $00000800
EI_iSIZEVERIFY                  EQU     $00001000
EI_iINACTIVEWINDOW              EQU     $00002000
EI_iINTUITICKS                  EQU     $00004000
EI_iDISKINSERT                  EQU     $00008000
EI_iDISKREMOVE                  EQU     $00010000
EI_iNEWPREFS                    EQU     $00020000
EI_iMOVEWINDOW                  EQU     $00040000

 STRUCTURE  EIWindow,0
    APTR    eiwi_Front
    APTR    eiwi_Back
    APTR    eiwi_Prev
    APTR    eiwi_Next
    APTR    eiwi_OldActive
    WORD    eiwi_LeftEdge
    WORD    eiwi_TopEdge
    WORD    eiwi_Width
    WORD    eiwi_Height
    WORD    eiwi_BorderLeft
    WORD    eiwi_BorderTop
    WORD    eiwi_BorderRight
    WORD    eiwi_BorderBottom
    WORD    eiwi_FullWidth
    WORD    eiwi_FullHeight
    WORD    eiwi_Leftsed
    WORD    eiwi_RightUsed
    WORD    eiwi_MouseX
    WORD    eiwi_MouseY
    APTR    eiwi_RPort
    APTR    eiwi_WLayer
    APTR    eiwi_WScreen
    APTR    eiwi_BorderRPort
    APTR    eiwi_BorderLayer
    ULONG   eiwi_Flags
    ULONG   eiwi_IDCMPFlags
    APTR    eiwi_UserPort
    APTR    eiwi_FirstGadget
    STRUCT  eiwi_GadColors,4*5
                     ; in C EB_ColorTable  GadColors [5]
                     ; EB_ColorTable  is ULONG
    STRUCT  eiwi_WinColors,igwc_SIZEOF
    APTR    eiwi_Tile
    APTR    eiwi_ScrTitel
    APTR    eiwi_Border
    APTR    eiwi_Render
    APTR    eiwi_OuterMenu
    APTR    eiwi_MenuStrip
    APTR    eiwi_Pointer
    WORD    eiwi_MinWidth
    WORD    eiwi_MinHeight
    WORD    eiwi_MaxWidth
    WORD    eiwi_MaxHeight
    WORD    eiwi_FlipWidth
    WORD    eiwi_FlipHeight
    WORD    eiwi_FlipLeft
    WORD    eiwi_FlipTop
    APTR    eiwi_EFont
    APTR    eiwi_UserData
    APTR    eiwi_Colors
    LONG    eiwi_SleepCount
    LABEL   eiwi_SIZEOF

 STRUCTURE  EIEIntuiMsg,0
    STRUCT  eims_ExecMessage,MN_SIZE
    ULONG   eims_Class
    UWORD   eims_Code
    WORD    eims_Qualifier
    APTR    eims_IAddress
    WORD    eims_MouseX
    WORD    eims_MouseY
    ULONG   eims_Seconds
    ULONG   eims_Micros
    APTR    eims_IDCMPWindow
    WORD    eims_RepeatCount        * Number of repeated keys
    LABEL   eims_SIZEOF

*
*  EI_UserStyle
*
*  Structure for own look window border. Uses an IntuiGfx program to draw.
*  The parameters are defined as EI_US_xxx. If an own border is given, all
*  the system gadgets have to be supplied by the programmer too.
*
*  Example, the original egs window border:
*
*  {
*    black surrounding
*    IG_Const24+0x000000,IG_Color,
*    EI_US_Width,EI_US_Height,IG_Box2d,
*    first outer 3d border
*    IG_Const+1,IG_Const+1,IG_Locate,
*    IG_Const24+0x000000,EI_US_Middle,
*    EI_US_Width,IG_ADDI-2,
*    EI_US_Height,IG_ADDI-2,IG_Box3d,
*    second outer 3d border
*    IG_Const+2,IG_Const+2,IG_Locate,
*    EI_US_Dark,EI_US_Light,
*    EI_US_Width,IG_ADDI-4,
*    EI_US_Height,IG_ADDI-4,IG_
*    first inner 3d border
*    EI_US_Left,IG_ADDI-1,
*    EI_US_Top,IG_ADDI-1,IG_Locate,
*    EI_US_Middle,IG_Const24+0x000000,
*    EI_US_Width,EI_US_Left,IG_SUB,EI_US_Right,IG_SUB,IG_ADDI+2,
*    EI_US_Height,EI_US_Top,IG_SUB,EI_US_Bottom,IG_SUB,IG_ADDI+2,IG_Box3d,
*    second inner 3d border
*    EI_US_Left,IG_ADDI-2,
*    EI_US_Top,IG_ADDI-2,IG_Locate,
*    EI_US_Middle,IG_Const24+0x000000,
*    EI_US_Width,EI_US_Left,IG_SUB,EI_US_Right,IG_SUB,IG_ADDI+4,
*    EI_US_Height,EI_US_Top,IG_SUB,EI_US_Bottom,IG_SUB,IG_ADDI+4,IG_Box3d,
*    filled border area, top...
*    EI_US_Middle,IG_Color,
*    ... top ...
*    IG_Const+3,IG_Const+3,IG_Locate,
*    EI_US_Width,IG_ADDI-6,EI_US_Top,IG_ADDI-5,IG_Box,
*    ... right ...
*    EI_US_Right,IG_ADDI-5,IG_DUP,
*    IG_NEG,IG_Const+0,IG_Move,
*    EI_US_Height,EI_US_Top,IG_SUB,EI_US_Bottom,IG_SUB,IG_ADDI-4,IG_Box,
*    ... left ...
*    IG_Const+3,EI_US_Top,IG_ADDI-2,IG_Locate,
*    EI_US_Left,IG_ADDI-5,IG_DUP,
*    EI_US_Height,EI_US_Top,IG_SUB,EI_US_Bottom,IG_SUB,IG_ADDI+4,IG_Box,
*    ... bottom ...
*    IG_NEG,IG_Const+0,IG_Move,
*    EI_US_Width,IG_ADDI-6,EI_US_Bottom,IG_ADDI-5,IG_Box,
*    ... title ...
*    EI_US_Font,IG_Font,
*    EI_US_FHeight,IG_ADDI+7,IG_Const+6,IG_Locate,
*    EI_US_TextColor,IG_Color,EI_US_Name,IG_Write,
*    good bye

*    IG_RTF+13
*   }
*
*

EI_US_TEXTCOLOR    EQU   (IG_GETFI+12)  * color of title text
EI_US_LEFT         EQU   (IG_GETFI+11)  * width of left border
EI_US_TOP          EQU   (IG_GETFI+10)  * height of top border
EI_US_RIGHT        EQU   (IG_GETFI+9)   * width of right border
EI_US_BOTTOM       EQU   (IG_GETFI+8)   * height of bottom border
EI_US_FONT         EQU   (IG_GETFI+7)   * font of title text
EI_US_FHEIGHT      EQU   (IG_GETFI+6)   * fontheight
EI_US_NAME         EQU   (IG_GETFI+5)   * title, use IG_Write
EI_US_MIDDLE       EQU   (IG_GETFI+4)   * main border pen
EI_US_DARK         EQU   (IG_GETFI+3)   * dark border pen
EI_US_LIGHT        EQU   (IG_GETFI+2)   * light border pen
EI_US_WIDTH        EQU   (IG_GETFI+1)   * full window width and height
EI_US_HEIGHT       EQU   (IG_GETFI+0)   * including the border


 STRUCTURE  EIUserStyle,0
     WORD    eius_BorderLeft
     WORD    eius_BorderTop
     WORD    eius_BorderRight
     WORD    eius_BorderBottom
     APTR    eius_DrawBorder
     LABEL   eius_SIZEOF


 STRUCTURE  EINewWindow,0
    WORD    einw_LeftEdge
    WORD    einw_TopEdge
    WORD    einw_Width
    WORD    einw_Height
    WORD    einw_MinWidth
    WORD    einw_MinHeight
    WORD    einw_MaxWidth
    WORD    einw_MaxHeight
    APTR    einw_Screen

* Tag for this union is hidden by WindowUserStyle flag in "flags" field
                     ;  In C
    LABEL   einw_UserStyle       ; union {
    LABEL   einw_SysGadgets      ;      ULONG             SysGadgets;
                     ;      EI_UserStylePtr   UserStyle;
                     ;       } Bordef;
    APTR    einw_Bordef

    APTR    einw_FirstGadgets
    APTR    einw_Title
    ULONG   einw_Flags
    ULONG   einw_IDCMPFlags
    APTR    einw_Port
    STRUCT  einw_Colors,igwc_SIZEOF
    APTR    einw_Menu
    APTR    einw_Render
    LABEL   einw_SIZEOF

    ENDC    * EGS_EGSINTUI_I

