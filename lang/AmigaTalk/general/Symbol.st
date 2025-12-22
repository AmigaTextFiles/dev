Class Symbol :Object
[
   == aSymbol
      ^ <primitive 6 self aSymbol >
         ifTrue:  [<primitive 91 self aSymbol >]
         ifFalse: [false]
|
   printString
      ^ <primitive 92 self>
|
   asString
      ^ <primitive 93 self>
|
   numArgs
      ^ <primitive 90 0 self> " Added on 28-Mar-2002 "
]
