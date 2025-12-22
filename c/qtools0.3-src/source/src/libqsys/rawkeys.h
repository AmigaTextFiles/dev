/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef RAWKEY_H
#define	RAWKEY_H

struct keyEvent {
  unsigned char pressed;					/* -1 if nothing */
  unsigned short int qualifier;					/* -1 if nothing */
};

#define	RAWKEY_TILDE		0x00
#define	RAWKEY_1		0x01
#define	RAWKEY_2		0x02
#define	RAWKEY_3		0x03
#define	RAWKEY_4		0x04
#define	RAWKEY_5		0x05
#define	RAWKEY_6		0x06
#define	RAWKEY_7		0x07
#define	RAWKEY_8		0x08
#define	RAWKEY_9		0x09
#define	RAWKEY_0		0x0A
#define	RAWKEY_SZ		0x0B				/* ß */

#define	RAWKEY_BACKSLASH	0x0D

#define	RAWKEY_NUMPAD_INS	0x0F
#define	RAWKEY_q		0x10
#define	RAWKEY_w		0x11
#define	RAWKEY_e		0x12
#define	RAWKEY_r		0x13
#define	RAWKEY_t		0x14
#define	RAWKEY_z		0x15
#define	RAWKEY_u		0x16
#define	RAWKEY_i		0x17
#define	RAWKEY_o		0x18
#define	RAWKEY_p		0x19
#define	RAWKEY_UE		0x1a				/* ü */
#define	RAWKEY_PLUS		0x1b				/* + */

#define	RAWKEY_NUMPAD_END	0x1d
#define	RAWKEY_NUMPAD_AWDN	0x1e
#define	RAWKEY_NUMPAD_PGDN	0x1f
#define	RAWKEY_a		0x20
#define	RAWKEY_s		0x21
#define	RAWKEY_d		0x22
#define	RAWKEY_f		0x23
#define	RAWKEY_g		0x24
#define	RAWKEY_h		0x25
#define	RAWKEY_j		0x26
#define	RAWKEY_k		0x27
#define	RAWKEY_l		0x28
#define	RAWKEY_OE		0x29				/* ö */
#define	RAWKEY_AE		0x2a				/* ä */
#define	RAWKEY_TICTAC		0x2b				/* # */

#define	RAWKEY_NUMPAD_AWLEFT	0x2d
#define	RAWKEY_NUMPAD_PAUSE	0x2e
#define	RAWKEY_NUMPAD_AWRIGHT	0x2f
#define	RAWKEY_SHIFTLEFT	0x30				/* < */
#define	RAWKEY_y		0x31
#define	RAWKEY_x		0x32
#define	RAWKEY_c		0x33
#define	RAWKEY_v		0x34
#define	RAWKEY_b		0x35
#define	RAWKEY_n		0x36
#define	RAWKEY_m		0x37
#define	RAWKEY_COMMA		0x38				/* , */
#define	RAWKEY_POINT		0x39				/* . */
#define	RAWKEY_MINUS		0x3a				/* - */

#define	RAWKEY_NUMPAD_DEL	0x3c
#define	RAWKEY_NUMPAD_HOME	0x3d
#define	RAWKEY_NUMPAD_AWUP	0x3e
#define	RAWKEY_NUMPAD_PGUP	0x3f
#define	RAWKEY_SPACE		0x40				/*   */
#define	RAWKEY_BACKSPACE	0x41
#define	RAWKEY_TAB		0x42
#define	RAWKEY_ENTER		0x43
#define	RAWKEY_RETURN		0x44
#define	RAWKEY_ESCAPE		0x45
#define	RAWKEY_DELETE		0x46

#define	RAWKEY_NUMPAD_MINUS	0x4A

#define	RAWKEY_UPARROW		0x4C
#define	RAWKEY_DOWNARROW	0x4D
#define	RAWKEY_RIGHTARROW	0x4E
#define	RAWKEY_LEFTARROW	0x4F
#define	RAWKEY_F1		0x50
#define	RAWKEY_F2		0x51
#define	RAWKEY_F3		0x52
#define	RAWKEY_F4		0x53
#define	RAWKEY_F5		0x54
#define	RAWKEY_F6		0x55
#define	RAWKEY_F7		0x56
#define	RAWKEY_F8		0x57
#define	RAWKEY_F9		0x58
#define	RAWKEY_F10		0x59
#define	RAWKEY_NUMPAD_NUML	0x5a
#define	RAWKEY_NUMPAD_SCRL	0x5b
#define	RAWKEY_NUMPAD_SLASH	0x5c
#define	RAWKEY_NUMPAD_STAR	0x5d
#define	RAWKEY_NUMPAD_PLUS	0x5e
#define	RAWKEY_HELP		0x5f
#define	RAWKEY_LEFTSHIFT	0x60
#define	RAWKEY_RIGHTSHIFT	0x61
#define	RAWKEY_CAPSLOCK		0x62
#define	RAWKEY_CONTROL		0x63
#define	RAWKEY_LEFTALT		0x64
#define	RAWKEY_RIGHTALT		0x65
#define	RAWKEY_LEFTCOMMAND	0x66
#define	RAWKEY_RIGHTCOMMAND	0x67

#define	RAWKEY_NOTHING		0xFF

#define RAWQUAL_LSHIFT		0x0001
#define RAWQUAL_RSHIFT		0x0002
#define RAWQUAL_CAPSLOCK	0x0004
#define RAWQUAL_CONTROL		0x0008
#define RAWQUAL_LALT		0x0010
#define RAWQUAL_RALT		0x0020
#define RAWQUAL_LCOMMAND	0x0040
#define RAWQUAL_RCOMMAND	0x0080
#define RAWQUAL_NUMERICPAD	0x0100

#endif
