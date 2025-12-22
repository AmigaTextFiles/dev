" -------------------------------------------------------------- "
" Vector2D.st - Implementation of Vectors of 2-dimensions.       "
" -------------------------------------------------------------- "

Class Vector2D :VectorN ! v1 v2 !
[
  new
    v1 <- Float new: 0.0. 
    v2 <- Float new: 0.0.

    ^ self 
|
  norm
    ^ (((v1 * v1) + (v2 * v2)) sqrt).
|
  scale: aNumber
    v1 <- v1 * aNumber.
    v2 <- v2 * aNumber.

    ^ self
|
  printString
    ('<', v1 asString, ', ', v2 asString, '>') print
|
  dot: b
    ^ (((self v1) * (b v1)) + ((self v2) * (b v2))))
|
  v1
   ^ v1 
|
  v2
   ^ v2 
|
  v1: newV1
   ^ v1 <- newV1
|
  v2: newV2
   ^ v2 <- newV2
|
  cross: b
   ^ (((self v1) * (b v2)) - ((self v2) * (b v1)))
|
  - b
    (b isKindOf: Vector2D)
      if False: [ ('Argument wrong class for - Vector2D') print.
                  ^ nil
                ].
                
    v1 <- ((self v1) - (b v1)).
    v2 <- ((self v2) - (b v2)).

    ^ self
|
  + b
    (b isKindOf: Vector2D)
      if False: [ ('Argument wrong class for + Vector2D') print.
                  ^ nil
                ].
                
    v1 <- ((self v1) + (b v1)).
    v2 <- ((self v2) + (b v2)).

    ^ self
|
  < b
    (b isKindOf: Vector2D)
      if False: [ ('Argument wrong class for < Vector2D') print.
                  ^ nil
                ].
                
    ((self norm) < (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  > b
    (b isKindOf: Vector2D)
      if False: [ ('Argument wrong class for > Vector2D') print.
                  ^ nil
                ].
                
    ((self norm) > (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  <= b
    (b isKindOf: Vector2D)
      if False: [ ('Argument wrong class for <= Vector2D') print.
                  ^ nil
                ].
                
    ((self norm) <= (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  >= b
    (b isKindOf: Vector2D)
      if False: [ ('Argument wrong class for >= Vector2D') print.
                  ^ nil
                ].
                
    ((self norm) >= (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  = b
    (b isKindOf: Vector2D)
      if False: [ ('Argument wrong class for = Vector2D') print.
                  ^ nil
                ].
                
    ((self norm) = (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  ~= b
    (b isKindOf: Vector2D)
      if False: [ ('Argument wrong class for ~= Vector2D') print.
                  ^ nil
                ].
                
    ((self norm) ~= (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
]
