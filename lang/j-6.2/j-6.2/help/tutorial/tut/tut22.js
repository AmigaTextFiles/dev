            GEOMETRY: 2-space Ha
   length=. '%:+/y.^2':''
   length 12 5
13
   [ tri=. ? 2 3 $ 9
3 4 7
0 0 4
   1 |."1 tri
4 7 3
0 4 0
   [ lsides=.length tri-1|."1 tri
1 5 5.65685
   [ semiper=. 2 %~ +/lsides
5.82843
   area=. %:*/semiper-0,lsides
   area
2
   tri,1
3 4 7
0 0 4
1 1 1
   2 %~ det tri,1
2
