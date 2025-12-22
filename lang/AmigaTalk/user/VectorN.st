" -------------------------------------------------------------- "
" VectorN.st - Implementation of Vectors of n-dimensions.        "
" -------------------------------------------------------------- "

Class VectorN :Magnitude ! n ele !
[
  new: newElements
    (newElements > 3)
       ifFalse:  [ ('size of VectorN S/B > 3!') print. 
                   ^ nil
                 ].
       
    n   <- newElements. 
    ele <- Array new: numElements.

    1 to: n do: [:i | ele at: i put: (Float new: 0.0)].

    ^ self
|
  componentAt: index
    ^ (ele at: index)
|
  setComponent: val at: index
    (index > n)
      ifTrue:  [ ('Index out of range for VectorN!') print.
                 ^ nil
               ].

    ele at: index put: val.
    ^ ele
|
  norm ! sum x !
    sum <- Float new: 0.0.
    (1 to: n) do: [:i | x   <- ((ele at: i) * (ele at: i)).
                        sum <- (sum + x)
                  ].
   
    ^ (sum sqrt)
|
  scale: s
    (1 to: n) do: [:i | ele at: i put: (s * (ele at: i))].
    ^ ele
|
  dot: b ! sum x !
    sum <- Float new: 0.0.
    (1 to: n) do: [:i | x   <- ((ele at: i) * (b at: i)).
                        sum <- sum + x
                  ]

    ^ sum
]
