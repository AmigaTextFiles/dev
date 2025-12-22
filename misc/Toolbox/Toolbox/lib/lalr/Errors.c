/* $Id: Errors.c,v 2.8 1992/08/17 14:35:54 grosch rel $ */

# include "Errors.h"
# include <stdio.h>

# ifdef __cplusplus
extern "C" {
#  include "System.h"
#  include "Sets.h"
#  include "Idents.h"
}
# else
#  include "System.h"
#  include "Sets.h"
#  include "Idents.h"
# endif

static void yyExit () { Exit (1); }

void (* Errors_Exit) () = yyExit;

static void WriteHead
# if defined __STDC__ | defined __cplusplus
   (short yyErrorClass, tPosition yyPosition)
# else
   (yyErrorClass, yyPosition) short yyErrorClass; tPosition yyPosition;
# endif
{
   WritePosition (stderr, yyPosition);
   (void) fputs (": ", stderr);
   switch (yyErrorClass) {
   case xxFatal		: (void) fputs ("Fatal       ", stderr); break;
   case xxRestriction	: (void) fputs ("Restriction ", stderr); break;
   case xxError		: (void) fputs ("Error       ", stderr); break;
   case xxWarning	: (void) fputs ("Warning     ", stderr); break;
   case xxRepair	: (void) fputs ("Repair      ", stderr); break;
   case xxNote		: (void) fputs ("Note        ", stderr); break;
   case xxInformation	: (void) fputs ("Information ", stderr); break;
   default		: (void) fprintf (stderr, "Error class: %d ", yyErrorClass);
   }
}

static void WriteTail
# if defined __STDC__ | defined __cplusplus
   (short yyErrorClass)
# else
   (yyErrorClass) short yyErrorClass;
# endif
{
   (void) fputc ('\n', stderr);
   if (yyErrorClass == xxFatal) Errors_Exit ();
}

static void WriteCode
# if defined __STDC__ | defined __cplusplus
   (short yyErrorCode)
# else
   (yyErrorCode) short yyErrorCode;
# endif
{
   switch (yyErrorCode) {
   case xxNoText	: break;
   case xxSyntaxError	: (void) fputs ("syntax error"		, stderr); break;
   case xxExpectedTokens: (void) fputs ("expected tokens"	, stderr); break;
   case xxRestartPoint	: (void) fputs ("restart point"		, stderr); break;
   case xxTokenInserted	: (void) fputs ("token inserted "	, stderr); break;
   default		: (void) fprintf (stderr, " error code: %d", yyErrorCode);
   }
}

static void WriteInfo
# if defined __STDC__ | defined __cplusplus
   (short yyInfoClass, char * yyInfo)
# else
   (yyInfoClass, yyInfo) short yyInfoClass; char * yyInfo;
# endif
{
   (void) fputs (": ", stderr);
   switch (yyInfoClass) {
   case xxInteger	: (void) fprintf (stderr, "%d", * (int *)	yyInfo); break;
   case xxShort		: (void) fprintf (stderr, "%d", * (short *)	yyInfo); break;
   case xxCharacter	: (void) fprintf (stderr, "%c", *		yyInfo); break;
   case xxString	: (void) fputs	 (yyInfo, stderr);			 break;
   case xxSet		: WriteSet	 (stderr, (tSet *)		yyInfo); break;
   case xxIdent		: WriteIdent	 (stderr, * (tIdent *)		yyInfo); break;
   default		: (void) fprintf (stderr, "info class: %d", yyInfoClass);
   }
}

void ErrorMessage
# if defined __STDC__ | defined __cplusplus
   (short yyErrorCode, short yyErrorClass, tPosition yyPosition)
# else
   (yyErrorCode, yyErrorClass, yyPosition)
   short yyErrorCode, yyErrorClass; tPosition yyPosition;
# endif
{
   WriteHead (yyErrorClass, yyPosition);
   WriteCode (yyErrorCode);
   WriteTail (yyErrorClass);
}

void ErrorMessageI
# if defined __STDC__ | defined __cplusplus
   (short yyErrorCode, short yyErrorClass, tPosition yyPosition, short yyInfoClass, char * yyInfo)
# else
   (yyErrorCode, yyErrorClass, yyPosition, yyInfoClass, yyInfo)
   short yyErrorCode, yyErrorClass; tPosition yyPosition; short yyInfoClass; char * yyInfo;
# endif
{
   WriteHead (yyErrorClass, yyPosition);
   WriteCode (yyErrorCode);
   WriteInfo (yyInfoClass, yyInfo);
   WriteTail (yyErrorClass);
}

void Message
# if defined __STDC__ | defined __cplusplus
   (char * yyErrorText, short yyErrorClass, tPosition yyPosition)
# else
   (yyErrorText, yyErrorClass, yyPosition)
   char * yyErrorText; short yyErrorClass; tPosition yyPosition;
# endif
{
   WriteHead (yyErrorClass, yyPosition);
   (void) fputs (yyErrorText, stderr);
   WriteTail (yyErrorClass);
}

void MessageI
# if defined __STDC__ | defined __cplusplus
   (char * yyErrorText, short yyErrorClass, tPosition yyPosition, short yyInfoClass, char * yyInfo)
# else
   (yyErrorText, yyErrorClass, yyPosition, yyInfoClass, yyInfo)
   char * yyErrorText; short yyErrorClass; tPosition yyPosition; short yyInfoClass; char * yyInfo;
# endif
{
   WriteHead (yyErrorClass, yyPosition);
   (void) fputs (yyErrorText, stderr);
   WriteInfo (yyInfoClass, yyInfo);
   WriteTail (yyErrorClass);
}
