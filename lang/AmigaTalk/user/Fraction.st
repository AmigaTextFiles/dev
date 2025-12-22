" ------------------------------------------------------------- "
" Fraction.st - Implementation of fraction number class for     "
"               AmigaTalk.                                      "
" ------------------------------------------------------------- "

Class Fraction :Magnitude ! ratio n d !
[
  new
    n     <- Float new: 0.0.
    d     <- Float new: 1.0.
    ratio <- Float new: 0.0
|
  numerator
    ^n
|
  denominator
    ^d
|
  fraction
    ^ratio
|
  asFloat
    (d == 0.0)
      ifTrue: [ <primitive 123 'Improper fraction (x / 0.0)!'>.
                ^ nil 
              ].
      
    ^ratio <- (n / d)
|
  coerce: aNumber ! newFraction !
    newFraction <- Fraction new.

    newFraction numerator:   aNumber.
    newFraction denominator: 1.0.
    newFraction fraction:    aNumber.

    ^ newFraction
|
  numerator: newNum
    n <- newNum
|
  denominator: newDenom
    d <- newDenom
|
  fraction: newFrac
    ratio <- newFrac
|
  reciprocal ! temp !
    (n == 0.0)
      ifTrue: [ <primitive 123 'Reciprocal: Improper fraction (x / 0.0)!'>.
                ^ nil 
              ].
    temp <- n.
    n    <- d.
    d    <- temp.
    ^ ratio <- (n / d)    
|
  + aNumber ! tn td nc !
    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    td           <- d  * (nc denominator).
    tn           <- n  * (nc denominator).
    nc numerator:   d  * (nc numerator).
    n            <- tn + (nc numerator).
    d            <- td.
    ^ ratio <- (n / d)
|
  - aNumber ! tn td nc !
    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    td                <- d  * (nc denominator).
    tn                <- n  * (nc denominator).
    aNumber numerator:   d  * (nc numerator).
    n                 <- tn - (nc numerator).
    d                 <- td.
    ^ ratio <- (n / d)
|
  * aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    n <- n * (nc numerator).
    d <- d * (nc denominator).
    ^ ratio <- (n / d)
|
  / aNumber ! nf !

    (aNumber isKindOf: (self class))
      ifFalse: [ nf <- self coerce: aNumber ]
      ifTrue:  [ nf <- aNumber              ].
   
    ^ self * (nf reciprocal)
|
  printString ! str !
    (<primitive 78 n>, ' / ', <primitive 78 d>) print
|
  == aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((n == nc numerator) & (d == nc denominator))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  ~= aNumber ! nc !

    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    ((n ~= nc numerator) & (d ~= nc denominator))
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  <  aNumber ! nc !
    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    (ratio < nc fraction)
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  >  aNumber ! nc !
    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    (ratio > nc fraction)
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  <= aNumber ! nc !
    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    (ratio <= nc fraction)
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
|
  >= aNumber ! nc !
    (aNumber isKindOf: (self class))
      ifFalse: [ nc <- self coerce: aNumber ]
      ifTrue:  [ nc <- aNumber              ].

    (ratio >= nc fraction)
      ifTrue:  [ ^ true  ]
      ifFalse: [ ^ false ]
]
