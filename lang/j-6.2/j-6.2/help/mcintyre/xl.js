   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  August 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

NB. An Executable Notation, with illustrations from
NB. Elementary Crystallography  (In Press)

NB. Appendix B

   rfd=. %&180@o.      NB. Radians From Degrees
   sin=. 1&o.          NB. sine of angle in radians
   cos=. 2&o.          NB. cosine of angle in radians
   SinCos=. 1 2&o.    NB. sine and cosine
   NB. crystallographic axes (lengths) or interaxial angles
   a=. 0&{
   b=. 1&{
   c=. 2&{
   ab=. a,b
   axisa=. 1 0 2&{ @ (0&,@ SinCos@b)
   
   NB.  cos(rho) and cos(sigma) from Terpstra (1961) p.287
   CosRho=. (cos@c - */@(cos@ab)) % */@(sin@b)
   CosSigma=. sin@b %~ %:@(>:@+:@(*/@cos) - +/@*:@cos)
   axisb=. CosRho,CosSigma,cos@a
   dm=. ,&0 0 1 @ (axisa,:axisb) @ (rfd @ (1&{))
   dmat=. {. *"0 1 dm
   dmat=. dmat f.       NB.  The adverb f. "fixes" the verb
   NB.  anorthite and chalcanthite from Terpstra (1961) p.290
   NB.   ch (chalcanthite) from Dana Vol. 2 (1951) p.489
   anorthite=. 0.6344 1 0.5505,:93.15 115.9833 91.2
   chalcanthite=. 0.5705 1 0.5565,: 82.367 107.433 102.55
   ch=. 6.11 10.673 5.95,: 97.583 107.167 77.55
   dmat"2 anorthite,chalcanthite,:ch
   norm=. %: @ (+/ @ *:)"1     NB. Length of vectors
   dv=. %"1 0 norm             NB. Direction Vector
   ip=. +/ .*                  NB. Inner Product
   ipt=. ip |:                 NB. Inner Product with Transpose
   limit=. 1&<. @(_1&>.)       NB. Restrict range from _1 to 1
   arcos=. _2&o.               NB. arcosine in radians
   dfr=. rfd^:_1           NB. Degrees From Radians. Inverse of rfd
   angles=. dfr@arcos@limit@ipt@dv
NB. The canonical forms can be recovered from the d-matrices:
   canon=. norm,:5 2 1&{@,@angles
   canon"2 dmat"2 anorthite,chalcanthite,:ch

NB. ----------------------------------------------------

NB. Chalcanthite:  Canonical form
      ]dana=. 6.11 10.673 5.95,: 97.583 107.167 77.55
      <"0 dana
      (;:'a b c'),: ;:'alpha beta gamma'

NB. Cartesian coordinates
      a=. 1.75 0.5
      b=. 0.25 2
      <"0 d=. a,:b
NB. Lattice rows
      ]p=. a*/i.4
      ]q=. b*/i.5
      $p+/q
      $r=. (<0 2)|:(a*/i.4)+/(b*/i.5)
NB. Lattice points
      r
      ip=. +/ .*
      x=. 20 2$,r
      x -: (4 5#:i.20) ip d
   norm=. %: @ (+/ @ *:)"1      NB.  Lengths
   norm d
   dv=. %"1 0 norm              NB. Direction Vectors
   dv
   dv d
   ipt=. ip |:            NB. A hook: inner product with transpose
   limit=. 1&<. @(_1&>.)  NB. Result to be from _1 to 1
   arcos=. _2&o.          NB. arcosine:  angle in radians
   rfd=. %&180@o.         NB. Radians From Degrees
   dfr=. rfd^:_1          NB. Inverse of rfd:  Degrees From Radians
   angles=. dfr@arcos@limit@ipt@dv
   angles d

NB. Angle between Crystallographic a-axis and Cartesian x-axis:
   dfr arcos 1 0 ip dv a

NB. Rotation matrix:  Explicit and Tacit definitions
   rot=. '(cos,-sin),:(''sin'';''cos'')=. 1 2 o. rfd y.' : ''
   rot=. '(1 _1,: 1 1)*(2 1,:1 2)o. rfd y.' : ''
   rot=. 2 2&$ @ (1 _1 1 1&* @ (2 1 1 2&o.@rfd))
   rot=. (1 _1,:1 1)&*@((2 1,:1 2)&o. @ rfd)
   6.2 6.2 8.2 6.2 ": x,"1 x ip rot 15.9454

NB. Chalcanthite: d-matrix
   <"0 d=. 5.82945 0 _1.83019, 2.00218 10.3847 _1.43613,: 0 0 5.95
NB. Canonical from d-matrix
   canon=. norm,:5 2 1&{@,@angles
   canon d

NB. Determinant
   det=. -/ .*
   det d

NB. Test for coplanar vectors
   det 1 0 0, 1 1 1,: 0 1 1
   det 1 2 2, 3 1 1,: 0 1 1
   det 1 2 1, 3 1 1,: 0 1 1

NB. Set small values to zero
   clean=. ] * (<:|)

   cubic=. 1 0 0,1 1 0,1 1 1,0 1 0,0 1 1,1 _1 1,: 3 1 2
   (3 ":cubic),"( 1) 8.2 ": 1e_4 clean angles cubic
   4 ": cubic,"(1) 0 60 60 #: 60*60* 0{angles cubic

NB. Rutile: TiO®MDSD¯2®MDNM¯
   d=. 4.58 0 0,0 4.58 0,:0 0 2.98
   O=. 0.31 0.31 0, 0.69 0.69 0,: 0.81 0.19 0.5
   O=. O, 0.19 0.81 0.5, 0.31 0.31 1,: 0.69 0.69 1
   6.2": O,"1 0 norm x=. (O-0.5) ip d

   BondAngles=. 9.2&":@angles@dv
   BondAngles x

NB. Chalcanthite
   <"0 d=. 5.84927 0 _1.80693, 1.97722 10.4155 _1.41139,: 0 0 5.96
   canon d
NB. r-matrix
   <"0 r=.  1e_10 clean |: %. d
   canon r
NB. Some of the faces (hkl)
   m=. 1 0 0, 1 _1 0, _1 _1 1, 0 1 0, 1 1 0,: 1 3 0
   (3 3 3,6#9.2)":m,"(1) angles m ip r
   4 ": 2 0 1|: 0 60 #:60* angles m ip r

NB. JCPDS 11-646
    <"0 d=. 5.83802 0 _4.13661, _1.99634 10.4258 _1.42202,: 0 0 5.955
   canon d
NB. r matrix
   <"0 r=. |: %. d
   canon r
NB. Selected planes
hkl=.0 1 0,1 0 0,1 0 _1,1 _1 0,0 2 0,1 1 _1,1 _1 _1,0 1 _1, 0 0 1,1 1 0,:1 _2 0
NB. d-spacings

NB. Transformations:  Gypsum
   3 3 3 8.2 ": hkl,"1 0 % norm hkl ip r
   t=. _2 0 _1, 0 _1 0,: 0 0 1
NB. Relative size of cells
   det t
NB. Transform Dana's Miller Indices to de Jong's
   <"0 s=. |: %. t
NB. 1 0 _3 has the same Miller indices inboth settings
   1 0 _3 ip s
   ]j6=. 0 2 0, 0 3 1,: 2 0 0         NB. JCPDS 6-0046
   ]j21=. 0 2 0,1 3 0,:2 0 _2         NB. JCPDS 21-816

NB. Transformation Matrix
   ]t=. j21 ip~ %.j6
   0 2 0 ip t
   j6a=. 0 2 0,1 2 _1,0 3 1,1 1 _2,1 4 _1,0 0 2,2 1 _1,:0 5 1
   j6a=. j6a,1 5 0,2 0 _2,2 0 0,2 2 _2,1 4 1,1 5 _2,:2 4 _2
   j6a=. j6a,1 2 _3, 1 0 0, 0 0 1,1 0 1,1 0 _1,:_1 0 1 

NB. Tabulate equivalent Miller Indices in two settings
   4 4 4 7 4 4": 6{.j6a,"1 j6a ip t

NB. Canonical descriptions
   ]j6can=. 5.68 15.18 6.51,:90 118.383 90
   ]j21can=. 6.286 15.213 5.678,:90 114.08 90

NB. d-spacings
   dspace=. %@norm@ip
   x=. j6a,"1 0 j6a dspace |:%. dmat j6can
   j21a=. j6a ip t
   y=. j21a,"1 0 j21a dspace |:%. dmat j21can

NB. Miller Indices and d-spacings for each of two settings
   4 4 4 7.2 7 4 4 7.2 ": 6{. x,"1 y

NB. Volume of a triclinic cell
NB. V= abc û( 1 - cos®MDSU¯2®MDNM¯ A - cos®MDSU¯2®MDNM¯ B - cos®MDSU¯2®MDNM¯ C + 2 cos A cos B cos C )
NB. A, B, C,  <->  alpha, beta, gamma
NB.         f * f1
   f=. */@{.                NB.  product over the first item (row)
   
   cos=. 2&o. @ rfd@,@}.    NB.  cosines of the angles in radians
   g=. -. @(+/@*:@cos)      NB.  1 - sum of squares of the cosines
   h=. +:@(*/@cos)          NB.  twice the product of the cosines
   V=. f * %:@(g+h)

NB. Chalcanthite (Dana 1951, Vol2., p.489)
   ch=. 6.11 10.673 5.95,: 97.733 107.43 77.333
   V ch
   g=. -. @(+/@*:)          NB.  1 - sum of squares
   h=. +:@(*/)              NB.  twice the product
   V=. f * %:@(g+h)@cos 
   V ch
   V=. */@{. * %:@(-.@(+/@*:) + +:@(*/))@cos
   V ch

NB. Rhetorical
   product=. */
   axes=. {.
   root=. %:
   sum=. +/
   squares=. *:
   twice=. +:
   V=. product@axes * root@(-.@(sum@squares) + twice@product)@cos
   V ch

NB. Syncopated
   p=. product
   ss=. sum@squares
   V=. p@axes * root@(-.@ss + twice@p)@cos
   V ch
   V
   
NB. "Volume is (the product of a,b,c) multiplied by
NB. the (square root of (1 minus the sum of squares of
NB. the cosines of alpha, beta, gamma) plus
NB. twice the product of these cosines.)"

NB. Volume from the d-matrix:  Vector cross product
   d=. dmat ch 

   vcp=. (1&|.@[ * _1&|.@]) - _1&|.@[ * 1&|.@]
   vol=. {. ip 1&{ vcp 2&{
   vol d
   vol

NB. Determinant
   c:=. &[           NB.  Adverb turning a noun into a verb
   f=. 0  1  2 c: |."0 1 ]
   g=. 0 _1 _2 c: |."0 1 ]
   det=. -/@(+/@(*/"2@(f,:g)))
   det d
   f=.  |."0 1~ 0  1  2 c:
   g=.  |."0 1~ 0 _1 _2 c:
   det=. -/@(+/@(*/"2@(f,:g)))
   det d
   f=. |."0 1
   g=. 0 1 2&f ,: 0 _1 _2&f
   det=. -/@(+/@(*/"2@g))
   det d
   det=. -/@(+/@(*/"2@((0 1 2,:0 _1 _2)c: |."0 1 ,:~)))
   det d
   f=. 1 _1&(*/)@(i.@#)
   det=. -/@(+/@(*/"2 @(f |."0 1 ,:~)))
   det d
   det=. -/ .*
   vol=. det
   vol d

