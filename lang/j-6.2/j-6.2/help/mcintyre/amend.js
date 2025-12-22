   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  August 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk


NB. "Using J's Boxed Arrays", VECTOR Vol.9 #1 (July 1992) 92-105
NB.  AMENDMENT: "A Change for the Better", VECTOR.   In Press

NB. simulate the 5 by 6 array of nested cells:
   ]d=.<"0 i.5 6
NB. The numbers can be called "linear indexes"
   li=. [ { i.@$@]     NB. Fork
NB. The linear indices of rows 1 and 4 are:
   1 4 li d
NB. The linear index of the cell at row 2 and column 5:
   (<2 5) li d

NB. To place the array x in this cell:
   x=. < 9 8 7 6,:5 4 3 2
   x 17} d

NB. Scattered indexing:
   (x;'London') ((2 5; 4 2) li d)} d
NB. Expand the table and amend new rows 1 and 4:
   exp=. /:@\:@[ { #@[{.]
   e=. 1 0 1 1 0 1 1 exp d
   t=. e (1 li d)}~ 'Bob';'Bernecky';'Toronto';35;22000; 4 5
   t (4 li d)}~ 'Graham';'Woyka';'U.K.';62;35000;14 31 5 7
   
y=. ('Graham';'Woyka';'U.K.';1;2;3),:'Vin';'Grannell';'Los Angeles';4;5;6 7 8
   ]z=. e (1 4 li e)}~ 1 0{ y

NB. Alternatively:
      v=. 1 4&li
      v e
      u=. v@]}
      z-: e u~ 1 0{y
NB. ----------------------------------------------------
NB. "Mastering J",  APL91, APL Quote Quad 21#4 (Aug 91) p.264-273
NB. "Jacobi's method for Eigenvalues: an Illustration of J",
NB.  VECTOR, In Press

NB. Capitalize the first occurrence of each vowel:
      s=. 'now is the time for all of us'
      i=. s i. 'aeiou'
      x=. 'AEIOU'
      x i}s

NB.   x i} m  Amend was amended in Version 4.
NB.  Illustrations from Jacobi's method

   m=. i.6 6
   ]i=. 2 2; 2 4; 4 2; 4 4
   x=. 100 101 102 103
   f=. >@[ +/ .* ,&1@#@]
   i f m
   x (i f m)}m
   
   ut=. ,@(</~@i.)@#            NB.  Upper Triangle
   pt=. (, i. >./@(ut # ,))@|   NB.  Pivot in Triangle
   pm=. <.@(pt % #) , # | pt    NB.  Pivot in Matrix
   pa=. 0 0&{ ; ] ; |. ; 1 1&{  NB.  Permutations for amend
   ia=. pa@pm { i.@$            NB.  Indices for Amend
   amend=. ia@]}                NB.  Amend the right argument

   qrl=. 9!:0                NB. Query Random Link:  qrl 0
   setrl=. 9!:1              NB. Set Random Link:  setrl 7^5
   setrl 7^5
   ]y=. 50-~ ?6 6$100
   x amend y
   
   p=.  0 0&{ ; ] ; |. ; 1 1&{   NB.  permutations for amend
   ia=. p@pm { i.@$              NB.  indices for amend
   id=. =/~ i.6
   x (ia y)} id
