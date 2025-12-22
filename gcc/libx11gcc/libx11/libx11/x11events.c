/* Copyright (c) 1996 by Terje Pedersen.  All Rights Reserved   */
/*                                                              */
/* By using this code you will agree to these terms:            */
/*                                                              */
/* 1. You may not use this code for profit in any way or form   */
/*    unless an agreement with the author has been reached.     */
/*                                                              */
/* 2. The author is not responsible for any damages caused by   */
/*    the use of this code.                                     */
/*                                                              */
/* 3. All modifications are to be released to the public.       */
/*                                                              */
/* Thats it! Have fun!                                          */
/* TP                                                           */
/*                                                              */

/***
   NAME
     events
   PURPOSE
     add eventhandling to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 23, 1994: Created.

3/3/97: Added XAutoRepeatOn/Off.
XGrabPointer/XUngrabPointer
 
17. Nov 96: A move of a window generated a configure event, probably only needed
            when resizing window.
16. Nov 96: root_x_return and root_y_return was relative to event window
            XCheckWindowEvent used events not belonging to window
7. Nov 96: Added comment headers to all functions and cleaned the code up
           somewhat. If you have the manual pages you may notice an eerie
	   similarity..
6. Nov 96: added values for xbutton.x_root and xbutton.y_root
***/

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <devices/timer.h>
#include <devices/keymap.h>
#include <devices/inputevent.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/layers.h>
#include <proto/keymap.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <ctype.h>

#include "libX11.h"

#if 0
#define DEBUGXEMUL_WARNING 1
#endif

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>
#define XK_MISCELLANY
#define XK_LATIN1
#include <X11/keysymdef.h>

#include "x11display.h"
#include "x11windows.h"
#include "x11events.h"
#include "debug.h"

/********************************************************************************/
/* external */
/********************************************************************************/

extern struct Library *KeymapBase;

/********************************************************************************/
/* internal */
/********************************************************************************/

int X11LastKeyEvent = -1;
int X11AutoRepeat = 1;
int X11LastKey = -1;

#ifdef DEBUGXEMUL_ENTRY
extern int bInformEvents; /* outputting information about events */
#endif

EventGlobals_s EG;

char X11CharBuffer[BUFFERLEN];

int X11ConfineMouse = 0;
Window X11ConfineWindow = 0;
int X11OwnEvents = 0;

KeySym_Map XKeys[]={
	  /* 0 */{ XK_quoteleft, XK_asciitilde,1, "quoteleft", "asciitilde"},
	  /* 1 */{ XK_1, XK_1,1, "1", ""},
	  /* 2 */{ XK_2, XK_2,1, "2", ""},
	  /* 3 */{ XK_3, XK_3,1, "3", ""},
	  /* 4 */{ XK_4, XK_4,1, "4", ""},
	  /* 5 */{ XK_5, XK_5,1, "5", ""},
	  /* 6 */{ XK_6, XK_6,1, "6", ""},
	  /* 7 */{ XK_7, XK_7,1, "7", ""},
	  /* 8 */{ XK_8, XK_8,1, "8", ""},
	  /* 9 */{ XK_9, XK_9,1, "9", ""},
	  /* 10 */{ XK_0, XK_0,1, "0", ""},
	  /* 11 */{ XK_minus, XK_underscore,1, "-", "_"},
	  /* 12 */{ XK_equal, XK_plus,1, "equal", "+"},
	  /* 13 */{ XK_backslash, XK_backslash,1, "\\", "\\"},
	  /* 14 */{ XK_Scroll_Lock, XK_Scroll_Lock,1, "Scroll_Lock", ""},
	  /* 15 */{ XK_KP_0, XK_KP_0,1, "KP_0", ""},
	  /* 16 */{ XK_q, XK_Q,1, "q", "Q"},
	  /* 17 */{ XK_w, XK_W,1, "w", "W"},
	  /* 18 */{ XK_e, XK_E,1, "e", "E"},
	  /* 19 */{ XK_r, XK_R,1, "r", "R"},
	  /* 20 */{ XK_t, XK_T,1, "t", "T"},
	  /* 21 */{ XK_y, XK_Y,1, "y", "Y"},
	  /* 22 */{ XK_u, XK_U,1, "u", "U"},
	  /* 23 */{ XK_i, XK_I,1, "i", "I"},
	  /* 24 */{ XK_o, XK_O,1, "o", "O"},
	  /* 25 */{ XK_p, XK_P,1, "p", "P"},
	  /* 26 */{ XK_bracketleft, XK_braceleft,1, "bracketleft", "{"},
	  /* 27 */{ XK_bracketright, XK_braceright,1, "bracketright", "}"},
	  /* 28 */{ 0, 0,1,"", ""},
	  /* 29 */{ XK_KP_1, XK_KP_1,1, "KP_1", ""},
	  /* 30 */{ XK_KP_2, XK_KP_2,1, "KP_2", ""},
	  /* 31 */{ XK_KP_3, XK_KP_3,1, "KP_3", ""},
	  /* 32 */{ XK_a, XK_A,1, "a", "A"},
	  /* 33 */{ XK_s, XK_S,1, "s", "S"},
	  /* 34 */{ XK_d, XK_D,1, "d", "D"},
	  /* 35 */{ XK_f, XK_F,1, "f", "F"},
	  /* 36 */{ XK_g, XK_G,1, "g", "G"},
	  /* 37 */{ XK_h, XK_H,1, "h", "H"},
	  /* 38 */{ XK_j, XK_J,1, "j", "J"},
	  /* 39 */{ XK_k, XK_K,1, "k", "K"},
	  /* 40 */{ XK_l, XK_L,1, "l", "L"},
	  /* 41 */{ XK_semicolon, XK_semicolon,1, ";", ""},
	  /* 42 */{ XK_quoteright, XK_quoteright,1,"quoteright", ""},
	  /* 43 */{ XK_apostrophe, XK_apostrophe,1, "apostrophe", ""},
	  /* 44 */{ 0, 0,1,"", ""},
	  /* 45 */{ XK_KP_4, XK_KP_4,1, "KP_4", ""},
	  /* 46 */{ XK_KP_5, XK_KP_5,1, "KP_5", ""},
	  /* 47 */{ XK_KP_6, XK_KP_6,1, "KP_6", ""},
	  /* 48 */{ XK_less, XK_less,1,"", ""},
	  /* 49 */{ XK_z, XK_Z,1, "z", "Z"},
	  /* 50 */{ XK_x, XK_X,1, "x", "X"},
	  /* 51 */{ XK_c, XK_C,1, "c", "C"},
	  /* 52 */{ XK_v, XK_V,1, "v", "V"},
	  /* 53 */{ XK_b, XK_B,1, "b", "B"},
	  /* 54 */{ XK_n, XK_N,1, "n", "N"},
	  /* 55 */{ XK_m, XK_M,1, "m", "M"},
	  /* 56 */{ XK_comma, XK_comma,1, "comma", ""},
	  /* 57 */{ XK_period, XK_period,1, "period", ""},
	  /* 58 */{ XK_slash, XK_slash,1, "slash", ""},
	  /* 59 */{ 0, 0,1,"", ""},
	  /* 60 */{ XK_KP_Decimal, XK_KP_Decimal,1,"KP_Decimal", ""},
	  /* 61 */{ XK_KP_7, XK_KP_7,1, "KP_7", ""},
	  /* 62 */{ XK_KP_8, XK_KP_8,1, "KP_8", ""},
	  /* 63 */{ XK_KP_9, XK_KP_9,1, "KP_9", ""},
	  /* 64 */{ XK_space, XK_space,1, "space", ""},
	  /* 65 */{ XK_BackSpace, XK_BackSpace,1, "BackSpace", ""},
	  /* 66 */{ XK_Tab, XK_Tab,1, "Tab", ""},
	  /* 67 */{ XK_KP_Enter, XK_KP_Enter,1,  "KP_Enter", ""},
	  /* 68 */{ XK_Return, XK_Return,1, "Return", ""},
	  /* 69 */{ XK_Escape, XK_Escape,1, "Escape", ""},
	  /* 70 */{ XK_Delete, XK_Delete,1, "Delete", ""},
	  /* 71 */{ 0, 0,1,"", ""},
	  /* 72 */{ 0, 0,1,"", ""},
	  /* 73 */{ 0, 0,1,"", ""},
	  /* 74 */{ XK_KP_Subtract, XK_KP_Subtract,1, "KP_Subtract", ""},
	  /* 75 */{ 0, 0,1,"", ""},
	  /* 76 */{ XK_Up, XK_Up,1, "Up", ""},
	  /* 77 */{ XK_Down, XK_Down,1, "Down", ""},
	  /* 78 */{ XK_Right, XK_Right,1, "Right", ""},
	  /* 79 */{ XK_Left, XK_Left,1, "Left", ""},
	  /* 80 */{ XK_F1, XK_F1,1,"F1", ""},
	  /* 81 */{ XK_F2, XK_F2,1,"F2", ""},
	  /* 82 */{ XK_F3, XK_F3,1,"F3", ""},
	  /* 83 */{ XK_F4, XK_F4,1,"F4", ""},
	  /* 84 */{ XK_F5, XK_F5,1,"F5", ""},
	  /* 85 */{ XK_F6, XK_F6,1,"F6", ""},
	  /* 86 */{ XK_F7, XK_F7,1,"F7", ""},
	  /* 87 */{ XK_F8, XK_F8,1,"F8", ""},
	  /* 88 */{ XK_F9, XK_F9,1,"F9", ""},
	  /* 89 */{ XK_F10, XK_F10,1,"F10", ""},
	  /* 90 */{ XK_KP_F1, XK_KP_F1,1,"KP_F1", ""},
	  /* 91 */{ XK_KP_F2, XK_KP_F2,1,"KP_F2", ""},
	  /* 92 */{ XK_KP_Divide, XK_KP_Divide,1, "KP_Divide", ""},
	  /* 93 */{ XK_KP_Multiply, XK_KP_Multiply,1, "KP_Multiply", ""},
	  /* 94 */{ XK_KP_Add, XK_KP_Add,1, "KP_Add", ""},
	  /* 95 */{ XK_Help, XK_Help,1, "Help", ""},
	  /* 96 */{ XK_Shift_L, XK_Shift_L,0, "Shift_L", ""},
	  /* 97 */{ XK_Shift_R, XK_Shift_R,0, "Shift_R", ""},
	  /* 98 */{ XK_Caps_Lock, XK_Caps_Lock,0,"Caps_Lock", ""},
	  /* 99 */{ XK_Control_L, XK_Control_L,0, "Control_L", ""},
	  /* 100 */{ XK_Alt_L, XK_Alt_L,0, "Alt_L", ""},
	  /* 101 */{ XK_Alt_R, XK_Alt_R,0, "Alt_R", ""},
	  /* 102 */{ XK_Meta_L, XK_Meta_L,0, "Meta_L", ""},
	  /* 103 */{ XK_Meta_R, XK_Meta_R,0, "Meta_R", ""},
	  /* 104 */{ 0, 0,1,"", ""},
	  /* 105 */{ 0, 0,1,"", ""},
	  /* 106 */{ 0, 0,1,"", ""},
	  /* 107 */{ 0, 0,1,"", ""},
	  /* 108 */{ 0, 0,1,"", ""},
	  /* 109 */{ 0, 0,1,"", ""},
	  /* 110 */{ 0, 0,1,"", ""},
	  /* 111 */{ 0, 0,1,"", ""},
	  /* 112 */{ 0, 0,1,"", ""},
	  /* 113 */{ 0, 0,1,"", ""},
	  /* 114 */{ 0, 0,1,"", ""},
	  /* 115 */{ 0, 0,1,"", ""},
	  /* 116 */{ 0, 0,1,"", ""},
	  /* 117 */{ 0, 0,1,"", ""},
	  /* 118 */{ 0, 0,1,"", ""},
	  /* 119 */{ 0, 0,1,"", ""},
	  /* 120 */{ 0, 0,1,"", ""},
	  /* 121 */{ 0, 0,1,"", ""},
	  /* 122 */{ 0, 0,1,"", ""},
	  /* 123 */{ 0, 0,1,"", ""},
	  /* 124 */{ 0, 0,1,"", ""},
	  /* 125 */{ 0, 0,1,"", ""},
	  /* 126 */{ 0, 0,1,"", ""},
	  /* 127 */{ XK_Delete, XK_Delete,1,"Delete", ""},
	  /* 128 */{ XK_quoteleft, XK_asciitilde,1, "quoteleft", "asciitilde"},
	  /* 129 */{ XK_1, XK_1,1, "1", ""},
	  /* 130 */{ XK_2, XK_2,1, "2", ""},
	  /* 131 */{ XK_3, XK_3,1, "3", ""},
	  /* 132 */{ XK_4, XK_4,1, "4", ""},
	  /* 133 */{ XK_5, XK_5,1, "5", ""},
	  /* 134 */{ XK_6, XK_6,1, "6", ""},
	  /* 135 */{ XK_7, XK_7,1, "7", ""},
	  /* 136 */{ XK_8, XK_8,1, "8", ""},
	  /* 137 */{ XK_9, XK_9,1, "9", ""},
	  /* 138 */{ XK_0, XK_0,1, "0", ""},
	  /* 139 */{ XK_minus, XK_underscore,1, "-", "_"},
	  /* 140 */{ XK_equal, XK_plus,1, "equal", "+"},
	  /* 141 */{ XK_backslash, XK_backslash,1, "backslash", ""},
	  /* 142 */{ 0, 0,1,"", ""},
	  /* 143 */{ XK_KP_0, XK_KP_0,1, "KP_0", ""},
	  /* 144 */{ XK_q, XK_Q,1, "q", "Q"},
	  /* 145 */{ XK_w, XK_W,1, "w", "W"},
	  /* 146 */{ XK_e, XK_E,1, "e", "E"},
	  /* 147 */{ XK_r, XK_R,1, "r", "R"},
	  /* 148 */{ XK_t, XK_T,1, "t", "T"},
	  /* 149 */{ XK_y, XK_Y,1, "y", "Y"},
	  /* 150 */{ XK_u, XK_U,1, "u", "U"},
	  /* 151 */{ XK_i, XK_I,1, "i", "I"},
	  /* 152 */{ XK_o, XK_O,1, "o", "O"},
	  /* 153 */{ XK_p, XK_P,1, "p", "P"},
	  /* 154 */{ XK_bracketleft, XK_braceleft,1, "bracketleft", "{"},
	  /* 155 */{ XK_bracketright, XK_braceright,1, "bracketright", "}"},
	  /* 156 */{ 0, 0,1,"", ""},
	  /* 157 */{ XK_End, XK_End,1, "End", ""},
	  /* 158 */{ XK_KP_2, XK_KP_2,1, "KP_2", ""},
	  /* 159 */{ XK_KP_3, XK_KP_3,1, "KP_3", ""},
	  /* 160 */{ XK_a, XK_A,1, "a", "A"},
	  /* 161 */{ XK_s, XK_S,1, "s", "S"},
	  /* 162 */{ XK_d, XK_D,1, "d", "D"},
	  /* 163 */{ XK_f, XK_F,1, "f", "F"},
	  /* 164 */{ XK_g, XK_G,1, "g", "G"},
	  /* 165 */{ XK_h, XK_H,1, "h", "H"},
	  /* 166 */{ XK_j, XK_J,1, "j", "J"},
	  /* 167 */{ XK_k, XK_K,1, "k", "K"},
	  /* 168 */{ XK_l, XK_L,1, "l", "L"},
	  /* 169 */{ XK_semicolon, XK_semicolon,1, "semicolon", ""},
	  /* 170 */{ XK_apostrophe, XK_apostrophe,1, "apostrophe", ""},
	  /* 171 */{ XK_apostrophe, XK_apostrophe,1, "apostrophe", ""},
	  /* 172 */{ 0, 0,1,"", ""},
	  /* 173 */{ XK_KP_1, XK_KP_1,1, "KP_1", ""},
	  /* 174 */{ XK_KP_2, XK_KP_2,1, "KP_2", ""},
	  /* 175 */{ XK_KP_3, XK_KP_3,1, "KP_3", ""},
	  /* 176 */{ XK_less, XK_less,1, "KP_less", ""},
	  /* 177 */{ XK_z, XK_Z,1, "z", "Z"},
	  /* 178 */{ XK_x, XK_X,1, "x", "X"},
	  /* 179 */{ XK_c, XK_C,1, "c", "C"},
	  /* 180 */{ XK_v, XK_V,1, "v", "V"},
	  /* 181 */{ XK_b, XK_B,1, "b", "B"},
	  /* 182 */{ XK_n, XK_N,1, "n", "N"},
	  /* 183 */{ XK_m, XK_M,1, "m", "M"},
	  /* 184 */{ XK_comma, XK_comma,1, "comma", ","},
	  /* 185 */{ XK_period, XK_period,1, "period", "."},
	  /* 186 */{ XK_slash, XK_slash,1, "slash", "/"},
	  /* 187 */{ XK_comma, XK_comma,1, "comma", ","},
	  /* 188 */{ XK_KP_Decimal, XK_KP_Decimal,1,"KP_Decimal", ""},
	  /* 189 */{ XK_Home, XK_Home,1, "Home", ""},
	  /* 190 */{ XK_KP_8, XK_KP_8,1, "KP_8", ""},
	  /* 191 */{ XK_KP_9, XK_KP_9,1, "KP_9", ""},
	  /* 192 */{ XK_space, XK_space,1, "space", " "},
	  /* 193 */{ XK_BackSpace, XK_BackSpace,1, "BackSpace", ""},
	  /* 194 */{ XK_Tab, XK_Tab,1, "Tab", ""},
	  /* 195 */{ XK_KP_Equal, XK_KP_Equal,1, "KP_Equal", ""},
	  /* 196 */{ XK_Return, XK_Return,1, "Return", ""},
	  /* 197 */{ XK_Escape, XK_Escape,1, "Escape", ""},
	  /* 198 */{ XK_Delete, XK_Delete,1, "Delete", ""},
	  /* 199 */{ 0, 0,1,"", ""},
	  /* 200 */{ 0, 0,1,"", ""},
	  /* 201 */{ 0, 0,1,"", ""},
	  /* 202 */{ XK_KP_Subtract, XK_KP_Subtract,1, "KP_Subtract", ""},
	  /* 203 */{ 0, 0,1,"", ""},
	  /* 204 */{ XK_Up, XK_Up,1, "Up", ""},
	  /* 205 */{ XK_Down, XK_Down,1, "Down", ""},
	  /* 206 */{ XK_Right, XK_Right,1, "Right", ""},
	  /* 207 */{ XK_Left, XK_Left,1, "Left", ""},
	  /* 208 */{ XK_F1, XK_F1,1,"F1", ""},
	  /* 209 */{ XK_F2, XK_F2,1,"F2", ""},
	  /* 210 */{ XK_F3, XK_F3,1,"F3", ""},
	  /* 211 */{ XK_F4, XK_F4,1,"F4", ""},
	  /* 212 */{ XK_F5, XK_F5,1,"F5", ""},
	  /* 213 */{ XK_F6, XK_F6,1,"F6", ""},
	  /* 214 */{ XK_F7, XK_F7,1,"F7", ""},
	  /* 215 */{ XK_F8, XK_F8,1,"F8", ""},
	  /* 216 */{ XK_F9, XK_F9,1,"F9", ""},
	  /* 217 */{ XK_F10, XK_F10,1,"F10", ""},
	  /* 218 */{ XK_KP_F1, XK_KP_F1,1,"KP_F1", ""},
	  /* 219 */{ XK_KP_F2, XK_KP_F2,1,"KP_F1", ""},
	  /* 220 */{ XK_KP_Divide, XK_KP_Divide,1, "KP_Divide", ""},
	  /* 221 */{ XK_KP_Multiply, XK_KP_Multiply,1, "KP_Multiply", ""},
	  /* 222 */{ XK_KP_Add, XK_KP_Add,1, "KP_Add", ""},
	  /* 223 */{ XK_Help, XK_Help,1, "Help", ""},
	  /* 224 */{ XK_Shift_L, XK_Shift_L,0, "Shift_L", ""},
	  /* 225 */{ XK_Shift_R, XK_Shift_R,0, "Shift_R", ""},
	  /* 226 */{ XK_Caps_Lock, XK_Caps_Lock,0, "Caps_Lock", ""},
	  /* 227 */{ XK_Control_L, XK_Control_L,0, "Control_L", ""},
	  /* 228 */{ XK_Alt_L, XK_Alt_L,0, "Alt_L", ""},
	  /* 229 */{ XK_Alt_R, XK_Alt_R,0, "Alt_R", ""},
	  /* 230 */{ XK_Meta_L, XK_Meta_L,0, "Meta_L", ""},
	  /* 231 */{ XK_Meta_R, XK_Meta_R,0, "Meta_R", ""},
	  /* 232 */{ 0, 0,1,"", ""},
	  /* 233 */{ 0, 0,1,"", ""},
	  /* 234 */{ 0, 0,1,"", ""},
	  /* 235 */{ 0, 0,1,"", ""},
	  /* 236 */{ 0, 0,1,"", ""},
	  /* 237 */{ 0, 0,1,"", ""},
	  /* 238 */{ 0, 0,1,"", ""},
	  /* 239 */{ 0, 0,1,"", ""},
	  /* 240 */{ 0, 0,1,"", ""},
	  /* 241 */{ 0, 0,1,"", ""},
	  /* 242 */{ 0, 0,1,"", ""},
	  /* 243 */{ 0, 0,1,"", ""},
	  /* 244 */{ 0, 0,1,"", ""},
	  /* 245 */{ 0, 0,1,"", ""},
	  /* 246 */{ 0, 0,1,"", ""},
	  /* 247 */{ 0, 0,1,"", ""},
	  /* 248 */{ 0, 0,1,"", ""},
	  /* 249 */{ 0, 0,1,"", ""},
	  /* 250 */{ 0, 0,1,"", ""},
	  /* 251 */{ 0, 0,1,"", ""},
	  /* 252 */{ 0, 0,1,"", ""},
	  /* 253 */{ 0, 0,1,"", ""},
	  /* 254 */{ 0, 0,1,"", ""},
	  /* 255 */{ XK_Delete, XK_Delete,1,"Delete", ""},
};

long Xevent_to_mask[LASTEvent] = {
	0,						/* no event 0 */
	0,						/* no event 1 */
	KeyPressMask,					/* KeyPress */
	KeyReleaseMask,					/* KeyRelease */
	ButtonPressMask,				/* ButtonPress */
	ButtonReleaseMask,				/* ButtonRelease */
	PointerMotionMask|PointerMotionHintMask|Button1MotionMask|
		Button2MotionMask|Button3MotionMask|Button4MotionMask|
		Button5MotionMask|ButtonMotionMask,	/* MotionNotify */
	EnterWindowMask,				/* EnterNotify */
	LeaveWindowMask,				/* LeaveNotify */
	FocusChangeMask,				/* FocusIn */
	FocusChangeMask,				/* FocusOut */
	KeymapStateMask,				/* KeymapNotify */
	ExposureMask,					/* Expose */
	ExposureMask,					/* GraphicsExpose */
	ExposureMask,					/* NoExpose */
	VisibilityChangeMask,				/* VisibilityNotify */
	SubstructureNotifyMask,				/* CreateNotify */
	StructureNotifyMask|SubstructureNotifyMask,	/* DestroyNotify */
	StructureNotifyMask|SubstructureNotifyMask,	/* UnmapNotify */
	StructureNotifyMask /*|SubstructureNotifyMask*/,	/* MapNotify */
	SubstructureRedirectMask,			/* MapRequest */
	SubstructureNotifyMask|StructureNotifyMask,	/* ReparentNotify */
	StructureNotifyMask /*|SubstructureNotifyMask*/,	/* ConfigureNotify */
	SubstructureRedirectMask,			/* ConfigureRequest */
	SubstructureNotifyMask|StructureNotifyMask,	/* GravityNotify */
	ResizeRedirectMask,				/* ResizeRequest */
	SubstructureNotifyMask|StructureNotifyMask,	/* CirculateNotify */
	SubstructureRedirectMask,			/* CirculateRequest */
	PropertyChangeMask,				/* PropertyNotify */
	0,						/* SelectionClear */
	0,						/* SelectionRequest */
	0,						/* SelectionNotify */
	ColormapChangeMask,				/* ColormapNotify */
	0,						/* ClientMessage */
	0,						/* MappingNotify */
};

/********************************************************************************/
/* functions */
/********************************************************************************/

/********************************************************************************
Name     : Events_LookupKey()
Author   : Terje Pedersen
Input    : key - The key name to map
Output   : 
Function : Map key strings to actual characters.
********************************************************************************/

typedef struct {
  char *zName;
  char vVal;
} X_Keys;

X_Keys X_NameKeyMapping[]={
  {"space", ' '},
  {"comma", ','},
  {"greater", '>'},
  {"less", '<'},
  {NULL,0},
};

char
Events_LookupKey( char *key )
{
  int i = 0;

  while( X_NameKeyMapping[i].vVal ){
    if( !strcmp(X_NameKeyMapping[i].zName,key) )
      return X_NameKeyMapping[i].vVal;
    i++;
  }
  return(0);
}

/********************************************************************************
Name     : Events_GetIntui()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Get an intuition event from one of the active windows.
********************************************************************************/

void
Events_GetIntui(void)
{
  struct IntuiMessage *winmsg = NULL;
  int i;
  IMap_p pMapped;
  int inside;
  static int olded = -1;

  EG.nPeeked = 0;
  pMapped = X11Windows[ROOTID].mMappedChildren;
  
  for( i=0; i<pMapped->nTopEntry; i++ ){
    inside = pMapped->pData[i];
    EG.X11eventwin = X11DrawablesWindows[X11DrawablesMap[inside]];
    if( EG.X11eventwin ){
      EG.nEventDrawable = inside;
      winmsg = (struct IntuiMessage *)GetMsg(EG.X11eventwin->UserPort);
      if( winmsg ){
	if( EG.nEventDrawable != olded ){
#if 0
	  printf("Eventroot now %d\n",EG.nEventDrawable );
#endif
	  olded = EG.nEventDrawable;
	}
	break;
      }
    }
  }

  if( winmsg ){
    EG.nMouseX = winmsg->MouseX;
    EG.nBorderX = EG.X11eventwin->BorderLeft;
    EG.nMouseY = winmsg->MouseY;
    EG.nBorderY = EG.X11eventwin->BorderTop;
    EG.nClass = winmsg->Class;
    EG.nCode = winmsg->Code;
    EG.nQual = winmsg->Qualifier&255;
    EG.nButtonMask = (EG.nButtonMask&(0xff00))|EG.nQual;
    EG.nTime = (unsigned long)(winmsg->Seconds*1000+winmsg->Micros/1000);
    Events_MapRawKey(winmsg);
    ReplyMsg((struct Message *)winmsg);
    EG.bHaveWinMsg = 1;
  } else {
    /*EG.nClass=EG.nCode=EG.nQual=0;*/
    EG.bHaveWinMsg = 0;
  }
}

/********************************************************************************
Name     : Events_NewInternalXEvent()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Add an internal event.
********************************************************************************/

void
Events_NewInternalXEvent( XEvent *event, int size )
{
  InternalXEvent *new = (InternalXEvent *)malloc(sizeof(InternalXEvent));

  if( !new )
    X11resource_exit(EVENTS1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)new);
#endif /* MEMORYTRACKING */
  new->xev = malloc(size);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)new->xev);
#endif /* MEMORYTRACKING */
  if( !new->xev )
    X11resource_exit(EVENTS2);
  memcpy(new->xev,event,size);
  new->next = NULL;
  new->size  = size;
  if( !EG.X11InternalEvents->next )
    EG.X11InternalEvents->next = new;
  else
    EG.X11InternalEventsLast->next = new;
  EG.X11InternalEventsLast = new;
}

/********************************************************************************
Name     : Events_Init()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Initialize the EG (Event Globals) event structure.
********************************************************************************/

void
Events_Init( void )
{
  EG.nButtonMask = 0;
  EG.nPrevInside = -1;
  EG.nPeeked = 0;
  EG.bDontWait = 0;
  EG.bButtonSwitch = 0;
  EG.bHaveWinMsg = 0;
  EG.X11eventwin = NULL;
  EG.fwindowsig = 0;
  EG.GrabWin = -1;

  EG.X11InternalEvents = (InternalXEvent*)calloc( sizeof(InternalXEvent),1 );
}

/********************************************************************************
Name     : Events_Exit()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Cleanup after event handling.
********************************************************************************/

void
Events_Exit( void )
{
  XEvent event;

  EG.bX11ReleaseAll = 1;
  while( Events_NextInternalXEvent(&event) );
  free( EG.X11InternalEvents );
}

/********************************************************************************
Name     : Events_NextInternalXEvent()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Return the next internal event
********************************************************************************/

int
Events_NextInternalXEvent( XEvent *event )
{
  if( EG.X11InternalEvents->next ){
    InternalXEvent *old = EG.X11InternalEvents->next;

    EG.X11InternalEvents->next = EG.X11InternalEvents->next->next;
    memcpy( event, old->xev, old->size );
#if (MEMORYTRACKING!=0)
    List_RemoveEntry(pMemoryList,(void*)old->xev);
    List_RemoveEntry(pMemoryList,(void*)old);
#else
    free(old->xev);
    free(old);
#endif /* MEMORYTRACKING */

    if( event->type == Expose ){
      /* if( X11Drawables[event->xany.window]==X11WINDOW ) */
      ClearWinFlag(event->xany.window,WIN_EXPOSED);
#ifdef OPTDBG
      printf("Event exposing %d\n",event->xany.window);
#endif

#ifdef OPTDBG
      printf("expose %d (parent %d) x %d y %d w %d h %d\n",
	     event->xany.window,
	     X11Windows[X11DrawablesMap[event->xany.window]].parent,
	     event->xexpose.x,
	     event->xexpose.y,
	     event->xexpose.width,
	     event->xexpose.height);

#endif
    }
    if( event->type == ConfigureNotify ){
      ClearWinFlag(event->xany.window,WIN_CONFIGURED);
#ifdef OPTDBG
      printf("Event configuring %d\n",event->xany.window);
#endif
#if 0 /*(DEBUG!=0)*/
      printf("configure %d (parent %d) x %d y %d w %d h %d\n",
	     event->xany.window,
	     X11Windows[X11DrawablesMap[event->xany.window]],
	     event->xconfigure.x,
	     event->xconfigure.y,
	     event->xconfigure.width,
	     event->xconfigure.height);

#endif
    }
    if( event->type == MapNotify ){
#ifdef OPTDBG
      printf("Event mapping %d\n",event->xany.window);
#endif
    }


    return(1);
  }

  return 0;
}

int
Events_NextInternalWindowXEvent( XEvent *event, Window win )
{
  if( EG.X11InternalEvents->next ){
    InternalXEvent *pThis = EG.X11InternalEvents->next,*pPrev = EG.X11InternalEvents,*old = NULL;

    while( pThis!=NULL && pThis->xev->xany.window!=win ){
      pPrev = pThis;
      pThis = pThis->next;
    }    
    if( pThis && pThis->xev->xany.window==win ){
      old = pThis;
      if( pPrev ){
	pPrev->next = pThis->next;
      }
      if( old->next==NULL ){
	EG.X11InternalEventsLast = pPrev;
      }
    }
    if( old ){
      memcpy(event,old->xev,old->size);
#if (MEMORYTRACKING!=0)
      List_RemoveEntry(pMemoryList,(void*)old->xev);
      List_RemoveEntry(pMemoryList,(void*)old);
#else
      free(old->xev);
      free(old);
#endif /* MEMORYTRACKING */
    } else {
      return 0;
    }
#if 0
    if( event->type==Expose ){
      if( X11Drawables[win]==X11WINDOW )
	ClearWinFlag(win,WIN_EXPOSED);
    }
#endif
    return(1);
  }

  return 0;
}

void
Events_FreeInternalWindowXEvents( Window win )
{
  if( !win )
    return;

  if( EG.X11InternalEvents->next ){
    InternalXEvent *pThis = EG.X11InternalEvents->next,*pPrev = EG.X11InternalEvents,*old = NULL;

    while( pThis!=NULL ){
      if( pThis->xev->xany.window==win ){
	pPrev->next = pThis->next;
	old = pThis;
	pThis = pThis->next;
#if (MEMORYTRACKING!=0)
xxx
	List_RemoveEntry(pMemoryList,(void*)old->xev);
	List_RemoveEntry(pMemoryList,(void*)old);
#else
	free(old->xev);
	free(old);
#endif /* MEMORYTRACKING */
      } else {
	pPrev = pThis;
	pThis = pThis->next;
      }
    }    
  }
}


/********************************************************************************
Name     : Events_AddExpose()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Add an expose event to the internal event queue.
********************************************************************************/

void
Events_AddExpose( Window win ){
  XEvent ievent;
  
  if( GetWinFlag(win,WIN_EXPOSED) )
    return;

  SetWinFlag(win,WIN_EXPOSED);

  ievent.type = Expose;
  ievent.xexpose.count = 0;
  ievent.xexpose.window = ievent.xany.window = win;
  ievent.xexpose.width = X11Windows[X11DrawablesMap[win]].rwidth;
  ievent.xexpose.height = X11Windows[X11DrawablesMap[win]].rheight;
  ievent.xexpose.x = X11Windows[X11DrawablesMap[win]].rx+X11Windows[X11DrawablesMap[win]].RelX;
  ievent.xexpose.y = X11Windows[X11DrawablesMap[win]].ry+X11Windows[X11DrawablesMap[win]].RelY;

  Events_NewInternalXEvent(&ievent,sizeof(XExposeEvent));
}

void
Events_ExposeChildren( Drawable win )
{
  XEvent ievent;
  int i;
  int child;
  IMap_p pChildren;

  pChildren = X11Windows[X11DrawablesMap[win]].mMappedChildren;

  for( i=0; i<pChildren->nTopEntry; i++ ){
    int parentx = 0, parenty = 0, parentw = DG.nDisplayWidth, parenth = DG.nDisplayHeight;
    int parent;
    child = X11DrawablesMap[pChildren->pData[i]];

    if( GetWinFlagD(child,WIN_EXPOSED) )
      continue;

    parent = X11Windows[child].parent;

    ievent.type = Expose;
    ievent.xexpose.count = 0;
    ievent.xexpose.window = ievent.xany.window = child;

    if( parent != ROOTID ){
      parentx = X11Windows[X11DrawablesMap[parent]].rx;
      parenty = X11Windows[X11DrawablesMap[parent]].ry;
      parentw = X11Windows[X11DrawablesMap[parent]].rwidth;
      parenth = X11Windows[X11DrawablesMap[parent]].rheight;
    }
#ifdef OPTDBG
    printf("parent win (%d) x %d y %d w %d h %d\n",parent,parentx,parenty,parentw,parenth);
#endif

    ievent.xexpose.width = X11Windows[child].rwidth;
    ievent.xexpose.height = X11Windows[child].rheight;
    ievent.xexpose.x = X11Windows[child].rx+X11Windows[child].RelX;
    ievent.xexpose.y = X11Windows[child].ry+X11Windows[child].RelY;

#ifdef OPTDBG
      printf("expose %d (parent %d) x %d y %d w %d h %d\n",i,parent,ievent.xexpose.x,ievent.xexpose.y,ievent.xexpose.width,ievent.xexpose.height);
#endif
      if( ievent.xexpose.x+ievent.xexpose.width>=parentx
	 && ievent.xexpose.x<parentx+parentw
	 && ievent.xexpose.y+ievent.xexpose.height>=parenty
	 && ievent.xexpose.y<parenty+parenth ){
	SetWinFlagD(child,WIN_EXPOSED);
	Events_NewInternalXEvent(&ievent,sizeof(XExposeEvent));
	Events_ExposeChildren( pChildren->pData[i] );
      } else {
#if (DEBUG!=0)
	printf("Ha! outside!\n");
#endif
      }
  }
}

/********************************************************************************
Name     : Events_AddConfigure()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Add a configure event to the internal event queue.
********************************************************************************/

void
Events_ConfigureChildren( Drawable win )
{
  XEvent ievent;
  int i;
  int child;
  IMap_p pChildren;

  pChildren = X11Windows[X11DrawablesMap[win]].mMappedChildren;

  for( i=0; i<pChildren->nTopEntry; i++ ){
    child = X11DrawablesMap[pChildren->pData[i]];

    if( GetWinFlagD(child,WIN_CONFIGURED) )
      continue;

    SetWinFlagD(child,WIN_CONFIGURED);
    
    ievent.type = ConfigureNotify;
    ievent.xconfigure.window = ievent.xany.window = X11Windows[child].win;
    ievent.xconfigure.width = X11Windows[child].rwidth;
    ievent.xconfigure.height = X11Windows[child].rheight;
    ievent.xconfigure.x = X11Windows[child].rx;
    ievent.xconfigure.y = X11Windows[child].ry;

    Events_NewInternalXEvent(&ievent,sizeof(XConfigureEvent));
    Events_ConfigureChildren( pChildren->pData[i] );
  }
}

void
Events_AddConfigure( Drawable win )
{
  XEvent ievent;

  if( GetWinFlag(win,WIN_CONFIGURED) )
    return;

#ifdef OPTDBG
  printf("Add configure %d\n",win);
#endif
  SetWinFlag(win,WIN_CONFIGURED);

  ievent.type = ConfigureNotify;
  ievent.xconfigure.window = ievent.xany.window = win;
  ievent.xconfigure.width = X11Windows[X11DrawablesMap[win]].rwidth;
  ievent.xconfigure.height = X11Windows[X11DrawablesMap[win]].rheight;
  ievent.xconfigure.x = X11Windows[X11DrawablesMap[win]].rx;
  ievent.xconfigure.y = X11Windows[X11DrawablesMap[win]].ry;

  Events_NewInternalXEvent(&ievent,sizeof(XConfigureEvent));
}

/********************************************************************************
Name     : Events_AddEvent()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
Events_AddEvent( Window win, int type, int size )
{
  XEvent ievent;

  ievent.type = type;
  ievent.xany.window = win;
  Events_NewInternalXEvent( &ievent, size );
}

/********************************************************************************
Name     : Events_AddChildEvent()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
Events_AddChildEvent( Window win,
		      int type,
		      int size )
{
  XEvent ievent;
  int i;
  int child;
  IMap_p pChildren;

  pChildren = X11Windows[X11DrawablesMap[win]].mMappedChildren;

  for( i=0; i<pChildren->nTopEntry; i++ ){
    child = pChildren->pData[i];
    ievent.type = type;
    ievent.xany.window = child;
    switch( type ){
    case UnmapNotify:
      ievent.xunmap.window = child;
      break;
    case MapNotify:
      ievent.xmap.window = child;
      break;
    }
    Events_NewInternalXEvent(&ievent,size);
  }
}

/********************************************************************************
Name     : XNextEvent()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     event_return
               Returns the event removed from the event queue.

Output   : 
Function : get the next event of any type or window.
********************************************************************************/

XNextEvent( Display * display,
	    XEvent *event_return )
{
/*  int gotone=EG.bHaveWinMsg;*/

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XNEXTEVENT, bInformEvents );
#endif 

  if( !EG.bSkipInternal && Events_NextInternalXEvent(event_return) ){
    EG.bX11SkippedClient = 0;

#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XNEXTEVENT, bInformEvents );
#endif 

    return;
  }

  if( !EG.nPeeked )
    XPending(display);

#if (DEBUG!=0)
  if( !EG.fwindowsig ){
    printf("Hey! No window and still expecting events..\n");
  }
#endif

  event_return->type = 0;
  event_return->xany.window = 0;
  
  if( !EG.bDontWait ){
    if( !EG.bHaveWinMsg )
      while( !XPending(display) ){
	Wait(EG.fwindowsig);
      }
  }
  if( !EG.nPeeked )
    XPeekEvent(display,event_return);
  EG.nPeeked = 0;
  EG.bDontWait = 0;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XNEXTEVENT, bInformEvents );
#endif 

  return(0);
}

/********************************************************************************
Name     : XPending()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

Output   : 
Function : return the number of pending events.
Notes    : It doesn't.., it just returns 1 if an event is pending 0 otherwise.
********************************************************************************/

int
XPending( Display *display )
{
  int vRet = 1;
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XPENDING, bInformEvents );
#endif
  if( EG.X11InternalEvents->next && !EG.bX11SkippedClient ){
    return(1);
  }
#if (DEBUG!=0)
  if( !DG.X11NumDrawablesWindows ){
    printf("Hey! No drawables and still expecting events!\n");
  }
#endif
  if( !EG.bHaveWinMsg )
    Events_GetIntui();
  if( !EG.bHaveWinMsg )
    vRet = 0;

#ifdef DEBUGXEMUL_EXIT
  FunCount_Leave( XPENDING , bInformEvents );
#endif
  return ( vRet );
}

/********************************************************************************
Name     : XPeekEvent()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     report_return
               Returns the event peeked from the input queue.

Output   : 
Function : get an event without removing it from the queue.
********************************************************************************/

XPeekEvent( Display *display, XEvent *event )
{
  int vRet;
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XPEEKEVENT, bInformEvents );
#endif

  EG.nPeeked = 1;
  event->type = 0;
  if( !EG.fwindowsig )
    vRet = 0;
  else
    vRet = Events_Get(event);

#ifdef DEBUGXEMUL_EXIT
  FunCount_Leave( XPEEKEVENT , bInformEvents );
#endif

  return( vRet );
}

/********************************************************************************
Name     : XSelectInput()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XSelectInput( Display* display,
	      Window win,
	      long event_mask )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSELECTINPUT  , bInformEvents );
#endif

  assert( win>=0 && win<DG.X11AvailDrawables );

#if 0
  printf("Mask for win %d = %x\n", win, event_mask);
#endif
  X11DrawablesMask[win] = event_mask;
/*  EG.nEventDrawable=win;*/

  return(0);
}

/********************************************************************************
Name     : Events_HandleButtons()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Map a intui button value to X button mask and value.
********************************************************************************/

int
Events_HandleButtons( XEvent *event, int code )
{
  switch( code ){
  case SELECTDOWN:
    event->xbutton.button = Button1;
    EG.nButtonMask |= Button1Mask;
    break;
  case SELECTUP:
    event->xbutton.button = Button1;
    EG.nButtonMask &= (0xFFFF-Button1Mask);
    break;
  case MENUDOWN:
    event->xbutton.button = Button3;
    EG.nButtonMask |= Button3Mask;
    break;
  case MENUUP:
    event->xbutton.button = Button3;
    EG.nButtonMask &= (0xFFFF-Button3Mask);
    break;
  case MIDDLEDOWN:
    event->xbutton.button = Button2;
    EG.nButtonMask |= Button2Mask;
    break;
  case MIDDLEUP:
    event->xbutton.button = Button2;
    EG.nButtonMask &= (0xFFFF-Button2Mask); 
    break;
  default:
    break;
  }
}

/* PTINRECT returns '1' if x,y is in rect (inclusive) */
#define PTINRECT(x,y,rx,ry,rw,rh) \
           ((x)>=(rx) && (y)>=(ry) && (x)<=(rx)+(rw) && (y)<=(ry)+(rh))

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
check_inside( XEvent *event )
{
  int i;
  int inside;
  int x = EG.nMouseX-EG.nBorderX;
  int y = EG.nMouseY-EG.nBorderY;
  IMap_p pMapped;
  int bFound;

  inside  = EG.nEventDrawable;
  EG.bHaveWinMsg = 0;
  pMapped = X11Windows[X11DrawablesMap[EG.nEventDrawable]].mMappedChildren;

  do {
    bFound = FALSE;
    for( i=0; i<pMapped->nTopEntry; i++ ){
      inside = pMapped->pData[i];
      if( PTINRECT(x,y,
		   X11Windows[X11DrawablesMap[inside]].rx,
		   X11Windows[X11DrawablesMap[inside]].ry,
		   X11Windows[X11DrawablesMap[inside]].rwidth,
		   X11Windows[X11DrawablesMap[inside]].rheight) ){
	bFound = TRUE;
#if 0
	printf("Inside %d\n",inside);
#endif
	pMapped = X11Windows[X11DrawablesMap[inside]].mMappedChildren;
	break;
      }
    }
  } while( bFound );

  /*
    DG.vWinX = EG.X11eventwin->BorderLeft+X11Windows[i].rx;
    DG.vWinY = EG.X11eventwin->BorderTop+X11Windows[i].ry;
    DG.vPrevWindow = (Window)-1;
    */

  event->xany.window = inside;

  return inside;
}

/********************************************************************************
Name     : Events_Get()
Author   : Terje Pedersen
Input    : event - pointer to the event to return
Output   : 
Function : The core of the event handling: Get an intuition event and map it to
           an XEvent.
********************************************************************************/

int
Events_Get( XEvent *event )
{
  int buttoncode;
  int inside = 0;
  int parent;
  int vEventMask = 0;

  if( !event )
    return(0);
  if( EG.X11InternalEvents->next )
    if( Events_NextInternalXEvent(event) )
      return;

  if( !EG.bHaveWinMsg )
    Events_GetIntui();

  event->type = 0;
  event->xbutton.button = 0;
  event->xkey.keycode = 0;
  event->xkey.state = EG.nQual;

  if( EG.bHaveWinMsg ){
    switch( EG.nClass ){
    case IDCMP_CLOSEWINDOW:
      force_exit(0);
      break;
    case IDCMP_RAWKEY:
      event->xkey.state = EG.nQual;
      event->xkey.time = EG.nTime;
      event->xkey.keycode = 0;
      if( EG.nCode==98 || EG.nCode==100 || EG.nCode==101 ){
	EG.bButtonSwitch=1;
      } else if( EG.nCode==226 || EG.nCode==228 || EG.nCode==229 ){
	EG.bButtonSwitch = 0;
      }
      if( EG.nCode<128 ){
	if( !X11AutoRepeat && X11LastKeyEvent == KeyPress
	    && X11LastKey == EG.nCode  ){
	  EG.bHaveWinMsg = 0;
	  EG.nCode = 0;

	  return 0;
	}
	event->type = KeyPress;
	vEventMask = KeyPressMask;
      } else {
	event->type = KeyRelease;
	vEventMask = KeyReleaseMask;
      }
      X11LastKey = EG.nCode;
      X11LastKeyEvent = event->type;
      inside = check_inside( event );

      /* printf("Rawkey %d\n",X11LastKey); */

      if( inside>0 ){
	event->xkey.subwindow = X11Windows[X11DrawablesMap[inside]].win;
	event->xbutton.x -= X11Windows[X11DrawablesMap[inside]].rx;
	event->xbutton.y -= X11Windows[X11DrawablesMap[inside]].ry;
      }
      event->xkey.type = event->type;

#if 0
      event->xkey.keycode = EG.X11Abuffer[0];
#else
      event->xkey.keycode = EG.nCode;
#endif

      if( EG.nCode==97 || EG.nCode==225 || EG.nCode==96 || EG.nCode==224 ){
	break; /*shift*/
      }
      if( EG.nCode==101 || EG.nCode==229 || EG.nCode==100 || EG.nCode==228 ){
	break; /* alt */
      }
      if( EG.nCode==99 || EG.nCode==227 ){
	break; /*ctrl */
      }
      if( EG.nCode==103 || EG.nCode==230 || EG.nCode==102 || EG.nCode==231 ){
	break; /* amiga */
      }
      if( EG.nCode==98 || EG.nCode==226 ){
	break; /* caps */
      }

      break;
/*    case IDCMP_REFRESHWINDOW:*/
    case IDCMP_CHANGEWINDOW:{
      int vOldW,vOldH;
      int vNewW,vNewH;

      event->type = ConfigureNotify;
      vEventMask = StructureNotifyMask;

      inside = check_inside( event );

      vOldW = X11Windows[X11DrawablesMap[EG.nEventDrawable]].width;
      vOldH = X11Windows[X11DrawablesMap[EG.nEventDrawable]].height;
      vNewW = EG.X11eventwin->Width-(EG.X11eventwin->BorderLeft+EG.X11eventwin->BorderRight);
      vNewH = EG.X11eventwin->Height-(EG.X11eventwin->BorderTop+EG.X11eventwin->BorderBottom);
      X11Windows[X11DrawablesMap[EG.nEventDrawable]].width = vNewW;
      X11Windows[X11DrawablesMap[EG.nEventDrawable]].height = vNewH;
      X11Windows[X11DrawablesMap[EG.nEventDrawable]].rwidth = vNewW;
      X11Windows[X11DrawablesMap[EG.nEventDrawable]].rheight = vNewH;

      X11Windows[X11DrawablesMap[EG.nEventDrawable]].x = EG.X11eventwin->LeftEdge;
      X11Windows[X11DrawablesMap[EG.nEventDrawable]].y = EG.X11eventwin->TopEdge;

      DG.vPrevWindow = -1;

#if 1
      event->xconfigure.window = EG.nEventDrawable;
      event->xconfigure.width = vNewW;
      event->xconfigure.height = vNewH;
      event->xconfigure.x = X11Windows[X11DrawablesMap[EG.nEventDrawable]].x;
      event->xconfigure.y = X11Windows[X11DrawablesMap[EG.nEventDrawable]].y;
      event->xconfigure.border_width = 0;
#endif
      XSetClipMask(&DG.X11Display,NULL,None);

      if( vOldW!=vNewW || vOldH!=vNewH ){

	XClearWindow( NULL, EG.nEventDrawable );
	adjustchildren( EG.nEventDrawable );
#if 1
	Events_AddConfigure( EG.nEventDrawable );
	Events_ConfigureChildren( EG.nEventDrawable );
	Events_MapMappedChildren( EG.nEventDrawable );
	Events_ExposeChildren( EG.nEventDrawable );
#endif
#if 1
	Events_ExposeChildren(event->xany.window);
	{
	  int i;
	  int child;
	  IMap_p pChildren;

/*	  ResetWindow(EG.X11eventwin,vNewW,vNewH); */

	  pChildren = X11Windows[X11DrawablesMap[EG.nEventDrawable]].mChildren;

	  for( i=0; i<pChildren->nTopEntry; i++ ){
	    child = pChildren->pData[i];
	    Events_AddEvent(child,MapNotify,sizeof(XMapEvent));
	    Events_AddExpose( child );
	  }
	}
#endif
      } else { /* forget about this one, just a move */
	event->type = 0;
      }
    }
      break;
    case IDCMP_MOUSEBUTTONS:
/*
      printf("(events)mousebuttons! [%d] qual [%x]\n",EG.nCode,EG.nQual);
*/
      if( EG.bButtonSwitch ){
	if( EG.nCode==MENUDOWN || EG.nCode==SELECTDOWN )
	  EG.nCode=MIDDLEDOWN;
	else if( EG.nCode==MENUUP || EG.nCode==SELECTUP )
	  EG.nCode=MIDDLEUP;
      }
      buttoncode = EG.nCode;
      Events_HandleButtons(event,EG.nCode);
      event->xbutton.x = EG.nMouseX-EG.nBorderX;
      event->xbutton.y = EG.nMouseY-EG.nBorderY;
      event->xbutton.x_root = EG.nMouseX+EG.X11eventwin->LeftEdge;
      event->xbutton.y_root = EG.nMouseY+EG.X11eventwin->TopEdge;

      {
	if( EG.nCode==SELECTUP || EG.nCode==MENUUP || EG.nCode==MIDDLEUP ){
	  event->type = ButtonRelease;
	  vEventMask = ButtonReleaseMask;
	} else {
	  event->type = ButtonPress;
	  vEventMask = ButtonPressMask;
	}
      }

      inside = check_inside( event );

      if( inside>0 ){
	event->xbutton.subwindow = X11Windows[X11DrawablesMap[inside]].win;
	event->xbutton.x -= X11Windows[X11DrawablesMap[inside]].rx;
	event->xbutton.y -= X11Windows[X11DrawablesMap[inside]].ry;
      }
      event->xbutton.state = EG.nQual;
      event->xbutton.time = EG.nTime;
      Events_HandleButtons(event,buttoncode);
      break;
    case IDCMP_MOUSEMOVE:
      event->xbutton.x = EG.nMouseX-EG.nBorderX;
      event->xbutton.y = EG.nMouseY-EG.nBorderY;
      event->xbutton.x_root = EG.nMouseX+EG.X11eventwin->LeftEdge;
      event->xbutton.y_root = EG.nMouseY+EG.X11eventwin->TopEdge;
      event->xbutton.state = EG.nQual;

      inside = check_inside( event );

      if( inside>0 ){
	event->xbutton.subwindow = X11Windows[X11DrawablesMap[inside]].win;
	event->xbutton.x -= X11Windows[X11DrawablesMap[inside]].rx;
	event->xbutton.y -= X11Windows[X11DrawablesMap[inside]].ry;
      }
      event->xbutton.time = EG.nTime;
      event->type = MotionNotify;
      vEventMask = PointerMotionMask;
      if( EG.nButtonMask ){
	vEventMask |= (ButtonMotionMask | EG.nButtonMask);
      }
      break;
    case IDCMP_ACTIVEWINDOW:
      EG.nQual = 0;
      event->type = EnterNotify;
      vEventMask = EnterWindowMask;
      inside = check_inside( event );
/*
      DG.X11Screen[0].root=EG.nEventDrawable;
*/
      break;
    case IDCMP_INACTIVEWINDOW:
      EG.nQual = 0;
      event->type = LeaveNotify;
      vEventMask = LeaveWindowMask;
      inside = check_inside( event );
      break;
    default:
      event->xany.window = EG.nEventDrawable;
      break;
    }
    EG.nCode = 0;
    parent = event->xany.window;

#if 0
    if( inside==0 )
      inside = EG.nEventDrawable;
#endif
    if( EG.GrabWin!=-1 ){
      if( event->xany.window!=EG.GrabWin && !X11OwnEvents ){
	event->type = 0;
	return 0;
      }
    }

#if 0
    printf("Event state = %d\n",event->xkey.state);
#endif
#if (DEBUG!=0)
    if( event->xany.window == 0 ){
      printf("Won't do!\n");
    }
#endif

	if( EG.nPrevInside!=inside ){
	  XEvent ievent;
#if 0
	  printf("inside subwindow %d from %d \n",inside,EG.nPrevInside);
#endif
	  ievent.type = LeaveNotify;
	  if( EG.nPrevInside<=0 )
	    ievent.xany.window = EG.nEventDrawable;
	  else
	    ievent.xany.window = EG.nPrevInside;
	  if( X11DrawablesMask[ievent.xany.window] & LeaveWindowMask )
	    Events_NewInternalXEvent(&ievent,sizeof(XLeaveWindowEvent));
	  ievent.xany.window = inside;
	  ievent.type = EnterNotify;
	  if( X11DrawablesMask[ievent.xany.window] & EnterWindowMask )
	    Events_NewInternalXEvent(&ievent,sizeof(XEnterWindowEvent));
	  EG.nPrevInside = inside;
	}

    do {	
      if( X11DrawablesMask[parent] & vEventMask ){ /* (Xevent_to_mask[event->type]) */
	event->xany.window = parent;
#if 0
	if( event->type != MotionNotify )
	  printf( "accepted %x inside %d\n", event->type, event->xany.window );
#endif
	return 1;
      }
      parent = X11Windows[X11DrawablesMap[parent]].parent;
      /* printf("Traversing back to %d\n",parent); */
    } while( parent != ROOTID );

    event->type = 0;
  }

  EG.bHaveWinMsg = 0;
  EG.nCode = 0;

  return(0);
}

/********************************************************************************
Name     : Events_MapRawKey()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Map a rawkey message to a character
********************************************************************************/

void
Events_MapRawKey( struct IntuiMessage *im )
{
  WORD actual;
  struct InputEvent ie = {0};
  int q = im->Qualifier&255;

  if ( im->Class != IDCMP_RAWKEY || !im->Code )
    return;

#if 1
  EG.X11Abuffer[0] = 0;
#endif
  ie.ie_Class = IECLASS_RAWKEY;
  ie.ie_SubClass = 0;
  ie.ie_Code = im->Code /*&127*/;
  if(q==1||q==2||q==8) ie.ie_Qualifier = im->Qualifier&255;
  else {
    ie.ie_Qualifier = 0;
  }
  if( im->IAddress ){
    ie.ie_EventAddress = (APTR *) *((ULONG *)im->IAddress);
    actual = MapRawKey(&ie,  EG.X11Abuffer, BUFFERLEN, NULL);
#if 0
    printf("%d\n", EG.X11Abuffer[0]);
    if( q==8 )
      ie.ie_Qualifier = 0;
    MapRawKey(&ie, X11CharBuffer, BUFFERLEN, NULL);
#endif
  }
}

/********************************************************************************
Name     : XRefreshKeyboardMapping()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XRefreshKeyboardMapping( XMappingEvent* map_event )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XRefreshKeyboardMapping\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XFlush()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

Output   : 
Function : send all queued requests to the server.
********************************************************************************/

XFlush( Display *d )
{
#if 0
  XEvent event;
#endif
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XFLUSH, bInformEvents );
#endif
#if 0
  if( DG.X11NumDrawablesWindows )
    while( XPending(&DG.X11Display) ){
      Events_Get(&event);
    }
#else
  if( DG.X11NumDrawablesWindows ){
    do {
      Events_GetIntui();
    } while ( EG.bHaveWinMsg );
  }
#endif
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XFLUSH, bInformEvents );
#endif

  return(0);
}

#define XK_MISCELLANY
#define XK_LATIN1
#include <X11/keysymdef.h>

/********************************************************************************
Name     : XLookupKeysym()
Author   : Terje Pedersen
Input    : 
     event   Specifies the KeyPress or KeyRelease event that is to be used.

     index   Specifies which keysym  from  the  list  associated  with  the
             keycode  in  the  event  to  return.   These correspond to the
             modifier keys, and the  symbols  ShiftMapIndex,  LockMapIndex,
             ControlMapIndex,   Mod1MapIndex,  Mod2MapIndex,  Mod3MapIndex,
             Mod4MapIndex, and Mod5MapIndex can be used.

Output   : 
Function : get the keysym corresponding to a keycode in structure.
********************************************************************************/

KeySym
XLookupKeysym( XKeyEvent* event, int index )
{
  int retval;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XLOOKUPKEYSYM, bInformEvents );
#endif
  if( (index == 1<<ShiftMapIndex) && (event->state & ShiftMask) )
    retval = XKeys[event->keycode].shiftkey;
  else
    retval = XKeys[event->keycode].key;
#if 0
  if( !retval ){
    if( event->keycode )
      printf("XKeys[] need %d\n",event->keycode);
    retval = NoSymbol;
  } else {
    EG.X11str[0] = retval;
  }
#endif
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XLOOKUPKEYSYM, bInformEvents );
#endif
  return( (KeySym)retval );
}


/********************************************************************************
Name     : XtGrabPointer()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
int 
XtGrabPointer( Widget 		 widget,
	       _XtBoolean 	 owner_events,
	       unsigned int	 event_mask,
	       int 		 pointer_mode,
	       int 		 keyboard_mode,
	       Window 		 confine_to,
	       Cursor 		 cursor,
	       Time 		 t )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtGrabPointer\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XtGrabKeyboard()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
XtGrabKeyboard( Widget 		widget,
	        _XtBoolean      owner_events,
	        int 		pointer_mode,
	        int 		keyboard_mode,
	        Time 		t )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XtGrabKeyboard\n");
#endif

  return(0);
}

extern void setmouse( int x, int y );

#ifndef XMUIAPP
XSizeHints* XAllocSizeHints()
{
  void *data = calloc(sizeof(XSizeHints),1);

#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)data);
#endif /* MEMORYTRACKING */

  return data;
}

XClassHint* XAllocClassHint()
{
  void *data = calloc(sizeof(XClassHint),1);

#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)data);
#endif /* MEMORYTRACKING */

  return data;
}
#endif

/********************************************************************************
Name     : XFree( void* data )
Author   : Terje Pedersen
Input    : data - pointer to memory 
Output   : 
Function : Free the memory pointed to by data
********************************************************************************/

XFree( void* data )
{
#if (MEMORYTRACKING!=0)
  List_RemoveEntry(pMemoryList,(void*)data);
#endif /* MEMORYTRACKING */

  return(0);
}

/********************************************************************************
Name     : XAutoRepeatOn()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XAutoRepeatOn( Display* d )
{
#if (DEBUGXEMUL_ENTRY)
  printf("Autorepeat on\n");
#endif
  X11AutoRepeat = 1;
}

/********************************************************************************
Name     : XAutoRepeatOff()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XAutoRepeatOff( Display *d )
{
#if (DEBUGXEMUL_ENTRY)
  printf("Autorepeat on\n");
#endif
  X11AutoRepeat = 0;
}

/********************************************************************************
Name     : XQueryPointer()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies a window which indicates which screen  the  pointer
              position is returned for, and child_return will be a child of
              this window if pointer is inside a child.

     root_return
              Returns the root window ID the pointer is currently on.

     child_return
              Returns the ID of the child of w the pointer is  located  in,
              or zero if it not in a child.

     root_x_return
     route_y_return
              Return the x and y coordinates of the pointer relative to the
              root's origin.

     win_x_return
     win_y_return
              Return the x and y coordinates of the pointer relative to the
              origin of window w.

     mask_return
              Returns the current state of the modifier  keys  and  pointer
              buttons.   This is a mask composed of the OR of any number of
              the  following  symbols:  ShiftMask,  LockMask,  ControlMask,
              Mod1Mask,  Mod2Mask,  Mod3Mask,  Mod4Mask, Mod5Mask, Button1-
              Mask, Button2Mask, Button3Mask, Button4Mask, Button5Mask.

Output   : 
Function : get the current pointer location.
********************************************************************************/

Bool
XQueryPointer( Display* display,
	       Window w,
	       Window* root_return,
	       Window* child_return,
	       int* root_x_return,
	       int* root_y_return,
	       int* win_x_return,
	       int* win_y_return,
	       unsigned int* mask_return )
{
  XEvent event;
  int old;

  if( w!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(w)) )
      return;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter(  XQUERYPOINTER , bInformEvents );
#endif
  if( !DG.vWindow ){
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave(  XQUERYPOINTER , bInformEvents );
#endif
    return 0;
  }
  if( X11Drawables[w]==X11WINDOW ){
    *win_x_return = DG.vWindow->MouseX-X11Windows[X11DrawablesMap[w]].rx-DG.vWindow->BorderLeft;
    *win_y_return = DG.vWindow->MouseY-X11Windows[X11DrawablesMap[w]].ry-DG.vWindow->BorderTop;
  }
  if( root_x_return )
    *root_x_return = DG.vWindow->LeftEdge+DG.vWindow->MouseX-DG.vWindow->BorderLeft;
  if( root_y_return )
    *root_y_return = DG.vWindow->TopEdge+DG.vWindow->MouseY-DG.vWindow->BorderTop;
  old = EG.nEventDrawable;
  EG.nEventDrawable = w;
  if( XPending(display) ){
    Events_Get(&event);
  } else {
    if( EG.fwindowsig )
      Wait(EG.fwindowsig); 
    Events_Get(&event);
  }
  *mask_return = EG.nButtonMask;
  EG.nEventDrawable = old;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave(  XQUERYPOINTER , bInformEvents );
#endif

  return(TRUE);
}

/********************************************************************************
Name     : XLookupString()
Author   : Terje Pedersen
Input    : 
     event_structure
               Specifies the key event to be used.

     buffer_return
               Returns  the  resulting  string   (not   NULL   terminated).
               Returned value of the function is the length of the string.

     bytes_buffer
               Specifies  the  length  of  the  buffer.    No   more   than
               bytes_buffer of translation are returned.

     keysym_return
               If this argument is not NULL, it  specifies  the  keysym  ID
               computed from the event.

     status_in_out
               Specifies the XComposeStatus structure that contains compose
               key  state  information  and  that  allows  the  compose key
               processing to take place.  This can be NULL if the caller is
               not   interested  in  seeing  compose  key  sequences.   Not
               implemented in X Consortium Xlib through Release 5.

Output   : 
Function : map a key event to ASCII string, keysym, and ComposeStatus.
********************************************************************************/

int
XLookupString( XKeyEvent* event_structure, 
               char* buffer_return,
               int bytes_buffer,
               KeySym* keysym_return,
               XComposeStatus *status_in_out )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XLOOKUPSTRING, bInformEvents );
#endif

  *buffer_return = 0;
  EG.nCode = 0;

#if 0
      if( EG.X11Abuffer[0] ){
	*keysym_return = (XID)EG.X11Abuffer[0] /*X11CharBuffer[0]*/;
	strncpy(buffer_return,EG.X11Abuffer /*X11CharBuffer*/,bytes_buffer);
      } else {
	*keysym_return = XLookupKeysym(event_structure,0);
	buffer_return[0] = *keysym_return;
	buffer_return[1] = 0;
      }
#endif


  if( event_structure->type==KeyPress || event_structure->type==KeyRelease ){
    strncpy( buffer_return, EG.X11Abuffer , bytes_buffer);
    if( keysym_return ){
      *keysym_return = 0;
      if( event_structure->state & ShiftMask ){
	*keysym_return = XKeys[event_structure->keycode].shiftkey;
      } else {
	*keysym_return = XKeys[event_structure->keycode].key;
      }
    }
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XLOOKUPSTRING, bInformEvents );
#endif
    return XKeys[event_structure->keycode].symbol;
  }
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XLOOKUPSTRING, bInformEvents );
#endif
}

/********************************************************************************
Name     : XGrabPointer()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     grab_window
               Specifies the ID of the window that should grab the  pointer
               input independent of pointer location.

     owner_events
               Specifies if the pointer events are to be reported  normally
               within  this  application  (pass  True)  or only to the grab
               window (pass False).

     event_mask
               Specifies the event mask symbols that can be ORed  together.
               Only  events  selected  by  this  mask, plus ButtonPress and
               ButtonRelease, will  be  delivered  during  the  grab.   See
               XSelectInput() for a complete list of event masks.

     pointer_mode
               Controls further processing of pointer events.  Pass  either
               GrabModeSync or GrabModeAsync.

     keyboard_mode
               Controls further processing of keyboard events.  Pass either
               GrabModeSync or GrabModeAsync.

     confine_to
               Specifies the ID of the window to confine the pointer.   One
               option is None, in which case the pointer is not confined to
               any window.

     cursor    Specifies the ID of the cursor that is  displayed  with  the
               pointer  during  the grab.  One option is None, which causes
               the cursor to keep its current pattern.

     time      Specifies the time when the grab request took  place.   Pass
               either  a  timestamp,  expressed  in  milliseconds  (from an
               event), or the constant CurrentTime.

Output   : 
Function : grab the pointer.
********************************************************************************/

int
XGrabPointer( Display* display,
	      Window grab_window,
	      Bool owner_events,
	      unsigned int event_mask,
	      int pointer_mode,
	      int keyboard_mode,
	      Window confine_to,
	      Cursor cursor,
	      Time time )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XGRABPOINTER, bInformEvents );
#endif
  if( grab_window==ROOTID ){
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XGRABPOINTER, bInformEvents );
#endif
    return 0;
  }
  if( cursor )
    XDefineCursor(display, grab_window, cursor);
  EG.GrabMask = X11DrawablesMask[grab_window];
  EG.GrabWin = grab_window;
  X11OwnEvents = owner_events;
  XSelectInput(display,grab_window,event_mask);

  if( confine_to ){
    X11ConfineMouse=1;
    X11ConfineWindow=confine_to;
    XWarpPointer(display,NULL,confine_to,0,0,0,0,10,10);
  } else {
    X11ConfineMouse=0;
    X11ConfineWindow=0;
  }
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XGRABPOINTER, bInformEvents );
#endif
  return(0);
}

/********************************************************************************
Name     : XUngrabPointer()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     time      Specifies the time when the grab should  take  place.   Pass
               either  a  timestamp,  expressed  in  milliseconds,  or  the
               constant CurrentTime.  If this  time  is  earlier  than  the
               last-pointer-grab  time  or  later than current server time,
               the pointer will not be grabbed.

Output   : 
Function : release the pointer from an active grab.
********************************************************************************/

XUngrabPointer( Display* display, Time time )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XUNGRABPOINTER, bInformEvents );
#endif
  XUndefineCursor(display,NULL);

  if( EG.GrabWin==-1 ){
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XUNGRABPOINTER, bInformEvents );
#endif
    return(0);
  }
  assert( EG.GrabWin<DG.X11AvailDrawables );

  X11DrawablesMask[EG.GrabWin] = EG.GrabMask;
  X11OwnEvents = 0;
  EG.GrabMask = 0;
  EG.GrabWin = -1;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XUNGRABPOINTER, bInformEvents );
#endif
  return(0);
}

/********************************************************************************
Name     : XKeysymToString()
Author   : Terje Pedersen
Input    : keysym    Specifies the keysym that is to be converted.
Output   : 
Function : convert a keysym symbol to a string.
********************************************************************************/

char*
XKeysymToString( KeySym keysym )
{
  register int i;

  for( i=0; i<255; i++ ){
    if( XKeys[i].key == keysym )
      return( XKeys[i].name );
    if( XKeys[i].shiftkey == keysym )
      return( XKeys[i].shiftname );
  }
  printf("Undefined keysym %d\n",keysym);

  return NULL;
#if 0
  switch( keysym ){
  case XK_Return:
    strcpy(EG.X11str,"Return"); break;
  case XK_Left:
    strcpy(EG.X11str,"Left"); break;
  case XK_Right:
    strcpy(EG.X11str,"Right"); break;
  case XK_Up:
    strcpy(EG.X11str,"Up"); break;
  case XK_Down:
    strcpy(EG.X11str,"Down"); break;
  case XK_Delete:
    strcpy(EG.X11str,"Delete"); break;
  case XK_BackSpace:
    strcpy(EG.X11str,"BackSpace"); break;
  case XK_Escape:
    strcpy(EG.X11str,"Escape"); break;
  case XK_period:
    strcpy(EG.X11str,"period"); break;
  case XK_slash:
    strcpy(EG.X11str,"slash"); break;
  }

  return(EG.X11str);
#endif
}

/********************************************************************************
Name     : XSetInputFocus()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     focus    Specifies the ID of the window you want to  be  the  keyboard
              focus.  Pass the window ID, PointerRoot, or None.

     revert_to
              Specifies which window the keyboard focus reverts to  if  the
              focus  window  becomes  not  viewable.   Pass  one  of  these
              constants:     RevertToParent,    RevertToPointerRoot,     or
              RevertToNone.  Must not be a window ID.

     time     Specifies the time when the focus change should  take  place.
              Pass  either  a  timestamp, expressed in milliseconds, or the
              constant CurrentTime.  Also returns the  time  of  the  focus
              change when CurrentTime is specified.

Output   : 
Function : set the keyboard focus window.
********************************************************************************/

XSetInputFocus(Display* display,
	       Window focus,
	       int revert_to,
	       Time time )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSETINPUTFOCUS, bInformEvents );
#endif
  if( X11Drawables[focus]==X11WINDOW ){
    int root = X11Windows[X11DrawablesMap[focus]].root;
    ActivateWindow(X11DrawablesWindows[X11DrawablesMap[root]]);
    EG.nEventDrawable = focus;
  }

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XSETINPUTFOCUS, bInformEvents );
#endif

  return(0);
}

/********************************************************************************
Name     : XWarpPointer()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
XWarpPointer( Display *display,
	      Window src_w,
	      Window dest_w,
	      int src_x,
	      int src_y,
	      unsigned int src_width,
	      unsigned int src_height,
	      int dest_x,
	      int dest_y )
{
#if (DEBUGXEMUL_ENTRY)
  FunCount_Enter( XWARPPOINTER, bInformEvents );
#endif
  if( dest_w!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(dest_w)) )
      return;

  if( dest_w && dest_w!=ROOTID ){
    if( DG.vWindow ){
      dest_x += X11Windows[X11DrawablesMap[dest_w]].rx;
      dest_y += X11Windows[X11DrawablesMap[dest_w]].ry;
      setmouse(DG.vWindow->LeftEdge+DG.vWindow->BorderLeft+dest_x,DG.vWindow->TopEdge+DG.vWindow->BorderTop+dest_y);
    }
  } else {
    setmouse(dest_x,dest_y);
  }
  return(0);
}

KeySym XStringToKeysym(string)
     char *string;
{
  register int i;
  int vStrLen;
  int vKeyLen;

#if (DEBUGXEMUL_ENTRY)
  FunCount_Enter( XSTRINGTOKEYSYM, bInformEvents );
#endif

  if( strchr(string,' ') )
    *strchr(string,' ') = 0;
  vStrLen = strlen(string);
  for( i=0; i<256; i++ ){
    vKeyLen = strlen(XKeys[i].name);
    if( vKeyLen==vStrLen && !strncmp(string,XKeys[i].name,vKeyLen) )
      return (XKeys[i].key);
    vKeyLen = strlen(XKeys[i].shiftname);
    if( vKeyLen==vStrLen && XKeys[i].shiftname!=NULL
       && !strncmp(string,XKeys[i].shiftname,vKeyLen) )
      return (XKeys[i].shiftkey);
  }

  printf("XStringToKeysym: unknown [%s]\n",string);
  return(0);
}

/********************************************************************************
Name     : XEventsQueued()
Author   : Terje Pedersen
Input    : 
     display   Specifies a connection to a Display structure, returned from
               XOpenDisplay().

     mode      Specifies whether the request buffer is flushed if there are
               no  events  in  Xlib's  queue.  You can specify one of these
               constants:         QueuedAlready,          QueuedAfterFlush,
               QueuedAfterReading.

Output   : 
Function : check the number of events in the event queue.
********************************************************************************/

int
XEventsQueued( Display *display, int  mode )
{
  int vRet;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XEVENTSQUEUED, bInformEvents );
#endif
/*  if()
    return(XPeekEvent(&DG.X11Display,&peekevent));*/
  EG.bDontWait = 1;

  vRet = XPending(&DG.X11Display);

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XEVENTSQUEUED, bInformEvents );
#endif 
  return vRet;

}

/********************************************************************************
Name     : XSendEvent()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the ID of the window where you want  to  send  the
               event.   Pass  the  window  resource  ID,  PointerWindow, or
               InputFocus.

     propagate Specifies how the sent event should propagate  depending  on
               event_mask.  See description below.  May be True or False.

     event_mask
               Specifies the event mask.  See XSelectInput() for a detailed
               list of the event masks.

     event_send
               Specifies a pointer to the event to be sent.

Output   : 
Function : send an event.
********************************************************************************/
Status
XSendEvent( Display* display,
	    Window w,
	    Bool propagate,
	    long event_mask,
	    XEvent* event_send )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSENDEVENT, bInformEvents );
#endif
  if( w != ROOTID ){
    event_send->xclient.window = w;
    Events_NewInternalXEvent(event_send,sizeof(XEvent));
  }

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XSENDEVENT, bInformEvents );
#endif

  return(0);
}

/********************************************************************************
Name     : XCheckIfEvent()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     event_return
               Returns the matched event structure.

     predicate Specifies the procedure that is called to determine  if  the
               next event in the queue matches your criteria.

     arg       Specifies the user-specified argument that will be passed to
               the predicate procedure.

Output   : 
Function : check the event queue for a matching event; don't wait.
********************************************************************************/

Bool
XCheckIfEvent(Display* display,
	      XEvent* event_return,
	      Bool (*
#if 1
__stdargs
#endif
		    predicate)(Display *,XEvent*,char *data),
	      char* arg )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCHECKIFEVENT, bInformEvents );
#endif
  if( XPending(display) ){
    XNextEvent(display,event_return);
    if( predicate(display,event_return,arg) ){
#ifdef DEBUGXEMUL_ENTRY
      FunCount_Leave( XCHECKIFEVENT, bInformEvents );
#endif
      return(1);
    }
  }

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XCHECKIFEVENT, bInformEvents );
#endif
  return(0);
}

/********************************************************************************
Name     : XPeekIfEvent()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     event_return
               Returns a copy of the matched event.

     predicate Specifies the procedure to be called to  determine  if  each
               event that arrives in the queue is the desired one.

     arg       Specifies the user-specified argument that will be passed to
               the predicate procedure.

Output   : 
Function : get an event matched by predicate procedure without removing it from
           the queue.
********************************************************************************/

XPeekIfEvent( Display* display,
	      XEvent* event_return,
	      Bool (*
#if 1
__stdargs
#endif
		    predicate)(Display *,XEvent*,char *data),
	      XPointer arg )
{
  Bool bFound = FALSE;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XPEEKIFEVENT, bInformEvents );
#endif

  if( EG.X11InternalEvents->next ){
    InternalXEvent *pThis = EG.X11InternalEvents->next,*pPrev = EG.X11InternalEvents,*old = NULL;

    while( pThis!=NULL &&
	  !(bFound = predicate(display,pThis->xev,arg)) ){
      pPrev = pThis;
      pThis = pThis->next;
    }    
    if( bFound ){
      memcpy(event_return,pThis->xev,pThis->size);
#ifdef DEBUGXEMUL_ENTRY
      FunCount_Leave( XPEEKIFEVENT, bInformEvents );
#endif
      return;
    } 
  } else {
    EG.bSkipInternal = 1;
    do {
      XNextEvent(display,event_return);
      if( !predicate(display,event_return,arg) ) XPutBackEvent(display,event_return);
    } while( !predicate(display,event_return,arg) && XPending(display) );
    EG.bSkipInternal = 0;
  }
  if( !predicate(display,event_return,arg) ){
    XFlush( display );
    do {
      XNextEvent(display,event_return);
    } while( !predicate(display,event_return,arg) );
  }
  XPutBackEvent(display,event_return);
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XPEEKIFEVENT, bInformEvents );
#endif
}

/********************************************************************************
Name     : XCheckWindowEvent()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the window ID.  The  event  must  match  both  the
               passed window and the passed event mask.

     event_mask
               Specifies the event mask.  See XSelectInput() for a list  of
               mask elements.

     event_return
               Returns the XEvent structure.

Output   : 
Function : remove the next event matching both passed window
           and passed mask; don't wait.
********************************************************************************/

Bool
XCheckWindowEvent(Display* display,
		  Window w,
		  long event_mask,
		  XEvent* event_return )
{
  long old;
  int olddrawable;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCHECKWINDOWEVENT, bInformEvents );
#endif
  olddrawable = EG.nEventDrawable;
  EG.nEventDrawable = w;
  old = X11DrawablesMask[w];

  assert( w>=0 && w<DG.X11AvailDrawables );

  X11DrawablesMask[w] = event_mask;
  event_return->type = 0;
  if( XPending(display) ){
#if 1
    Events_NextInternalWindowXEvent(event_return,w);
#else
    XNextEvent(display,event_return);
#endif
  }

  X11DrawablesMask[w] = old;
  EG.nEventDrawable = olddrawable;
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XCHECKWINDOWEVENT, bInformEvents );
#endif
  if( Xevent_to_mask[event_return->type]&event_mask ){
    return(1);
  }

  return(0);
}

/********************************************************************************
Name     : XPutBackEvent()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     event     Specifies a pointer to the event to be requeued.

Output   : 
Function : push an event back on the input queue.
********************************************************************************/

XPutBackEvent( Display* display,
	       XEvent* event )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XPUTBACKEVENT, bInformEvents ); 
#endif
  Events_NewInternalXEvent(event,sizeof(XEvent));

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XPUTBACKEVENT, bInformEvents ); 
#endif

  return(0);
}

/********************************************************************************
Name     : XCheckMaskEvent()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     event_mask
               Specifies the event types to be returned.   See  list  under
               XSelectInput().

     event_return
               Returns a copy of the matched event's XEvent structure.
Output   : 
Function : remove the next event that matches mask; don't wait.
********************************************************************************/

Bool
XCheckMaskEvent( Display* display,
		 long event_mask,
		 XEvent* event_return )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCHECKMASKEVENT, bInformEvents ); 
#endif

  if( XPending(display) ){
    XPeekEvent(display,event_return);
    if( Xevent_to_mask[event_return->type] & event_mask ){
#ifdef DEBUGXEMUL_ENTRY
      FunCount_Leave( XCHECKMASKEVENT, bInformEvents ); 
#endif
      return 1;
    }
  }

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XCHECKMASKEVENT, bInformEvents ); 
#endif

  return(0);
}
