   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  September 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

NB.  In Crystallography the R-matrix (describing the Reciprocal
NB.  Lattice) is the transpose of the inverse of the D-matrix
NB.  (describing the Direct Lattice).

      y=. ?3 3 3$100          NB. Simulate D-matrices of 3 crystals

      y2=. {.y                NB. First item
      y2i=. %. y2           NB. Inverse
      ip=. +/ .*            NB. Inner Product
      y2 ip y2i             NB. Identity Matrix

      y2i                   NB. Inverse of y2
      |: %. y2              NB. Transpose of the Inverse

      ti=. |:@%.            NB. Transpose of the inverse

      y2it=. |: %. y2
      y2it

      y2it-: %. |: y2       NB. The inverse of the transpose is the
                            NB. same as the transpose of the inverse.

      y2it-: ti y2

      yit=. ti y            NB. Transpose the inverses of all items
      y2it-:{.yit           NB. Check the first one

      it=. %.@|:            NB. Inverse of the transpose
      y2it-: it y2

      (ti -: it) y2         NB. Fork

      |:i.2 3 4             NB. The transpose must INHERIT rank 2!
      |:"2 i.2 3 4

      (ti -: it"2) y2         NB. Fork
