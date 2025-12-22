" -------------------------------------------------------------- "
" Vector3D.st - Implementation of Vectors of 3-dimensions.       "
" -------------------------------------------------------------- "

Class Vector3D :VectorN ! v1 v2 v3 !
[
  new
    v1 <- Float new: 0.0. 
    v2 <- Float new: 0.0.
    v3 <- Float new: 0.0.

    ^ self 
|
  norm
    ^ (((v1 * v1) + (v2 * v2) + (v3 * v3)) sqrt)
|
  scale: aNumber
    v1 <- v1 * aNumber.
    v2 <- v2 * aNumber.
    v3 <- v3 * aNumber.

    ^ self
|
  printString
    ('<',  v1 asString, ', ', v2 asString, ', ', v3 asString, '>') print
|
  dot: nv
    ^ ((v1 * nv v1) + (v2 * nv v2) + (v3 * nv v3))
|
  v1
   ^ v1 
|
  v2
   ^ v2 
|
  v3
   ^ v3 
|
  v1: newV1
   ^ v1 <- newV1
|
  v2: newV2
   ^ v2 <- newV2
|
  v3: newV3
   ^ v3 <- newV3
|
  cross: nv
   v1 <- ((v2 * nv v3) - (v3 * nv v2)).
   v2 <- ((v3 * nv v1) - (v1 * nv v3)).
   v3 <- ((v1 * nv v2) - (v2 * nv v1)).

   ^ self
|
  boxProduct: b ! t !
    t <- Vector3D new.
    
    t <- self cross: b.

    ^ (self dot: t)
|
  vectorProduct: b ! t !
    t <- Vector3D new.
    
    t <- self cross: b.

    ^ (self cross: t)
|
  - b
    (b isKindOf: Vector3D)
      if False: [ ('Argument wrong class for - Vector3D') print.
                  ^ nil
                ].
                
    v1 <- (v1 - (b v1)).
    v2 <- (v2 - (b v2)).
    v3 <- (v3 - (b v3)).

    ^ self
|
  + b
    (b isKindOf: Vector3D)
      if False: [ ('Argument wrong class for + Vector3D') print.
                  ^ nil
                ].
                
    v1 <- (v1 + (b v1)).
    v2 <- (v2 + (b v2)).
    v3 <- (v3 + (b v3)).

    ^ self
|
  < b
    (b isKindOf: Vector3D)
      if False: [ ('Argument wrong class for < Vector3D') print.
                  ^ nil
                ].
                
    ((self norm) < (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  > b
    (b isKindOf: Vector3D)
      if False: [ ('Argument wrong class for > Vector3D') print.
                  ^ nil
                ].
                
    ((self norm) > (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  <= b
    (b isKindOf: Vector3D)
      if False: [ ('Argument wrong class for <= Vector3D') print.
                  ^ nil
                ].
                
    ((self norm) <= (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  >= b
    (b isKindOf: Vector3D)
      if False: [ ('Argument wrong class for >= Vector3D') print.
                  ^ nil
                ].
                
    ((self norm) >= (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  = b
    (b isKindOf: Vector3D)
      if False: [ ('Argument wrong class for = Vector3D') print.
                  ^ nil
                ].
                
    ((self norm) = (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
|
  ~= b
    (b isKindOf: Vector3D)
      if False: [ ('Argument wrong class for ~= Vector3D') print.
                  ^ nil
                ].
                
    ((self norm) ~= (b norm))
      ifTrue:  [^ true ]
      ifFalse: [^ false]
]
