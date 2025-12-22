/*
** SDL display adapter Hollywood plugin
** Copyright (C) 2014-2017 Andreas Falkenhahn <andreas@airsoftsoftwair.de>
**
** Permission is hereby granted, free of charge, to any person obtaining a copy
** of this software and associated documentation files (the "Software"), to deal
** in the Software without restriction, including without limitation the rights
** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
** copies of the Software, and to permit persons to whom the Software is
** furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included in
** all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
** SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// mapping table SDL key -> Hollywood key
static const struct
{
	int hwkey;
	int sdlkey;
} keymap[] = {
	{HWKEY_CURSOR_UP, SDLK_UP},
	{HWKEY_CURSOR_DOWN, SDLK_DOWN},
	{HWKEY_CURSOR_RIGHT, SDLK_RIGHT},
	{HWKEY_CURSOR_LEFT, SDLK_LEFT},
	{HWKEY_F1, SDLK_F1},
	{HWKEY_F2, SDLK_F2},
	{HWKEY_F3, SDLK_F3},
	{HWKEY_F4, SDLK_F4},
	{HWKEY_F5, SDLK_F5},
	{HWKEY_F6, SDLK_F6},
	{HWKEY_F7, SDLK_F7},
	{HWKEY_F8, SDLK_F8},
	{HWKEY_F9, SDLK_F9},
	{HWKEY_F10, SDLK_F10},
	{HWKEY_F11, SDLK_F11},
	{HWKEY_F12, SDLK_F12},
	{HWKEY_F13, SDLK_F13},
	{HWKEY_F14, SDLK_F14},
	{HWKEY_F15, SDLK_F15},	
	{HWKEY_BACKSPACE, SDLK_BACKSPACE},
	{HWKEY_TAB, SDLK_TAB},
	{HWKEY_RETURN, SDLK_RETURN},
	{HWKEY_ESC, SDLK_ESCAPE},
	{HWKEY_SPACE, SDLK_SPACE},
	{HWKEY_DEL, SDLK_DELETE},
	{HWKEY_INSERT, SDLK_INSERT},
	{HWKEY_HOME, SDLK_HOME},
	{HWKEY_END, SDLK_END},
	{HWKEY_PAGEUP, SDLK_PAGEUP},
	{HWKEY_PAGEDOWN, SDLK_PAGEDOWN},
	{HWKEY_PAUSE, SDLK_PAUSE},
	{HWKEY_ENTER, SDLK_KP_ENTER},
	{HWKEY_PRINT, SDLK_PRINTSCREEN},
	{HWKEY_F16, SDLK_F16},		
	{'0', SDLK_KP_0},
	{'1', SDLK_KP_1},
	{'2', SDLK_KP_2},
	{'3', SDLK_KP_3},
	{'4', SDLK_KP_4},
	{'5', SDLK_KP_5},
	{'6', SDLK_KP_6},
	{'7', SDLK_KP_7},
	{'8', SDLK_KP_8},
	{'9', SDLK_KP_9},
	{'.', SDLK_KP_PERIOD},
	{'/', SDLK_KP_DIVIDE},
	{'*', SDLK_KP_MULTIPLY},
	{'-', SDLK_KP_MINUS},
	{'+', SDLK_KP_PLUS},  	                                                                             
	{0, 0}
};
