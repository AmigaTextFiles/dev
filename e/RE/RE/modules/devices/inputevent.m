#ifndef DEVICES_INPUTEVENT_H
#define DEVICES_INPUTEVENT_H

#ifndef DEVICES_TIMER_H
MODULE  'devices/timer'
#endif
#ifndef UTILITY_HOOKS_H
MODULE  'utility/hooks'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif



#define IECLASS_NULL			$00

#define IECLASS_RAWKEY			$01

#define IECLASS_RAWMOUSE		$02

#define IECLASS_EVENT			$03

#define IECLASS_POINTERPOS		$04

#define IECLASS_TIMER			$06

#define IECLASS_GADGETDOWN		$07

#define IECLASS_GADGETUP		$08

#define IECLASS_REQUESTER		$09

#define IECLASS_MENULIST		$0A

#define IECLASS_CLOSEWINDOW		$0B

#define IECLASS_SIZEWINDOW		$0C

#define IECLASS_REFRESHWINDOW		$0D

#define IECLASS_NEWPREFS		$0E

#define IECLASS_DISKREMOVED		$0F

#define IECLASS_DISKINSERTED		$10

#define IECLASS_ACTIVEWINDOW		$11

#define IECLASS_INACTIVEWINDOW		$12

#define IECLASS_NEWPOINTERPOS		$13

#define IECLASS_MENUHELP		$14

#define	IECLASS_CHANGEWINDOW		$15

#define IECLASS_MAX			$15



#define IESUBCLASS_COMPATIBLE	$00

#define IESUBCLASS_PIXEL	$01

#define IESUBCLASS_TABLET	$02

#define IESUBCLASS_NEWTABLET	   $03

OBJECT IEPointerPixel
	
     	Screen:PTR TO Screen	
     OBJECT Position
				
	X:WORD
	Y:WORD
    			ENDOBJECT
ENDOBJECT


OBJECT IEPointerTablet
	
     OBJECT Range

	X:UWORD
	Y:UWORD
    			ENDOBJECT
	     OBJECT Value

	X:UWORD
	Y:UWORD
    			ENDOBJECT
	    Pressure:WORD	
ENDOBJECT


OBJECT IENewTablet

    
      CallBack:PTR TO Hook
    
    ScaledX:UWORD
 ScaledY:UWORD
    ScaledXFraction:UWORD
 ScaledYFraction:UWORD
    
    TabletX:LONG
 TabletY:LONG
    
    RangeX:LONG
 RangeY:LONG
    
      TagList:PTR TO TagItem
ENDOBJECT



#define IECODE_UP_PREFIX		$80
#define IECODE_KEY_CODE_FIRST		$00
#define IECODE_KEY_CODE_LAST		$77
#define IECODE_COMM_CODE_FIRST		$78
#define IECODE_COMM_CODE_LAST		$7F

#define IECODE_C0_FIRST			$00
#define IECODE_C0_LAST			$1F
#define IECODE_ASCII_FIRST		$20
#define IECODE_ASCII_LAST		$7E
#define IECODE_ASCII_DEL		$7F
#define IECODE_C1_FIRST			$80
#define IECODE_C1_LAST			$9F
#define IECODE_LATIN1_FIRST		$A0
#define IECODE_LATIN1_LAST		$FF

#define IECODE_LBUTTON			$68	
#define IECODE_RBUTTON			$69
#define IECODE_MBUTTON			$6A
#define IECODE_NOBUTTON			$FF

#define IECODE_NEWACTIVE		$01	
#define IECODE_NEWSIZE			$02	
#define IECODE_REFRESH			$03	



#define IECODE_REQSET			$01

#define IECODE_REQCLEAR			$00

#define IEQUALIFIER_LSHIFT		$0001
#define IEQUALIFIER_RSHIFT		$0002
#define IEQUALIFIER_CAPSLOCK		$0004
#define IEQUALIFIER_CONTROL		$0008
#define IEQUALIFIER_LALT		$0010
#define IEQUALIFIER_RALT		$0020
#define IEQUALIFIER_LCOMMAND		$0040
#define IEQUALIFIER_RCOMMAND		$0080
#define IEQUALIFIER_NUMERICPAD		$0100
#define IEQUALIFIER_REPEAT		$0200
#define IEQUALIFIER_INTERRUPT		$0400
#define IEQUALIFIER_MULTIBROADCAST	$0800
#define IEQUALIFIER_MIDBUTTON		$1000
#define IEQUALIFIER_RBUTTON		$2000
#define IEQUALIFIER_LEFTBUTTON		$4000
#define IEQUALIFIER_RELATIVEMOUSE	$8000
#define IEQUALIFIERB_LSHIFT		0
#define IEQUALIFIERB_RSHIFT		1
#define IEQUALIFIERB_CAPSLOCK		2
#define IEQUALIFIERB_CONTROL		3
#define IEQUALIFIERB_LALT		4
#define IEQUALIFIERB_RALT		5
#define IEQUALIFIERB_LCOMMAND		6
#define IEQUALIFIERB_RCOMMAND		7
#define IEQUALIFIERB_NUMERICPAD		8
#define IEQUALIFIERB_REPEAT		9
#define IEQUALIFIERB_INTERRUPT		10
#define IEQUALIFIERB_MULTIBROADCAST	11
#define IEQUALIFIERB_MIDBUTTON		12
#define IEQUALIFIERB_RBUTTON		13
#define IEQUALIFIERB_LEFTBUTTON		14
#define IEQUALIFIERB_RELATIVEMOUSE	15

OBJECT InputEvent
 
       NextEvent:PTR TO InputEvent	
    Class:UBYTE			
    SubClass:UBYTE		
    Code:UWORD			
    Qualifier:UWORD		
     UNION position

	 OBJECT xy

	    x:WORD		
	    y:WORD
	 ENDOBJECT
	addr:LONG		
	 OBJECT dead

	    prev1DownCode:UBYTE	
	    prev1DownQual:UBYTE	
	    prev2DownCode:UBYTE	
	    prev2DownQual:UBYTE	
	 ENDOBJECT
     ENDUNION
      TimeStamp:timeval	
ENDOBJECT

#define	ie_X			ie_position.ie_xy.ie_x
#define	ie_Y			ie_position.ie_xy.ie_y
#define	ie_EventAddress		ie_position.ie_addr
#define	ie_Prev1DownCode	ie_position.ie_dead.ie_prev1DownCode
#define	ie_Prev1DownQual	ie_position.ie_dead.ie_prev1DownQual
#define	ie_Prev2DownCode	ie_position.ie_dead.ie_prev2DownCode
#define	ie_Prev2DownQual	ie_position.ie_dead.ie_prev2DownQual
#endif	
