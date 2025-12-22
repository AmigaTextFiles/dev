/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* MENUDEMO.PL */
/* Illustrates accepting input from a menu */

/*
 *  Main routine, called by the starting query
 */

main_program :-  display_menu,
		 get_from_menu(State),
		 capital_of(State,City),
		 nl,
		 write('The capital of '),
		 write(State),
		 write(' is '),
		 write(City),
		 nl.

/*
 *  The knowledge base
 */

capital_of(georgia,atlanta).
capital_of(california,sacramento).
capital_of(florida,tallahassee).
capital_of(connecticut,hartford).

/*
 *  Routines to display the menu
 */

display_menu :- write('Which state do you want to know about?'),nl,
		write(' 1  Georgia'),nl,
		write(' 2  California'),nl,
		write(' 3  Florida'),nl,
		write(' 4  Connecticut'),nl,
		write('Type a number, 1 to 4 -- ').

/*
 *  Routine to accept user's choice from menu
 */

get_from_menu(State) :-  get(Code),
			 interpret(Code,State).

interpret(49,georgia).      /* ASCII 49 = '1' */
interpret(50,california).   /* ASCII 50 = '2' */
interpret(51,florida).      /* ASCII 51 = '3' */
interpret(52,connecticut).  /* ASCII 52 = '4' */

/*
 *  Starting query
 */

start :- main_program.

