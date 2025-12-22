include "inc/devices/timer.inc";
include "inc/utility/hooks.inc";
include "inc/utility/tagitem.inc";

def IECLASS_NULL = $00;
def IECLASS_RAWKEY = $01;
def IECLASS_RAWMOUSE = $02;
def IECLASS_EVENT = $03;
def IECLASS_POINTERPOS = $04;
def IECLASS_TIMER = $06;
def IECLASS_GADGETDOWN = $07;
def IECLASS_GADGETUP = $08;
def IECLASS_REQUESTER = $09;
def IECLASS_MENULIST = $0a;
def IECLASS_CLOSEWINDOW = $0b;
def IECLASS_SIZEWINDOW = $0c;
def IECLASS_REFRESHWINDOW = $0d;
def IECLASS_NEWPREFS = $0e;
def IECLASS_DISKREMOVED = $0f;
def IECLASS_DISKINSERTED = $10;
def IECLASS_ACTIVEWINDOW = $11;
def IECLASS_INACTIVEWINDOW = $12;
def IECLASS_NEWPOINTERPOS = $13;
def IECLASS_MENUHELP = $14;
def IECLASS_CHANGEWINDOW = $15;

def IECLASS_MAX = $15;

def IESUBCLASS_COMPATIBLE = $00;
def IESUBCLASS_PIXEL = $01;
def IESUBCLASS_TABLET = $02;
def IESUBCLASS_NEWTABLET = $03;

struct IEPointerPixel is
  iepp_Screen:ulong;
  iepp_Position:struct is
    X:word;
    Y:word;
  ;
;

struct IEPointerTablet is
  iept_Range:struct is
    X:uword;
    Y:uword;
  ;
  iept_Value:struct is
    X:uword;
    Y:uword;
  ;

  iept_Pressure:word;
;

struct IENewTablet is
  ient_CallBack:ulong;
  ient_ScaledX,ient_ScaledY:uword;
  ient_ScaledXFraction,ient_ScaledYFraction:uword;
  ient_TabletX,ient_TabletY:ulong;
  ient_RangeX,ient_RangeY:ulong;
  ient_TagList:ulong;
;

def IECODE_UP_PREFIX = $80;
def IECODE_KEY_CODE_FIRST = $00;
def IECODE_KEY_CODE_LAST = $77;
def IECODE_COMM_CODE_FIRST = $78;
def IECODE_COMM_CODE_LAST = $7f;

def IECODE_C0_FIRST = $00;
def IECODE_C0_LAST = $1f;
def IECODE_ASCII_FIRST = $20;
def IECODE_ASCII_LAST = $7e;
def IECODE_ASCII_DEL = $7f;
def IECODE_C1_FIRST = $80;
def IECODE_C1_LAST = $9f;
def IECODE_LATIN1_FIRST = $a0;
def IECODE_LATIN1_LAST = $ff;

def IECODE_LBUTTON = $68;
def IECODE_RBUTTON = $69;
def IECODE_MBUTTON = $6a;
def IECODE_NOBUTTON = $ff;

def IECODE_NEWACTIVE = $01;
def IECODE_NEWSIZE = $02;
def IECODE_REFRESH = $03;

def IECODE_REQSET = $01;
def IECODE_REQCLEAR = $00;

def IEQUALIFIER_LSHIFT = $0001;
def IEQUALIFIER_RSHIFT = $0002;
def IEQUALIFIER_CAPSLOCK = $0004;
def IEQUALIFIER_CONTROL = $0008;
def IEQUALIFIER_LALT = $0010;
def IEQUALIFIER_RALT = $0020;
def IEQUALIFIER_LCOMMAND = $0040;
def IEQUALIFIER_RCOMMAND = $0080;
def IEQUALIFIER_NUMERICPAD = $0100;
def IEQUALIFIER_REPEAT = $0200;
def IEQUALIFIER_INTERRUPT = $0400;
def IEQUALIFIER_MULTIBROADCAST = $0800;
def IEQUALIFIER_MIDBUTTON = $1000;
def IEQUALIFIER_RBUTTON = $2000;
def IEQUALIFIER_LEFTBUTTON = $4000;
def IEQUALIFIER_RELATIVEMOUSE = $8000;

def IEQUALIFIERB_LSHIFT = 0;
def IEQUALIFIERB_RSHIFT = 1;
def IEQUALIFIERB_CAPSLOCK = 2;
def IEQUALIFIERB_CONTROL = 3;
def IEQUALIFIERB_LALT = 4;
def IEQUALIFIERB_RALT = 5;
def IEQUALIFIERB_LCOMMAND = 6;
def IEQUALIFIERB_RCOMMAND = 7;
def IEQUALIFIERB_NUMERICPAD = 8;
def IEQUALIFIERB_REPEAT = 9;
def IEQUALIFIERB_INTERRUPT = 10;
def IEQUALIFIERB_MULTIBROADCAST = 11;
def IEQUALIFIERB_MIDBUTTON = 12;
def IEQUALIFIERB_RBUTTON = 13;
def IEQUALIFIERB_LEFTBUTTON = 14;
def IEQUALIFIERB_RELATIVEMOUSE = 15;

struct InputEvent is
  ie_NextEvent:ulong;
  ie_Class:ubyte;
  ie_SubClass:ubyte;
  ie_Code:uword;
  ie_Qualifier:uword;
  ie_position:union is
    ie_xy:struct is
      ie_x:word;
      ie_y:word;
    ;
    ie_addr:ulong;
    ie_dead:struct is
      ie_prev1DownCode:ubyte;
      ie_prev1DownQual:ubyte;
      ie_prev2DownCode:ubyte;
      ie_prev2DownQual:ubyte;
    ;
  ;
  ie_TimeStamp:timeval;
;

def ie_X = ie_position.ie_xy.ie_x;
def ie_Y = ie_position.ie_xy.ie_y;
def ie_EventAddress = ie_position.ie_addr;
def ie_Prev1DownCode = ie_position.ie_dead.ie_prev1DownCode;
def ie_Prev1DownQual = ie_position.ie_dead.ie_prev1DownQual;
def ie_Prev2DownCode = ie_position.ie_dead.ie_prev2DownCode;
def ie_Prev2DownQual = ie_position.ie_dead.ie_prev2DownQual;

