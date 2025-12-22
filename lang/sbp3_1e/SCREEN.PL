/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* SCREEN.PL */
/* Screen control using ANSI escape sequences */

/* These predicates work on the IBM PC if the
 * ANSI.SYS device driver is installed -- see text.
 * Except as noted below, they also work on the
 * DEC VT-100 and similar terminals on any computer.
 */

/************************************************
 * clrscr                                       *
 *  Clears the screen and homes the cursor but  *
 *  does not change video attribute settings.   *
 ************************************************/

clrscr :- put(27),
          write('[2J').

/***************************************
 * home                                *
 *  Moves the cursor to the upper left *
 *  corner of the screen.              *
 ***************************************/

home :- put(27),
        write('[H').

/*********************************************
 * clreol                                    *
 *  Clears from the current cursor position  *
 *  to the end of the line.                  *
 *********************************************/

clreol :- put(27),
          write('[K').

/********************************************************
 * gotoxy(X,Y)                                          *
 *  Puts cursor at row X, column Y (numbered from 1,1). *
 ********************************************************/

gotoxy(X,Y) :- integer(X),
               integer(Y),
               put(27),
               write('['),
               write(X),
               write(';'),
               write(Y),
               write('H').

/************************************************************
 * video(Mode)                                              *
 *  Sets various video modes.                               *
 *  Underlined or Reverse can be combined                   *
 *  with Intense and/or Blinking.                           *
 *  Underlining works on the VT-100 and the IBM Monochrome  *
 *  Display but not the various IBM color displays.         *
 ************************************************************/

video(normal)     :- videoattribute(0).
video(underlined) :- videoattribute(4).
video(intense)    :- videoattribute(1).
video(reverse)    :- videoattribute(7).
video(blinking)   :- videoattribute(5).

/*************************************************************************
 * fcolor(Color)                                                         *
 *  Changes the foreground color (the color of lettering on the screen). *
 *  For IBM and similar color displays.                                  *
 *************************************************************************/

fcolor(black)   :- videoattribute(30).
fcolor(red)     :- videoattribute(31).
fcolor(green)   :- videoattribute(32).
fcolor(yellow)  :- videoattribute(33).
fcolor(blue)    :- videoattribute(34).
fcolor(magenta) :- videoattribute(35).
fcolor(cyan)    :- videoattribute(36).
fcolor(white)   :- videoattribute(37).

/***********************************************************************
 * bcolor(Color)                                                       *
 *  Changes the background color (color of blank space on the screen). *
 *  For IBM and similar color displays.                                *
 ***********************************************************************/

bcolor(black)   :- videoattribute(40).
bcolor(red)     :- videoattribute(41).
bcolor(green)   :- videoattribute(42).
bcolor(yellow)  :- videoattribute(43).
bcolor(blue)    :- videoattribute(44).
bcolor(magenta) :- videoattribute(45).
bcolor(cyan)    :- videoattribute(46).
bcolor(white)   :- videoattribute(47).

/**************************************************************
 * videoattribute(N)                                          *
 *  Uses the ANSI "set graphics rendition" escape sequence to *
 *  request the display attributes denoted by the number N.   *
 *  Called by BCOLOR, FCOLOR, and VIDEO.                      *
 **************************************************************/

videoattribute(X) :- put(27),     /* Escape */
                     write('['),
                     write(X),
                     write('m').
