/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* PLANNER.PL */

/* This program uses FINDALL.PL from Chapter 6. */
:- ( clause(find_all(_,_,_),_) ; consult('findall.pl') ).

itinerary(Start,Destination) :-
     flight_planner(Destination,[Start],_).

flight_planner(Destination,[Destination|RestOfCities],
     [Destination|RestOfCities]).

flight_planner(Destination,[OldCity|RestOfCities],Solution) :-
     find_all(X,connection(OldCity,X),List),
     best(Destination,List,NewCity),
     \+ member(NewCity,RestOfCities),
     write([NewCity,OldCity|RestOfCities]), nl,
     flight_planner(Destination,[NewCity,OldCity|RestOfCities],Solution).

best(Destination,List,City) :-
     closest(Destination,List,City).

best(Destination,List,City) :-
     closest(Destination,List,RejectedCity),
     remove(RejectedCity,List,NewList),
     best(Destination,NewList,City).

closest(_,[City],City).

closest(Destination,[FirstCity|RestOfCities],City) :-
     closest(Destination,RestOfCities,AlternateCity),
     distance(FirstCity,Destination,N),
     distance(AlternateCity,Destination,M),
     closer(FirstCity,AlternateCity,N,M,City).

closer(City,_,N,M,City) :- N =< M, !.
closer(_,City,_,_,City).

remove(_,[],[]).
remove(X,[X|Ytail],Ytail) :- !.
remove(X,[Y|Ztail],[Y|Wtail]) :- remove(X,Ztail,Wtail).

connection(FirstCity,SecondCity) :-
     flights_between(FirstCity,SecondCity).
connection(FirstCity,SecondCity) :-
     flights_between(SecondCity,FirstCity).

distance(City,City,0).
distance(FirstCity,SecondCity,N) :-
     miles_between(FirstCity,SecondCity,N).
distance(FirstCity,SecondCity,N) :-
     miles_between(SecondCity,FirstCity,N).

member(X,[X|_]).
member(X,[_|Y]) :- member(X,Y).

/* Information about some cities where Slow and Low flies */

flights_between(atlanta,boston).
flights_between(atlanta,cincinnati).
flights_between(atlanta,new_orleans).
flights_between(atlanta,washington).
flights_between(cincinnati,los_angeles).
flights_between(cincinnati,new_orleans).
flights_between(cincinnati,washington).

miles_between(atlanta,boston,1108).
miles_between(atlanta,cincinnati,400).
miles_between(atlanta,los_angeles,2091).
miles_between(atlanta,new_orleans,480).
miles_between(atlanta,washington,618).
miles_between(boston,cincinnati,840).
miles_between(boston,los_angeles,3017).
miles_between(boston,new_orleans,1507).
miles_between(boston,washington,448).
miles_between(cincinnati,los_angeles,2179).
miles_between(cincinnati,new_orleans,786).
miles_between(cincinnati,washington,481).
miles_between(los_angeles,new_orleans,1858).
miles_between(los_angeles,washington,2646).
miles_between(new_orleans,washington,1099).
