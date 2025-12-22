          CONNECTIONS: family Ic
   
   cm
0 0 0 0 0 0 0 0
0 0 1 0 0 0 0 1
1 1 0 1 0 0 0 0
0 0 0 0 0 1 0 1
0 0 1 1 0 0 0 0
1 0 1 0 0 0 1 1
0 0 0 1 0 0 0 0
1 0 1 1 1 0 1 0
   points=. 1 0 0 0 0 0 0 1
   points +./ . *. cm
1 0 1 1 1 0 1 0
   points+.points+./ . *.cm
1 0 1 1 1 0 1 1
   
   immfam=. '':'x.+.x.+./ . *.y.'
   points immfam cm
1 0 1 1 1 0 1 1
   fam=.'':'immfam&y.^:(#y.)x.'
   points fam cm
1 1 1 1 1 1 1 1
