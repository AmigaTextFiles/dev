/* $VER: sghooks.h 38.1 (11.11.1991) */
OPT NATIVE
PUBLIC MODULE 'target/intuition/intuition_shared2'
MODULE 'target/exec/types'
MODULE 'target/graphics/text', 'target/utility/hooks', 'target/intuition/intuition', 'target/devices/inputevent', 'target/intuition/cghooks'
{#include <intuition/sghooks.h>}
NATIVE {INTUITION_SGHOOKS_H} CONST

->"OBJECT stringextend" is on-purposely missing from here (it can be found in 'intuition/intuition_shared2')

NATIVE {SGWork} OBJECT sgwork
    /* set up when gadget is first activated	*/
    {Gadget}	gadget	:PTR TO gadget	/* the contestant itself	*/
    {StringInfo}	stringinfo	:PTR TO stringinfo	/* easy access to sinfo		*/
    {WorkBuffer}	workbuffer	:ARRAY OF UBYTE	/* intuition's planned result	*/
    {PrevBuffer}	prevbuffer	:ARRAY OF UBYTE	/* what was there before	*/
    {Modes}	modes	:ULONG		/* current mode			*/

    /* modified for each input event	*/
    {IEvent}	ievent	:PTR TO inputevent	/* actual event: do not change	*/
    {Code}	code	:UINT		/* character code, if one byte	*/
    {BufferPos}	bufferpos	:INT	/* cursor position		*/
    {NumChars}	numchars	:INT
    {Actions}	actions	:ULONG	/* what Intuition will do	*/
    {LongInt}	longint	:VALUE	/* temp storage for longint	*/

    {GadgetInfo}	gadgetinfo	:PTR TO gadgetinfo	/* see cghooks.h		*/
    {EditOp}	editop	:UINT		/* from constants below		*/
ENDOBJECT

/* SGWork.EditOp -
 * These values indicate what basic type of operation the global
 * editing hook has performed on the string before your gadget's custom
 * editing hook gets called.  You do not have to be concerned with the
 * value your custom hook leaves in the EditOp field, only if you
 * write a global editing hook.
 *
 * For most of these general edit operations, you'll want to compare
 * the BufferPos and NumChars of the StringInfo (before global editing)
 * and SGWork (after global editing).
 */

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
/* please initialize StringInfo with in-range value of BufferPos
 * if you are using SGM_REPLACE mode.
 */

NATIVE {SGM_FIXEDFIELD}	CONST SGM_FIXEDFIELD	= $2	/* fixed length buffer		*/
					/* always set SGM_REPLACE, too	*/
NATIVE {SGM_NOFILTER}	CONST SGM_NOFILTER	= $4	/* don't filter control chars	*/

/* SGM_EXITHELP is new for V37, and ignored by V36: */
NATIVE {SGM_EXITHELP}	CONST SGM_EXITHELP	= $80	/* exit with code = 0x5F if HELP hit */


/* These Mode Flags are for internal use only				*/
NATIVE {SGM_NOCHANGE}	CONST SGM_NOCHANGE	= $8	/* no edit changes yet		*/
NATIVE {SGM_NOWORKB}	CONST SGM_NOWORKB	= $10	/* Buffer == PrevBuffer		*/
NATIVE {SGM_CONTROL}	CONST SGM_CONTROL	= $20	/* control char escape mode	*/
NATIVE {SGM_LONGINT}	CONST SGM_LONGINT	= $40	/* an intuition longint gadget	*/

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

/* Here's a brief summary of how the custom string gadget edit hook works:
 *	You provide a hook in StringInfo.Extension.EditHook.
 *	The hook is called in the standard way with the 'object'
 *	a pointer to SGWork, and the 'message' a pointer to a command
 *	block, starting either with (longword) SGH_KEY, SGH_CLICK,
 *	or something new.
 *
 *	You return 0 if you don't understand the command (SGH_KEY is
 *	required and assumed).	Return non-zero if you implement the
 *	command.
 *
 *   SGH_KEY:
 *	There are no parameters following the command longword.
 *
 *	Intuition will put its idea of proper values in the SGWork
 *	before calling you, and if you leave SGA_USE set in the
 *	SGWork.Actions field, Intuition will use the values
 *	found in SGWork fields WorkBuffer, NumChars, BufferPos,
 *	and LongInt, copying the WorkBuffer back to the StringInfo
 *	Buffer.
 *
 *	NOTE WELL: You may NOT change other SGWork fields.
 *
 *	If you clear SGA_USE, the string gadget will be unchanged.
 *
 *	If you set SGA_END, Intuition will terminate the activation
 *	of the string gadget.  If you also set SGA_REUSE, Intuition
 *	will reuse the input event after it deactivates your gadget.
 *
 *	In this case, Intuition will put the value found in SGWork.Code
 *	into the IntuiMessage.Code field of the IDCMP_GADGETUP message it
 *	sends to the application.
 *
 *	If you set SGA_BEEP, Intuition will call DisplayBeep(); use
 *	this if the user has typed in error, or buffer is full.
 *
 *	Set SGA_REDISPLAY if the changes to the gadget warrant a
 *	gadget redisplay.  Note: cursor movement requires a redisplay.
 *
 *	Starting in V37, you may set SGA_PREVACTIVE or SGA_NEXTACTIVE
 *	when you set SGA_END.  This tells Intuition that you want
 *	the next or previous gadget with GFLG_TABCYCLE to be activated.
 *
 *   SGH_CLICK:
 *	This hook command is called when Intuition wants to position
 *	the cursor in response to a mouse click in the string gadget.
 *
 *	Again, here are no parameters following the command longword.
 *
 *	This time, Intuition has already calculated the mouse position
 *	character cell and put it in SGWork.BufferPos.	The previous
 *	BufferPos value remains in the SGWork.StringInfo.BufferPos.
 *
 *	Intuition will again use the SGWork fields listed above for
 *	SGH_KEY.  One restriction is that you are NOT allowed to set
 *	SGA_END or SGA_REUSE for this command.	Intuition will not
 *	stand for a gadget which goes inactive when you click in it.
 *
 *	You should always leave the SGA_REDISPLAY flag set, since Intuition
 *	uses this processing when activating a string gadget.
 */
