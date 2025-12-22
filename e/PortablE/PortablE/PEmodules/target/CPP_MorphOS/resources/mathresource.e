/* $VER: mathresource.h 1.2 (13.7.1990) */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <resources/mathresource.h>}
NATIVE {RESOURCES_MATHRESOURCE_H} CONST

/*
*	The 'Init' entries are only used if the corresponding
*	bit is set in the Flags field.
*
*	So if you are just a 68881, you do not need the Init stuff
*	just make sure you have cleared the Flags field.
*
*	This should allow us to add Extended Precision later.
*
*	For Init users, if you need to be called whenever a task
*	opens this library for use, you need to change the appropriate
*	entries in MathIEEELibrary.
*/

NATIVE {MathIEEEResource} OBJECT mathieeeresourceresource
	{MathIEEEResource_Node}	node	:ln
	{MathIEEEResource_Flags}	flags	:UINT
	{MathIEEEResource_BaseAddr}	baseaddr	:PTR TO UINT /* ptr to 881 if exists */
	{MathIEEEResource_DblBasInit}	dblbasinit	:NATIVE {void	(*)()} PTR
	{MathIEEEResource_DblTransInit}	dbltransinit	:NATIVE {void	(*)()} PTR
	{MathIEEEResource_SglBasInit}	sglbasinit	:NATIVE {void	(*)()} PTR
	{MathIEEEResource_SglTransInit}	sgltransinit	:NATIVE {void	(*)()} PTR
	{MathIEEEResource_ExtBasInit}	extbasinit	:NATIVE {void	(*)()} PTR
	{MathIEEEResource_ExtTransInit}	exttransinit	:NATIVE {void	(*)()} PTR
ENDOBJECT

/* definations for MathIEEEResource_FLAGS */
NATIVE {MATHIEEERESOURCEF_DBLBAS}	CONST MATHIEEERESOURCEF_DBLBAS	= $1
NATIVE {MATHIEEERESOURCEF_DBLTRANS}	CONST MATHIEEERESOURCEF_DBLTRANS	= $2
NATIVE {MATHIEEERESOURCEF_SGLBAS}	CONST MATHIEEERESOURCEF_SGLBAS	= $4
NATIVE {MATHIEEERESOURCEF_SGLTRANS}	CONST MATHIEEERESOURCEF_SGLTRANS	= $8
NATIVE {MATHIEEERESOURCEF_EXTBAS}	CONST MATHIEEERESOURCEF_EXTBAS	= $10
NATIVE {MATHIEEERESOURCEF_EXTTRANS}	CONST MATHIEEERESOURCEF_EXTTRANS	= $20
