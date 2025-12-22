/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */

/* CHEM.PL */
/* Molecular query predicates and examples */

/* Description of 3-chloro-toluene molecule:

                      H1      Ch
                       \     /
                  H2    C1--C2
                  |    //    \\
              H3--C3--C4      C5--H4
                  |    \     /
                  H5    C6==C7
                       /      \
                      H6      H7

*/

atom_specs(h1,hydrogen,[c1]).
atom_specs(h2,hydrogen,[c3]).
atom_specs(h3,hydrogen,[c3]).
atom_specs(h4,hydrogen,[c5]).
atom_specs(h5,hydrogen,[c3]).
atom_specs(h6,hydrogen,[c6]).
atom_specs(h7,hydrogen,[c7]).
atom_specs(c1,carbon,[c2,c4,h1]).
atom_specs(c2,carbon,[c1,c5,ch]).
atom_specs(c3,carbon,[c4,h2,h3,h5]).
atom_specs(c4,carbon,[c1,c3,c6]).
atom_specs(c5,carbon,[c2,c7,h4]).
atom_specs(c6,carbon,[c4,c7,h6]).
atom_specs(c7,carbon,[c5,c6,h7]).
atom_specs(ch,chlorine,[c2]).


/* Predicates to find bonds and identify elements */

bonded(A1,A2) :-
     atom_specs(A1,_,Neighbors),
     member(A2,Neighbors).

member(X,[X|_]).
member(X,[_|Y]) :- member(X,Y).

element(A1,Element) :- atom_specs(A1,Element,_).


/* Predicates to identify particular substructures */

methyl(C) :-
     element(C,carbon),
     bonded(C,H1), element(H1,hydrogen),
     bonded(C,H2), element(H2,hydrogen), H1 \== H2,
     bonded(C,H3), element(H3,hydrogen), H3 \== H1,
          H3 \== H2.

six_membered_carbon_ring([A1,A2,A3,A4,A5,A6]) :-
     element(A1,carbon), bonded(A1,A2),
     element(A2,carbon), bonded(A2,A3), A1 \== A3,
     element(A3,carbon), bonded(A3,A4),
          \+ member(A4,[A1,A2,A3]),
     element(A4,carbon), bonded(A4,A5),
          \+ member(A5,[A1,A2,A3,A4]),
     element(A5,carbon), bonded(A5,A6),
     element(A6,carbon), bonded(A6,A1),
          \+ member(A6,[A1,A2,A3,A4,A5]).

meth_carbon_ring([C|Ring]) :-
     six_membered_carbon_ring(Ring),
     member(A,Ring), bonded(A,C), methyl(C).

hydroxide(O) :- element(O,oxygen),
                     bonded(O,H),
                element(H,hydrogen).



/* Demonstrations */

demo1 :-    write('Searching for a methyl group...'),nl,
            methyl(X),
            write('Found one centered on atom: '),write(X),nl.

demo2 :-    write('Searching for a six-membered carbon ring...'),nl,
            six_membered_carbon_ring(List),
            write('Found one containing atoms: '),write(List),nl.
