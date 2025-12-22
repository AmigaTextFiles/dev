/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* MENUSYST.PL */
/* A menu system written in Prolog */

/* Requires procedure MENU on file MENU.PL */
:- ( clause(menu(_,_),_) ; consult('menu.pl') ).

/****************************
 * Menu navigation routines *
 ****************************/

/* back(Path)
 *   Go to the previous menu. If none, write an
 *   error message and return to the current menu.
 */

back([Head|Tail]) :-  /* back to previous menu */
  !,
  Goal =.. [Head,Tail],    /* note comma! */
  call(Goal).

back([]) :-           /* there IS no previous menu */
  Goal =.. [_,[]],
  write('Cannot back up further'),write(Goal),nl,
  call(Goal).

/* forward(NewMenu,CurrentMenu,Path)
 *   Go to NewMenu, passing it a correctly constructed path.
 */

forward(NewMenu,CurrentMenu,Path) :-   /* forward to another menu */
  Goal =.. [NewMenu,[CurrentMenu|Path]],
  call(Goal).

/* application(Name,CurrentMenu,Path)
 *   Execute the specified application, then
 *   return to the current menu.
 */

application(Name,CurrentMenu,Path) :-  /* execute an application */
  call(Name),
  Goal =.. [CurrentMenu,Path],
  call(Goal).

/*********************************
 * Menus (replace with your own) *
 *********************************/

/* Each menu takes an argument giving the list of menus
   through which it was reached (most recent first).
   See text for comments. */

menuA(_) :-
  nl,
  write('Main menu (Menu A)'),nl,
  menu([item('Go to menu B', forward(menuB,menuA,[])),
        item('Go to menu C', forward(menuC,menuA,[])),
        item('Exit to operating system',
		  application(exit_to_operating_system,_,_)),
        item('Exit to Prolog',application(exit_to_prolog,_,_))],
       Goal),
  call(Goal).

menuB(Path) :-
  nl,
  write('Menu B'),nl,
  menu([item('Go to menu D', forward(menuD,menuB,Path)),
        item('Go to menu E', forward(menuE,menuB,Path)),
        item('Previous menu',back(Path))],
       Goal),
  call(Goal).

menuC(Path)  :-
  nl,
  write('Menu C'),nl,
  menu([item('Say hello',    application(say_hello,menuC,Path)),
        item('Say bonjour',  application(say_bonjour,menuC,Path)),
        item('Previous menu',back(Path))],
       Goal),
  call(Goal).

menuD(Path) :-
  nl,
  write('Menu D'),nl,
  menu([item('Exit to Prolog',application(exit_to_prolog,_,_)),
        item('Jump to menu C',forward(menuC,menuD,Path)),
        item('Previous menu', back(Path))],
       Goal),
  call(Goal).

menuE(Path) :-
  nl,
  write('Menu E'),nl,
  menu([item('Exit to operating system', 
		   application(exit_to_operating_system,menuE,Path)),
        item('Say hello',        application(say_hello,menuE,Path)),
        item('Previous menu',    back(Path)),
        item('Jump to main menu',forward(menuA,menuE,Path))],
       Goal),
  call(Goal).

/* The applications. These are trivial examples,
   but any Prolog procedures could be substituted. */

say_hello :- write('Hello'),nl.
say_bonjour :- write('Bonjour'),nl.
exit_to_operating_system :- halt.
exit_to_prolog :- abort.

/* Starting query */
start :- menuA(_).

:-start.
