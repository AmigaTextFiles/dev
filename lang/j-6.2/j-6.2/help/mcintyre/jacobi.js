   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  September 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

   NB. Jacobi Method for Eigenvalues and Vectors of Symmetric Matrix

   setrl=. 9!:1              NB. Set Random Link:  setrl 7^5
   setrl 7^5
   ]y=. 50-~ ?6 6$100

   ut=. ,@(</~@i.)@#            NB.  Upper Triangle
   pt=. ((,*ut) i. >./@(ut # ,))@|   NB.  Pivot in Triangle  [eem Sept 92]
   pm=. <.@(pt % #) , # | pt    NB.  Pivot in Matrix
   pv=. {~ <@pm                 NB.  Pivot
   pa=. 0 0&{ ; ] ; |. ; 1 1&{  NB.  Permutations for amend
   ia=. pa@pm { i.@$            NB.  Indices for Amend
NB.  The positions of cells to be amended depend upon y
   amend=. ia@]}

   pv y
   ia y

   996 997 998 999 amend y

   ip=. +/ .*                          NB. Inner Product
   readkb=. ".@(1!:1@1:)               NB.  read from keyboard
   write=. 1!:2&2                      NB.  write to screen

   diag=. (<0 1)&|:                    NB.  matrix diagonal
   uf=. -:@-/@(pm{diag)                NB.  u function
   rss=. %:@+/@*:                      NB.  Square root of sum of squares
   vf=. rss@(pv,uf)                    NB.  v function
   sign=. >:&0 - <&0                   NB.  Sign of the sine
   cosf=. %:@((vf + |@uf) % +:@vf)         NB.  Cosine function
   sinf=. sign@uf * -@pv % +:@(vf * cosf)  NB.  Sine function

   maxit=. 20

   s0=. <'it=. 0 [ I=. Q=. =/~ i.#R=. y.'
   s1=. <'loop) $.=. >(end;$.){~ x.<|p=. -pv R'
   s2=. <'v=. %: +/*~p,u=. -: -/ (pm R){ diag R'
   s3=. <'sin=. (sign u)*p%+:v* cos=. %: (v+|u)%+:v'
   s4=. <'$.=. >(end;$.){~ *./0~:-.-|sin,cos'
   s5=. <'r=. ((cos,-sin),sin,cos) (ia R)} I'
   s6=. <'Q=. Q ip |:r [ R=. r ip R ip |:r'
   s7=. <'$.=. >(loop;$.){~ maxit<it=. it+1'
   s8=. <'write ''Number of further iterations or 0?'''
   s9=. <'$.=. >(loop;end){~ maxit<it=. it-readkb 1'
   s10=. <'end) R,:Q'
   jacobi=. '' : (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10)

   jacobi

   clean0=. ] * (<:|)            NB.  Sets small values to 0
NB. clean=. j./"1@(1e_5&clean0@+.)NB. Cleans complex numbers [eem Sept 92]
   clean=. j./"1@([ clean0 +.@]) NB. Cleans complex numbers [eem Sept 92]
   y=. 3 4$1e_19j7 7j1e_19 1e_19j1e_19 3j7
   1e_5 clean y
   1e_19 clean y

   round=. [ * <.@(0.5&+@(%~))   NB.  Tolerance is on left
   rfd=. %&180@o.                NB.  Radians From Degrees
   dfr=. rfd^:_1                 NB.  Degrees From Radians
   arcos=. dfr@(_2&o.)           NB.  Arcosine in degrees

   smatrix=. |: ip ]                   NB. symmmetric matrix:  Fork
   smatrix=. ip~ |:                    NB. symmetric matrix:  Hook

   n=. -p=. 0.7071
   ]table1=. (p,n,0),(n,p,0),(0,p,n),(0,n,p),:n,0,p
   ]m=.0.0001 round smatrix table1
   ]z=. 1e_5 clean 1e_6 jacobi  m

   m  ip  0{"1 (1{z)
   (0{0{0{z) * 0{"1 (1{z)
   
   m  ip  1{"1 (1{z)
   (1{1{0{z) * 1{"1 (1{z)
   
   m  ip  2{"1 (1{z)
   (2{2{0{z) * 2{"1 (1{z)

NB. These comparisons can be made with a single expression:
  (1e_9 clean |:m ip 1{z);(diag 0{z) *"0 1 |: 1{z

   1e_9 clean smatrix 1{z
    evf=. '|: (\:d){"1 (d=. diag 0{y.),1{y.' : ''
   ]ez=. evf z
   dg=. diag@{.
   '|: (\:d){"1 (d=. dg y.),1{y.':11
   evf=. |:@(\:@dg {"1 dg,1&{)
   NB.  1{z is not the same as }.z
   $ }.z
   $ 1{z
   ez-: evf z
   evf
tree=. 5!:4 @<   NB. Tree 'exp'
   tree 'evf'
   evf=. '|: (\:dg){"1 (dg=. diag 0{y.),1{y.' : ''
   evf=. |:@(\:@diag@{. {"1 diag@{.,1&{)
   evf 1e_5 clean 1e_6 jacobi  m=. 0.0001 round smatrix table1
   dg=. diag@{.
   '|: (\:d){"1 (d=. dg y.),1{y.':11
   evf=. |:@(\:@dg {"1 dg,1&{)
   
   ez-: evf z

   t=. _0.75 0.27 0.6, _0.85 0.53 0, _0.63 0.46 0.63,: _0.85 0 0.53
   t=. t, _0.09 1 0, _0.17 0.98 0, _0.86 0 0.52,: _0.82 _0.28 0.52
   t=.t,0.59 0.79 0.12, _0.59 _0.81 0.07, 0.87 0.4 0.28,: 0.02 0.87 0.5
   t=.t,0.67 0.7 0.26, _0.66 0.64 0.39, 0.38 0.85 0.36,:_0.02 0.99 0.12
   t=.t,0.35 0.44 0.83, _0.88 _0.47 0.09, 0.82 0.44 0.36,:0.67 0.64 0.37
   y=. t, _0.26 0.65 0.73
   
   m=. smatrix y
   z=. 1e_5 clean 1e_6 jacobi m
   evf z
      (1e_9 clean |:m ip 1{z);(diag 0{z) *"0 1 |: 1{z
   1e_5 clean arcos smatrix 1{z
   
   ] s2=. (<./ diag 0{z) % #y
   
   dfr _1 o. %: s2
