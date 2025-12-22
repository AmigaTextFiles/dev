/***********************************************************************
 *
 *	C Callin facility
 *
 *	This module provides the routines necessary to allow C code to
 *	invoke Smalltalk messages on objects.
 *
 ***********************************************************************/


/***********************************************************************
 *
 * Copyright (C) 1990, 1991, 1992 Free Software Foundation, Inc.
 * Written by Steve Byrne.
 *
 * This file is part of GNU Smalltalk.
 *
 * GNU Smalltalk is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 1, or (at your option) any later 
 * version.
 * 
 * GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
 * Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
 *
 ***********************************************************************/

/*
 *    Change Log
 * ============================================================================
 * Author      Date       Change 
 * sbb	      1 Jan 92	  Fixed to auto-initialize Smalltalk when the public
 *			  routines are invoked.
 *
 * sbb	     31 Dec 91	  Created.
 *
 */

#include <varargs.h>
#include <stdio.h>

#include "mst.h"
#include "mstlib.h"
#include "mstinterp.h"
#include "mstcallin.h"
#include "mstdict.h"
#include "mstsym.h"
#include "mstoop.h"

/* Simple control over oop registry size */
#define INITIAL_REGISTRY_SIZE	100

/*
 * The registry of OOPs which have been passed to C code.  A vector of
 * of oops, running from 0 to registryIndex, some of which may be nilOOP.
 * the current allocated size of the registry is registrySize, and the
 * registry may be reallocated to a larger size as need.  The registry
 * is examined at GC time to ensure that OOPs that C code knows about don't
 * go away.  "C code" here means user level C code, not Smalltalk internal
 * code.
 */
static OOP	*oopRegistry;
static int	registrySize, registryIndex;


OOP msgSend(va_alist)
va_dcl
{
  va_list	args;
  OOP 		receiver, selector, anArg, result;
  int		numArgs;

  va_start(args);

  if (!smalltalkInitialized) { initSmalltalk(); }

  receiver = va_arg(args, OOP);
  selector = va_arg(args, OOP);
  
  prepareExecutionEnvironment();
  pushOOP(receiver);
  for (numArgs = 0; (anArg = va_arg(args, OOP)) != nil; numArgs++) {
    pushOOP(anArg);
  }

  sendMessage(selector, numArgs, false);
  interpret();
  result = popOOP();
  finishExecutionEnvironment();

  return (result);
}

OOP strMsgSend(va_alist)
va_dcl
{
  va_list	args;
  OOP 		receiver, selector, anArg, result;
  int		numArgs;

  va_start(args);

  if (!smalltalkInitialized) { initSmalltalk(); }

  receiver = va_arg(args, OOP);
  selector = internString(va_arg(args, char *));
  
  prepareExecutionEnvironment();
  pushOOP(receiver);
  for (numArgs = 0; (anArg = va_arg(args, OOP)) != nil; numArgs++) {
    pushOOP(anArg);
  }

  sendMessage(selector, numArgs, false);
  interpret();
  result = popOOP();
  finishExecutionEnvironment();

  return (result);
}

#ifdef looks_goofy_to_me /* Tue Dec 31 20:41:01 1991 */
/**/voidPtr cMsgSend(va_alist)
/**/va_dcl
/**/{
/**/  va_list	args;
/**/  OOP 		receiver, selector, anArg, result;
/**/  int		numArgs, bool;
/**/  char		*argStr, *s;
/**/  union {
/**/    voidPtr	v;
/**/    float	f;
/**/  } conv;
/**/
/**/  va_start(args);
/**/
/**/  argStr = va_arg(args, char *);
/**/  selector = internString(va_arg(args, char *));
/**/  
/**/  prepareExecutionEnvironment();
/**/
/**/  s = argStr + 2;		/* <type>= */
/**/  for (numArgs = -1; *s; numArgs++, s++) {
/**/    switch (*s) {
/**/    case 'i':
/**/      pushInt(va_arg(args, long));
/**/      break;
/**/
/**/    case 'f':
/**/      anArg = floatNew(va_arg(args, double));
/**/      pushOOP(anArg);
/**/      break;
/**/
/**/    case 'b':
/**/      if (va_arg(args, int)) {
/**/	pushOOP(trueOOP);
/**/      } else {
/**/	pushOOP(falseOOP);
/**/      }
/**/      break;
/**/
/**/    case 'c':
/**/      anArg = charOOPAt(va_arg(args, char));
/**/      pushOOP(anArg);
/**/      break;
/**/
/**/    case 'C':
/**/      anArg = cObjectNew(va_arg(args, voidPtr));
/**/      pushOOP(anArg);
/**/      break;
/**/
/**/    case 's':
/**/      anArg = stringNew(va_arg(args, char *));
/**/      pushOOP(anArg);
/**/      break;
/**/
/**/    case 'S':
/**/      anArg = internString(va_arg(args, char *));
/**/      pushOOP(anArg);
/**/      break;
/**/    }
/**/  }
/**/
/**/  sendMessage(selector, numArgs, false);
/**/  interpret();
/**/  result = popOOP();
/**/  finishExecutionEnvironment();
/**/
/**/  switch (*argStr) {
/**/  case 'i':
/**/    return ((voidPtr)toInt(result));
/**/
/**/  case 'c':
/**/    return ((voidPtr)charOOPValue(result));
/**/
/**/  case 'C':
/**/    return (cObjectValue(result));
/**/
/**/  case 's':
/**/    return (toCString(result));
/**/
/**/  case 'b':
/**/    return ((voidPtr)(result == trueOOP));
/**/
/**/  case 'f':
/**/    conv.f = floatOOPValue(result);
/**/    return (conv.v);
/**/
/**/  default:
/**/    return (result);
/**/  }
/**/}
#endif /* looks_goofy_to_me Tue Dec 31 20:41:01 1991 */

/* like printf */
void msgSendf(va_alist)
va_dcl
{
  va_list	args;
  OOP 		receiver, selector, anArg, result;
  int		numArgs, bool;
  voidPtr	*resultPtr;
  char		*fmt, *fp, *s, selectorBuf[256];

  va_start(args);

  if (!smalltalkInitialized) { initSmalltalk(); }

  resultPtr = va_arg(args, voidPtr *);

  fmt = va_arg(args, char *);
  
  prepareExecutionEnvironment();

  numArgs = -1;
  for (s = selectorBuf, fp = &fmt[2]; *fp; fp++) {
    if (*fp == '%') {
      fp++;
      numArgs++;
      switch (*fp) {
      case 'i':
	pushInt(va_arg(args, long));
	break;

      case 'f':
	anArg = floatNew(va_arg(args, double));
	pushOOP(anArg);
	break;

      case 'b':
	if (va_arg(args, int)) {
	  pushOOP(trueOOP);
	} else {
	  pushOOP(falseOOP);
	}
	break;

      case 'c':
	anArg = charOOPAt(va_arg(args, char));
	pushOOP(anArg);
	break;

      case 'C':
	anArg = cObjectNew(va_arg(args, voidPtr));
	pushOOP(anArg);
	break;
	
      case 's':
	anArg = stringNew(va_arg(args, char *));
	pushOOP(anArg);
	break;

      case 'S':
	anArg = internString(va_arg(args, char *));
	pushOOP(anArg);
	break;

      case 'o':
	anArg = va_arg(args, OOP);
	pushOOP(anArg);
	break;

      case '%':
	*s++ = '%';
	numArgs--;
	break;
      }
    } else if (*fp != ' ' && *fp != '\t') {
      *s++ = *fp;
    }
  }

  *s = '\0';

  selector = internString(selectorBuf);

  sendMessage(selector, numArgs, false);
  interpret();
  result = popOOP();
  finishExecutionEnvironment();

  if (resultPtr) {
    switch (fmt[1]) {
    case 'i':
      *(int *)resultPtr = toInt(result);
      break;

    case 'c':
      *(char *)resultPtr = charOOPValue(result);
      break;

    case 'C':
      *resultPtr = cObjectValue(result);
      break;

    case 's':
      *(char **)resultPtr = (char *)toCString(result);
      break;

    case 'b':
      *(int *)resultPtr = (result == trueOOP);
      break;

    case 'f':
      *(double *)resultPtr = floatOOPValue(result);
      break;

    case 'o':
    default:
      *(OOP *)resultPtr = result;
      break;
    }
  }
}

void evalCode(str)
char	*str;
{
  if (!smalltalkInitialized) { initSmalltalk(); }
  prepareExecutionEnvironment();
  initLexer(false);
  pushCString(str);
  yyparse();
  popStream(false);
  finishExecutionEnvironment();
}


/*
 *	OOP evalExpr(str)
 *
 * Description
 *
 *	Evaluate a single Smalltalk expression and return the result.
 *
 * Inputs
 *
 *	str   : A Smalltalk method body.  Can have local variables, but no
 *		parameters.  This is much like the immediate expression
 *		evaluation that the command interpreter provides.
 *
 * Outputs
 *
 *	
 */
OOP evalExpr(str)
char	*str;
{
  OOP		result;

  if (!smalltalkInitialized) { initSmalltalk(); }

  /* !!! not done yet */
  prepareExecutionEnvironment();
  initLexer(false);
  pushCString(str);
  yyparse();
  popStream(false);
  result = finishExecutionEnvironment();
  return (result);
}

/***********************************************************************
 *
 *	Conversion *to* Smalltalk datatypes routines
 *
 ***********************************************************************/

OOP intToOOP(i)
long	i;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  return (fromInt(i));
}

OOP floatToOOP(f)
double	f;
{
  return (registerOOP(floatNew(f)));
}

OOP boolToOOP(b)
int	b;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  if (b) {
    return (trueOOP);
  } else {
    return (falseOOP);
  }
}


OOP charToOOP(c)
char	c;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  return (charOOPAt(c));
}


/* !!! Add in byteArray support sometime soon */

OOP stringToOOP(str)
char	*str;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  if (str == nil) {
    return (nilOOP);
  } else {
    return (registerOOP(stringNew(str)));
  }
}

OOP symbolToOOP(str)
char	*str;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  if (str == nil) {
    return (nilOOP);
  } else {
    return (internString(str));
  }
}

OOP cObjectToOOP(co)
voidPtr co;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  if (co == nil) {
    return (nilOOP);
  } else {
    return (registerOOP(cObjectNew(co)));
  }
}


/***********************************************************************
 *
 *	Conversion *from* Smalltalk datatypes routines
 *
 ***********************************************************************/

/* ### need a type inquiry routine */


long OOPToInt(oop)
OOP	oop;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  return (toInt(oop));
}

double OOPToFloat(oop)
OOP	oop;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  return (floatOOPValue(oop));
}

int OOPToBool(oop) 
OOP	oop;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  return (oop == trueOOP);
}

char  OOPToChar(oop)
OOP	oop;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  return (charOOPValue(oop));
}

char *OOPToString(oop)
OOP	oop;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  if (isNil(oop)) {
    return (nil);
  } else {
    return ((char *)toCString(oop));
  }
}

/* !!! add in byteArray support soon */

voidPtr OOPToCObject(oop)
OOP	oop;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  if (isNil(oop)) {
    return (nil);
  } else {
    return (cObjectValue(oop));
  }
}



/***********************************************************************
 *
 *	Bookkeeping routines
 *
 ***********************************************************************/


void initOOPRegistry()
{
  oopRegistry = (OOP *)malloc(INITIAL_REGISTRY_SIZE * sizeof(OOP));
  registrySize = INITIAL_REGISTRY_SIZE;
  registryIndex = 0;
}

OOP registerOOP(oop)
OOP	oop;
{
  if (!smalltalkInitialized) { initSmalltalk(); }

  if (registryIndex >= registrySize) {
    registrySize += INITIAL_REGISTRY_SIZE;
    oopRegistry = (OOP *)realloc(oopRegistry, registrySize);
  }

  oopRegistry[registryIndex++] = oop;
  return (oop);
}

void unregisterOOP(oop)
OOP	oop;
{
  int		i;

  if (!smalltalkInitialized) { initSmalltalk(); }

  for (i = 0; i < registryIndex; i++) {
    if (oopRegistry[i] == oop) {
      oopRegistry[i] = nilOOP;
    }
  }
}


/*
 *	void copyRegisteredOOPs()
 *
 * Description
 *
 *	Called at gcFlip time, copies registered objects to the new space,
 *	and compresses out unregistered objects and those which are duplicates.
 *
 */
void copyRegisteredOOPs()
{
  int		maxIndex, i;
  OOP		oop;

  maxIndex = 0;
  for (i = 0; i < registryIndex; i++) {
    oop = oopRegistry[i];
    if (!isNil(oop) && inFromSpace(oop)) {
      oopRegistry[maxIndex++] = oop;
      localMaybeMoveOOP(oop);
    }
  }

  registryIndex = maxIndex;
}


