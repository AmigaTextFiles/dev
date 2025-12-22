with System; use System;
with Interfaces; use Interfaces;

with devices_timer; use devices_timer;

with Incomplete_Type; use Incomplete_Type;

package devices_InputEvent is

--#ifndef DEVICES_TIMER_H
--#include "devices/timer.h"
--#endif



IECLASS_NULL			: constant Unsigned_32 := 16#00#;
IECLASS_RAWKEY			: constant Unsigned_32 := 16#01#;
IECLASS_RAWMOUSE		: constant Unsigned_32 := 16#02#;
IECLASS_EVENT			: constant Unsigned_32 := 16#03#;
IECLASS_POINTERPOS		: constant Unsigned_32 := 16#04#;
IECLASS_TIMER			: constant Unsigned_32 := 16#06#;
IECLASS_GADGETDOWN		: constant Unsigned_32 := 16#07#;
IECLASS_GADGETUP		: constant Unsigned_32 := 16#08#;
IECLASS_REQUESTER		: constant Unsigned_32 := 16#09#;
IECLASS_MENULIST		: constant Unsigned_32 := 16#0A#;
IECLASS_CLOSEWINDOW		: constant Unsigned_32 := 16#0B#;
IECLASS_SIZEWINDOW		: constant Unsigned_32 := 16#0C#;
IECLASS_REFRESHWINDOW		: constant Unsigned_32 := 16#0D#;
IECLASS_NEWPREFS		: constant Unsigned_32 := 16#0E#;
IECLASS_DISKREMOVED		: constant Unsigned_32 := 16#0F#;
IECLASS_DISKINSERTED		: constant Unsigned_32 := 16#10#;
IECLASS_ACTIVEWINDOW		: constant Unsigned_32 := 16#11#;
IECLASS_INACTIVEWINDOW		: constant Unsigned_32 := 16#12#;
IECLASS_NEWPOINTERPOS		: constant Unsigned_32 := 16#13#;
IECLASS_MENUHELP		: constant Unsigned_32 := 16#14#;
IECLASS_CHANGEWINDOW		: constant Unsigned_32 := 16#15#;

IECLASS_MAX			: constant Unsigned_32 := 16#15#;


IESUBCLASS_COMPATIBLE	: constant Unsigned_32 := 16#00#;
IESUBCLASS_PIXEL	: constant Unsigned_32 := 16#01#;
IESUBCLASS_TABLET	: constant Unsigned_32 := 16#02#;

--struct IEPointerPixel	{
--    struct Screen	*iepp_Screen;	
--    struct {				
--	WORD	X;
--	WORD	Y;
--    }			iepp_Position;
--};
--
--struct IEPointerTablet	{
--    struct {
--	UWORD	X;
--	UWORD	Y;
--    }			iept_Range;	
--    struct {
--	UWORD	X;
--	UWORD	Y;
--    }			iept_Value;	
--    WORD		iept_Pressure;	
--};
--

IECODE_UP_PREFIX		: constant Unsigned_32 := 16#80#;
IECODE_KEY_CODE_FIRST		: constant Unsigned_32 := 16#00#;
IECODE_KEY_CODE_LAST		: constant Unsigned_32 := 16#77#;
IECODE_COMM_CODE_FIRST		: constant Unsigned_32 := 16#78#;
IECODE_COMM_CODE_LAST		: constant Unsigned_32 := 16#7F#;

IECODE_C0_FIRST			: constant Unsigned_32 := 16#00#;
IECODE_C0_LAST			: constant Unsigned_32 := 16#1F#;
IECODE_ASCII_FIRST		: constant Unsigned_32 := 16#20#;
IECODE_ASCII_LAST		: constant Unsigned_32 := 16#7E#;
IECODE_ASCII_DEL		: constant Unsigned_32 := 16#7F#;
IECODE_C1_FIRST			: constant Unsigned_32 := 16#80#;
IECODE_C1_LAST			: constant Unsigned_32 := 16#9F#;
IECODE_LATIN1_FIRST		: constant Unsigned_32 := 16#A0#;
IECODE_LATIN1_LAST		: constant Unsigned_32 := 16#FF#;

IECODE_LBUTTON			: constant Unsigned_32 := 16#68#;
IECODE_RBUTTON			: constant Unsigned_32 := 16#69#;
IECODE_MBUTTON			: constant Unsigned_32 := 16#6A#;
IECODE_NOBUTTON			: constant Unsigned_32 := 16#FF#;

IECODE_NEWACTIVE		: constant Unsigned_32 := 16#01#;
IECODE_NEWSIZE			: constant Unsigned_32 := 16#02#;
IECODE_REFRESH			: constant Unsigned_32 := 16#03#;


IECODE_REQSET			: constant Unsigned_32 := 16#01#;
IECODE_REQCLEAR			: constant Unsigned_32 := 16#00#;


IEQUALIFIER_LSHIFT		: constant Unsigned_32 := 16#0001#;
IEQUALIFIER_RSHIFT		: constant Unsigned_32 := 16#0002#;
IEQUALIFIER_CAPSLOCK		: constant Unsigned_32 := 16#0004#;
IEQUALIFIER_CONTROL		: constant Unsigned_32 := 16#0008#;
IEQUALIFIER_LALT		: constant Unsigned_32 := 16#0010#;
IEQUALIFIER_RALT		: constant Unsigned_32 := 16#0020#;
IEQUALIFIER_LCOMMAND		: constant Unsigned_32 := 16#0040#;
IEQUALIFIER_RCOMMAND		: constant Unsigned_32 := 16#0080#;
IEQUALIFIER_NUMERICPAD		: constant Unsigned_32 := 16#0100#;
IEQUALIFIER_REPEAT		: constant Unsigned_32 := 16#0200#;
IEQUALIFIER_INTERRUPT		: constant Unsigned_32 := 16#0400#;
IEQUALIFIER_MULTIBROADCAST	: constant Unsigned_32 := 16#0800#;
IEQUALIFIER_MIDBUTTON		: constant Unsigned_32 := 16#1000#;
IEQUALIFIER_RBUTTON		: constant Unsigned_32 := 16#2000#;
IEQUALIFIER_LEFTBUTTON		: constant Unsigned_32 := 16#4000#;
IEQUALIFIER_RELATIVEMOUSE	: constant Unsigned_32 := 16#8000#;
IEQUALIFIERB_LSHIFT	: constant Unsigned_32 :=	0;
IEQUALIFIERB_RSHIFT	: constant Unsigned_32 :=	1;
IEQUALIFIERB_CAPSLOCK	: constant Unsigned_32 :=	2;
IEQUALIFIERB_CONTROL	: constant Unsigned_32 :=	3;
IEQUALIFIERB_LALT	: constant Unsigned_32 :=	4;
IEQUALIFIERB_RALT	: constant Unsigned_32 :=	5;
IEQUALIFIERB_LCOMMAND	: constant Unsigned_32 :=	6;
IEQUALIFIERB_RCOMMAND	: constant Unsigned_32 :=	7;
IEQUALIFIERB_NUMERICPAD	: constant Unsigned_32 :=	8;
IEQUALIFIERB_REPEAT	: constant Unsigned_32 :=	9;
IEQUALIFIERB_INTERRUPT		: constant Unsigned_32 :=10;
IEQUALIFIERB_MULTIBROADCAST	: constant Unsigned_32 :=11;
IEQUALIFIERB_MIDBUTTON		: constant Unsigned_32 :=12;
IEQUALIFIERB_RBUTTON		: constant Unsigned_32 :=13;
IEQUALIFIERB_LEFTBUTTON		: constant Unsigned_32 :=14;
IEQUALIFIERB_RELATIVEMOUSE	: constant Unsigned_32 :=15;

type InputEvent;
type InputEvent_Ptr is access InputEvent;
type InputEvent is record
    ie_NextEvent : InputEvent_Ptr;
    ie_Class : Unsigned_8;
    ie_SubClass : Unsigned_8;		
    ie_Code : Unsigned_16;			
    ie_Qualifier : Unsigned_16;		
    ie_x : Integer_16;
    ie_y : Integer_16;
    ie_TimeStamp : timeval;	
end record;

--#define	ie_X			ie_position.ie_xy.ie_x
--#define	ie_Y			ie_position.ie_xy.ie_y
--#define	ie_EventAddress		ie_position.ie_addr
--#define	ie_Prev1DownCode	ie_position.ie_dead.ie_prev1DownCode
--#define	ie_Prev1DownQual	ie_position.ie_dead.ie_prev1DownQual
--#define	ie_Prev2DownCode	ie_position.ie_dead.ie_prev2DownCode
--#define	ie_Prev2DownQual	ie_position.ie_dead.ie_prev2DownQual

end devices_InputEvent;
