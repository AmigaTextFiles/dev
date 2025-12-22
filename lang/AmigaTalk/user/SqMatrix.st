" -------------------------------------------------------------- "
" SqMatrix.st - Implementation of Square Matrices for AmigaTalk. "
" -------------------------------------------------------------- "

Class SqMatrix :Magnitude ! size ele !
[
  new: newSize
    (newSize < 2)
       ifTrue: [ ('size of SqMatrix too small!') print. 
                 ^ nil
               ].
       
    size <- newSize. 
    ele  <- Array new: (size * size).

    (1 to: (size * size)) do: [:i | ele at: i put: (Float new: 0.0)].

    ^ self
|
  scale: s
    (1 to: (size * size)) do: [:i | ele at: i put: (s * (ele at: i))].
    ^ self 
|
  getElementAt: rcPoint ! idx !
    ((rcPoint x) < 1 | (rcPoint y) < 1)
      ifTrue:  [ ('Row@Column below minimum(1) in SqMatrix.') print.
                 ^ nil
               ].
      
    idx <- (size * ((rcPoint x) - 1) + rcPoint y).

    ^ ele at: idx
|
  setElement: val at: rcPoint ! idx !
    ((rcPoint x) < 1 | (rcPoint y) < 1)
      ifTrue:  [ ('Row@Column below minimum(1) in SqMatrix.') print.
                 ^ nil
               ].

    ((rcPoint x) > size | (rcPoint y) > size)
      ifTrue:  [ ('Row@Column > size in SqMatrix.') print.
                 ^ nil
               ].

    idx <- (size * ((rcPoint x) - 1) + rcPoint y).
    ele at: idx put: val.
    ^ self
]
