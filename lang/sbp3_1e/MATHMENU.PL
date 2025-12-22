/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* MATHMENU.PL */
/* Demonstrates using a menu to choose an operator and
   then build an arithmetic expression around it */

/* Requires procedure READNUMBER defined in READNUM.PL */
:- ( clause(readnumber(_),_) ; consult('readnum.pl') ).

/* Requires procedure MENU defined in MENU.PL */
:- ( clause(menu(_,_),_) ; consult('menu.pl') ).

go :- write('Enter two numbers.'),nl,
      write('The first number:   '),
      readnumber(Num1),
      nl,
      write('The second number:  '),
      readnumber(Num2),
      nl,
      write('Choose an operation: '),nl,
      menu([item('Add','+'),
            item('Subtract','-'),
            item('Multiply','*'),
            item('Divide','/')],
           Operation),
      E =.. [Operation,Num1,Num2],
      write('We have constructed the expression: '),
      write(E),
      nl,
      call(V is E),
      write('It evaluates to: '),
      write(V).
