/* $Id: Scanner.c,v 2.16 1992/08/18 09:05:32 grosch rel $ */

# define bool		char
# define true		1
# define false		0
# define StdIn		0

$@ # include "@.h"
$@ # include "$Source.h"
# include "System.h"
# include "General.h"
# include "DynArray.h"
# include "Positions.h"
# include <stdio.h>

#  include <stdlib.h>

# define yyTabSpace	8

# define yyStart(State)	{ yyPreviousStart = yyStartState; yyStartState = State; }
# define yyPrevious	{ yyStateRange s = yyStartState; \
	 		yyStartState = yyPreviousStart; yyPreviousStart = s; }
$@ # define yyEcho		{ char * yyEnd = $_TokenPtr + $_TokenLength; \
			char yyCh = * yyEnd; * yyEnd = '\0'; \
$@ 	 		(void) fputs ($_TokenPtr, stdout); * yyEnd = yyCh; }
$@ # define yyLess(n)	{ yyChBufferIndex -= $_TokenLength - n; $_TokenLength = n; }
$@ # define yyTab		yyLineStart -= yyTabSpace - 1 - ((unsigned char *) $_TokenPtr - yyLineStart - 1) % yyTabSpace
$@ # define yyTab1(a)	yyLineStart -= yyTabSpace - 1 - ((unsigned char *) $_TokenPtr - yyLineStart + a - 1) % yyTabSpace
$@ # define yyTab2(a,b)	yyLineStart -= yyTabSpace - 1 - ((unsigned char *) $_TokenPtr - yyLineStart + a - 1) % yyTabSpace
# define yyEol(Column)	{ yyLineCount ++; yyLineStart = yyChBufferIndex - 1 - Column; }
# define output(c)	(void) putchar ((int) c)
# define unput(c)	* (-- yyChBufferIndex) = c

# define yyDNoState		0
# define yyFileStackSize	16
# define yyInitBufferSize	1024 * 8 + 256
$C constant declarations

static void yyExit (void) { Exit (1); }

typedef unsigned short	yyStateRange;
typedef struct { yyStateRange yyCheck, yyNext; } yyCombType;

$@ 	char *		$_TokenPtr	;
$@ 	short		$_TokenLength	;
$@ 	$_tScanAttribute	$_Attribute	;
$@ 	void		(* @_Exit) (void) = yyExit;

static	yyCombType	yyComb		[yyTableSize   + 1] = {{1, 0},
$T
};
static	yyCombType *	yyBasePtr	[yyDStateCount + 1] = {& yyComb [0],
$B
};
static	yyStateRange	yyDefault	[yyDStateCount + 1] = {0,
$U
};
static	yyStateRange	yyEobTrans	[yyDStateCount + 1] = {0,
$R
};
$M static short		yyAction	[yyDStateCount + 1] = {0,
$Q
$M };

static	yyStateRange	yyInitStateStack [yyInitBufferSize] = {0};
static	yyStateRange *	yyStateStack	= yyInitStateStack;
static	unsigned long	yyStateStackSize= yyInitBufferSize;
static	yyStateRange	yyStartState	= 0;
static	yyStateRange	yyPreviousStart	= 1;

static  short		yySourceFile	;
static	bool		yyEof		;
static	unsigned char *	yyChBufferPtr	;
static	unsigned char *	yyChBufferStart	;
static	unsigned long	yyChBufferSize	;
static	unsigned char *	yyChBufferIndex	= ((unsigned char *) yyComb) + 2; /* dirty trick */
static	int		yyBytesRead	;
static	int		yyLineCount	;
static	unsigned char *	yyLineStart	;

static	struct {
	short		yySourceFile	;
	bool		yyEof		;
	unsigned char *	yyChBufferPtr	;
	unsigned char *	yyChBufferStart	;
	unsigned long	yyChBufferSize	;
	unsigned char *	yyChBufferIndex	;
	int		yyBytesRead	;
	int		yyLineCount	;
	unsigned char *	yyLineStart	;
	} yyFileStack [yyFileStackSize + 1], * yyFileStackPtr = yyFileStack;

static	char	yyToLower	[] = {
'\0', '\1', '\2', '\3', '\4', '\5', '\6', '\7',
'\10', '\11', '\12', '\13', '\14', '\15', '\16', '\17',
'\20', '\21', '\22', '\23', '\24', '\25', '\26', '\27',
'\30', '\31', '\32', '\33', '\34', '\35', '\36', '\37',
' ', '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',', '-', '.', '/',
'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?',
'@', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '[', '\\', ']', '^', '_',
'`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', '\177',
'\200', '\201', '\202', '\203', '\204', '\205', '\206', '\207',
'\210', '\211', '\212', '\213', '\214', '\215', '\216', '\217',
'\220', '\221', '\222', '\223', '\224', '\225', '\226', '\227',
'\230', '\231', '\232', '\233', '\234', '\235', '\236', '\237',
'\240', '\241', '\242', '\243', '\244', '\245', '\246', '\247',
'\250', '\251', '\252', '\253', '\254', '\255', '\256', '\257',
'\260', '\261', '\262', '\263', '\264', '\265', '\266', '\267',
'\270', '\271', '\272', '\273', '\274', '\275', '\276', '\277',
'\300', '\301', '\302', '\303', '\304', '\305', '\306', '\307',
'\310', '\311', '\312', '\313', '\314', '\315', '\316', '\317',
'\320', '\321', '\322', '\323', '\324', '\325', '\326', '\327',
'\330', '\331', '\332', '\333', '\334', '\335', '\336', '\337',
'\340', '\341', '\342', '\343', '\344', '\345', '\346', '\347',
'\350', '\351', '\352', '\353', '\354', '\355', '\356', '\357',
'\360', '\361', '\362', '\363', '\364', '\365', '\366', '\367',
'\370', '\371', '\372', '\373', '\374', '\375', '\376', '\377',
};

static	char	yyToUpper	[] = {
'\0', '\1', '\2', '\3', '\4', '\5', '\6', '\7',
'\10', '\11', '\12', '\13', '\14', '\15', '\16', '\17',
'\20', '\21', '\22', '\23', '\24', '\25', '\26', '\27',
'\30', '\31', '\32', '\33', '\34', '\35', '\36', '\37',
' ', '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',', '-', '.', '/',
'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?',
'@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '\\', ']', '^', '_',
'`', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '{', '|', '}', '~', '\177',
'\200', '\201', '\202', '\203', '\204', '\205', '\206', '\207',
'\210', '\211', '\212', '\213', '\214', '\215', '\216', '\217',
'\220', '\221', '\222', '\223', '\224', '\225', '\226', '\227',
'\230', '\231', '\232', '\233', '\234', '\235', '\236', '\237',
'\240', '\241', '\242', '\243', '\244', '\245', '\246', '\247',
'\250', '\251', '\252', '\253', '\254', '\255', '\256', '\257',
'\260', '\261', '\262', '\263', '\264', '\265', '\266', '\267',
'\270', '\271', '\272', '\273', '\274', '\275', '\276', '\277',
'\300', '\301', '\302', '\303', '\304', '\305', '\306', '\307',
'\310', '\311', '\312', '\313', '\314', '\315', '\316', '\317',
'\320', '\321', '\322', '\323', '\324', '\325', '\326', '\327',
'\330', '\331', '\332', '\333', '\334', '\335', '\336', '\337',
'\340', '\341', '\342', '\343', '\344', '\345', '\346', '\347',
'\350', '\351', '\352', '\353', '\354', '\355', '\356', '\357',
'\360', '\361', '\362', '\363', '\364', '\365', '\366', '\367',
'\370', '\371', '\372', '\373', '\374', '\375', '\376', '\377',
};

static	void	yyInitialize	(void);
static	void	yyErrorMessage	(int yyErrorCode);
static	char	input		(void);
$G global user declarations

$@ int $_GetToken (void)
{
   register	yyStateRange	yyState;
   register	yyStateRange *	yyStatePtr;
   register	unsigned char * yyChBufferIndexReg;
   register	yyCombType * *	yyBasePtrReg = yyBasePtr;
$L local user declarations and actions

yyBegin:
   yyState		= yyStartState;		/* initialize */
   yyStatePtr		= & yyStateStack [1];
   yyChBufferIndexReg 	= yyChBufferIndex;
$@    $_TokenPtr	 	= (char *) yyChBufferIndexReg;
$J if (yyChBufferIndexReg [-1] == yyEolCh) yyState ++;

   /* ASSERT yyChBuffer [yyChBufferIndex] == first character */

yyContinue:		/* continue after sentinel or skipping blanks */
   for (;;) {		/* execute as many state transitions as possible */
					/* determine next state and get next character */
      register yyCombType * yyTablePtr = (yyBasePtrReg [yyState] + * yyChBufferIndexReg ++);
      if (yyTablePtr->yyCheck == yyState) {
	 yyState = yyTablePtr->yyNext;
	 * yyStatePtr ++ = yyState;		/* push state */
	 goto yyContinue;
      }
      yyChBufferIndexReg --;			/* reconsider character */
      if ((yyState = yyDefault [yyState]) == yyDNoState) break;
   }

   for (;;) {					/* search for last final state */
$@       $_TokenLength = yyChBufferIndexReg - (unsigned char *) $_TokenPtr;
      yyChBufferIndex = yyChBufferIndexReg;
$A switch header and user actions	/* switch (* -- yyStatePtr) {	/* pop state */
$N non final states
	 /* non final states */
	 yyChBufferIndexReg --;			/* return character */
	 break;

$P    case yyDefaultState:
$@ 	 $_Attribute.Position.Line   = yyLineCount;
$@ 	 $_Attribute.Position.Column = yyChBufferIndexReg - yyLineStart;
$@       /* $_TokenLength   = 1; */
	 yyChBufferIndex = ++ yyChBufferIndexReg;
	 {
$D default action
	 }
	 goto yyBegin;

      case yyDNoState:				/* automatic initialization */
	 yyInitialize ();
	 yySourceFile = StdIn;
	 goto yyBegin;

$O    case yyEobState:				/* end of buffer sentinel found */
	 yyChBufferIndex = -- yyChBufferIndexReg; /* undo last state transition */
$@ 	 if (-- $_TokenLength == 0) {		/* get previous state */
	    yyState = yyStartState;
$J	    if (yyChBufferIndexReg [-1] == yyEolCh) yyState ++;
	 } else {
	    yyState = * (yyStatePtr - 1);
	 }

	 if (yyChBufferIndex != & yyChBufferStart [yyBytesRead]) {
						/* end of buffer sentinel in buffer */
	    if ((yyState = yyEobTrans [yyState]) == yyDNoState) continue;
	    yyChBufferIndexReg ++;
	    * yyStatePtr ++ = yyState;		/* push state */
	    goto yyContinue;
	 }
						/* end of buffer reached */
	 {  /* copy initial part of token in front of the input buffer */
$@ 	    register char * yySource = $_TokenPtr;
$@ 	    register char * yyTarget = $_TokenPtr = (char *) & yyChBufferPtr [yyMaxAlign - $_TokenLength % yyMaxAlign];
	    if (yySource != yyTarget) {
	       while (yySource < (char *) yyChBufferIndexReg) * yyTarget ++ = * yySource ++;
	       yyLineStart += (unsigned char *) yyTarget - yyChBufferStart - yyBytesRead;
	       yyChBufferStart = (unsigned char *) yyTarget;
	    } else {
	       yyChBufferStart = yyChBufferIndexReg;
	    }
	 }

	 if (! yyEof) {				/* read buffer and restart */
$@ 	    int yyChBufferFree = (int) Exp2 (Log2 (yyChBufferSize - 4 - yyMaxAlign - $_TokenLength));
	    if (yyChBufferFree < yyChBufferSize / 8) {
	       register int yyDelta;
	       register unsigned char * yyOldChBufferPtr = yyChBufferPtr;
	       ExtendArray ((char * *) & yyChBufferPtr, & yyChBufferSize, sizeof (char));
	       if (yyChBufferPtr == NULL) yyErrorMessage (1);
	       yyDelta = yyChBufferPtr - yyOldChBufferPtr;
	       yyChBufferStart	+= yyDelta;
	       yyLineStart	+= yyDelta;
$@ 	       $_TokenPtr	+= yyDelta;
$@ 	       yyChBufferFree = (int) Exp2 (Log2 (yyChBufferSize - 4 - yyMaxAlign - $_TokenLength));
	       if (yyStateStackSize < yyChBufferSize) {
		  yyStateRange * yyOldStateStack = yyStateStack;
		  ExtendArray ((char * *) & yyStateStack, & yyStateStackSize, sizeof (yyStateRange));
		  if (yyStateStack == NULL) yyErrorMessage (1);
		  yyStatePtr	+= yyStateStack - yyOldStateStack;
	       }
	    }
	    yyChBufferIndex = yyChBufferIndexReg = yyChBufferStart;
$@ 	    yyBytesRead = $_GetLine (yySourceFile, (char *) yyChBufferIndex, yyChBufferFree);
	    if (yyBytesRead <= 0) { yyBytesRead = 0; yyEof = true; }
	    yyChBufferStart [yyBytesRead    ] = yyEobCh;
	    yyChBufferStart [yyBytesRead + 1] = '\0';
	    goto yyContinue;
	 }

$@ 	 if ($_TokenLength == 0) {		/* end of file reached */
$@ 	    $_Attribute.Position.Line   = yyLineCount;
$@ 	    $_Attribute.Position.Column = yyChBufferIndexReg - yyLineStart;
$@ 	    $_CloseFile ();
	    if (yyFileStackPtr == yyFileStack) {
$E eof action
	    }
$@ 	    if (yyFileStackPtr == yyFileStack) return $_EofToken;
	    goto yyBegin;
	 }
	 break;

      default:
	 yyErrorMessage (0);
      }
   }
}

$@ void $_BeginFile(char * yyFileName)
   {
      yyInitialize ();
$@       yySourceFile = $_BeginSource (yyFileName);
   }

static void yyInitialize (void)
   {
      if (yyFileStackPtr >= yyFileStack + yyFileStackSize) yyErrorMessage (2);
      yyFileStackPtr ++;			/* push file */
      yyFileStackPtr->yySourceFile	= yySourceFile		;
      yyFileStackPtr->yyEof		= yyEof			;
      yyFileStackPtr->yyChBufferPtr	= yyChBufferPtr		;
      yyFileStackPtr->yyChBufferStart	= yyChBufferStart	;
      yyFileStackPtr->yyChBufferSize	= yyChBufferSize	;
      yyFileStackPtr->yyChBufferIndex	= yyChBufferIndex	;
      yyFileStackPtr->yyBytesRead	= yyBytesRead		;
      yyFileStackPtr->yyLineCount	= yyLineCount		;
      yyFileStackPtr->yyLineStart	= yyLineStart		;
						/* initialize file state */
      yyChBufferSize	   = yyInitBufferSize;
      MakeArray ((char * *) & yyChBufferPtr, & yyChBufferSize, sizeof (char));
      if (yyChBufferPtr == NULL) yyErrorMessage (1);
      yyChBufferStart	   = & yyChBufferPtr [yyMaxAlign];
      yyChBufferStart [-1] = yyEolCh;		/* begin of line indicator */
      yyChBufferStart [ 0] = yyEobCh;		/* end of buffer sentinel */
      yyChBufferStart [ 1] = '\0';
      yyChBufferIndex	   = yyChBufferStart;
      yyEof		   = false;
      yyBytesRead	   = 0;
      yyLineCount	   = 1;
      yyLineStart	   = & yyChBufferStart [-1];
      if (yyStartState == 0) {
	 yyStartState	   = STD;
	 yyStateStack [0]  = yyDefaultState;	/* stack underflow sentinel */
      }
   }

$@ void $_CloseFile (void)
   {
      if (yyFileStackPtr == yyFileStack) yyErrorMessage (3);
$@       $_CloseSource (yySourceFile);
      ReleaseArray ((char * *) & yyChBufferPtr, & yyChBufferSize, sizeof (char));
						/* pop file */
      yySourceFile	= yyFileStackPtr->yySourceFile		;
      yyEof		= yyFileStackPtr->yyEof			;
      yyChBufferPtr	= yyFileStackPtr->yyChBufferPtr		;
      yyChBufferStart	= yyFileStackPtr->yyChBufferStart	;
      yyChBufferSize	= yyFileStackPtr->yyChBufferSize	;
      yyChBufferIndex	= yyFileStackPtr->yyChBufferIndex	;
      yyBytesRead	= yyFileStackPtr->yyBytesRead		;
      yyLineCount	= yyFileStackPtr->yyLineCount		;
      yyLineStart	= yyFileStackPtr->yyLineStart		;
      yyFileStackPtr --;
   }

$@ int $_GetWord(char * yyWord)
   {
$@       register char * yySource			= $_TokenPtr;
      register char * yyTarget			= yyWord;
      register char * yyChBufferIndexReg	= (char *) yyChBufferIndex;

      do {				/* ASSERT word is not empty */
	 * yyTarget ++ = * yySource ++;
      } while (yySource < yyChBufferIndexReg);
      * yyTarget = '\0';
$@       return yyChBufferIndexReg - $_TokenPtr;
   }

$@ int $_GetLower(char * yyWord)
   {
$@       register char * yySource			= $_TokenPtr;
      register char * yyTarget			= yyWord;
      register char * yyChBufferIndexReg	= (char *) yyChBufferIndex;

      do {				/* ASSERT word is not empty */
	 * yyTarget ++ = yyToLower [* yySource ++];
      } while (yySource < yyChBufferIndexReg);
      * yyTarget = '\0';
$@       return yyChBufferIndexReg - $_TokenPtr;
   }

$@ int $_GetUpper(char * yyWord)
   {
$@       register char * yySource			= $_TokenPtr;
      register char * yyTarget			= yyWord;
      register char * yyChBufferIndexReg	= (char *) yyChBufferIndex;

      do {				/* ASSERT word is not empty */
	 * yyTarget ++ = yyToUpper [* yySource ++];
      } while (yySource < yyChBufferIndexReg);
      * yyTarget = '\0';
$@       return yyChBufferIndexReg - $_TokenPtr;
   }

static char input (void)
   {
      if (yyChBufferIndex == & yyChBufferStart [yyBytesRead]) {
	 if (! yyEof) {
	    yyLineStart -= yyBytesRead;
	    yyChBufferIndex = yyChBufferStart = yyChBufferPtr;
$@ 	    yyBytesRead = $_GetLine (yySourceFile, (char *) yyChBufferIndex,
	       (int) Exp2 (Log2 (yyChBufferSize)));
	    if (yyBytesRead <= 0) { yyBytesRead = 0; yyEof = true; }
	    yyChBufferStart [yyBytesRead    ] = yyEobCh;
	    yyChBufferStart [yyBytesRead + 1] = '\0';
	 }
      }
      if (yyChBufferIndex == & yyChBufferStart [yyBytesRead]) return '\0';
      else return((char)(*yyChBufferIndex++));
   }

$@ void $_BeginScanner (void)
   {
$I user initialization code
   }

$@ void $_CloseScanner (void)
   {
$F user finalization code
   }

static void yyErrorMessage(int yyErrorCode)
   {
$@       WritePosition (stderr, $_Attribute.Position);
      switch (yyErrorCode) {
$@       case 0: (void) fprintf (stderr, ": @: internal error\n"); break;
$@       case 1: (void) fprintf (stderr, ": @: out of memory\n"); break;
$@       case 2: (void) fprintf (stderr, ": @: too many nested include files\n"); break;
$@       case 3: (void) fprintf (stderr, ": @: file stack underflow (too many calls of $_CloseFile)\n"); break;
      }
$@      (*@_Exit)();
   }
