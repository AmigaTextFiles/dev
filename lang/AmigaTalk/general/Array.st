Class Array :ArrayedCollection
[
   new

      " Create a default Array with only one element! "

      ^ <primitive 114 1>.
|
   at: aNumber

      ^ <primitive 111 self aNumber>
|
   at: aNumber put: aValue

      ^ <primitive 112 self aNumber aValue>.
|
   grow: newObject

      ^ <primitive 113 self newObject>
|
   printString ! value aSize ele !

      amigatalk tracingOff.
      
      value <- ')'.

      aSize <- <primitive 4 self>.
      
      [aSize > 0] 
         whileTrue: [ ele <- <primitive 111 self aSize>.

                      (ele isKindOf: Integer) 
                         ifTrue:  [ value <- ele asHex,       ' ', value. ]
                         ifFalse: [ value <- ele printString, ' ', value. ].

                      aSize <- aSize - 1 ].

      amigatalk tracingOn.
      
      ^ '#(' , value
|
   size

      ^ <primitive 4 self>
|
   new: numElements

      ^ <primitive 114 numElements>
]
