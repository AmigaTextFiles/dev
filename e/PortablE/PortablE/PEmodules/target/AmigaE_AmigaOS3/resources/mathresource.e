/* $VER: mathresource.h 1.2 (13.7.1990) */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{MODULE 'resources/mathresource'}

NATIVE {mathieeeresource} OBJECT mathieeeresourceresource
	{node}	node	:ln
	{flags}	flags	:UINT
	{baseaddr}	baseaddr	:PTR TO UINT /* ptr to 881 if exists */
	{dblbasinit}	dblbasinit	:PTR /*void	(*MathIEEEResource_DblBasInit)()*/
	{dbltransinit}	dbltransinit	:PTR /*void	(*MathIEEEResource_DblTransInit)()*/
	{sglbasinit}	sglbasinit	:PTR /*void	(*MathIEEEResource_SglBasInit)()*/
	{sgltransinit}	sgltransinit	:PTR /*void	(*MathIEEEResource_SglTransInit)()*/
	{extbasinit}	extbasinit	:PTR /*void	(*MathIEEEResource_ExtBasInit)()*/
	{exttransinit}	exttransinit	:PTR /*void	(*MathIEEEResource_ExtTransInit)()*/
ENDOBJECT

/* definations for MathIEEEResource_FLAGS */
NATIVE {MATHIEEERESOURCEF_DBLBAS}	CONST MATHIEEERESOURCEF_DBLBAS	= $1
NATIVE {MATHIEEERESOURCEF_DBLTRANS}	CONST MATHIEEERESOURCEF_DBLTRANS	= $2
NATIVE {MATHIEEERESOURCEF_SGLBAS}	CONST MATHIEEERESOURCEF_SGLBAS	= $4
NATIVE {MATHIEEERESOURCEF_SGLTRANS}	CONST MATHIEEERESOURCEF_SGLTRANS	= $8
NATIVE {MATHIEEERESOURCEF_EXTBAS}	CONST MATHIEEERESOURCEF_EXTBAS	= $10
NATIVE {MATHIEEERESOURCEF_EXTTRANS}	CONST MATHIEEERESOURCEF_EXTTRANS	= $20
