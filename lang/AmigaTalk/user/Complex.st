" ------------------------------------------------------------- "
" Complex.st - Implementation of complex number class for       "
"              AmigaTalk.                                       "
" ------------------------------------------------------------- "

Class Complex :Magnitude
! real imag mag phase !
[
  new
    real  <- Float new: 0.0.
    imag  <- Float new: 0.0.
    mag   <- Float new: 0.0.
    phase <- Float new: 0.0
|
  realpart
    ^real
|
  imagpart
    ^imag
|
  magpart
    ^mag
|
  phasepart
    ^phase
|
  realpart: newReal
    real  <- newReal
|
  imagpart: newImag
    imag  <- newImag
|
  magpart: newMag
    mag   <- newMag
|
  phasepart: newPhase
    phase <- newPhase
|
  coerce: aNumber ! newComplex !
    newComplex <- Complex new.

    newComplex realpart: aNumber.
    newComplex imagpart: 0.0.

    ^ newComplex
|
  conjugate
    imag <- -1.0 * imag
|
  ~
    ^ conjugate self
|
  + aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    real <- nc realpart + self realpart.
    imag <- nc imagpart + self imagpart.

    ^ self
|
  - aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    real <- self realpart - nc realpart.
    imag <- self imagpart - nc imagpart.

    ^ self
|
  * aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    real <- (self realpart * nc realpart) - (self imagpart * nc imagpart).
    imag <- (self imagpart * nc realpart) + (self realpart * nc imagpart).

    ^ self
|
  / aNumber ! nc denom r i !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((nc realpart == 0.0) & (nc imagpart == 0.0))
      ifTrue: [ <primitive 123 'Division by Complex zero!'>.
                ^ nil 
              ].
    
    denom <- (nc realpart * nc realpart) + (nc imagpart * nc imagpart).
    r     <- (nc realpart * self realpart) + (nc imagpart * self imagpart).
    i     <- (self imagpart * nc realpart) - (self realpart * nc imagpart).
      
    real  <- r / denom.
    imag  <- i / denom.

    ^ self
|
  printString ! str !
    ('{', <primitive 78 real>, ', ', <primitive 78 imag>, '}') print
|
  computeMag
    mag <- <primitive 71 ((self realpart * self realpart) \ 
                        + (self imagpart * self imagpart))>
|
  computeMagPhase
    self computeMag.

    (self imagpart == 0.0)
      ifTrue: [ <primitive 123 'Division by Complex zero!'> ].
    
    phase <- (self realpart / self imagpart) arcTan      
|
  == aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((self realpart = nc realpart) & (self imagpart = nc imagpart))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  < aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    self computeMag.
    nc   computeMag.
    
    (self magpart < nc magpart)
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  > aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    self computeMag.
    nc   computeMag.
    
    (self magpart > nc magpart)
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  <= aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    self computeMag.
    nc   computeMag.
    
    (self magpart <= nc magpart)
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  >= aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    self computeMag.
    nc   computeMag.
    
    (self magpart >= nc magpart)
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  ~= aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((self realpart ~= nc realpart) & (self imagpart ~= nc imagpart))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
]
