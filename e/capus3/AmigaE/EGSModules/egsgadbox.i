    IFND    EGS_EGSGADBOX_I
EGS_EGSGADBOX_I     SET     1
*\
*  $
*  $ FILE     : egsgadbox.i
*  $ VERSION  : 1
*  $ REVISION : 6
*  $ DATE     : 07-Feb-93 18:04
*  $
*  $ Author   : mvk
*  $
*
*
* (c) Copyright 1990/93 VIONA Development
*     All Rights Reserved
*
*\
    IFND    EXEC_TYPES_I
    INCLUDE "exec/types.i"
    ENDC
    IFND    EGS_EGSGFX_I
    INCLUDE "egsgfx.i"
    ENDC
    IFND    EGS_EGSINTUI_I
    INCLUDE "egsintui.i"
    ENDC
    IFND    EGS_EGSINTUIGFX_I
    INCLUDE "egsintuigfx.i"
    ENDC

*
*  The egsgadbox.library is the basic library for font sensitive and resizeable
*  gadgets/requesters. The programmer defines the shape of a requester by
*  a recursive structure of boxes, a gadget box tree. The elements of this tree
*  can be gadgets, rendering routines or ordering boxes, that contain several
*  other boxes and order them in a given way. From this tree a list of gadgets
*  and a rendering programm for additional graphics is calculated.
*
*  The elements of this tree are generated using the function of this library,
*  and linked together by two functions. Lower elements in the tree serve as
*  additional graphics or gadgets for higher elements or gadgets. By the usage
*  of fillboxes and borderboxes, the elements can be grouped and separated.
*
*  Example for a color modification gadget, using three scrollers with arrows
*
*  Treestructure:
*
*  unknown, gadget : Master gadget for the requester
*  | horizontal, draw : Rectangle surrounding
*  | | unknown, - : horizontal fill box
*  | | vertical, - : grouping for the first prop gadget
*  | | | unknwon, gadget : upper arrow gadget, first scroller
*  | | | | horizontal, draw : Rectangle surrounding the arrow
*  | | | | | unknown, - : horizontal fill box
*  | | | | | vertical, - :
*  | | | | | | unknown, - : vertical fill box
*  | | | | | | unknown, draw : dynamic rendering of an arrow
*  | | | | | | unknown, - : vertical fill box
*  | | | | | unknown, - : horizontal fill box
*  | | | unknwon, gadget : scroller gadget, including its rendering
*  | | | unknwon, gadget : lower arrow gadget, first scroller
*  | | | | horizontal, draw : Rectangle surrounding the arrow
*  | | | | | unknown, - : horizontal fill box
*  | | | | | vertical, - :
*  | | | | | | unknown, - : vertical fill box
*  | | | | | | unknown, draw : dynamic rendering of an arrow
*  | | | | | | unknown, - : vertical fill box
*  | | | | | unknown, - : horizontal fill box
*  | | unknown, - : horizontal fill box
*  | | vertical, - : grouping for the second prop gadget
*  | | | unknwon, gadget : upper arrow gadget, secode scroller
*  | | | | horizontal, draw : Rectangle surrounding the arrow
*  | | | | | unknown, - : horizontal fill box
*  | | | | | vertical, - :
*  | | | | | | unknown, - : vertical fill box
*  | | | | | | unknown, draw : dynamic rendering of an arrow
*  | | | | | | unknown, - : vertical fill box
*  | | | | | unknown, - : horizontal fill box
*  | | | unknwon, gadget : scroller gadget, including its rendering
*  | | | unknwon, gadget : lower arrow gadget, first scroller
*  | | | | horizontal, draw : Rectangle surrounding the arrow
*  | | | | | unknown, - : horizontal fill box
*  | | | | | vertical, - :
*  | | | | | | unknown, - : vertical fill box
*  | | | | | | unknown, draw : dynamic rendering of an arrow
*  | | | | | | unknown, - : vertical fill box
*  | | | | | unknown, - : horizontal fill box
*
*    ...
*
*
*  Assuming con contains a valid EB_GadContext, and b1 and b2 are EB_GadBoxPtr,
*  this structure can be created by:
*
* b1 = EB_CreateHorizBox(con);
* EB_AddLastSon(b1,EB_CreateHorizFill(con,0,0));
* EB_AddLastSon(b1,EB_CreateSuperVertiProp(con,255,16,0,$1000,
*                                          EB_DEC_UP_LEFT|EB_INC_BOTTOM_RIGHT));
* EB_AddLastSon(b1,EB_CreateHorizFill(con,0,0));
* EB_AddLastSon(b1,EB_CreateSuperVertiProp(con,255,16,0,$1001,
*                                          EB_DEC_UP_LEFT|EB_INC_BOTTOM_RIGHT));
* EB_AddLastSon(b1,EB_CreateHorizFill(con,0,0));
* EB_AddLastSon(b1,EB_CreateSuperVertiProp(con,255,16,0,$1002,
*                                          EB_DEC_UP_LEFT|EB_INC_BOTTOM_RIGHT));
* EB_AddLastSon(b1,EB_CreateHorizFill(con,0,0));
* root = EB_CreateMaster(con,$4711,$1010);
* EB_AddLastSon(root, EB_CreateFrontBorder(con, b1, EB_FILL_ALL));
*
*  From this gadget tree a list of gadgets and a rendering programm can be
*  calculated using EB_ProcessGadBoxes.
*
*

*
*  EB_ContextPtr
*
*  Pointer to a structure that keeps track of allocated memory. This is used
*  to allocate the memory for the temporary tree, and permanent gadgets.
*

*
*  EB_ResBox
*
*  The library uses this structure to return locations and sizes of custom
*  boxes in the created requester/window. A pointer to this structure is
*  passed to EB_CreateResponseBox.
*
 STRUCTURE  EBResBox,0
    WORD    ebrb_X
    WORD    ebrb_Y
    WORD    ebrb_W
    WORD    ebrb_H
    LABEL   ebrb_SIZEOF

*
*  EB_InfoBox
*
*  Extension to the EB_ResBox structure, for changing textuell information
*
 STRUCTURE  EBInfoBox,0
    APTR    ebib_Font
    UBYTE   ebib_Justify
    UBYTE   ebib_Pad
    STRUCT  ebib_Box,ebrb_SIZEOF
    LABEL   ebib_SIZEOF

*
*  Fill flags, needed at several locations, to determine on which sides
*  further filling is recommended or posible.
*

EB_FILL_LEFT       EQU     1
EB_FILL_RIGHT      EQU     2
EB_FILL_TOP        EQU     4
EB_FILL_BOTTOM     EQU     8
EB_FILL_ALL        EQU     (EB_FILL_LEFT!EB_FILL_RIGHT!EB_FILL_TOP!EB_FILL_BOTTOM)

*
*  Types/orientation of gadboxes:
*
*   EB_HORIZONTAL  : the box may have several sons, which are
*                    ordered horizontal
*   EB_VERTICAL    : the box may have several sons, which are
*                    ordered vertical
*   EB_UNKNOWN     : the box may have only one son
*   EB_HORIZTABLE  : the box may have several sons, which may
*                    either be unknown, or vertical. All vertical
*                    sons must have the same number of sons,
*                    because the grandsons are ordered in a table.
*   EB_VERTITABLE  : the box may have several sons, which may
*                    either be unknown, or horizontal. All
*                    horizontal sons must have the same number of
*                    sons, because the grandsons are ordered in a
*                    table.
*   EB_SELECT      : the box may have several sons, which all lay
*                    at the same location.
*
EB_HORIZONTAL        EQU     0
EB_VERTICAL          EQU     1
EB_UNKNOWN           EQU     2
EB_HORIZTABLE        EQU     3
EB_VERTITABLE        EQU     4
EB_SELECT            EQU     5

*
*  The aim of a gadgbox is given in the type field, possible values are:
*
*   EB_GADGET    : The box is to create a gadget. A pointer to the gadget
*                  has to be put into the "gad" field.
*   EB_DRAW      : The box contains a draing routine, which is specified by
*                  the "draw" field.
*   EB_WINDOW    : The box has a pointer to a new window structure in its
*                  "new" field.
*   EB_LATE      : The meaning of the box is not yet clear. Through rendering
*                  the "call" procedure is called with a pointer to the
*                  gadget in A0.
*   EB_RESPONSE  : The box returns its size and location back to the user,
*                  using a supplied EB_ResBox structure.
*
EB_GADGET          EQU     0
EB_DRAW            EQU     1
EB_WINDOW          EQU     2
EB_LATE            EQU     3
EB_RESPONSE        EQU     4

*
*  EB_GadBox
*
*  The primary element of a gadbox tree. This boxes may not be created by
*  the programm, only by using functions from this or other EGB libraries.
*  All boxes are discarded, after the calculation of the real gadgets.
*
*    .Prev,
*    .Next      : chaining of elements in the same level
*    .Father    : pointer to the upper element
*    .First,
*    .Last      : pointers to the first and last elements of the leafs of this
*                 node
*    .Orient    : orientation
*    .MinWidth,
*    .MinHeight : minimal size of the box
*    .MaxWidth,
*    .MaxHeight : maximal size of the box
*    .X, .Y     : location, only valid after calculation
*    .Pri       : priority of the box
*                 If there is more room in a row/collumn, than needed by the
*                 elements, the additional space is spread over all elements
*                 of the highest priority until their maximum is reached. Then
*                 the elements with the next priority are stretched. This is
*                 continued, until there is no more space, or all elements
*                 are stretched to their maximum. In this case the additional
*                 space is used to center the elements in the surrounding box.
*    .Con       : pointer to associated gadget context
*    .Type      : type of gadbox
*     .Gad      : pointer to a gadget, that is resized and rendered by
*                 this box
*     .Draw     : drawing routine that is resized and located by this box
*     .New      : pointer to new window structure that is filled using the
*                 informations of this box
*     .Call     : Routine that is called during calculation, when all the boxes
*                 have their location and size. This routine may modify the
*                 box itself, as all calculation is performed on its son, after
*                 the call. This box type can be used to gain a list of gadgets,
*                 whichs number depends on the size of the surrounding box.
*     .Res      : pointer to EB_ResInfo structure, to be filled with information
*                 after calculation is done
*     .Selector : Routine that is called after calculation for an EB_select box
*                 that carries a gadget. The routine is called once for each
*                 son element with parameters, the parent box in A0, the number
*                 of the sons in D0 and the render routine of the son in A1.
*     .UserData : free for user data, very handy for late or select boxes
*
*
 STRUCTURE  EBGadBox,0
    APTR    ebgb_Prev
    APTR    ebgb_Next
    APTR    ebgb_Father
    APTR    ebgb_First
    APTR    ebgb_Last
    UBYTE   ebgb_Orient
    UBYTE   ebgb_Pad1
    WORD    ebgb_MinWidth
    WORD    ebgb_MaxWidth
    WORD    ebgb_MinHeight
    WORD    ebgb_MaxHeight
    WORD    ebgb_X
    WORD    ebgb_Y
    BYTE    ebgb_Pri
    UBYTE   ebgb_Pad2
    APTR    ebgb_Con
    UBYTE   ebgb_Type
    UBYTE   ebgb_Pad3
    UWORD   ebgb_Pad4

    LABEL   ebgb_Gad     * EI_GadgetPtr
    LABEL   ebgb_Draw    * IG_IntuiGfxPtr
    LABEL   ebgb_New     * struct EI_NewWindow  *
    LABEL   ebgb_Call    * EB_GBCreate
    LABEL   ebgb_Res     * EB_ResBoxPtr
    APTR    ebgb_Render  * union

    APTR    ebgb_Selector
    APTR    ebgb_UserData
    LABEL   ebgb_SIZEOF

*
*  Errormessages, supported by the .error field in the gadget context:
*
*   EB_OK                        : no error
*   EB_NOT_ENOUGH_MEMORY         : not enough memory for operation available
*   EB_UNKNOWN_WITH_MULTIPLE_SONS: a gadget with unknown location but several
*                                  sons was discoverd during calculation.
*   EB_STRING_GAD_NOT_FOUND      : A call to EB_LinkStringGadgets was done,
*                                  but the referenced gadgets could not be
*                                  found.
*   EB_ILLEGAL_SELECT            : A select box was discovered, which was no
*                                  gadget, or had no select call supported.
*   EB_UNKNOWN_FONT, EB_BAD_FONTS: The EB_CreateGadContext routine was called
*                                  with illegal fonts.
*   EB_NO_GAD_SOLUTION           : The library could not find a possible
*                                  solution for the given gadget box tree.
*   EB_UNMATCHING_TABLES         : A gadget table was discovered during
*                                  calculation, whichs sons had different
*                                  numbers of elements.
*
EB_OK                              EQU     0
EB_NOT_ENOUGH_MEMORY               EQU     $4000
EB_UNKNOWN_WITH_MULTIPLESONS       EQU     $4001
EB_STRINGGAD_NOT_FOUND             EQU     $4002
EB_ILLEGAL_SELECT                  EQU     $4003
EB_UNKNOWN_FONT                    EQU     $4004
EB_NO_WINDOW                       EQU     $4005
EB_NO_GAD_SOLUTION                 EQU     $4006
EB_BAD_FONTS                       EQU     $4007
EB_UNMATCHING_TABLES               EQU     $4008
EB_OWN_FONT                        EQU     1
EB_OWN_TFONT                       EQU     2

*
*  EB_GadContext
*
*  Structure that keeps track and information for a gadget box tree and the
*  resulting list of gadgets and renderings. All box creating routines need
*  this context as parameter. This structure is created and initialized using
*  EB_CreateGadContext. When it is deleted using EB_DeleteGadContext, all
*  asociated boxes, gadgets and rendering informations are also discarded,
*  so make sure, not to delete the context, before you closed the window.
*
*   .Gadres      : permanent context, that keeps existing after the gadgets
*                  have been calculated.
*   .Helres      : temporary context, that is deleted, after the gadgets have
*                  been calculated.
*   .FHeight,
*   .FWidth      : the size of the capital "M" in the desired font.
*   .Font        : font for gadget elements, and additional rendering
*   .TFont       : font for textgadgets and information fields
*   .NewWin      : pointer to EI_NewWindow structure, which is valid after
*                  calculation.
*   .First       : pointer to first gadget in the created list
*   .Num         : number of gadgets in this list
*   .Color, Back : colors for 24 bit gadgets
*   .Error       : errorconditions that occur during operation
*
 STRUCTURE  EBGadContextNode,0
    APTR    ebgc_Gadres
    APTR    ebgc_Helpres
    WORD    ebgc_FHeight
    WORD    ebgc_FWidth
    APTR    ebgc_Font
    APTR    ebgc_TFont
    APTR    ebgc_NewWin
    APTR    ebgc_First
    WORD    ebgc_Num
    UWORD   ebgc_Pad1
    ULONG   ebgc_Color
    ULONG   ebgc_Back
    UBYTE   ebgc_Flags
    UBYTE   ebgc_Pad2
    UWORD   ebgc_Error
    LABEL   ebgc_SIZEOF

 STRUCTURE  EBSPropGadget,0
    STRUCT  ebsp_Master,eimg_SIZEOF
    APTR    ebsp_RealProp
    LABEL   ebsp_SIZEOF

*
*  EB_Max, EB_Min : extrem sizes for gadget boxes, serve as don't care
*
EB_GAD_MAX      EQU     32767
EB_GAD_MIN      EQU     0

*
*  Arrow locations in SuperPropGadgets
*
EB_DEC_UP_LEFT        EQU     1
EB_DEC_BOTTOM_RIGHT   EQU     2
EB_INC_UP_LEFT        EQU     4
EB_INC_BOTTOM_RIGHT   EQU     8

    ENDC          ; EGS_EGSGADBOX_H
