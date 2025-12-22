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

NB. Volume of a parallelepiped given edges and angles

   rfd=. %&180@o.      NB. Radians From Degrees
NB. Volume of a triclinic cell
NB. V= abc û( 1 - cos®MDSU¯2®MDNM¯ A - cos®MDSU¯2®MDNM¯ B - cos®MDSU¯2®MDNM¯ C + 2 cos A cos B cos C )
NB. A, B, C,  <->  alpha, beta, gamma
NB.         f * f1
   f=. */@{.                NB.  product over the first item (row)
   
      ss=. +/@*:
      cos=. 2&o.@rfd@{:    NB.  cosines of the angles in radians

      g=. -. @ss@cos      NB.  1 - sum of squares of the cosines
   h=. +:@(*/@cos)          NB.  twice the product of the cosines
   V=. f * %:@(g+h)

NB. Chalcanthite (Dana 1951, Vol2., p.489)
   ch=. 6.11 10.673 5.95,: 97.733 107.43 77.333
   V ch
      g=. -. @ss          NB.  1 - sum of squares
   h=. +:@(*/)              NB.  twice the product
   V=. f * %:@(g+h)@cos 
   V ch
      V=. */@{. * %:@(-.@ss + +:@(*/))@cos
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
