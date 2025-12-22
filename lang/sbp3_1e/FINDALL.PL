/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */

/* FINDALL.PL */

/*************************************************
 * find_all(X,Goal,List)                         *
 *  X contains one or more uninstantiated        *
 *  variables that also occur in Goal.           *
 *  (X can be a single uninstantiated variable.) *
 *  List is a list of all of the instantiations  *
 *  of X with which Goal will succeed.           *
 *************************************************/

/* Note: This is a built-in predicate in Arity
   and is called findall (no underscore mark). */

find_all(X,Goal,_) :-
  asserta(find_item('*MARK*')),
  call(Goal),
  asserta(find_item(X)),
  fail.

find_all(_,_,List) :-
  find_collect([],L),
  !,
  List = L.

find_collect(List1,List2) :-
  find_next(X),
  !,
  find_collect([X|List1],List2).

find_collect(List,List).

find_next(X) :-
  retract(find_item(X)),
  !,
  X \== '*MARK*'.
