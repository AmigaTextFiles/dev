"---------------------------------------------------------------"
"  Block Class.

   Note how whileTrue: and whileFalse: depend upon the parser
   optimizing the loops into control flow, rather than message
   passing.  If this were not the case, whileTrue: would have to
   be implemented using recursion, as follows:

   whileTrue: aBlock
      (self value)
         ifFalse: [^nil].

      aBlock value.

      ^ self whileTrue: aBlock
"
"---------------------------------------------------------------"

Class Block :Object
[
   numArgs
      ^ <primitive 144 0 self> " (unused primitive 144) Added on 18-Nov-2002 (JTS) "
|      
   newProcess
      <primitive 144 1 self 0>.
      
      ^ <primitive 141 self>
|
   newProcessWith: argumentArray
      <primitive 144 1 self (argumentArray size)>.

      ^ <primitive 141 self argumentArray>
|
   fork
      self newProcess resume.

      ^ nil
|
   forkWith: argumentArray
      (self newProcessWith: argumentArray) resume.

      ^ nil
|
   whileTrue
      ^ [self value ] whileTrue: []
|
   whileTrue: aBlock
      ^ [ self value ] whileTrue: [ aBlock value ]
|
   whileFalse
      ^ [ self value ] whileFalse: []
|
   whileFalse: aBlock
      ^ [ self value ] whileFalse: [ aBlock value ]
|
   value

      <primitive 140  0>
|
   value: a

      <primitive 140  1>
|
   value: a value: b

      <primitive 140  2>
|
   value: a value: b value: c

      <primitive 140  3>
|
   value: a value: b value: c value: d

      <primitive 140  4>
|
   value: a value: b value: c value: d value: e

      <primitive 140  5>
]
