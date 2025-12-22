/* From the book PROLOG PROGRAMMING IN DEPTH
   by Michael A. Covington, Donald Nute, and Andre Vellino.
   Copyright 1988 Scott, Foresman & Co.
   Non-commercial distribution of this file is permitted. */
/* Modified for Quintus Prolog by Andreas Siebert */


/* XSHELL.PL */

/*
 * An expert system consultation driver to be used     
 * with separately written knowledge bases.            
 *
 * Procedures in the file include XSHELL, XSHELL_AUX,  
 * FINISH_XSHELL, PROP, PARM, PARMSET, PARMRANGE,      
 * EXPLAIN, MEMBER, and WAIT.                          
 *
 * Requires various procedures defined in the files
 * READSTR.PL, READNUM.PL, WRITELN.PL, and YES.PL
 * from Chapter 5.
 *
 */

:- ( clause(readstring(_),_) ; consult('readstr.pl') ). 
:- ( clause(readnumber(_),_) ; consult('readnum.pl') ).
:- ( clause(writeln(_),_) ; consult('writeln.pl') ). 
:- ( clause(yes(_),_) ; consult('yes.pl') ).

/*
 * xshell                                                    
 *   As a query, this predicate begins a consultation. It is
 *   the main program or procedure for the expert system 
 *   consultation driver. It always succeeds. 
 */

xshell :- xkb_intro(Statement),  
          writeln(Statement), nl,  
          xkb_identify(ID),             
          asserta(known(identification,ID)), 
          xkb_report(Phrase),           
          write(Phrase),                
          writeln(ID), nl,          
          explain,
          xkb_unique(yes),              
          !,                            
          xshell_aux.

xshell :- xshell_aux.

/*
 * xshell_aux 
 *   Prevents an abrupt end to a consultation that ends 
 * without an identification, or a consultation where 
 * multiple identifications are allowed. 
 */ 

xshell_aux :- known(identification,_),   
              writeln('I cannot reach a conclusion.'),
              !,
              finish_xshell.

xshell_aux :- xkb_unique(no),  
              known(identification,_),
              writeln('I cannot reach any further conclusion.'),
              !,                            
              finish_xshell.

xshell_aux :- finish_xshell.     

/*                                 
 * finish_xshell                                               
 *   Erases the working database and asks if the user wants  
 *   to conduct another consultation.  Use retractall instead  
 *   of abolish in some Prolog implementations.
 */

finish_xshell :-
     abolish(known,2),
     writeln('Do you want to conduct another consultation?'),
     yes('>'), nl, nl,
     !,
     xshell.  

finish_xshell.

/*
 * prop(Property)
 *   Succeeds if it is remembered from an earlier call that  
 *   the subject has the Property.  Otherwise the user is  
 *   asked if the subject has the Property and the user's  
 *   answer is remembered. In this case, the procedure call
 *   succeeds only if the user answers 'yes'. 
 */

prop(Property) :- known(Property,Value),
                  !,           
                  Value == y.  

prop(Property) :- xkb_question(Property,Question),
                  writeln(Question),
                  yes('>'), nl, nl,
                  assert(known(Property,y)), 
                  !.

prop(Property) :- assert(known(Property,n)),    
                  nl, nl,
                  !,
                  fail.

/*
 * parm(Parameter,Type,Value)
 *   Type determines whether Value is to be a character, an   
 *   atom, or a number.  Value becomes the remembered value
 *   for the parameter if there is one. Otherwise the user is  
 *   asked for a value and that value is remembered. When 
 *   used as a test condition, Value is instantiated before
 *   the procedure is called and parm(Parameter,Type,Value)  
 *   only succeeds if the remembered value, or alternatively 
 *   the value reported by the user, matches Value.          
 */

parm(Parameter,_,Value) :- known(Parameter,StoredValue),
                           !,
                           Value = StoredValue.

parm(Parameter,c,Value) :- xkb_question(Parameter,Question),
                           writeln(Question),
                           write('>'),
                           get1(Char), nl, nl,
                           name(Response,[Char]), 
                           assert(known(Parameter,Response)), 
                           !,
                           Value = Response.

parm(Parameter,a,Value) :- xkb_question(Parameter,Question),
                           writeln(Question),
                           readatom(Response), nl, nl,
                           assert(known(Parameter,Response)),
                           !,
                           Value = Response.

parm(Parameter,n,Value) :- xkb_question(Parameter,Question),
                           writeln(Question),
                           readnumber(Response), nl, nl,
                           assert(known(Parameter,Response)),
                           !,
                           Value = Response.

/*
 * parmset(Parameter,Type,Set)
 *   Type indicates whether the Parameter takes a character, 
 *   an atom, or a number as value, and Set is a list of 
 *   possible values for Parameter.  A call to the procedure 
 *   succeeds if a value for Parameter is established that is
 *   a member of Set.
 */

parmset(Parameter,Type,Set) :- parm(Parameter,Type,Value),
                               member(Value,Set).

/*
 * parmrange(Parameter,Minimum,Maximum)
 *   Parameter should be a parameter that takes numbers as   
 *   values, and Minimum and Maximum should be numbers.  A 
 *   call to the procedure succeeds if a value for Parameter 
 *   is established that is in the closed interval           
 *   [Minimum,Maximum].                                      
 */

parmrange(Parameter,Minimum,Maximum) :- 
     parm(Parameter,n,Value),                                
     Minimum =< Value,                                       
     Maximum >= Value.

/*
 * explain
 *   Explains how the expert system arrived at a conclusion 
 *   by finding an identification rule for the conclusion in 
 *   the knowledge base whose condition succeeds and showing 
 *   it to the user.  If xkb_explain(no) is in the knowledge 
 *   base explain merely waits for a keystroke to give the 
 *   user time to read the conclusion. 
 */

explain :- xkb_explain(no), wait, !.

explain :- writeln(
           ['Do you want to see the rule that was used',
            'to reach the conclusion?']),
           \+ yes('>'), nl, !.

explain :- known(identification,ID),
           clause(xkb_identify(ID),Condition),
           Condition, nl, nl,
           write('Rule: '),
           xkb_report(Phrase),
           write(Phrase),
           writeln(ID),
           writeln('    if'),
           write(Condition), nl, nl, !.

/*
 * wait
 *   Prints prompt and waits for keystroke.
 */ 

wait :- write('Press Return when ready to continue. '),
        get0(_), nl, nl.  % Even ALS can use get0 here.



member(X,[X|_]).
member(X,[_|Y]) :- member(X,Y).
