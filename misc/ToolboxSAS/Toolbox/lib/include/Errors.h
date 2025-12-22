#ifndef yyErrors
#define yyErrors

/* $Id: Errors.h,v 1.1 1992/08/13 12:14:11 grosch rel $ */

/* $Log: Errors.h,v $
 * Revision 1.1  1992/08/13  12:14:11  grosch
 * deleted redefinition of bool
 *
 * Revision 1.0  1992/08/07  14:31:41  grosch
 * Initial revision
 *
 */

/* Ich, Doktor Josef Grosch, Informatiker, Juli 1992 */


#include <stdio.h>
#include "ratc.h"
#include "Positions.h"

#define xxNoText         0 /* error codes */
#define xxSyntaxError    1
#define xxExpectedTokens 2
#define xxRestartPoint   3
#define xxTokenInserted  4
#define xxTooManyErrors  5

#define xxFatal       1 /* error classes */
#define xxRestriction 2
#define xxError       3
#define xxWarning     4
#define xxRepair      5
#define xxNote        6
#define xxInformation 7

#define xxNone      0 /* info classes */
#define xxInteger   1
#define xxShort     2
#define xxLong      3
#define xxReal      4
#define xxBoolean   5
#define xxCharacter 6
#define xxString    7
#define xxSet       8
#define xxIdent     9


extern void (*Errors_Exit)(void);
/* Refers to a procedure that specifies  */
/* what to do if 'ErrorClass' = Fatal.   */
/* Default: terminate program execution. */


void StoreMessages(bool Store);
/* Messages are stored if 'Store' = TRUE         */
/* for printing with the routine 'WriteMessages' */
/* otherwise they are printed immediately.       */
/* If 'Store'=TRUE the message store is cleared. */

void ErrorMessage(int ErrorCode, int ErrorClass, tPosition Position);
/* Report a message represented by an integer  */
/* 'ErrorCode' and classified by 'ErrorClass'. */

void ErrorMessageI(int ErrorCode, int ErrorClass, tPosition Position, int InfoClass, char *Info);
/* Like the previous routine with additional */
/* information of type 'InfoClass' at the    */
/* address 'Info'.                           */

void Message(char *ErrorText, int ErrorClass, tPosition Position);
/* Report a message represented by a string    */
/* 'ErrorText' and classified by 'ErrorClass'. */

void MessageI(char *ErrorText, int ErrorClass, tPosition Position, int InfoClass, char *Info);
/* Like the previous routine with additional */
/* information of type 'InfoClass' at the    */
/* address 'Info'.                           */

void WriteMessages(FILE *File);
/* The stored messages are sorted by their */
/* source position and printed on 'File'.  */

#endif
