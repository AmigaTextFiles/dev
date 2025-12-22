/* $VER: sghooks.h 38.1 (11.11.1991) */
OPT NATIVE
PUBLIC MODULE 'target/intuition/intuition_shared2'
MODULE 'target/exec/types'
MODULE 'target/graphics/text', 'target/utility/hooks', 'target/intuition/intuition', 'target/devices/inputevent', 'target/intuition/cghooks'
{MODULE 'intuition/sghooks'}

->"OBJECT stringextend" is on-purposely missing from here (it can be found in 'intuition/intuition_shared2')

NATIVE {sgwork} OBJECT sgwork
    /* set up when gadget is first activated	*/
    {gadget}	gadget	:PTR TO gadget	/* the contestant itself	*/
    {stringinfo}	stringinfo	:PTR TO stringinfo	/* easy access to sinfo		*/
    {workbuffer}	workbuffer	:ARRAY OF UBYTE	/* intuition's planned result	*/
    {prevbuffer}	prevbuffer	:ARRAY OF UBYTE	/* what was there before	*/
    {modes}	modes	:ULONG		/* current mode			*/

    /* modified for each input event	*/
    {ievent}	ievent	:PTR TO inputevent	/* actual event: do not change	*/
    {code}	code	:UINT		/* character code, if one byte	*/
    {bufferpos}	bufferpos	:INT	/* cursor position		*/
    {numchars}	numchars	:INT
    {actions}	actions	:ULONG	/* what Intuition will do	*/
    {longint}	longint	:VALUE	/* temp storage for longint	*/

    {gadgetinfo}	gadgetinfo	:PTR TO gadgetinfo	/* see cghooks.h		*/
    {editop}	editop	:UINT		/* from constants below		*/
ENDOBJECT

NATIVE {EO_NOOP}		CONST EO_NOOP		= ($0001)
	/* did nothing							*/
NATIVE {EO_DELBACKWARD}	CONST EO_DELBACKWARD	= ($0002)
	/* deleted some chars (maybe 0).				*/
NATIVE {EO_DELFORWARD}	CONST EO_DELFORWARD	= ($0003)
	/* deleted some characters under and in front of the cursor	*/
NATIVE {EO_MOVECURSOR}	CONST EO_MOVECURSOR	= ($0004)
	/* moved the cursor						*/
NATIVE {EO_ENTER}	CONST EO_ENTER	= ($0005)
	/* "enter" or "return" key, terminate				*/
NATIVE {EO_RESET}	CONST EO_RESET	= ($0006)
	/* current Intuition-style undo					*/
NATIVE {EO_REPLACECHAR}	CONST EO_REPLACECHAR	= ($0007)
	/* replaced one character and (maybe) advanced cursor		*/
NATIVE {EO_INSERTCHAR}	CONST EO_INSERTCHAR	= ($0008)
	/* inserted one char into string or added one at end		*/
NATIVE {EO_BADFORMAT}	CONST EO_BADFORMAT	= ($0009)
	/* didn't like the text data, e.g., Bad LONGINT			*/
NATIVE {EO_BIGCHANGE}	CONST EO_BIGCHANGE	= ($000A)	/* unused by Intuition	*/
	/* complete or major change to the text, e.g. new string	*/
NATIVE {EO_UNDO}		CONST EO_UNDO		= ($000B)	/* unused by Intuition	*/
	/* some other style of undo					*/
NATIVE {EO_CLEAR}	CONST EO_CLEAR	= ($000C)
	/* clear the string						*/
NATIVE {EO_SPECIAL}	CONST EO_SPECIAL	= ($000D)	/* unused by Intuition	*/
	/* some operation that doesn't fit into the categories here	*/


/* Mode Flags definitions (ONLY first group allowed as InitialModes)	*/
NATIVE {SGM_REPLACE}	CONST SGM_REPLACE	= $1	/* replace mode			*/

NATIVE {SGM_FIXEDFIELD}	CONST SGM_FIXEDFIELD	= $2	/* fixed length buffer		*/
					/* always set SGM_REPLACE, too	*/
NATIVE {SGM_NOFILTER}	CONST SGM_NOFILTER	= $4	/* don't filter control chars	*/

/* SGM_EXITHELP is new for V37, and ignored by V36: */
NATIVE {SGM_EXITHELP}	CONST SGM_EXITHELP	= $80	/* exit with code = 0x5F if HELP hit */


/* These Mode Flags are for internal use only				*/
CONST SGM_NOCHANGE	= $8	/* no edit changes yet		*/
CONST SGM_NOWORKB	= $10	/* Buffer == PrevBuffer		*/
CONST SGM_CONTROL	= $20	/* control char escape mode	*/
CONST SGM_LONGINT	= $40	/* an intuition longint gadget	*/

/* String Gadget Action Flags (put in SGWork.Actions by EditHook)	*/
NATIVE {SGA_USE}		CONST SGA_USE		= ($1)	/* use contents of SGWork		*/
NATIVE {SGA_END}		CONST SGA_END		= ($2)	/* terminate gadget, code in Code field	*/
NATIVE {SGA_BEEP}	CONST SGA_BEEP	= ($4)	/* flash the screen for the user	*/
NATIVE {SGA_REUSE}	CONST SGA_REUSE	= ($8)	/* reuse input event			*/
NATIVE {SGA_REDISPLAY}	CONST SGA_REDISPLAY	= ($10)	/* gadget visuals changed		*/

/* New for V37: */
NATIVE {SGA_NEXTACTIVE}	CONST SGA_NEXTACTIVE	= ($20)	/* Make next possible gadget active.	*/
NATIVE {SGA_PREVACTIVE}	CONST SGA_PREVACTIVE	= ($40)	/* Make previous possible gadget active.*/

/* function id for only existing custom string gadget edit hook	*/

NATIVE {SGH_KEY}		CONST SGH_KEY		= (1)	/* process editing keystroke		*/
NATIVE {SGH_CLICK}	CONST SGH_CLICK	= (2)	/* process mouse click cursor position	*/
