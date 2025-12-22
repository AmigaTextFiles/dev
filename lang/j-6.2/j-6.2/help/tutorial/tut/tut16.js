             PROGRAMS: simple Ga
   root=. 'y. ^ %2':'y. ^ %x.'
   root 64
8
   3 root 64
4
   rPr=. '% y.':'x. + % y.'
   3 rPr 4
3.25
   rPr / 1 2 2 2 2 2 2
1.4142
   rPr/ \ 1 2 2 2 2
1 1.5 1.4 1.41667 1.41379
   rPr/ \ 3 7 15
3 3.14286 3.14151
   triple=. '3*y.':''
   triple i.5
0 3 6 9 12
   3 triple 6
domain error
   tr=. '3*y.':*
   tr i. 5
0 3 6 9 12
   3 5 7 tr i. 3
0 5 14
