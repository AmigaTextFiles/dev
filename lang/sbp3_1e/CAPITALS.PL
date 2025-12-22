/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* CAPITALS.PL */
/* Example of a program that starts computation
   automatically upon being consulted */
/* Quintus Prolog prints a warning at the end of the consultation
   because of the fail statement */

capital_of(georgia,atlanta).
capital_of(california,sacramento).
capital_of(florida,tallahassee).
capital_of(connecticut,hartford).

print_a_capital :-  capital_of(State,City),
                    write(City),
                    write(' is the capital of '),
                    write(State),
                    nl.

print_capitals :-   print_a_capital,
                    fail.

/* In some Prologs, change ":-" to "?-" below */

:- nl,
   write('The following are some states and their capitals:'),
   nl,
   nl,
   print_capitals.

