/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#include <exec/types.h>
#include <dos/dos.h>
#include <rexx/storage.h>

#define NO_GLOBALS
#include "drawrexx.h"

#define RESINDEX(stype) (((long) &((struct stype *)0)->res) / sizeof(long))

char	RexxPortBaseName[80] = "AMISLATE";
char	*rexx_extension = "AMISLATE";

struct rxs_command rxs_commandlist[] =
{
	{ "BREAKAREXXSCRIPTS", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_breakarexxscripts, 1 },
	{ "CIRCLE", "X/N,Y/N,RX/N,RY/N,FILL/S,XOR/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_circle, 1 },
	{ "CLEAR", "XOR/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_clear, 1 },
	{ "CONNECT", "HOSTNAME", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_connect, 1 },
	{ "DISCONNECT", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_disconnect, 1 },
	{ "DISPLAYBEEP", "LOCAL/S,REMOTE/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_displaybeep, 1 },
	{ "EASYREQUEST", "TITLE,MESSAGE,GADGETS", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_easyrequest, 1 },
	{ "FILEREQUEST", "TITLE,DIR,FILE,OKTEXT,SAVE/S", "FILE", RESINDEX(rxd_filerequest), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_filerequest, 1 },
	{ "FLOOD", "X/N,Y/N,UNSAFE/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_flood, 1 },
	{ "GETPIXEL", "X/N,Y/N", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_getpixel, 1 },
	{ "GETREMOTESTATEATTRS", NULL, "MODE/N,FPEN/N,BPEN/N,FRED/N,FGREEN/N,FBLUE/N,BRED/N,BGREEN/N,BBLUE/N", RESINDEX(rxd_getremotestateattrs), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_getremotestateattrs, 1 },
	{ "GETSTATEATTRS", NULL, "MODE/N,FPEN/N,BPEN/N,FRED/N,FGREEN/N,FBLUE/N,BRED/N,BGREEN/N,BBLUE/N,PENDOWN/N,LOCKED/N,LOCKEDPALETTES/N", RESINDEX(rxd_getstateattrs), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_getstateattrs, 1 },
	{ "GETVERSION", NULL, "VERSION", RESINDEX(rxd_getversion), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_getversion, 1 },
	{ "GETWINDOWATTRS", NULL, "TOP/N,LEFT/N,WIDTH/N,HEIGHT/N,DEPTH/N,MAXWIDTH/N,MAXHEIGHT/N", RESINDEX(rxd_getwindowattrs), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_getwindowattrs, 1 },
	{ "LINE", "X1/N,Y1/N,X2/N,Y2/N,XOR/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_line, 1 },
	{ "LOADIFF", "FILE,EXPAND/S,LOADPALETTE/S,PROTECTGUI/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_loadiff, 1 },
	{ "LOCK", "ON/S,OFF/S", "STATE/N", RESINDEX(rxd_lock), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_lock, 1 },
	{ "LOCKPALETTE", "ON/S,OFF/S", "STATE/N", RESINDEX(rxd_lockpalette), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_lockpalette, 1 },
	{ "PEN", "X/N,Y/N,XOR/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_pen, 1 },
	{ "PENRESET", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_penreset, 1 },
	{ "PLAYSCRIPT", "FILE", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_playscript, 1 },
	{ "POINT", "X/N,Y/N,XOR/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_point, 1 },
	{ "PUTRASTERPIXELS", "LENGTH/N,RED/N,GREEN/N,BLUE/N,PEN/N/K", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_putrasterpixels, 1 },
	{ "QUIT", "FORCE/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_quit, 1 },
	{ "RECORDSCRIPT", "FILE,FORCE/S,START/S,STOP/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_recordscript, 1 },
	{ "REMOTEEASYREQUEST", "TITLE,MESSAGE,GADGETS", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_remoteeasyrequest, 1 },
	{ "REMOTEREXXCOMMAND", "MESSAGE,FILE", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_remoterexxcommand, 1 },
	{ "REMOTESTRINGREQUEST", "TITLE,DEFAULTSTRING,MESSAGE", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_remotestringrequest, 1 },
	{ "SAVEIFF", "FILE", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_saveiff, 1 },
	{ "SENDMESSAGE", "MESSAGE", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_sendmessage, 1 },
	{ "SETBCOLOR", "RED/N,GREEN/N,BLUE/N,NOTBACKGROUND/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setbcolor, 1 },
	{ "SETBPEN", "PEN/N", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setbpen, 1 },
	{ "SETFCOLOR", "RED/N,GREEN/N,BLUE/N,NOTBACKGROUND/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setfcolor, 1 },
	{ "SETFPEN", "PEN/N", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setfpen, 1 },
	{ "SETRASTER", "X/N,Y/N,WIDTH/N,HEIGHT/N,OFFSET/N", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setraster, 1 },
	{ "SETREMOTEWINDOWTITLE", "MESSAGE", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setremotewindowtitle, 1 },
	{ "SETTOOLBEHAVIOR", "TOOL/N,MODE/N,PRAGMA1,PRAGMA2", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_settoolbehavior, 1 },
	{ "SETUSERBCOLOR", "RED/N,GREEN/N,BLUE/N,NOTBACKGROUND/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setuserbcolor, 1 },
	{ "SETUSERBPEN", "PEN/N,NOTBACKGROUND/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setuserbpen, 1 },
	{ "SETUSERFCOLOR", "RED/N,GREEN/N,BLUE/N,NOTBACKGROUND/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setuserfcolor, 1 },
	{ "SETUSERFPEN", "PEN/N,NOTBACKGROUND/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setuserfpen, 1 },
	{ "SETUSERTOOL", "TOOL/N", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setusertool, 1 },
	{ "SETWINDOWTITLE", "MESSAGE", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setwindowtitle, 1 },
	{ "SIZEWINDOW", "TOP/N,LEFT/N,WIDTH/N,HEIGHT/N", "EXACT/N,TOP/N,LEFT/N,WIDTH/N,HEIGHT/N", RESINDEX(rxd_sizewindow), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_sizewindow, 1 },
	{ "SQUARE", "X1/N,Y1/N,X2/N,Y2/N,FILL/S,XOR/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_square, 1 },
	{ "STRINGREQUEST", "TITLE,DEFAULTSTRING,MESSAGE", "MESSAGE", RESINDEX(rxd_stringrequest), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_stringrequest, 1 },
	{ "TYPEKEYS", "MESSAGE", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_typekeys, 1 },
	{ "WAITEVENT", "TIMEOUT/N,MESSAGE/S,CLICK/S,RESIZE/S,QUIT/S,CONNECT/S,DISCONNECT/S,TOOLSELECT/S,COLORSELECT/S,KEYPRESS/S,MOUSEDOWN/S,MOUSEUP/S,MOUSEMOVE/S", "TYPE/N,X/N,Y/N,MESSAGE,CODE1/N,CODE2/N,MOUSEX/N,MOUSEY/N,BUTTON/N,LASTKEY/N", RESINDEX(rxd_waitevent), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_waitevent, 1 },
	{ NULL, NULL, NULL, NULL, NULL }
};

int		command_cnt = 48;

static struct arb_p_link link0[] = {
	{"WAITEVENT", 1}, {"TYPEKEYS", 2}, {"S", 3}, {"RE", 30}, {"QUIT", 36}, {"P", 37},
	{"L", 43}, {"GET", 49}, {"F", 55}, {"EASYREQUEST", 58}, {"DIS", 59}, {"C", 62},
	{"BREAKAREXXSCRIPTS", 66}, {NULL, 0} };

static struct arb_p_link link3[] = {
	{"TRINGREQUEST", 4}, {"QUARE", 5}, {"IZEWINDOW", 6}, {"E", 7}, {"AVEIFF", 29}, {NULL, 0} };

static struct arb_p_link link7[] = {
	{"T", 8}, {"NDMESSAGE", 28}, {NULL, 0} };

static struct arb_p_link link8[] = {
	{"WINDOWTITLE", 9}, {"USER", 10}, {"TOOLBEHAVIOR", 18}, {"R", 19}, {"F", 22}, {"B", 25},
	{NULL, 0} };

static struct arb_p_link link10[] = {
	{"TOOL", 11}, {"F", 12}, {"B", 15}, {NULL, 0} };

static struct arb_p_link link12[] = {
	{"PEN", 13}, {"COLOR", 14}, {NULL, 0} };

static struct arb_p_link link15[] = {
	{"PEN", 16}, {"COLOR", 17}, {NULL, 0} };

static struct arb_p_link link19[] = {
	{"EMOTEWINDOWTITLE", 20}, {"ASTER", 21}, {NULL, 0} };

static struct arb_p_link link22[] = {
	{"PEN", 23}, {"COLOR", 24}, {NULL, 0} };

static struct arb_p_link link25[] = {
	{"PEN", 26}, {"COLOR", 27}, {NULL, 0} };

static struct arb_p_link link30[] = {
	{"MOTE", 31}, {"CORDSCRIPT", 35}, {NULL, 0} };

static struct arb_p_link link31[] = {
	{"STRINGREQUEST", 32}, {"REXXCOMMAND", 33}, {"EASYREQUEST", 34}, {NULL, 0} };

static struct arb_p_link link37[] = {
	{"UTRASTERPIXELS", 38}, {"OINT", 39}, {"LAYSCRIPT", 40}, {"EN", 41}, {NULL, 0} };

static struct arb_p_link link41[] = {
	{"RESET", 42}, {NULL, 0} };

static struct arb_p_link link43[] = {
	{"O", 44}, {"INE", 48}, {NULL, 0} };

static struct arb_p_link link44[] = {
	{"CK", 45}, {"ADIFF", 47}, {NULL, 0} };

static struct arb_p_link link45[] = {
	{"PALETTE", 46}, {NULL, 0} };

static struct arb_p_link link49[] = {
	{"WINDOWATTRS", 50}, {"VERSION", 51}, {"STATEATTRS", 52}, {"REMOTESTATEATTRS", 53}, {"PIXEL", 54}, {NULL, 0} };

static struct arb_p_link link55[] = {
	{"LOOD", 56}, {"ILEREQUEST", 57}, {NULL, 0} };

static struct arb_p_link link59[] = {
	{"PLAYBEEP", 60}, {"CONNECT", 61}, {NULL, 0} };

static struct arb_p_link link62[] = {
	{"ONNECT", 63}, {"LEAR", 64}, {"IRCLE", 65}, {NULL, 0} };

struct arb_p_state arb_p_state[] = {
	{-1, link0}, {47, NULL}, {46, NULL}, {28, link3}, {45, NULL},
	{44, NULL}, {43, NULL}, {29, link7}, {30, link8}, {42, NULL},
	{37, link10}, {41, NULL}, {39, link12}, {40, NULL}, {39, NULL},
	{37, link15}, {38, NULL}, {37, NULL}, {36, NULL}, {34, link19},
	{35, NULL}, {34, NULL}, {32, link22}, {33, NULL}, {32, NULL},
	{30, link25}, {31, NULL}, {30, NULL}, {29, NULL}, {28, NULL},
	{24, link30}, {25, link31}, {27, NULL}, {26, NULL}, {25, NULL},
	{24, NULL}, {23, NULL}, {18, link37}, {22, NULL}, {21, NULL},
	{20, NULL}, {18, link41}, {19, NULL}, {14, link43}, {15, link44},
	{16, link45}, {17, NULL}, {15, NULL}, {14, NULL}, {9, link49},
	{13, NULL}, {12, NULL}, {11, NULL}, {10, NULL}, {9, NULL},
	{7, link55}, {8, NULL}, {7, NULL}, {6, NULL}, {4, link59},
	{5, NULL}, {4, NULL}, {1, link62}, {3, NULL}, {2, NULL},
	{1, NULL}, {0, NULL}  };

