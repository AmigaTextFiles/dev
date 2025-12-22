/* $Id: Parser.c,v 2.9 1992/08/07 15:28:42 grosch rel $ */

# define bool		char
# define true		1
# define false		0

$@ # include "@.h"
# include "Errors.h"

# ifdef __cplusplus
extern "C" {
#    include "Memory.h"
#    include "DynArray.h"
#    include "Sets.h"
#    ifndef BCOPY
#       include <memory.h>
#    endif
}
# else
#    include "Memory.h"
#    include "DynArray.h"
#    include "Sets.h"
#    ifndef BCOPY
#       include <memory.h>
#    endif
# endif

# if defined __STDC__ | defined __cplusplus
# define ARGS(parameters)	parameters
# else
# define ARGS(parameters)	()
# endif

# ifdef lex_interface
$@ #    define $_GetToken	yylex
     extern int yylex ();
#    ifndef AttributeDef
#	include "Positions.h"
$@         typedef struct { tPosition Position; } $_tScanAttribute;
$@         static	$_tScanAttribute	$_Attribute = {{ 0, 0 }};
#    endif
#    ifndef ErrorAttributeDef
$@ #	define $_ErrorAttribute(Token, RepairAttribute)
#    endif
#    ifndef yyGetAttribute
#	define yyGetAttribute(yyAttrStackPtr, Attribute) * yyAttrStackPtr = yylval
#    endif
# else
$@ #    include "$.h"
#    ifndef yyGetAttribute
#	define yyGetAttribute(yyAttrStackPtr, Attribute) (yyAttrStackPtr)->Scan = Attribute
#    endif
# endif

$G	/* GLOBAL section is inserted here */

# if defined lex_interface & ! defined yylvalDef
     tParsAttribute yylval;
# endif

# ifndef yyInitStackSize
#    define yyInitStackSize	100
# endif
# define yyNoState		0

$T	/* table constants are inserted here */

# define yyFirstFinalState	yyFirstReadTermState

typedef unsigned short	yyStateRange	;
typedef unsigned short	yySymbolRange	;
typedef struct	{ yyStateRange Check, Next; } yyTCombType ;

$@ 	char *		@_TokenName	[yyLastTerminal + 1] = {
$W	/* token names are inserted here */
};
static	yyTCombType	yyTComb		[yyTableMax + 1] = {
$M
};
static	unsigned short	yyNComb		[yyNTableMax - yyLastTerminal] = {
$N
};
static	yyTCombType *	yyTBasePtr	[yyLastReadState + 1] = {
$P
};
static	unsigned short*	yyNBasePtr	[yyLastReadState + 1] = {
$Q
};
static	unsigned short	yyDefault	[yyLastReadState + 1] = {
$D
};
static	unsigned char	yyLength	[yyLastReduceState - yyFirstReduceState + 1] = {
$K
};
static	yySymbolRange	yyLeftHandSide	[yyLastReduceState - yyFirstReduceState + 1] = {
$H
};
static	yySymbolRange	yyContinuation	[yyLastReadState + 1] = {
$O
};
static	unsigned short	yyFinalToProd	[yyLastReadNontermState - yyFirstReadTermState + 1] = {
$F
};

static	void	yyErrorRecovery		ARGS((yySymbolRange * yyTerminal, yyStateRange * yyStateStack, unsigned long yyStackSize, short yyStackPtr));
static	void	yyComputeContinuation	ARGS((yyStateRange * yyStack, unsigned long yyStackSize, short yyStackPtr, tSet * yyContinueSet));
static	bool	yyIsContinuation	ARGS((yySymbolRange yyTerminal, yyStateRange * yyStateStack, unsigned long yyStackSize, short yyStackPtr));
static	void	yyComputeRestartPoints	ARGS((yyStateRange * yyStateStack, unsigned long yyStackSize, short yyStackPtr, tSet * yyRestartSet));
static	yyStateRange yyNext		ARGS((yyStateRange yyState, yySymbolRange yySymbol));
$@ static	void	Begin@		();

$@ int @ ()
   {
      register	yyStateRange	yyState		;
      register	long		yyTerminal	;
      register	yyStateRange *	yyStateStackPtr ;
      register	tParsAttribute *yyAttrStackPtr	;
      register	bool		yyIsRepairing	;
		unsigned long	yyStateStackSize= yyInitStackSize;
		unsigned long	yyAttrStackSize = yyInitStackSize;
		yyStateRange *	yyStateStack	;
		tParsAttribute* yyAttributeStack;
		tParsAttribute	yySynAttribute	;	/* synthesized attribute */
      register	yyStateRange *	yyEndOfStack	;
		int		yyErrorCount	= 0;
   
$L	/* LOCAL section is inserted here */

$@       Begin@ ();
      yyState		= yyStartState;
$@       yyTerminal	= $_GetToken ();
      MakeArray ((char * *) & yyStateStack, & yyStateStackSize, sizeof (yyStateRange));
      MakeArray ((char * *) & yyAttributeStack, & yyAttrStackSize, sizeof (tParsAttribute));
      yyEndOfStack	= & yyStateStack [yyStateStackSize];
      yyStateStackPtr	= yyStateStack;
      yyAttrStackPtr	= yyAttributeStack;
      yyIsRepairing	= false;

   ParseLoop:
      for (;;) {
	 if (yyStateStackPtr >= yyEndOfStack) {
	    int yyyStateStackPtr= yyStateStackPtr - yyStateStack;
	    int yyyAttrStackPtr	= yyAttrStackPtr - yyAttributeStack;
	    ExtendArray ((char * *) & yyStateStack, & yyStateStackSize, sizeof (yyStateRange));
	    ExtendArray ((char * *) & yyAttributeStack, & yyAttrStackSize, sizeof (tParsAttribute));
	    yyStateStackPtr	= yyStateStack + yyyStateStackPtr;
	    yyAttrStackPtr	= yyAttributeStack + yyyAttrStackPtr;
	    yyEndOfStack	= & yyStateStack [yyStateStackSize];
	 }
	 * yyStateStackPtr = yyState;

   TermTrans:
	 for (;;) {	/* SPEC State = Next (State, Terminal); terminal transition */
	    register short * yyTCombPtr;

	    yyTCombPtr = (short *) (yyTBasePtr [yyState] + yyTerminal);
	    if (* yyTCombPtr ++ == yyState) { yyState = * yyTCombPtr; break; }
	    if ((yyState = yyDefault [yyState]) != yyNoState) goto TermTrans;

							/* syntax error */
	    if (! yyIsRepairing) {			/* report and recover */
	       yySymbolRange yyyTerminal = yyTerminal;

	       yyErrorCount ++;
	       yyErrorRecovery (& yyyTerminal, yyStateStack, yyStateStackSize, yyStateStackPtr - yyStateStack);
	       yyTerminal = yyyTerminal;
	       yyIsRepairing = true;
	    }
	    yyState = * yyStateStackPtr;
	    for (;;) {
	       if (yyNext (yyState, (yySymbolRange) yyTerminal) == yyNoState) { /* repair */
		  yySymbolRange		yyRepairToken;
$@ 		  $_tScanAttribute	yyRepairAttribute;
	    
		  yyRepairToken = yyContinuation [yyState];
		  yyState = yyNext (yyState, yyRepairToken);
		  if (yyState <= yyLastReadTermState) { /* read or read terminal reduce ? */
$@ 		     $_ErrorAttribute ((int) yyRepairToken, & yyRepairAttribute);
$@ 		     ErrorMessageI (xxTokenInserted, xxRepair, $_Attribute.Position,
$@ 			xxString, @_TokenName [yyRepairToken]);
		     if (yyState >= yyFirstFinalState) {	/* avoid second push */
			yyState = yyFinalToProd [yyState - yyFirstReadTermState];
		     }
		     yyGetAttribute (yyAttrStackPtr ++, yyRepairAttribute);
		     * ++ yyStateStackPtr = yyState;
		  }
		  if (yyState >= yyFirstFinalState) goto Final; /* final state ? */
	       } else {
		  yyState = yyNext (yyState, (yySymbolRange) yyTerminal);
		  goto Final;
	       }
	    }
	 }

   Final:
	 if (yyState >= yyFirstFinalState) {		/* final state ? */
	    if (yyState <= yyLastReadTermState) {	/* read terminal reduce ? */
	       yyStateStackPtr ++;
$@ 	       yyGetAttribute (yyAttrStackPtr ++, $_Attribute);
$@ 	       yyTerminal = $_GetToken ();
	       yyIsRepairing = false;
$X	       yyState = yyFinalToProd [yyState - yyFirstReadTermState];
	    }

	    for (;;) {
	       /* register long yyNonterminal;		/* left-hand side */
# define yyNonterminal yyState

$R	/* Code for Reductions is inserted here */

	       /* SPEC State = Next (Top (), Nonterminal); nonterminal transition */
	       yyState = * (yyNBasePtr [* yyStateStackPtr ++] + yyNonterminal);
	       * yyAttrStackPtr ++ = yySynAttribute;
	       if (yyState < yyFirstFinalState) goto ParseLoop; /* read nonterminal reduce ? */
$X	       yyState = yyFinalToProd [yyState - yyFirstReadTermState];
	    } 

	 } else {					/* read */
	    yyStateStackPtr ++;
$@ 	    yyGetAttribute (yyAttrStackPtr ++, $_Attribute);
$@ 	    yyTerminal = $_GetToken ();
	    yyIsRepairing = false;
	 }
      }
   }

static void yyErrorRecovery
# if defined __STDC__ | defined __cplusplus
   (yySymbolRange * yyTerminal, yyStateRange * yyStateStack, unsigned long yyStackSize, short yyStackPtr)
# else
   (yyTerminal, yyStateStack, yyStackSize, yyStackPtr)
   yySymbolRange *	yyTerminal	;
   yyStateRange *	yyStateStack	;
   unsigned long	yyStackSize	;
   short		yyStackPtr	;
# endif
   {
      bool	yyTokensSkipped	;
      tSet	yyContinueSet	;
      tSet	yyRestartSet	;
      int	yyLength = 0	;
      char	yyContinueString [256];

   /* 1. report an error */
$@       ErrorMessage (xxSyntaxError, xxError, $_Attribute.Position);

   /* 2. report the set of expected terminal symbols */
      MakeSet (& yyContinueSet, (short) yyLastTerminal);
      yyComputeContinuation (yyStateStack, yyStackSize, yyStackPtr, & yyContinueSet);
      yyContinueString [0] = '\0';
      while (! IsEmpty (& yyContinueSet)) {
$@ 	 char * yyTokenString = @_TokenName [Extract (& yyContinueSet)];
	 if ((yyLength += strlen (yyTokenString) + 1) >= 256) break;
	 (void) strcat (yyContinueString, yyTokenString);
	 (void) strcat (yyContinueString, " ");
      }
$@       ErrorMessageI (xxExpectedTokens, xxInformation, $_Attribute.Position,
	 xxString, yyContinueString);
      ReleaseSet (& yyContinueSet);

   /* 3. compute the set of terminal symbols for restart of the parse */
      MakeSet (& yyRestartSet, (short) yyLastTerminal);
      yyComputeRestartPoints (yyStateStack, yyStackSize, yyStackPtr, & yyRestartSet);

   /* 4. skip terminal symbols until a restart point is reached */
      yyTokensSkipped = false;
      while (! IsElement (* yyTerminal, & yyRestartSet)) {
$@ 	 * yyTerminal = $_GetToken ();
	 yyTokensSkipped = true;
      }
      ReleaseSet (& yyRestartSet);

   /* 5. report the restart point */
      if (yyTokensSkipped) {
$@ 	 ErrorMessage (xxRestartPoint, xxInformation, $_Attribute.Position);
      }
   }

/*
   compute the set of terminal symbols that can be accepted (read)
   in a given stack configuration (eventually after reduce actions)
*/

static void yyComputeContinuation
# if defined __STDC__ | defined __cplusplus
   (yyStateRange * yyStack, unsigned long yyStackSize, short yyStackPtr, tSet * yyContinueSet)
# else
   (yyStack, yyStackSize, yyStackPtr, yyContinueSet)
   yyStateRange *	yyStack		;
   unsigned long	yyStackSize	;
   short		yyStackPtr	;
   tSet *		yyContinueSet	;
# endif
   {
      register yySymbolRange	yyTerminal;
      register yyStateRange	yyState = yyStack [yyStackPtr];

      AssignEmpty (yyContinueSet);
      for (yyTerminal = yyFirstTerminal; yyTerminal <= yyLastTerminal; yyTerminal ++) {
	 if (yyNext (yyState, yyTerminal) != yyNoState &&
	    yyIsContinuation (yyTerminal, yyStack, yyStackSize, yyStackPtr)) {
	    Include (yyContinueSet, (short) yyTerminal);
	 }
      }
   }

/*
   check whether a given terminal symbol can be accepted (read)
   in a certain stack configuration (eventually after reduce actions)
*/

static bool yyIsContinuation
# if defined __STDC__ | defined __cplusplus
   (yySymbolRange yyTerminal, yyStateRange * yyStateStack, unsigned long yyStackSize, short yyStackPtr)
# else
   (yyTerminal, yyStateStack, yyStackSize, yyStackPtr)
   yySymbolRange	yyTerminal	;
   yyStateRange *	yyStateStack	;
   unsigned long	yyStackSize	;
   short		yyStackPtr	;
# endif
   {
      register yyStateRange	yState		;
      register yySymbolRange	yyNonterminal	;
	       yyStateRange *	yyStack		;
   
      MakeArray ((char * *) & yyStack, & yyStackSize, sizeof (yyStateRange));	/* pass Stack by value */
# ifdef BCOPY
      bcopy ((char *) yyStateStack, (char *) yyStack, (int) sizeof (yyStateRange) * (yyStackPtr + 1));
# else
      (void) memcpy ((char *) yyStack, (char *) yyStateStack, (int) sizeof (yyStateRange) * (yyStackPtr + 1));
# endif

      yState = yyStack [yyStackPtr];
      for (;;) {
	 yyStack [yyStackPtr] = yState;
	 yState = yyNext (yState, yyTerminal);
	 if (yState == yyNoState) {
	    ReleaseArray ((char * *) & yyStack, & yyStackSize, sizeof (yyStateRange));
	    return false;
	 }
	 if (yState <= yyLastReadTermState) {		/* read or read terminal reduce ? */
	    ReleaseArray ((char * *) & yyStack, & yyStackSize, sizeof (yyStateRange));
	    return true;
	 }

	 for (;;) {					/* reduce */
	    if (yState == yyStopState) {
	       ReleaseArray ((char * *) & yyStack, & yyStackSize, sizeof (yyStateRange));
	       return true;
	    } else { 
	       yyStackPtr -= yyLength [yState - yyFirstReduceState];
	       yyNonterminal = yyLeftHandSide [yState - yyFirstReduceState];
	    }

	    yState = yyNext (yyStack [yyStackPtr], yyNonterminal);
	    if (yyStackPtr >= yyStackSize) {
	       ExtendArray ((char * *) & yyStack, & yyStackSize, sizeof (yyStateRange));
	    }
	    yyStackPtr ++;
	    if (yState < yyFirstFinalState) break;	/* read nonterminal ? */
	    yState = yyFinalToProd [yState - yyFirstReadTermState];	/* read nonterminal reduce */
	 }
      }
   }

/*
   compute a set of terminal symbols that can be used to restart
   parsing in a given stack configuration. we simulate parsing until
   end of file using a suffix program synthesized by the function
   Continuation. All symbols acceptable in the states reached during
   the simulation can be used to restart parsing.
*/

static void yyComputeRestartPoints
# if defined __STDC__ | defined __cplusplus
   (yyStateRange * yyStateStack, unsigned long yyStackSize, short yyStackPtr, tSet * yyRestartSet)
# else
   (yyStateStack, yyStackSize, yyStackPtr, yyRestartSet)
   yyStateRange *	yyStateStack	;
   unsigned long	yyStackSize	;
   short		yyStackPtr	;
   tSet *		yyRestartSet	;
# endif
   {
      register yyStateRange	yState		;
      register yySymbolRange	yyNonterminal	;
	       yyStateRange *	yyStack		;
	       tSet		yyContinueSet	;
   
      MakeArray ((char * *) & yyStack, & yyStackSize, sizeof (yyStateRange)); /* pass Stack by value */
# ifdef BCOPY
      bcopy ((char *) yyStateStack, (char *) yyStack, (int) sizeof (yyStateRange) * (yyStackPtr + 1));
# else
      (void) memcpy ((char *) yyStack, (char *) yyStateStack, (int) sizeof (yyStateRange) * (yyStackPtr + 1));
# endif

      MakeSet (& yyContinueSet, (short) yyLastTerminal);
      AssignEmpty (yyRestartSet);
      yState = yyStack [yyStackPtr];

      for (;;) {
	 if (yyStackPtr >= yyStackSize) {
	    ExtendArray ((char * *) & yyStack, & yyStackSize, sizeof (yyStateRange));
	 }
	 yyStack [yyStackPtr] = yState;
	 yyComputeContinuation (yyStack, yyStackSize, yyStackPtr, & yyContinueSet);
	 Union (yyRestartSet, & yyContinueSet);
	 yState = yyNext (yState, yyContinuation [yState]);

	 if (yState >= yyFirstFinalState) {		/* final state ? */
	    if (yState <= yyLastReadTermState) {	/* read terminal reduce ? */
	       yyStackPtr ++;
	       yState = yyFinalToProd [yState - yyFirstReadTermState];
	    }

	    for (;;) {					/* reduce */
	       if (yState == yyStopState) {
		  ReleaseSet (& yyContinueSet);
		  ReleaseArray ((char * *) & yyStack, & yyStackSize, sizeof (yyStateRange));
		  return;
	       } else { 
		  yyStackPtr -= yyLength [yState - yyFirstReduceState];
		  yyNonterminal = yyLeftHandSide [yState - yyFirstReduceState];
	       }

	       yState = yyNext (yyStack [yyStackPtr], yyNonterminal);
	       yyStackPtr ++;
	       if (yState < yyFirstFinalState) break;	/* read nonterminal ? */
	       yState = yyFinalToProd [yState - yyFirstReadTermState]; /* read nonterminal reduce */
	    }
	 } else {					/* read */
	    yyStackPtr ++;
	 }
      }
   }

/* access the parse table:   Next : State x Symbol -> Action */

static yyStateRange yyNext
# if defined __STDC__ | defined __cplusplus
   (yyStateRange yyState, yySymbolRange yySymbol)
# else
   (yyState, yySymbol) yyStateRange yyState; yySymbolRange yySymbol;
# endif
   {
      register yyTCombType * yyTCombPtr;

      if (yySymbol <= yyLastTerminal) {
	 for (;;) {
	    yyTCombPtr = yyTBasePtr [yyState] + yySymbol;
	    if (yyTCombPtr->Check != yyState) {
	       if ((yyState = yyDefault [yyState]) == yyNoState) return yyNoState;
	    } else {
	       return yyTCombPtr->Next;
	    }
	 }
      } else {
	return * (yyNBasePtr [yyState] + yySymbol);
      }
   }

$@ static void Begin@ ()
   {
$B	/* BEGIN section is inserted here */
   }

$@ void Close@ ()
   {
$C	/* CLOSE section is inserted here */
   }
