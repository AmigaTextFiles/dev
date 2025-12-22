%   File   : color.pl
%   Author : Neng-Fa ZHOU
%   Date   : 1992
%   Purpose: Forward chekcing algorithm for coloring Gardner's map
:-determinate([bt/2,length/2,neighbors/2]).

go :- true :
    cputime(Start),
    bt(domain(1..110,[red,white,blue,black]),true),
    functor(Vs,vars,110),
    build_vars(110,Vs),
    Vs=..[_|Vars],
    solve(Vars),
    cputime(End),
    T is End-Start,
    write('%execution time ='), write(T), write(' milliseconds'),nl,
    write_solution(Vars),nl.

build_vars(N,Vs):-
    N=<0 : true.
build_vars(N,Vs):-
    true :
    neighbors(N,Neibs),
    length(Neibs,D),
    vertex_to_vars(Neibs,Vs,VarNeibs),
    arg(N,Vs,dvar(N,C,D,VarNeibs)),
    N1 is N-1,
    build_vars(N1,Vs).

vertex_to_vars([],_,L):-
    true : L=[].
vertex_to_vars([E|Es],Vs,L):-
    true :
    arg(E,Vs,V),
    L:=[V|L1],
    vertex_to_vars(Es,Vs,L1).

write_solution([]):-true : true.
write_solution([dvar(V,C,D,Neibs)|Vars]):-
    true :
    write((V,C)),nl,
    write_solution(Vars).

solve([]):-true : true.
solve(Vars):-
    true :
    color_choose(Vars,dvar(V,C,D,Neibs),Rest),
    bt_select(domain(V,C)),
    color_exclude(Neibs,C),
    solve(Rest).


color_exclude([],_):-
    true : true.
color_exclude([dvar(V,C1,D,Neibs)|Vars],C):-
    nonvar(C1) :
    color_exclude(Vars,C).
color_exclude([dvar(V,C1,D,Neibs)|Vars],C):-
    true :
    bt_set_false(domain(V,C)),
    bt_count(domain(V,_),Count),
    Count>0,
    color_exclude(Vars,C).

color_choose([Var|Vars],Var1,Rest):-
    dvar(V,C,D,Neibs)<=Var :
    bt_count(domain(V,_),Count),
    color_choose(Vars,Count,D,Var,Var1,Rest).

color_choose([],Count,D,Var,Var1,Rest):-
    true :
    Var=Var1,
    Rest=[].
color_choose([Var|Vars],Count1,D1,Var1,Var2,Rest):-
    dvar(V,C,D,Neibs)<=Var :
    bt_count(domain(V,_),Count),
    color_choose1(Vars,Count1,D1,Var1,Var2,Rest,Count,D,Var).

color_choose1(Vars,Count1,D1,Var1,Var2,Rest,Count,D,Var):-
    Count<Count1 :
    Rest:=[Var1|Rest1],
    color_choose(Vars,Count,D,Var,Var2,Rest1).
color_choose1(Vars,Count1,D1,Var1,Var2,Rest,Count,D,Var):-
    Count>Count1 :
    Rest:=[Var|Rest1],
    color_choose(Vars,Count1,D1,Var1,Var2,Rest1).
color_choose1(Vars,Count1,D1,Var1,Var2,Rest,Count,D,Var):-
    D>D1 :
    Rest:=[Var1|Rest1],
    color_choose(Vars,Count,D,Var,Var2,Rest1).
color_choose1(Vars,Count1,D1,Var1,Var2,Rest,Count,D,Var):-
    true :
    Rest:=[Var|Rest1],
    color_choose(Vars,Count1,D1,Var1,Var2,Rest1).

neighbors(1,_1448440):-true : _1448440 := [2,3,4,5,6,7,8,9,10,11,20,73,109,110].
neighbors(2,_1449472):-true : _1449472 := [1,3,12,57,102,103,104,105,106,110].
neighbors(3,_1450344):-true : _1450344 := [1,2,4,12,13].
neighbors(4,_1451216):-true : _1451216 := [1,3,5,13,14].
neighbors(5,_1452088):-true : _1452088 := [1,4,6,14,15].
neighbors(6,_1452960):-true : _1452960 := [1,5,7,15,16].
neighbors(7,_1453832):-true : _1453832 := [1,6,8,16,17].
neighbors(8,_1454704):-true : _1454704 := [1,7,9,17,18].
neighbors(9,_1455576):-true : _1455576 := [1,8,10,18,19].
neighbors(10,_1456448):-true : _1456448 := [1,9,11,19,20].
neighbors(11,_1457256):-true : _1457256 := [1,10,20].
neighbors(12,_1458160):-true : _1458160 := [2,3,13,21,57,58].
neighbors(13,_1459064):-true : _1459064 := [3,4,12,14,21,22].
neighbors(14,_1459968):-true : _1459968 := [4,5,13,15,22,23].
neighbors(15,_1460872):-true : _1460872 := [5,6,14,16,23,24].
neighbors(16,_1461776):-true : _1461776 := [6,7,15,17,24,25].
neighbors(17,_1462680):-true : _1462680 := [7,8,16,18,25,26].
neighbors(18,_1463584):-true : _1463584 := [8,9,17,19,26,27].
neighbors(19,_1464488):-true : _1464488 := [9,10,18,20,27,28].
neighbors(20,_1465392):-true : _1465392 := [1,10,11,19,28,73].
neighbors(21,_1466296):-true : _1466296 := [12,13,22,29,58,59].
neighbors(22,_1467200):-true : _1467200 := [13,14,21,23,29,30].
neighbors(23,_1468104):-true : _1468104 := [14,15,22,24,30,31].
neighbors(24,_1469008):-true : _1469008 := [15,16,23,25,31,32].
neighbors(25,_1469912):-true : _1469912 := [16,17,24,26,32,33].
neighbors(26,_1470816):-true : _1470816 := [17,18,25,27,33,34].
neighbors(27,_1471720):-true : _1471720 := [18,19,26,28,34,35].
neighbors(28,_1472624):-true : _1472624 := [19,20,27,35,72,73].
neighbors(29,_1473528):-true : _1473528 := [21,22,30,36,59,60].
neighbors(30,_1474432):-true : _1474432 := [22,23,29,31,36,37].
neighbors(31,_1475336):-true : _1475336 := [23,24,30,32,37,38].
neighbors(32,_1476240):-true : _1476240 := [24,25,31,33,38,39].
neighbors(33,_1477144):-true : _1477144 := [25,26,32,34,39,40].
neighbors(34,_1478048):-true : _1478048 := [26,27,33,35,40,41].
neighbors(35,_1478952):-true : _1478952 := [27,28,34,41,71,72].
neighbors(36,_1479856):-true : _1479856 := [29,30,37,42,60,61].
neighbors(37,_1480760):-true : _1480760 := [30,31,36,38,42,43].
neighbors(38,_1481664):-true : _1481664 := [31,32,37,39,43,44].
neighbors(39,_1482568):-true : _1482568 := [32,33,38,40,44,45].
neighbors(40,_1483472):-true : _1483472 := [33,34,39,41,45,46].
neighbors(41,_1484376):-true : _1484376 := [34,35,40,46,70,71].
neighbors(42,_1485280):-true : _1485280 := [36,37,43,47,61,62].
neighbors(43,_1486184):-true : _1486184 := [37,38,42,44,47,48].
neighbors(44,_1487088):-true : _1487088 := [38,39,43,45,48,49].
neighbors(45,_1487992):-true : _1487992 := [39,40,44,46,49,50].
neighbors(46,_1488896):-true : _1488896 := [40,41,45,50,69,70].
neighbors(47,_1489800):-true : _1489800 := [42,43,48,51,62,63].
neighbors(48,_1490704):-true : _1490704 := [43,44,47,49,51,52].
neighbors(49,_1491608):-true : _1491608 := [44,45,48,50,52,53].
neighbors(50,_1492512):-true : _1492512 := [45,46,49,53,68,69].
neighbors(51,_1493416):-true : _1493416 := [47,48,52,54,63,64].
neighbors(52,_1494320):-true : _1494320 := [48,49,51,53,54,55].
neighbors(53,_1495224):-true : _1495224 := [49,50,52,55,67,68].
neighbors(54,_1496128):-true : _1496128 := [51,52,55,56,64,65].
neighbors(55,_1497032):-true : _1497032 := [52,53,54,56,66,67].
neighbors(56,_1497872):-true : _1497872 := [54,55,65,66].
neighbors(57,_1498712):-true : _1498712 := [2,12,58,102].
neighbors(58,_1499616):-true : _1499616 := [12,21,57,59,95,102].
neighbors(59,_1500520):-true : _1500520 := [21,29,58,60,89,95].
neighbors(60,_1501424):-true : _1501424 := [29,36,59,61,84,89].
neighbors(61,_1502328):-true : _1502328 := [36,42,60,62,80,84].
neighbors(62,_1503232):-true : _1503232 := [42,47,61,63,77,80].
neighbors(63,_1504136):-true : _1504136 := [47,51,62,64,75,77].
neighbors(64,_1505040):-true : _1505040 := [51,54,63,65,74,75].
neighbors(65,_1505912):-true : _1505912 := [54,56,64,66,74].
neighbors(66,_1506784):-true : _1506784 := [55,56,65,67,74].
neighbors(67,_1507688):-true : _1507688 := [53,55,66,68,74,76].
neighbors(68,_1508592):-true : _1508592 := [50,53,67,69,76,79].
neighbors(69,_1509496):-true : _1509496 := [46,50,68,70,79,83].
neighbors(70,_1510400):-true : _1510400 := [41,46,69,71,83,88].
neighbors(71,_1511304):-true : _1511304 := [35,41,70,72,88,94].
neighbors(72,_1512208):-true : _1512208 := [28,35,71,73,94,101].
neighbors(73,_1513112):-true : _1513112 := [1,20,28,72,101,109].
neighbors(74,_1514016):-true : _1514016 := [64,65,66,67,75,76].
neighbors(75,_1514920):-true : _1514920 := [63,64,74,76,77,78].
neighbors(76,_1515824):-true : _1515824 := [67,68,74,75,78,79].
neighbors(77,_1516728):-true : _1516728 := [62,63,75,78,80,81].
neighbors(78,_1517632):-true : _1517632 := [75,76,77,79,81,82].
neighbors(79,_1518536):-true : _1518536 := [68,69,76,78,82,83].
neighbors(80,_1519440):-true : _1519440 := [61,62,77,81,84,85].
neighbors(81,_1520344):-true : _1520344 := [77,78,80,82,85,86].
neighbors(82,_1521248):-true : _1521248 := [78,79,81,83,86,87].
neighbors(83,_1522152):-true : _1522152 := [69,70,79,82,87,88].
neighbors(84,_1523056):-true : _1523056 := [60,61,80,85,89,90].
neighbors(85,_1523960):-true : _1523960 := [80,81,84,86,90,91].
neighbors(86,_1524864):-true : _1524864 := [81,82,85,87,91,92].
neighbors(87,_1525768):-true : _1525768 := [82,83,86,88,92,93].
neighbors(88,_1526672):-true : _1526672 := [70,71,83,87,93,94].
neighbors(89,_1527576):-true : _1527576 := [59,60,84,90,95,96].
neighbors(90,_1528480):-true : _1528480 := [84,85,89,91,96,97].
neighbors(91,_1529384):-true : _1529384 := [85,86,90,92,97,98].
neighbors(92,_1530288):-true : _1530288 := [86,87,91,93,98,99].
neighbors(93,_1531192):-true : _1531192 := [87,88,92,94,99,100].
neighbors(94,_1532096):-true : _1532096 := [71,72,88,93,100,101].
neighbors(95,_1533000):-true : _1533000 := [58,59,89,96,102,103].
neighbors(96,_1533904):-true : _1533904 := [89,90,95,97,103,104].
neighbors(97,_1534808):-true : _1534808 := [90,91,96,98,104,105].
neighbors(98,_1535712):-true : _1535712 := [91,92,97,99,105,106].
neighbors(99,_1536616):-true : _1536616 := [92,93,98,100,106,107].
neighbors(100,_1537520):-true : _1537520 := [93,94,99,101,107,108].
neighbors(101,_1538424):-true : _1538424 := [72,73,94,100,108,109].
neighbors(102,_1539296):-true : _1539296 := [2,57,58,95,103].
neighbors(103,_1540168):-true : _1540168 := [2,95,96,102,104].
neighbors(104,_1541040):-true : _1541040 := [2,96,97,103,105].
neighbors(105,_1541912):-true : _1541912 := [2,97,98,104,106].
neighbors(106,_1542816):-true : _1542816 := [2,98,99,105,107,110].
neighbors(107,_1543688):-true : _1543688 := [99,100,106,108,110].
neighbors(108,_1544560):-true : _1544560 := [100,101,107,109,110].
neighbors(109,_1545432):-true : _1545432 := [1,73,101,108,110].
neighbors(110,_1546336):-true : _1546336 := [1,2,106,107,108,109].



