OPT NATIVE
MODULE 'target/graphics/text', 'target/utility/hooks'
MODULE 'target/exec/types'

NATIVE {StringExtend} OBJECT stringextend
    {Font}	font	:PTR TO textfont
    {Pens}	pens[2]	:ARRAY OF UBYTE
    {ActivePens}	activepens[2]	:ARRAY OF UBYTE
    {InitialModes}	initialmodes	:ULONG
    {EditHook}	edithook	:PTR TO hook
    {WorkBuffer}	workbuffer	:/*STRPTR*/ ARRAY OF CHAR
    {Reserved}	reserved[4]	:ARRAY OF ULONG
ENDOBJECT
