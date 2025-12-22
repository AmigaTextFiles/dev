/**************************************/
/* parse.h                            */
/* for BMFC 0.00                      */
/* Copyright 1992 by Adam M. Costello */
/**************************************/


#include <stdio.h>


void beginparsing(FILE *infile);

/* beginparsing(infile) must be called before any of   */
/* the other functions are called.  This tells the     */
/* other functions where to get their input, and also  */
/* resets the current line number to 1 and the current */
/* line position to 0.  beginparsing() may be called   */
/* more than once, to parse more than one file.        */


const unsigned char *nextword(void);

/* nextword() returns a string containing the next     */
/* word in the instruction, or an empty string if      */
/* there are no more words in the instruction.  The    */
/* pointer returned is valid only until the next call  */
/* to nextword().  See the file BMFC.doc, section      */
/* SOURCE LANGUAGE, subsection Basic Syntax, for an    */
/* explanation of words and instructions.              */


int nextinstr(void);

/* nextinstr() advances to the next instruction, if    */
/* there is one.  It returns 1 if there is one, 0 if   */
/* there isn't (e.g., if end-of-file is reached.)      */


int wordtoul(const unsigned char *word, unsigned long *ulptr);

/* wordtoul(word,ulptr) attempts to find the integer   */
/* represented by word.  See the file BMFC.doc,        */
/* section SOURCE LANGUAGE, subsection Basic Syntax,   */
/* for an explanation of words than represent          */
/* integers.  If wordtoul(word,ulptr) is able to find  */
/* the integer, it writes the integer to *ulptr and    */
/* returns 1, else it trashes *ulptr and returns 0.    */


unsigned long linenum(void);

/* linenum() returns the line number of the last       */
/* character read.  Lines are terminated by            */
/* character $0A.                                      */


unsigned long position(void);

/* position() returns the number of characters read so */
/* far on the current line.                            */
