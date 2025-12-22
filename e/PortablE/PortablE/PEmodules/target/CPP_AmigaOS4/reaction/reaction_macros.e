/*
**    $VER: reaction_macros.h 53.21 (29.9.2013)
**
**    Reaction macros
**
**    (C) Copyright 1985-2005 Hyperion Entertainment VOF and Amiga, Inc.
**        All Rights Reserved
**
**    Copyright (c) 2010 Hyperion Entertainment CVBA.
**        All Rights Reserved.
*/
OPT PREPROCESS
PUBLIC MODULE 'intuition'  ->so that macros using NewObject() won't fail with a cryptic error
MODULE 'tools/installhook', 'target/utility/hooks', 'target/exec/types'

/****************************************************************************
 *  The following macro defines allow easy object creation.
 *
 *  You can do things such as:
 *
 *   layoutgadget = LayoutObject,
 *                      LAYOUT_BevelStyle, GroupFrame,
 *                      LAYOUT_AddChild,
 *                          ButtonObject,
 *                              GA_ID, 1L,
 *                              GA_Text, "_Hamburgers",
 *                          EndButton,
 *                      LAYOUT_AddChild,
 *                          ButtonObject,
 *                              GA_ID, 2L,
 *                              GA_Text, "Hot _Dogs",
 *                          EndButton,
 *                  EndLayout;
 *
 *   Be careful with your commas and colons; only the FIRST object gets
 *   an "End;", objects that are embedded should get a comma ("End,"), so
 *   that the TagList continues.
 */

/****************************************************************************
 * Gadget Objects Creation Macros
 */

/***************************************************************************/
#define AnimObject NewObject(NIL, 'anim.gadget'
		
#define ButtonObject NewObject(NIL, 'button.gadget'

#define ToggleObject NewObject(NIL, 'button.gadget', GA_TOGGLESELECT, TRUE

#define CheckBoxObject NewObject(CheckBox_GetClass(), NILA

#define ChooserObject NewObject(Chooser_GetClass(), NILA

#define ClickTabObject NewObject(ClickTab_GetClass(), NILA

#define ClickTabsObject ClickTabObject

#define PopUpObject NewObject(Chooser_GetClass(), NILA, CHOOSER_POPUP, TRUE

#define DropDownObject NewObject(Chooser_GetClass(), NILA, CHOOSER_DROPDOWN, TRUE

#define FillerObject NewObject(Filler_GetClass(), NILA

#define FuelGaugeObject NewObject(FuelGauge_GetClass(), NILA

#define FuelObject FuelGaugeObject

#ifndef GetColorObject
#define GetColorObject NewObject(GetColor_GetClass(), NILA
#endif

#ifndef GetFileObject
#define GetFileObject NewObject(GetFile_GetClass(), NILA
#endif

#ifndef GetFontObject
#define GetFontObject NewObject(GetFont_GetClass(), NILA
#endif

#ifndef GetScreenModeObject
#define GetScreenModeObject NewObject(GetScreenMode_GetClass(), NILA
#endif

#define IntegerObject NewObject(Integer_GetClass(), NILA

#define PaletteObject NewObject(Palette_GetClass(), NILA

#define PageObject NewObject(Page_GetClass(), NILA

#define PenMapObject NewObject(PenMap_GetClass(), NILA

#define LayoutObject NewObject(Layout_GetClass(), NILA

#define VLayoutObject NewObject(Layout_GetClass(), NILA, LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT

#define HLayoutObject NewObject(Layout_GetClass(), NILA

#define VGroupObject VLayoutObject
#define HGroupObject HLayoutObject

#define ListBrowserObject NewObject(ListBrowser_GetClass(), NILA

#define RadioButtonObject NewObject(RadioButton_GetClass(), NILA

#define MxObject RadioButtonObject

#define ScrollerObject NewObject(Scroller_GetClass(), NILA

#define SpeedBarObject NewObject(SpeedBar_GetClass(), NILA

#define SliderObject NewObject(Slider_GetClass(), NILA

#define StatusObject NewObject(StatusBar_GetClass(), NILA

#define StringObject NewObject(String_GetClass(), NILA

#define SpaceObject NewObject(Space_GetClass(), NILA

#define TextEditorObject NewObject(TextEditor_GetClass(), NILA

#define VirtualObject NewObject(Virtual_GetClass(), NILA

/****************************************************************************
 * Image Object Creation Macros
 */
#define BevelObject NewObject(Bevel_GetClass(), NILA

#define BitMapObject NewObject(BitMap_GetClass(), NILA

#define DrawListObject NewObject(DrawList_GetClass(), NILA

#define GlyphObject NewObject(Glyph_GetClass(), NILA

#define LabelObject NewObject(Label_GetClass(), NILA

/****************************************************************************
 * Class Object Creation Macros
 */
#define WindowObject NewObject(Window_GetClass(), NILA

#define ARexxObject NewObject(ARexx_GetClass(), NILA

/****************************************************************************
 * Window class method macros
 */

#define RA_OpenWindow(win/*:PTR TO /*Object*/ ULONG*/) IdoMethod(win, WM_OPEN, 0)!!PTR TO window

#define RA_CloseWindow(win/*:PTR TO /*Object*/ ULONG*/) IdoMethod(win, WM_CLOSE, 0)

#define RA_HandleInput(win/*:PTR TO /*Object*/ ULONG*/, code) IdoMethod(win, WM_HANDLEINPUT, code)

#define RA_Iconify(win/*:PTR TO /*Object*/ ULONG*/) (IdoMethod(win, WM_ICONIFY, 0)<>0)

#define RA_Uniconify(win/*:PTR TO /*Object*/ ULONG*/) RA_OpenWindow(win)

/****************************************************************************
 * ARexx class method macros
 */

#define RA_HandleRexx(obj) IdoMethod(obj, AM_HANDLEEVENT )
#define RA_FlushRexx(obj)  IdoMethod(obj, AM_FLUSH )

/* Easy macro to set up a Hook for a string gadget, etc
 */
#define RA_SetUpHook(apphook, func, data)  ra_SetUpHook(apphook,func,data)

PROC ra_SetUpHook(apphook:PTR TO hook, func:PTR, data:APTR2)
	installhook(apphook, func)
	apphook.data := data
ENDPROC

/****************************************************************************
 * Additional BOOPSI Classes.
 */

#define ColorWheelObject NewObject(NULL, 'colorwheel.gadget'
#define GradientObject   NewObject(NULL, 'gradientslider.gadget'
#define LedObject        NewObject(NULL, 'led.image'

/****************************************************************************
 * Reaction synomyms for End which can make layout
 * groups easier to follow.
 */
#define WindowEnd           End

#define AnimEnd             End
#define BitMapEnd           End
#define ButtonEnd           End
#define CheckBoxEnd         End
#define ChooserEnd          End
#define ClickTabEnd         End
#define ClickTabsEnd        End
#define FillerEnd           End
#define FuelGaugeEnd        End
#define IntegerEnd          End
#define PaletteEnd          End
#define LayoutEnd           End
#define ListBrowserEnd      End
#define PageEnd             End
#define RadioButtonEnd      End
#define ScrollerEnd         End
#define SpeedBarEnd         End
#define SliderEnd           End
#define StatusEnd           End
#define StringEnd           End
#define SpaceEnd            End
#define StatusbarEnd        End
#define TextEditorEnd       End
#define VirtualEnd          End

#define ARexxEnd            End

#define BevelEnd            End
#define DrawListEnd         End
#define GlyphEnd            End
#define LabelEnd            End

#define ColorWheelEnd       End
#define GradientSliderEnd   End
#define LedEnd              End

/****************************************************************************
 * Vector Glyph Images.
 */
#define GetPath       GLYPH_POPDRAWER
#define GetFile       GLYPH_POPFILE
#define GetScreen     GLYPH_POPSCREENMODE
#define GetTime       GLYPH_POPTIME
#define CheckMark     GLYPH_CHECKMARK
#define PopUp         GLYPH_POPUP
#define DropDown      GLYPH_DROPDOWN
#define ArrowUp       GLYPH_ARROWUP
#define ArrowDown     GLYPH_ARROWDOWN
#define ArrowLeft     GLYPH_ARROWLEFT
#define ArrowRight    GLYPH_ARROWRIGHT

/****************************************************************************
 * Bevel Frame Types.
 */
#define ThinFrame     BVS_THIN
#define ButtonFrame   BVS_BUTTON
#define StandardFrame BVS_STANDARD
#define RidgeFrame    BVS_FIELD
#define StringFrame   BVS_FIELD
#define GroupFrame    BVS_GROUP
#define DropBoxFrame  BVS_DROPBOX
#define HBarFrame     BVS_SBAR_HORIZ
#define VBarFrame     BVS_SBAR_VERT
#define RadioFrame    BVS_RADIOBUTTON
#define MxFrame       BVS_RADIOBUTTON

/****************************************************************************
 * Often used simple gadgets
 */
#define Label(text) CHILD_LABEL,LabelObject, LABEL_TEXT,text, End

#define Button(text,id) ButtonObject, GA_TEXT,text, GA_ID,id, GA_RELVERIFY,TRUE, End

#define PushButton(text,id) ButtonObject, GA_TEXT,text, GA_ID,id, GA_RELVERIFY,TRUE, BUTTON_PUSHBUTTON,TRUE, End

#define TextLine(text) ButtonObject, GA_TEXT,text, GA_READONLY,TRUE, End

#define LabelTextLine(text,label) TextLine(text), Label(label)

#define String(text,id,maxchars) StringObject, STRINGA_TEXTVAL,text, STRINGA_MAXCHARS,maxchars, GA_ID,id, GA_RELVERIFY,TRUE, GA_TABCYCLE,TRUE, End

#define LabelString(text,id,maxchars,label) String(text,id,maxchars), Label(label)

#define PopString(text,id,maxchars,image) LAYOUT_ADDCHILD, HLayoutObject,   \
            String(text,0,maxchars),      \
            ButtonObject,                 \
                BAG_AUTOBUTTON, image,    \
                GA_RELVERIFY,   TRUE,     \
                GA_ID,          id,       \
            End,                          \
        End

/****************************************************************************
 * BGUI style Window/Layout Group Macros.
 */
#define StartMember   LAYOUT_ADDCHILD
#define StartImage    LAYOUT_ADDIMAGE
#define StartHLayout  LAYOUT_ADDCHILD, HLayoutObject
#define StartVLayout  LAYOUT_ADDCHILD, VLayoutObject
#define StartHGroup   StartHLayout
#define StartVGroup   StartVLayout
#ifndef End
#define End           TAG_END)
#endif
#define EndWindow     End
#define EndMember     End
#define EndImage      End
#define EndObject     End
#define EndHGroup     End
#define EndVGroup     End
#define EndGroup      End

/****************************************************************************
 * Lazy typist BGUI inspired macros (BGUI is Copyright Jan van den Baard.)
 */
#define HAlign(p)     LAYOUT_HORIZALIGNMENT, p
#define VAlign(p)     LAYOUT_VERTALIGNMENT, p
#define Spacing(p)    LAYOUT_INNERSPACING, p
#define LOffset(p)    LAYOUT_LEFTSPACING, p
#define ROffset(p)    LAYOUT_RIGHTSPACING, p
#define TOffset(p)    LAYOUT_TOPSPACING, p
#define BOffset(p)    LAYOUT_BOTTOMSPACING, p

/****************************************************************************
 * And for even lazier typists....
 */
#define VCentered           LAYOUT_VERTALIGNMENT, LALIGN_CENTER
#define TAligned            LAYOUT_VERTALIGNMENT, LALIGN_TOP
#define BAligned            LAYOUT_VERTALIGNMENT, LALIGN_BOTTOM
#define HCentered           LAYOUT_HORIZALIGNMENT, LALIGN_CENTER
#define LAligned            LAYOUT_HORIZALIGNMENT, LALIGN_LEFT
#define RAligned            LAYOUT_HORIZALIGNMENT, LALIGN_RIGHT
#define Offset(x1,y1,x2,y2) LAYOUT_LEFTSPACING,   x1, \
                            LAYOUT_TOPSPACING,    y1, \
                            LAYOUT_RIGHTSPACING,  x2, \
                            LAYOUT_BOTTOMSPACING, y2
#define EvenSized           LAYOUT_EVENSIZE, TRUE
#define MemberLabel(a)      CHILD_LABEL, LabelObject, LABEL_TEXT, a, LabelEnd

/****************************************************************************
 * Easy Menu Macros.
 */
#define Title(t)       NM_TITLE, 0, t, NILA, 0, 0, NIL
#define Item(t,s,i)    NM_ITEM, 0, t, s, 0, 0, i!!APTR
#define ItemBar        NM_ITEM, 0, NM_BARLABEL, NILA, 0, 0, NIL
#define SubItem(t,s,i) NM_SUB, 0, t, s, 0, 0, i!!APTR
#define SubBar         NM_SUB, 0, NM_BARLABEL, NILA, 0, 0, NIL
#define EndMenu        NM_END, 0, NILA, NILA, 0, 0, NIL
