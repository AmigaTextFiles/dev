/* $Id: emulator.h,v 1.10 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes'
{#include <resources/emulator.h>}
NATIVE {RESOURCES_EMULATOR_H} CONST

NATIVE {EmulatorResource} OBJECT emulatorresource
    {Node}	node	:ln
    {EnterPPC}	enterppc	:APTR
    {Enter68K}	enter68k	:APTR
    {EnterPPCQuick}	enterppcquick	:APTR
    {Enter68KQuick}	enter68kquick	:APTR
    {EnterPPCQuickSP}	enterppcquicksp	:APTR
    {EnterPPCNew}	enterppcnew	:APTR
    {EnterPPCDirectly}	enterppcdirectly	:APTR
    {PrivateDontMove}	privatedontmove	:ULONG
    {Reserved}	reserved[3]	:ARRAY OF ULONG
ENDOBJECT
