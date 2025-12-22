%   File   : route.pl
%   Author : Neng-Fa ZHOU
%   Date   : 1993
%   Modified: 1995 by Serge Le Huitouze & Neng-Fa Zhou
%   Purpose: Forward chekcing algorithm for channel routing

go:-go1.

go1:-
    cputime(Start),
    N=72,L=1,T=28,C=174,
    build_tables(N,L,T,Vars),
    shrink_domain(Vars,L,T),
    route(L,Vars,1534,Start),!,
    VVars=..[dvars|Vars],
    cputime(End),
    output(L,T,C,VVars),
    Time is End-Start,
    write('%execution time go1='), write(Time), write(' milliseconds'),nl,
    told.

go2:-
    cputime(Start),
    N=72,L=2,T=11,C=174,
    build_tables(N,L,T,Vars),
    route(L,Vars,1534,Start),!,
    VVars=..[dvars|Vars],
    cputime(End),
    output(L,T,C,VVars),
    Time is End-Start,
    write('%execution time go2='), write(Time), write(' milliseconds'),nl,
    told.

go3:-
    cputime(Start),
    N=72,L=3,T=7,C=174,
    build_tables(N,L,T,Vars),
    route(L,Vars,1534,Start),!,
    VVars=..[dvars|Vars],
    cputime(End),
    output(L,T,C,VVars),
    Time is End-Start,
    write('%execution time go2='), write(Time), write(' milliseconds'),nl,
    told.

go1(Order):-
    cputime(Start),
    N=72,L=1,T=40,C=174,
    build_tables(N,L,T,Vars),
    optimal_route(N,L,T,T,C,Vars,Order,Start).

go2(Order):-
    cputime(Start),
    N=72,L=2,T=20,C=174,
    build_tables(N,L,T,Vars),
    optimal_route(N,L,T,T,C,Vars,Order,Start).

go3(Order):-
    cputime(Start),
    N=72,L=3,T=14,C=174,
    build_tables(N,L,T,Vars),
    optimal_route(N,L,T,T,C,Vars,Order,Start).

build_tables(N,L,T,DVars):-
    bt(domain(1..N,1..L,1..T),true),
    generate_vars(N,AllVars),
    bt(below(1..N,1..N),false),
    bt(above(1..N,1..N),false),
    build_graph_v(1,N,AllVars),
    bt(gh(1..N,1..N),false),
    build_graph_h(1,N,AllVars),
    AllVars=..[_|DVars].

optimal_route(N,L,T0,T,C,Vars,Order,Start):-
    write('Current try: Tracks='),write(T0),nl,
    T1 is T0+1,
    initialize_domains(N,L,T1,T),
    (L=:=1->shrink_domain(Vars,L,T0);
     true),
    not(not(route(L,Vars,Order,Start))),
    cputime(End),
    Time is End-Start,
    write(' found in '),write(Time), write(ms),nl,
    fail.
optimal_route(N,L,T0,T,C,Vars,Order,Start):-
    T0>0,
    T1 is T0-1,
    optimal_route(N,L,T1,T,C,Vars,Order,Start).

initialize_domains(N,L,T0,T):-
    N>0 :
    initialize_domains1(N,L,T0,T),
    N1 is N-1,
    initialize_domains(N1,L,T0,T).
initialize_domains(N,L,T0,T):-true : true.

initialize_domains1(N,L,T0,T):-
    L>0 :
    exclude_tracks_upto(N,L,T0,T),
    L1 is L-1,
    initialize_domains1(N,L1,T0,T).
initialize_domains1(N,L,T0,T):-
    true : true.

generate_vars(N,AllVars):-
    functor(AllVars,dvars,N),
    build_vars(1,N,AllVars).

build_vars(N0,N,AllVars):-
    N0>N : true.
build_vars(N0,N,AllVars):-
    true :
    net(N0,Terminals),
    head_net(Terminals,Head),
    tail_net(Terminals,Tail),
    Var:=dvar(N0,Head,Tail,Terminals,Layer,Track,Depth,Height),
    arg(N0,AllVars,Var),
    N1 is N0+1,
    build_vars(N1,N,AllVars).

head_field(Var,Head):-
    arg(2,Var,Head).

tail_field(Var,Tail):-
    arg(3,Var,Tail).

terms_field(Var,Terms):-
    arg(4,Var,Terms).

layer_field(Var,Layer):-
    arg(5,Var,Layer).

track_field(Var,Track):-
    arg(6,Var,Track).

depth_field(Var,Depth):-
    arg(7,Var,Depth).

height_field(Var,Depth):-
    arg(8,Var,Depth).

build_graph_v(N0,N,AllVars):-
    N0>N :
    compute_depth(1,N,AllVars),
    compute_height(1,N,AllVars).
build_graph_v(N0,N,AllVars):-
    true :
    N1 is N0+1,
    build_graph_v(N0,N1,N,AllVars),
    build_graph_v(N1,N,AllVars).

build_graph_v(N0,N1,N,AllVars):-
    N1>N : true.
build_graph_v(N0,N1,N,AllVars):-
    arg(N0,AllVars,V0),
    arg(N1,AllVars,V1),
    below1(V0,V1) :
    bt_set_true(below(N0,N1)),
    bt_set_true(above(N1,N0)),
    N2 is N1+1,
    build_graph_v(N0,N2,N,AllVars).
build_graph_v(N0,N1,N,AllVars):-
    arg(N0,AllVars,V0),
    arg(N1,AllVars,V1),
    below1(V1,V0) :
    bt_set_true(below(N1,N0)),
    bt_set_true(above(N0,N1)),
    N2 is N1+1,
    build_graph_v(N0,N2,N,AllVars).
build_graph_v(N0,N1,N,AllVars):-
    true :
    N2 is N1+1,
    build_graph_v(N0,N2,N,AllVars).

compute_depth(N0,N,AllVars):-
    N0>N : true.
compute_depth(N0,N,AllVars):-
    is_top(N0) :
    arg(N0,AllVars,Var),
    depth_field(Var,0),
    findall(B,bt_select(above(N0,B)),Bs),
    compute_depth(Bs,AllVars),
    N1 is N0+1,
    compute_depth(N1,N,AllVars).
compute_depth(N0,N,AllVars):-
    true :
    N1 is N0+1,
    compute_depth(N1,N,AllVars).
    
compute_depth([],AllVars):-true : true.
compute_depth([N|Ns],AllVars):-
    true :
    findall(A,bt_select(below(N,A)),As),
    maximum_depth(As,N,0,AllVars),
    compute_depth(Ns,AllVars).

maximum_depth([],N,Depth,AllVars):-
    true :
    arg(N,AllVars,Var),
    Depth1 is Depth+1,
    depth_field(Var,Depth1),
    findall(B,bt_select(above(N,B)),Bs),
    compute_depth(Bs,AllVars).
maximum_depth([A|As],N,Depth,AllVars):-
    arg(A,AllVars,Var),
    depth_field(Var,D),
    nonvar(D) :
    (D>Depth->Depth1=D; Depth1=Depth),
    maximum_depth(As,N,Depth1,AllVars).
maximum_depth([A|As],N,Depth,AllVars):-
    true : true.

compute_height(N0,N,AllVars):-
    N0>N : true.
compute_height(N0,N,AllVars):-
    is_bottom(N0) :
    arg(N0,AllVars,Var),
    height_field(Var,0),
    findall(A,bt_select(below(N0,A)),As),
    compute_height(As,AllVars),
    N1 is N0+1,
    compute_height(N1,N,AllVars).
compute_height(N0,N,AllVars):-
    true :
    N1 is N0+1,
    compute_height(N1,N,AllVars).
    
compute_height([],AllVars):-true : true.
compute_height([N|Ns],AllVars):-
    true :
    findall(B,bt_select(above(N,B)),Bs),
    maximum_height(Bs,N,0,AllVars),
    compute_height(Ns,AllVars).

maximum_height([],N,Height,AllVars):-
    true :
    arg(N,AllVars,Var),
    Height1 is Height+1,
    height_field(Var,Height1),
    findall(A,bt_select(below(N,A)),As),
    compute_height(As,AllVars).
maximum_height([A|As],N,Height,AllVars):-
    arg(A,AllVars,Var),
    height_field(Var,H),
    nonvar(H) :
    (H>Height->Height1=H;Height1=Height),
    maximum_height(As,N,Height1,AllVars).
maximum_height([A|As],N,Height,AllVars):-
    true : true.

build_graph_h(N0,N,AllVars):-
    N0>N :
    true.
build_graph_h(N0,N,AllVars):-
    true :
    build_graph_h(N0,1,N,AllVars),
    N1 is N0+1,
    build_graph_h(N1,N,AllVars).

build_graph_h(N,N0,N1,AllVars):-
    N0>N1 : true.
build_graph_h(N,N0,N1,AllVars):-
    N=\=N0,
    arg(N,AllVars,Var),
    arg(N0,AllVars,Var0),
    head_field(Var,H),
    tail_field(Var,T),
    head_field(Var0,H0),
    tail_field(Var0,T0),
    h_conflicts(H,T,H0,T0),
    bt_false(above(N0,N)),
    bt_false(above(N,N0)) :
    bt_set_true(gh(N,N0)),
    bt_set_true(gh(N0,N)),
    N2 is N0+1,
    build_graph_h(N,N2,N1,AllVars).
build_graph_h(N,N0,N1,AllVars):-
    true :
    N2 is N0+1,
    build_graph_h(N,N2,N1,AllVars).

h_conflicts(H,T,H0,T0):-
    H>=H0,H=<T0 :
    true.
h_conflicts(H,T,H0,T0):-
    H0>=H,H0=<T :
    true.

below1(V1,V2):-
    true :
    above1(V2,V1).

above1(Var1,Var2):-
    true :
    terms_field(Var1,Terms1),
    terms_field(Var2,Terms2),
    above2(Terms1,Terms2).

above2([t(K)|_],[b(K)|_]):-
    true : true.
above2(Ts1,Ts2):-
    [T1|Ts3]<=Ts1,
    [T2|Ts4]<=Ts2,
    arg(1,T1,C1),
    arg(1,T2,C2),
    C1<C2 :
    above2(Ts3,Ts2).
above2(Ts1,Ts2):-
    [T1|Ts3]<=Ts1,
    [T2|Ts4]<=Ts2 :
    above2(Ts1,Ts4).

head_net([H|_],H1):-
    true : arg(1,H,H1).

tail_net([Tail],Tail1):-
    true : arg(1,Tail,Tail1).
tail_net([_|Tail],Tail1):-
    true :
    tail_net(Tail,Tail1).


shrink_domain([],L,T):-true : true.
shrink_domain([dvar(N,Head,Tail,Terms,Layer,Track,Depth,Height)|Vars],L,T):-
    true :
    shrink_domain(N,L,T,Depth,Height),
    shrink_domain(Vars,L,T).

shrink_domain(N,L,T,Depth,Height):-
    true :
    Max is L*T-Depth+1,
    Min is Height-(L-1)*T,
    shrink_domain1(N,1,L,T,Min,Max).

shrink_domain1(N,L0,L,T,Min,Max):-
    L0>L : true.
shrink_domain1(N,L0,L,T,Min,Max):-
    true :
    exclude_tracks_upto(N,L0,Max,T),
    exclude_tracks_upto(N,L0,1,Min),
    L1 is L0+1,
    shrink_domain1(N,L1,L,T,Min,Max).
    
route(L,[],Order,Start):-true : true.
route(L,Vars,Order,Start):-
    true :
    cputime(End),
    End-Start=<1850000,
    choose(Vars,Order,dvar(N,Head,Tail,Terms,Layer,Track,Depth,Height),Rest),
    bt_select(domain(N,Layer,Track)),
%    write(p_select(domain(N,Layer,Track))),nl,
    update_v(L,N,Layer,Track),
    update_h(N,Layer,Track),
    route(L,Rest,Order,Start).

choose([Var|Vars],Order,BestVar,Rest):-
    true :
    evaluate_dvar(Order,Var,EValue),
    choose(Vars,Order,Var,EValue,BestVar,Rest).

choose([],Order,Var,EValue,BestVar,Rest):-
    true :
    BestVar=Var,
    Rest=[].
choose([Var|Vars],Order,Var1,EValue1,BestVar,Rest):-
    true :
    evaluate_dvar(Order,Var,EValue),
    compare_dvar(Var1,EValue1,Var,EValue,GoodVar,GoodEValue,BadVar),
    Rest:=[BadVar|Rest1],
    choose(Vars,Order,GoodVar,GoodEValue,BestVar,Rest1).

compare_dvar(Var1,[],Var2,EValue2,GoodVar,GoodEValue,BadVar):-
    true :
    GoodVar=Var1,
    GoodEValue=[],
    BadVar=Var2.
compare_dvar(Var1,[X|EValue1],Var2,[Y|EValue2],GoodVar,GoodEValue,BadVar):-
    X>Y :
    GoodVar=Var1,
    GoodEValue:=[X|EValue1],
    BadVar=Var2.
compare_dvar(Var1,[X|EValue1],Var2,[Y|EValue2],GoodVar,GoodEValue,BadVar):-
    X<Y :
    GoodVar=Var2,
%   a bug found by Serge Le Huitouze
%    GoodEValue:=[Y|EValue1], 
    GoodEValue:=[Y|EValue2], 
    BadVar=Var1.
compare_dvar(Var1,[X|EValue1],Var2,[Y|EValue2],GoodVar,GoodEValue,BadVar):-
    true : 
    GoodEValue:=[X|GoodEValue1],
    compare_dvar(Var1,EValue1,Var2,EValue2,GoodVar,GoodEValue1,BadVar).

is_open(N,Open):-
    bt_count(above(N,_),Count),
    Count=:=0 :
    Open=1.
is_open(N,Open):-true : Open=0.

open(N):-
    bt_count(above(N,_),Count),
    Count=:=0 :
    true.

is_top(N):-
    bt_first(below(N,_)) : fail.
is_top(N):-true : true.

is_bottom(N):-
    bt_first(above(N,_)) : fail.
is_bottom(N):-true : true.

/* Don't want to use findall/3. Hence, the code is a little long */
update_v(L,N,Layer,Track):-
    bt_first(below(N,A)) :
    update_a(L,N,A,Layer,Track).
update_v(L,N,Layer,Track):-true : true.

update_a(L,N,A,Layer,Track):-
    bt_next(below(N,A),below(N,A1)) :
    bt_set_false(below(N,A)),
    bt_set_false(above(A,N)),
    exclude_a(A,Layer,Track),
    (L=:=1->Track1 is Track+1,update_domain(A,Layer,Track1);true),
    update_a(L,N,A1,Layer,Track).
update_a(L,N,A,Layer,Track):-
    true :
    bt_set_false(below(N,A)),
    bt_set_false(above(A,N)),
    exclude_a(A,Layer,Track),
    (L=:=1->Track1 is Track+1,update_domain(A,Layer,Track1);true).

update_domain(N,Layer,Track):-
    bt_first(below(N,A)) :   % A is above N in Gv
    update_domain(N,A,Layer,Track).
update_domain(N,Layer,Track):-true : true.
    
update_domain(N,A,Layer,Track):-
    bt_next(below(N,A),below(N,A1)) :
    exclude_a(A,Layer,Track),
    Track1 is Track+1,
    update_domain(A,Layer,Track1),
    update_domain(N,A1,Layer,Track).
update_domain(N,A,Layer,Track):-
    true :
    exclude_a(A,Layer,Track),
    Track1 is Track+1,
    update_domain(A,Layer,Track1).

%   a bug found by Serge Le Huitouze
%exclude_a(N,Layer,Track):- 
%    true :
%    bt_first(domain(N,Layer,MinTrack)),
%    exclude_tracks_upto(N,Layer,MinTrack,Track),
%    bt_count(domain(N,_,_),Count),
%    Count>0.
exclude_a(N,Layer,Track):- 
    bt_first(domain(N,Layer,MinTrack)) :
    exclude_tracks_upto(N,Layer,MinTrack,Track),
    bt_count(domain(N,_,_),Count),
    Count>0.
exclude_a(N,Layer,Track):-true : true.
    
exclude_tracks_upto(N,Layer,From,To):-
    From>To :
    true.
exclude_tracks_upto(N,Layer,From,To):-
    true :
    bt_set_false(domain(N,Layer,From)),
    Next is From+1,
    exclude_tracks_upto(N,Layer,Next,To).

update_h(N,Layer,Track):-
    bt_first(gh(N,N1)) :
    update_h(N,N1,Layer,Track).
update_h(N,Layer,Track):-true : true.

update_h(N,N1,Layer,Track):-
    bt_next(gh(N,N1),gh(N,N2)) :
    bt_set_false(gh(N,N1)),
    bt_set_false(gh(N1,N)),
    bt_set_false(domain(N1,Layer,Track)),
    bt_count(domain(N1,_,_),Count),
    Count>0,
    update_h(N,N2,Layer,Track).
update_h(N,N1,Layer,Track):-
    true :
    bt_set_false(gh(N,N1)),
    bt_set_false(gh(N1,N)),
    bt_set_false(domain(N1,Layer,Track)),
    bt_count(domain(N1,_,_),Count),
    Count>0.

/************************************************************* 
1: select first open nets
2: select those nets with the smallest domains
3: select first those nets with the greatest degree in Gv 
4: select first those nets with the greatest degree in Gh
5: select first those nets lie deep in Gv
****************************************************************/
evaluate_dvar(12,Var,EValue):-
    true :
    arg(1,Var,N),
    is_open(N,Open),
    bt_count(domain(N,_,_),Count),
    Count1 is -Count,
    EValue:=[Open,Count1].
evaluate_dvar(134,Var,EValue):-
    true :
    arg(1,Var,N),
    is_open(N,Open),
    bt_count(below(N,_),Degree1),
    bt_count(gh(N,_),Degree2),
    EValue:=[Open,Degree1,Degree2].
evaluate_dvar(15,Var,EValue):-
    true :
    arg(1,Var,N),
    is_open(N,Open),
    depth_field(Var,Depth),
    EValue:=[Open,Depth].
evaluate_dvar(1234,Var,EValue):-
    true :
    arg(1,Var,N),
    is_open(N,Open),
    bt_count(domain(N,_,_),Count),
    Count1 is -Count,
    bt_count(below(N,_),Degree1),
    bt_count(gh(N,_),Degree2),
    EValue:=[Open,Count1,Degree1,Degree2].
evaluate_dvar(1534,Var,EValue):-
    true :
    arg(1,Var,N),
    is_open(N,Open),
    depth_field(Var,Depth),
    bt_count(below(N,_),Degree1),
    bt_count(gh(N,_),Degree2),
    EValue:=[Open,Depth,Degree1,Degree2].

output(MaxLayer,MaxTrack,MaxTerm,Dvars):-
    true :
    X is MaxTerm+1,
    Y is MaxLayer*(MaxTrack+3)+1,
    write_line(['\documentstyle[11pt,epsf]{article}']),
    write_line(['\topmargin=-0.5cm']),
    write_line(['\oddsidemargin=-1.5cm']),
    write_line(['\textheight=23cm \textwidth=30cm']),
    write_line(['\begin{document}']),
    write_line(['\begin{figure}[hbt]']),
    write_line(['\setlength{\unitlength}{1.5mm}']),
    write_line(['\begin','{',picture,'}','(',X,',',Y,')','(',0,',',0,')']),
    output_rows(MaxLayer,MaxTrack,MaxTerm),
    functor(Dvars,F,N),
    output_nets(MaxTrack,Dvars,1,N),
    write_line(['\end{picture}']),
    write_line(['\end{figure}']),
    write_line(['\end{document}']).

output_rows(Layer,MaxTrack,MaxTerm):-
    Layer=<0 :
    true.
output_rows(Layer,MaxTrack,MaxTerm):-
    true :
    Top is Layer*(MaxTrack+3),
    Bottom is (Layer-1)*(MaxTrack+3)+2,
    Len is MaxTerm+1,
    write_line(['\put','(',0,',',Top,')','{\line(1,0){',Len,'}}']),
    write_line(['\multiput(1,',Top,')(1,0){',MaxTerm,'}{\circle*{.2}}']),
    write_line(['\put','(',0,',',Bottom,')','{\line(1,0){',Len,'}}']),
    write_line(['\multiput(1,',Bottom,')(1,0){',MaxTerm,'}{\circle*{.2}}']),
    Layer1 is Layer-1,
    output_rows(Layer1,MaxTrack,MaxTerm).

output_nets(MaxTrack,Dvars,N0,N):-
    N0>N :
    true.
output_nets(MaxTrack,Dvars,N0,N):-
    true :
    arg(N0,Dvars,Dvar),
    Dvar=dvar(N0,Head,Tail,Terms,Layer,Track,Depth,Height),
    Y is (Layer-1)*(MaxTrack+3)+2+Track,
    Length is Tail-Head,
    write_line(['\put(',Head,',',Y,'){\line(1,0){',Length,'}}']),
    Top is Layer*(MaxTrack+3),
    Bottom is (Layer-1)*(MaxTrack+3)+2,
    Top_len is MaxTrack-Track+1,
    output_terminals(Top_len,Track,Y,Terms),
    N1 is N0+1,
    output_nets(MaxTrack,Dvars,N1,N).

output_terminals(Top_len,Bottom_len,Y,[]):-
    true : true.
output_terminals(Top_len,Bottom_len,Y,[t(X)|Terminals]):-
    true :
    (X=:=0->true;
    write_line(['\put(',X,',',Y,'){\line(0,1){',Top_len,'}}']),
    write_line(['\put(',X,',',Y,'){\circle*{0.2}}'])),
    output_terminals(Top_len,Bottom_len,Y,Terminals).
output_terminals(Top_len,Bottom_len,Y,[b(X)|Terminals]):-
    true :
    (X=:=0->true;
     write_line(['\put(',X,',',Y,'){\line(0,-1){',Bottom_len,'}}']),
     write_line(['\put(',X,',',Y,'){\circle*{0.2}}'])),
    output_terminals(Top_len,Bottom_len,Y,Terminals).

write_line([]):-
    true :
    nl.
write_line([X|L]):-
    true :
    write(X),
    write_line(L).

net(1,N):-true : N:=[t(5),t(28)].
net(2,N):-true : N:=[t(39),t(67)].
net(3,N):-true : N:=[t(74),t(117)].
net(4,N):-true : N:=[b(145),t(151)].
net(5,N):-true : N:=[t(161),t(163)].
net(6,N):-true : N:=[b(62),t(77)].
net(7,N):-true : N:=[t(78),t(82)].
net(8,N):-true : N:=[b(90),t(110),b(118),t(123)].
net(9,N):-true : N:=[t(139),t(141),t(144),b(151),t(174)].
net(10,N):-true : N:=[t(106),t(130),t(132),b(161),t(168)].
net(11,N):-true : N:=[t(70),t(98),t(100)].
net(12,N):-true : N:=[t(109),t(131),t(135),b(141),t(153),t(155),t(171)].
net(13,N):-true : N:=[t(24),b(37),t(53),b(55),t(60),t(92),b(110)].
net(14,N):-true : N:=[b(117),t(166)].
net(15,N):-true : N:=[t(12),t(19)].
net(16,N):-true : N:=[t(22),b(39),t(51),t(58),t(94),b(97),b(106),b(108),b(135),b(144),b(155),b(166)].
net(17,N):-true : N:=[t(6),t(13),b(22),t(30),t(34),t(36),t(40)].
net(18,N):-true : N:=[b(78),t(147),t(149)].
net(19,N):-true : N:=[t(159),b(165)].
net(20,N):-true : N:=[t(0),t(21),b(40),t(48),t(50),t(57),t(95)].
net(21,N):-true : N:=[b(98),t(119)].
net(22,N):-true : N:=[t(120),t(154),t(156)].
net(23,N):-true : N:=[t(2),b(13)].
net(24,N):-true : N:=[t(20),b(57),t(68),t(76),t(111),b(119),t(122)].
net(25,N):-true : N:=[t(128),b(149),b(160),t(167)].
net(26,N):-true : N:=[b(2),b(5),t(11),t(14),t(46),t(49)].
net(27,N):-true : N:=[t(66),b(70)].
net(28,N):-true : N:=[b(95),t(105),b(113),t(124),b(128)].
net(29,N):-true : N:=[t(138),t(140)].
net(30,N):-true : N:=[t(7),b(14)].
net(31,N):-true : N:=[b(7),b(11),t(15),t(16),b(19)].
net(32,N):-true : N:=[t(23),b(24)].
net(33,N):-true : N:=[b(66),b(68),t(83),b(92),t(99),t(101),b(102)].
net(34,N):-true : N:=[t(3),b(16),b(21),b(32),b(58),t(69),t(75),b(77),t(112),b(120),t(121)].
net(35,N):-true : N:=[b(124),t(129)].
net(36,N):-true : N:=[t(134),b(140),b(150),t(162),t(164),t(173)].
net(37,N):-true : N:=[t(73),b(75)].
net(38,N):-true : N:=[t(87),b(94),b(101),t(114),t(116)].
net(39,N):-true : N:=[t(136),b(154)].
net(40,N):-true : N:=[t(44),b(60),t(65),b(73),t(79),t(104),b(112),t(125),b(129)].
net(41,N):-true : N:=[b(79),t(93)].
net(42,N):-true : N:=[b(114),t(133)].
net(43,N):-true : N:=[b(134),t(158)].
net(44,N):-true : N:=[b(65),b(74)].
net(45,N):-true : N:=[t(84),t(86),b(93),t(146),t(148)].
net(46,N):-true : N:=[t(25),b(36),t(54),t(61),t(91),b(99),b(104),b(133),b(142),b(146),b(153),b(164)].
net(47,N):-true : N:=[t(52),b(54)].
net(48,N):-true : N:=[t(1),b(50),b(52)].
net(49,N):-true : N:=[b(1),t(8),t(29),t(41),b(44),b(46),t(63)].
net(50,N):-true : N:=[t(33),t(35)].
net(51,N):-true : N:=[t(38),t(45),b(61),t(71),b(86)].
net(52,N):-true : N:=[t(127),t(143),b(159)].
net(53,N):-true : N:=[t(10),t(27),b(29),t(43)].
net(54,N):-true : N:=[t(47),b(67),b(71),t(81),b(82),b(84),t(89),b(91)].
net(55,N):-true : N:=[b(127),t(172)].
net(56,N):-true : N:=[b(6),b(10),t(18)].
net(57,N):-true : N:=[t(31),b(38)].
net(58,N):-true : N:=[b(41),t(59)].
net(59,N):-true : N:=[b(63),b(69),t(72),b(87)].
net(60,N):-true : N:=[t(88),b(89)].
net(61,N):-true : N:=[t(96),b(105)].
net(62,N):-true : N:=[t(4),b(15),b(20),b(31),b(59),t(64),b(72),t(80),t(103),b(111),t(126),b(130)].
net(63,N):-true : N:=[b(138),b(168),t(170)].
net(64,N):-true : N:=[b(4),t(9),t(42),b(49),b(51),t(56)].
net(65,N):-true : N:=[b(64),t(85),b(88)].
net(66,N):-true : N:=[b(158),t(169)].
net(67,N):-true : N:=[b(3),b(9),b(12),t(17)].
net(68,N):-true : N:=[b(23),b(43),b(45)].
net(69,N):-true : N:=[b(56),b(81),b(83)].
net(70,N):-true : N:=[b(96),b(107),b(109),b(136),b(143),b(156),b(167)].
net(71,N):-true : N:=[b(8),b(17)].
net(72,N):-true : N:=[b(18),b(26),b(28)].




