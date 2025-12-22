" ------------------------------------------------------------- "
" Quaternion.st - Implementation of Quaternions class for       "
"                 AmigaTalk.                                    "
""
" Quaternions are attributed to Sir William Rowan Hamilton      "
" who developed them in 1843, and published a major analysis in "
" 1844 called:  On a Species of Imaginary Quantities Connected  "
"               with a Theory of Quaternions                    "
" in the Proceedings of the Royal Irish Academ. (2, pp 424-434) "

" Typical quaternion number q is of the form:                   "

"      q = s + a*i + b*j + c*k.                                 "
"          s, a, b, & c are real numbers.                       "

" Bases i, j, k behave as follows:                              "

" i^2 = j^2 = k^2 = -1, i*j = k, j*k = i, k*i = j, &            "

" j*i = -k, k*j = -i, i*k = -j.                                 "

" Quaternion numbers are NOT Commutative.                       "

" A Quaternion is a 4-D space over Real numbers, and a 2-D      "
" space over Complex numbers as q = (a + b*i) + (c + d*i)*j.    "

" Polar Coordinates:                                            "

" A Quaternion q = s + a*i + b*j + k*c has 1st level polar form "
" such that: "

"   q = |q| * (cos(t1) + sin(t1)*u1),                           "
"     where u1 is unit vector of u1 = a1*i + b1*j + c1*k.       "

" u1 has 2nd level polar form:                                  "

"   u1 = i*cos t2 + sin t2 u2,                                  "
"     where u2 is unit vector of u2 = b2*j + c2*k.              "

" And u2 has 3rd level polar form:                              "

"     u2 = j*cos t3 + k*sin t3.                                 "

" So we have:                                                   "

" q = |q| * (cos(t1) + sin(t1)*(i*cos(t2) +                     "
"                          sin(t2)*(j*cos(t3) + k*sin(t3)))).   "

" The equivalent to polar coordinates in quaternion space are:  "   

" s = |q| cos(t1),                                              "
" a = |q| sin(t1)*cos(t2),                                      "
" b = |q| sin(t1)*sin(t2)*cos(t3),                              "
" c = |q| sin(t1)*sin(t2)*sin(t3).                              "

" |q| is known as the magnitude of the quaternion,              "
" t1 is the amplitude(or angle),                                "
" t2 and t3 are the latitude (or co-latitude) and longitude     "
" respectively.                                                 "
" ------------------------------------------------------------- "

Class Quaternion :Magnitude ! s i j k !
[
  new
    s <- Float new: 0.0.
    i <- Float new: 0.0.
    j <- Float new: 0.0.
    k <- Float new: 0.0
|
  tensor
    ^s
|
  ipart
    ^i
|
  jpart
    ^j
|
  kpart
    ^k
|
  tensor: newReal
    s <- newReal
|
  ipart: newI
    i <- newI
|
  jpart: newJ
    j <- newJ
|
  kpart: newK
    k <- newK
|
  versor: ni p2: nj p3: nk
    i <- ni.
    j <- nj.
    k <- nk
|
  coerce: aNumber ! newQuaternion !
    newQuaternion <- Quaternion new.

    newQuaternion tensor: aNumber.
    newQuaternion ipart:  0.0.
    newQuaternion jpart:  0.0.
    newQuaternion kpart:  0.0.

    ^ newQuaternion
|
  conjugate
    i <- -1.0 * i.
    j <- -1.0 * j.
    k <- -1.0 * k.
    ^ self
|
  ~
    ^ conjugate self
|
  norm
    ^ ((s * s) + (i * i) + (j * j) + (k * k))
|
  inverse
    ((self norm) = 0.0)
    ifTrue: [ <primitive 123 'Quaternion error: Division by zero!'>.
              ^ nil
            ].
    
    ^ ((self conjugate) / (self norm))
|
  + aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    s <- nc spart + self spart.
    i <- nc ipart + self ipart.
    j <- nc jpart + self jpart.
    k <- nc kpart + self kpart.

    ^ self
|
  - aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    s <- self spart - nc spart.
    i <- self ipart - nc ipart.
    j <- self jpart - nc jpart.
    k <- self kpart - nc kpart.

    ^ self
|
  * aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    s <- (s * nc spart) - (i * nc ipart) - (j * nc jpart) - (k * nc kpart).
    i <- (i * nc spart) + (s * nc ipart) + (k * nc jpart) - (j * nc kpart).
    j <- (j * nc spart) - (k * nc ipart) + (s * nc jpart) + (i * nc kpart).
    k <- (k * nc spart) + (j * nc ipart) - (i * nc jpart) + (s * nc kpart).

    ^ self
|
  / aNumber ! nc denom r i !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((nc spart == 0.0) & (nc ipart == 0.0))
      ifTrue: [ <primitive 123 'Quaternion error: Division by zero!'>.
                ^ nil 
              ].
    
    self * (nc inverse).

    ^ self
|
  printString
    ('{', <primitive 78 s>, ', ', <primitive 78 i>, ', ', <primitive 78 j>, ', ', <primitive 78 k>, '}') print.
    ^ self
|
  == aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((s = nc spart) & (i = nc ipart) & (j = nc jpart) & (k = nc kpart))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  < aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    self computeMag.
    nc   computeMag.
    
    ((s < nc spart) & (i < nc ipart) & (j < nc jpart) & (k < nc kpart))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  > aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((s > nc spart) & (i > nc ipart) & (j > nc jpart) & (k > nc kpart))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  <= aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((s <= nc spart) & (i <= nc ipart) & (j <= nc jpart) & (k <= nc kpart))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  >= aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((s >= nc spart) & (i >= nc ipart) & (j >= nc jpart) & (k >= nc kpart))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  ~= aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((s ~= nc spart) ! (i ~= nc ipart) ! (j ~= nc jpart) ! (k ~= nc kpart))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
]
