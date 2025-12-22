
%   File   : READ.PL
%   Author : D.H.D.Warren + Richard O'Keefe
%   Modified for SB-Prolog by Saumya K. Debray & Deeporn Beardsley
%   Updated: July 1988
%   Purpose: Read Prolog terms in Dec-10 syntax.
%   Modified by Neng-Fa Zhou for Beta-Prolog
/*
    Modified by Alan Mycroft to regularise the functor modes.
    This is both easier to understand (there are no more '?'s),
    and also fixes bugs concerning the curious interaction of cut with
    the state of parameter instantiation.
 
    Since this file doesn't provide "metaread", it is considerably
    simplified.  The token list format has been changed somewhat, see
    the comments in the RDTOK file.
 
    I have added the rule X(...) -> apply(X,[...]) for Alan Mycroft.
    
    Modified by Neng-Fa ZHOU, 1992
*/
 
:-determinate([univ/2, b_NEXT_TOKEN_cf/2,
      closetail/1,length/2,globaldel/1,
      b_FLOAT_MINUS_cf/2]). 

read(Answer) :- 
    var(Answer) :
    show_prompt,
    read_vars(Answer,_),!.
read(Answer):-
    true :
    show_prompt,
    read(Temp),
    Answer==Temp.

show_prompt:-
    true ?
    seeing(user),
    '$output'(Curr,user),
    global_get('$prompt',0,Prompt),
    writename(Prompt),!,
    '$output'(_,Curr).
show_prompt:-true : true.
    
%   read_vars(?Answer, ?Variables)
%   reads a term from the current input stream and unifies it with
%   Answer.  Variables is bound to a list of [Atom=Variable] pairs.
 
read_vars(Answer, Variables) :-
    true :
    repeat,
    read_tokens(Tokens, Variables),
%    write(Tokens),nl,
    read1(Term,Variables,Tokens),!,
    Answer = Term.

read1(Term,Variables,Tokens):-
    true ?
    read(Tokens, 1200, Term, LeftOver),
    read_all(LeftOver).
read1(Answer,Variables,Tokens):-
    true :
    read_syntax_error(Tokens).
 
read_all([]):-true : true.
read_all(S):-
    true :
    read_syntax_error(['operator expected after expression'],S).

%   read_expect(Token, TokensIn, TokensOut)
%   reads the next token, checking that it is the one expected, and
%   giving an error message if it is not.  It is used to look for
%   right brackets of various sorts, as they're all we can be sure of.
 
read_expect(Token, [Token|Rest], Rest1) :- 
    true :
    Rest1 = Rest.
read_expect(Token, S0, _) :-
    true :
    read_syntax_error([Token,'or operator expected'], S0).
 
 
%   I want to experiment with having the operator information held as
%   ordinary Prolog facts.  For the moment the following predicates
%   remain as interfaces to curr_op.
%   read_prefixop(O -> Self, Rarg)
%   read_postfixop(O -> Larg, Self)
%   read_infixop(O -> Larg, Self, Rarg)
 

read_prefixop(Op, Prec, Prec1) :-
    read_curr_op(Prec, fy, Op) :
    Prec=Prec1.
read_prefixop(Op, Prec, Less) :-
    true :
    read_curr_op(Prec, fx, Op),
    Less is Prec-1.
 
 
read_postfixop(Op, Prec, Prec1) :-
    read_curr_op(Prec, yf, Op) :
    Prec=Prec1.
read_postfixop(Op, Less, Prec) :-
    true :
    read_curr_op(Prec, xf, Op), 
    Less is Prec-1.
 
 
read_infixop(Op, Less, Prec, Less1) :-
    read_curr_op(Prec, xfx, Op) :
    Less=Less1,
    Less is Prec-1.
read_infixop(Op, Less, Prec, Prec1) :-
    read_curr_op(Prec, xfy, Op) :
    Prec=Prec1,
    Less is Prec-1.
read_infixop(Op, Prec, Prec1, Less) :-
    true :
    read_curr_op(Prec, yfx, Op), 
    Prec=Prec1,
    Less is Prec-1.
 

read_ambigop(F, L1, O1, R1, L2, O2) :-
    true :
    read_postfixop(F, L2, O2),
    read_infixop(F, L1, O1, R1).
 
 
%   read(+TokenList, +Precedence, -Term, -LeftOver)
%   parses a Token List in a context of given Precedence,
%   returning a Term and the unread Left Over tokens.
/* 
:- mode(read,4,[nv,nv,d,d]).
*/ 
read([Token|RestTokens], Precedence, Term, LeftOver) :-
    true :
    read(Token, RestTokens, Precedence, Term, LeftOver).
read([], _, _, _) :-
    true :
    read_syntax_error(['expression expected'], []).
 
 
%   read(+Token, +RestTokens, +Precedence, -Term, -LeftOver)
/* 
:- mode(read,5,[nv,nv,c,d,d]).
*/ 

read(var(Variable,_), ['('|S1], Precedence, Answer, S) :- 
    true :
    read(S1, 999, Arg1, S2),
    read_args(S2, RestArgs, S3),
    read_exprtl0(S3,apply(Variable,[Arg1|RestArgs]),Precedence,Answer,S).
read(var(Variable,_), S0, Precedence, Answer, S) :- 
    true :
%	write('==>read_exprt10'(Variable,Answer)),nl,
    read_exprtl0(S0, Variable, Precedence, Answer, S).
%    write('<==read_exprt10'(Variable,Answer)),nl.
read(atom('-'), [number(Num)|S1], Precedence, Answer, S) :-
    true :
    Negative is -Num,
    read_exprtl0(S1, Negative, Precedence, Answer, S).
read(atom('-'), [F|S1], Precedence, Answer, S) :-
    float(F) :
    b_FLOAT_MINUS_cf(F,NF),
    read_exprtl0(S1, NF, Precedence, Answer, S).
read(atom(Functor), ['('|S1], Precedence, Answer, S) :- 
    true :
    read(S1, 999, Arg1, S2),
    read_args(S2, RestArgs, S3),
%    write(univ(Term,[Functor,Arg1|RestArgs])),nl,
    univ(Term,[Functor,Arg1|RestArgs]),
%    write('<==univ'),nl,
    read_exprtl0(S3, Term, Precedence, Answer, S).
read(atom(Functor), S0, Precedence, Answer, S) :-
    true ?
    read_prefixop(Functor, Prec, Right),
    read_aft_pref_op(Functor, Prec, Right, S0, Precedence, Answer, S).
read(atom(Atom), S0, Precedence, Answer, S) :- 
    true :
    read_exprtl0(S0, Atom, Precedence, Answer, S).
read(number(Num), S0, Precedence, Answer, S) :- 
    true :
    read_exprtl0(S0, Num, Precedence, Answer, S).
read('[', [']'|S1], Precedence, Answer, S) :-
    true :
    read_exprtl0(S1, [], Precedence, Answer, S).
read('[', S1, Precedence, Answer, S) :- 
    true :
    read(S1, 999, Arg1, S2),
    read_list(S2, RestArgs, S3), 
    read_exprtl0(S3, [Arg1|RestArgs], Precedence, Answer, S).
read('(', S1, Precedence, Answer, S) :- 
    true :
    read(S1, 1200, Term, S2),
    read_expect(')', S2, S3), 
    read_exprtl0(S3, Term, Precedence, Answer, S).
read(' (', S1, Precedence, Answer, S) :- 
    true :
    read(S1, 1200, Term, S2),
    read_expect(')', S2, S3), 
    read_exprtl0(S3, Term, Precedence, Answer, S).
read('{', ['}'|S1], Precedence, Answer, S) :- 
    true :
    read_exprtl0(S1, '{}', Precedence, Answer, S).
read('{', S1, Precedence, Answer, S) :- 
    true :
    read(S1, 1200, Term, S2),
    read_expect('}', S2, S3), 
    read_exprtl0(S3, '{}'(Term), Precedence, Answer, S).
read(string(List), S0, Precedence, Answer, S) :- 
    true :
    read_exprtl0(S0, List, Precedence, Answer, S).
read(F, S0, Precedence, Answer, S) :- 
    float(F) :
    read_exprtl0(S0, F, Precedence, Answer, S).
read(Token, S0, _, _, _) :-
    true :
    read_syntax_error([Token,'cannot start an expression'], S0).
 

%   read_args(+Tokens, -TermList, -LeftOver)
%   parses {',' expr(999)} ')' and returns a list of terms.
 
read_args([','|S1], Term, S) :-
    true :
    read(S1, 999, Arg, S2),
    Term = [Arg|Rest],
    read_args(S2,Rest,S).
read_args([')'|S1],Term,S):-
    true :
    Term = [],
    S = S1.
read_args(S,_,_):-
    true :
    read_syntax_error([', or ) expected in arguments'],S).

%   read_list(+Tokens, -TermList, -LeftOver)
%   parses {',' expr(999)} ['|' expr(999)] ']' and returns a list of terms.
 
read_list([','|S1],Term,S) :-
    true :
    read(S1,999,Arg,S2),
    Term = [Arg|Rest],
    read_list(S2,Rest,S).
read_list(['|'|S1],Term,S):-
    true :
    read(S1,999,Term,S2),
    read_expect(']', S2, S).
read_list([']'|S1],Term,S):-
    true :
    Term = [],
    S=S1.
read_list(S, _, _) :-
    true :
    read_syntax_error([', | or ] expected in list'], S).
 
%   read_aft_pref_op(+Op, +Prec, +ArgPrec, +Rest, +Precedence, -Ans, -LeftOver)
 
/*
:- mode(read_aft_pref_op,7,[nv,nv,nv,nv,nv,d,d]).
*/ 

read_aft_pref_op(Op, Oprec, Aprec, S0, Precedence, _, _) :-
    Precedence < Oprec :
    read_syntax_error(['prefix operator',Op,'in context with precedence '
                        ,Precedence], S0).
read_aft_pref_op(Op, Oprec, Aprec, S0, Precedence, Answer, S) :-
    read_peepop(S0, S1),
    read_prefix_is_atom(S1, Oprec) : % can't cut but would like to
    read_exprtl(S1, Oprec, Op, Precedence, Answer, S).
read_aft_pref_op(Op, Oprec, Aprec, S1, Precedence, Answer, S) :-
    true :
    read(S1, Aprec, Arg, S2),
    univ(Term,[Op,Arg]), 
    read_exprtl(S2, Oprec, Term, Precedence, Answer, S).

 
%   The next clause fixes a bug concerning "mop dop(1,2)" where
%   mop is monadic and dop dyadic with higher Prolog priority.
 
read_peepop([atom(F),'('|S1], S):-
    true :
    S=[atom(F),'('|S1].
read_peepop([atom(F)|S1], S):-
    read_infixop(F, L, P, R) :
    S=[infixop(F,L,P,R)|S1].
read_peepop([atom(F)|S1], S):-
    read_postfixop(F, L, P) :
    S= [postfixop(F,L,P)|S1].
read_peepop(S0, S):-
    true :
    S=S0.
 
%   read_prefix_is_atom(+TokenList, +Precedence)
%   is true when the right context TokenList of a prefix operator
%   of result precedence Precedence forces it to be treated as an
%   atom, e.g. (- = X), p(-), [+], and so on.
 
read_prefix_is_atom([infixop(_,L,_,_)|_], P) :-
    L >= P : true.
read_prefix_is_atom([postfixop(_,L,_,_)|_], P) :-
    L >= P : true.
read_prefix_is_atom([')'|_], P) :-
    true : true.
read_prefix_is_atom([']'|_], P) :-
    true : true.
read_prefix_is_atom(['}'|_], P) :-
    true : true.
read_prefix_is_atom(['|'|_], P) :-
    1100 >= P : true.
read_prefix_is_atom([','|_], P) :-
    1000 >= P : true.
read_prefix_is_atom([], P) :-
    true : true.
 
%   read_exprtl0(+Tokens, +Term, +Prec, -Answer, -LeftOver)
%   is called by read/4 after it has read a primary (the Term).
%   It checks for following postfix or infix operators.

read_exprtl0([atom(F)|S1], Term, Precedence, Answer, S) :-
    read_ambigop(F, L1, O1, R1, L2, O2) :
    read_exprtl([infixop(F,L1,O1,R1)|S1],0,Term,Precedence,Answer,S),!,
    true.
read_exprtl0([atom(F)|S1], Term, Precedence, Answer, S) :-
    read_ambigop(F, L1, O1, R1, L2, O2) :
    read_exprtl([postfixop(F,L2,O2) |S1],0,Term,Precedence,Answer,S).
read_exprtl0([atom(F)|S1], Term, Precedence, Answer, S) :-
    read_infixop(F, L1, O1, R1) :
    read_exprtl([infixop(F,L1,O1,R1)|S1],0,Term,Precedence,Answer,S).
read_exprtl0([atom(F)|S1], Term, Precedence, Answer, S) :-
    read_postfixop(F, L2, O2) :
    read_exprtl([postfixop(F,L2,O2)|S1], 0, Term, Precedence, Answer, S).
read_exprtl0([','|S1], Term, Precedence, Answer, S) :-
    Precedence >= 1000 :
    read(S1, 1000, Next, S2),
    read_exprtl(S2, 1000, (Term,Next), Precedence, Answer, S).
read_exprtl0(['|'|S1], Term, Precedence, Answer, S) :-
    Precedence >= 1100 :
    read(S1, 1100, Next, S2),
    read_exprtl(S2, 1100, (Term;Next), Precedence, Answer, S).
read_exprtl0([Thing|S1], _, _, _, _) :-
    read_cfexpr(Thing, Culprit) :
    read_syntax_error([Culprit,follows,expression], [Thing|S1]).
read_exprtl0(S, Term, _, Term1, S1):-
    true :
    Term1=Term,
    S1=S.

/*:- mode(read_cfexpr,2,[nv,d]).*/
 
read_cfexpr(atom(_),      T):-true : T=atom.
read_cfexpr(var(_,_),     T):-true : T=variable.
read_cfexpr(number(_),    T):-true : T=number.
read_cfexpr(string(_),    T):-true : T=string.
read_cfexpr('$float'(_,_,_), T):-true : T='$float'.
read_cfexpr(' (',         T):-true : T=bracket.
read_cfexpr('(',          T):-true : T=bracket.
read_cfexpr('[',          T):-true : T=bracket.
read_cfexpr('{',          T):-true : T=bracket.
 
/* 
:- mode(read_exprtl,6,[nv,d,d,c,d,d]).
*/
read_exprtl([infixop(F,L,O,R)|S1], C, Term, Precedence, Answer, S) :-
    Precedence >= O, C =< L :
    read(S1, R, Other, S2),
    Expr =.. [F,Term,Other],
    read_exprtl(S2, O, Expr, Precedence, Answer, S).
read_exprtl([postfixop(F,L,O)|S1], C, Term, Precedence, Answer, S) :-
    Precedence >= O, C =< L :
    Expr =.. [F,Term],
    read_peepop(S1, S2),
    read_exprtl(S2, O, Expr, Precedence, Answer, S).
read_exprtl([','|S1], C, Term, Precedence, Answer, S) :-
    Precedence >= 1000, C < 1000 :
    read(S1, 1000, Next, S2),
    read_exprtl(S2, 1000, (Term,Next), Precedence, Answer, S).
read_exprtl(['|'|S1], C, Term, Precedence, Answer, S) :-
    Precedence >= 1100, C < 1100 :
    read(S1, 1100, Next, S2),
    read_exprtl(S2, 1100, (Term;Next), Precedence, Answer, S).
read_exprtl(S, _, Term, _, Term1, S1):-
    true :
    Term1 = Term,
    S1 = S.
 
%   This business of syntax errors is tricky.  When an error is detected,
%   we have to write out a message.  We also have to note how far it was
%   to the end of the input, and for this we are obliged to use the data-
%   base.  Then we fail all the way back to read(), and that prints the
%   input list with a marker where the error was noticed.  If subgoal_of
%   were available in compiled code we could use that to find the input
%   list without hacking the data base.  The really hairy thing is that
%   the original code noted a possible error and backtracked on, so that
%   what looked at first sight like an error sometimes turned out to be
%   a wrong decision by the parser.  This version of the parser makes
%   fewer wrong decisions, and  goal was to get it to do no backtracking
%   at all.  This goal has not yet been met, and it will still occasionally
%   report an error message and then decide that it is happy with the input
%   after all.  Sorry about that.
 
/*  Modified by Saua Debray, Nov 18 1986, to use SB-Prolog's database
    facilities to print out error messages.                             */
 
read_syntax_error(Message, List) :-
    true :
/*    print('**'), print_list(Message), */
    length(List,Length),
    read_syntax_error1(Length).

read_syntax_error1(Length):-
    isglobal('_$synerr',0) :
    fail.
read_syntax_error1(Length):-
    true :
    global_create('_$synerr',0,Length),
    fail.

read_syntax_error(List) :-
    true :
    print('*** syntax error ***'), nl,
    global_get('_$synerr',0,AfterError),
    global_del('_$synerr',0),
    length(List,Length),
    BeforeError is Length - AfterError,
    '$read_display_list'(List,BeforeError), 
    fail.

'$read_display_list'(X, 0) :-
     true :
     print('<<here>> '),
     '$read_display_list'(X, 99999).
'$read_display_list'([Head|Tail], BeforeError) :-
    true :
    print_token(Head),
    print(' '),
    Left is BeforeError-1,
    '$read_display_list'(Tail, Left).
'$read_display_list'([], _) :-
        true : nl.
 
print_list([]) :- 
    true :
    nl.
print_list([Head|Tail]) :-
    true :
    tab(1),
    print_token(Head),
    print_list(Tail).
 
print_token(atom(X))    :- true : print(X).
print_token(var(V,X))   :- true : print(X).
print_token(number(X)) :-  true : print(X).
print_token(string(X))  :- true : print(X).
print_token(X)          :- true : print(X).
 
 
/*
%   read_tokens(TokenList, Dictionary)
%   returns a list of tokens.  It is needed to "prime" read_tokens/2
%   with the initial blank, and to check for end of file.  The
%   Dictionary is a list of AtomName=Variable pairs in no particular order.
%   The way end of file is handled is that everything else FAILS when it
%   hits character "-1", sometimes printing a warning.  It might have been
%   an idea to return the atom 'end_of_file' instead of the same token list
%   that you'd have got from reading "end_of_file. ", but (1) this file is
%   for compatibility, and (b) there are good practical reasons for wanting
%   this behaviour. */
 
read_tokens(TokenList, Dictionary) :-
    true :
    b_NEXT_TOKEN_ff(Type,Value),
    read_insert_token(Type,Value,Dict,ListOfTokens),
    closetail(Dict),
    Dictionary = Dict,              %  unify explicitly so we read and 
    TokenList = ListOfTokens.       %  then check even with filled in arguments
 

read_next_token(Type, Value) :- 
    true :
    b_NEXT_TOKEN_ff(Type,Value).
%    write((Type,Value)),nl.

read_insert_token(0,Val,Dict,Tokens):-		    
    true :     		% punctuation 
    Tokens = [Val | TokRest],
    b_NEXT_TOKEN_ff(Type,Value),
    read_insert_token(Type,Value,Dict,TokRest).
read_insert_token(1,Name,Dict,Tokens):-		    
    true :		        % var 
    Tokens = [var(Var,Name) | TokRest], 
    read_lookup(Dict, Name=Var),
%    write('<==lookup'),write(Dict),nl,
    b_NEXT_TOKEN_ff(Type,Value), 
    read_insert_token(Type,Value,Dict,TokRest).
read_insert_token(2,Val,Dict,Tokens):-		    
    true  :			% atom( 
    Tokens = [atom(Val),'(' | TokRest],
    b_NEXT_TOKEN_ff(Type,Value),
    read_insert_token(Type,Value,Dict,TokRest).
read_insert_token(3,Val,Dict,Tokens):-		    
    true :		        % integer
    Tokens = [number(Val) | TokRest],
    b_NEXT_TOKEN_ff(Type,Value),
    read_insert_token(Type,Value,Dict,TokRest).
read_insert_token(4,Val,Dict,Tokens):-		    
    true : 			% atom 
    Tokens = [atom(Val) | TokRest],
    b_NEXT_TOKEN_ff(Type,Value),
    read_insert_token(Type,Value,Dict,TokRest).
read_insert_token(5,Val,Dict,Tokens):-		    
    true :   			% end of clause 
    Tokens = [].
read_insert_token(6,Val,Dict,Tokens):-		    
    true : 			% uscore 
    Tokens = [var(_,Val) | TokRest],
    b_NEXT_TOKEN_ff(Type,Value),
    read_insert_token(Type,Value,Dict,TokRest).
read_insert_token(7,Val,Dict,Tokens):-		    
    true :			% semicolon 
    Tokens = [atom((';')) | TokRest],
    b_NEXT_TOKEN_ff(Type,Value),
    read_insert_token(Type,Value,Dict,TokRest).
read_insert_token(8,Val,Dict,Tokens):-		    
    true :			% end of file 
    Tokens = [atom(end_of_file)].
read_insert_token(9,Val,Dict,Tokens):-		    
    true :			% string 
    Tokens = [string(Val) | TokRest],
    b_NEXT_TOKEN_ff(Type,Value),
    read_insert_token(Type,Value,Dict,TokRest).
read_insert_token(10,Val,Dict,Tokens):-		    
    true  :			% float
    Tokens = [Val| TokRest],
    b_NEXT_TOKEN_ff(Type,Value),
    read_insert_token(Type,Value,Dict,TokRest).

/* 
%   read_lookup is identical to memberchk except for argument order and
%   mode declaration.
*/

read_lookup(L,X):-
    var(L) :
    L=[X|_].  
read_lookup([X=Y|_], X=Y1) :- true : Y=Y1.
read_lookup([_|T], X) :- 
    true :
    read_lookup(T, X).
/*
read_lookup(L,Name,Val):-
    var(L) :
    L:=[Name=Val|_].  
read_lookup([Name1=Val|_], Name,Val1) :- Name==Name1 : Val1=Val.
read_lookup([_|T], Name,Val) :- 
    true :
    read_lookup(T, Name,Val).
*/
/*  This is the file of operators for read/1 and read/2.  It really
    belongs in the file $read.P, but is here so that the assembler won't
    optimize away the indirect linkages to it.  This allows op
    declarations to be handled correctly.  -- S. Debray, Dec 22, 1987.  */

read_curr_op(Prec,Assoc,Name):-
    isglobal('$dynamic_op',3),
    global_get('$dynamic_op',3,Ops),
    op_dynamically_defined(Prec1,Assoc,Name,Ops) :
    Prec=Prec1.
read_curr_op(Prec,Assoc,Name):-
    true :
    read_curr_op1(Prec,Assoc,Name).

op_dynamically_defined(Prec,Assoc,Name,[op(Prec1,Assoc,Name)|Ops]):-
    true :
    Prec=Prec1.
op_dynamically_defined(Prec,Assoc,Name,[_|Ops]):-
    true :
    op_dynamically_defined(Prec,Assoc,Name,Ops).
    
read_curr_op1(Prec,XFX,(':-')):-xfx<=XFX : Prec=1200.
read_curr_op1(Prec,XFX,('-->')):-xfx<=XFX : Prec=1200.
read_curr_op1(Prec,FX,(':-')):-fx<=FX : Prec=1200.
read_curr_op1(Prec,FX,('?-')):-fx<=FX : Prec=1200.
read_curr_op1(Prec,XFX,('::-')):-xfx<=XFX : Prec=1198.
read_curr_op1(Prec,XFY,(':')):- xfy<=XFY : Prec=1150.
read_curr_op1(Prec,XFY,('?')):-xfy<=XFY : Prec=1150.
read_curr_op1(Prec,XFY,';'):-xfy<=XFY : Prec=1100.
read_curr_op1(Prec,XFY,'->'):-xfy<=XFY : Prec=1050.
read_curr_op1(Prec,XFY,','):-xfy<=XFY : Prec=1000.
read_curr_op1(Prec,FY,not):-fy<=FY : Prec=900.
read_curr_op1(Prec,FY,'\+'):-fy<=FY : Prec=900.
read_curr_op1(Prec,FY,spy):-fy<=FY : Prec=900.
read_curr_op1(Prec,FY,nospy):-fy<=FY : Prec=900.
read_curr_op1(Prec,FY,(mode)):-fy<=FY : Prec=1150.
read_curr_op1(Prec,FY,(public)):-fy<=FY : Prec=1150.
read_curr_op1(Prec,FY,(dynamic)):-fy<=FY : Prec=1150.
read_curr_op1(Prec,XFX,in):-xfx<=XFX : Prec=700.
%read_curr_op1(Prec,XFX,'::'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,':='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'<='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,is):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'=..'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'?='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'\='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'=='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'\=='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'@<'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'@>'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'@=<'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'@>='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'=:='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'=\='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'<'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'>'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'=<'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'>='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'#='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'##'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'#\='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'#<'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'#>'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'#=<'):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFX,'#>='):-xfx<=XFX : Prec=700.
read_curr_op1(Prec,XFY,'.'):-xfy<=XFY : Prec=661.	/* !! */
read_curr_op1(Prec,YFX,'+'):-yfx<=YFX : Prec=500.
read_curr_op1(Prec,YFX,'-'):-yfx<=YFX : Prec=500.
read_curr_op1(Prec,YFX,'/\'):-yfx<=YFX : Prec=500.
read_curr_op1(Prec,YFX,'\/'):-yfx<=YFX : Prec=500.
read_curr_op1(Prec,FX,'+'):-fx<=FX : Prec=500.
read_curr_op1(Prec,FX,'-'):-fx<=FX : Prec=500.
read_curr_op1(Prec,FX,'\'):-fx<=FX : Prec=500.
read_curr_op1(Prec,XFX,'..'):-xfx<=XFX : Prec=500.
read_curr_op1(Prec,YFX,'*'):-yfx<=YFX : Prec=400.
read_curr_op1(Prec,YFX,'/'):-yfx<=YFX : Prec=400.
read_curr_op1(Prec,YFX,'//'):-yfx<=YFX : Prec=400.
read_curr_op1(Prec,YFX,div):-yfx<=YFX : Prec=400.
read_curr_op1(Prec,YFX,'<<'):-yfx<=YFX : Prec=400.
read_curr_op1(Prec,YFX,'>>'):-yfx<=YFX : Prec=400.
read_curr_op1(Prec,XFX,mod):-xfx<=XFX : Prec=400.
read_curr_op1(Prec,XFX,'**'):-xfx<=XFX : Prec=300.
read_curr_op1(Prec,XFY,'^'):-xfy<=XFY : Prec=200.

predefined_ops(Ops):-
    Ops:=[
     op(1200,xfx,:-),
     op(1200,xfx,-->),
     op(1200,fx,:-),
     op(1200,fx,?-),
     op(1198,xfx,::-),
     op(1150,xfy,:),
     op(1150,xfy,?),
     op(1100,xfy,;),
     op(1050,xfy,->),
     op(1000,xfy,','),
     op(900,fy,not),
     op(900,fy,\+),
     op(900,fy,spy),
     op(900,fy,nospy),
     op(1150,fy,mode),
     op(1150,fy,public),
     op(1150,fy,dynamic),
     op(700,xfx,in),
     op(700,xfx,=),
     op(700,xfx,:=),
     op(700,xfx,=),
     op(700,xfx,is),
     op(700,xfx,=..),
     op(700,xfx,?=),
     op(700,xfx,\=),
     op(700,xfx,==),
     op(700,xfx,\==),
     op(700,xfx,@<),
     op(700,xfx,@>),
     op(700,xfx,@=<),
     op(700,xfx,@>=),
     op(700,xfx,=:=),
     op(700,xfx,=\=),
     op(700,xfx,<),
     op(700,xfx,>),
     op(700,xfx,=<),
     op(700,xfx,>=),
     op(700,xfx,#=),
     op(700,xfx,##),
     op(700,xfx,#\=),
     op(700,xfx,#<),
     op(700,xfx,#>),
     op(700,xfx,#=<),
     op(700,xfx,#>=),
     op(661,xfy,.),
     op(500,yfx,+),
     op(500,yfx,-),
     op(500,yfx,/\),
     op(500,yfx,\/),
     op(500,fx,+),
     op(500,fx,-),
     op(500,fx,\),
     op(500,xfx,..),
     op(400,yfx,*),
     op(400,yfx,/),
     op(400,yfx,//),
     op(400,yfx,div),
     op(400,yfx,<<),
     op(400,yfx,>>),
     op(400,xfx,mod),
     op(300,xfx,**),
     op(200,xfy,^)].
