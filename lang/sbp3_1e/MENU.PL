/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

% get1(C)
%  accepts a line of input and returns only the first character.
%  A good way to obtain a 1-character response from the user
%  in a Prolog with buffered input, such as Quintus or ALS.

get1(C) :-
  get(C),
  repeat,
    get0(N),
    (N=10 ; N=13),
  !.


/* MENU.PL */

/*************************************************************************
 * menu(Menu,Result)                                                     *
 *   Displays a menu of up to 9 items and returns the user's choice.     *
 *   A menu is a list of items, each of the form item(Message,Value)     *
 *   where Message (an atom, in single quotes) is the message to be      *
 *   displayed and Value is the value to be returned in Result if the    *
 *   user chooses this item.                                             *
 *************************************************************************/

menu(Menu,Result) :- menu_display(Menu,49,Last),
                     menu_choose(Menu,49,Last,Result),
                     nl.

     /* Display all the messages and simultaneously count them.
        The count starts at 49 (ASCII code for '1'). */

menu_display([],SoFar,Last) :- !,
                               /* not an item, so don't use this number */
                               Last is SoFar - 1.

menu_display([item(Message,_)|Tail],SoFar,Last) :-
      put(32),
      put(32),
      put(SoFar),       /* appropriate digit */
      put(32),          /* blank */
      write(Message),
      nl,
      Next is SoFar + 1,
      menu_display(Tail,Next,Last).

     /* Get the user's choice. If invalid, make him try again. */

menu_choose(Menu,First,Last,Result) :-
      write('Your choice ('),
      put(First),
      write(' to '),
      put(Last),
      write('):  '),
      get1(Char),
      menu_choose_aux(Menu,First,Last,Result,Char).

menu_choose_aux(Menu,First,Last,Result,Char) :-
      Char >= First,
      Char =< Last,
      !,
      menu_select(Menu,First,Char,Result).

menu_choose_aux(Menu,First,Last,Result,_) :-
      put(7),           /* beep */
      put(13),          /* carriage return */
      menu_choose(Menu,First,Last,Result).

      /* Find the appropriate item to return for Char */

menu_select([item(_,Result)|_],First,First,Result) :- !.

menu_select([_|Tail],First,Char,Result) :-
     NewFirst is First+1,
     menu_select(Tail,NewFirst,Char,Result).

