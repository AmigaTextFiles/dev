/* $Id: iprefs.h 21385 2004-03-25 22:20:00Z falemagn $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <intuition/iprefs.h>}
NATIVE {INTUITION_IPREFS_H} CONST

NATIVE {IPREFS_TYPE_ICONTROL}   CONST IPREFS_TYPE_ICONTROL   = 0
NATIVE {IPREFS_TYPE_SCREENMODE} CONST IPREFS_TYPE_SCREENMODE = 1

NATIVE {IScreenModePrefs} OBJECT iscreenmodeprefs
    {smp_DisplayID}	displayid	:ULONG
    {smp_Width}	width	:UINT
    {smp_Height}	height	:UINT
    {smp_Depth}	depth	:UINT
    {smp_Control}	control	:UINT
ENDOBJECT

NATIVE {IIControlPrefs} OBJECT iicontrolprefs
    {ic_TimeOut}	timeout	:UINT
    {ic_MetaDrag}	metadrag	:INT
    {ic_Flags}	flags	:ULONG
    {ic_WBtoFront}	wbtofront	:UBYTE
    {ic_FrontToBack}	fronttoback	:UBYTE
    {ic_ReqTrue}	reqtrue	:UBYTE
    {ic_ReqFalse}	reqfalse	:UBYTE
ENDOBJECT
