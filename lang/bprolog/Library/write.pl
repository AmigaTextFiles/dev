
%   File   : WRITE.PL
%   Author : Richard A. O'Keefe
%   Updated: 22 October 1984
%   Purpose: Portable definition of write/1 and friends.

/*
:- public
	write_canonical/1, write_canonical/2,
	display/1,
	print/1, print/2,
	write/1, write/2,
	writeq/1, writeq/2,
	listing/0,
	listing/1,
	portray_clause/1, portray_clause/2.
*/

/*  WARNING!
    This file was written to assist portability and to help people
    get a decent set of output routines off the ground fast.  It is
    not particularly efficient.  Information about atom names and
    properties should be precomputed and fetched as directly as
    possible, and strings should not be created as lists!

    The four output routines differ in the following respects:
    [a] write_canonical doesn't use operator information or handle {X} or
	[H|T] specially.  The others do.
    [b] print calls portray/1 to give the user a chance to do
	something different.  The others don't.
    [c] writeq puts quotes around atoms that can't be read back.
	The others don't.
    Since they have such a lot in common, we just pass around
    arguments (SynStyle, LexStyle) saying what to do.

    In a Prolog which supports strings;
	write(<string>) should just write the text of the string, this so
	that write("Beware bandersnatch") can be used.  The other output
	commands should quote the string.

    listing(Preds) is supposed to write the predicates out so that they
    can be read back in exactly as they are now, provided the operator
    declarations haven't changed.  So it has to use writeq.  $VAR(X)
    will write the atom X without quotes, this so that you can write
    out a clause in a readable way by binding each input variable to
    its name.
*/

% Priority 999 is o.k. if printed e.g. as elements of a list. /MC
:-determinate([writename/1,writeqname/1]).

illarg(Type, Term,ArgNo):-
    true :
    handle_exception(Type,Term).

'$output'(Curr,Stream):-
    true :
    telling(Curr),
    tell(Stream).

'$operator'(Atom):-
    read_prefixop(Atom,_,_).
'$operator'(Atom):-
    read_postfixop(Atom,_,_).
'$operator'(Atom):-
    read_infixop(Atom,_,_,_).

current_prefixop(F, P1, P2):-
    true :
    read_prefixop(F,P1,P2).

current_postfixop(F, P1, P2):-
    true :
    read_postfixop(F,P1,P2).

current_infixop(F, P, O, Q):-
    true :
    read_infixop(F,P,O,Q).

'$atom_mode'(Atom,C):-
    b_NORMAL_ATOM_c(Atom),!, C=0.
'$atom_mode'(Atom,C):-
     '$operator'(Atom),Atom\==',',!,C=2.
'$atom_mode'(Atom,C):-
     C=1.

writeq_atom(Atom):-
    '$atom_mode'(Atom,C),
    (C=:=0->writename(Atom);
     C=:=2->writename(Atom);
     writeqname(Atom)).
/*
writeq_quick(Term) :- var(Term) : writeqname(Term).
writeq_quick(Term) :- atom(Term) : writeqname(Term).
writeq_quick(Term) :- integer(Term) : writeqname(Term).
writeq_quick(Term) :- float(Term) : b_FLOAT_WRITE_c(Term).
writeq_quick(dvar(X,_,_,_,_)):- true : writename('dvar:'),writename(X).

write_quick(Term) :- var(Term) : writename(Term).
write_quick(Term) :- atom(Term) : writename(Term).
write_quick(Term) :- integer(Term) : writename(Term).
write_quick(Term) :- float(Term) : b_FLOAT_WRITE_c(Term).
write_quick(dvar(X,_,_,_,_)):- true : writename('dvar:'),writename(X).
*/

write_quick(Term):- b_WRITE_QUICK_c(Term).

writeq_quick(Term):-
    atom(Term) :
    writeq_atom(Term).
writeq_quick(Term):-
    true :
    b_WRITEQ_QUICK_c(Term).

display_quick(Term) :- var(Term): writename(Term).
display_quick(Term) :- atomic(Term): writename(Term).

write_canonical(Term) :-
    writeq_quick(Term) : true.
write_canonical(Term) :- 
    true :
    write_out(Term, noop, quote, 1200, 0, 0, '(', 2'100, _).

display(Term) :- 
    true :
    display1(user, Term).

display1(Stream, Term) :-
    true :
    '$output'(Curr, Stream),
    display1(Term), 
    '$output'(_, Curr).

display1(Term) :-
    display_quick(Term) :
    true.
display1(Term) :- 
    true :
    write_out(Term, noop, noquote, 1200, 0, 0, '(', 2'100, _).


print(Stream, Term, Limit) :-
    true :
    '$output'(Curr, Stream),
    write_out(Term, print(Limit), quote, 1200, 0, 0, '(', 2'100, _),
    '$output'(_, Curr).

print(Stream, Term) :-
    '$output'(Curr, Stream) :
    print(Term), 
    '$output'(_, Curr).
print(Stream, Term) :-
    true :
    illarg(type(stream), print(Stream,Term), 1).

print(Term) :-
    true :
    write_out(Term, print(10), noquote, 1200, 0, 0, '(', 2'100, _).

/*
write(Stream, Term) :-
    '$output'(Curr, Stream) :
    write(Term), 
    '$output'(_, Curr).
write(Stream, Term) :-
    true :
    illarg(type(stream), write(Stream,Term), 1).
*/

write(Term) :-
    b_WRITE_QUICK_c(Term) : true.
write(Term) :-
    true :
    write_out(Term, op, noquote, 1200, 0, 0, '(', 2'100, _).



writeq(Term) :-
    writeq_quick(Term) : true.
writeq(Term) :-
    true : write_out(Term, op, quote, 1200, 0, 0, '(', 2'100, _).


%   maybe_paren(P, Prio, Char, Ci, Co)
%   writes a parenthesis if the context demands it.
%   Context = 2'000 for alpha
%   Context = 2'001 for quote
%   Context = 2'010 for other
%   Context = 2'100 for punct

maybe_paren(P, Prio, Lpar, Lpar1, _, C):-
    P > Prio :
    C=2'100,
    Lpar1='(',
    writename(Lpar).
maybe_paren(_, _, Lpar, Lpar1, C, C1):-
    true : Lpar=Lpar1,C=C1.

maybe_paren(P, Prio, _, C):-
    P > Prio :
    C=2'100,
    writename(')').
maybe_paren(_, _, C, C1):-
    true : C=C1.

%   maybe_space(LeftContext, TypeOfToken)
%   generates spaces as needed to ensure that two successive
%   tokens won't run into each other.

maybe_space(Ci, Co) :-
    Ci\/Co<2'100, xor(Ci,Co,Cm),Cm<2'010 :put(0' ).
maybe_space(Ci, Co) :-
    true : true.

/*
sticky_contexts(alpha, alpha).
sticky_contexts(quote, quote).
sticky_contexts(other, other).
sticky_contexts(alpha, quote).
sticky_contexts(quote, alpha).
*/

%   write_out(Term, SynStyle, LexStyle, Prio, PrePrio, Depth, Lpar, Ci, Co)
%   writes out a Term in given SynStyle, LexStyle
%   at nesting depth Depth
%   in a context of priority Priority (that is, expressions with
%   greater priority must be parenthesized), 
%   and prefix operators =< PrePrio must be parenthesized,
%   where the last token to be
%   written was of type Ci, and reports that the last token it wrote
%   was of type Co.

write_out(Term, _, _, _, _, _, _, Ci, Co):-
    var(Term) :
    Co=2'000,
    maybe_space(Ci, 2'000),
    writename(Term).
write_out('$VAR'(N), SynStyle, LexStyle, _, _, Depth, _, Ci, Co) :- 
    true :
    Depth1 is Depth+1,
    write_VAR(N, SynStyle, LexStyle, Depth1, Ci, Co).
write_out(dvar(X,_,_,_,Dx), SynStyle, LexStyle, _, _, Depth, _, Ci, Co) :- 
    true :
    Co=2'000,
    (nonvar(X)->write(X);
         write(dvar(Dx)),write(':'),writename(X),
         b_DM_MIN_cf(Dx,Min),
         b_DM_MAX_cf(Dx,Max),
         writename(':'),writename(Min),writename('..'),write(Max)).
write_out(_, print(Limit), _, _, _, Depth, _, Ci, Co):-
    Depth > Limit :
    Co=2'010,
%    maybe_space(Ci, 2'010),
    writename(...).
%write_out(Term, print(_), _, _, _, _, _, _, Co):-
%    true :
%    Co=2'000.
write_out(Atom, _, LexStyle, _, PrePrio, _, Lpar, _, Co):-
    atom(Atom),
    current_prefixop(Atom, P, _),
    P =< PrePrio :
    Co=2'100,
   writename(Lpar),
   write_atom(LexStyle, Atom, 2'100, _),
    put(0')).
write_out(Atom, _, LexStyle, _, _, _, _, Ci, Co) :-
    atom(Atom) :
    write_atom(LexStyle, Atom, Ci, Co).
write_out(N, _, _, _, _, _, _, Ci, Co):-
    number(N) :
	(   N < 0 -> maybe_space(Ci, 2'010)
	;   maybe_space(Ci, 2'000)
	),
    Co=2'000,
    writename(N).
write_out(Term, noop, LexStyle, _, _, Depth, _, Ci, Co):-
    functor(Term, Atom, Arity) :
    Co=2'100,
    write_atom(LexStyle, Atom, Ci, _),
    Depth1 is Depth+1,
    write_args(0, Arity, Term, noop, LexStyle, Depth1).
write_out({Term}, SynStyle, LexStyle, _, _, Depth, _, _, Co):-
    true :
    Co=2'100,
    put(0'{),
    Depth1 is Depth+1,
    write_out(Term, SynStyle, LexStyle, 1200, 0, Depth1, '(', 2'100, _),
    put(0'}).
write_out([Head|Tail], SynStyle, LexStyle, _, _, Depth, _, _, Co):-
    true :
    Co=2'100,
    put(0'[),
    Depth1 is Depth+1,
    write_out(Head, SynStyle, LexStyle, 999, 0, Depth1, '(', 2'100, _),
    write_tail(Tail, SynStyle, LexStyle, Depth1).
write_out((A,B), SynStyle, LexStyle, Prio, _, Depth, Lpar, Ci, Co) :- 
    true :
	%  This clause stops writeq quoting commas.
    Depth1 is Depth+1,
    maybe_paren(1000, Prio, Lpar, Lpar1, Ci, C1),
    write_out(A, SynStyle, LexStyle, 999, 0, Depth1, Lpar1, C1, _),
    put(0',),
    write_out(B, SynStyle, LexStyle, 1000, 1000, Depth1, '(', 2'100, C2),
    maybe_paren(1000, Prio, C2, Co).
write_out(Term, SynStyle, LexStyle, Prio, PrePrio, Depth, Lpar, Ci, Co) :-
    true :
    functor(Term, F, N),
    Depth1 is Depth+1,
    write_out(N, F, Term, SynStyle, LexStyle, Prio, PrePrio, Depth1, Lpar, Ci, Co).

write_out(1, F, Term, SynStyle, LexStyle, Prio, _, Depth, Lpar, Ci, Co) :-
    current_postfixop(F, P, O) :
    (current_infixop(F, _, _, _) -> O1=1200; O1=O),
    maybe_paren(O1, Prio, Lpar, Lpar1, Ci, C1),
    arg(1, Term, A),
    write_out(A, SynStyle, LexStyle, P, 1200, Depth, Lpar1, C1, C2),
    write_atom(LexStyle, F, C2, C3),
    maybe_paren(O1, Prio, C3, Co).
write_out(1, F, Term, SynStyle, LexStyle, Prio, PrePrio, Depth, Lpar, Ci, Co) :-
    F \== -,
    current_prefixop(F, O, P) :
    (PrePrio=1200 -> O1 is P+1; O1=O),	% for "fy X yf" etc. cases
    maybe_paren(O1, Prio, Lpar, _, Ci, C1),
    write_atom(LexStyle, F, C1, C2),
    arg(1, Term, A),
    write_out(A, SynStyle, LexStyle, P, P, Depth, ' (', C2, C3),
    maybe_paren(O1, Prio, C3, Co).
write_out(2, F, Term, SynStyle, LexStyle, Prio, PrePrio, Depth, Lpar, Ci, Co) :-
    current_infixop(F, P, O, Q) :
    (PrePrio=1200 -> O1 is Q+1; O1=O),	% for "U xfy X yf" etc. cases
    maybe_paren(O1, Prio, Lpar, Lpar1, Ci, C1),
    arg(1, Term, A),
    write_out(A, SynStyle, LexStyle, P, 1200, Depth, Lpar1, C1, C2),
    write_atom(LexStyle, F, C2, C3),
    arg(2, Term, B),
    write_out(B, SynStyle, LexStyle, Q, Q, Depth, '(', C3, C4),
    maybe_paren(O1, Prio, C4, Co).
write_out(N, F, Term, SynStyle, LexStyle, _, _, Depth, _, Ci, Co):-
    true :
    Co=2'100,
    write_atom(LexStyle, F, Ci, _),
    write_args(0, N, Term, SynStyle, LexStyle, Depth).

write_VAR(N, SynStyle, _, _, Ci, Co):-
    integer(N), N >= 0,
    SynStyle \== noop :
    Co=2'000,
    maybe_space(Ci, 2'000),
    Letter is N mod 26 + 0'A,
    put(Letter),
    (N>=26 ->
	    Rest is N//26, writename(Rest)
	;   true
	).
write_VAR(String, SynStyle, _, _, Ci, Co) :-
    nonvar(String),
%    (   '$atom_chars'(Atom, String) -> true
    Atom = String,
    atom(Atom),
    SynStyle \== noop :
    '$atom_mode'(Atom, Co),
    maybe_space(Ci, Co),
    writename(Atom).
write_VAR(X, SynStyle, LexStyle, Depth, Ci, Co):-
    true :
    Co=2'100,
    write_atom(LexStyle, '$VAR', Ci, _),
    write_args(0, 1, '$VAR'(X), SynStyle, LexStyle, Depth).

write_atom(noquote, Atom, Ci, Co) :-
    true :
    '$atom_mode'(Atom, Co),
    maybe_space(Ci, Co),
    writename(Atom).
write_atom(quote, Atom, Ci, Co) :-
    true :
    '$atom_mode'(Atom, Co),
    maybe_space(Ci, Co),
    writeq_atom(Atom).


%   write_args(DoneSoFar, Arity, Term, SynStyle, LexStyle, Depth)
%   writes the remaining arguments of a Term with Arity arguments
%   all told in SynStyle, LexStyle, given that DoneSoFar have already been written.

write_args(N, N, _, _, _, _) :- 
    true :
    put(0')).
write_args(I, _, _, print(Limit), _, Depth) :-
    Depth > Limit :
    write_args(I, Depth),
    writename(...),
    put(0')).
write_args(I, N, Term, SynStyle, LexStyle, Depth) :-
    true :
    write_args(I, Depth),
    J is I+1,
    arg(J, Term, A),
    write_out(A, SynStyle, LexStyle, 999, 0, Depth, '(', 2'100, _),
    Depth1 is Depth+1,
    write_args(J, N, Term, SynStyle, LexStyle, Depth1).

write_args(0, _) :- true : put(0'().
write_args(I, I) :- true : writename(', ').
write_args(_, _) :- true : put(0',).



%   write_tail(Tail, SynStyle, LexStyle, Depth)
%   writes the tail of a list of a given SynStyle, LexStyle, Depth.

write_tail(Var, _, _, _) :-			%  |var]
    var(Var) :
    put(0'|),
    writename(Var),
    put(0']).
write_tail([], _, _, _) :- 			%  ]
    true : put(0']).
write_tail(_, print(Limit), _, Depth) :-
    Depth > Limit :
    put(0',),
    write(...),
    put(0']).
write_tail([Head|Tail], SynStyle, LexStyle, Depth) :-  %  ,Head tail
    true : put(0',),
    write_out(Head, SynStyle, LexStyle, 999, 0, Depth, '(', 2'100, _),
    Depth1 is Depth+1,
    write_tail(Tail, SynStyle, LexStyle, Depth1).
write_tail(Other, SynStyle, LexStyle, Depth) :-	%  |junk]
    true :
    put(0'|),
    write_out(Other, SynStyle, LexStyle, 999, 0, Depth, '(', 2'100, _),
    put(0']).


/*  The listing/0 and listing/1 commands are based on the Dec-10
    commands, but the format they generate is based on the "pp" command.
    The idea of portray_clause/1 came from PDP-11 Prolog.

    BUG: the arguments of goals are not separated by comma-space but by
    just comma.  This should be fixed, but I haven't the time right not.
    Run the output through COMMA.EM if you really care.
    (Now fixed by Mats C).

    An irritating fact is that we can't guess reliably which clauses
    were grammar rules, so we can't print them out in grammar rule form.

    We need a proper pretty-printer that takes the line width into
    acount, but it really isn't all that feasible in Dec-10 Prolog.
    Perhaps we could use some ideas from NIL?
*/
/*
listing :- listing(_).

listing(Arg) :- parse_functor_spec(Arg, X, M, listing1(X, M), listing(X)).

listing1(Pred, Module) :-
	'$predicate_property'(Pred, 8, _, Module), %xref predtyp.h
	listing2(Pred, Module),
	fail.
listing1(_, _).

listing2(Pred, Module) :-
	'$typein_module'(Tyi, Tyi),
	'$current_clauses'(Pred, Root, Module),
	'$first_instance'(Root, _),
	nl,
	'$current_instance'(Head0, Body, Root, _),
	(   Module = Tyi -> Head = Head0
	;   '$home_module'(Head0, Module, Home),
	    '$home_module'(Head0, Tyi, Home) -> Head=Head0
	;   Head = Module:Head0
	),
	prettyvars((Head:-Body)),
	portray_clause1((Head:-Body)).
*/

prettyvars(Term) :-
    prettyvars(Term, Vars0, []),
    keysort(Vars0, Vars),
    set_singleton_vars(Vars, 0).

prettyvars(Var) -->
	{var(Var)}, !, [Var-[]].
prettyvars([X|Xs]) --> !,
	prettyvars(X),
	prettyvars(Xs).
prettyvars(X) -->
	{functor(X, _, A)},
	prettyvars(0, A, X).

prettyvars(A, A, _) --> !.
prettyvars(A0, A, X) -->
	{A1 is A0+1},
	{arg(A1, X, X1)},
	prettyvars(X1),
	prettyvars(A1, A, X).

set_singleton_vars([], _).
set_singleton_vars([X,Y|Xs], N0) :-
	X==Y, !,
	X='$VAR'(N0)-[],
	N is N0+1,
	set_singleton_vars(Xs, X, N).
set_singleton_vars(['$VAR'('_')-[]|Xs], N0) :-
	set_singleton_vars(Xs, N0).

set_singleton_vars([X|Xs], Y, N0) :-
	X==Y, !,
	set_singleton_vars(Xs, Y, N0).
set_singleton_vars(Xs, _, N0) :-
	set_singleton_vars(Xs, N0).


% This must be careful not to bind any variables in Clause.
portray_clause(Clause) :-
    prettyvars(Clause),
    portray_clause1(Clause),
    fail.
portray_clause(_).

portray_clause1(:-(Command)) :-
    functor(Command, Key, 1),
    read_curr_op(_, fx, Key), !,
    arg(1, Command, Body),
    'list clauses'(Body, :-(Key), 8, Co),
    write_fullstop(Co).
portray_clause1((Pred:-Body)) :- !,
    write_head(Pred, Ci),
    (   Body=true -> write_fullstop(Ci)
      ;   'list clauses'(Body, 0, 8, Co),
	write_fullstop(Co)
    ).
portray_clause1((Pred-->Body)) :- !,
    write_head(Pred, _),
    'list clauses'(Body, 2, 8, Co),
    write_fullstop(Co).
portray_clause1(Pred) :-
    write_head(Pred, Ci),
    write_fullstop(Ci).

write_head(Head, Ci) :-
    write_out(Head, op, quote, 1199, 1200, -1, '(', 2'100, Ci).  % writeq

write_fullstop(Ci) :-
	maybe_space(Ci, 2'010),
	put(0'.), nl.


'list clauses'((A,B), L, D, Co) :- !,
	'list clauses'(A, L, D, _),
	'list clauses'(B, 1, D, Co).
'list clauses'((A;B), L, D, 2'100) :- !,
	'list magic'(L, D),
	'list disj'(A, 3, D),
	'list disj'(B, D).
'list clauses'((A->B), L, D, 2'100) :- !,
	'list magic'(L, D),
	E is D+4,
	'list clauses'(A, 3, E, _),
	'list clauses'(B, 5, E, _),
	nl, tab(D),
	put(0')).
'list clauses'(!, 0, _, 2'100) :- !,
	writename(' :- !').
'list clauses'(!, 1, _, 2'100) :- !,
        writename(', !').
'list clauses'(!, 2, _, 2'100) :- !,
	writename(' --> !').
'list clauses'(Goal, L, D, Co) :-
	'list magic'(L, D),
	write_out(Goal, op, quote, 999, 0, -1, '(', 2'100, Co). % writeq


'list magic'(0, D) :-
	writename(' :-'),
	nl, tab(D).
'list magic'(1, D) :-
	put(0',),
	nl, tab(D).
'list magic'(2, D) :-
	writename(' -->'),
	nl, tab(D).
'list magic'(3, _) :-
	writename('(   ').
'list magic'(4, _) :-
	writename(';   ').
'list magic'(5, D) :-
	writename(' ->'),
	nl, tab(D).
'list magic'(:-(Key), D) :-
	writename(':- '),
	writename(Key),
	nl, tab(D).

'list disj'((A;B), D) :- !,
	'list disj'(A, 4, D),
	'list disj'(B, D).
'list disj'(Conj, D) :-
	'list disj'(Conj, 4, D),
	put(0')).

'list disj'((A->B), L, D) :- !,
	E is D+4,
	'list clauses'(A, L, E, _),
	'list clauses'(B, 5, E, _),
	nl, tab(D).
'list disj'(A, L, D) :-
	E is D+4,
	'list clauses'(A, L, E, _),
	nl, tab(D).
